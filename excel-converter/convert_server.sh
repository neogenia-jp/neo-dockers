#!/bin/bash

LISTEN_PORT=${LISTEN_PORT:-2222}
TYPE=${TYPE:-pdf}

echo "Usage:"
echo "  nc 127.0.0.1 $LISTEN_PORT < /path/to/input.xls > /path/to/output.$TYPE"
echo ""

FIFO=/tmp/convert.$LISTEN_PORT.io
mkfifo $FIFO
tail -f $FIFO &

TF=/tmp/$LISTEN_PORT-$TYPE
while :; do
  echo "Listening port $LISTEN_PORT (convert type: $TYPE) ..."
  nc -klp $LISTEN_PORT -e bash -c "cat > $TF && ./convert.rb $TF /tmp/ $TYPE > $FIFO 2>&1 && cat $TF.$TYPE";
done
