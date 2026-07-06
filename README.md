# Write Freely

WriteFreely is a clean, minimalist publishing platform made for writers. Start a blog, share knowledge within your organization, or build a community around the shared act of writing.

writefreely.org

<img src="https://writefreely.org/img/writefreely.svg" width="30%" height="auto" alt="Write Freely logo">

## How to use this Makejail

```console
$ mkdir -p /var/appjail-volumes/writefreely/data
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -o expose=80:8080 \
    -o fstab="/var/appjail-volumes/writefreely/data /data" \
    -o container="args:--pull" \
    -e PUID=1000 \
    -e PGID=1000 \
    -e WRITEFREELY__APP__SITE_NAME="myblog" \
    -e WRITEFREELY__APP__HOST="http://your-host-or-ip" \
    ghcr.io/appjail-makejails/writefreely writefreely
```

You can configure WriteFreely through environment variables in the build stage of this Makejail by following these rules:

1. Environment variables must have the form: `WRITEFREELY__SECTION_NAME__KEY_NAME`.
2. `SECTION` and `KEY_NAME` must be in uppercase. They can contain `_` and numbers.
3. `_0X2E_` will be replaced by `.`.

### Arguments (stage: build)

* `writefreely_from` (default: `ghcr.io/appjail-makejails/writefreely`): Location of OCI image. See also [OCI Configuration](#oci-configuration).
* `writefreely_tag` (default: `latest`): OCI image tag. See also [OCI Configuration](#oci-configuration).

### Environment (OCI image)

* `PGID` (default: `1000`): Equivalent to `PUID` but for the Process Group ID.
* `PUID` (default: `1000`): Process User ID for the container's main process, allowing you to match the owner of files written to mounted host volumes to your host system's user. Writable volumes are changed based on this environment variable.
### Environment (stage: build)

* `WRITEFREELY_MIGRATE` (default: `0`): Ignored when SQLite is used as database backend. If MySQL/MariaDB is used as database backend and this environment variable is set to `0`, database initialization is performed, as well as the creation of the user (with admin rights) and the creation of encryption and authentication keys, but when this environment variable is set to a number other than `0`, only migration is performed.
* `WRITEFREELY_PASSWORD` (default: `writefreely`): Password for the WriteFreely user.
* `WRITEFREELY_USERNAME` (default: `writefreely`): Name of the WriteFreely user.


### Volumes

| Name | Owner | Group | Perm | Type | Mountpoint |
| --- | --- | --- | --- | --- | --- |
| appjail-263aca83a3-data | `${PUID}` | `${PGID}` | - | - | /data |

## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.1
      containerfile: Containerfile
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.1"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
```
