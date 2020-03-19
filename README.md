Github-CI:
[![Build Status][github_docker_status]][github_docker_link]
[![Build Status][github_linux_status]][github_linux_link]
[![Build Status][github_macos_status]][github_macos_link]
[![Build Status][github_windows_status]][github_windows_link]

Travis-CI:
[![Build Status][travis_status]][travis_link]

Appveyor-CI:
[![Build Status][appveyor_status]][appveyor_link]

[github_docker_status]: https://github.com/Mizux/cmake-cpp/workflows/Docker/badge.svg
[github_docker_link]: https://github.com/Mizux/cmake-cpp/actions?query=workflow%3ADocker

[github_linux_status]: https://github.com/Mizux/cmake-cpp/workflows/Linux/badge.svg
[github_linux_link]: https://github.com/Mizux/cmake-cpp/actions?query=workflow%3ALinux

[github_macos_status]: https://github.com/Mizux/cmake-cpp/workflows/MacOS/badge.svg
[github_macos_link]: https://github.com/Mizux/cmake-cpp/actions?query=workflow%3AMacOS

[github_windows_status]: https://github.com/Mizux/cmake-cpp/workflows/Windows/badge.svg
[github_windows_link]: https://github.com/Mizux/cmake-cpp/actions?query=workflow%3AWindows

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
