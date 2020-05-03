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
<nav for="project"> |
<a href="#dependencies">Dependencies</a> |
<a href="#codemap">Codemap</a> |
<a href="#build">Build</a> |
<a href="ci/README.md">CI</a> |
<a href="#license">License</a> |
</nav>
This is an example of how to create a Modern [CMake](https://cmake.org/) C++ Project.

This project should run on Linux, Mac and Windows.

# [Dependencies Tree](#dependencies)
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

# [Project directory layout](#codemap)
Thus the project layout is as follow:

* [CMakeLists.txt](CMakeLists.txt) Top-level for [CMake](https://cmake.org/cmake/help/latest/) based build.
* [cmake](cmake) Subsidiary CMake files.

* [ci](ci) Root directory for continuous integration.

* [Foo](Foo) Root directory for `Foo` library.
  * [CMakeLists.txt](Foo/CMakeLists.txt) for `Foo`.
  * [include](Foo/include) public folder.
    * [foo](Foo/include/foo)
      * [Foo.hpp](Foo/include/foo/Foo.hpp)
  * [src](Foo/src) private folder.
    * [src/Foo.cpp](Foo/src/Foo.cpp)
* [Bar](Bar) Root directory for `Bar` library.
  * [CMakeLists.txt](Bar/CMakeLists.txt) for `Bar`.
  * [include](Bar/include) public folder.
    * [bar](Bar/include/bar)
      * [Bar.hpp](Bar/include/bar/Bar.hpp)
  * [src](Bar/src) private folder.
    * [src/Bar.cpp](Bar/src/Bar.cpp)
* [FooBar](FooBar) Root directory for `FooBar` library.
  * [CMakeLists.txt](FooBar/CMakeLists.txt) for `FooBar`.
  * [include](FooBar/include) public folder.
    * [foobar](FooBar/include/foobar)
      * [FooBar.hpp](FooBar/include/foobar/FooBar.hpp)
  * [src](FooBar/src) private folder.
    * [src/FooBar.cpp](FooBar/src/FooBar.cpp)
* [FooBarApp](FooBarApp) Root directory for `FooBarApp` executable.
  * [CMakeLists.txt](FooBarApp/CMakeLists.txt) for `FooBarApp`.
  * [src](FooBarApp/src) private folder.
    * [src/main.cpp](FooBarApp/src/main.cpp)

# [C++ Project Build](#build)
To build the C++ project, as usual:
```sh
cmake -S. -Bbuild
cmake --build build
```

# [License](#license)

Apache 2. See the LICENSE file for details.

# Disclaimer

This is not an official Google product, it is just code that happens to be
owned by Google.
