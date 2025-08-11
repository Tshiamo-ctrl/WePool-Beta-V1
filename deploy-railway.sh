#!/bin/bash

# WePool Railway Deployment Script
# This script helps deploy the WePool application to Railway

set -e

echo "🚂 WePool Railway Deployment Script"
echo "=================================="

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI is not installed. Please install it first:"
    echo "   npm install -g @railway/cli"
    echo "   or visit: https://railway.app/cli"
    exit 1
fi

# Check if user is logged in to Railway
if ! railway whoami &> /dev/null; then
    echo "❌ Not logged in to Railway. Please login first:"
    echo "   railway login"
    exit 1
fi

echo "✅ Railway CLI is ready"

# Check if we're in a Railway project
if [ ! -f "railway.json" ]; then
    echo "❌ railway.json not found. Please run this script from the project root."
    exit 1
fi

echo "📁 Project configuration found"

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "⚠️  .env file not found. Creating from template..."
    if [ -f "railway.env.template" ]; then
        cp railway.env.template .env
        echo "✅ .env file created from template"
        echo "⚠️  Please update .env with your actual values before deploying"
    else
        echo "❌ railway.env.template not found"
        exit 1
    fi
fi

# Check Django settings
echo "🔍 Checking Django configuration..."
if python manage.py check --deploy; then
    echo "✅ Django configuration is valid"
else
    echo "❌ Django configuration has issues. Please fix them before deploying."
    exit 1
fi

# Collect static files
echo "📦 Collecting static files..."
python manage.py collectstatic --noinput
echo "✅ Static files collected"

# Check if database migrations are needed
echo "🗄️  Checking database migrations..."
if python manage.py showmigrations --list | grep -q "\[ \]"; then
    echo "⚠️  There are unapplied migrations. Please run migrations before deploying."
    echo "   python manage.py migrate"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo "✅ All migrations are applied"
fi

# Deploy to Railway
echo "🚀 Deploying to Railway..."
echo "⚠️  Make sure you have set up your environment variables in Railway dashboard"
echo "⚠️  Required variables: SECRET_KEY, DB_*, EMAIL_*, etc."

read -p "Ready to deploy? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Deployment cancelled"
    exit 1
fi

# Deploy
echo "🚂 Deploying to Railway..."
railway up

echo "✅ Deployment completed!"
echo ""
echo "📋 Next steps:"
echo "1. Check your Railway dashboard for deployment status"
echo "2. Verify your environment variables are set correctly"
echo "3. Test your application at the provided Railway URL"
echo "4. Run database migrations if needed: railway run python manage.py migrate"
echo "5. Create a superuser if needed: railway run python manage.py createsuperuser"
echo ""
echo "🔗 Useful Railway commands:"
echo "   railway status          - Check deployment status"
echo "   railway logs            - View application logs"
echo "   railway run             - Run commands in Railway environment"
echo "   railway open            - Open your application in browser"