#include "foobar/FooBar.hpp"

#include <absl/log/log.h>

#include <iostream>
#include <memory>
#include <string>
#include <utility>

#include "bar/Bar.hpp"
#include "foo/Foo.hpp"

namespace foobar {
using std::make_unique;

std::vector<std::string> stringVectorOutput(int level) {
  LOG(INFO) << "[" << level << "] Enter " << __func__ << "()" << std::endl;
  std::vector<std::string> result;
  auto foo_vec = foo::stringVectorOutput(level + 1);
  auto bar_vec = bar::stringVectorOutput(level + 1);
  result.insert(result.end(), foo_vec.begin(), foo_vec.end());
  result.insert(result.end(), bar_vec.begin(), bar_vec.end());
  LOG(INFO) << "[" << level << "] Exit " << __func__ << "()" << std::endl;
  return result;
}

int stringVectorInput(std::vector<std::string> data) {
  LOG(INFO) << "Enter " << __func__ << "()" << std::endl;
  LOG(INFO) << "{";
  for (const auto& item : data) {
    LOG(INFO) << item << ", ";
  }
  LOG(INFO) << "}" << std::endl;
  LOG(INFO) << "Exit " << __func__ << "()" << std::endl;
  return data.size();
}

int stringVectorRefInput(const std::vector<std::string>& data) {
  LOG(INFO) << "Enter " << __func__ << "()" << std::endl;
  LOG(INFO) << "{";
  for (const auto& item : data) {
    LOG(INFO) << item << ", ";
  }
  LOG(INFO) << "}" << std::endl;
  LOG(INFO) << "Exit " << __func__ << "()" << std::endl;
  return data.size();
}

std::vector<std::vector<std::string>> stringJaggedArrayOutput(int level) {
  LOG(INFO) << "[" << level << "] Enter " << __func__ << "()" << std::endl;
  std::vector<std::vector<std::string>> result;
  result.reserve(level);
  for (int i = 1; i <= level; ++i) {
    result.emplace_back(std::vector<std::string>(i, std::to_string(i)));
  }
  LOG(INFO) << "[" << level << "] Exit " << __func__ << "()" << std::endl;
  return result;
}

int stringJaggedArrayInput(std::vector<std::vector<std::string>> data) {
  LOG(INFO) << "Enter " << __func__ << "()" << std::endl;
  LOG(INFO) << "{";
  for (const auto& inner : data) {
    LOG(INFO) << "{";
    for (const auto& item : inner) {
      LOG(INFO) << item << ", ";
    }
    LOG(INFO) << "}, ";
  }
  LOG(INFO) << "}" << std::endl;
  LOG(INFO) << "Exit " << __func__ << "()" << std::endl;
  return data.size();
}

int stringJaggedArrayRefInput(
    const std::vector<std::vector<std::string>>& data) {
  LOG(INFO) << "Enter " << __func__ << "()" << std::endl;
  LOG(INFO) << "{";
  for (const auto& inner : data) {
    LOG(INFO) << "{";
    for (const auto& item : inner) {
      LOG(INFO) << item << ", ";
    }
    LOG(INFO) << "}, ";
  }
  LOG(INFO) << "}" << std::endl;
  LOG(INFO) << "Exit " << __func__ << "()" << std::endl;
  return data.size();
}

std::vector<std::pair<int, int>> pairVectorOutput(int level) {
  LOG(INFO) << "[" << level << "] Enter " << __func__ << "()" << std::endl;
  std::vector<std::pair<int, int>> result;
  auto foo_vec = foo::pairVectorOutput(level + 1);
  auto bar_vec = bar::pairVectorOutput(level + 1);
  result.insert(result.end(), foo_vec.begin(), foo_vec.end());
  result.insert(result.end(), bar_vec.begin(), bar_vec.end());
  LOG(INFO) << "[" << level << "] Exit " << __func__ << "()" << std::endl;
  return result;
}

int pairVectorInput(std::vector<std::pair<int, int>> data) {
  LOG(INFO) << "Enter " << __func__ << "()" << std::endl;
  LOG(INFO) << "{";
  for (const auto& item : data) {
    LOG(INFO) << "[" << item.first << "," << item.second << "], ";
  }
  LOG(INFO) << "}" << std::endl;
  LOG(INFO) << "Exit " << __func__ << "()" << std::endl;
  return data.size();
}

int pairVectorRefInput(const std::vector<std::pair<int, int>>& data) {
  LOG(INFO) << "Enter " << __func__ << "()" << std::endl;
  LOG(INFO) << "{";
  for (const auto& item : data) {
    LOG(INFO) << "[" << item.first << "," << item.second << "], ";
  }
  LOG(INFO) << "}" << std::endl;
  LOG(INFO) << "Exit " << __func__ << "()" << std::endl;
  return data.size();
}

std::vector<std::vector<std::pair<int, int>>> pairJaggedArrayOutput(int level) {
  LOG(INFO) << "[" << level << "] Enter " << __func__ << "()" << std::endl;
  std::vector<std::vector<std::pair<int, int>>> result;
  result.reserve(level);
  for (int i = 1; i <= level; ++i) {
    result.emplace_back(
        std::vector<std::pair<int, int>>(i, std::make_pair(i, i)));
  }
  LOG(INFO) << "[" << level << "] Exit " << __func__ << "()" << std::endl;
  return result;
}

int pairJaggedArrayInput(std::vector<std::vector<std::pair<int, int>>> data) {
  LOG(INFO) << "Enter " << __func__ << "()" << std::endl;
  LOG(INFO) << "{";
  for (const auto& inner : data) {
    LOG(INFO) << "{";
    for (const auto& item : inner) {
      LOG(INFO) << "[" << item.first << "," << item.second << "], ";
    }
    LOG(INFO) << "}, ";
  }
  LOG(INFO) << "}" << std::endl;
  LOG(INFO) << "Exit " << __func__ << "()" << std::endl;
  return data.size();
}

int pairJaggedArrayRefInput(
    const std::vector<std::vector<std::pair<int, int>>>& data) {
  LOG(INFO) << "Enter " << __func__ << "()" << std::endl;
  LOG(INFO) << "{";
  for (const auto& inner : data) {
    LOG(INFO) << "{";
    for (const auto& item : inner) {
      LOG(INFO) << "[" << item.first << "," << item.second << "], ";
    }
    LOG(INFO) << "}, ";
  }
  LOG(INFO) << "}" << std::endl;
  LOG(INFO) << "Exit " << __func__ << "()" << std::endl;
  return data.size();
}

void freeFunction(int level) {
  LOG(INFO) << "[" << level << "] Enter " << __func__ << "(int)" << std::endl;
  foo::freeFunction(level + 1);
  bar::freeFunction(level + 1);
  LOG(INFO) << "[" << level << "] Exit " << __func__ << "(int)" << std::endl;
}

void freeFunction(int64_t level) {
  LOG(INFO) << "[" << level << "] Enter " << __func__ << "(int64_t)"
            << std::endl;
  foo::freeFunction(level + 1);
  bar::freeFunction(level + 1);
  LOG(INFO) << "[" << level << "] Exit " << __func__ << "(int64_t)"
            << std::endl;
}

void FooBar::staticFunction(int level) {
  LOG(INFO) << "[" << level << "] Enter " << __func__ << "(int)" << std::endl;
  freeFunction(level + 1);
  LOG(INFO) << "[" << level << "] Exit " << __func__ << "(int)" << std::endl;
}

void FooBar::staticFunction(int64_t level) {
  LOG(INFO) << "[" << level << "] Enter " << __func__ << "(int64_t)"
            << std::endl;
  freeFunction(level + 1);
  LOG(INFO) << "[" << level << "] Exit " << __func__ << "(int64_t)"
            << std::endl;
}

FooBar::FooBar() {
  _bar = make_unique<bar::Bar>();
  _foo = make_unique<foo::Foo>();
}

FooBar::~FooBar() {}

int FooBar::getInt() const { return _bar->getInt() + _foo->getInt(); }

void FooBar::setBarInt(int input) { _bar->setInt(input); }

void FooBar::setFooInt(int input) { _foo->setInt(input); }

int64_t FooBar::getInt64() const { return _bar->getInt64() + _foo->getInt64(); }

void FooBar::setBarInt64(int64_t input) { _bar->setInt64(input); }

void FooBar::setFooInt64(int64_t input) { _foo->setInt64(input); }

std::string FooBar::operator()() const {
  return std::string{"\"FooBar\":{"} + (*_bar)() + "," + (*_foo)() + "}";
}

namespace {
void* kVar = [] {
  std::cerr << "kFooBar" << std::endl;
  return nullptr;
}();
}  // namespace

}  // namespace foobar
