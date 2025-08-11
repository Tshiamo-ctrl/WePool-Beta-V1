# WePool Deployment Guide

This guide covers the complete deployment process for the WePool Django application using Docker containers.

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- At least 2GB RAM available
- Ports 80, 443, 8000, and 5432 available

### Production Deployment
```bash
# 1. Configure environment
cp .env.production.template .env.production
# Edit .env.production with your actual values

# 2. Deploy
./deploy.sh
```

### Development Deployment
```bash
# 1. Deploy development environment
./deploy-dev.sh

# 2. Access application
# http://localhost:8000
# Admin: admin/admin123
```

## 📁 Project Structure

```
WePool/
├── Dockerfile                 # Main container configuration
├── docker-compose.yml        # Production orchestration
├── docker-compose.dev.yml    # Development orchestration
├── requirements.txt          # Python dependencies
├── .env.production.template  # Production env template
├── .env.development         # Development environment
├── deploy.sh                 # Production deployment script
├── deploy-dev.sh            # Development deployment script
├── nginx/                   # Nginx configuration
│   ├── nginx.conf          # Main nginx config
│   └── default.conf        # Site configuration
└── wepool_project/         # Django project
    ├── settings.py         # Development settings
    └── settings_prod.py    # Production settings
```

## 🔧 Configuration

### Environment Variables

#### Production (.env.production)
```bash
# Django Settings
DEBUG=False
DJANGO_SETTINGS_MODULE=wepool_project.settings_prod
SECRET_KEY=your-super-secret-key-here

# Database
DB_ENGINE=django.db.backends.postgresql
DB_NAME=wepool_db
DB_USER=wepool_user
DB_PASSWORD=your-secure-password
DB_HOST=db
DB_PORT=5432

# Email
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=your-app-password
DEFAULT_FROM_EMAIL=noreply@wepooltribe.com

# Security
ALLOWED_HOSTS=your-domain.com,www.your-domain.com
CSRF_TRUSTED_ORIGINS=https://your-domain.com,https://www.your-domain.com
```

#### Development (.env.development)
```bash
DEBUG=True
DJANGO_SETTINGS_MODULE=wepool_project.settings
SECRET_KEY=django-insecure-development-key
# ... other development defaults
```

## 🐳 Docker Services

### Web Application
- **Image**: Custom Python 3.10 with Django
- **Port**: 8000 (internal), 80/443 (external via nginx)
- **Health Check**: `/health/` endpoint
- **Process Manager**: Gunicorn with 3 workers

### Database
- **Image**: PostgreSQL 15
- **Port**: 5432 (internal)
- **Volume**: Persistent data storage
- **Health Check**: Database connectivity

### Nginx
- **Image**: Nginx Alpine
- **Ports**: 80 (HTTP), 443 (HTTPS)
- **Features**: SSL termination, static file serving, rate limiting
- **SSL**: Self-signed certificates (replace with real ones in production)

## 🔒 Security Features

- HTTPS enforcement with HSTS
- Security headers (X-Frame-Options, X-Content-Type-Options, etc.)
- Rate limiting on API and login endpoints
- CSRF protection
- Secure session cookies
- Non-root container user

## 📊 Monitoring & Health Checks

### Health Endpoint
- **URL**: `/health/`
- **Response**: JSON with status and database connectivity
- **Use**: Container health monitoring, load balancer checks

### Logging
- **Application**: `/var/log/wepool/django.log`
- **Nginx**: Standard nginx logs
- **Container**: `docker-compose logs -f`

## 🚀 Deployment Commands

### Production
```bash
# Full deployment
./deploy.sh

# Manual deployment
docker-compose up --build -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Restart services
docker-compose restart
```

### Development
```bash
# Development deployment
./deploy-dev.sh

# Manual development deployment
docker-compose -f docker-compose.dev.yml up --build -d

# Access Django shell
docker-compose -f docker-compose.dev.yml exec web python manage.py shell

# Run migrations
docker-compose -f docker-compose.dev.yml exec web python manage.py migrate
```

## 🔧 Maintenance

### Database Migrations
```bash
# Production
docker-compose exec web python manage.py migrate

# Development
docker-compose -f docker-compose.dev.yml exec web python manage.py migrate
```

### Static Files
```bash
# Production
docker-compose exec web python manage.py collectstatic --noinput

# Development
docker-compose -f docker-compose.dev.yml exec web python manage.py collectstatic --noinput
```

### Backup Database
```bash
# Production
docker-compose exec db pg_dump -U wepool_user wepool_db > backup.sql

# Development
docker-compose -f docker-compose.dev.yml exec db pg_dump -U wepool_user wepool_dev > backup.sql
```

## 🚨 Troubleshooting

### Common Issues

#### Application Won't Start
```bash
# Check logs
docker-compose logs web

# Check health endpoint
curl http://localhost/health/

# Verify environment variables
docker-compose exec web env | grep DJANGO
```

#### Database Connection Issues
```bash
# Check database logs
docker-compose logs db

# Test database connectivity
docker-compose exec web python manage.py dbshell

# Verify database environment
docker-compose exec db env | grep POSTGRES
```

#### Nginx Issues
```bash
# Check nginx logs
docker-compose logs nginx

# Verify SSL certificates
ls -la nginx/ssl/

# Test nginx configuration
docker-compose exec nginx nginx -t
```

### Performance Tuning

#### Gunicorn Workers
```bash
# Adjust in Dockerfile CMD
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "--timeout", "120", "wepool_project.wsgi:application"]
```

#### Database Connections
```bash
# Adjust in settings_prod.py
DATABASES = {
    'default': {
        # ... existing config
        'CONN_MAX_AGE': 600,  # 10 minutes
        'OPTIONS': {
            'sslmode': 'require',
            'max_connections': 100,
        },
    }
}
```

## 🔄 Updates & Upgrades

### Application Updates
```bash
# 1. Pull latest code
git pull origin main

# 2. Rebuild and restart
./deploy.sh
```

### Dependency Updates
```bash
# 1. Update requirements.txt
# 2. Rebuild containers
docker-compose build --no-cache
docker-compose up -d
```

### Database Schema Changes
```bash
# 1. Create migration
docker-compose exec web python manage.py makemigrations

# 2. Apply migration
docker-compose exec web python manage.py migrate
```

## 📚 Additional Resources

- [Django Deployment Checklist](https://docs.djangoproject.com/en/4.2/howto/deployment/checklist/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Nginx Configuration](https://nginx.org/en/docs/)
- [PostgreSQL Tuning](https://www.postgresql.org/docs/current/runtime-config.html)

## 🆘 Support

For deployment issues:
1. Check the logs: `docker-compose logs -f`
2. Verify environment configuration
3. Check health endpoint: `/health/`
4. Review this documentation
5. Check Django deployment checklist