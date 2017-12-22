# This file is just an orchestration
cmake_minimum_required(VERSION 3.5)
project(meta NONE)

include(CTest)
set(CMAKE_VERBOSE_MAKEFILE ON)
if(UNIX)
	cmake_policy(SET CMP0068 NEW)
  set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
  option(BUILD_SHARED_LIBS "Build shared libraries(.so)." ON)
else()
 set(BUILD_SHARED_LIBS OFF)
endif()

add_subdirectory(Foo)
add_subdirectory(Bar)

add_subdirectory(FooBar)
add_subdirectory(FooBarApp)
