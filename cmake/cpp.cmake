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
