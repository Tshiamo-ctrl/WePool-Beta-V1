# Debug Railway 500 Server Error

## 🚨 Current Status
- ✅ Docker build succeeded (no more permission errors)
- ❌ Application starts but returns 500 Server Error
- 🔍 Need to identify runtime configuration issues

## 🔍 **IMMEDIATE DEBUGGING STEPS**

### **Step 1: Check Railway Logs**
```bash
# If you have Railway CLI
railway logs --tail 50

# Or check logs in Railway dashboard
# Look for Django error messages
```

### **Step 2: Check Environment Variables**
In Railway dashboard, verify these are set:
```bash
# Critical Django Variables
SECRET_KEY=your-secure-secret-key-here
DEBUG=False
DJANGO_SETTINGS_MODULE=wepool_project.settings_railway
ALLOWED_HOSTS=.railway.app,your-app-name.railway.app

# Database Variables (if using PostgreSQL)
DB_ENGINE=django.db.backends.postgresql
DB_NAME=railway
DB_USER=postgres
DB_PASSWORD=your-actual-db-password
DB_HOST=your-actual-db-host.railway.app
DB_PORT=5432
```

### **Step 3: Test Django Configuration**
```bash
# Check Django settings
railway run python manage.py check --deploy

# Check if migrations are needed
railway run python manage.py showmigrations

# Test database connection
railway run python manage.py dbshell
```

## 🚀 **QUICK FIXES TO TRY**

### **Fix 1: Use Development Settings Temporarily**
Set this environment variable to bypass Railway settings:
```bash
DJANGO_SETTINGS_MODULE=wepool_project.settings
DEBUG=True
```

### **Fix 2: Check Database Service**
1. Go to Railway dashboard
2. Verify PostgreSQL service is running
3. Check database connection details
4. Ensure database is accessible

### **Fix 3: Use SQLite Fallback**
The Railway settings have SQLite fallback, but verify it's working.

## 🔍 **COMMON 500 ERROR CAUSES**

### **1. Missing SECRET_KEY**
- Django requires SECRET_KEY to run
- Check if it's set in Railway environment variables

### **2. Database Connection Failed**
- PostgreSQL service not running
- Wrong connection details
- Network connectivity issues

### **3. Django Settings Import Error**
- `wepool_project.settings_railway` not found
- Import errors in settings file

### **4. Missing Dependencies**
- Some packages not installed
- Version conflicts

### **5. Static Files Issues**
- Static files not collected
- WhiteNoise configuration problems

## 📋 **DEBUGGING COMMANDS**

### **Check Django Configuration**
```bash
railway run python manage.py check --deploy
```

### **Check Static Files**
```bash
railway run python manage.py collectstatic --noinput
```

### **Check Migrations**
```bash
railway run python manage.py showmigrations
```

### **Check Environment Variables**
```bash
railway run env | grep -E "(DB_|SECRET_|DJANGO_)"
```

### **Check Python Path**
```bash
railway run python -c "import sys; print(sys.path)"
```

## 🚨 **MOST LIKELY ISSUES**

### **1. Missing SECRET_KEY**
```bash
# Check if SECRET_KEY is set
railway run python -c "import os; print('SECRET_KEY:', os.environ.get('SECRET_KEY', 'NOT SET'))"
```

### **2. Database Connection**
```bash
# Test database connection
railway run python manage.py dbshell
```

### **3. Settings Import**
```bash
# Test settings import
railway run python -c "import django; django.setup(); print('Settings loaded successfully')"
```

## ✅ **STEP-BY-STEP RESOLUTION**

### **Phase 1: Basic Setup**
1. Set `DEBUG=True` temporarily
2. Set `DJANGO_SETTINGS_MODULE=wepool_project.settings`
3. Deploy and check logs

### **Phase 2: Database Setup**
1. Verify PostgreSQL service is running
2. Check all database environment variables
3. Test database connection

### **Phase 3: Railway Settings**
1. Once basic setup works, switch to Railway settings
2. Set `DJANGO_SETTINGS_MODULE=wepool_project.settings_railway`
3. Gradually enable security features

## 🔍 **WHAT TO LOOK FOR IN LOGS**

### **Common Error Messages:**
- `ModuleNotFoundError`: Missing package or import issue
- `OperationalError`: Database connection problem
- `ImproperlyConfigured`: Django settings issue
- `ImportError`: Python import problem
- `KeyError`: Missing environment variable

### **Log Location:**
- Railway dashboard → Your service → Logs
- Or use `railway logs` command

## 🚀 **EMERGENCY FALLBACK**

If nothing works, temporarily use development settings:
```bash
DJANGO_SETTINGS_MODULE=wepool_project.settings
DEBUG=True
ALLOWED_HOSTS=*
```

This will at least get your app running, then we can debug the Railway-specific issues.

## 📞 **NEXT STEPS**

1. **Check Railway logs** for specific error messages
2. **Verify environment variables** are set correctly
3. **Test database connection**
4. **Try development settings** as a fallback
5. **Share error logs** for specific debugging

## 🔧 **IMMEDIATE ACTIONS**

1. **Go to Railway dashboard**
2. **Check the logs** for Django error messages
3. **Verify environment variables** are set
4. **Try the quick fixes** above
5. **Share the specific error** from logs

---

**Remember**: 500 errors are usually configuration issues, not code problems. The fix is usually in the environment variables or service configuration. Check the logs first to see the specific error message!