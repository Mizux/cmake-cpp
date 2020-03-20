PROJECT := cmake-cpp
BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
SHA1 := $(shell git rev-parse --verify HEAD)

# General commands
.PHONY: help
BOLD=\e[1m
RESET=\e[0m

help:
	@echo -e "${BOLD}SYNOPSIS${RESET}"
	@echo -e "\tmake <target> [NOCACHE=1]"
	@echo
	@echo -e "${BOLD}DESCRIPTION${RESET}"
	@echo -e "\ttest build inside docker container to have a reproductible build."
	@echo
	@echo -e "${BOLD}MAKE TARGETS${RESET}"
	@echo -e "\t${BOLD}help${RESET}: display this help and exit."
	@echo
	@echo -e "\t${BOLD}env${RESET}: build all env docker images."
	@echo -e "\t${BOLD}env_<distro>${RESET}: build the env docker image for a specific distro."
	@echo -e "\t${BOLD}save_env${RESET}: Save all env docker images."
	@echo -e "\t${BOLD}save_env_<distro>${RESET}: Save the env docker image for a specific distro."
	@echo -e "\t${BOLD}sh_env_<distro>${RESET}: run a container using the env docker image (debug purpose)."
	@echo
	@echo -e "\t${BOLD}devel${RESET}: build all devel docker images."
	@echo -e "\t${BOLD}devel_<distro>${RESET}: build the devel docker image for a specific distro."
	@echo -e "\t${BOLD}save_devel${RESET}: Save all devel docker images."
	@echo -e "\t${BOLD}save_devel_<distro>${RESET}: Save the devel docker image for a specific distro."
	@echo -e "\t${BOLD}sh_devel_<distro>${RESET}: run a container using the devel docker image (debug purpose)."
	@echo
	@echo -e "\t${BOLD}build${RESET}: build all build docker images."
	@echo -e "\t${BOLD}build_<distro>${RESET}: build the build docker image for a specific distro."
	@echo -e "\t${BOLD}save_build${RESET}: Save all build docker images."
	@echo -e "\t${BOLD}save_build_<distro>${RESET}: Save the build docker image for a specific distro."
	@echo -e "\t${BOLD}sh_build_<distro>${RESET}: run a container using the build docker image (debug purpose)."
	@echo
	@echo -e "\t${BOLD}test${RESET}: test using all build docker images."
	@echo -e "\t${BOLD}test_<distro>${RESET}: test using the build image."
	@echo -e "\t${BOLD}sh_<distro>${RESET}: run a container using the devel image (debug purpose)."
	@echo
	@echo -e "\t${BOLD}install${RESET}: execute the cmake target ${BOLD}install${RESET} using all devel image container, then create an install image with it."
	@echo -e "\t${BOLD}install_<distro>${RESET}: execute the cmake target ${BOLD}install${RESET} using the devel image container specified, then create an install image with it."
	@echo -e "\t${BOLD}test_install${RESET}: configure, build, install then test a sample project against it using all ${BOLD}install${RESET} image containers."
	@echo -e "\t${BOLD}test_install_<distro>${RESET}: configure, build, install then test a sample project against it using the ${BOLD}install${RESET} image container specified."
	@echo -e "\t${BOLD}sh_install_<distro>${RESET}: run a container using the install image (debug purpose)."
	@echo
	@echo -e "\t${BOLD}clean${RESET}: Remove cache and docker image."
	@echo -e "\t${BOLD}clean_<distro>${RESET}: Remove cache and docker image for the specified distro."
	@echo
	@echo -e "\t${BOLD}<distro>${RESET}:"
	@echo -e "\t\t${BOLD}alpine${RESET} (edge)"
	@echo -e "\t\t${BOLD}archlinux${RESET} (latest)"
	@echo -e "\t\t${BOLD}centos${RESET} (latest)"
	@echo -e "\t\t${BOLD}debian${RESET} (latest)"
	@echo -e "\t\t${BOLD}fedora${RESET} (latest)"
	@echo -e "\t\t${BOLD}opensuse${RESET} (tumbleweed)"
	@echo -e "\t\t${BOLD}ubuntu${RESET} (rolling)"
	@echo -e "\te.g. 'make test_ubuntu'"
	@echo
	@echo -e "\t${BOLD}NOCACHE=1${RESET}: use 'docker build --no-cache' when building container (default use cache)."
	@echo
	@echo -e "branch: $(BRANCH)"
	@echo -e "sha1: $(SHA1)"

# Need to add cmd_distro to PHONY otherwise target are ignored since they do not
# contain recipe (using FORCE do not work here)
.PHONY: all
all: devel

# Delete all implicit rules to speed up makefile
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:
# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =
# Keep all intermediate files
# ToDo: try to remove it later
.SECONDARY:

# Docker image name prefix.
IMAGE := ${PROJECT}

ifdef NOCACHE
DOCKER_BUILD_CMD := docker build --no-cache
else
DOCKER_BUILD_CMD := docker build
endif

DOCKER_RUN_CMD := docker run --rm --init --net=host

# Currently supported distro
DISTROS = alpine archlinux centos debian fedora opensuse ubuntu

# $* stem
# $< first prerequist
# $@ target name


## ENV ##
# Build the env image.
targets = $(addprefix env_, $(DISTROS))
.PHONY: env $(targets)
env: $(targets)
$(targets): env_%: docker/%/Dockerfile
	@docker image rm -f ${IMAGE}:$*_env 2>/dev/null
	${DOCKER_BUILD_CMD} --target=env --tag ${IMAGE}:$*_env -f $< docker/$*

# Save the env image (debug).
targets = $(addprefix save_env_, $(DISTROS))
.PHONY: save_env $(targets)
save_env: $(targets)
$(targets): save_env_%: cache/%/docker_env.tar
cache/%/docker_env.tar: env_%
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_env -o $@

# Run a container using the env image (debug).
targets = $(addprefix sh_env_, $(DISTROS))
.PHONY: $(targets)
$(targets): sh_env_%: env_%
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$* ${IMAGE}:$*_env /bin/sh


## DEVEL ##
# Build the devel image.
targets = $(addprefix devel_, $(DISTROS))
.PHONY: devel $(targets)
devel: $(targets)
$(targets): devel_%: docker/%/Dockerfile ../CMakeLists.txt ../cmake
	@docker image rm -f ${IMAGE}:$*_devel 2>/dev/null
	${DOCKER_BUILD_CMD} --target=devel --tag ${IMAGE}:$*_devel -f $< ..

# Save the devel image (debug).
targets = $(addprefix save_devel_, $(DISTROS))
.PHONY: save_devel $(targets)
save_devel: $(targets)
$(targets): save_devel_%: cache/%/docker_devel.tar
cache/%/docker_devel.tar: devel_%
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_devel -o $@

# Run a container using the devel image (debug).
targets = $(addprefix sh_devel_, $(DISTROS))
.PHONY: $(targets)
$(targets): sh_devel_%: devel_%
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$* ${IMAGE}:$*_devel /bin/sh


## BUILD ##
# Build the build image.
targets = $(addprefix build_, $(DISTROS))
.PHONY: build $(targets)
build: $(targets)
$(targets): build_%: docker/%/Dockerfile ../CMakeLists.txt ../cmake
	@docker image rm -f ${IMAGE}:$*_build 2>/dev/null
	${DOCKER_BUILD_CMD} --target=build --tag ${IMAGE}:$*_build -f $< ..

# Save the build image (debug).
targets = $(addprefix save_build_, $(DISTROS))
.PHONY: save_build $(targets)
save_build: $(targets)
$(targets): save_build_%: cache/%/docker_build.tar
cache/%/docker_build.tar: build_%
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_build -o $@

# Run a container using the build image (debug).
targets = $(addprefix sh_build_, $(DISTROS))
.PHONY: $(targets)
$(targets): sh_build_%: build_%
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$* ${IMAGE}:$*_build /bin/sh


## TEST ##
# Run the tests.
targets = $(addprefix test_, $(DISTROS))
.PHONY: test $(targets)
test: $(targets)
$(targets): test_%: build_%
	${DOCKER_RUN_CMD} -t --name ${IMAGE}_$* ${IMAGE}:$*_build \
 cmake --build build --target test

## INSTALL ##
# Build the instqll image.
targets = $(addprefix install_, $(DISTROS))
.PHONY: install $(targets)
install: $(targets)
$(targets): install_%: docker/%/Dockerfile sample
	@docker image rm -f ${IMAGE}:$*_install 2>/dev/null
	${DOCKER_BUILD_CMD} --target=install --tag ${IMAGE}:$*_install -f $< ..

# Save the install image (debug).
targets = $(addprefix save_install_, $(DISTROS))
.PHONY: save_install $(targets)
save_install: $(targets)
$(targets): save_install_%: cache/%/docker_install.tar
cache/%/docker_install.tar: docker/%/Dockerfile \
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_install -o $@

# DOCKER BASH INSTALL (debug)
targets = $(addprefix sh_install_, $(DISTROS))
.PHONY: $(targets)
$(targets): sh_install_%: cache/%/docker_install.tar
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$* ${IMAGE}:$*_install /bin/sh

# TEST INSTALL
targets = $(addprefix test_install_, $(DISTROS))
.PHONY: test_install $(targets)
test_install: $(targets)
$(targets): test_install_%: cache/%/docker_install.tar sample
	@docker load -i cache/$*/docker_install.tar
	${DOCKER_RUN_CMD} -t --name ${IMAGE}_$* ${IMAGE}:$*_install /bin/sh -c \
 "cmake -H. -Bbuild; \
 cmake --build build --target all; \
 cmake --build build --target test; \
 cmake --build build --target install"

# CLEAN
targets = $(addprefix clean_, $(DISTROS))
.PHONY: clean $(targets)
clean: $(targets)
	-rmdir cache
$(targets): clean_%:
	docker container prune -f
	docker image prune -f
	-docker image rm -f ${IMAGE}:$*_install 2>/dev/null
	-docker image rm -f ${IMAGE}:$*_build 2>/dev/null
	-docker image rm -f ${IMAGE}:$*_devel 2>/dev/null
	-docker image rm -f ${IMAGE}:$*_env 2>/dev/null
	-rm -f cache/$*/docker_install.tar
	-rm -f cache/$*/docker_build.tar
	-rm -f cache/$*/docker_devel.tar
	-rm -f cache/$*/docker_env.tar
	-rmdir cache/$*

.PHONY: distclean
distclean: clean
	-docker container rm -f $$(docker container ls -aq)
	-docker image rm -f $$(docker image ls -aq)
