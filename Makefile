OCI_REGISTRY	?= ghcr.io
NAMESPACE		?= kesha123
REPOSITORY		?= caddy-route53
OCI_IMAGE		?= $(OCI_REGISTRY)/$(NAMESPACE)/$(REPOSITORY)

CADDY_VERSION	:= $(shell scripts/caddy-version 2>/dev/null || echo latest)

BUILD_TAG	?= $(CADDY_VERSION)

PLATFORM	?= linux/amd64

DOCKER		?= docker

CREATED		?=
REVISION	?=


.PHONY: build publish publish-assemble

build:
	$(DOCKER) buildx build \
		--load \
		--platform $(PLATFORM) \
		--build-arg CREATED="$(CREATED)" \
		--build-arg REVISION="$(REVISION)" \
		--build-arg VERSION="$(CADDY_VERSION)" \
		-t $(OCI_IMAGE):$(BUILD_TAG) \
		-t $(OCI_IMAGE):latest \
		-f Dockerfile \
		.

publish:
	$(DOCKER) buildx build \
		--push \
		--platform $(PLATFORM) \
		--build-arg CREATED="$(CREATED)" \
		--build-arg REVISION="$(REVISION)" \
		--build-arg VERSION="$(CADDY_VERSION)" \
		--sbom=true --provenance=mode=max \
		-t $(OCI_IMAGE):$(BUILD_TAG) \
		-f Dockerfile \
		.

publish-assemble:
	$(DOCKER) buildx imagetools create \
		--annotation "index:org.opencontainers.image.description=Caddy with the Route53 DNS plugin" \
		--annotation "index:org.opencontainers.image.source=https://github.com/Kesha123/caddy-route53" \
		--annotation "index:org.opencontainers.image.version=$(BUILD_TAG)" \
		-t $(OCI_IMAGE):$(BUILD_TAG) \
		-t $(OCI_IMAGE):latest \
		$(OCI_IMAGE):$(BUILD_TAG)-amd64 \
		$(OCI_IMAGE):$(BUILD_TAG)-arm64
