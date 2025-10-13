add_cxx_library(
  NAME
    Bar
  HEADERS
    include/bar/Bar.hpp
  SOURCES
    src/Bar.cpp
  LINK_LIBRARIES
    absl::log
  INSTALL_DIR
    bar
)

add_subdirectory(tests)
