if(NOT BUILD_TESTING)
  return()
endif()

file(GLOB CPP_SRCS "*.cpp")
foreach(_TEST_FILE IN LISTS CPP_SRCS)
  get_filename_component(_NAME ${_TEST_FILE} NAME_WE)
  get_filename_component(_FILE_NAME ${_TEST_FILE} NAME)
  add_cxx_test(
    NAME
      ${_NAME}
    SOURCES
      ${_FILE_NAME}
    LINK_LIBRARIES
      ${PROJECT_NAMESPACE}::Bar
  )
endforeach()
