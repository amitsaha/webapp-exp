#!/bin/bash

pushd golang/basic
docker build -t amitsaha/webapp-demo:golang .
docker push amitsaha/webapp-demo:golang
popd


pushd golang/tls
docker build -t amitsaha/webapp-demo:golang-tls .
docker push amitsaha/webapp-demo:golang-tls
popd

pushd python/django-gunicorn
docker build -t amitsaha/webapp-demo:python-django .
docker push amitsaha/webapp-demo:python-django
popd