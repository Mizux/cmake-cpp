add_cxx_library(
  NAME
    Foo
  HEADERS
    include/foo/Foo.hpp
  SOURCES
    src/Foo.cpp
  LINK_LIBRARIES
    absl::log
  INSTALL_DIR
    foo
)

add_subdirectory(tests)
