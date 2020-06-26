FROM alpine:3.11

MAINTAINER Bryce Anglin <opensource@terrahost.cloud>

ARG VERSION

ENV STARTUP_TIMEOUT=5 \
    BLESTA_VERSION=${VERSION}

WORKDIR /var/www/blesta

ADD https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

RUN \
    apk --update add ca-certificates && \
    echo "https://dl.bintray.com/php-alpine/v3.11/php-7.3" >> /etc/apk/repositories

RUN \
    apk add --update tar unzip zip curl gettext nginx php php-common php-pdo_mysql php-curl php-openssl \
    php-json php-ldap php-xml php-iconv php-mbstring \
    php-gmp php-imap php-simplexml php-zlib tini

RUN \
    cd /tmp \
    && curl -sSL https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz -o ioncube.tar.gz \
    && tar -xf ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_7.3.so /usr/lib/php7/modules/ioncube_loader_lin_7.3.so \
    && echo 'zend_extension = /usr/lib/php7/modules/ioncube_loader_lin_7.3.so' >  /etc/php7/conf.d/00-ioncube.ini \
    && rm ioncube.tar.gz

RUN \
    mkdir -p /var/www/blesta /run/nginx
 
RUN \
    curl -Lo blesta.zip https://account.blesta.com/client/plugin/download_manager/client_main/download/152/blesta-${BLESTA_VERSION}.zip \
    && unzip blesta.zip -d /var/www \
    && rm blesta.zip \
    && chown nginx:nginx * -R

COPY ./ /

VOLUME [ "/data" ]

# Expose HTTP and HTTPS ports
EXPOSE 80 443

ENTRYPOINT [ "/sbin/tini", "--", "/entrypoint.sh" ]

CMD [ "p:start" ]
