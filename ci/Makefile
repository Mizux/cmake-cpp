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
	@echo -e "\t${BOLD}<stage>${RESET}: build <stage> docker images for ALL DISTROS."
	@echo -e "\t${BOLD}<distro>_<stage>${RESET}: build <stage> docker image for a specific distro."
	@echo -e "\t${BOLD}save_<stage>${RESET}: Save <stage> docker images for ALL DISTROS."
	@echo -e "\t${BOLD}save_<distro>_<stage>${RESET}: Save the <stage> docker image for a specific distro."
	@echo -e "\t${BOLD}sh_<distro>_<stage>${RESET}: run a container using the <stage> docker image specified (debug purpose)."
	@echo
	@echo -e "\tWith ${BOLD}<stage>${RESET}:"
	@echo -e "\t\t${BOLD}env${RESET}"
	@echo -e "\t\t${BOLD}devel${RESET}"
	@echo -e "\t\t${BOLD}build${RESET}"
	@echo -e "\t\t${BOLD}test${RESET}"
	@echo -e "\t\t${BOLD}install_env${RESET}"
	@echo -e "\t\t${BOLD}install_devel${RESET}"
	@echo -e "\t\t${BOLD}install_build${RESET}"
	@echo -e "\t\t${BOLD}install_test${RESET}"
	@echo -e "\te.g. 'make build'"
	@echo
	@echo -e "\tWith ${BOLD}<distro>${RESET}:"
	@echo -e "\t\t${BOLD}alpine${RESET} (edge)"
	@echo -e "\t\t${BOLD}archlinux${RESET} (latest)"
	@echo -e "\t\t${BOLD}centos${RESET} (latest)"
	@echo -e "\t\t${BOLD}debian${RESET} (latest)"
	@echo -e "\t\t${BOLD}fedora${RESET} (latest)"
	@echo -e "\t\t${BOLD}opensuse${RESET} (tumbleweed)"
	@echo -e "\t\t${BOLD}ubuntu${RESET} (rolling)"
	@echo -e "\te.g. 'make ubuntu_test'"
	@echo
	@echo -e "\t${BOLD}<VM>${RESET}: build the vagrant <VM> virtual machine."
	@echo
	@echo -e "\t${BOLD}<VM>${RESET}:"
	@echo -e "\t\t${BOLD}freebsd${RESET} (FreeBSD)"
	@echo
	@echo -e "\t${BOLD}clean${RESET}: Remove cache and ALL docker images."
	@echo -e "\t${BOLD}clean_<distro>${RESET}: Remove cache and docker images for the specified distro."
	@echo -e "\t${BOLD}clean_<vm>${RESET}: Remove virtual machine for the specified vm."
	@echo
	@echo -e "\t${BOLD}NOCACHE=1${RESET}: use 'docker build --no-cache' when building container (default use cache)."
	@echo
	@echo -e "branch: $(BRANCH)"
	@echo -e "sha1: $(SHA1)"

# Need to add cmd_distro to PHONY otherwise target are ignored since they do not
# contain recipe (using FORCE do not work here)
.PHONY: all
all: build

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

############
## STAGES ##
############
STAGES = env devel build test install_env install_devel install_build install_test
define make-stage-target =
#$$(info STAGE: $1)
#$$(info Create targets: $1 $(addsuffix _$1, $(DISTROS)).)
targets_$1 = $(addsuffix _$1, $(DISTROS))
.PHONY: $1 $$(targets_$1)
$1: $$(targets_$1)
$$(targets_$1): %_$1: docker/%/Dockerfile
	#@docker image rm -f ${IMAGE}:$$*_$1 2>/dev/null
	${DOCKER_BUILD_CMD} --target=$1 --tag ${IMAGE}:$$*_$1 -f $$< ..

#$$(info Create targets: save_$1 $(addprefix save_, $(addsuffix _$1, $(DISTROS))) (debug).)
save_targets_$1 = $(addprefix save_, $(addsuffix _$1, $(DISTROS)))
.PHONY: save_$1 $$(save_targets_$1)
save_$1: $$(save_targets_$1)
$$(save_targets_$1): save_%_$1: cache/%/docker_$1.tar
cache/%/docker_$1.tar: %_$1
	@rm -f $$@
	mkdir -p cache/$$*
	docker save ${IMAGE}:$$*_$1 -o $$@

#$$(info Create targets: $(addprefix sh_, $(addsuffix _$1, $(DISTROS))) (debug).)
sh_targets_$1 = $(addprefix sh_, $(addsuffix _$1, $(DISTROS)))
.PHONY: $$(sh_targets_$1)
$$(sh_targets_$1): sh_%_$1: %_$1
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$$*_$1 ${IMAGE}:$$*_$1

#$$(info Create targets: $(addprefix clean_, $(addsuffix _$1, $(DISTROS))).)
clean_targets_$1 = $(addprefix clean_, $(addsuffix _$1, $(DISTROS)))
.PHONY: clean_$1 $$(clean_targets_$1)
clean_$1: $$(clean_targets_$1)
$$(clean_targets_$1): clean_%_$1:
	docker image rm -f ${IMAGE}:$$*_$1 2>/dev/null
	rm -f cache/$$*/docker_$1.tar
endef

$(foreach stage,$(STAGES),$(eval $(call make-stage-target,$(stage))))

#############
## VAGRANT ##
#############
VMS = freebsd

$(VMS): %: vagrant/%/Vagrantfile
	@cd vagrant/$* && vagrant destroy -f
	cd vagrant/$* && vagrant up

############
## ARM 64 ##
############
STEPS = env devel build test
#$(info Create targets: $(addprefix arm_, $(STEPS)))
arm_targets = $(addprefix arm_, $(STEPS))
.PHONY: $(arm_targets)
$(arm_targets): arm_%: docker/arm/Dockerfile
	#@docker image rm -f ${IMAGE}:$@ 2>/dev/null
	${DOCKER_BUILD_CMD} --target=$* --tag ${IMAGE}:$@ -f $< ..

save_arm_targets = $(addprefix save_arm_, $(STEPS))
.PHONY: $(save_arm_targets)
$(save_arm_targets): save_arm_%: cache/arm/docker_%.tar
cache/arm/docker_%.tar: arm_%
	@rm -f $@
	mkdir -p cache/arm
	docker save ${IMAGE}:$< -o $@

sh_arm_targets = $(addprefix sh_arm_, $(STEPS))
.PHONY: $(sh_arm_targets)
$(sh_arm_targets): sh_arm_%: arm_%
	${DOCKER_RUN_CMD} -it --name ${PROJECT}_$< ${IMAGE}:$<

clean_arm_targets = $(addprefix clean_arm_, $(STEPS))
.PHONY: $(clean_arm_targets)
$(clean_arm_targets): clean_arm_%
	docker image rm -f ${IMAGE}:arm_$* 2>/dev/null
	rm -f cache/arm/docker_$*.tar

## CLEAN ##
clean_targets = $(addprefix clean_, $(DISTROS))
clean_vms = $(addprefix clean_, $(VMS))
.PHONY: clean $(clean_targets)
clean: $(clean_targets) $(clean_vms)
	docker container prune -f
	docker image prune -f
	-rmdir cache
$(clean_targets): clean_%: $(addprefix clean_%_, $(STAGES))
	-rmdir cache/$*
$(clean_vms): clean_%:
	cd vagrant/$* && vagrant destroy -f
	-rm -rf vagrant/$*/.vagrant

.PHONY: distclean
distclean: clean
	-docker container rm -f $$(docker container ls -aq)
	-docker image rm -f $$(docker image ls -aq)
	-vagrant box remove -f generic/freebsd12
