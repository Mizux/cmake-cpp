add_executable(FooBarApp)
target_sources(FooBarApp PRIVATE src/main.cpp)
target_include_directories(FooBarApp PRIVATE
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
)
target_compile_features(FooBarApp PRIVATE cxx_std_20)
set_target_properties(FooBarApp PROPERTIES
  VERSION ${PROJECT_VERSION}
  POSITION_INDEPENDENT_CODE ON
)
# note: macOS is APPLE and also UNIX !
if(APPLE)
  set_target_properties(FooBarApp PROPERTIES
    INSTALL_RPATH "@loader_path/../${CMAKE_INSTALL_LIBDIR}")
elseif(UNIX AND NOT APPLE)
  set_target_properties(FooBarApp PROPERTIES
    INSTALL_RPATH "$ORIGIN/../${CMAKE_INSTALL_LIBDIR}")
endif()
target_link_libraries(FooBarApp PRIVATE
  absl::flags
  absl::flags_parse
  absl::log
  absl::log_globals
  absl::log_initialize
  absl::log_severity
  absl::strings
  protobuf::libprotobuf
  CMakeCpp::FooBar
)
add_executable(${PROJECT_NAMESPACE}::FooBarApp ALIAS FooBarApp)

if(BUILD_TESTING)
  add_test(NAME cxx_FooBarApp_test COMMAND FooBarApp)
endif()

# Install
include(GNUInstallDirs)
install(TARGETS FooBarApp
  EXPORT ${PROJECT_NAME}Targets
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
