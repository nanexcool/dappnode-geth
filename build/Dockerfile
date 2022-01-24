FROM ethereum/client-go:v1.10.15 as geth

FROM node:12.14.1 as build-deps-wizard
RUN apt-get update && apt-get install -y libusb-1.0-0-dev libudev-dev openssl

WORKDIR /cert
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
RUN wget http://iso.ava.do/my.ava.do.crt
RUN wget http://iso.ava.do/my.ava.do.key

FROM alpine:latest

COPY --from=geth /usr/local/bin/geth /usr/local/bin/geth

RUN apk update && apk add --no-cache supervisor nginx

#RUN adduser -D nginx
RUN rm -rf /tmp/*
RUN rm -rf /var/cache/apk/*

# Set up nginx config
RUN mkdir -p /etc/nginx/certs/
COPY --from=build-deps-wizard /cert/my.ava.do.crt /etc/nginx/certs/my.ava.do.crt
COPY --from=build-deps-wizard /cert/my.ava.do.key /etc/nginx/certs/my.ava.do.key

RUN ls -l /etc/nginx/certs/
COPY files/nginx.conf /etc/nginx
RUN mkdir -p /run/nginx

COPY ./files/supervisord.conf /etc/supervisord.conf

# Startup script
COPY ./files/start.sh /opt/start.sh
RUN chmod +x /opt/start.sh

ENTRYPOINT ["/opt/start.sh"]