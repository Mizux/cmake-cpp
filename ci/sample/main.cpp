#include <iostream>

#include <foo/Foo.hpp>
#include <bar/Bar.hpp>
#include <foobar/FooBar.hpp>

int main(int /*argc*/, char** /*argv*/) {
  foo::fooHello(1);
  bar::barHello(1);
  foobar::foobarHello(1);
  std::cout << std::endl;
  foobar::FooBar::hello(int{1});
  std::cout << std::endl;

  return 0;
}
