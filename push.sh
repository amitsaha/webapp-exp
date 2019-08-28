#!/bin/bash
set -e

docker push amitsaha/webapp-demo:golang
docker push amitsaha/webapp-demo:golang-tls
docker push amitsaha/webapp-demo:python-django
docker push amitsaha/nginx:basic
docker push amitsaha/nginx:gunicorn
