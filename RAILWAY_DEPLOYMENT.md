# WePool Railway Deployment Guide

This guide will help you deploy the WePool application to Railway.com, a modern platform for deploying web applications.

## Prerequisites

1. **Railway Account**: Sign up at [railway.app](https://railway.app)
2. **Railway CLI**: Install the Railway CLI tool
3. **Git Repository**: Your WePool project should be in a Git repository
4. **PostgreSQL Database**: Railway provides PostgreSQL databases

## Quick Start

### 1. Install Railway CLI

```bash
# Using npm
npm install -g @railway/cli

# Or using yarn
yarn global add @railway/cli
```

### 2. Login to Railway

```bash
railway login
```

### 3. Initialize Railway Project

```bash
# Navigate to your project directory
cd /path/to/wepool

# Initialize Railway project
railway init

# This will create a railway.json file and link your project
```

### 4. Set Up Environment Variables

In your Railway dashboard, set the following environment variables:

#### Required Variables
```bash
SECRET_KEY=your-super-secret-key-here
DEBUG=False
DJANGO_SETTINGS_MODULE=wepool_project.settings_railway
ALLOWED_HOSTS=.railway.app,your-app-name.railway.app
```

#### Database Variables (Railway PostgreSQL)
```bash
DB_ENGINE=django.db.backends.postgresql
DB_NAME=railway
DB_USER=postgres
DB_PASSWORD=your-db-password
DB_HOST=your-db-host.railway.app
DB_PORT=5432
```

#### Email Configuration
```bash
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=your-app-password
DEFAULT_FROM_EMAIL=noreply@wepooltribe.com
```

#### Security Variables
```bash
CSRF_TRUSTED_ORIGINS=https://your-app-name.railway.app
SECURE_SSL_REDIRECT=True
SESSION_COOKIE_SECURE=True
CSRF_COOKIE_SECURE=True
```

### 5. Deploy

```bash
# Deploy to Railway
railway up

# Or use the deployment script
./deploy-railway.sh
```

## Railway Configuration

### railway.json
The project includes a `railway.json` file that configures:
- Docker build process
- Deployment settings
- Restart policies

### Dockerfile
The Dockerfile is optimized for Railway:
- Uses Python 3.10 slim image
- Installs PostgreSQL client and build tools
- Sets up non-root user for security
- Configures Gunicorn for production

### Django Settings
Railway-specific settings are in `wepool_project/settings_railway.py`:
- Optimized for Railway environment
- PostgreSQL database configuration
- Security settings for production
- WhiteNoise for static file serving

## Database Setup

### 1. Create PostgreSQL Database
In Railway dashboard:
1. Go to your project
2. Click "New Service" → "Database" → "PostgreSQL"
3. Note the connection details

### 2. Run Migrations
```bash
# Run migrations in Railway environment
railway run python manage.py migrate

# Create superuser
railway run python manage.py createsuperuser
```

### 3. Load Initial Data (if needed)
```bash
railway run python manage.py loaddata initial_data.json
```

## Static Files

Static files are automatically collected and served using WhiteNoise:
```bash
# Collect static files (done automatically during build)
python manage.py collectstatic --noinput
```

## Monitoring and Maintenance

### View Logs
```bash
railway logs
```

### Check Status
```bash
railway status
```

### Run Commands
```bash
# Run Django management commands
railway run python manage.py shell
railway run python manage.py check --deploy
```

### Open Application
```bash
railway open
```

## Environment-Specific Configurations

### Development
- Use `wepool_project/settings.py`
- SQLite database
- Debug mode enabled

### Production (Railway)
- Use `wepool_project/settings_railway.py`
- PostgreSQL database
- Debug mode disabled
- Security features enabled

## Troubleshooting

### Common Issues

1. **Database Connection Failed**
   - Check database environment variables
   - Verify PostgreSQL service is running
   - Check SSL requirements

2. **Static Files Not Loading**
   - Ensure `collectstatic` was run
   - Check WhiteNoise configuration
   - Verify static file paths

3. **Migration Errors**
   - Check database permissions
   - Verify database exists
   - Run migrations manually if needed

4. **Environment Variables**
   - Verify all required variables are set
   - Check variable names and values
   - Restart deployment after changes

### Debug Commands
```bash
# Check Django configuration
railway run python manage.py check --deploy

# Check database connection
railway run python manage.py dbshell

# View environment variables
railway run env | grep -E "(DB_|EMAIL_|SECRET_)"
```

## Security Considerations

- All sensitive data is stored in environment variables
- HTTPS is enforced in production
- CSRF protection is enabled
- Secure session cookies
- HSTS headers are set
- XSS protection is enabled

## Performance Optimization

- WhiteNoise for static file serving
- Database connection pooling
- Gunicorn with multiple workers
- Compressed static files
- Efficient logging configuration

## Support

For Railway-specific issues:
- [Railway Documentation](https://docs.railway.app)
- [Railway Discord](https://discord.gg/railway)
- [Railway GitHub](https://github.com/railwayapp)

For WePool application issues:
- Check the main README.md
- Review Django logs
- Check Railway deployment logs

## Deployment Checklist

- [ ] Railway CLI installed and logged in
- [ ] Environment variables configured
- [ ] PostgreSQL database created
- [ ] Django settings configured for Railway
- [ ] Static files collected
- [ ] Database migrations applied
- [ ] Superuser created
- [ ] Application deployed successfully
- [ ] Health check endpoint working
- [ ] Static files loading correctly
- [ ] Database operations working
- [ ] Email configuration tested