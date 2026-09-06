# caddy-route53

An OCI container image of [Caddy](https://caddyserver.com) with the [Route53 DNS plugin](https://github.com/caddy-dns/route53) pre-built, for obtaining TLS certificates via DNS-01 challenge against AWS Route 53.

## Build

```sh
make build
```

Overrides: `PLATFORM` (default `linux/amd64`), `OCI_IMAGE`, `BUILD_TAG` (default `v0.0.0`).

## Publish

```sh
make publish
```

Pushes `$(BUILD_TAG)` and `latest` to the registry (default `ghcr.io/kesha123/caddy-route53`).

## Run

```sh
docker run -d --name caddy \
  -p 80:80 -p 443:443 \
  -v caddy-data:/data \
  -e AWS_REGION=us-east-1 \
  -e AWS_ACCESS_KEY_ID=... \
  -e AWS_SECRET_ACCESS_KEY=... \
  ghcr.io/kesha123/caddy-route53:latest
```

## Caddyfile example

```caddyfile
example.com {
    tls {
        dns route53
    }
}
```
