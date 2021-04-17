#!/bin/bash
if [ -n ${USERNAME} -a -n ${PASSWORD} ]; then
    supertuxkart --init-user --login=${USERNAME} --password=${PASSWORD}
fi &&
/usr/local/bin/supertuxkart --server-config=server_config.xml $@
