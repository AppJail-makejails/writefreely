#!/bin/sh

. /scripts/lib.subr

env | grep -Ee '^WRITEFREELY__[A-Z0-9_]+__[A-Z0-9_]+=.*$' | while IFS= read -r env; do
    env_value=`printf "%s" "${env}" | cut -s -d "=" -f2-`

    section=`printf "%s" "${env}" | sed -Ee 's/^WRITEFREELY__([A-Z0-9_]+)__[A-Z0-9_]+=.*$/\1/'`
    section=`printf "%s" "${section}" | tr '[:upper:]' '[:lower:]'`
    # _0X2E_ to .
    section=`printf "%s" "${section}" | sed -Ee 's/_0x2e_/./g'`

    key=`printf "%s" "${env}" | sed -Ee 's/^WRITEFREELY__[A-Z0-9_]+__([A-Z0-9_]+)=.*$/\1/'`
    key=`printf "%s" "${key}" | tr '[:upper:]' '[:lower:]'`

    info "Configuring (section:${section}) ${key} = ${env_value}"

    initool s "${WRITEFREELY_CONFIG}" "${section}" "${key}" "${env_value}" > "${WRITEFREELY_CONFIG}.tmp" &&
        mv "${WRITEFREELY_CONFIG}.tmp" "${WRITEFREELY_CONFIG}" || exit $?
done
