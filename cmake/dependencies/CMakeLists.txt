include(FetchContent)
set(FETCHCONTENT_QUIET OFF)
set(FETCHCONTENT_UPDATES_DISCONNECTED ON)
set(BUILD_SHARED_LIBS ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(BUILD_TESTING OFF)
set(CMAKE_Fortran_COMPILER OFF)

# ##############################################################################
# ZLIB
# ##############################################################################
if(BUILD_ZLIB)
  message(CHECK_START "Fetching ZLIB")
  list(APPEND CMAKE_MESSAGE_INDENT "  ")
  FetchContent_Declare(
    ZLIB
    GIT_REPOSITORY "https://github.com/madler/ZLIB.git"
    GIT_TAG "v1.3.1"
    GIT_SHALLOW TRUE
    UPDATE_COMMAND git reset --hard
    PATCH_COMMAND git apply --ignore-whitespace
    "${CMAKE_CURRENT_LIST_DIR}/../../patches/ZLIB-v1.3.1.patch"
  )
  set(ZLIB_BUILD_EXAMPLES OFF)
  FetchContent_MakeAvailable(ZLIB)
  list(POP_BACK CMAKE_MESSAGE_INDENT)
  message(CHECK_PASS "fetched")
endif()

# ##############################################################################
# ABSEIL-CPP
# ##############################################################################
if(BUILD_absl)
  message(CHECK_START "Fetching Abseil-cpp")
  list(APPEND CMAKE_MESSAGE_INDENT "  ")
  FetchContent_Declare(
    absl
    GIT_REPOSITORY "https://github.com/abseil/abseil-cpp.git"
    GIT_TAG "20250814.0"
    GIT_SHALLOW TRUE
    UPDATE_COMMAND git reset --hard
    PATCH_COMMAND git apply --ignore-whitespace
    "${CMAKE_CURRENT_LIST_DIR}/../../patches/abseil-cpp-20250814.0.patch"
    OVERRIDE_FIND_PACKAGE
  )
  set(ABSL_USE_SYSTEM_INCLUDES ON)
  # We want Abseil to declare what C++ standard it was compiled with.
  set(ABSL_PROPAGATE_CXX_STD ON)
  # We want Abseil to keep the INSTALL rules enabled, even though it is a
  # subproject. Otherwise the install rules in this project break.
  set(ABSL_ENABLE_INSTALL ON)
  set(ABSL_BUILD_TESTING OFF)
  set(ABSL_BUILD_TEST_HELPERS OFF)
  set(ABSL_USE_EXTERNAL_GOOGLETEST ON)
  set(ABSL_FIND_GOOGLETEST OFF)
  FetchContent_MakeAvailable(absl)
  list(POP_BACK CMAKE_MESSAGE_INDENT)
  message(CHECK_PASS "fetched")
endif()

# ##############################################################################
# RE2
# ##############################################################################
if(BUILD_re2)
  message(CHECK_START "Fetching re2")
  list(APPEND CMAKE_MESSAGE_INDENT "  ")
  FetchContent_Declare(
    re2
    GIT_REPOSITORY "https://github.com/google/re2.git"
    GIT_TAG "2025-08-12"
    GIT_SHALLOW TRUE
    UPDATE_COMMAND git reset --hard
    PATCH_COMMAND git apply --ignore-whitespace
    "${CMAKE_CURRENT_LIST_DIR}/../../patches/re2-2025-08-12.patch"
  )
  set(RE2_BUILD_TESTING OFF)
  FetchContent_MakeAvailable(re2)
  list(POP_BACK CMAKE_MESSAGE_INDENT)
  message(CHECK_PASS "fetched")
endif()

# ##############################################################################
# Protobuf
# ##############################################################################
if(BUILD_Protobuf)
  message(CHECK_START "Fetching Protobuf")
  list(APPEND CMAKE_MESSAGE_INDENT "  ")
  FetchContent_Declare(
    Protobuf
    GIT_REPOSITORY "https://github.com/protocolbuffers/protobuf.git"
    GIT_TAG "v32.0"
    GIT_SHALLOW TRUE
    GIT_SUBMODULES ""
    UPDATE_COMMAND git reset --hard
    PATCH_COMMAND git apply --ignore-whitespace
    "${CMAKE_CURRENT_LIST_DIR}/../../patches/protobuf-v32.0.patch"
  )
  set(protobuf_BUILD_TESTS OFF)
  set(protobuf_BUILD_SHARED_LIBS ON)
  set(protobuf_BUILD_EXPORT OFF)
  set(protobuf_MSVC_STATIC_RUNTIME OFF)
  #set(protobuf_BUILD_LIBUPB ON)
  FetchContent_MakeAvailable(Protobuf)
  list(POP_BACK CMAKE_MESSAGE_INDENT)
  message(CHECK_PASS "fetched")
endif()

###############
##  TESTING  ##
###############
if(BUILD_googletest)
  message(CHECK_START "Fetching googletest")
  list(APPEND CMAKE_MESSAGE_INDENT "  ")
  FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG v1.17.0
    GIT_SHALLOW TRUE
    UPDATE_COMMAND git reset --hard
    PATCH_COMMAND git apply --ignore-whitespace
    "${CMAKE_CURRENT_LIST_DIR}/../../patches/googletest-v1.17.0.patch"
  )
  set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
  set(GTEST_HAS_ABSL ON)
  set(INSTALL_GTEST OFF)
  FetchContent_MakeAvailable(googletest)
  list(POP_BACK CMAKE_MESSAGE_INDENT)
  message(CHECK_PASS "fetched")
endif()

if(BUILD_benchmark)
  message(CHECK_START "Fetching benchmark")
  list(APPEND CMAKE_MESSAGE_INDENT "  ")
  FetchContent_Declare(
    benchmark
    GIT_REPOSITORY https://github.com/google/benchmark.git
    GIT_TAG v1.9.2
    GIT_SHALLOW TRUE
    #PATCH_COMMAND git apply --ignore-whitespace ""
  )
  set(BENCHMARK_ENABLE_TESTING OFF)
  set(BENCHMARK_ENABLE_WERROR OFF)
  set(BENCHMARK_ENABLE_INSTALL OFF)
  FetchContent_MakeAvailable(benchmark)
  list(POP_BACK CMAKE_MESSAGE_INDENT)
  message(CHECK_PASS "fetched")
endif()
