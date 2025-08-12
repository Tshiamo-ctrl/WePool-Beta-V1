from django.core.mail import EmailMultiAlternatives
from django.template.loader import render_to_string
from django.conf import settings


def send_verification_email(user, verification_url: str) -> None:
    subject = "Verify your WePool Tribe account"
    from_email = getattr(settings, "DEFAULT_FROM_EMAIL", "noreply@wepooltribe.com")
    to = [user.email]

    context = {
        "user": user,
        "verification_url": verification_url,
        "site_name": "WePool Tribe",
    }

    html_content = render_to_string("emails/verify_email.html", context)
    text_content = f"Welcome to WePool Tribe, {user.first_name}!\n\nPlease verify your email by clicking this link: {verification_url}\n\nIf you didn't register, you can ignore this email."

    try:
        msg = EmailMultiAlternatives(subject, text_content, from_email, to)
        msg.attach_alternative(html_content, "text/html")
        msg.send(fail_silently=True)
    except Exception:
        # Fallback/no-op to avoid blocking registration
        pass