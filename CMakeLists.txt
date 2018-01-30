# This file is just an orchestration
cmake_minimum_required(VERSION 3.8.2)
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

if(POLICY CMP0068)
	# Don't modify install_name when touching RPATH.
	cmake_policy(SET CMP0068 NEW)
endif()

include(CTest)
set(CMAKE_VERBOSE_MAKEFILE ON)
if(UNIX)
  set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
  option(BUILD_SHARED_LIBS "Build shared libraries(.so)." ON)
else()
	# only support for static build on Windows.
 set(BUILD_SHARED_LIBS OFF)
endif()

add_subdirectory(Foo)
add_subdirectory(Bar)
add_subdirectory(FooBar)
add_subdirectory(FooBarApp)

# Install
include(GNUInstallDirs)
install(EXPORT CMakeCPPTargets
	NAMESPACE CMakeCPP::
	DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/CMakeCPP
	COMPONENT Devel)
include(CMakePackageConfigHelpers)
configure_package_config_file(cmake/CMakeCPPConfig.cmake.in
	"${PROJECT_BINARY_DIR}/CMakeCPPConfig.cmake"
	INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/CMakeCPP"
	NO_SET_AND_CHECK_MACRO
  NO_CHECK_REQUIRED_COMPONENTS_MACRO)
write_basic_package_version_file(
	"${PROJECT_BINARY_DIR}/CMakeCPPConfigVersion.cmake"
	COMPATIBILITY SameMajorVersion)
install(
	FILES
	"${PROJECT_BINARY_DIR}/CMakeCPPConfig.cmake"
	"${PROJECT_BINARY_DIR}/CMakeCPPConfigVersion.cmake"
	DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/CMakeCPP"
	COMPONENT Devel)
