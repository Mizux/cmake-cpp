# Create a virtual environment with all tools installed
# ref: https://hub.docker.com/_/archlinux/
FROM archlinux:latest AS env
# Install system build dependencies
ENV PATH=/usr/local/bin:$PATH
RUN pacman -Syu --noconfirm git base-devel cmake
RUN pacman -Syu --noconfirm nodejs emscripten
ENV PATH=/usr/lib/emscripten:$PATH
RUN emcc -v

# Add the library src to our build env
FROM env AS devel
WORKDIR /home/project
COPY . .

FROM devel AS build
RUN cmake --version
RUN emcmake cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release
RUN cmake --build build --target all -v

FROM build AS test
#RUN CTEST_OUTPUT_ON_FAILURE=1 cmake --build build --target test
RUN cd build && ctest -V
