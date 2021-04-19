#!/bin/bash
# http://www.mikitechnica.com/19-notify-login-pam-exec.html

export PATH=/usr/bin:$PATH

[ "$PAM_TYPE" = "open_session" ] || exit 0
[ "$PAM_USER" != 'root' ] || exit 0

SUBJECT="sshd login alert"
BODY="'$PAM_USER' has logged in from [$PAM_RHOST on $PAM_SERVICE] at `date +'%Y/%m/%d %H:%M:%S %Z'`"
chronic /usr/local/bin/send_notify "$SUBJECT" "$BODY"
if [ "$?" != "0" ]; then
  echo "ERROR: can't send a login alert notification."
  exit 1
fi
