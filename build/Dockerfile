FROM ethereum/client-go:v1.9.24 as geth

FROM node:12.14.1 as build-deps-wizard
RUN apt-get update && apt-get install -y libusb-1.0-0-dev libudev-dev openssl

WORKDIR /cert
RUN cp /etc/ssl/openssl.cnf .
RUN echo "[SAN]\nsubjectAltName=DNS:ethchain-geth.public.dappnode.eth" >> openssl.cnf
RUN cat openssl.cnf
RUN PASSWORD=$(echo $(LC_CTYPE=C tr -dc 'A-HJ-NPR-Za-km-z2-9' < /dev/urandom | head -c 20)) && \
    openssl genrsa -des3 -passout pass:${PASSWORD} -out server.pass.key 2048 && \
    openssl rsa -passin pass:${PASSWORD} -in server.pass.key -out server.key && \
    rm server.pass.key && \
    openssl req -new -key server.key -out server.csr \
        -reqexts SAN \
        -extensions SAN \
        -config openssl.cnf \
        -subj "/C=DE/ST=AVADO/L=AVADO/O=ethchain-geth.public.dappnode.eth/OU=saskia@ava.do/CN=ethchain-geth.public.dappnode.eth" && \
    openssl x509 -req -days 3650 -in server.csr -signkey server.key -out server.crt
RUN ls -l /cert


WORKDIR /cert2
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
COPY --from=build-deps-wizard /cert/server.* /etc/nginx/certs/
COPY --from=build-deps-wizard /cert2/server.crt /etc/nginx/certs/server2.crt
COPY --from=build-deps-wizard /cert2/server.key /etc/nginx/certs/server2.key

RUN ls -l /etc/nginx/certs/
COPY files/nginx.conf /etc/nginx
RUN mkdir -p /run/nginx

COPY ./files/supervisord.conf /etc/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
