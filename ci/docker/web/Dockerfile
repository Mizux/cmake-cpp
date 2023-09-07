# Create a virtual environment with all tools installed
# ref: https://hub.docker.com/_/archlinux/
FROM archlinux:latest AS env
# Install system build dependencies
ENV PATH=/usr/local/bin:$PATH
RUN pacman -Syu --noconfirm git base-devel cmake
RUN pacman -Syu --noconfirm nodejs emscripten
ENV PATH=/usr/lib/emscripten:$PATH

# Add the library src to our build env
FROM env AS devel
WORKDIR /home/project
COPY . .

FROM devel AS build
RUN cmake -version
RUN emcc -v
RUN emcmake cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release
RUN cmake --build build --target all -v
#RUN cmake --build build --target install -v

FROM build AS test
#RUN cmake --build build --target test -v
RUN cd build && ctest -V
RUN node build/bin/example.js

