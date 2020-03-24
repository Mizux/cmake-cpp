# Create a virtual environment with all tools installed
# ref: https://hub.docker.com/_/centos
FROM centos:latest AS env
LABEL maintainer="mizux.dev@gmail.com"
# Install system build dependencies
ENV PATH=/usr/local/bin:$PATH
RUN yum -y update \
&& yum -y install git wget openssl-devel \
&& yum -y groupinstall "Development Tools" \
&& yum clean all \
&& rm -rf /var/cache/yum
# Install CMake 3.16.4
RUN wget "https://cmake.org/files/v3.16/cmake-3.16.4-Linux-x86_64.sh" \
&& chmod a+x cmake-3.16.4-Linux-x86_64.sh \
&& ./cmake-3.16.4-Linux-x86_64.sh --prefix=/usr/local/ --skip-license \
&& rm cmake-3.16.4-Linux-x86_64.sh
CMD [ "/bin/sh" ]

# Add the library src to our build env
FROM env AS devel
# Create lib directory
WORKDIR /home/lib
# Bundle lib source
COPY . .

# Effectively build the project
FROM devel AS build
# CMake version
RUN cmake -version
# CMake configure
RUN cmake -H. -Bbuild
# CMake build
RUN cmake --build build --target all
# CMake build
RUN cmake --build build --target install

# Run tests
FROM build AS test
RUN cmake --build build --target test

# Create an install image
FROM env AS install_devel
# Copy lib from build to prod
COPY --from=build /usr/local /usr/local/
# Copy  sample
WORKDIR /home/sample
COPY ci/sample .

# Build sample
FROM install_devel AS install_build
# CMake configure
RUN cmake -S. -Bbuild
# CMake build
RUN cmake --build build --target all -v

# Test sample
FROM install_build AS install_test
RUN cmake --build build --target test
