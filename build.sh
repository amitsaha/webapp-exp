#!/bin/bash
set -e

pushd golang/basic
docker build -t amitsaha/webapp-demo:golang .
popd


pushd golang/tls
docker build -t amitsaha/webapp-demo:golang-tls .
popd

pushd python/django-gunicorn
docker build -t amitsaha/webapp-demo:python-django .
popd

pushd python/flask-gunicorn
docker build -t amitsaha/webapp-demo:python-flask .
popd


pushd nginx/basic
docker build -t amitsaha/nginx:basic .
popd

pushd nginx/python-gunicorn
docker build -t amitsaha/nginx:gunicorn .
popd

