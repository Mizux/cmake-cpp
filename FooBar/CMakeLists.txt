add_cxx_library(
  NAME
    FooBar
  HEADERS
    include/foobar/FooBar.hpp
  SOURCES
    src/FooBar.cpp
  LINK_LIBRARIES
    absl::log Bar Foo
  INSTALL_DIR
    foobar
)

add_subdirectory(tests)
