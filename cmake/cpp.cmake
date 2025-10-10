# Check primitive types
option(CHECK_TYPE "Check primitive type size" OFF)
if(CHECK_TYPE)
  include(CMakePushCheckState)
  cmake_push_check_state(RESET)
  set(CMAKE_EXTRA_INCLUDE_FILES "cstdint")
  include(CheckTypeSize)
  check_type_size("long" SIZEOF_LONG LANGUAGE CXX)
  message(STATUS "Found long size: ${SIZEOF_LONG}")
  check_type_size("long long" SIZEOF_LONG_LONG LANGUAGE CXX)
  message(STATUS "Found long long size: ${SIZEOF_LONG_LONG}")
  check_type_size("int64_t" SIZEOF_INT64_T LANGUAGE CXX)
  message(STATUS "Found int64_t size: ${SIZEOF_INT64_T}")

  check_type_size("unsigned long" SIZEOF_ULONG LANGUAGE CXX)
  message(STATUS "Found unsigned long size: ${SIZEOF_ULONG}")
  check_type_size("unsigned long long" SIZEOF_ULONG_LONG LANGUAGE CXX)
  message(STATUS "Found unsigned long long size: ${SIZEOF_ULONG_LONG}")
  check_type_size("uint64_t" SIZEOF_UINT64_T LANGUAGE CXX)
  message(STATUS "Found uint64_t size: ${SIZEOF_UINT64_T}")

  check_type_size("int *" SIZEOF_INT_P LANGUAGE CXX)
  message(STATUS "Found int * size: ${SIZEOF_INT_P}")
  check_type_size("intptr_t" SIZEOF_INTPTR_T LANGUAGE CXX)
  message(STATUS "Found intptr_t size: ${SIZEOF_INTPTR_T}")
  check_type_size("uintptr_t" SIZEOF_UINTPTR_T LANGUAGE CXX)
  message(STATUS "Found uintptr_t size: ${SIZEOF_UINTPTR_T}")
  cmake_pop_check_state()
endif()

include(GNUInstallDirs)

################
##  C++ Test  ##
################
# add_cxx_test()
# CMake function to generate and build C++ test.
# Parameters:
# NAME: CMake target name
# SOURCES: List of source files
# [COMPILE_DEFINITIONS]: List of private compile definitions
# [COMPILE_OPTIONS]: List of private compile options
# [LINK_LIBRARIES]: List of private libraries to use when linking
# note: ortools::ortools is always linked to the target
# [LINK_OPTIONS]: List of private link options
# e.g.:
# add_cxx_test(
#   NAME
#     foo_test
#   SOURCES
#     foo_test.cc
#     ${PROJECT_SOURCE_DIR}/Foo/foo_test.cc
#   LINK_LIBRARIES
#     GTest::gmock
#     GTest::gtest_main
# )
function(add_cxx_test)
  set(options "")
  set(oneValueArgs "NAME")
  set(multiValueArgs
    "SOURCES;COMPILE_DEFINITIONS;COMPILE_OPTIONS;LINK_LIBRARIES;LINK_OPTIONS")
  cmake_parse_arguments(TEST
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )
  if(NOT BUILD_TESTING)
    return()
  endif()

  if(NOT TEST_NAME)
    message(FATAL_ERROR "no NAME provided")
  endif()
  if(NOT TEST_SOURCES)
    message(FATAL_ERROR "no SOURCES provided")
  endif()
  message(STATUS "Configuring test ${TEST_NAME} ...")

  add_executable(${TEST_NAME} "")
  target_sources(${TEST_NAME} PRIVATE ${TEST_SOURCES})
  target_include_directories(${TEST_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
  target_compile_definitions(${TEST_NAME} PRIVATE ${TEST_COMPILE_DEFINITIONS})
  target_compile_features(${TEST_NAME} PRIVATE cxx_std_20)
  target_compile_options(${TEST_NAME} PRIVATE ${TEST_COMPILE_OPTIONS})
  target_link_libraries(${TEST_NAME} PRIVATE
    GTest::gtest
    GTest::gtest_main
    ${TEST_LINK_LIBRARIES}
  )
  target_link_options(${TEST_NAME} PRIVATE ${TEST_LINK_OPTIONS})

  include(GNUInstallDirs)
  if(APPLE)
    set_target_properties(${TEST_NAME} PROPERTIES
      INSTALL_RPATH "@loader_path/../${CMAKE_INSTALL_LIBDIR};@loader_path")
  elseif(UNIX)
    cmake_path(RELATIVE_PATH CMAKE_INSTALL_FULL_LIBDIR
      BASE_DIRECTORY ${CMAKE_INSTALL_FULL_BINDIR}
      OUTPUT_VARIABLE libdir_relative_path)
    set_target_properties(${TEST_NAME} PROPERTIES
      INSTALL_RPATH "$ORIGIN/${libdir_relative_path}:$ORIGIN")
  endif()

  add_test(
    NAME cxx_${TEST_NAME}
    COMMAND ${TEST_NAME}
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
  )
  message(STATUS "Configuring test ${TEST_NAME} ...DONE")
endfunction()

###################
##  C++ Library  ##
###################
# add_cxx_library()
# CMake function to generate and build C++ library.
# Parameters:
# NAME: CMake target name
# SOURCES: List of source files
# [TYPE]: SHARED, STATIC or INTERFACE
# [COMPILE_DEFINITIONS]: List of private compile definitions
# [COMPILE_OPTIONS]: List of private compile options
# [LINK_LIBRARIES]: List of **public** libraries to use when linking
# note: ortools::ortools is always linked to the target
# [LINK_OPTIONS]: List of private link options
# e.g.:
# add_cxx_library(
#   NAME
#     foo
#   SOURCES
#     foo.cc
#     ${PROJECT_SOURCE_DIR}/Foo/foo.cc
#   TYPE
#     SHARED
#   LINK_LIBRARIES
#     GTest::gmock
#     GTest::gtest_main
#   TESTING
# )
function(add_cxx_library)
  set(options "TESTING")
  set(oneValueArgs "NAME;TYPE")
  set(multiValueArgs
    "SOURCES;COMPILE_DEFINITIONS;COMPILE_OPTIONS;LINK_LIBRARIES;LINK_OPTIONS")
  cmake_parse_arguments(LIBRARY
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )
  if(LIBRARY_TESTING AND NOT BUILD_TESTING)
    return()
  endif()

  if(NOT LIBRARY_NAME)
    message(FATAL_ERROR "no NAME provided")
  endif()
  if(NOT LIBRARY_SOURCES)
    message(FATAL_ERROR "no SOURCES provided")
  endif()
  message(STATUS "Configuring library ${LIBRARY_NAME} ...")

  add_library(${LIBRARY_NAME} ${LIBRARY_TYPE} "")
  if(LIBRARY_TYPE STREQUAL "INTERFACE")
    target_include_directories(${LIBRARY_NAME} INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})
    target_link_libraries(${LIBRARY_NAME} INTERFACE ${LIBRARY_LINK_LIBRARIES})
  else()
    target_sources(${LIBRARY_NAME} PRIVATE ${LIBRARY_SOURCES})
    target_include_directories(${LIBRARY_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
    target_compile_definitions(${LIBRARY_NAME} PRIVATE ${LIBRARY_COMPILE_DEFINITIONS})
    target_compile_features(${LIBRARY_NAME} PRIVATE cxx_std_20)
    target_compile_options(${LIBRARY_NAME} PRIVATE ${LIBRARY_COMPILE_OPTIONS})
    target_link_libraries(${LIBRARY_NAME} PUBLIC ${LIBRARY_LINK_LIBRARIES})
    target_link_options(${LIBRARY_NAME} PRIVATE ${LIBRARY_LINK_OPTIONS})
  endif()

  include(GNUInstallDirs)
  if(APPLE)
    set_target_properties(${LIBRARY_NAME} PROPERTIES
      INSTALL_RPATH "@loader_path/../${CMAKE_INSTALL_LIBDIR};@loader_path")
  elseif(UNIX)
    cmake_path(RELATIVE_PATH CMAKE_INSTALL_FULL_LIBDIR
      BASE_DIRECTORY ${CMAKE_INSTALL_FULL_BINDIR}
      OUTPUT_VARIABLE libdir_relative_path)
    set_target_properties(${LIBRARY_NAME} PROPERTIES
      INSTALL_RPATH "$ORIGIN/${libdir_relative_path}:$ORIGIN")
  endif()
  add_library(${PROJECT_NAMESPACE}::${LIBRARY_NAME} ALIAS ${LIBRARY_NAME})
  message(STATUS "Configuring library ${LIBRARY_NAME} ...DONE")
endfunction()

##################
##  PROTO FILE  ##
##################
# get_cpp_proto()
# CMake macro to generate Protobuf cpp sources
# Parameters:
#  the proto c++ headers list
#  the proto c++ sources list
# e.g.:
# get_cpp_proto(PROTO_HDRS PROTO_SRCS)
macro(get_cpp_proto PROTO_HDRS PROTO_SRCS)
  file(GLOB_RECURSE PROTO_FILES RELATIVE ${PROJECT_SOURCE_DIR} "*.proto")
  ## Get Protobuf include dir
  get_target_property(protobuf_dirs protobuf::libprotobuf INTERFACE_INCLUDE_DIRECTORIES)
  foreach(dir IN LISTS protobuf_dirs)
    if (NOT "${dir}" MATCHES "INSTALL_INTERFACE|-NOTFOUND")
      message(STATUS "protoc(cc) Adding proto path: ${dir}")
      list(APPEND PROTO_DIRS "--proto_path=${dir}")
    endif()
  endforeach()

  foreach(PROTO_FILE IN LISTS PROTO_FILES)
    message(STATUS "protoc(cc) .proto: ${PROTO_FILE}")
    get_filename_component(PROTO_DIR ${PROTO_FILE} DIRECTORY)
    get_filename_component(PROTO_NAME ${PROTO_FILE} NAME_WE)
    set(PROTO_HDR ${PROJECT_BINARY_DIR}/${PROTO_DIR}/${PROTO_NAME}.pb.h)
    set(PROTO_SRC ${PROJECT_BINARY_DIR}/${PROTO_DIR}/${PROTO_NAME}.pb.cc)
    message(STATUS "protoc(cc) hdr: ${PROTO_HDR}")
    message(STATUS "protoc(cc) src: ${PROTO_SRC}")
    add_custom_command(
      OUTPUT ${PROTO_SRC} ${PROTO_HDR}
      COMMAND ${PROTOC_PRG}
        "--proto_path=${PROJECT_SOURCE_DIR}"
        ${PROTO_DIRS}
        "--cpp_out=dllexport_decl=PROTO_DLL:${PROJECT_BINARY_DIR}"
        ${PROTO_FILE}
      DEPENDS ${PROTO_NAME}.proto ${PROTOC_PRG}
      COMMENT "Generate C++ protocol buffer for ${PROTO_FILE}"
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      VERBATIM)
    list(APPEND ${PROTO_HDRS} ${PROTO_HDR})
    list(APPEND ${PROTO_SRCS} ${PROTO_SRC})
  endforeach()
endmacro()

###################
## CMake Install ##
###################
include(GNUInstallDirs)
#include(GenerateExportHeader)
#GENERATE_EXPORT_HEADER(${PROJECT_NAME})
#install(FILES ${PROJECT_BINARY_DIR}/${PROJECT_NAME}_export.h
#  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

install(EXPORT ${PROJECT_NAME}Targets
  NAMESPACE ${PROJECT_NAMESPACE}::
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
  COMPONENT Devel)
include(CMakePackageConfigHelpers)
configure_package_config_file(cmake/${PROJECT_NAME}Config.cmake.in
  "${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
  INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
  NO_SET_AND_CHECK_MACRO
  NO_CHECK_REQUIRED_COMPONENTS_MACRO)
write_basic_package_version_file(
  "${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
  COMPATIBILITY SameMajorVersion)
install(
  FILES
  "${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
  "${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
  DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
  COMPONENT Devel)
