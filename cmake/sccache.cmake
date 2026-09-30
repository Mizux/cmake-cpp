if(CMAKE_C_COMPILER_LAUNCHER OR CMAKE_CXX_COMPILER_LAUNCHER)
  message(STATUS "Configuring SCCache - skipped")
  return()
endif()

find_program(SCCACHE_PROGRAM sccache)
if(SCCACHE_PROGRAM)
  if(MSVC)
  set(CMAKE_C_COMPILER_LAUNCHER ${SCCACHE_PROGRAM})
  set(CMAKE_CXX_COMPILER_LAUNCHER ${SCCACHE_PROGRAM})
    set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT "$<$<CONFIG:Debug,RelWithDebInfo>:Embedded>")
  else()
    # Set up wrapper scripts
    set(C_LAUNCHER   "${SCCACHE_PROGRAM}")
    set(CXX_LAUNCHER "${SCCACHE_PROGRAM}")

    file(WRITE "${CMAKE_BINARY_DIR}/launch-c"
      "#!/usr/bin/env sh\n"
      "# Xcode generator doesn't include the compiler as the\n"
      "# first argument, Ninja and Makefiles do. Handle both cases.\n"
      "if [ \"$1\" = \"${CMAKE_C_COMPILER}\" ]; then\n"
      "  shift\n"
      "fi\n"
      "exec \"${C_LAUNCHER}\" \"${CMAKE_C_COMPILER}\" \"$@\"\n"
    )
    file(WRITE "${CMAKE_BINARY_DIR}/launch-cxx"
      "#!/usr/bin/env sh\n"
      "# Xcode generator doesn't include the compiler as the\n"
      "# first argument, Ninja and Makefiles do. Handle both cases.\n"
      "if [ \"$1\" = \"${CMAKE_CXX_COMPILER}\" ]; then\n"
      "  shift\n"
      "fi\n"
      "exec \"${CXX_LAUNCHER}\" \"${CMAKE_CXX_COMPILER}\" \"$@\"\n"
    )
    file(CHMOD
      "${CMAKE_BINARY_DIR}/launch-c"
      "${CMAKE_BINARY_DIR}/launch-cxx"
      FILE_PERMISSIONS
      OWNER_READ OWNER_EXECUTE
      GROUP_READ GROUP_EXECUTE
      WORLD_READ WORLD_EXECUTE)

    if(CMAKE_GENERATOR STREQUAL "Xcode")
      # Set Xcode project attributes to route compilation and linking
      # through our scripts
      set(CMAKE_XCODE_ATTRIBUTE_CC         "${CMAKE_BINARY_DIR}/launch-c")
      set(CMAKE_XCODE_ATTRIBUTE_CXX        "${CMAKE_BINARY_DIR}/launch-cxx")
      set(CMAKE_XCODE_ATTRIBUTE_LD         "${CMAKE_BINARY_DIR}/launch-c")
      set(CMAKE_XCODE_ATTRIBUTE_LDPLUSPLUS "${CMAKE_BINARY_DIR}/launch-cxx")
    else()
      # Support Unix Makefiles and Ninja
      set(CMAKE_C_COMPILER_LAUNCHER   "${CMAKE_BINARY_DIR}/launch-c")
      set(CMAKE_CXX_COMPILER_LAUNCHER "${CMAKE_BINARY_DIR}/launch-cxx")
    endif()
  endif()
  message(STATUS "Configuring SCCache - done")
else()
  message(STATUS "Looking for SCCache - not found")
endif()
