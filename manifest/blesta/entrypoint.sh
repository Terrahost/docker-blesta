#!/bin/sh

###
# /entrypoint.sh - Manages the startup of Blesta
###

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

    /usr/sbin/php-fpm --nodaemonize -c /etc/php &

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
