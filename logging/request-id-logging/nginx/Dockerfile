FROM centos:7
RUN yum clean all && \
    yum update -y && \
    yum install epel-release -y && \
    yum -y install nginx wget 

RUN mkdir /content/
COPY index.html /content/

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
VOLUME ["/etc/nginx/conf.d/"]

ENTRYPOINT ["nginx"]
