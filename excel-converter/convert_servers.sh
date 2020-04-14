#!/bin/bash
SCRIPT_DIR=${SCRIPT_DIR:-$(cd $(dirname $0) && pwd)}

LISTEN_PORT=2222 TYPE=pdf $SCRIPT_DIR/convert_server.sh &
LISTEN_PORT=2223 TYPE=jpg $SCRIPT_DIR/convert_server.sh &
LISTEN_PORT=2224 TYPE=png $SCRIPT_DIR/convert_server.sh

