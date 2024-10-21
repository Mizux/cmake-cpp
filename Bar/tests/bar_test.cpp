#include <bar/Bar.hpp>

#include <gtest/gtest.h>
#include <iostream>
#include <numeric>
#include <string>

namespace bar {

TEST(BarTest, FreeFunction) {
  EXPECT_NO_THROW(freeFunction(42));
  EXPECT_NO_THROW(freeFunction(int64_t{42}));
}

TEST(BarTest, StringVectorOutput) {
  std::vector<std::string> result;
  ASSERT_NO_THROW(result = stringVectorOutput(8));
  EXPECT_EQ(result.size(), 8);
  for (const auto& it : result) {
    EXPECT_EQ(it, std::to_string(8));
  }
}

TEST(BarTest, StringVectorValueInput) {
  const std::vector<std::string> data{"1", "2", "3", "4", "5"};
  int                            size = 0;
  ASSERT_NO_THROW(size = stringVectorInput(data));
  EXPECT_EQ(size, 5);
}

TEST(BarTest, StringVectorRefInput) {
  const std::vector<std::string> data{"1", "2", "3", "4", "5"};
  int                            size = 0;
  ASSERT_NO_THROW(size = stringVectorRefInput(data));
  EXPECT_EQ(size, 5);
}

TEST(BarTest, StringJaggedArrayOutput) {
  std::vector<std::vector<std::string>> result;
  ASSERT_NO_THROW(result = stringJaggedArrayOutput(8));
  EXPECT_EQ(result.size(), 8);
  for (std::size_t i = 0; i < result.size(); ++i) {
    EXPECT_EQ(i + 1, result[i].size());
  }
  for (std::size_t i = 1; i <= result.size(); ++i) {
    const auto& inner = result[i - 1];
    for (const auto& it : inner) {
      EXPECT_EQ(it, std::to_string(i));
    }
  }
}

TEST(BarTest, StringJaggedArrayValueInput) {
  const std::vector<std::vector<std::string>> data{{"1", "2", "3"}, {"4", "5"}};
  int                                         size = 0;
  ASSERT_NO_THROW(size = stringJaggedArrayInput(data));
  EXPECT_EQ(size, 2);
}

TEST(BarTest, StringJaggedArrayRefInput) {
  const std::vector<std::vector<std::string>> data{{"1", "2", "3"}, {"4", "5"}};
  int                                         size = 0;
  ASSERT_NO_THROW(size = stringJaggedArrayRefInput(data));
  EXPECT_EQ(size, 2);
}

TEST(BarTest, PairVectorOutput) {
  std::vector<std::pair<int, int>> result;
  ASSERT_NO_THROW(result = pairVectorOutput(8));
  EXPECT_EQ(result.size(), 8);
  for (const auto& it : result) {
    EXPECT_EQ(it.first, 8);
    EXPECT_EQ(it.second, 8);
  }
}

TEST(BarTest, PairVectorValueInput) {
  const std::vector<std::pair<int, int>> data{{1, 2}, {3, 4}, {5, 6}};
  int                                    size = 0;
  ASSERT_NO_THROW(size = pairVectorInput(data));
  EXPECT_EQ(size, 3);
}

TEST(BarTest, PairVectorRefInput) {
  const std::vector<std::pair<int, int>> data{{1, 2}, {3, 4}, {5, 6}};
  int                                    size = 0;
  ASSERT_NO_THROW(size = pairVectorRefInput(data));
  EXPECT_EQ(size, 3);
}

TEST(BarTest, PairJaggedArrayOutput) {
  std::vector<std::vector<std::pair<int, int>>> result;
  ASSERT_NO_THROW(result = pairJaggedArrayOutput(8));
  EXPECT_EQ(result.size(), 8);
  for (std::size_t i = 0; i < result.size(); ++i) {
    EXPECT_EQ(i + 1, result[i].size());
  }
  for (int i = 1; i <= static_cast<int>(result.size()); ++i) {
    const auto& inner = result[i - 1];
    for (const auto& it : inner) {
      EXPECT_EQ(it, std::make_pair(i, i));
    }
  }
}

TEST(BarTest, PairJaggedArrayValueInput) {
  std::vector<std::vector<std::pair<int, int>>> data{{{1, 1}, {2, 2}, {3, 3}}, {{4, 4}, {5, 5}}};
  int                                           size = 0;
  ASSERT_NO_THROW(size = pairJaggedArrayInput(data));
  EXPECT_EQ(size, 2);
}

TEST(BarTest, PairJaggedArrayRefInput) {
  std::vector<std::vector<std::pair<int, int>>> data{{{1, 1}, {2, 2}, {3, 3}}, {{4, 4}, {5, 5}}};
  int                                           size = 0;
  ASSERT_NO_THROW(size = pairJaggedArrayRefInput(data));
  EXPECT_EQ(size, 2);
}

TEST(BarTest, StaticMethods) {
  EXPECT_NO_THROW(Bar::staticFunction(42));
  EXPECT_NO_THROW(Bar::staticFunction(int64_t{42}));
}

TEST(BarTest, Constructor) {
  Bar* b = new Bar();
  EXPECT_NE(b, nullptr);
}

TEST(BarTest, IntMethods) {
  Bar bar;
  ASSERT_NO_THROW(bar.setInt(42));
  EXPECT_EQ(42, bar.getInt());
}

TEST(BarTest, Int64Methods) {
  Bar bar;
  ASSERT_NO_THROW(bar.setInt64(31));
  EXPECT_EQ(31, bar.getInt64());
}

TEST(BarTest, PrintMethod) {
  Bar         bar;
  std::string str("");
  ASSERT_NO_THROW(str = bar());
  EXPECT_EQ("\"Bar\":{\"int\":0,\"int64\":0}", str);
}

} // namespace bar
