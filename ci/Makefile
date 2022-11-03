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
	@echo -e "\tBuild using docker and the host platform."
	@echo -e "\t${BOLD}<distro>_<stage>${RESET}: build a <stage> docker image for a specific distro."
	@echo -e "\t${BOLD}save_<distro>_<stage>${RESET}: Save a <stage> docker image for a specific distro."
	@echo -e "\t${BOLD}sh_<distro>_<stage>${RESET}: run a container using the <stage> docker image specified (debug purpose)."
	@echo -e "\t${BOLD}clean_<distro>_<stage>${RESET}: Remove cache and docker image."
	@echo -e "\t${BOLD}clean_native${RESET}: Remove ALL caches and docker images."
	@echo
	@echo -e "\tWith ${BOLD}<distro>${RESET}:"
	@echo -e "\t\t${BOLD}alpine${RESET} (edge)"
	@echo -e "\t\t${BOLD}archlinux${RESET} (latest)"
	@echo -e "\t\t${BOLD}centos${RESET} (latest)"
	@echo -e "\t\t${BOLD}debian${RESET} (latest)"
	@echo -e "\t\t${BOLD}fedora${RESET} (latest)"
	@echo -e "\t\t${BOLD}opensuse${RESET} (tumbleweed)"
	@echo -e "\t\t${BOLD}ubuntu${RESET} (rolling)"
	@echo -e "\t\t${BOLD}all${RESET} trigger ALL DISTROS."
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
	@echo -e "\te.g. 'make ubuntu_test'"
	@echo
	@echo -e "\tBuild using docker buildx with a platform specified."
	@echo -e "\t${BOLD}<platform>_<stage>${RESET}: build <stage> docker images for ALL DISTROS."
	@echo -e "\t${BOLD}<platform>_<distro>_<stage>${RESET}: build <stage> docker image for a specific distro."
	@echo -e "\t${BOLD}save_<platform>_<stage>${RESET}: Save <stage> docker images for ALL DISTROS."
	@echo -e "\t${BOLD}save_<platform>_<distro>_<stage>${RESET}: Save the <stage> docker image for a specific distro."
	@echo -e "\t${BOLD}sh_<platform>_<distro>_<stage>${RESET}: run a container using the <stage> docker image specified (debug purpose)."
	@echo -e "\t${BOLD}clean_<platform>_<distro>_<stage>${RESET}: Remove cache and docker image."
	@echo -e "\t${BOLD}clean_platforms${RESET}: Remove ALL cache and docker image."
	@echo
	@echo -e "\tWith ${BOLD}<platform>${RESET}:"
	@echo -e "\t\t${BOLD}amd64${RESET}: linux/amd64 (x86_64)"
	@echo -e "\t\t${BOLD}386${RESET}: linux/386 (x86)"
	@echo -e "\t\t${BOLD}arm${RESET}: linux/arm (armv7)"
	@echo -e "\t\t${BOLD}arm64${RESET}: linux/arm64 (aarch64, arm64v8)"
	@echo -e "\t\t${BOLD}mips${RESET}: linux/mips (mips 32bits)"
	@echo -e "\t\t${BOLD}mipsle${RESET}: linux/mipsle (mips 32bits Little Endian)"
	@echo -e "\t\t${BOLD}mips64${RESET}: linux/mips64 (mips 64bits)"
	@echo -e "\t\t${BOLD}mips64le${RESET}: linux/mips64le (mips 64bits Little Endian)"
	@echo -e "\t\t${BOLD}ppc64${RESET}: linux/ppc64 (PowerPC 64Bits)"
	@echo -e "\t\t${BOLD}ppc64le${RESET}: linux/ppc64le (PowerPC 64Bits Little Endian)"
	@echo -e "\t\t${BOLD}riscv64${RESET}: linux/riscv64 (RISC-V 64bits)"
	@echo -e "\t\t${BOLD}s390x${RESET}: linux/s390x (IBM System/390x)"
	@echo -e "\te.g. 'make amd64_ubuntu_test'"
	@echo -e "\tDocker image unavailable: arm64_archlinux"
	@echo
	@echo -e "\tBuild using a toolchain."
	@echo -e "\t${BOLD}<toolchain>_<toolchain_stage>${RESET}: build <stage> docker image for a specific toolchain target."
	@echo -e "\t${BOLD}save_<toolchain>_<toolchain_stage>${RESET}: Save the <stage> docker image for a specific platform."
	@echo -e "\t${BOLD}sh_<toolchain>_<toolchain_stage>${RESET}: run a container using the <stage> docker image specified (debug purpose)."
	@echo -e "\t${BOLD}clean_<toolchain>_<toolchain_stage>${RESET}: Remove cache and docker image."
	@echo -e "\t${BOLD}clean_toolchains${RESET}: Remove ALL cache and docker image."
	@echo
	@echo -e "\tWith ${BOLD}<toolchain>${RESET}:"
	@echo -e "\t\t${BOLD}arm-linux-gnueabihf${RESET} (linaro toolchain)"
	@echo -e "\t\t${BOLD}armv8l-linux-gnueabihf${RESET} (linaro toolchain)"
	@echo -e "\t\t${BOLD}arm-linux-gnueabi${RESET} (linaro toolchain)"
	@echo -e "\t\t${BOLD}armeb-linux-gnueabihf${RESET} (linaro toolchain)"
	@echo -e "\t\t${BOLD}armeb-linux-gnueabi${RESET} (linaro toolchain)"
	@echo -e "\t\t${BOLD}aarch64${RESET} (alias: arm64) (bootlin toolchain)"
	@echo -e "\t\t${BOLD}aarch64be${RESET} (bootlin toolchain)"
	@echo -e "\t\t${BOLD}aarch64-linux-gnu${RESET} (linaro toolchain)"
	@echo -e "\t\t${BOLD}aarch64_be-linux-gnu${RESET} (linaro toolchain)"
	@echo -e "\t\t${BOLD}mips32-r6${RESET} (alias: mips) (codespace toolchain)"
	@echo -e "\t\t${BOLD}mips64-r6${RESET} (alias: mips64) (codespace toolchain)"
	@echo -e "\t\t${BOLD}mips32el-r6${RESET} (alias: mipsle) (codespace toolchain)"
	@echo -e "\t\t${BOLD}mips64el-r6${RESET} (alias: mips64le) (codespace toolchain)"
	@echo -e "\t\t${BOLD}mips32-r2${RESET} (codespace toolchain)"
	@echo -e "\t\t${BOLD}mips64-r2${RESET} (codespace toolchain)"
	@echo -e "\t\t${BOLD}mips32el-r2${RESET} (codespace toolchain)"
	@echo -e "\t\t${BOLD}mips64el-r2${RESET} (codespace toolchain)"
	@echo -e "\t\t${BOLD}ppc-440fp${RESET} (alias: ppc) (bootlin toolchain)"
	@echo -e "\t\t${BOLD}ppc-e500mc${RESET} (bootlin toolchain)"
	@echo -e "\t\t${BOLD}ppc64-power8${RESET} (alias: ppc64) (bootlin toolchain)"
	@echo -e "\t\t${BOLD}ppc64le-power8${RESET} (alias: ppc64le) (bootlin toolchain)"
	@echo -e "\t\t${BOLD}riscv32${RESET} (bootlin toolchain)"
	@echo -e "\t\t${BOLD}riscv64${RESET} (bootlin toolchain)"
	@echo -e "\t\t${BOLD}s390x${RESET} (bootlin toolchain)"
	@echo
	@echo -e "\tWith ${BOLD}<toolchain_stage>${RESET}:"
	@echo -e "\t\t${BOLD}env${RESET}"
	@echo -e "\t\t${BOLD}devel${RESET}"
	@echo -e "\t\t${BOLD}build${RESET}"
	@echo -e "\t\t${BOLD}test${RESET}"
	@echo -e "\te.g. 'make mips64_build'"
	@echo -e "\te.g. 'make aarch64-linux-gnu_test'"
	@echo
	@echo -e "\tBuild using a vagrant machine."
	@echo -e "\t${BOLD}<vm>_<vms_stage>${RESET}: build the vagrant <vm> virtual machine."
	@echo -e "\t${BOLD}sh_<vm>_<lang>${RESET}: ssh to the vagrant machine specified (debug purpose)."
	@echo -e "\t${BOLD}clean_<vm>${RESET}: Remove virtual machine for the specified vm."
	@echo -e "\t${BOLD}clean_vms${RESET}: Remove ALL vagrant box."
	@echo
	@echo -e "\tWith ${BOLD}<vm>${RESET}:"
	@echo -e "\t\t${BOLD}freebsd${RESET} (FreeBSD)"
	@echo
	@echo -e "\tWith ${BOLD}<vms_stage>${RESET}:"
	@echo -e "\t\t${BOLD}build${RESET}"
	@echo
	@echo -e "\tGlobal targets."
	@echo -e "\t${BOLD}clean${RESET}: Remove ALL caches and docker images."
	@echo -e "\t${BOLD}distclean${RESET}: Remove everything."
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
DOCKER_BUILDX_CMD := docker buildx build --no-cache
else
DOCKER_BUILD_CMD := docker build
DOCKER_BUILDX_CMD := docker buildx build
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
#$$(info Create targets: all_$1 $(addsuffix _$1, $(DISTROS)).)
targets_$1 = $(addsuffix _$1, $(DISTROS))
.PHONY: all_$1 $$(targets_$1)
all_$1: $$(targets_$1)
$$(targets_$1): %_$1: docker/%/Dockerfile
	#@docker image rm -f ${IMAGE}:$$*_$1 2>/dev/null
	${DOCKER_BUILD_CMD} --target=$1 --tag ${IMAGE}:$$*_$1 -f $$< ..

#$$(info Create targets: save_all_$1 $(addprefix save_, $(addsuffix _$1, $(DISTROS))) (debug).)
save_targets_$1 = $(addprefix save_, $(addsuffix _$1, $(DISTROS)))
.PHONY: save_all_$1 $$(save_targets_$1)
save_all_$1: $$(save_targets_$1)
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

#$$(info Create targets: clean_all_$1 $(addprefix clean_, $(addsuffix _$1, $(DISTROS))).)
clean_targets_$1 = $(addprefix clean_, $(addsuffix _$1, $(DISTROS)))
.PHONY: clean_all_$1 $$(clean_targets_$1)
clean_all_$1: $$(clean_targets_$1)
$$(clean_targets_$1): clean_%_$1:
	docker image rm -f ${IMAGE}:$$*_$1 2>/dev/null
	rm -f cache/$$*/docker_$1.tar
endef

$(foreach stage,$(STAGES),$(eval $(call make-stage-target,$(stage))))

## MERGE ##
.PHONY: clean_all
clean_all: $(addprefix clean_all_, $(STAGES))
	rm -f $(addprefix cache/, $(DISTROS))

##############
## PLATFORM ##
##############
# ref: https://go.dev/doc/install/source#environment
# ref: https://github.com/containerd/containerd/blob/269548fa27e0089a8b8278fc4fc781d7f65a939b/platforms/platforms.go#L80-L94
PLATFORMS = \
 386 amd64 \
 arm arm64 \
 mips mipsle mips64 mips64le \
 ppc64 ppc64le \
 riscv64 \
 s390x

define make-platform-stage-target =
#$$(info PLATFORM: $1)
#$$(info STAGE: $2)
#$$(info Create targets: $1_all_$2 $(addprefix $1_, $(addsuffix _$2, $(DISTROS))).)
targets_$1_$2 = $(addprefix $1_, $(addsuffix _$2, $(DISTROS)))
.PHONY: $1_all_$2 $$(targets_$1_$2)
$1_all_$2: $$(targets_$1_$2)
$$(targets_$1_$2): $1_%_$2: docker/%/Dockerfile
	#@docker image rm -f ${IMAGE}:$1_$$*_$2 2>/dev/null
	${DOCKER_BUILDX_CMD} --platform linux/$1 --target=$2 --tag ${IMAGE}:$1_$$*_$2 -f $$< ..

#$$(info Create targets: save_$1_all_$2 $(addprefix save_$1_, $(addsuffix _$2, $(DISTROS))) (debug).)
save_targets_$1_$2 = $(addprefix save_$1_, $(addsuffix _$2, $(DISTROS)))
.PHONY: save_$1_all_$2 $$(save_targets_$1_$2)
save_$1_all_$2: $$(save_targets_$1_$2)
$$(save_targets_$1_$2): save_$1_%_$2: cache/$1/%/docker_$2.tar
cache/$1/%/docker_$2.tar: $1_%_$2
	@rm -f $$@
	mkdir -p cache/$1/$$*
	docker save ${IMAGE}:$1_$$*_$2 -o $$@

#$$(info Create targets: $(addprefix sh_$1_, $(addsuffix _$2, $(DISTROS))) (debug).)
sh_targets_$1_$2 = $(addprefix sh_$1_, $(addsuffix _$2, $(DISTROS)))
.PHONY: $$(sh_targets_$1_$2)
$$(sh_targets_$1_$2): sh_$1_%_$2: $1_%_$2
	${DOCKER_RUN_CMD} --platform linux/$1 -it --name ${IMAGE}_$1_$$*_$2 ${IMAGE}:$1_$$*_$2

#$$(info Create targets: clean_$1_all_$2 $(addprefix clean_$1_, $(addsuffix _$2, $(DISTROS))).)
clean_targets_$1_$2 = $(addprefix clean_$1_, $(addsuffix _$2, $(DISTROS)))
.PHONY: clean_$1_all_$2 $$(clean_targets_$1_$2)
clean_$1_all_$2: $$(clean_targets_$1_$2)
$$(clean_targets_$1_$2): clean_$1_%_$2:
	docker image rm -f ${IMAGE}:$1_$$*_$2 2>/dev/null
	rm -f cache/$1/$$*/docker_$2.tar
endef

define make-platform-target =
#$$(info PLATFORM: $1)
$(foreach stage,$(STAGES),$(eval $(call make-platform-stage-target,$1,$(stage))))

# merge
.PHONY: clean_$1
clean_$1: $(addprefix clean_$1_all_, $(STAGES))
	-rmdir $(addprefix cache/$1/, $(DISTROS))
	-rmdir cache/$1
endef

$(foreach platform,$(PLATFORMS),$(eval $(call make-platform-target,$(platform))))

## MERGE ##
.PHONY: clean_platforms
clean_platforms: $(addprefix clean_, $(PLATFORMS))

###############
## TOOLCHAIN ##
###############
TOOLCHAIN_TARGETS = \
 arm-linux-gnueabihf armv8l-linux-gnueabihf arm-linux-gnueabi armeb-linux-gnueabihf armeb-linux-gnueabi \
 aarch64-linux-gnu aarch64_be-linux-gnu \
 mips mips32-r6 mips32-r2 \
 mipsle mips32el-r6 mips32el-r2 \
 mips64 mips64-r6 mips64-r2 \
 mips64le mips64el-r6 mips64el-r2 \
 arm64 aarch64 aarch64be \
 ppc ppc-440fp ppc-e500mc \
 ppc64 ppc64-power8 \
 ppc64le ppc64le-power8 \
 riscv32 riscv64 \
 s390x
TOOLCHAIN_STAGES = env devel build test

define toolchain-stage-target =
#$$(info STAGE: $1)
#$$(info Create targets: toolchain_$1 $(addsuffix _$1, $(TOOLCHAIN_TARGETS)).)
targets_toolchain_$1 = $(addsuffix _$1, $(TOOLCHAIN_TARGETS))
.PHONY: toolchain_$1 $$(targets_toolchain_$1)
toolchain_$1: $$(targets_toolchain_$1)
$$(targets_toolchain_$1): %_$1: docker/toolchain/Dockerfile
	#@docker image rm -f ${IMAGE}:$$*_$1 2>/dev/null
	${DOCKER_BUILD_CMD} \
 --tag ${IMAGE}:$$*_$1 \
 --build-arg TARGET=$$* \
 --target=$1 \
 -f $$< \
 ..

#$$(info Create targets: save_toolchain_$1 $(addprefix save_, $(addsuffix _$1, $(TOOLCHAIN_TARGETS))) (debug).)
save_targets_toolchain_$1 = $(addprefix save_, $(addsuffix _$1, $(TOOLCHAIN_TARGETS)))
.PHONY: save_toolchain_$1 $$(save_targets_toolchain_$1)
save_toolchain_$1: $$(save_targets_toolchain_$1)
$$(save_targets_toolchain_$1): save_%_$1: cache/%/docker_$1.tar
cache/%/docker_$1.tar: %_$1
	@rm -f $$@
	mkdir -p cache/$$*
	docker save ${IMAGE}:$$*_$1 -o $$@

#$$(info Create targets: $(addprefix sh_, $(addsuffix _$1, $(TOOLCHAIN_TARGETS))) (debug).)
sh_targets_toolchain_$1 = $(addprefix sh_, $(addsuffix _$1, $(TOOLCHAIN_TARGETS)))
.PHONY: $$(sh_targets_toolchain_$1)
$$(sh_targets_toolchain_$1): sh_%_$1: %_$1
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$$*_$1 ${IMAGE}:$$*_$1

#$$(info Create targets: clean_toolchain_$1 $(addprefix clean_, $(addsuffix _$1, $(TOOLCHAIN_TARGETS))).)
clean_targets_toolchain_$1 = $(addprefix clean_, $(addsuffix _$1, $(TOOLCHAIN_TARGETS)))
.PHONY: clean_toolchain_$1 $$(clean_targets_toolchain_$1)
clean_toolchain_$1: $$(clean_targets_toolchain_$1)
$$(clean_targets_toolchain_$1): clean_%_$1:
	docker image rm -f ${IMAGE}:$$*_$1 2>/dev/null
	rm -f cache/$$*/docker_$1.tar
endef

$(foreach stage,$(TOOLCHAIN_STAGES),$(eval $(call toolchain-stage-target,$(stage))))

## MERGE ##
.PHONY: clean_toolchains
clean_toolchains: $(addprefix clean_toolchain_, $(TOOLCHAIN_STAGES))
	-rmdir $(addprefix cache/, $(TOOLCHAIN_TARGETS))

#############
## VAGRANT ##
#############
VMS = freebsd

vms_targets = $(addsuffix _build, $(VMS))
.PHONY: vms_build $(vms_targets)
vms_build: $(vms_targets)
$(vms_targets): %_build: vagrant/%/Vagrantfile
	@cd vagrant/$* && vagrant destroy -f
	cd vagrant/$* && vagrant up

sh_vms_targets = $(addprefix sh_,$(addsuffix _build, $(VMS)))
.PHONY: $(sh_vms_targets)
$(sh_vms_targets): sh_%_build: vagrant/%/Vagrantfile
	cd vagrant/$* && vagrant up
	cd vagrant/$* && vagrant ssh

clean_vms_targets = $(addprefix clean_, $(VMS))
.PHONY: clean_vms $(clean_vms_targets)
clean_vms: $(clean_vms_targets)
$(clean_vms_targets): clean_%: vagrant/%/Vagrantfile
	cd vagrant/$* && vagrant destroy -f
	-rm -rf vagrant/$*/.vagrant

###########
## CLEAN ##
###########
.PHONY: clean
clean: clean_all clean_platforms clean_toolchains clean_vms
	docker container prune -f
	docker image prune -f
	-rmdir cache

.PHONY: distclean
distclean: clean
	-docker container rm -f $$(docker container ls -aq)
	-docker image rm -f $$(docker image ls -aq)
	-vagrant box remove -f generic/freebsd12
