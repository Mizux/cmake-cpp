# Check dependencies
set(CMAKE_THREAD_PREFER_PTHREAD TRUE)
set(THREAD_PREFER_PTHREAD_FLAG TRUE)
find_package(Threads REQUIRED)

# Tell find_package() to try “Config” mode before “Module” mode if no mode was specified.
# This should avoid find_package() to first find our FindXXX.cmake modules if
# distro package already provide a CMake config file...
set(CMAKE_FIND_PACKAGE_PREFER_CONFIG TRUE)

# libprotobuf force us to depends on ZLIB::ZLIB target
if(NOT BUILD_ZLIB)
 find_package(ZLIB REQUIRED)
endif()

if(NOT BUILD_absl)
  find_package(absl REQUIRED)
endif()

if(NOT BUILD_Protobuf)
  find_package(Protobuf REQUIRED)
endif()

# CXX Test
if(BUILD_TESTING)
  if(NOT BUILD_Catch2)
    find_package(Catch2 REQUIRED)
  endif()

  if(NOT BUILD_re2)
    find_package(re2 REQUIRED)
  endif()

  if(NOT BUILD_googletest)
    find_package(GTest REQUIRED)
  endif()
endif()
