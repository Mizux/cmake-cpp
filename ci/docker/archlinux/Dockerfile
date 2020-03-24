# Create a virtual environment with all tools installed
# ref: https://hub.docker.com/_/archlinux/
FROM archlinux/base AS env
LABEL maintainer="mizux.dev@gmail.com"
# Install system build dependencies
ENV PATH=/usr/local/bin:$PATH
RUN pacman -Syu --noconfirm git base-devel cmake
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
