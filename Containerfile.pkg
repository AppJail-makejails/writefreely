ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/base:${FREEBSD_RELEASE}

LABEL org.opencontainers.image.title="WriteFreely" \
    org.opencontainers.image.description="Clean, Markdown-based publishing platform made for writers" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/writefreely" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/writefreely" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN pkg update && \
    pkg install FreeBSD-set-base-jail writefreely initool && \
    pkg clean -a && \
    rm -rf /var/cache/pkg/* /var/db/pkg/repos/*
