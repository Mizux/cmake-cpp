if(NOT BUILD_EXAMPLES)
  return()
endif()

add_executable(example)
target_sources(example PRIVATE example.cpp)
target_include_directories(example PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)
target_compile_features(example PRIVATE cxx_std_20)
set_target_properties(example PROPERTIES
  VERSION ${PROJECT_VERSION}
  POSITION_INDEPENDENT_CODE ON
)
if(APPLE)
  set_target_properties(example PROPERTIES
    INSTALL_RPATH "@loader_path/../${CMAKE_INSTALL_LIBDIR};@loader_path")
elseif(UNIX)
  set_target_properties(example PROPERTIES
    INSTALL_RPATH "$ORIGIN/../${CMAKE_INSTALL_LIBDIR}:$ORIGIN")
endif()
target_link_libraries(example PRIVATE
  #GTest::gtest_main
  ${PROJECT_NAMESPACE}::Foo
  ${PROJECT_NAMESPACE}::Bar
  ${PROJECT_NAMESPACE}::FooBar
)

add_test(NAME example COMMAND example)
