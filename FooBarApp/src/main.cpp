#include <absl/base/log_severity.h>
#include <absl/flags/parse.h>
#include <absl/flags/usage.h>
#include <absl/log/globals.h>
#include <absl/log/initialize.h>
#include <absl/log/log.h>
#include <absl/strings/str_join.h>

#include <cstdint>
#include <foobar/FooBar.hpp>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

void* kVar = [] {
  std::cerr << "kFooBarApp\n";
  return nullptr;
}();

int main(int argc, char* argv[]) {
  absl::InitializeLog();
  absl::SetProgramUsageMessage("FooBarApp");
  absl::EnableLogPrefix(false);
  absl::SetStderrThreshold(absl::LogSeverity::kInfo);
  absl::ParseCommandLine(argc, argv);
  {
    const std::vector<std::string> v = {"foo", "bar", "baz"};
    std::string s = absl::StrJoin(v, "-");
    LOG(INFO) << "Joined string: " << s << "\n";
  }

  foobar::freeFunction(int{0});
  LOG(INFO) << std::endl;
  foobar::freeFunction(int64_t{1});
  LOG(INFO) << std::endl;

  foobar::FooBar::staticFunction(int{2});
  LOG(INFO) << std::endl;
  foobar::FooBar::staticFunction(int64_t{3});
  LOG(INFO) << std::endl;

  foobar::FooBar f;
  f.setBarInt(13);
  f.setFooInt(17);
  LOG(INFO) << std::to_string(f.getInt()) << std::endl;

  f.setBarInt64(int64_t{31});
  f.setFooInt64(int64_t{42});
  LOG(INFO) << std::to_string(f.getInt64()) << std::endl;

  LOG(INFO) << f() << std::endl;

  return 0;
}
