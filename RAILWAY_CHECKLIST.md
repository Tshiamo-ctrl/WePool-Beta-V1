# Railway Deployment Checklist

Use this checklist to ensure your WePool application is ready for Railway deployment.

## Pre-Deployment Checklist

### ✅ Project Structure
- [ ] `manage.py` is in the root directory
- [ ] `railway.json` exists and is properly configured
- [ ] `wepool_project/settings_railway.py` exists
- [ ] All Django apps are properly configured
- [ ] Static and media file paths are correct

### ✅ Dependencies
- [ ] `requirements.txt` is up to date
- [ ] All required packages are listed
- [ ] `psycopg[binary]` is included for PostgreSQL
- [ ] `whitenoise` is included for static files
- [ ] `gunicorn` is included for production server

### ✅ Django Configuration
- [ ] `settings_railway.py` extends base settings correctly
- [ ] Database configuration uses environment variables
- [ ] Static files configuration is correct
- [ ] Security settings are enabled
- [ ] Logging configuration is container-friendly

### ✅ Environment Variables
- [ ] `.env` file exists (for local testing)
- [ ] `railway.env.template` is up to date
- [ ] All required variables are documented
- [ ] Sensitive data is not hardcoded

## Railway Setup Checklist

### ✅ Railway Account
- [ ] Railway account created
- [ ] Railway CLI installed
- [ ] Logged in to Railway CLI
- [ ] Project initialized on Railway

### ✅ Railway Project Configuration
- [ ] `railway.json` is properly configured
- [ ] Project is linked to Railway
- [ ] Service name is set correctly
- [ ] Build configuration is correct

### ✅ Database Setup
- [ ] PostgreSQL service created on Railway
- [ ] Database connection details noted
- [ ] Environment variables set for database
- [ ] Database is accessible

### ✅ Environment Variables on Railway
- [ ] `SECRET_KEY` is set and secure
- [ ] `DEBUG=False` for production
- [ ] `DJANGO_SETTINGS_MODULE=wepool_project.settings_railway`
- [ ] Database credentials are set
- [ ] Email configuration is set
- [ ] `ALLOWED_HOSTS` includes Railway domain
- [ ] `CSRF_TRUSTED_ORIGINS` includes Railway domain

## Deployment Checklist

### ✅ Pre-Deployment Tests
- [ ] Django configuration check passes
- [ ] Static files collect successfully
- [ ] Database migrations are ready
- [ ] Health check endpoints work locally

### ✅ Deployment Process
- [ ] Railway project is properly linked
- [ ] Environment variables are set
- [ ] Deployment script is executable
- [ ] Ready to run `railway up`

### ✅ Post-Deployment Verification
- [ ] Application deploys successfully
- [ ] Health check endpoint responds
- [ ] Static files are served correctly
- [ ] Database connection works
- [ ] Application is accessible via Railway URL

## Testing Checklist

### ✅ Local Testing
- [ ] Railway settings work locally
- [ ] Docker Compose with Railway settings works
- [ ] Health check endpoints respond correctly
- [ ] Static files are collected and served

### ✅ Railway Testing
- [ ] Application starts successfully
- [ ] Database migrations run
- [ ] Static files are accessible
- [ ] Health check endpoints work
- [ ] Application responds to requests

## Security Checklist

### ✅ Environment Security
- [ ] `.env` file is in `.gitignore`
- [ ] No sensitive data in code
- [ ] SECRET_KEY is properly generated
- [ ] Database credentials are secure

### ✅ Django Security
- [ ] `DEBUG=False` in production
- [ ] HTTPS redirect is enabled
- [ ] Secure cookies are enabled
- [ ] CSRF protection is working
- [ ] HSTS headers are set

### ✅ Railway Security
- [ ] Environment variables are encrypted
- [ ] Database access is restricted
- [ ] Service is properly isolated
- [ ] Health checks don't expose sensitive data

## Monitoring Checklist

### ✅ Health Monitoring
- [ ] Health check endpoints are working
- [ ] Railway health checks are configured
- [ ] Logs are accessible
- [ ] Error monitoring is set up

### ✅ Performance Monitoring
- [ ] Static files are optimized
- [ ] Database queries are efficient
- [ ] Gunicorn workers are properly configured
- [ ] Resource usage is monitored

## Troubleshooting Checklist

### ✅ Common Issues
- [ ] Database connection problems
- [ ] Static file serving issues
- [ ] Environment variable problems
- [ ] Migration errors
- [ ] Port binding issues
- [ ] If you hit a 500 due to a missing static manifest entry, temporarily set `DISABLE_MANIFEST=1` on Railway to serve unhashed files while you add the missing asset(s), then unset it.

### ✅ Debug Tools
- [ ] Railway logs are accessible
- [ ] Django debug commands work
- [ ] Health check provides useful information
- [ ] Error messages are clear

## Maintenance Checklist

### ✅ Regular Tasks
- [ ] Monitor application logs
- [ ] Check database performance
- [ ] Update dependencies
- [ ] Review security settings
- [ ] Backup database

### ✅ Updates
- [ ] Test updates locally first
- [ ] Deploy during low-traffic periods
- [ ] Monitor after updates
- [ ] Rollback plan is ready

## Final Verification

Before considering deployment complete:

- [ ] All checklist items are completed
- [ ] Application is fully functional on Railway
- [ ] All features work as expected
- [ ] Performance is acceptable
- [ ] Security measures are in place
- [ ] Monitoring is working
- [ ] Documentation is updated
- [ ] Team is trained on deployment process

---

**Note**: This checklist should be reviewed and updated regularly as your application evolves and Railway adds new features.