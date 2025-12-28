#!/bin/bash

# Cloud Storage Application Startup Script

echo "================================"
echo "Cloud Storage Setup"
echo "================================"
echo ""

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$SCRIPT_DIR/cloud_storage"
VENV_DIR="$SCRIPT_DIR/storage"

# Check if virtual environment exists
if [ ! -d "$VENV_DIR" ]; then
    echo "❌ Virtual environment not found at $VENV_DIR"
    echo "Please run: python3 -m venv storage"
    exit 1
fi

# Activate virtual environment
source "$VENV_DIR/bin/activate"

# Change to project directory
cd "$PROJECT_DIR" || exit 1

echo "✓ Virtual environment activated"
echo ""

# Menu
echo "Choose an option:"
echo "1) Start MySQL with Docker"
echo "2) Run migrations (SQLite)"
echo "3) Run migrations (MySQL)"
echo "4) Start development server (SQLite)"
echo "5) Start development server (MySQL)"
echo "6) Create superuser"
echo "7) Access admin panel"
echo ""

read -p "Enter your choice (1-7): " choice

case $choice in
    1)
        echo "Starting MySQL container..."
        docker compose up -d mysql
        echo "✓ MySQL container started"
        echo "Waiting for MySQL to be ready..."
        sleep 5
        docker compose logs mysql | grep "ready for connections"
        ;;
    2)
        echo "Running migrations with SQLite..."
        export USE_SQLITE=1
        python manage.py migrate
        echo "✓ Migrations completed"
        ;;
    3)
        echo "Running migrations with MySQL..."
        export USE_SQLITE=0
        python manage.py migrate
        echo "✓ Migrations completed"
        ;;
    4)
        echo "Starting development server with SQLite..."
        export USE_SQLITE=1
        echo "🚀 Server running at http://localhost:8000"
        echo "Press Ctrl+C to stop"
        python manage.py runserver
        ;;
    5)
        echo "Starting development server with MySQL..."
        export USE_SQLITE=0
        echo "🚀 Server running at http://localhost:8000"
        echo "Press Ctrl+C to stop"
        python manage.py runserver
        ;;
    6)
        echo "Create superuser"
        python manage.py createsuperuser
        ;;
    7)
        echo "Open your browser and go to:"
        echo "http://localhost:8000/admin"
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

deactivate
