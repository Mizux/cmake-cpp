if(NOT BUILD_TESTING)
  return()
endif()

add_executable(foo_test)
target_sources(foo_test PRIVATE foo_test.cpp)
target_include_directories(foo_test PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)
target_compile_features(foo_test PRIVATE cxx_std_20)
set_target_properties(foo_test PROPERTIES
  VERSION ${PROJECT_VERSION}
  POSITION_INDEPENDENT_CODE ON
)
if(APPLE)
  set_target_properties(foo_test PROPERTIES
    INSTALL_RPATH "@loader_path/../${CMAKE_INSTALL_LIBDIR};@loader_path")
elseif(UNIX)
  set_target_properties(foo_test PROPERTIES
    INSTALL_RPATH "$ORIGIN/../${CMAKE_INSTALL_LIBDIR}:$ORIGIN")
endif()
target_link_libraries(foo_test PRIVATE
  #GTest::gtest_main
  Catch2::Catch2WithMain
  ${PROJECT_NAMESPACE}::Foo)

add_test(NAME foo_test COMMAND foo_test)
