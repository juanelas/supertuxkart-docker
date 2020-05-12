#!/bin/bash
if [ ! -d "/root/.config/supertuxkart/config-0.10" ]; then
    supertuxkart --init-user
    cd /root/.config/supertuxkart/config-0.10 && \
    touch stkservers.db
fi
/usr/local/bin/supertuxkart $@
