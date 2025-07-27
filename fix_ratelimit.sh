#!/bin/bash
# Script to fix 'ratelimit' module not found issue by creating a virtual environment and installing required packages.

set -e

# Step 1: Create a virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment 'venv'..."
    python3 -m venv venv
fi

# Step 2: Activate the virtual environment
source venv/bin/activate

# Step 3: Upgrade pip
pip install --upgrade pip

# Step 4: Install required dependencies
pip install django django-ratelimit ip2geotools

# Step 5: Verify installation of django-ratelimit
if pip show django-ratelimit > /dev/null 2>&1; then
    echo "django-ratelimit successfully installed."
else
    echo "Failed to install django-ratelimit."
    exit 1
fi

echo "All set! You can now run: python manage.py runserver"
