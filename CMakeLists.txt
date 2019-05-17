# This file is just an orchestration
cmake_minimum_required(VERSION 3.8.2)

# Apple: Don't modify install_name when touching RPATH.
if(POLICY CMP0068)
	cmake_policy(SET CMP0068 NEW)
endif()

project(meta VERSION 1.0 LANGUAGES NONE)

# Force default build type to Release
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING
		"Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel."
		FORCE)
endif(NOT CMAKE_BUILD_TYPE)

# Usage find_target(TARGET_NAME TARGET_PACKAGE [PACKAGE OPTIONS]).
# e.g.: find_target(protobuf::libprotobuf Protobuf REQUIRED)
macro(find_target TARGET_NAME TARGET_PACKAGE)
	if(TARGET ${TARGET_NAME})
		get_target_property(TGT_VERSION ${TARGET_NAME} VERSION)
		message(STATUS "Found Target: ${TARGET_NAME} (found version \"${TGT_VERSION}\")")
		set(${TARGET_PACKAGE}_FOUND TRUE)
	else()
		find_package(${TARGET_PACKAGE} ${ARGN})
	endif()
endmacro()

include(CTest)
set(CMAKE_VERBOSE_MAKEFILE ON)
if(UNIX)
  set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
  option(BUILD_SHARED_LIBS "Build shared libraries(.so)." ON)
else()
	# only support for static build on Windows.
 set(BUILD_SHARED_LIBS OFF)
endif()


# type size checks
enable_language(CXX)
include(CheckTypeSize)
set(TYPES
  "char"
  "short"
  "int"
  "long"
  "long int"
  "long long"
  "long long int"
  "void *"
  "intptr_t"
  "uintptr_t")
foreach(TYPE ${TYPES})
  string(MAKE_C_IDENTIFIER ${TYPE} TYPE_NAME)
  string(TOUPPER ${TYPE_NAME} TYPE_NAME)
  string(PREPEND TYPE_NAME "SIZEOF_")
  message(STATUS "${TYPE} -> ${TYPE_NAME}")
  check_type_size(${TYPE} ${TYPE_NAME} LANGUAGE CXX)
  message(STATUS "${TYPE_NAME} -> ${${TYPE_NAME}}")
endforeach()

add_subdirectory(Foo)
add_subdirectory(Bar)
add_subdirectory(FooBar)
add_subdirectory(FooBarApp)

# Install
include(GNUInstallDirs)
install(EXPORT CMakeCppTargets
	NAMESPACE CMakeCpp::
	DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/CMakeCpp
	COMPONENT Devel)
include(CMakePackageConfigHelpers)
configure_package_config_file(cmake/CMakeCppConfig.cmake.in
	"${PROJECT_BINARY_DIR}/CMakeCppConfig.cmake"
	INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/CMakeCpp"
	NO_SET_AND_CHECK_MACRO
  NO_CHECK_REQUIRED_COMPONENTS_MACRO)
write_basic_package_version_file(
	"${PROJECT_BINARY_DIR}/CMakeCppConfigVersion.cmake"
	COMPATIBILITY SameMajorVersion)
install(
	FILES
	"${PROJECT_BINARY_DIR}/CMakeCppConfig.cmake"
	"${PROJECT_BINARY_DIR}/CMakeCppConfigVersion.cmake"
	DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/CMakeCpp"
	COMPONENT Devel)
