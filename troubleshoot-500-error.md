# Troubleshooting Railway 500 Server Error

## 🚨 Current Issue
You're getting a **Server Error (500)** on your Railway deployment after fixing the redirect loop.

## 🔍 Common Causes of 500 Errors

### 1. **Missing Environment Variables**
The most common cause is missing or incorrect environment variables.

### 2. **Database Connection Issues**
PostgreSQL service might not be running or configured incorrectly.

### 3. **Missing Dependencies**
Some packages might not be installed properly.

### 4. **Django Settings Issues**
Configuration problems in the Railway settings.

## 🚀 Immediate Troubleshooting Steps

### Step 1: Check Railway Logs
```bash
# If you have Railway CLI
railway logs

# Or check logs in Railway dashboard
```

### Step 2: Verify Environment Variables
In your Railway dashboard, ensure these are set:

```bash
# Required Django Variables
SECRET_KEY=your-secure-secret-key-here
DEBUG=False
DJANGO_SETTINGS_MODULE=wepool_project.settings_railway
ALLOWED_HOSTS=.railway.app,wepool2.up.railway.app

# Database Variables (Critical!)
DB_ENGINE=django.db.backends.postgresql
DB_NAME=railway
DB_USER=postgres
DB_PASSWORD=your-actual-db-password
DB_HOST=your-actual-db-host.railway.app
DB_PORT=5432

# Security Variables
CSRF_TRUSTED_ORIGINS=https://wepool2.up.railway.app
SECURE_SSL_REDIRECT=False
SESSION_COOKIE_SECURE=False
CSRF_COOKIE_SECURE=False

# Railway Variables
RAILWAY_ENVIRONMENT=production
```

### Step 3: Check Database Service
1. Go to Railway dashboard
2. Verify PostgreSQL service is running
3. Check database connection details
4. Ensure database is accessible

### Step 4: Test Database Connection
```bash
# If you have Railway CLI
railway run python manage.py dbshell

# Or check if migrations can run
railway run python manage.py showmigrations
```

## 🔧 Quick Fixes to Try

### Fix 1: Use Development Settings Temporarily
Set this environment variable to bypass Railway settings:
```bash
DJANGO_SETTINGS_MODULE=wepool_project.settings
DEBUG=True
```

### Fix 2: Check Database Connection
Ensure your database variables match exactly what Railway shows in the PostgreSQL service.

### Fix 3: Verify Requirements
Make sure all dependencies are installed:
```bash
railway run pip list
```

## 📋 Debugging Commands

### Check Django Configuration
```bash
railway run python manage.py check --deploy
```

### Check Static Files
```bash
railway run python manage.py collectstatic --noinput
```

### Check Migrations
```bash
railway run python manage.py showmigrations
```

### Check Environment Variables
```bash
railway run env | grep -E "(DB_|SECRET_|DJANGO_)"
```

## 🚨 Most Likely Issues

### 1. **Missing SECRET_KEY**
- Django requires a SECRET_KEY to run
- Generate a secure one if missing

### 2. **Database Connection Failed**
- PostgreSQL service not running
- Wrong connection details
- Network connectivity issues

### 3. **Missing Dependencies**
- Some packages not installed
- Version conflicts

### 4. **Settings Import Error**
- `wepool_project.settings_railway` not found
- Import errors in settings file

## ✅ Step-by-Step Resolution

### Phase 1: Basic Setup
1. Set `DEBUG=True` temporarily
2. Set `DJANGO_SETTINGS_MODULE=wepool_project.settings`
3. Deploy and check logs

### Phase 2: Database Setup
1. Verify PostgreSQL service is running
2. Check all database environment variables
3. Test database connection

### Phase 3: Railway Settings
1. Once basic setup works, switch to Railway settings
2. Set `DJANGO_SETTINGS_MODULE=wepool_project.settings_railway`
3. Gradually enable security features

## 🔍 What to Look For in Logs

### Common Error Messages:
- `ModuleNotFoundError`: Missing package or import issue
- `OperationalError`: Database connection problem
- `ImproperlyConfigured`: Django settings issue
- `ImportError`: Python import problem

### Log Location:
- Railway dashboard → Your service → Logs
- Or use `railway logs` command

## 🚀 Emergency Fallback

If nothing works, temporarily use development settings:
```bash
DJANGO_SETTINGS_MODULE=wepool_project.settings
DEBUG=True
ALLOWED_HOSTS=*
```

This will at least get your app running, then we can debug the Railway-specific issues.

## 📞 Next Steps

1. **Check Railway logs** for specific error messages
2. **Verify environment variables** are set correctly
3. **Test database connection** 
4. **Try development settings** as a fallback
5. **Share error logs** for specific debugging

---

**Remember**: 500 errors are usually configuration issues, not code problems. The fix is usually in the environment variables or service configuration.