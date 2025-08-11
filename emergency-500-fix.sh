#!/bin/bash

# Emergency 500 Error Fix Script for Railway
# This script helps quickly resolve the 500 server error

set -e

echo "🚨 Emergency 500 Error Fix for Railway"
echo "======================================"

echo ""
echo "🔍 Step 1: Check Railway Logs"
echo "Go to Railway dashboard → Your service → Logs"
echo "Look for Django error messages"
echo ""

echo "🔧 Step 2: Quick Fix - Use Development Settings"
echo "In Railway dashboard, set these environment variables:"
echo ""
echo "DJANGO_SETTINGS_MODULE=wepool_project.settings"
echo "DEBUG=True"
echo "ALLOWED_HOSTS=*"
echo ""

echo "🔧 Step 3: Check Critical Variables"
echo "Ensure these are set in Railway:"
echo ""
echo "SECRET_KEY=your-secure-secret-key-here"
echo ""

echo "🔧 Step 4: Database Check"
echo "If using PostgreSQL, verify these are set:"
echo ""
echo "DB_ENGINE=django.db.backends.postgresql"
echo "DB_NAME=railway"
echo "DB_USER=postgres"
echo "DB_PASSWORD=your-actual-db-password"
echo "DB_HOST=your-actual-db-host.railway.app"
echo "DB_PORT=5432"
echo ""

echo "📋 Step 5: Force Redeploy"
echo "After setting variables:"
echo "1. Save environment variables"
echo "2. Trigger new deployment"
echo "3. Wait for deployment to complete"
echo "4. Check logs for success"
echo ""

echo "🚨 Most Common Issues:"
echo "1. Missing SECRET_KEY"
echo "2. Database connection failed"
echo "3. Wrong DJANGO_SETTINGS_MODULE"
echo "4. Missing environment variables"
echo ""

echo "🔍 Debug Commands (if you have Railway CLI):"
echo "railway logs                    # View error logs"
echo "railway run python manage.py check --deploy  # Test Django config"
echo "railway run python manage.py dbshell         # Test database"
echo ""

echo "✅ Expected Results After Fix:"
echo "- No more 500 errors"
echo "- Landing page loads correctly"
echo "- All UI improvements visible"
echo "- Water animations working"
echo ""

echo "📞 If Still Not Working:"
echo "1. Share Railway logs output"
echo "2. List environment variables you've set"
echo "3. Check if database service is running"
echo ""

echo "🚀 The development settings should definitely work!"
echo "Then we can gradually fix Railway-specific issues."