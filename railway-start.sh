#!/bin/bash

# Railway Startup Script for WePool
# This script can be used as an alternative to Dockerfile deployment

set -e

echo "🚂 Starting WePool on Railway..."

# Activate virtual environment if it exists
if [ -d "venv" ]; then
    echo "🔧 Activating virtual environment..."
    source venv/bin/activate
fi

# Install dependencies if needed
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment and installing dependencies..."
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
fi

# Set Django settings
export DJANGO_SETTINGS_MODULE=wepool_project.settings_railway

# Collect static files
echo "📁 Collecting static files..."
python manage.py collectstatic --noinput

# Run database migrations
echo "🗄️  Running database migrations..."
python manage.py migrate

# Start the application
echo "🚀 Starting Gunicorn server..."
echo "🔌 Using port: ${PORT:-8000}"
exec gunicorn --bind 0.0.0.0:${PORT:-8000} --workers 3 --timeout 120 wepool_project.wsgi:application