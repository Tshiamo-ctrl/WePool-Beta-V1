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
python manage.py collectstatic --noinput || true
# Verify critical assets are present in manifest
if [ -f "staticfiles/staticfiles.json" ]; then
  if ! grep -q "js/landing.js" staticfiles/staticfiles.json; then
    echo "⚠️  landing.js not found in manifest. Re-running collectstatic and listing dirs..."
    python manage.py collectstatic --noinput || true
    ls -la static/js || true
    ls -la staticfiles/js || true
  fi
fi

# Wait for database readiness (if configured)
MAX_DB_RETRIES=${MAX_DB_RETRIES:-20}
SLEEP_BETWEEN_RETRIES=${SLEEP_BETWEEN_RETRIES:-3}

echo "🧪 Checking database readiness (retries: $MAX_DB_RETRIES, sleep: ${SLEEP_BETWEEN_RETRIES}s)..."
for i in $(seq 1 $MAX_DB_RETRIES); do
  if python - <<'PY'
import os
import sys
os.environ.setdefault("DJANGO_SETTINGS_MODULE", os.getenv("DJANGO_SETTINGS_MODULE", "wepool_project.settings_railway"))
try:
    import django
    django.setup()
    from django.db import connections
    with connections['default'].cursor() as cursor:
        cursor.execute("SELECT 1")
        cursor.fetchone()
    sys.exit(0)
except Exception as e:
    print(f"DB not ready: {e}")
    sys.exit(1)
PY
  then
    echo "✅ Database is ready"
    break
  else
    if [ "$i" -eq "$MAX_DB_RETRIES" ]; then
      echo "❌ Database not ready after $MAX_DB_RETRIES attempts. Exiting."
      exit 1
    fi
    echo "⏳ Waiting for database... (attempt $i/$MAX_DB_RETRIES)"
    sleep "$SLEEP_BETWEEN_RETRIES"
  fi
done

# Run database migrations with retry
MAX_MIGRATE_RETRIES=${MAX_MIGRATE_RETRIES:-5}
for i in $(seq 1 $MAX_MIGRATE_RETRIES); do
  echo "🗄️  Running database migrations (attempt $i/$MAX_MIGRATE_RETRIES)..."
  if python manage.py migrate --noinput; then
    echo "✅ Migrations applied"
    break
  else
    if [ "$i" -eq "$MAX_MIGRATE_RETRIES" ]; then
      echo "❌ Migrations failed after $MAX_MIGRATE_RETRIES attempts. Exiting."
      exit 1
    fi
    echo "⚠️  Migration failed. Retrying in 3s..."
    sleep 3
  fi
done

# Start the application
echo "🚀 Starting Gunicorn server on port $PORT..."
exec gunicorn \
  --bind 0.0.0.0:$PORT \
  --workers ${GUNICORN_WORKERS:-3} \
  --timeout ${GUNICORN_TIMEOUT:-120} \
  --access-logfile - \
  --error-logfile - \
  --log-level ${GUNICORN_LOG_LEVEL:-info} \
  wepool_project.wsgi:application