IMAGE_NAME ?= stata-mp-local
INTERACTIVE:=$(shell [ -t 0 ] && echo 1)
STATA_LICENSE ?= $(shell cat stata.lic)
export STATA_LICENSE

export DOCKER_BUILDKIT=1
export BUILD_DATE=$(shell date +'%y-%m-%dT%H:%M:%S.%3NZ')
export VERSIOHN=$(shell git rev-parse --short HEAD)

build:
	docker-compose build --pull stata-mp

.PHONY: lint
lint:
	@docker pull hadolint/hadolint
	docker run --rm -i hadolint/hadolint < Dockerfile
	shellcheck entrypoint.sh scripts/*.sh tests/*.sh

.PHONY: test
test:
	./tests/run.sh stata-mp


# docker leaves files around as root
clean:
	sudo rm -f tests/*.log
