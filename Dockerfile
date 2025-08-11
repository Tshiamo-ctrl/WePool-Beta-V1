
# Use Python 3.10 slim image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=wepool_project.settings_railway
ENV PORT=8000

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
        build-essential \
        libpq-dev \
        curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Copy and set permissions for the Railway entrypoint script (as root)
COPY railway-entrypoint.sh /app/
RUN chmod +x /app/railway-entrypoint.sh

# Create non-root user
RUN adduser --disabled-password --gecos '' appuser && chown -R appuser:appuser /app
USER appuser

# Collect static files
RUN python manage.py collectstatic --noinput

# Create media directory
RUN mkdir -p media

# Expose port (Railway will override this)
EXPOSE 8000

# Health check honoring dynamic PORT
HEALTHCHECK --interval=30s --timeout=30s --start-period=10s --retries=5 \
    CMD /bin/sh -c 'curl -sf http://localhost:${PORT:-8000}/core/railway-health/ || exit 1'

# Run the application using the entrypoint script
CMD ["/app/railway-entrypoint.sh"]
