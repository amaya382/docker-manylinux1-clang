FROM quay.io/pypa/manylinux1_x86_64

LABEL maintainer='amaya <mail@sapphire.in.net>'

RUN set -eux && \
    `# Install deps` \
    yum install -y zlib-devel gcc44 gcc44-c++ xz && \
    `# Install cmake 3.11.4` \
    wget --no-check-certificate https://cmake.org/files/v3.11/cmake-3.11.4.tar.gz -O - \
      | tar xz && \
    cd cmake-3.11.4 && \
    ./configure --system-curl && \
    make -j4 && \
    make install && \
    `# Install clang 5.0.2` \
    wget http://releases.llvm.org/5.0.2/llvm-5.0.2.src.tar.xz -O - \
      | xz -dc \
      | tar xp && \
    mv llvm-5.0.2.src llvm && \
    wget http://releases.llvm.org/5.0.2/cfe-5.0.2.src.tar.xz -O - \
      | xz -dc \
      | tar xp && \
    mv cfe-5.0.2.src llvm/tools/clang && \
    wget http://releases.llvm.org/5.0.2/clang-tools-extra-5.0.2.src.tar.xz -O - \
      | xz -dc \
      | tar xp && \
    mv clang-tools-extra-5.0.2.src llvm/tools/clang/tools/extra && \
    mkdir llvm.build && \
    cd llvm.build && \
    cmake -G "Unix Makefiles" \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DPYTHON_EXECUTABLE=/opt/python/cp27-cp27m/bin/python \
      -DPYTHON_INCLUDE_DIR=/opt/python/cp27-cp27m/include/python2.7 \
      ../llvm && \
    make -j4 && \
    make install && \
    `# Remove garbages` \
    cd && \
    rm -rf * && \
    yum erase -y zlib-devel gcc44 gcc44-c++ xz && \
    rm -rf /var/cache/yum/* && \
    yum clean all

