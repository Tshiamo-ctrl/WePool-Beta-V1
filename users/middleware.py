from django.shortcuts import redirect
from django.urls import reverse
from django.utils import timezone
import os

class ReferrerPromptMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)
        return response

    def process_view(self, request, view_func, view_args, view_kwargs):
        if request.user.is_authenticated:
            exempt_names = {
                'update_profile', 'logout', 'login', 'terms', 'about', 'contact',
                'railway_health_check', 'health_check', 'email_lock', 'verify_email',
                'password_reset', 'password_reset_done', 'password_reset_confirm', 'password_reset_complete',
                # Admin dashboard routes
                'admin_dashboard', 'view_all_users', 'edit_user', 'delete_user', 'toggle_admin', 'create_user',
                'paying_queue', 'sponsored_queue', 'yellow_members', 'qualified_sponsored', 'assign_members',
                'export_data', 'override_history', 'dashboard_stats', 'bulk_update_status', 'process_yellow_queue'
            }
            try:
                if request.resolver_match and request.resolver_match.url_name in exempt_names:
                    return None
            except Exception:
                pass

            # Hard lock after 72 hours if email not verified
            profile = getattr(request.user, 'profile', None)
            if profile and not profile.verified_email and profile.created_at:
                hours = (timezone.now() - profile.created_at).total_seconds() / 3600
                if hours >= 72:
                    return redirect(reverse('email_lock'))

            # Prompt for referrer phone (admins/superusers exempt)
            if profile and not profile.referrer_phone:
                if request.user.is_staff or request.user.is_superuser:
                    return None
                current_path = request.path or ''
                allow_paths = [
                    reverse('update_profile'),
                    reverse('user_dashboard'),
                ]
                if current_path not in allow_paths:
                    return redirect(f"{reverse('update_profile')}?need_referrer=1")
        return None