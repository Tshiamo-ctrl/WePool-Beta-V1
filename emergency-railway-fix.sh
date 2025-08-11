#!/bin/bash

# Emergency Railway Fix Script
# This script helps quickly resolve common Railway deployment issues

set -e

echo "🚨 Emergency Railway Fix Script"
echo "==============================="

echo ""
echo "🔧 Quick Fix 1: Use Development Settings"
echo "Set these environment variables in Railway dashboard:"
echo ""
echo "DJANGO_SETTINGS_MODULE=wepool_project.settings"
echo "DEBUG=True"
echo "ALLOWED_HOSTS=*"
echo ""

echo "🔧 Quick Fix 2: Check Critical Variables"
echo "Ensure these are set in Railway:"
echo ""
echo "SECRET_KEY=your-secure-secret-key-here"
echo "DJANGO_SETTINGS_MODULE=wepool_project.settings_railway"
echo ""

echo "🔧 Quick Fix 3: Database Fallback"
echo "If PostgreSQL fails, the app will fallback to SQLite"
echo ""

echo "📋 Immediate Actions:"
echo "1. Go to Railway dashboard"
echo "2. Navigate to your service"
echo "3. Go to Variables tab"
echo "4. Set the variables above"
echo "5. Wait for redeployment"
echo ""

echo "🔍 Debug Commands (if you have Railway CLI):"
echo "railway logs                    # View error logs"
echo "railway status                  # Check service status"
echo "railway run python manage.py check --deploy  # Test Django config"
echo ""

echo "🚨 If Still Getting 500 Error:"
echo "1. Check Railway logs for specific error message"
echo "2. Verify all environment variables are set"
echo "3. Try development settings first"
echo "4. Check if database service is running"
echo ""

echo "📞 Share This Information:"
echo "- Railway logs output"
echo "- Environment variables you've set"
echo "- Specific error messages"
echo ""

echo "✅ The app should work with development settings"
echo "Then we can gradually fix Railway-specific issues"