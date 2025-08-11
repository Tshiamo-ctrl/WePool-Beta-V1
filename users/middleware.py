from django.shortcuts import redirect
from django.urls import reverse

class ReferrerPromptMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)
        return response

    def process_view(self, request, view_func, view_args, view_kwargs):
        if request.user.is_authenticated:
            # Skip on specific views to avoid loops
            exempt_names = {
                'update_profile', 'logout', 'login', 'terms', 'about', 'contact',
                'railway_health_check', 'health_check'
            }
            try:
                if request.resolver_match and request.resolver_match.url_name in exempt_names:
                    return None
            except Exception:
                pass

            profile = getattr(request.user, 'profile', None)
            if profile and not profile.referrer_phone:
                # Redirect to profile update with a flag to show persistent prompt
                return redirect(f"{reverse('update_profile')}?need_referrer=1")
        return None