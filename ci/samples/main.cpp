#include <absl/base/log_severity.h>
#include <absl/flags/parse.h>
#include <absl/flags/usage.h>
#include <absl/log/globals.h>
#include <absl/log/initialize.h>
#include <absl/log/log.h>
#include <absl/strings/str_join.h>

#include <bar/Bar.hpp>
#include <foo/Foo.hpp>
#include <foobar/FooBar.hpp>
#include <iostream>
#include <string>
#include <vector>

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

  foo::freeFunction(0);
  bar::freeFunction(1);
  foobar::freeFunction(2);
  std::cout << std::endl;

  foo::Foo::staticFunction(int{0});
  bar::Bar::staticFunction(int{1});
  foobar::FooBar::staticFunction(int{2});
  std::cout << std::endl;

  return 0;
}
