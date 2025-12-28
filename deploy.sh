#!/bin/bash

# Cloud Storage App - Deployment Script
# This script automates the deployment process on AWS EC2

set -e

echo "=========================================="
echo "Cloud Storage App - Deployment Script"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Check if .env file exists
if [ ! -f .env ]; then
    print_error ".env file not found!"
    echo "Please copy .env.example to .env and update values:"
    echo "  cp .env.example .env"
    echo "  nano .env"
    exit 1
fi

print_status "Environment file found"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed!"
    exit 1
fi

print_status "Docker is installed"

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed!"
    exit 1
fi

print_status "Docker Compose is installed"

# Stop existing containers
print_warning "Stopping existing containers..."
docker-compose -f docker-compose.prod.yaml down || true

# Build Docker images
print_warning "Building Docker images..."
docker-compose -f docker-compose.prod.yaml build

# Start services
print_warning "Starting services..."
docker-compose -f docker-compose.prod.yaml up -d

# Wait for services to be ready
print_warning "Waiting for services to be ready..."
sleep 10

# Run migrations
print_warning "Running database migrations..."
docker-compose -f docker-compose.prod.yaml exec -T web python manage.py migrate

# Collect static files
print_warning "Collecting static files..."
docker-compose -f docker-compose.prod.yaml exec -T web python manage.py collectstatic --noinput

# Create logs directory
docker-compose -f docker-compose.prod.yaml exec -T web mkdir -p logs

# Check service health
print_warning "Checking service health..."
if curl -f http://localhost:8000/health > /dev/null 2>&1; then
    print_status "Application health check passed"
else
    print_error "Application health check failed"
    echo "Logs:"
    docker-compose -f docker-compose.prod.yaml logs web
    exit 1
fi

# Test database connection
print_warning "Testing database connection..."
if docker-compose -f docker-compose.prod.yaml exec -T web python manage.py dbshell <<< "SELECT 1;" > /dev/null 2>&1; then
    print_status "Database connection successful"
else
    print_error "Database connection failed"
    exit 1
fi

# Show deployment summary
echo ""
echo "=========================================="
echo "Deployment Complete!"
echo "=========================================="
echo ""
echo -e "${GREEN}Services Running:${NC}"
docker-compose -f docker-compose.prod.yaml ps
echo ""
echo -e "${GREEN}Next Steps:${NC}"
echo "1. Verify application: http://localhost"
echo "2. Check logs: docker-compose -f docker-compose.prod.yaml logs -f web"
echo "3. Configure domain and SSL certificate"
echo "4. Setup monitoring and alerts"
echo ""
echo -e "${GREEN}Useful Commands:${NC}"
echo "  View logs:          docker-compose -f docker-compose.prod.yaml logs -f web"
echo "  Create superuser:   docker-compose -f docker-compose.prod.yaml exec web python manage.py createsuperuser"
echo "  Collect static:     docker-compose -f docker-compose.prod.yaml exec web python manage.py collectstatic"
echo "  Run migrations:     docker-compose -f docker-compose.prod.yaml exec web python manage.py migrate"
echo "  Stop services:      docker-compose -f docker-compose.prod.yaml down"
echo "  Restart services:   docker-compose -f docker-compose.prod.yaml restart"
echo ""

print_status "Deployment script completed successfully!"
