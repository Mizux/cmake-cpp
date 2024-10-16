#include "bar/Bar.hpp"

#include <iostream>
#include <string>
#include <utility>

#include "absl/log/log.h"

namespace bar {
std::vector<std::string> stringVectorOutput(int level) {
  LOG(INFO) << "[" << level << "] Enter " << __func__ << "()" << std::endl;
  std::vector<std::string> result(level, std::to_string(level));
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

int stringJaggedArrayRefInput(const std::vector<std::vector<std::string>>& data) {
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
  std::vector<std::pair<int, int>> result(level, std::make_pair(level, level));
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
    result.emplace_back(std::vector<std::pair<int, int>>(i, std::make_pair(i, i)));
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

int pairJaggedArrayRefInput(const std::vector<std::vector<std::pair<int, int>>>& data) {
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
  LOG(INFO) << "[" << level << "] Exit " << __func__ << "(int)" << std::endl;
}

void freeFunction(int64_t level) {
  LOG(INFO) << "[" << level << "] Enter " << __func__ << "(int64_t)" << std::endl;
  LOG(INFO) << "[" << level << "] Exit " << __func__ << "(int64_t)" << std::endl;
}

void Bar::staticFunction(int level) {
  LOG(INFO) << "[" << level << "] Enter " << __func__ << "(int)" << std::endl;
  freeFunction(level + 1);
  LOG(INFO) << "[" << level << "] Exit " << __func__ << "(int)" << std::endl;
}

void Bar::staticFunction(int64_t level) {
  LOG(INFO) << "[" << level << "] Enter " << __func__ << "(int64_t)" << std::endl;
  freeFunction(level + 1);
  LOG(INFO) << "[" << level << "] Exit " << __func__ << "(int64_t)" << std::endl;
}

int Bar::getInt() const {
  return _intValue;
}

void Bar::setInt(int input) {
  _intValue = input;
}

int64_t Bar::getInt64() const {
  return _int64Value;
}

void Bar::setInt64(int64_t input) {
  _int64Value = input;
}

std::string Bar::operator()() const {
  return std::string{"\"Bar\":{\"int\":"} + std::to_string(_intValue) +
         ",\"int64\":" + std::to_string(_int64Value) + "}";
}

namespace {
void* kVar = [] {
  std::cerr << "kBar" << std::endl;
  return nullptr;
}();
} // namespace

} // namespace bar
