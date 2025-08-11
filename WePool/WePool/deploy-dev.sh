#!/bin/bash

# WePool Development Deployment Script
# This script sets up the development environment with Docker

set -e  # Exit on any error

echo "🚀 Starting WePool development deployment..."

# Check if Docker and Docker Compose are installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Create development environment file if it doesn't exist
if [ ! -f .env.development ]; then
    echo "📝 Creating development environment file..."
    cp .env.development.template .env.development 2>/dev/null || echo "Using existing .env.development"
fi

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker-compose down

# Build and start services (development mode)
echo "🔨 Building and starting development services..."
docker-compose -f docker-compose.dev.yml up --build -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 20

# Check service health
echo "🏥 Checking service health..."
if curl -f http://localhost:8000/health/ > /dev/null 2>&1; then
    echo "✅ Application is healthy!"
else
    echo "❌ Application health check failed!"
    echo "📋 Container logs:"
    docker-compose -f docker-compose.dev.yml logs web
    exit 1
fi

# Run database migrations
echo "🗄️ Running database migrations..."
docker-compose -f docker-compose.dev.yml exec web python manage.py migrate

# Create superuser if it doesn't exist
echo "👤 Creating superuser (if needed)..."
docker-compose -f docker-compose.dev.yml exec web python manage.py shell -c "
from django.contrib.auth.models import User
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
    print('Superuser created: admin/admin123')
else:
    print('Superuser already exists')
"

echo "🎉 Development deployment completed successfully!"
echo "🌐 Application is available at: http://localhost:8000"
echo "📊 Health check: http://localhost:8000/health/"
echo "👤 Admin user: admin/admin123"
echo ""
echo "📋 Useful commands:"
echo "  View logs: docker-compose -f docker-compose.dev.yml logs -f"
echo "  Stop services: docker-compose -f docker-compose.dev.yml down"
echo "  Restart services: docker-compose -f docker-compose.dev.yml restart"
echo "  Shell access: docker-compose -f docker-compose.dev.yml exec web python manage.py shell"