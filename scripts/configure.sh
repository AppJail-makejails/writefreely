#!/bin/sh

WRITEFREELY_CONFIG="/usr/local/www/writefreely/config.ini"
WRITEFREELY_DATABASE_TYPE="${WRITEFREELY_DATABASE_TYPE:-sqlite3}"; export WRITEFREELY_DATABASE_TYPE
WRITEFREELY_DATABASE_FILENAME="${WRITEFREELY_DATABASE_FILENAME:-/data/writefreely.db}"; export WRITEFREELY_DATABASE_FILENAME
WRITEFREELY_SERVER_PORT="${WRITEFREELY_SERVER_PORT:-8080}"; export WRITEFREELY_SERVER_PORT
WRITEFREELY_SERVER_BIND="${WRITEFREELY_SERVER_BIND:-0.0.0.0}"; export WRITEFREELY_SERVER_BIND

env | grep -Ee '^WRITEFREELY__[A-Z0-9_]+__[A-Z0-9_]+=.*$' | while IFS= read -r env; do
    env_name=`printf "%s" "${env}" | cut -s -d "=" -f1`
    env_value=`printf "%s" "${env}" | cut -s -d "=" -f2-`

    section=`printf "%s" "${env}" | sed -Ee 's/^WRITEFREELY__([A-Z0-9_]+)__[A-Z0-9_]+=.*$/\1/'`
    key=`printf "%s" "${env}" | sed -Ee 's/^WRITEFREELY__[A-Z0-9_]+__([A-Z0-9_]+)=.*$/\1/'`

    # tolower
    section=`printf "%s" "${section}" | tr '[:upper:]' '[:lower:]'`

    # _0X2E_ to .
    section=`printf "%s" "${section}" | sed -Ee 's/_0x2e_/./g'`

    initool s "${WRITEFREELY_CONFIG}" "${key}" "${env_value}" > "${WRITEFREELY_CONFIG}.tmp" &&
        mv "${WRITEFREELY_CONFIG}.tmp" "${WRITEFREELY_CONFIG}" || exit $?
done
