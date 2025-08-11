from django.shortcuts import render

# Create your views here.
# core/views.py
from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from django.views.decorators.http import require_http_methods
from django.db import connection
from users.models import Profile
from .models import Referral
from .utils import build_referral_matrix, get_referral_stats
from django.utils import timezone

@login_required
def referral_matrix_view(request):
    """Display detailed referral matrix for current user"""
    profile = request.user.profile
    matrix = build_referral_matrix(profile)
    stats = get_referral_stats(profile)

    return render(request, 'core/referral_matrix.html', {
        'matrix': matrix,
        'stats': stats,
        'profile': profile
    })

@login_required
@require_http_methods(["GET"])
def get_referral_data(request):
    """API endpoint to get referral data for charts/visualizations"""
    profile = request.user.profile
    matrix = build_referral_matrix(profile)

    # Format data for response
    data = {
        'level_1': len(matrix['level_1']),
        'level_2': len(matrix['level_2']),
        'level_3': len(matrix['level_3']),
        'level_4': len(matrix['level_4']),
        'total': sum(len(matrix[level]) for level in matrix)
    }

    return JsonResponse(data)

@login_required
def direct_referrals_view(request):
    """View to show only direct referrals with detailed info"""
    profile = request.user.profile
    referrals = Referral.objects.filter(
        referrer=profile
    ).select_related('referred__user').order_by('-created_at')

    return render(request, 'core/direct_referrals.html', {
        'referrals': referrals,
        'profile': profile
    })

def health_check(request):
    """Health check endpoint for container monitoring"""
    try:
        # Test database connection
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
            cursor.fetchone()
        
        # Get environment info
        import os
        env_info = {
            'environment': os.environ.get('RAILWAY_ENVIRONMENT', 'unknown'),
            'railway_service': os.environ.get('RAILWAY_SERVICE_NAME', 'unknown'),
            'railway_revision': os.environ.get('RAILWAY_REVISION', 'unknown'),
        }
        
        return JsonResponse({
            'status': 'healthy',
            'database': 'connected',
            'timestamp': timezone.now().isoformat(),
            'railway': env_info,
            'version': '1.0.0'
        }, status=200)
    except Exception as e:
        return JsonResponse({
            'status': 'unhealthy',
            'database': 'disconnected',
            'error': str(e),
            'timestamp': timezone.now().isoformat()
        }, status=503)

def railway_health_check(request):
    """Railway-specific health check endpoint"""
    try:
        # Test database connection
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
            cursor.fetchone()
        
        # Get Railway-specific environment info
        import os
        railway_info = {
            'environment': os.environ.get('RAILWAY_ENVIRONMENT', 'unknown'),
            'service_name': os.environ.get('RAILWAY_SERVICE_NAME', 'unknown'),
            'revision': os.environ.get('RAILWAY_REVISION', 'unknown'),
            'port': os.environ.get('PORT', '8000'),
            'deployment': os.environ.get('RAILWAY_DEPLOYMENT_ID', 'unknown'),
        }
        
        return JsonResponse({
            'status': 'healthy',
            'service': 'wepool',
            'database': 'connected',
            'timestamp': timezone.now().isoformat(),
            'railway': railway_info,
            'version': '1.0.0'
        }, status=200)
    except Exception as e:
        return JsonResponse({
            'status': 'unhealthy',
            'service': 'wepool',
            'database': 'disconnected',
            'error': str(e),
            'timestamp': timezone.now().isoformat()
        }, status=503)

def about_page(request):
    return render(request, 'core/about.html')

def contact_page(request):
    if request.method == 'POST':
        # In production, send email or store message
        name = request.POST.get('name')
        email = request.POST.get('email')
        subject = request.POST.get('subject')
        message = request.POST.get('message')
        # TODO: Integrate email backend or persistence
        return JsonResponse({'success': True})
    return render(request, 'core/contact.html')

def terms_page(request):
    return render(request, 'core/terms.html')
