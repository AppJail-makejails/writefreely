#!/bin/sh

. /scripts/lib.subr

for d in keys pages static templates; do
    if [ ! -d "/data/${d}" ]; then
        info "Copying ${d} -> /data/${d}"
        cp -a "/usr/local/www/writefreely/${d}" "/data/${d}" || exit $?
    fi
done

if [ "${WRITEFREELY__DATABASE__TYPE}" = "sqlite3" ]; then
    if [ -s "${WRITEFREELY__DATABASE__FILENAME}" ]; then
        info "Migrating database"
        writefreely_func db migrate || exit $?
    else
        info "Initializing database"
        writefreely_func db init || exit $?

        info "Creating user '${WRITEFREELY_USERNAME}'"
        writefreely_func user create --admin "${WRITEFREELY_USERNAME}:${WRITEFREELY_PASSWORD}" || exit $?

        info "Generating encryption and authentication keys"
        writefreely_func keys gen || exit $?
    fi
else
    if [ "${WRITEFREELY_MIGRATE}" != 0 ]; then
        info "Migrating database"
        writefreely_func db migrate || exit $?
    else
        info "Initializing database"
        writefreely_func db init || exit $?

        info "Creating user '${WRITEFREELY_USERNAME}'"
        writefreely_func user create --admin "${WRITEFREELY_USERNAME}:${WRITEFREELY_PASSWORD}" || exit $?

        info "Generating encryption and authentication keys"
        writefreely_func keys gen || exit $?
    fi
fi
