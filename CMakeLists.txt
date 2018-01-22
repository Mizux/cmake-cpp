# This file is just an orchestration
cmake_minimum_required(VERSION 3.8.2)
project(meta VERSION 1.0 LANGUAGES NONE)

# Force default build type to Release
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING
		"Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel."
		FORCE)
endif(NOT CMAKE_BUILD_TYPE)

# Use find_package everywhere, no-op if it's a target
macro(find_package)
	if(NOT TARGET ${ARGV0} AND NOT TARGET ${ARGV0}::${ARGV0})
		_find_package(${ARGV})
	else()
		if(TARGET ${ARGV0})
			get_target_property(TGT_VER ${ARGV0} VERSION)
			set(TGT ${ARGV0})
		else()
			get_target_property(TGT_VER ${ARGV0}::${ARGV0} VERSION)
			set(TGT ${ARGV0}::${ARGV0})
		endif()
		message(STATUS "Found ${ARGV0}: CMake Target ${TGT} (found version \"${TGT_VER}\")")
		set(${ARGV0}_FOUND TRUE)
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
