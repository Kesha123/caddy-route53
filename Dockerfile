FROM docker.io/caddy:builder AS builder
RUN xcaddy build --with github.com/caddy-dns/route53

FROM docker.io/caddy:2.11.4

ARG CREATED
ARG REVISION
ARG VERSION

LABEL org.opencontainers.image.source=https://github.com/Kesha123/caddy-route53
LABEL org.opencontainers.image.description="Caddy with the Route53 DNS plugin"
LABEL org.opencontainers.image.licenses=MIT
LABEL org.opencontainers.image.created=${CREATED}
LABEL org.opencontainers.image.revision=${REVISION}
LABEL org.opencontainers.image.version=${VERSION}

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
