#!/bin/bash
if [ ! -f "/root/.config/supertuxkart/config-0.10/stkservers.db" ]; then
    touch /root/.config/supertuxkart/config-0.10/stkservers.db
fi
/usr/local/bin/supertuxkart $@
