
import os
import sys
from django.core.management import execute_from_command_line

if __name__ == "__main__":
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "wepool_project.settings")
    
    # Run migrations on startup
    execute_from_command_line(["manage.py", "migrate"])
    
    # Collect static files
    execute_from_command_line(["manage.py", "collectstatic", "--noinput"])
    
    # Start the server
    port = os.environ.get("PORT", "5000")
    execute_from_command_line(["manage.py", "runserver", f"0.0.0.0:{port}"])
