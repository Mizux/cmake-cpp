cmake_minimum_required(VERSION 3.5)
project(FooBar VERSION 1.0.0 LANGUAGES CXX)

if(NOT TARGET Foo::Foo OR NOT TARGET Bar::Bar)
	message(FATAL_ERROR "FooBar: missing dependencies")
endif()

file(GLOB_RECURSE _HDRS "include/*.hpp" "include/*hxx")
file(GLOB_RECURSE _SRCS "src/*.[hc]pp")

add_library(${PROJECT_NAME} ${_HDRS} ${_SRCS})
target_include_directories(${PROJECT_NAME} PUBLIC
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
	$<INSTALL_INTERFACE:include>)
if(APPLE)
set_target_properties(${PROJECT_NAME} PROPERTIES
	INSTALL_RPATH "@loader_path/../Foo;@loader_path/../Bar;@loader_path/../lib")
elseif(UNIX AND NOT APPLE)
	set_target_properties(${PROJECT_NAME} PROPERTIES
INSTALL_RPATH "$ORIGIN/../Foo:$ORIGIN/../Bar:$ORIGIN")
endif()
target_link_libraries(${PROJECT_NAME} PUBLIC Foo::Foo PRIVATE Bar::Bar)
add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

# TEST
include(CTest)
if(BUILD_TESTING)
	add_subdirectory(test)
endif()

# Install
include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
	EXPORT ${PROJECT_NAME}Targets
	INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
	PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/foobar
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	#RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
	)
install(EXPORT ${PROJECT_NAME}Targets
	NAMESPACE ${PROJECT_NAME}::
	DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
	)
