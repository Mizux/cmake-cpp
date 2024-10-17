if(NOT BUILD_TESTING)
  return()
endif()

add_executable(foobar_test)
target_sources(foobar_test PRIVATE foobar_test.cpp)
target_include_directories(foobar_test PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)
target_compile_features(foobar_test PRIVATE cxx_std_20)
set_target_properties(foobar_test PROPERTIES
  VERSION ${PROJECT_VERSION}
  POSITION_INDEPENDENT_CODE ON
)
if(APPLE)
  set_target_properties(foobar_test PROPERTIES
    INSTALL_RPATH "@loader_path/../${CMAKE_INSTALL_LIBDIR};@loader_path")
elseif(UNIX)
  set_target_properties(foobar_test PROPERTIES
    INSTALL_RPATH "$ORIGIN/../${CMAKE_INSTALL_LIBDIR}:$ORIGIN")
endif()
target_link_libraries(foobar_test PRIVATE
  #GTest::gtest_main
  Catch2::Catch2WithMain
  ${PROJECT_NAMESPACE}::FooBar)

add_test(NAME foobar_test COMMAND foobar_test)
