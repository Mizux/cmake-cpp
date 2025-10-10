# This file is just an orchestration
cmake_minimum_required(VERSION 3.24..3.31)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Enable output of compile commands during generation.
option(CMAKE_EXPORT_COMPILE_COMMANDS "Export compile command" ON)

project(CMakeCpp VERSION 1.0.0 LANGUAGES C CXX)
set(PROJECT_NAMESPACE CMakeCpp)
message(STATUS "${PROJECT_NAME} version: ${PROJECT_VERSION}")
#message(STATUS "major: ${PROJECT_VERSION_MAJOR}")
#message(STATUS "minor: ${PROJECT_VERSION_MINOR}")
#message(STATUS "patch: ${PROJECT_VERSION_PATCH}")

message(STATUS "system name: ${CMAKE_SYSTEM_NAME}")
# Set max os target version.
set(CMAKE_OSX_DEPLOYMENT_TARGET 10.15)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Default Build Type to be Release
get_property(isMultiConfig GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(isMultiConfig)
  if(NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_CONFIGURATION_TYPES "Release;Debug" CACHE STRING
    "Choose the type of builds, options are: Debug Release RelWithDebInfo MinSizeRel. (default: Release;Debug)"
    FORCE)
  endif()
  message(STATUS "Configuration types: ${CMAKE_CONFIGURATION_TYPES}")
else()
  if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING
    "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel. (default: Release)"
    FORCE)
  endif()
  message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
endif()

# Layout build dir like install dir
include(GNUInstallDirs)
if(UNIX)
  option(BUILD_SHARED_LIBS "Build shared libraries (.so or .dylib)." ON)
  set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
  # for multi-config build system (e.g. Xcode, Ninja Multi-Config)
  foreach(OutputConfig IN LISTS CMAKE_CONFIGURATION_TYPES)
    string(TOUPPER ${OutputConfig} OUTPUTCONFIG)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OutputConfig}/${CMAKE_INSTALL_LIBDIR})
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OutputConfig}/${CMAKE_INSTALL_LIBDIR})
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OutputConfig}/${CMAKE_INSTALL_BINDIR})
  endforeach()
else()
  option(BUILD_SHARED_LIBS "Build shared libraries (.dll)." ON)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
  # for multi-config builds (e.g. msvc)
  foreach(OutputConfig IN LISTS CMAKE_CONFIGURATION_TYPES)
    string(TOUPPER ${OutputConfig} OUTPUTCONFIG)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OutputConfig}/${CMAKE_INSTALL_BINDIR})
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OutputConfig}/${CMAKE_INSTALL_BINDIR})
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OutputConfig}/${CMAKE_INSTALL_BINDIR})
  endforeach()
endif()

if(MSVC AND BUILD_SHARED_LIBS)
  set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
endif()

# Enable CCache if any
include(ccache)

# Build deps
option(BUILD_ZLIB "Build the ZLIB dependency Library" ON)
message(STATUS "Build ZLIB: ${BUILD_ZLIB}")

option(BUILD_absl "Build the abseil-cpp dependency Library" ON)
message(STATUS "Build absl: ${BUILD_absl}")

option(BUILD_re2 "Build the RE2 dependency Library" ON)
message(STATUS "Build re2: ${BUILD_re2}")

option(BUILD_Protobuf "Build the Protobuf dependency Library" ON)
message(STATUS "Build protobuf: ${BUILD_Protobuf}")

# Disable CTest targets
set_property(GLOBAL PROPERTY CTEST_TARGETS_ADDED 1)
include(CTest)

if(BUILD_TESTING)
  option(BUILD_googletest "Build googletest" ON)
  option(BUILD_benchmark "Build benchmark" ON)
else()
  set(BUILD_googletest OFF)
  set(BUILD_benchmark OFF)
endif()
message(STATUS "Build googletest: ${BUILD_googletest}")
message(STATUS "Build benchmark: ${BUILD_benchmark}")

option(BUILD_EXAMPLES "Build examples" ON)
message(STATUS "Build examples: ${BUILD_EXAMPLES}")

# Find system deps
include(system_deps)

# Build Needed dependencies
add_subdirectory(cmake/dependencies dependencies)

include(host)
# verify deps
include(check_deps)

include(cpp)
foreach(SUBPROJECT IN ITEMS Foo Bar FooBar FooBarApp)
  add_subdirectory(${SUBPROJECT})
endforeach()

add_subdirectory(examples)
