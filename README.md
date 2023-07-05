Github-CI:<br>
[![Build Status][amd64_linux_status]][amd64_linux_link]
[![Build Status][amd64_macos_status]][amd64_macos_link]
[![Build Status][amd64_windows_status]][amd64_windows_link]<br>

[![Build Status][amd64_docker_status]][amd64_docker_link]
[![Build Status][arm64_docker_status]][arm64_docker_link]
[![Build Status][riscv64_docker_status]][riscv64_docker_link]<br>

[![Build Status][arm_toolchain_status]][arm_toolchain_link]
[![Build Status][aarch64_toolchain_status]][aarch64_toolchain_link]
[![Build Status][mips_toolchain_status]][mips_toolchain_link]
[![Build Status][mips64_toolchain_status]][mips64_toolchain_link]
[![Build Status][powerpc_toolchain_status]][powerpc_toolchain_link]
[![Build Status][riscv64_toolchain_status]][riscv64_toolchain_link]<br>

[amd64_linux_status]: ./../../actions/workflows/amd64_linux.yml/badge.svg
[amd64_linux_link]: ./../../actions/workflows/amd64_linux.yml
[amd64_macos_status]: ./../../actions/workflows/amd64_macos.yml/badge.svg
[amd64_macos_link]: ./../../actions/workflows/amd64_macos.yml
[amd64_windows_status]: ./../../actions/workflows/amd64_windows.yml/badge.svg
[amd64_windows_link]: ./../../actions/workflows/amd64_windows.yml

[amd64_docker_status]: ./../../actions/workflows/amd64_docker.yml/badge.svg
[amd64_docker_link]: ./../../actions/workflows/amd64_docker.yml
[arm64_docker_status]: ./../../actions/workflows/arm64_docker.yml/badge.svg
[arm64_docker_link]: ./../../actions/workflows/arm64_docker.yml
[riscv64_docker_status]: ./../../actions/workflows/riscv64_docker.yml/badge.svg
[riscv64_docker_link]: ./../../actions/workflows/riscv64_docker.yml

[arm_toolchain_status]: ./../../actions/workflows/arm_toolchain.yml/badge.svg
[arm_toolchain_link]: ./../../actions/workflows/arm_toolchain.yml
[aarch64_toolchain_status]: ./../../actions/workflows/aarch64_toolchain.yml/badge.svg
[aarch64_toolchain_link]: ./../../actions/workflows/aarch64_toolchain.yml
[mips_toolchain_status]: ./../../actions/workflows/mips_toolchain.yml/badge.svg
[mips_toolchain_link]: ./../../actions/workflows/mips_toolchain.yml
[mips64_toolchain_status]: ./../../actions/workflows/mips64_toolchain.yml/badge.svg
[mips64_toolchain_link]: ./../../actions/workflows/mips64_toolchain.yml
[powerpc_toolchain_status]: ./../../actions/workflows/powerpc_toolchain.yml/badge.svg
[powerpc_toolchain_link]: ./../../actions/workflows/powerpc_toolchain.yml
[riscv64_toolchain_status]: ./../../actions/workflows/riscv64_toolchain.yml/badge.svg
[riscv64_toolchain_link]: ./../../actions/workflows/riscv64_toolchain.yml

# Introduction
<nav for="project"> |
<a href="#requirement">Requirement</a> |
<a href="#codemap">Codemap</a> |
<a href="#dependencies">Dependencies</a> |
<a href="#build">Build</a> |
<a href="ci/README.md">CI</a> |
<a href="#appendices">Appendices</a> |
<a href="#license">License</a> |
</nav>

This is an example of how to create a Modern [CMake](https://cmake.org/) C++ Project.

This project should run on GNU/Linux, MacOS and Windows.

## Requirement
You'll need:

* "CMake >= 3.16".

## Codemap
The project layout is as follow:

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

## Dependencies
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

## Build
To build the C++ project, as usual:
```sh
cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
```

## Appendices
Few links on the subject...

### Resources
Project layout:
* The Pitchfork Layout Revision 1 (cxx-pflR1)

CMake:
* https://llvm.org/docs/CMakePrimer.html
* https://cliutils.gitlab.io/modern-cmake/
* https://cgold.readthedocs.io/en/latest/

### Misc
Image has been generated using [plantuml](http://plantuml.com/):
```bash
plantuml -Tsvg docs/{file}.dot
```
So you can find the dot source files in [ci/docs](ci/docs).

## License
Apache 2. See the LICENSE file for details.

## Disclaimer
This is not an official Google product, it is just code that happens to be
owned by Google.

