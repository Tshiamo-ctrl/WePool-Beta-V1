from django.utils import timezone

def verification_banner(request):
    if not request.user.is_authenticated:
        return {}
    profile = getattr(request.user, 'profile', None)
    if not profile or profile.verified_email:
        return {}
    created = getattr(profile, 'created_at', None)
    if not created:
        return {}
    elapsed = timezone.now() - created
    total_hours = 72
    hours_used = int(elapsed.total_seconds() // 3600)
    hours_left = max(total_hours - hours_used, 0)
    show = hours_left > 0
    return {
        'show_email_verification_banner': show,
        'email_verification_hours_left': hours_left,
    }