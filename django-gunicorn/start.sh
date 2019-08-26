#!/bin/sh
python3 manage.py migrate
gunicorn --log-config gunicorn_logging.conf --workers 5 --bind 0.0.0.0:8000  til.wsgi
