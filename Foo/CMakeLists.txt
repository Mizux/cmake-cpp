add_library(Foo)
target_sources(Foo
  PRIVATE
    include/foo/Foo.hpp
    src/Foo.cpp)
target_include_directories(Foo
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>)
target_compile_features(Foo PUBLIC cxx_std_20)
set_target_properties(Foo PROPERTIES
  VERSION ${PROJECT_VERSION}
  POSITION_INDEPENDENT_CODE ON
  PUBLIC_HEADER include/foo/Foo.hpp)
if(APPLE)
  set_target_properties(Foo PROPERTIES INSTALL_RPATH "@loader_path")
elseif(UNIX)
  set_target_properties(Foo PROPERTIES INSTALL_RPATH "$ORIGIN")
endif()
target_link_libraries(Foo PRIVATE absl::log)
add_library(${PROJECT_NAMESPACE}::Foo ALIAS Foo)

add_subdirectory(tests)

# Install
include(GNUInstallDirs)
install(TARGETS Foo
  EXPORT ${PROJECT_NAME}Targets
  PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/foo
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  #RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
