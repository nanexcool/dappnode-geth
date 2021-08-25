FROM ethereum/client-go:v1.10.8 as geth

FROM node:12.14.1 as build-deps-wizard
RUN apt-get update && apt-get install -y libusb-1.0-0-dev libudev-dev openssl

WORKDIR /cert
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
RUN wget http://iso.ava.do/server.crt
RUN wget http://iso.ava.do/server.key

FROM alpine:latest

COPY --from=geth /usr/local/bin/geth /usr/local/bin/geth

RUN apk update && apk add --no-cache supervisor nginx

#RUN adduser -D nginx
RUN rm -rf /tmp/*
RUN rm -rf /var/cache/apk/*

# Set up nginx config
RUN mkdir -p /etc/nginx/certs/
COPY --from=build-deps-wizard /cert/server.crt /etc/nginx/certs/server.crt
COPY --from=build-deps-wizard /cert/server.key /etc/nginx/certs/server.key

RUN ls -l /etc/nginx/certs/
COPY files/nginx.conf /etc/nginx
RUN mkdir -p /run/nginx

COPY ./files/supervisord.conf /etc/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
