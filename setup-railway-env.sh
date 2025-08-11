#!/bin/bash

# Railway Environment Setup Script for WePool
# This script helps configure the environment for Railway deployment

set -e

echo "🚂 WePool Railway Environment Setup"
echo "=================================="

# Check if we're in the right directory
if [ ! -f "manage.py" ]; then
    echo "❌ Please run this script from the project root directory"
    exit 1
fi

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    echo "📝 Creating .env file from template..."
    if [ -f "railway.env.template" ]; then
        cp railway.env.template .env
        echo "✅ .env file created from railway.env.template"
    else
        echo "❌ railway.env.template not found"
        exit 1
    fi
fi

# Generate a secure SECRET_KEY
echo "🔑 Generating secure SECRET_KEY..."
SECRET_KEY=$(python3 -c "import secrets; print(''.join(secrets.choice('abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)') for i in range(50)))")

# Update .env file with generated SECRET_KEY
if [ -f ".env" ]; then
    if grep -q "SECRET_KEY=" .env; then
        sed -i "s/SECRET_KEY=.*/SECRET_KEY=$SECRET_KEY/" .env
    else
        echo "SECRET_KEY=$SECRET_KEY" >> .env
    fi
    echo "✅ SECRET_KEY updated in .env file"
fi

echo ""
echo "📋 Environment setup completed!"
echo ""
echo "🔧 Next steps:"
echo "1. Update .env file with your specific values:"
echo "   - Database credentials from Railway PostgreSQL service"
echo "   - Email configuration"
echo "   - Your Railway app domain"
echo ""
echo "2. Set these environment variables in Railway dashboard:"
echo "   - Copy values from .env file"
echo "   - Or use Railway's environment variable import feature"
echo ""
echo "3. Deploy to Railway:"
echo "   ./deploy-railway.sh"
echo ""
echo "⚠️  Important: Never commit .env file to version control!"
echo "   It contains sensitive information."

# Check if .env is in .gitignore
if [ -f ".gitignore" ] && grep -q "\.env" .gitignore; then
    echo "✅ .env is already in .gitignore"
else
    echo "⚠️  Adding .env to .gitignore..."
    echo ".env" >> .gitignore
    echo "✅ .env added to .gitignore"
fi