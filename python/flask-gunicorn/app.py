from flask import Flask, Response, request
import logging
from pythonjsonlogger import jsonlogger
import werkzeug.exceptions


app = Flask(__name__)

@app.before_request
def record_request():
    request_body = "{}"
    if request.method == "POST":
        if request.content_type == "application/json":
            request_body = json.loads(request.json)

    logger.info('Request receieved', extra={
        'request_path': request.path,
        'request_method': request.method,
        'request_content_type': request.content_type,
        'request_body': request_body,
    })

@app.after_request
def record_response(response):
    logger.info('Request processed', extra={
        'request_path': request.path,
        'response_status': response.status_code
    })

    return response

@app.route('/test/')
def test():
    return 'rest'

@app.route('/honeypot/')
def test1():
    1/0
    return 'lol'

@app.errorhandler(werkzeug.exceptions.HTTPException)
def handle_500(error):
    return "Something went wrong", 500

if __name__ == '__main__':
    logger = logging.getLogger()
    logHandler = logging.StreamHandler()
    formatter = jsonlogger.JsonFormatter()
    logHandler.setFormatter(formatter)
    logger.addHandler(logHandler)
    logger.setLevel(logging.DEBUG)
    app.run()
