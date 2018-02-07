cmake_minimum_required(VERSION 3.8.2)
project(FooBarApp VERSION 1.0.0 LANGUAGES CXX)

find_target(CMakeCpp::FooBar CMakeCpp REQUIRED CONFIG)

file(GLOB _SRCS "src/*.[hc]pp")

add_executable(${PROJECT_NAME} ${_SRCS})
# need to find FooBar AND Foo since Foo is a public dependencies of FooBar
if(APPLE)
	set_target_properties(${PROJECT_NAME} PROPERTIES
		INSTALL_RPATH
		"@loader_path/../FooBar;@loader_path/../Foo;@loader_path/../lib")
elseif(UNIX AND NOT APPLE)
	set_target_properties(${PROJECT_NAME} PROPERTIES
		INSTALL_RPATH "$ORIGIN/../FooBar:$ORIGIN/../Foo:$ORIGIN/../lib")
endif()
target_link_libraries(${PROJECT_NAME}
	PRIVATE CMakeCpp::FooBar)
add_executable(CMakeCpp::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

# Test
include(CTest)
if(BUILD_TESTING)
	add_test(NAME FooBarApp_UT COMMAND FooBarApp)
endif()

# Install
include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
	EXPORT CMakeCppTargets
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
	)
