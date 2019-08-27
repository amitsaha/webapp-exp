import logging
import json
from pythonjsonlogger import jsonlogger

class CustomJsonFormatter(jsonlogger.JsonFormatter):
    def add_fields(self, log_record, record, message_dict):
        super(CustomJsonFormatter, self).add_fields(log_record, record, message_dict)
        if log_record.get('level'):
            log_record['level'] = log_record['level'].upper()
        else:
            log_record['level'] = record.levelname
        

class RequestLogger():

    def __init__(self, get_response):
        self.get_response = get_response
        self.logger = logging.getLogger()
        

    def __call__(self, request):

        request_body = "{}"
        if request.method == "POST":
            if request.content_type == "application/json":
                request_body = json.loads(request.body)

        self.logger.info('Request receieved', extra={
            'request_path': request.path_info,
            'request_method': request.method,
            'request_content_type': request.content_type,
            'request_body': request_body,
        })
        
        response = self.get_response(request)
        if response:
            self.logger.info('Request processed', extra={
                'request_path': request.path_info,
                'response_status': response.status_code
            })

        return response

    
    def process_exception(self, request, exception):    
        self.logger.exception('Request exception', extra={'request_path': request.path_info})
