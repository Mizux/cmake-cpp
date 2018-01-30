help:
	@echo "usage:"
	@echo "make docker: generate docker images"
	@echo "make configure: cmake configure"
	@echo "make build: cmake build"
	@echo "make test: run unit tests"
	@echo "make install: cmake install"
	@echo "make clean: call cmake \"make clean\""
	@echo "make distclean: clean and also remove docker images"

# Need to add cmd_distro to PHONY otherwise target are ignored since they don't
# contain recipe (using FORCE don't work here)
.PHONY: help all
all: build

PROJECT :=$(shell basename $(shell pwd))
UID := $(shell id -u)
GID := $(shell id -g)
DOCKER_CMD := docker run --rm -it -v ${PWD}:/tmp -w /tmp --user ${UID}:${GID}
DOCKER_INSTALL_CMD := docker run --rm -it

# $* stem
# $< first prerequist
# $@ target name

# DOCKER
.PHONY: docker docker_alpine docker_archlinux docker_ubuntu
docker: docker_alpine docker_archlinux docker_ubuntu
docker_alpine: build/alpine/docker_devel.tar
docker_archlinux: build/archlinux/docker_devel.tar
docker_ubuntu: build/ubuntu/docker_devel.tar
build/%/docker_devel.tar: docker/%/Dockerfile docker/%/setup.sh
	mkdir -p build/$*
	docker image rm -f ${PROJECT}_$*:devel 2>/dev/null
	docker build --no-cache -t ${PROJECT}_$*:devel docker/$*
	docker save ${PROJECT}_$*:devel -o $@

# DOCKER BASH
.PHONY: bash_alpine bash_archlinux bash_ubuntu
bash_alpine: build/alpine/docker_devel.tar
	${DOCKER_CMD} ${PROJECT}_alpine:devel /bin/bash
bash_archlinux: build/archlinux/docker_devel.tar
	${DOCKER_CMD} ${PROJECT}_archlinux:devel /bin/bash
bash_ubuntu: build/ubuntu/docker_devel.tar
	${DOCKER_CMD} ${PROJECT}_ubuntu:devel /bin/bash

# CONFIGURE
.PHONY: configure configure_alpine configure_archlinux configure_ubuntu
configure: configure_alpine configure_archlinux configure_ubuntu
configure_alpine: configure-alpine
configure_archlinux: configure-archlinux
configure_ubuntu: configure-ubuntu
configure-%: build/%/docker_devel.tar
	@docker load -i $<
	${DOCKER_CMD} ${PROJECT}_$*:devel /bin/sh -c "cmake -H. -Bbuild/$*"

# BUILD
.PHONY: build build_alpine build_archlinux build_ubuntu
build: build_alpine build_archlinux build_ubuntu
build_alpine: build-alpine
build_archlinux: build-archlinux
build_ubuntu: build-ubuntu
build-%: build/%/docker_devel.tar
	@docker load -i $<
	${DOCKER_CMD} ${PROJECT}_$*:devel /bin/sh -c "cmake --build build/$* --target all"

# TEST
.PHONY: test test_alpine test_archlinux test_ubuntu
test: test_ubuntu
test_alpine: test-alpine
test_archlinux: test-archlinux
test_ubuntu: test-ubuntu
test-%: build/%/docker_devel.tar
	@docker load -i $<
	${DOCKER_CMD} ${PROJECT}_$*:devel /bin/sh -c "cd build/$* && ctest --output-on-failure"

# INSTALL
.PHONY: install install_alpine install_archlinux install_ubuntu
install: install_ubuntu
install_alpine: build/alpine/docker_install.tar
install_archlinux: build/archlinux/docker_install.tar
install_ubuntu: build/ubuntu/docker_install.tar
.PRECIOUS: build/%/install
build/%/install: build/%/docker_devel.tar FORCE
	@docker load -i $<
	${DOCKER_CMD} ${PROJECT}_$*:devel /bin/sh -c "cmake --build build/$* --target install -- DESTDIR=install"

build/%/docker_install.tar: docker/%/InstallDockerfile build/%/install test/config
	docker image rm -f ${PROJECT}_$*:install 2>/dev/null
	docker build --no-cache -t ${PROJECT}_$*:install -f $< .
	docker save ${PROJECT}_$*:install -o $@

# DOCKER BASH INSTALL
.PHONY: bash_install_alpine bash_install_archlinux bash_install_ubuntu
bash_install_alpine: build/alpine/docker_install.tar
	${DOCKER_INSTALL_CMD} ${PROJECT}_alpine:install /bin/bash
bash_install_archlinux: build/archlinux/docker_install.tar
	${DOCKER_INSTALL_CMD} ${PROJECT}_archlinux:install /bin/bash
bash_install_ubuntu: build/ubuntu/docker_install.tar
	${DOCKER_INSTALL_CMD} ${PROJECT}_ubuntu:install /bin/bash

# TEST INSTALL
.PHONY: test_install test_install_alpine bash_install_archlinux bash_isntall_ubuntu
test_install: test_install_alpine test_install_archlinux test_install_ubuntu
test_install_alpine: test_install-alpine
test_install_archlinux: test_install-archlinux
test_install_ubuntu: test_install-ubuntu
test_install-%: build/%/docker_install.tar
	@docker load -i $<
	${DOCKER_INSTALL_CMD} ${PROJECT}_$*:install /bin/sh -c "FooBarApp"
	${DOCKER_INSTALL_CMD} -w /project ${PROJECT}_$*:install /bin/sh -c "cmake -H. -Bbuild; cmake --build build"

# CLEAN
.PHONY: clean clean_alpine clean_archlinux clean_ubuntu
clean: clean_alpine clean_archlinux clean_ubuntu
clean_alpine: clean-alpine
clean_archlinux: clean-archlinux
clean_ubuntu: clean-ubuntu
clean-%:: build/%/docker_devel.tar
	@docker load -i $<
	${DOCKER_CMD} ${PROJECT}_$*:devel /bin/sh -c "cmake --build build/$* --target clean"

# DISTCLEAN
.PHONY: distclean distclean_alpine distclean_archlinux distclean_ubuntu
distclean: distclean_alpine distclean_archlinux distclean_ubuntu
	docker image prune -f
	rm -rf build
distclean_alpine: distclean-alpine
distclean_archlinux: distclean-archlinux
distclean_ubuntu: distclean-ubuntu
distclean-%::
	docker image rm -f ${PROJECT}_$*:devel 2>/dev/null
	docker image rm -f ${PROJECT}_$*:install 2>/dev/null
	rm -rf build/$*

FORCE:
