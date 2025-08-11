#!/bin/bash

# Railway Entrypoint Script for WePool
# This script handles Railway-specific startup requirements

set -e

echo "🚂 WePool Railway Entrypoint"
echo "============================"

# Set default port if not provided by Railway
export PORT=${PORT:-8000}
echo "🔌 Using port: $PORT"

# Activate virtual environment if it exists
if [ -d "venv" ]; then
    echo "🔧 Activating virtual environment..."
    source venv/bin/activate
fi

# Install dependencies if needed
if [ ! -d "venv" ]; then
    echo "📦 Installing dependencies..."
    pip install -r requirements.txt
fi

# Set Django settings
export DJANGO_SETTINGS_MODULE=wepool_project.settings_railway
echo "⚙️  Django settings: $DJANGO_SETTINGS_MODULE"

# Collect static files
echo "📁 Collecting static files..."
python manage.py collectstatic --noinput

# Run database migrations
echo "🗄️  Running database migrations..."
python manage.py migrate

# Start the application
echo "🚀 Starting Gunicorn server on port $PORT..."
exec gunicorn --bind 0.0.0.0:$PORT --workers 3 --timeout 120 wepool_project.wsgi:application