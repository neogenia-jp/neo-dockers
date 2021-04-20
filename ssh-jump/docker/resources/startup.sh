#!/bin/bash

echo "--- parameters dump ---"
echo NOTIFY_MAIL_TO=$NOTIFY_MAIL_TO
echo NOTIFY_WEBHOOK_URL=$NOTIFY_WEBHOOK_URL
echo CONTAINER_NAME=$CONTAINER_NAME

echo "--- replace env_vars in send_notify script ---"
sed -e "s|^NOTIFY_MAIL_TO=\$|NOTIFY_MAIL_TO=$NOTIFY_MAIL_TO|" \
    -e "s|^NOTIFY_WEBHOOK_URL=\$|NOTIFY_WEBHOOK_URL=$NOTIFY_WEBHOOK_URL|" \
    -e "s|^CONTAINER_NAME=\$|CONTAINER_NAME=${CONTAINER_NAME:-$HOSTNAME}|" \
    -i /usr/local/bin/send_notify

echo "--- start sshd ---"
exec /usr/sbin/sshd -D
