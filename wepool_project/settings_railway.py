"""
Railway-specific Django settings for WePool
This file extends the base settings with Railway-optimized configurations
"""

from .settings import *
import os

# Load environment variables
from dotenv import load_dotenv
load_dotenv()

# Import base settings safely
try:
    from .settings import *
except ImportError as e:
    print(f"Warning: Could not import base settings: {e}")
    # Fallback to basic Django settings
    import os
    from pathlib import Path
    
    BASE_DIR = Path(__file__).resolve().parent.parent
    SECRET_KEY = os.environ.get('SECRET_KEY', 'django-insecure-fallback-key-for-railway')
    DEBUG = os.environ.get('DEBUG', 'False') == 'True'
    ALLOWED_HOSTS = ['*']
    
    INSTALLED_APPS = [
        'django.contrib.admin',
        'django.contrib.auth',
        'django.contrib.contenttypes',
        'django.contrib.sessions',
        'django.contrib.messages',
        'django.contrib.staticfiles',
        'crispy_forms',
        'crispy_bootstrap5',
        'import_export',
        'users',
        'dashboard',
        'core',
    ]
    
    MIDDLEWARE = [
        'django.middleware.security.SecurityMiddleware',
        'django.contrib.sessions.middleware.SessionMiddleware',
        'django.middleware.common.CommonMiddleware',
        'django.middleware.csrf.CsrfViewMiddleware',
        'django.contrib.auth.middleware.AuthenticationMiddleware',
        'django.contrib.messages.middleware.MessageMiddleware',
        'django.middleware.clickjacking.XFrameOptionsMiddleware',
    ]
    
    ROOT_URLCONF = 'wepool_project.urls'
    WSGI_APPLICATION = 'wepool_project.wsgi.application'
    
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.sqlite3',
            'NAME': BASE_DIR / 'db.sqlite3',
        }
    }
    
    STATIC_URL = '/static/'
    STATIC_ROOT = BASE_DIR / 'staticfiles'
    STATICFILES_DIRS = [BASE_DIR / 'static']
    
    MEDIA_URL = '/media/'
    MEDIA_ROOT = BASE_DIR / 'media'
    
    LANGUAGE_CODE = 'en-us'
    TIME_ZONE = 'UTC'
    USE_I18N = True
    USE_TZ = True
    
    DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'
    
    CRISPY_ALLOWED_TEMPLATE_PACKS = "bootstrap5"
    CRISPY_TEMPLATE_PACK = "bootstrap5"

# Railway-specific settings
DEBUG = os.environ.get('DEBUG', 'False') == 'True'
ALLOWED_HOSTS = os.environ.get('ALLOWED_HOSTS', '.railway.app,localhost,127.0.0.1').split(',')

# Security settings for Railway
# Disable SSL redirect to prevent loops - Railway handles HTTPS
SECURE_SSL_REDIRECT = False
SESSION_COOKIE_SECURE = False  # Will be True when HTTPS is confirmed
CSRF_COOKIE_SECURE = False     # Will be True when HTTPS is confirmed
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS = 'DENY'
SECURE_HSTS_SECONDS = 31536000
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True

# CSRF settings for Railway
CSRF_TRUSTED_ORIGINS = os.environ.get('CSRF_TRUSTED_ORIGINS', 'https://*.railway.app,http://localhost,http://127.0.0.1,https://localhost,https://127.0.0.1').split(',')

# Database - Prefer DATABASE_URL (Railway default), fallback to discrete vars, then SQLite
try:
    database_url = os.environ.get('DATABASE_URL')
    if database_url:
        import dj_database_url  # type: ignore
        DATABASES = {
            'default': dj_database_url.parse(database_url, conn_max_age=600, ssl_require=True)
        }
        print("Using PostgreSQL via DATABASE_URL")
    else:
        db_host = os.environ.get('DB_HOST')
        db_password = os.environ.get('DB_PASSWORD')
        if db_host and db_password:
            DATABASES = {
                'default': {
                    'ENGINE': os.environ.get('DB_ENGINE', 'django.db.backends.postgresql'),
                    'NAME': os.environ.get('DB_NAME', 'railway'),
                    'USER': os.environ.get('DB_USER', 'postgres'),
                    'PASSWORD': db_password,
                    'HOST': db_host,
                    'PORT': os.environ.get('DB_PORT', '5432'),
                    'CONN_MAX_AGE': 600,
                    'OPTIONS': {'sslmode': 'require'},
                }
            }
            print(f"Using PostgreSQL database: {db_host}")
        else:
            print("No DATABASE_URL or DB_* variables, using SQLite fallback")
            DATABASES = {
                'default': {
                    'ENGINE': 'django.db.backends.sqlite3',
                    'NAME': BASE_DIR / 'db.sqlite3',
                }
            }
except Exception as e:
    print(f"Database configuration error: {e}, using SQLite fallback")
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.sqlite3',
            'NAME': BASE_DIR / 'db.sqlite3',
        }
    }

# Email configuration for Railway
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = os.environ.get('EMAIL_HOST')
EMAIL_PORT = int(os.environ.get('EMAIL_PORT', '587'))
EMAIL_USE_TLS = True
EMAIL_HOST_USER = os.environ.get('EMAIL_HOST_USER')
EMAIL_HOST_PASSWORD = os.environ.get('EMAIL_HOST_PASSWORD')
DEFAULT_FROM_EMAIL = os.environ.get('DEFAULT_FROM_EMAIL', 'noreply@wepooltribe.com')

# Static files for Railway
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
# Allow emergency fallback to non-manifest storage to prevent 500s if a file is missing
if os.environ.get('DISABLE_MANIFEST', '0') == '1':
    STATICFILES_STORAGE = 'whitenoise.storage.CompressedStaticFilesStorage'
else:
    STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'

# Media files for Railway
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

# Add WhiteNoise for static file serving (Railway-optimized)
MIDDLEWARE.insert(1, 'whitenoise.middleware.WhiteNoiseMiddleware')

# Logging configuration for Railway
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': '{levelname} {asctime} {module} {process:d} {thread:d} {message}',
            'style': '{',
        },
        'simple': {
            'format': '{levelname} {message}',
            'style': '{',
        },
    },
    'handlers': {
        'console': {
            'level': 'INFO',
            'class': 'logging.StreamHandler',
            'formatter': 'verbose',
        },
    },
    'root': {
        'handlers': ['console'],
        'level': 'INFO',
    },
    'loggers': {
        'django': {
            'handlers': ['console'],
            'level': 'INFO',
            'propagate': False,
        },
        'django.db.backends': {
            'handlers': ['console'],
            'level': 'WARNING',
            'propagate': False,
        },
        'gunicorn': {
            'handlers': ['console'],
            'level': 'INFO',
            'propagate': False,
        },
    },
}

# Cache configuration for Railway (using database)
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.db.DatabaseCache',
        'LOCATION': 'cache_table',
    }
}

# Session configuration for Railway
SESSION_COOKIE_AGE = 3600  # 1 hour
SESSION_EXPIRE_AT_BROWSER_CLOSE = True
SESSION_SAVE_EVERY_REQUEST = True

# Security middleware for Railway
SECURE_REFERRER_POLICY = 'strict-origin-when-cross-origin'
SECURE_CROSS_ORIGIN_OPENER_POLICY = 'same-origin'

# Railway-specific optimizations
# Trust Railway's proxy headers
USE_X_FORWARDED_HOST = True
USE_X_FORWARDED_PORT = True

# Railway handles HTTPS at the proxy level, so we don't need to redirect
# SECURE_SSL_REDIRECT = False  # Disabled to prevent redirect loops
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')

# Set secure cookies only when we're sure we're on HTTPS
SECURE_SSL_REDIRECT = False  # Let Railway handle HTTPS
SESSION_COOKIE_SECURE = False  # Will be set to True when HTTPS is confirmed
CSRF_COOKIE_SECURE = False    # Will be set to True when HTTPS is confirmed