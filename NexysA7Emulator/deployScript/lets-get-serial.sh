#!/bin/sh
LD_LIBRARY_PATH=/opt/lets-get-serial/lib:${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH
/opt/lets-get-serial/bin/lets-get-serial "$@"
