enable_language(CXX)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

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

# Check dependencies
set(CMAKE_THREAD_PREFER_PTHREAD TRUE)
set(THREAD_PREFER_PTHREAD_FLAG TRUE)
find_package(Threads REQUIRED)

include(FetchContent)
set(FETCHCONTENT_QUIET OFF)
set(FETCHCONTENT_UPDATES_DISCONNECTED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_Fortran_COMPILER OFF)

# ##############################################################################
# ABSEIL-CPP
# ##############################################################################
message(CHECK_START "Fetching Abseil-cpp")
list(APPEND CMAKE_MESSAGE_INDENT "  ")
set(ABSL_USE_SYSTEM_INCLUDES ON)
# We want Abseil to declare what C++ standard it was compiled with.
set(ABSL_PROPAGATE_CXX_STD ON)
# We want Abseil to keep the INSTALL rules enabled, even though it is a
# subproject. Otherwise the install rules in this project break.
set(ABSL_ENABLE_INSTALL ON)
FetchContent_Declare(
  absl
  GIT_REPOSITORY "https://github.com/abseil/abseil-cpp.git"
  GIT_TAG "20240116.2"
  GIT_SHALLOW TRUE
  PATCH_COMMAND git apply --ignore-whitespace "${CMAKE_CURRENT_LIST_DIR}/../patches/abseil-cpp-20240116.2.patch"
  OVERRIDE_FIND_PACKAGE)
FetchContent_MakeAvailable(absl)
list(POP_BACK CMAKE_MESSAGE_INDENT)
message(CHECK_PASS "fetched")

# ##############################################################################
# Protobuf
# ##############################################################################
message(CHECK_START "Fetching Protobuf")
list(APPEND CMAKE_MESSAGE_INDENT "  ")
set(protobuf_BUILD_TESTS OFF)
set(protobuf_BUILD_SHARED_LIBS OFF)
set(protobuf_BUILD_EXPORT OFF)
set(protobuf_MSVC_STATIC_RUNTIME OFF)
set(protobuf_WITH_ZLIB OFF)
FetchContent_Declare(
  protobuf
  GIT_REPOSITORY "https://github.com/protocolbuffers/protobuf.git"
  GIT_TAG "v27.2"
  GIT_SUBMODULES ""
  GIT_SHALLOW TRUE
  PATCH_COMMAND git apply --ignore-whitespace "${CMAKE_CURRENT_LIST_DIR}/../patches/protobuf-v27.2.patch")
FetchContent_MakeAvailable(protobuf)
list(POP_BACK CMAKE_MESSAGE_INDENT)
message(CHECK_PASS "fetched")

if(BUILD_TESTING)
  message(CHECK_START "Fetching Googletest")
  FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG main
    GIT_SHALLOW TRUE
    FIND_PACKAGE_ARGS NAMES GTest GMock)
  #set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
  FetchContent_MakeAvailable(googletest)
  message(CHECK_PASS "fetched")

  message(CHECK_START "Fetching Catch2")
  FetchContent_Declare(
    Catch2
    GIT_REPOSITORY https://github.com/catchorg/Catch2.git
    GIT_TAG devel
    GIT_SHALLOW TRUE
    FIND_PACKAGE_ARGS)
  FetchContent_MakeAvailable(Catch2)
  message(CHECK_PASS "fetched")
endif()

include(GNUInstallDirs)

# add_cpp_test()
# CMake function to generate and build C++ test.
# Parameters:
#  the C++ filename
# e.g.:
# add_cpp_test(foo.cpp)
function(add_cpp_test FILE_NAME)
  message(STATUS "Configuring test ${FILE_NAME}: ...")
  get_filename_component(TEST_NAME ${FILE_NAME} NAME_WE)
  get_filename_component(TEST_DIR ${FILE_NAME} DIRECTORY)
  get_filename_component(COMPONENT_DIR ${FILE_NAME} DIRECTORY)
  get_filename_component(COMPONENT_NAME ${COMPONENT_DIR} NAME)

  if(APPLE)
    set(CMAKE_INSTALL_RPATH
      "@loader_path/../${CMAKE_INSTALL_LIBDIR};@loader_path")
  elseif(UNIX)
    set(CMAKE_INSTALL_RPATH "$ORIGIN/../${CMAKE_INSTALL_LIBDIR}:$ORIGIN")
  endif()

  add_executable(${TEST_NAME} ${FILE_NAME})
  target_include_directories(${TEST_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
  target_compile_features(${TEST_NAME} PRIVATE cxx_std_20)
  target_link_libraries(${TEST_NAME} PRIVATE
    Catch2 Catch2WithMain
    ${PROJECT_NAMESPACE}::Foo
    ${PROJECT_NAMESPACE}::Bar
    ${PROJECT_NAMESPACE}::FooBar)

  if(BUILD_TESTING)
    add_test(NAME cpp_${COMPONENT_NAME}_${TEST_NAME} COMMAND ${TEST_NAME})
  endif()
  message(STATUS "Configuring test ${FILE_NAME}: ...DONE")
endfunction()

add_subdirectory(Foo)
add_subdirectory(Bar)
add_subdirectory(FooBar)

add_library(Full)
target_include_directories(Full
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Foo/include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Bar/include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/FooBar/include>
    $<INSTALL_INTERFACE:include>)
#target_link_libraries(Full INTERFACE
# Xcode fails to build if library doesn't contains at least one source file.
if(XCODE)
  file(GENERATE
    OUTPUT ${PROJECT_BINARY_DIR}/${PROJECT_NAME}/version.cpp
    CONTENT "namespace {char* version = \"${PROJECT_VERSION}\";}")
  target_sources(Full PRIVATE ${PROJECT_BINARY_DIR}/${PROJECT_NAME}/version.cpp)
endif()
target_sources(Full PRIVATE
  $<TARGET_OBJECTS:Bar>
  $<TARGET_OBJECTS:Foo>
  $<TARGET_OBJECTS:FooBar>
)
add_library(${PROJECT_NAMESPACE}::Full ALIAS Full)
install(TARGETS Full
  EXPORT ${PROJECT_NAME}Targets
  PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/foobar
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  #RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  )

add_subdirectory(FooBarApp)

# Install
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

# add_cpp_example()
# CMake function to generate and build C++ example.
# Parameters:
#  the C++ filename
# e.g.:
# add_cpp_example(foo.cpp)
function(add_cpp_example FILE_NAME)
  message(STATUS "Configuring example ${FILE_NAME}: ...")
  get_filename_component(EXAMPLE_NAME ${FILE_NAME} NAME_WE)
  get_filename_component(COMPONENT_DIR ${FILE_NAME} DIRECTORY)
  get_filename_component(COMPONENT_NAME ${COMPONENT_DIR} NAME)

  if(APPLE)
    set(CMAKE_INSTALL_RPATH
      "@loader_path/../${CMAKE_INSTALL_LIBDIR};@loader_path")
  elseif(UNIX)
    set(CMAKE_INSTALL_RPATH "$ORIGIN/../${CMAKE_INSTALL_LIBDIR}:$ORIGIN")
  endif()

  add_executable(${EXAMPLE_NAME} ${FILE_NAME})
  target_include_directories(${EXAMPLE_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
  target_compile_features(${EXAMPLE_NAME} PRIVATE cxx_std_20)
  target_link_libraries(${EXAMPLE_NAME} PRIVATE
    ${PROJECT_NAMESPACE}::Full
  )

  include(GNUInstallDirs)
  install(TARGETS ${EXAMPLE_NAME})

  if(BUILD_TESTING)
    add_test(NAME cpp_${COMPONENT_NAME}_${EXAMPLE_NAME} COMMAND ${EXAMPLE_NAME})
  endif()
  message(STATUS "Configuring example ${FILE_NAME}: ...DONE")
endfunction()
