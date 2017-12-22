cmake_minimum_required(VERSION 3.5)
project(FooBarApp VERSION 1.0.0 LANGUAGES CXX)

if(NOT TARGET FooBar::FooBar)
	message(FATAL_ERROR "FooBarApp: missing dependencies")
endif()

file(GLOB _SRCS "src/*.[hc]pp")

add_executable(${PROJECT_NAME} ${_SRCS})
if(APPLE)
	set_target_properties(${PROJECT_NAME} PROPERTIES
		INSTALL_RPATH
		"@loader_path/../FooBar;@loader_path/../Foo;@loader_path/../lib")
elseif(UNIX AND NOT APPLE)
	set_target_properties(${PROJECT_NAME} PROPERTIES
		INSTALL_RPATH "$ORIGIN/../Foo:$ORIGIN/../FooBar:$ORIGIN/../lib")
endif()
target_link_libraries(${PROJECT_NAME} FooBar::FooBar)

# TEST
include(CTest)
if(BUILD_TESTING)
	add_test(NAME FooBarApp_UT COMMAND FooBarApp)
endif()

# Install
include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
	EXPORT ${PROJECT_NAME}Targets
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
	)
install(EXPORT ${PROJECT_NAME}Targets
	NAMESPACE ${PROJECT_NAME}::
	DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
	)
