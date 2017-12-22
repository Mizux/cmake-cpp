#include <bar/Bar.hpp>

#include <iostream>

namespace bar {
  void hello() {
    std::cout << "bar::hello" << std::endl;
  }

void Bar::operator()() const {
	std::cout << "Bar()" << std::endl;
}
}

