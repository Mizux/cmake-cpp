if(NOT BUILD_TESTING)
  return()
endif()

add_executable(bar_test)
target_sources(bar_test PRIVATE bar_test.cpp)
target_include_directories(bar_test PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)
target_compile_features(bar_test PRIVATE cxx_std_20)
set_target_properties(bar_test PROPERTIES
  VERSION ${PROJECT_VERSION}
  POSITION_INDEPENDENT_CODE ON
)
if(APPLE)
  set_target_properties(bar_test PROPERTIES
    INSTALL_RPATH "@loader_path/../${CMAKE_INSTALL_LIBDIR};@loader_path")
elseif(UNIX)
  set_target_properties(bar_test PROPERTIES
    INSTALL_RPATH "$ORIGIN/../${CMAKE_INSTALL_LIBDIR}:$ORIGIN")
endif()
target_link_libraries(bar_test PRIVATE
  #GTest::gtest_main
  Catch2::Catch2WithMain
  ${PROJECT_NAMESPACE}::Bar)

add_test(NAME bar_test COMMAND bar_test)
