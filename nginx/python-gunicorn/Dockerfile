FROM centos:7
RUN yum clean all && \
    yum update -y && \
    yum install epel-release -y && \
    yum -y install https://extras.getpagespeed.com/release-el7-latest.rpm && \
    yum -y install nginx wget nginx-module-geoip2

WORKDIR /etc
RUN wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz && \
    wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz && \
    gzip -d GeoLite2-City.mmdb.gz && \
    gzip -d GeoLite2-Country.mmdb.gz

RUN rm -rf /etc/nginx/conf.d && mkdir -p /etc/nginx/conf.d
COPY nginx.conf /etc/nginx/nginx.conf
COPY proxy_settings /etc/nginx/conf.d/

EXPOSE 80

ENTRYPOINT ["nginx"]
