# Create a virtual environment with all tools installed
# ref: https://hub.docker.com/r/opensuse/tumbleweed
FROM opensuse/tumbleweed AS env
LABEL maintainer="mizux.dev@gmail.com"
# Install system build dependencies
ENV PATH=/usr/local/bin:$PATH
RUN zypper update -y \
&& zypper install -y git gcc gcc-c++ cmake \
&& zypper clean -a
ENV CC=gcc CXX=g++
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
RUN cmake -S. -Bbuild
# CMake build
RUN cmake --build build --target all -v
# CMake build
RUN cmake --build build --target install

# Create an install image
FROM env AS install
# Copy lib from build to prod
COPY --from=build /usr/local /usr/local/
# Copy  sample
WORKDIR /home/sample
COPY ci/sample .
