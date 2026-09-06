OCI_REGISTRY	?= ghcr.io
NAMESPACE		?= kesha123
REPOSITORY		?= caddy-route53
OCI_IMAGE		?= $(OCI_REGISTRY)/$(NAMESPACE)/$(REPOSITORY)

BUILD_TAG_MAJOR		:= 0
BUILD_TAG_MINOR		:= 0
BUILD_TAG_PATCH		:= 0
BUILD_TAG			?= v$(BUILD_TAG_MAJOR).$(BUILD_TAG_MINOR).$(BUILD_TAG_PATCH)

PLATFORM	?= linux/amd64

DOCKER ?= docker
DOCKER_BUILD := $(DOCKER) buildx build


.PHONY: build publish

build:
	$(DOCKER_BUILD) \
		--platform $(PLATFORM) \
		-t $(OCI_IMAGE):$(BUILD_TAG) \
		-t $(OCI_IMAGE):latest \
		-f Containerfile \
		.

publish:
	$(DOCKER) push $(OCI_IMAGE):$(BUILD_TAG)
	$(DOCKER) push $(OCI_IMAGE):latest
