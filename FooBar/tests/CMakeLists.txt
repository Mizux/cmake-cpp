if(NOT BUILD_TESTING)
  return()
endif()

add_cxx_test(
  NAME
    foobar_test
  SOURCES
    foobar_test.cpp
  LINK_LIBRARIES
    ${PROJECT_NAMESPACE}::FooBar
)
