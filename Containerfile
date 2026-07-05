ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/core:${FREEBSD_RELEASE}

ARG NO_PKGCLEAN

LABEL org.opencontainers.image.title="WriteFreely" \
    org.opencontainers.image.description="Clean, Markdown-based publishing platform made for writers" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/writefreely" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/writefreely" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN set -xe; \
    \
    pkg update; \
    pkg install FreeBSD-set-base-jail writefreely initool; \
    \
    if [ -z "${NO_PKGCLEAN}" ]; then \
        pkg clean -a; \
        rm -rf /var/cache/pkg/* /var/db/pkg/repos/*; \
    fi

VOLUME ["/data"]

COPY scripts /scripts
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
