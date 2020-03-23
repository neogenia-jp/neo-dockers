#!/bin/bash

LISTEN_PORT=${LISTEN_PORT:-2222}

echo "Usage:"
echo "nc 127.0.0.1 $LISTEN_PORT < /path/to/input.xls > /path/to/output.pdf"
echo ""
echo "Listening port $LISTEN_PORT ..."

FIFO=/tmp/convert.io
mkfifo $FIFO
tail -f $FIFO &

while :; do
  nc -klp $LISTEN_PORT -e bash -c "cat > /tmp/aa && ./convert.rb /tmp/aa /tmp/ > $FIFO 2>&1 && cat /tmp/aa.pdf";
done
