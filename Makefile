OCI_REGISTRY	?= ghcr.io
NAMESPACE		?= kesha123
REPOSITORY		?= caddy-route53
OCI_IMAGE		?= $(OCI_REGISTRY)/$(NAMESPACE)/$(REPOSITORY)

CADDY_VERSION	:= $(shell awk '/^FROM/ && $$2 ~ /caddy:/ { n=split($$2,a,":"); v=a[n] } END { print v }' Dockerfile)

BUILD_TAG			?= $(CADDY_VERSION)

PLATFORM	?= linux/amd64

DOCKER ?= docker
DOCKER_BUILD := $(DOCKER) buildx build


.PHONY: build publish publish-assemble

build:
	$(DOCKER_BUILD) \
		--platform $(PLATFORM) \
		-t $(OCI_IMAGE):$(BUILD_TAG) \
		-t $(OCI_IMAGE):latest \
		-f Dockerfile \
		.

publish:
	$(DOCKER) push $(OCI_IMAGE):$(BUILD_TAG)

publish-assemble:
	$(DOCKER) buildx imagetools create \
		-t $(OCI_IMAGE):$(BUILD_TAG) \
		-t $(OCI_IMAGE):latest \
		$(OCI_IMAGE):$(BUILD_TAG)-amd64 \
		$(OCI_IMAGE):$(BUILD_TAG)-arm64
