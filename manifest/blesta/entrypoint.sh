#!/bin/sh

###
# /entrypoint.sh - Manages the startup of Blesta
###

# Prep Container for usage
function init {
    # Create the storage/cache directories
    if [ ! -d /data/storage ]; then
        mkdir -p /data/storage
        cat .storage.tmpl | while read line; do
            mkdir -p "/data/${line}"
        done
        chown -R nginx:nginx /data/storage
    fi

    if [ ! -d /data/cache ]; then
        mkdir -p /data/cache
        chown -R nginx:nginx /data/cache
    fi

    # destroy links (or files) and recreate them
    rm -rf storage
    ln -s /data/storage storage

    rm -rf bootstrap/cache
    ln -s /data/cache bootstrap/cache

    rm -rf .env
    ln -s /data/pterodactyl.conf .env
}

# Runs the initial configuration on every startup
function startServer {

    # Allows Users to give MySQL sometime to start up.
    if [[ "${STARTUP_TIMEOUT}" -gt "0" ]]; then
        echo "Starting Blesta ${BLESTA_VERSION} in ${STARTUP_TIMEOUT} seconds..."
        sleep ${STARTUP_TIMEOUT}
    else 
        echo "Starting Blesta ${BLESTA_VERSION}..."
    fi

    if [ "${SSL}" == "true" ]; then
        envsubst '${SSL_CERT},${SSL_CERT_KEY}' \
        < /etc/nginx/templates/https.conf > /etc/nginx/conf.d/default.conf
    else
        echo "[Warning] Disabling HTTPS"
        cat /etc/nginx/templates/http.conf > /etc/nginx/conf.d/default.conf
    fi

    # Determine if workers should be enabled or not
    if [ "${DISABLE_WORKERS}" != "true" ]; then
        /usr/sbin/crond -f -l 0 &
    else 
        echo "[Warning] Disabling Workers (cron); It is recommended to keep these enabled unless you know what you are doing."
    fi

    /usr/sbin/php-fpm7 --nodaemonize -c /etc/php7 &

    exec /usr/sbin/nginx -g "daemon off;"
}

## Start ##

init

case "${1}" in
    p:start)
        startServer
        ;;
    *)
        exec ${@}
        ;;
esac
