#!/usr/bin/env bash
set -eo pipefail

function extract() {
  echo "Extracting ${1}..."
  case $1 in
    *.tar.bz2)   tar xjf "$1"    ;;
    *.tar.xz)    tar xJf "$1"    ;;
    *.tar.gz)    tar xzf "$1"    ;;
    *)
      >&2 echo "don't know how to extract '$1'..."
      exit 1
  esac
}

function unpack() {
  mkdir -p "${ARCHIVE_DIR}"
  cd "${ARCHIVE_DIR}" || exit 2
  local -r URL=$1
  local -r RELATIVE_DIR=$2
  local -r DESTINATION="${ARCHIVE_DIR}/${RELATIVE_DIR}"
  if [[  ! -d "${DESTINATION}" ]] ; then
    echo "Downloading ${URL}..."
    local -r ARCHIVE_NAME=$(basename "${URL}")
    [[ -f "${ARCHIVE_NAME}" ]] || wget --no-verbose "${URL}"
    extract "${ARCHIVE_NAME}"
    rm -f "${ARCHIVE_NAME}"
  fi
}

function install_qemu() {
  if [[ "${QEMU_ARCH}" == "DISABLED" ]]; then
    >&2 echo 'QEMU is disabled !'
    return 0
  fi
  local -r QEMU_VERSION=${QEMU_VERSION:=9.0.2}
  local -r QEMU_TARGET=${QEMU_ARCH}-linux-user

  if echo "${QEMU_VERSION} ${QEMU_TARGET}" | cmp --silent "${QEMU_INSTALL}/.build" -; then
    echo "qemu ${QEMU_VERSION} up to date!"
    return 0
  fi

  echo "QEMU_VERSION: ${QEMU_VERSION}"
  echo "QEMU_TARGET: ${QEMU_TARGET}"

  rm -rf "${QEMU_INSTALL}"

  # Checking for a tarball before downloading makes testing easier :-)
  local -r QEMU_URL="https://download.qemu.org/qemu-${QEMU_VERSION}.tar.xz"
  local -r QEMU_DIR="qemu-${QEMU_VERSION}"
  unpack "${QEMU_URL}" "${QEMU_DIR}"
  cd "${QEMU_DIR}" || exit 2

  ./configure \
    --prefix="${QEMU_INSTALL}" \
    --target-list="${QEMU_TARGET}" \
    --audio-drv-list= \
    --disable-brlapi \
    --disable-curl \
    --disable-curses \
    --disable-docs \
    --disable-gcrypt \
    --disable-gnutls \
    --disable-gtk \
    --disable-libnfs \
    --disable-libssh \
    --disable-nettle \
    --disable-opengl \
    --disable-sdl \
    --disable-virglrenderer \
    --disable-vte

  # wrapper on ninja
  make -j8
  make install

  echo "$QEMU_VERSION $QEMU_TARGET" > "${QEMU_INSTALL}/.build"
}

function assert_defined(){
  if [[ -z "${!1}" ]]; then
    >&2 echo "Variable '${1}' must be defined"
    exit 1
  fi
}

function clean_build() {
  # Cleanup previous build
  rm -rf "${BUILD_DIR}"
  mkdir -p "${BUILD_DIR}"
}

function expand_bootlin_config() {
  # ref: https://toolchains.bootlin.com/
  case "${TARGET}" in
    "arm" | "armv7-eabihf")
      local -r TOOLCHAIN_URL="https://toolchains.bootlin.com/downloads/releases/toolchains/armv7-eabihf/tarballs/armv7-eabihf--glibc--stable-2024.05-1.tar.xz"
      local -r GCC_PREFIX="arm"
      local -r GCC_SUFFIX="eabihf"
      ;;
    "armeb" | "armebv7-eabihf")
      local -r TOOLCHAIN_URL="https://toolchains.bootlin.com/downloads/releases/toolchains/armebv7-eabihf/tarballs/armebv7-eabihf--glibc--stable-2024.05-1.tar.xz"
      local -r GCC_PREFIX="armeb"
      local -r GCC_SUFFIX="eabihf"
      ;;
    "arm64" | "aarch64")
      local -r TOOLCHAIN_URL="https://toolchains.bootlin.com/downloads/releases/toolchains/aarch64/tarballs/aarch64--glibc--stable-2024.05-1.tar.xz"
      local -r GCC_PREFIX="aarch64"
      local -r GCC_SUFFIX=""
      ;;
    "arm64be" | "aarch64be")
      local -r TOOLCHAIN_URL="https://toolchains.bootlin.com/downloads/releases/toolchains/aarch64be/tarballs/aarch64be--glibc--stable-2024.05-1.tar.xz"
      local -r GCC_PREFIX="aarch64_be"
      local -r GCC_SUFFIX=""
      ;;
    "ppc" | "ppc-440fp")
      local -r TOOLCHAIN_URL="https://toolchains.bootlin.com/downloads/releases/toolchains/powerpc-440fp/tarballs/powerpc-440fp--glibc--stable-2024.05-1.tar.xz"
      local -r GCC_PREFIX="powerpc"
      local -r GCC_SUFFIX=""
      ;;
    "ppc-e500mc")
      local -r TOOLCHAIN_URL="https://toolchains.bootlin.com/downloads/releases/toolchains/powerpc-e500mc/tarballs/powerpc-e500mc--glibc--stable-2024.05-1.tar.xz"
      local -r GCC_PREFIX="powerpc"
      local -r GCC_SUFFIX=""
      QEMU_ARGS+=( -cpu "e500mc" )
      ;;
    "ppc64" | "ppc64-power8")
      local -r TOOLCHAIN_URL="https://toolchains.bootlin.com/downloads/releases/toolchains/powerpc64-power8/tarballs/powerpc64-power8--glibc--stable-2024.05-1.tar.xz"
      local -r GCC_PREFIX="powerpc64"
      local -r GCC_SUFFIX=""
      ;;
    "ppc64le" | "ppc64le-power8")
      local -r TOOLCHAIN_URL="https://toolchains.bootlin.com/downloads/releases/toolchains/powerpc64le-power8/tarballs/powerpc64le-power8--glibc--stable-2024.05-1.tar.xz"
      local -r GCC_PREFIX="powerpc64le"
      local -r GCC_SUFFIX=""
      ;;
    "riscv32")
      local -r TOOLCHAIN_URL="https://toolchains.bootlin.com/downloads/releases/toolchains/riscv32-ilp32d/tarballs/riscv32-ilp32d--glibc--bleeding-edge-2024.05-1.tar.xz"
      local -r GCC_PREFIX="riscv32"
      local -r GCC_SUFFIX=""
      ;;
    "riscv64")
      local -r TOOLCHAIN_URL="https://toolchains.bootlin.com/downloads/releases/toolchains/riscv64-lp64d/tarballs/riscv64-lp64d--glibc--stable-2024.05-1.tar.xz"
      local -r GCC_PREFIX="riscv64"
      local -r GCC_SUFFIX=""
      ;;
    "s390x")
      local -r TOOLCHAIN_URL="https://toolchains.bootlin.com/downloads/releases/toolchains/s390x-z13/tarballs/s390x-z13--glibc--stable-2024.05-1.tar.xz"
      local -r GCC_PREFIX="s390x"
      local -r GCC_SUFFIX=""
      ;;
    *)
      >&2 echo 'unknown power platform'
      exit 1 ;;
  esac

  local -r TOOLCHAIN_RELATIVE_DIR="${TARGET}"
  unpack "${TOOLCHAIN_URL}" "${TOOLCHAIN_RELATIVE_DIR}"
  local -r EXTRACT_DIR="${ARCHIVE_DIR}/$(basename ${TOOLCHAIN_URL%.tar.xz})"

  local -r TOOLCHAIN_DIR=${ARCHIVE_DIR}/${TOOLCHAIN_RELATIVE_DIR}
  if [[ -d "${EXTRACT_DIR}" ]]; then
    mv "${EXTRACT_DIR}" "${TOOLCHAIN_DIR}"
  fi

  local -r SYSROOT_DIR="${TOOLCHAIN_DIR}/${GCC_PREFIX}-buildroot-linux-gnu${GCC_SUFFIX}/sysroot"
  #local -r STAGING_DIR=${SYSROOT_DIR}-stage

  # Write a Toolchain file
  # note: This is manadatory to use a file in order to have the CMake variable
  # 'CMAKE_CROSSCOMPILING' set to TRUE.
  # ref: https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html#cross-compiling-for-linux
  cat >"${TOOLCHAIN_FILE}" <<EOL
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR ${GCC_PREFIX})

set(CMAKE_SYSROOT ${SYSROOT_DIR})
#set(CMAKE_STAGING_PREFIX ${STAGING_DIR})

set(tools ${TOOLCHAIN_DIR})

set(CMAKE_C_COMPILER \${tools}/bin/${GCC_PREFIX}-linux-gcc)
set(CMAKE_C_FLAGS "${POWER_FLAGS}")
set(CMAKE_CXX_COMPILER \${tools}/bin/${GCC_PREFIX}-linux-g++)
set(CMAKE_CXX_FLAGS "${POWER_FLAGS} -L${SYSROOT_DIR}/lib")

set(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_DIR})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
EOL

CMAKE_ADDITIONAL_ARGS+=( -DCMAKE_TOOLCHAIN_FILE="${TOOLCHAIN_FILE}" )
QEMU_ARGS+=( -L "${SYSROOT_DIR}" )
QEMU_ARGS+=( -E LD_PRELOAD="${SYSROOT_DIR}/usr/lib/libstdc++.so.6:${SYSROOT_DIR}/lib/libgcc_s.so.1" )
}

function expand_codescape_config() {
  # https://www.mips.com/mips-toolchain-configurations/
  # mips-img: MIPS32R6 and MIPS64R6
  # mips-mti: MIPS32R2 and MIPS64R2
  case "${TARGET}" in
    "mips" | "mipsel" | "mips64" | "mips64el" | \
    "mips32-r6" | "mips32el-r6" | "mips64-r6" | "mips64el-r6" )
      # IMG Toolchain MIPS32R6 and MIPS64R6
      # ref: https://codescape.mips.com/components/toolchain/2021.09-01/downloads.html
      local -r DATE=2021.09-01
      local -r CODESCAPE_URL=https://codescape.mips.com/components/toolchain/${DATE}/Codescape.GNU.Tools.Package.${DATE}.for.MIPS.IMG.Linux.CentOS-6.x86_64.tar.gz
      local -r GCC_PREFIX="mips-img-linux-gnu"
      local -r GCC_RELATIVE_DIR="${GCC_PREFIX}/${DATE}"
      ;;
    "mips32-r2" | "mips32el-r2" | "mips64-r2" | "mips64el-r2")
      # MTI Toolchain MIPS32R2-MIPS32R6, MIPS64R2-MIPS64R6
      # ref: https://codescape.mips.com/components/toolchain/2020.06-01/downloads.html
      local -r DATE=2020.06-01
      local -r CODESCAPE_URL=https://codescape.mips.com/components/toolchain/${DATE}/Codescape.GNU.Tools.Package.${DATE}.for.MIPS.MTI.Linux.CentOS-6.x86_64.tar.gz
      # # ref: https://codescape.mips.com/components/toolchain/2019.09-06/downloads.html
      # local -r DATE=2019.09-06
      # local -r CODESCAPE_URL=https://codescape.mips.com/components/toolchain/${DATE}/Codescape.GNU.Tools.Package.${DATE}.for.MIPS.MTI.Linux.CentOS-6.x86_64.tar.gz
      local -r GCC_PREFIX="mips-mti-linux-gnu"
      local -r GCC_RELATIVE_DIR="${GCC_PREFIX}/${DATE}"
      ;;
    *)
      >&2 echo 'unknown platform'
      exit 1 ;;
  esac

  local -r GCC_URL=${CODESCAPE_URL}
  unpack "${GCC_URL}" "${GCC_RELATIVE_DIR}"

  local -r GCC_DIR=${ARCHIVE_DIR}/${GCC_RELATIVE_DIR}

  case "${TARGET}" in
    "mips" | "mips32-r6")
      local -r MIPS_FLAGS="-EB -mips32r6 -mabi=32"
      local -r FLAVOUR="mips-r6-hard"
      local -r LIBC_DIR_SUFFIX="lib"
      ;;
    "mips32-r2")
      local -r MIPS_FLAGS="-EB -mips32r2 -mabi=32"
      local -r FLAVOUR="mips-r2-hard"
      local -r LIBC_DIR_SUFFIX="lib"
      ;;
    "mipsel" | "mips32el-r6")
      local -r MIPS_FLAGS="-EL -mips32r6 -mabi=32"
      local -r FLAVOUR="mipsel-r6-hard"
      local -r LIBC_DIR_SUFFIX="lib"
      ;;
    "mips32el-r2")
      local -r MIPS_FLAGS="-EL -mips32r2 -mabi=32"
      local -r FLAVOUR="mipsel-r2-hard"
      local -r LIBC_DIR_SUFFIX="lib"
      ;;
    "mips64" | "mips64-r6")
      local -r MIPS_FLAGS="-EB -mips64r6 -mabi=64"
      local -r FLAVOUR="mips-r6-hard"
      local -r LIBC_DIR_SUFFIX="lib64"
      ;;
    "mips64-r2")
      local -r MIPS_FLAGS="-EB -mips64r2 -mabi=64"
      local -r FLAVOUR="mips-r2-hard"
      local -r LIBC_DIR_SUFFIX="lib64"
      ;;
    "mips64el" | "mips64el-r6")
      local -r MIPS_FLAGS="-EL -mips64r6 -mabi=64"
      local -r FLAVOUR="mipsel-r6-hard"
      local -r LIBC_DIR_SUFFIX="lib64"
      ;;
    "mips64el-r2")
      local -r MIPS_FLAGS="-EL -mips64r2 -mabi=64"
      local -r FLAVOUR="mipsel-r2-hard"
      local -r LIBC_DIR_SUFFIX="lib64"
      ;;
    *)
      >&2 echo 'unknown mips platform'
      exit 1 ;;
  esac
  local -r SYSROOT_DIR=${GCC_DIR}/sysroot
  local -r STAGING_DIR=${SYSROOT_DIR}-stage

  # Write a Toolchain file
  # note: This is manadatory to use a file in order to have the CMake variable
  # 'CMAKE_CROSSCOMPILING' set to TRUE.
  # ref: https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html#cross-compiling-for-linux
  cat >"${TOOLCHAIN_FILE}" <<EOL
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR ${TARGET})

set(CMAKE_SYSROOT ${SYSROOT_DIR})
set(CMAKE_STAGING_PREFIX ${STAGING_DIR})

set(tools ${GCC_DIR})

set(CMAKE_C_COMPILER \${tools}/bin/${GCC_PREFIX}-gcc)
set(CMAKE_C_FLAGS "${MIPS_FLAGS}")
set(CMAKE_CXX_COMPILER \${tools}/bin/${GCC_PREFIX}-g++)
set(CMAKE_CXX_FLAGS "${MIPS_FLAGS} -L${SYSROOT_DIR}/usr/lib64")

set(CMAKE_FIND_ROOT_PATH ${GCC_DIR})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
EOL

CMAKE_ADDITIONAL_ARGS+=( -DCMAKE_TOOLCHAIN_FILE="${TOOLCHAIN_FILE}" )
QEMU_ARGS+=( -L "${SYSROOT_DIR}/${FLAVOUR}" )
local -r LIBC_DIR=${GCC_DIR}/${GCC_PREFIX}/lib/${FLAVOUR}/${LIBC_DIR_SUFFIX}
QEMU_ARGS+=( -E LD_PRELOAD="${LIBC_DIR}/libstdc++.so.6:${LIBC_DIR}/libgcc_s.so.1" )
}

function build() {
  cd "${PROJECT_DIR}" || exit 2
  set -x
  clean_build
  cmake -S. -B"${BUILD_DIR}" "${CMAKE_DEFAULT_ARGS[@]}" "${CMAKE_ADDITIONAL_ARGS[@]}"
  cmake --build "${BUILD_DIR}" --target all -j8 -v
  set +x
}

function run_test() {
  assert_defined QEMU_ARCH
  if [[ "${QEMU_ARCH}" == "DISABLED" ]]; then
    >&2 echo "QEMU is disabled for ${TARGET}"
    return
  fi
  install_qemu
  RUN_CMD="${QEMU_INSTALL}/bin/qemu-${QEMU_ARCH} ${QEMU_ARGS[*]}"

  cd "${BUILD_DIR}" || exit 2
  set -x
  for test_binary in \
    "${BUILD_DIR}"/bin/FooBarApp \
    "${BUILD_DIR}"/bin/*_test ; do
      ${RUN_CMD} "${test_binary}"
  done
  set +x
}

function usage() {
  local -r NAME=$(basename "$0")
  echo -e "$NAME - Build using a cross toolchain.

SYNOPSIS
\t$NAME [-h|--help] [toolchain|build|qemu|test|all]

DESCRIPTION
\tCross compile using a cross toolchain.

\tYou MUST define the following variables before running this script:
\t* TARGET:
\t\tx86_64
\t\tarmv7-eabihf(arm) armebv7-eabihf(armeb) (bootlin)
\t\taarch64(arm64) aarch64be(arm64be) (bootlin)
\t\tmips32-r6(mips) mips32el-r6(mipsel) mips32-r2 mips32el-r2 (codespace)
\t\tmips64-r6(mips64) mips64el-r6(mips64el) mips64-r2 mips64el-r2 (codespace)
\t\tppc-440fp(ppc) ppc-e500mc (bootlin)
\t\tppc64 ppc64le (bootlin)
\t\triscv32 riscv64 (bootlin)
\t\ts390x (bootlin)

OPTIONS
\t-h --help: show this help text
\ttoolchain: download, unpack toolchain and generate CMake toolchain file
\tbuild: toolchain + build the project using the toolchain file (note: remove previous build dir)
\tqemu: download, unpack and build qemu
\ttest: qemu + run all executable using qemu (note: don't build !)
\tall: build + test (default)

EXAMPLES
* Using export:
export TARGET=aarch64-linux-gnu
$0

* One-liner:
TARGET=aarch64-linux-gnu $0"
}

# Main
function main() {
  case ${1} in
    -h | --help)
      usage; exit ;;
  esac

  assert_defined TARGET

  # shellcheck disable=SC2155
  declare -r PROJECT_DIR="$(cd -P -- "$(dirname -- "$0")/.." && pwd -P)"
  declare -r ARCHIVE_DIR="${PROJECT_DIR}/build_cross/archives"
  declare -r BUILD_DIR="${PROJECT_DIR}/build_cross/${TARGET}"
  declare -r TOOLCHAIN_FILE=${ARCHIVE_DIR}/toolchain_${TARGET}.cmake

  echo "Target: '${TARGET}'"

  echo "Project dir: '${PROJECT_DIR}'"
  echo "Archive dir: '${ARCHIVE_DIR}'"
  echo "Build dir: '${BUILD_DIR}'"
  echo "toolchain file: '${TOOLCHAIN_FILE}'"

  declare -a CMAKE_DEFAULT_ARGS=( -G ${CMAKE_GENERATOR:-"Unix Makefiles"} )
  declare -a CMAKE_ADDITIONAL_ARGS=()

  declare -a QEMU_ARGS=()
  # ref: https://go.dev/doc/install/source#environment
  case ${TARGET} in
    x86_64)
      declare -r QEMU_ARCH=x86_64 ;;

    arm | armv7-eabihf)
      expand_bootlin_config
      declare -r QEMU_ARCH=arm ;;
    armeb | armebv7-eabihf)
      expand_bootlin_config
      declare -r QEMU_ARCH=DISABLED ;;
    arm64 | aarch64)
      expand_bootlin_config
      declare -r QEMU_ARCH=aarch64 ;;
    arm64be | aarch64be)
      expand_bootlin_config
      declare -r QEMU_ARCH=aarch64_be ;;

    mips | mips32-r6 | mips32-r2)
      expand_codescape_config
      declare -r QEMU_ARCH=mips ;;
    mipsel | mips32el-r6 | mips32el-r2)
      expand_codescape_config
      declare -r QEMU_ARCH=mipsel ;;
    mips64 | mips64-r6 | mips64-r2)
      expand_codescape_config
      declare -r QEMU_ARCH=mips64 ;;
    mips64el | mips64el-r6 | mips64el-r2)
      expand_codescape_config
      declare -r QEMU_ARCH=mips64el ;;

    ppc | ppc-440fp | ppc-e500mc )
      expand_bootlin_config
      declare -r QEMU_ARCH=ppc ;;
    ppc64 | ppc64-power8)
      expand_bootlin_config
      declare -r QEMU_ARCH=ppc64 ;;
    ppc64le | ppc64le-power8)
      expand_bootlin_config
      declare -r QEMU_ARCH=ppc64le ;;

    riscv32)
      expand_bootlin_config
      declare -r QEMU_ARCH=riscv32 ;;
    riscv64)
      expand_bootlin_config
      declare -r QEMU_ARCH=riscv64 ;;

    s390x)
      expand_bootlin_config
      declare -r QEMU_ARCH=s390x ;;
    *)
      >&2 echo "Unknown TARGET '${TARGET}'..."
      exit 1 ;;
  esac
  declare -r QEMU_INSTALL=${ARCHIVE_DIR}/qemu-${QEMU_ARCH}

  case ${1} in
    toolchain)
      exit ;;
    build)
      build ;;
    qemu)
      install_qemu ;;
    test)
      run_test ;;
    *)
      build
      run_test ;;
  esac
}

main "${1:-all}"
