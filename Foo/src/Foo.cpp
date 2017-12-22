#include <foo/Foo.hpp>

#include <iostream>

namespace foo {
  void hello() {
    std::cout << "foo::hello" << std::endl;
  }

void Foo::operator()() const {
	std::cout << "Foo()" << std::endl;
}
}

