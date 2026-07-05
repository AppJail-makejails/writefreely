#!/bin/sh

. /scripts/lib.subr

set -e

if [ ! -d "/data" ]; then
    mkdir -p /data
fi

for d in keys pages static templates; do
    if [ ! -d "/data/${d}" ]; then
        info "Copying ${d} -> /data/${d}"
        cp -a "/usr/local/www/writefreely/${d}" "/data/${d}"
    fi
done

chown -Rh noroot:noroot /data

if [ "${WRITEFREELY__DATABASE__TYPE}" = "sqlite3" ]; then
    if [ -s "${WRITEFREELY__DATABASE__FILENAME}" ]; then
        info "Migrating database"
        writefreely_func db migrate
    else
        info "Initializing database"
        writefreely_func db init

        info "Creating user '${WRITEFREELY_USERNAME}'"
        writefreely_func user create --admin "${WRITEFREELY_USERNAME}:${WRITEFREELY_PASSWORD}"

        info "Generating encryption and authentication keys"
        writefreely_func keys gen
    fi
else
    if [ "${WRITEFREELY_MIGRATE}" != 0 ]; then
        info "Migrating database"
        writefreely_func db migrate
    else
        info "Initializing database"
        writefreely_func db init

        info "Creating user '${WRITEFREELY_USERNAME}'"
        writefreely_func user create --admin "${WRITEFREELY_USERNAME}:${WRITEFREELY_PASSWORD}"

        info "Generating encryption and authentication keys"
        writefreely_func keys gen
    fi
fi
