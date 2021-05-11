IMAGE_NAME ?= stata-mp-local
INTERACTIVE:=$(shell [ -t 0 ] && echo 1)
STATA_LICENSE ?= $(shell cat stata.lic)
export DOCKER_BUILDKIT=1

.PHONY: build
build: BUILD_DATE=$(shell date +'%y-%m-%dT%H:%M:%S.%3NZ')
build: GITREF=$(shell git rev-parse --short HEAD)
build:
	docker build . --tag $(IMAGE_NAME) --progress=plain \
		--build-arg BUILDKIT_INLINE_CACHE=1 --cache-from ghcr.io/opensafely-core/stata-mp \
		--build-arg BUILD_DATE=$(BUILD_DATE) --build-arg GITREF=$(GITREF)

.PHONY: lint
lint:
	@docker pull hadolint/hadolint
	docker run --rm -i hadolint/hadolint < Dockerfile
	shellcheck entrypoint.sh scripts/*.sh tests/*.sh

.PHONY: test
test:
	@STATA_LICENSE="$(STATA_LICENSE)" ./tests/run.sh $(IMAGE_NAME)


# docker leaves files around as root
clean:
	sudo rm tests/*.log
