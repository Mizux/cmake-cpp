# CI: Makefile/Docker testing
To test the build on various distro, I'm using docker containers and a Makefile for orchestration.

pros:
* You are independent of third party CI runner config (e.g. github actions runners or Travis-CI VM images).
* You can run it locally on your linux system.
* Most CI provide runner with docker and Makefile installed (e.g. Travis-CI [minimal images](https://docs.travis-ci.com/user/languages/minimal-and-generic/).

cons:
* Only GNU/Linux distro supported.
* Could take few GiB (~30 GiB for all distro and all languages)
  * ~500MiB OS + C++/CMake tools,

# Usage
To get the help simply type:
```sh
make
```

note: you can also use from top directory
```sh
make --directory=ci
```

## Example
For example to test inside an `Alpine` container:
```sh
make alpine_test
```

# Docker layers
Dockerfile is splitted in several stages.

![docker](doc/docker.svg)

# Custom CMake install
To control the version of CMake, instead of using the version provided by the
distro package manager, you can rebuild it (slower) using the following snippet:
```Dockerfile
# Install CMake 3.16.4
RUN wget "https://cmake.org/files/v3.16/cmake-3.16.4.tar.gz" \
&& tar xzf cmake-3.16.4.tar.gz \
&& rm cmake-3.16.4.tar.gz \
&& cd cmake-3.16.4 \
&& ./bootstrap --prefix=/usr/local/ \
&& make \
&& make install \
&& cd .. \
&& rm -rf cmake-3.16.4
```

Otherwise (recommended, faster) you can also use the prebuilt version:
```Dockerfile
# Install CMake 3.16.4
RUN wget "https://cmake.org/files/v3.16/cmake-3.16.4-Linux-x86_64.sh" \
&& chmod a+x cmake-3.16.4-Linux-x86_64.sh \
&& ./cmake-3.16.4-Linux-x86_64.sh --prefix=/usr/local/ --skip-license \
&& rm cmake-3.16.4-Linux-x86_64.sh
```
