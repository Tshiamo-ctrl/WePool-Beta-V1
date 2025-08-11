#!/bin/bash

# WePool Deployment Script
# This script automates the deployment process for the WePool application

set -e  # Exit on any error

echo "🚀 Starting WePool deployment..."

# Check if Docker and Docker Compose are installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Check if .env.production exists
if [ ! -f .env.production ]; then
    echo "❌ .env.production file not found!"
    echo "📝 Please copy .env.production.template to .env.production and configure it."
    exit 1
fi

# Load environment variables
source .env.production

# Generate SSL certificates if they don't exist
if [ ! -f nginx/ssl/cert.pem ] || [ ! -f nginx/ssl/key.pem ]; then
    echo "🔐 Generating self-signed SSL certificates..."
    mkdir -p nginx/ssl
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout nginx/ssl/key.pem \
        -out nginx/ssl/cert.pem \
        -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
fi

# Create log directory
sudo mkdir -p /var/log/wepool
sudo chown -R $USER:$USER /var/log/wepool

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker-compose down

# Build and start services
echo "🔨 Building and starting services..."
docker-compose up --build -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 30

# Check service health
echo "🏥 Checking service health..."
if curl -f http://localhost/health/ > /dev/null 2>&1; then
    echo "✅ Application is healthy!"
else
    echo "❌ Application health check failed!"
    echo "📋 Container logs:"
    docker-compose logs web
    exit 1
fi

# Run database migrations
echo "🗄️ Running database migrations..."
docker-compose exec web python manage.py migrate

# Create cache table
echo "💾 Creating cache table..."
docker-compose exec web python manage.py createcachetable

# Collect static files
echo "📁 Collecting static files..."
docker-compose exec web python manage.py collectstatic --noinput

echo "🎉 Deployment completed successfully!"
echo "🌐 Application is available at: https://localhost"
echo "📊 Health check: https://localhost/health/"
echo ""
echo "📋 Useful commands:"
echo "  View logs: docker-compose logs -f"
echo "  Stop services: docker-compose down"
echo "  Restart services: docker-compose restart"
echo "  Update application: ./deploy.sh"