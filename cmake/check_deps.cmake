# Check dependencies
if(NOT TARGET ZLIB::ZLIB)
  message(FATAL_ERROR "Target ZLIB::ZLIB not available.")
endif()

if(NOT TARGET absl::base)
  message(FATAL_ERROR "Target absl::base not available.")
endif()
set(ABSL_DEPS
  absl::base
  absl::core_headers
  absl::absl_check
  absl::absl_log
  absl::check
  absl::die_if_null
  absl::flags
  absl::flags_commandlineflag
  absl::flags_marshalling
  absl::flags_parse
  absl::flags_reflection
  absl::flags_usage
  absl::log
  absl::log_flags
  absl::log_globals
  absl::log_initialize
  absl::log_internal_message
  absl::cord
  absl::random_random
  absl::raw_hash_set
  absl::hash
  absl::leak_check
  absl::memory
  absl::meta
  absl::stacktrace
  absl::status
  absl::statusor
  absl::str_format
  absl::strings
  absl::synchronization
  absl::time
  absl::any
  )

if(NOT TARGET re2::re2)
  message(FATAL_ERROR "Target re2::re2 not available.")
endif()
set(RE2_DEPS re2::re2)

if(NOT TARGET protobuf::libprotobuf)
  message(FATAL_ERROR "Target protobuf::libprotobuf not available.")
endif()

# CXX Test
if(BUILD_TESTING)
  if(NOT TARGET GTest::gtest)
    message(FATAL_ERROR "Target GTest::gtest not available.")
  endif()
  if(NOT TARGET GTest::gtest_main)
    message(FATAL_ERROR "Target GTest::gtest_main not available.")
  endif()
  if(NOT TARGET benchmark::benchmark)
    message(FATAL_ERROR "Target benchmark::benchmark not available.")
  endif()
endif()
