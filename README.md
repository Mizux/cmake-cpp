[![Build Status][github_status]][github_link]
[![Build Status][travis_status]][travis_link]
[![Build Status][appveyor_status]][appveyor_link]

[github_status]: https://github.com/Mizux/cmake-cpp/workflows/C++%20CI/badge.svg
[github_link]: https://github.com/Mizux/cmake-cpp/actions

[travis_status]: https://travis-ci.com/Mizux/cmake-cpp.svg?branch=master
[travis_link]: https://travis-ci.com/Mizux/cmake-cpp

[appveyor_status]: https://ci.appveyor.com/api/projects/status/cmv8xp5npei1o6w3/branch/master?svg=true
[appveyor_link]: https://ci.appveyor.com/project/Mizux/cmake-cpp/branch/master

# Introduction

This is an example of how to create a Modern [CMake](https://cmake.org/) C++ Project.

This project should run on Linux, Mac and Windows.

# CMake Dependencies Tree
To complexify a little, the CMake project is composed of three libraries (Foo, Bar and FooBar)
with the following dependencies:  
```sh
Foo:
Bar:
FooBar: PUBLIC Foo PRIVATE Bar
FooBarApp: PRIVATE FooBar
```

note: Since `Foo` is a public dependency of `FooBar`, then `FooBarApp` will
*see* `Foo` inlude directories
## Project directory layout
Thus the project layout is as follow:
```sh
 CMakeLists.txt // meta CMake doing the orchestration
 Foo
 ├── CMakeLists.txt
 ├── include
 │   └── foo
 │       └── Foo.hpp
 └── src
     └── Foo.cpp
 Bar
 ├── CMakeLists.txt
 ├── include
 │   └── bar
 │       └── Bar.hpp
 └── src
     └── Bar.cpp
 FooBar
 ├── CMakeLists.txt
 ├── include
 │   └── foobar
 │       └── FooBar.hpp
 └── src
     ├── FooBar.cpp
     └── main.cpp
 FooBarApp
 ├── CMakeLists.txt
 └── src
     └── main.cpp
```

# C++ Project Build
To build the C++ project, as usual:
```sh
mkdir build && cd build
cmake ..
make
```

# Contributing

The [CONTRIBUTING.md](./CONTRIBUTING.md) file contains instructions on how to
file the Contributor License Agreement before sending any pull requests (PRs).
Of course, if you're new to the project, it's usually best to discuss any
proposals and reach consensus before sending your first PR.

# License

Apache 2. See the LICENSE file for details.

# Disclaimer

This is not an official Google product, it is just code that happens to be
owned by Google.
