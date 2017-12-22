#include <foobar/FooBar.hpp>

#include <iostream>
#include <foo/Foo.hpp>
#include <bar/Bar.hpp>

namespace foobar {
  void hello() {
		foo::hello();
		bar::hello();
		std::cout << "foobar::hello" << std::endl;
  }

void FooBar::operator()() const {
	foo::Foo foo;
	bar::Bar bar;
	foo();
	bar();
	std::cout << "FooBar()" << std::endl;
}
}

