FROM python:3.7-alpine
ADD app.py /app.py
ADD gunicorn_logging.conf /gunicorn_logging.conf
RUN set -e; \
	apk add --no-cache --virtual .build-deps \
		gcc \
		libc-dev \
		linux-headers \
	; \
	pip install flask python-json-logger gunicorn ; \
	apk del .build-deps;
EXPOSE 8000
WORKDIR /
CMD ["gunicorn", "--log-config", "gunicorn_logging.conf", "--workers", "5", "--bind", "0.0.0.0:8000", "app:app"]

