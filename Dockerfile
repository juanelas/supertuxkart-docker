FROM ubuntu:20.04 AS build
LABEL maintainer=juanelas
WORKDIR /stk

ENV STK_VERSION=1.1

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install -y --no-install-recommends build-essential \
                       cmake \
                       git \
                       libcurl4-openssl-dev \
                       libenet-dev \
                       libssl-dev \
                       libsqlite3-dev \
                       pkg-config \
                       subversion \
                       zlib1g-dev \
                       ca-certificates

# Using releases to make builds reproducible
RUN git clone -b ${STK_VERSION} --depth=1 https://github.com/supertuxkart/stk-code.git
RUN svn checkout https://svn.code.sf.net/p/supertuxkart/code/stk-assets-release/${STK_VERSION}/ stk-assets

RUN mkdir stk-code/cmake_build && \ 
    cd stk-code/cmake_build && \
    cmake .. -DSERVER_ONLY=ON -DBUILD_RECORDER=off -USE_SYSTEM_ENET=ON && \
    make -j$(nproc) && \
    make install

FROM ubuntu:20.04
LABEL maintainer=juanelas
WORKDIR /stk

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install -y libcurl4-openssl-dev && \
    rm -rf /var/lib/apt/lists/*

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
