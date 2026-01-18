# Write Freely

WriteFreely is a clean, minimalist publishing platform made for writers. Start a blog, share knowledge within your organization, or build a community around the shared act of writing.

writefreely.org

<img src="https://writefreely.org/img/writefreely.svg" alt="writefreely logo" width="60%" height="auto">

## How to use this Makejail

```sh
mkdir -p .volumes/writefreely-data
appjail makejail \
    -j writefreely \
    -f gh+AppJail-makejails/writefreely \
    -o virtualnet=":<random> default" \
    -o nat \
    -o expose=80:8080 \
    -V WRITEFREELY__APP__SITE_NAME="myblog" \
    -V WRITEFREELY__APP__HOST="http://your-host-or-ip" \
    -o fstab="$PWD/.volumes/writefreely-data writefreely-data <volumefs>"
```

You can configure WriteFreely through environment variables in the build stage of this Makejail by following these rules:

1. Environment variables must have the form: `WRITEFREELY__SECTION_NAME__KEY_NAME`.
2. `SECTION` and `KEY_NAME` must be in uppercase. They can contain `_` and numbers.
3. `_0X2E_` will be replaced by `.`.

### Arguments

* `writefreely_config` (default: `files/config.ini`): Initial WriteFreely configuration file.
* `writefreely_ajspec` (default: `gh+AppJail-makejails/writefreely`): Entry point where the `appjail-ajspec(5)` file is located.
* `writefreely_tag` (default: `14.3`): see [#tags](#tags).

### Environment

* `WRITEFREELY_MIGRATE` (default: `0`): Ignored when SQLite is used as database backend. If MySQL/MariaDB is used as database backend and this environment variable is set to `0`, database initialization is performed, as well as the creation of the user (with admin rights) and the creation of encryption and authentication keys, but when this environment variable is set to a number other than `0`, only migration is performed.
* `WRITEFREELY_USERNAME` (default: `writefreely`): Name of the WriteFreely user.
* `WRITEFREELY_PASSWORD` (default: `writefreely`): Password for the WriteFreely user.

### Volumes

| Name             | Owner | Group | Perm | Type | Mountpoint |
| ---------------- | ----- | ----- | ---- | ---- | ---------- |
| writefreely-data | 296   | 296   | -    | -    | /data      |

## Tags

| Tag        | Arch     | Version            | Type   |
| ---------- | -------- | ------------------ | ------ |
| `14.3` | `amd64`  | `14.3-RELEASE` | `thin` |
| `15` | `amd64`  | `15` | `thin` |
