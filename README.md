[![Build Status](https://travis-ci.org/Mizux/cpp-template.svg?branch=master)](https://travis-ci.org/Mizux/cpp-template)
[![Build status](https://ci.appveyor.com/api/projects/status/9mrdg0m9u1a2r3ji?svg=true)](https://ci.appveyor.com/project/Mizux/cpp-template)

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
