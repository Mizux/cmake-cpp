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
	@echo -e "\t${BOLD}<stage>${RESET}: build all <stage> docker images."
	@echo -e "\t${BOLD}<distro>_<stage>${RESET}: build the <stage> docker image for a specific distro."
	@echo -e "\t${BOLD}save_<stage>${RESET}: Save all <stage> docker images."
	@echo -e "\t${BOLD}save_<distro>_<stage>${RESET}: Save the <stage> docker image for a specific distro."
	@echo -e "\t${BOLD}sh_<distro>_<stage>${RESET}: run a container using the <stage> docker image (debug purpose)."
	@echo
	@echo -e "\t${BOLD}<stage>${RESET}:"
	@echo -e "\t\t${BOLD}env${RESET}"
	@echo -e "\t\t${BOLD}devel${RESET}"
	@echo -e "\t\t${BOLD}build${RESET}"
	@echo -e "\t\t${BOLD}test${RESET}"
	@echo -e "\t\t${BOLD}install_devel${RESET}"
	@echo -e "\t\t${BOLD}install_build${RESET}"
	@echo -e "\t\t${BOLD}install_test${RESET}"
	@echo
	@echo -e "\t${BOLD}<distro>${RESET}:"
	@echo -e "\t\t${BOLD}alpine${RESET} (edge)"
	@echo -e "\t\t${BOLD}archlinux${RESET} (latest)"
	@echo -e "\t\t${BOLD}centos${RESET} (latest)"
	@echo -e "\t\t${BOLD}debian${RESET} (latest)"
	@echo -e "\t\t${BOLD}fedora${RESET} (latest)"
	@echo -e "\t\t${BOLD}opensuse${RESET} (tumbleweed)"
	@echo -e "\t\t${BOLD}ubuntu${RESET} (rolling)"
	@echo -e "\te.g. 'make ubuntu_test'"
	@echo
	@echo -e "\t${BOLD}clean${RESET}: Remove cache and ALL docker images."
	@echo -e "\t${BOLD}clean_<distro>${RESET}: Remove cache and docker images for the specified distro."
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
targets = $(addsuffix _env, $(DISTROS))
.PHONY: env $(targets)
env: $(targets)
$(targets): %_env: docker/%/Dockerfile
	#@docker image rm -f ${IMAGE}:$*_env 2>/dev/null
	${DOCKER_BUILD_CMD} --target=env --tag ${IMAGE}:$*_env -f $< ..

# Save the env image (debug).
targets = $(addprefix save_, $(addsuffix _env, $(DISTROS)))
.PHONY: save_env $(targets)
save_env: $(targets)
$(targets): save_%_env: cache/%/docker_env.tar
cache/%/docker_env.tar: %_env
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_env -o $@

# Run a container using the env image (debug).
targets = $(addprefix sh_, $(addsuffix _env, $(DISTROS)))
.PHONY: $(targets)
$(targets): sh_%_env: %_env
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$*_env ${IMAGE}:$*_env /bin/sh


## DEVEL ##
# Build the devel image.
targets = $(addsuffix _devel, $(DISTROS))
.PHONY: devel $(targets)
devel: $(targets)
$(targets): %_devel: docker/%/Dockerfile
	#@docker image rm -f ${IMAGE}:$*_devel 2>/dev/null
	${DOCKER_BUILD_CMD} --target=devel --tag ${IMAGE}:$*_devel -f $< ..

# Save the devel image (debug).
targets = $(addprefix save_, $(addsuffix _devel, $(DISTROS)))
.PHONY: save_devel $(targets)
save_devel: $(targets)
$(targets): save_%_devel: cache/%/docker_devel.tar
cache/%/docker_devel.tar: %_devel
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_devel -o $@

# Run a container using the devel image (debug).
targets = $(addprefix sh_, $(addsuffix _devel, $(DISTROS)))
.PHONY: $(targets)
$(targets): sh_%_devel: %_devel
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$*_devel ${IMAGE}:$*_devel /bin/sh


## BUILD ##
# Build the build image.
targets = $(addsuffix _build, $(DISTROS))
.PHONY: build $(targets)
build: $(targets)
$(targets): %_build: docker/%/Dockerfile
	#@docker image rm -f ${IMAGE}:$*_build 2>/dev/null
	${DOCKER_BUILD_CMD} --target=build --tag ${IMAGE}:$*_build -f $< ..

# Save the build image (debug).
targets = $(addprefix save_, $(addsuffix _build, $(DISTROS)))
.PHONY: save_build $(targets)
save_build: $(targets)
$(targets): save_%_build: cache/%/docker_build.tar
cache/%/docker_build.tar: %_build
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_build -o $@

# Run a container using the build image (debug).
targets = $(addprefix sh_, $(addsuffix _build, $(DISTROS)))
.PHONY: $(targets)
$(targets): sh_%_build: %_build
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$*_build ${IMAGE}:$*_build /bin/sh


## TEST ##
# Build the test image.
targets = $(addsuffix _test, $(DISTROS))
.PHONY: test $(targets)
test: $(targets)
$(targets): %_test: docker/%/Dockerfile
	#@docker image rm -f ${IMAGE}:$*_test 2>/dev/null
	${DOCKER_BUILD_CMD} --target=test --tag ${IMAGE}:$*_test -f $< ..

# Save the test image (debug).
targets = $(addprefix save_, $(addsuffix _test, $(DISTROS)))
.PHONY: save_test $(targets)
save_test: $(targets)
$(targets): save_%_test: cache/%/docker_test.tar
cache/%/docker_test.tar: %_test
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_test -o $@

# Run a container using the test image (debug).
targets = $(addprefix sh_, $(addsuffix _test, $(DISTROS)))
.PHONY: $(targets)
$(targets): sh_%_test: %_test
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$*_test ${IMAGE}:$*_test /bin/sh


## INSTALL_DEVEL ##
# Build the install_devel image.
targets = $(addsuffix _install_devel, $(DISTROS))
.PHONY: install_devel $(targets)
install_devel: $(targets)
$(targets): %_install_devel: docker/%/Dockerfile
	#@docker image rm -f ${IMAGE}:$*_install_devel 2>/dev/null
	${DOCKER_BUILD_CMD} --target=install_devel --tag ${IMAGE}:$*_install_devel -f $< ..

# Save the install_devel image (debug).
targets = $(addprefix save_, $(addsuffix _install_devel, $(DISTROS)))
.PHONY: save_install_devel $(targets)
save_install_devel: $(targets)
$(targets): save_%_install_devel: cache/%/docker_install_devel.tar
cache/%/docker_install_devel.tar: %_install_devel
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_install_devel -o $@

# Run a container using the install_devel image (debug).
targets = $(addprefix sh_, $(addsuffix _install_devel, $(DISTROS)))
.PHONY: $(targets)
$(targets): sh_%_install_devel: %_install_devel
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$*_install_devel ${IMAGE}:$*_install_devel /bin/sh


## INSTALL_BUILD ##
# Build the install_build image.
targets = $(addsuffix _install_build, $(DISTROS))
.PHONY: install_build $(targets)
install_build: $(targets)
$(targets): %_install_build: docker/%/Dockerfile
	#@docker image rm -f ${IMAGE}:$*_install_build 2>/dev/null
	${DOCKER_BUILD_CMD} --target=install_build --tag ${IMAGE}:$*_install_build -f $< ..

# Save the install_build image (debug).
targets = $(addprefix save_, $(addsuffix _install_build, $(DISTROS)))
.PHONY: save_install_build $(targets)
save_install_build: $(targets)
$(targets): save_%_install_build: cache/%/docker_install_build.tar
cache/%/docker_install_build.tar: %_install_build
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_install_build -o $@

# Run a container using the install_build image (debug).
targets = $(addprefix sh_, $(addsuffix _install_build, $(DISTROS)))
.PHONY: $(targets)
$(targets): sh_%_install_build: %_install_build
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$*_install_build ${IMAGE}:$*_install_build /bin/sh


## INSTALL_TEST ##
# Build the install_test image.
targets = $(addsuffix _install_test, $(DISTROS))
.PHONY: install_test $(targets)
install_test: $(targets)
$(targets): %_install_test: docker/%/Dockerfile
	#@docker image rm -f ${IMAGE}:$*_install_test 2>/dev/null
	${DOCKER_BUILD_CMD} --target=install_test --tag ${IMAGE}:$*_install_test -f $< ..

# Save the install_test image (debug).
targets = $(addprefix save_, $(addsuffix _install_test, $(DISTROS)))
.PHONY: save_install_test $(targets)
save_install_test: $(targets)
$(targets): save_%_install_test: cache/%/docker_install_test.tar
cache/%/docker_install_test.tar: %_install_test
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_install_test -o $@

# Run a container using the install_test image (debug).
targets = $(addprefix sh_, $(addsuffix _install_test, $(DISTROS)))
.PHONY: $(targets)
$(targets): sh_%_install_test: %_install_test
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$*_install_test ${IMAGE}:$*_install_test /bin/sh


## CLEAN ##
targets = $(addprefix clean_, $(DISTROS))
.PHONY: clean $(targets)
clean: $(targets)
	-rmdir cache
$(targets): clean_%:
	docker container prune -f
	docker image prune -f
	-docker image rm -f ${IMAGE}:$*_install_test 2>/dev/null
	-docker image rm -f ${IMAGE}:$*_install_build 2>/dev/null
	-docker image rm -f ${IMAGE}:$*_install_devel 2>/dev/null
	-docker image rm -f ${IMAGE}:$*_test 2>/dev/null
	-docker image rm -f ${IMAGE}:$*_build 2>/dev/null
	-docker image rm -f ${IMAGE}:$*_devel 2>/dev/null
	-docker image rm -f ${IMAGE}:$*_env 2>/dev/null
	-rm -f cache/$*/docker_install_test.tar
	-rm -f cache/$*/docker_install_build.tar
	-rm -f cache/$*/docker_install_devel.tar
	-rm -f cache/$*/docker_test.tar
	-rm -f cache/$*/docker_build.tar
	-rm -f cache/$*/docker_devel.tar
	-rm -f cache/$*/docker_env.tar
	-rmdir cache/$*

.PHONY: distclean
distclean: clean
	-docker container rm -f $$(docker container ls -aq)
	-docker image rm -f $$(docker image ls -aq)
