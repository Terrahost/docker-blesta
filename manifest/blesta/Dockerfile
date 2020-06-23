FROM alpine:3.11

MAINTAINER Bryce Anglin <opensource@terrahost.cloud>

ARG VERSION

ENV STARTUP_TIMEOUT=5 \
    BLESTA_VERSION=${VERSION}

WORKDIR /var/www/

ADD https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

RUN apk --update add ca-certificates && \
    echo "https://dl.bintray.com/php-alpine/v3.11/php-7.4" >> /etc/apk/repositories

RUN \
 apk --update add curl gettext nginx php7 php7 php7-bcmath php7-common php7-dom php7-fileinfo \
 php7-fpm php7-gd php7-memcached php7-mbstring php7-openssl php7-pdo php7-phar php7-json \
 php7-pdo_mysql php7-session php7-simplexml php7-tokenizer php7-ctype php7-zlib php7-zip tini \
 && mkdir -p /run/nginx
 
RUN \
 curl -Lo blesta.zip https://account.blesta.com/client/plugin/download_manager/client_main/download/152/blesta-${BLESTA_VERSION}.zip
 && unzip bleta.zip \
 && rm bleta.zip \
 && chown nginx:nginx * -R

COPY ./ /

VOLUME [ "/data" ]

# Expose HTTP and HTTPS ports
EXPOSE 80 443

ENTRYPOINT [ "/sbin/tini", "--", "/entrypoint.sh" ]

CMD [ "p:start" ]
