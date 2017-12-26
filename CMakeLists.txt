# This file is just an orchestration
cmake_minimum_required(VERSION 3.8.2)
project(meta VERSION 1.0 LANGUAGES NONE)

# Use find_package everywhere, no-op if it's a target
macro(find_package)
	if(NOT TARGET "${ARGV0}")
		_find_package(${ARGV})
	endif()
endmacro()

include(CTest)
set(CMAKE_VERBOSE_MAKEFILE ON)
if(UNIX)
	if(APPLE)
		# Don't modify install_name when touching RPATH.
		cmake_policy(SET CMP0068 NEW)
	endif()
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
