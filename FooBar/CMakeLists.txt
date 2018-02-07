cmake_minimum_required(VERSION 3.8.2)
project(FooBar VERSION 1.0.0 LANGUAGES CXX)

find_target(CMakeCpp::Foo CMakeCpp REQUIRED CONFIG)
find_target(CMakeCpp::Bar CMakeCpp REQUIRED CONFIG)

file(GLOB _HDRS "include/foobar/*.hpp" "include/foobar/*.hxx")
file(GLOB _SRCS "src/*.[hc]pp")

add_library(${PROJECT_NAME} ${_HDRS} ${_SRCS})
target_include_directories(${PROJECT_NAME} PUBLIC
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
	$<INSTALL_INTERFACE:include>)
set_target_properties(${PROJECT_NAME} PROPERTIES
	PUBLIC_HEADER ${_HDRS}
	VERSION ${PROJECT_VERSION})
if(APPLE)
	set_target_properties(${PROJECT_NAME} PROPERTIES
		INSTALL_RPATH "@loader_path/../Foo;@loader_path/../Bar;@loader_path")
elseif(UNIX AND NOT APPLE)
	set_target_properties(${PROJECT_NAME} PROPERTIES
		INSTALL_RPATH "$ORIGIN/../Foo:$ORIGIN/../Bar:$ORIGIN")
endif()
target_link_libraries(${PROJECT_NAME}
	PUBLIC CMakeCpp::Foo
	PRIVATE CMakeCpp::Bar)
add_library(CMakeCpp::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

# Test
include(CTest)
if(BUILD_TESTING)
	add_subdirectory(test)
endif()

# Install
include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
	EXPORT CMakeCppTargets
	PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/foobar
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	#RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
	)
