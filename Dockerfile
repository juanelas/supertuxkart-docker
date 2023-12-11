FROM ubuntu:22.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends build-essential ca-certificates cmake git libcurl4-openssl-dev libenet-dev libsqlite3-dev libssl-dev subversion pkg-config zlib1g-dev \
    libcurl4 libsqlite3-0 && \
    mkdir /src && \
    cd /src && \
    git clone https://github.com/supertuxkart/stk-code stk-code && \
    for i in `/usr/bin/seq 1 100`; do \
        svn co https://svn.code.sf.net/p/supertuxkart/code/stk-assets stk-assets; \
        if [ $? -eq 0 ]; then \
            break; \
        else \
            echo "[$i] reconnecting to SVN"; \
            svn cleanup stk-assets; \
        fi; \
    done && \
    if [ "$i" -eq "100" ]; then \
        echo "too many retries for SVN checkout" 1>&2; \
        exit 1; \
    fi && \ 
    cd stk-code && \ 
    mkdir cmake_build && \
    cd cmake_build && \
    cmake .. -DSERVER_ONLY=ON -DBUILD_RECORDER=off -DCMAKE_INSTALL_PREFIX=/stk && \
    make && \
    make install

FROM ubuntu:22.04
COPY --from=0 /stk /stk
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
VOLUME /root/.config/supertuxkart/config-0.10
EXPOSE 2757/udp
EXPOSE 2759/udp
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
        libcurl4 \
        libsqlite3-0
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
