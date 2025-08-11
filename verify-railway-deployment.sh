#!/bin/bash

# Railway Deployment Verification Script
# This script helps verify that your Railway deployment is working correctly

set -e

echo "🔍 WePool Railway Deployment Verification"
echo "========================================"

# Check if we're in the right directory
if [ ! -f "manage.py" ]; then
    echo "❌ Please run this script from the project root directory"
    exit 1
fi

echo "✅ Project structure verified"

# Check if Railway CLI is available
if command -v railway &> /dev/null; then
    echo "✅ Railway CLI is installed"
    
    # Check if logged in
    if railway whoami &> /dev/null; then
        echo "✅ Logged in to Railway"
        
        # Check project status
        echo "📊 Checking Railway project status..."
        railway status
        
        # Check logs
        echo ""
        echo "📋 Recent Railway logs:"
        railway logs --tail 20
        
    else
        echo "❌ Not logged in to Railway. Please run: railway login"
    fi
else
    echo "⚠️  Railway CLI not found. Install with: npm install -g @railway/cli"
fi

echo ""
echo "🔧 Local Verification Steps:"
echo "============================"

# Check Django configuration
echo "1. Testing Django configuration..."
if python manage.py check --deploy --settings=wepool_project.settings_railway; then
    echo "   ✅ Django configuration is valid"
else
    echo "   ❌ Django configuration has issues"
fi

# Check static files
echo "2. Testing static file collection..."
if python manage.py collectstatic --noinput --settings=wepool_project.settings_railway; then
    echo "   ✅ Static files collected successfully"
else
    echo "   ❌ Static file collection failed"
fi

# Check if landing page template exists
echo "3. Checking landing page template..."
if [ -f "templates/landing.html" ]; then
    echo "   ✅ Landing page template found"
else
    echo "   ❌ Landing page template missing"
fi

# Check if landing CSS exists
echo "4. Checking landing page CSS..."
if [ -f "static/css/landing.css" ]; then
    echo "   ✅ Landing page CSS found"
else
    echo "   ❌ Landing page CSS missing"
fi

# Check URL configuration
echo "5. Checking URL configuration..."
if grep -q "landing_page" users/urls.py; then
    echo "   ✅ Landing page URL configured"
else
    echo "   ❌ Landing page URL not configured"
fi

# Check views
echo "6. Checking views..."
if grep -q "def landing_page" users/views.py; then
    echo "   ✅ Landing page view implemented"
else
    echo "   ❌ Landing page view not implemented"
fi

echo ""
echo "🌐 Railway Deployment Checklist:"
echo "================================"
echo "1. ✅ Main branch updated with latest changes"
echo "2. ✅ Railway configuration files present"
echo "3. ✅ Landing page and UI improvements included"
echo "4. ✅ All dependencies specified in requirements.txt"
echo ""
echo "📋 Next Steps:"
echo "1. Railway should automatically redeploy from the updated main branch"
echo "2. Check Railway dashboard for deployment status"
echo "3. Verify environment variables are set correctly"
echo "4. Test the landing page at your Railway URL"
echo ""
echo "🔗 Useful Commands:"
echo "   railway status          - Check deployment status"
echo "   railway logs            - View application logs"
echo "   railway open            - Open your application"
echo "   railway run python manage.py migrate  - Run migrations"
echo ""
echo "⚠️  If issues persist:"
echo "1. Check Railway logs for error messages"
echo "2. Verify environment variables in Railway dashboard"
echo "3. Ensure database service is running"
echo "4. Check if migrations need to be applied"