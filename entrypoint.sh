#!/bin/sh

. /scripts/lib.subr

set -e

create_user

/scripts/configure.sh
/scripts/init.sh

exec su-exec noroot writefreely -c "${WRITEFREELY_CONFIG}" serve "$@"
