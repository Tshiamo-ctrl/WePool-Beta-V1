# core/urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('referral-matrix/', views.referral_matrix_view, name='referral_matrix'),
    path('api/referral-data/', views.get_referral_data, name='get_referral_data'),
    path('direct-referrals/', views.direct_referrals_view, name='direct_referrals'),
    path('health/', views.health_check, name='health_check'),
    path('railway-health/', views.railway_health_check, name='railway_health_check'),
    path('about/', views.about_page, name='about'),
    path('contact/', views.contact_page, name='contact'),
    path('terms/', views.terms_page, name='terms'),
]
