#!/bin/bash
if [ ! -d "/root/.config/supertuxkart/config-0.10" ]; then
    echo "First run. Initializing"
    supertuxkart --init-user
    cd /root/.config/supertuxkart/config-0.10 && \
    touch stkservers.db
fi
/usr/local/bin/supertuxkart $@
