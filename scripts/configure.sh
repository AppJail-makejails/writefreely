#!/bin/sh

. /scripts/lib.subr

set -e

if [ ! -f "${WRITEFREELY_CONFIG}" ]; then
    cat << EOF > "${WRITEFREELY_CONFIG}"
[server]
hidden_host          =
port                 = 8080
bind                 = 0.0.0.0
tls_cert_path        =
tls_key_path         =
autocert             = false
templates_parent_dir = /data
static_parent_dir    = /data
pages_parent_dir     = /data
keys_parent_dir      = /data
hash_seed            =
gopher_port          = 0

[database]
type     = sqlite3
filename = /data/writefreely.db
username =
password =
database =
host     =
port     = 0
tls      = false

[app]
site_name             =
site_description      =
host                  =
theme                 =
editor                =
disable_js            = false
webfonts              = false
landing               =
simple_nav            = false
wf_modesty            = false
chorus                = false
forest                = false
disable_drafts        = false
single_user           = true
open_registration     = false
open_deletion         = false
min_username_len      = 0
max_blogs             = 0
federation            = false
public_stats          = false
monetization          = false
notes_only            = false
private               = false
local_timeline        = false
user_invites          =
default_visibility    =
update_checks         = false
disable_password_auth = false

[email]
smtp_host             =
smtp_port             = 0
smtp_username         =
smtp_password         =
smtp_enable_start_tls = false
domain                =
mailgun_private       =
mailgun_europe        = false

[oauth.slack]
client_id          =
client_secret      =
team_id            =
callback_proxy     =
callback_proxy_api =

[oauth.writeas]
client_id          =
client_secret      =
auth_location      =
token_location     =
inspect_location   =
callback_proxy     =
callback_proxy_api =

[oauth.gitlab]
client_id          =
client_secret      =
host               =
display_name       =
callback_proxy     =
callback_proxy_api =

[oauth.gitea]
client_id          =
client_secret      =
host               =
display_name       =
callback_proxy     =
callback_proxy_api =

[oauth.generic]
client_id          =
client_secret      =
host               =
display_name       =
callback_proxy     =
callback_proxy_api =
token_endpoint     =
inspect_endpoint   =
auth_endpoint      =
scope              =
allow_disconnect   = false
map_user_id        =
map_username       =
map_display_name   =
map_email          =
EOF
fi

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
        mv "${WRITEFREELY_CONFIG}.tmp" "${WRITEFREELY_CONFIG}"
done
