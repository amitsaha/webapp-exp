FROM centos:7
RUN yum clean all && \
    yum update -y && \
    yum install epel-release -y && \
    yum -y install nginx 

RUN rm -rf /etc/nginx/conf.d && mkdir -p /etc/nginx/conf.d
COPY nginx.conf /etc/nginx/nginx.conf
COPY proxy_settings /etc/nginx/conf.d/

EXPOSE 80

ENTRYPOINT ["nginx"]
