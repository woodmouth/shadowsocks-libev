#!/bin/sh

if [[ -f "$PASSWORD_FILE" ]]; then
    PASSWORD=$(cat "$PASSWORD_FILE")
fi

if [[ -f "/var/run/secrets/$PASSWORD_SECRET" ]]; then
    PASSWORD=$(cat "/var/run/secrets/$PASSWORD_SECRET")
fi

exec ss-local \
      -s '139.180.137.185' \
      -p 18721 \
      -k '45Qrs176showYoDGSY7eWk0WPiDvMljd6r5r4n36QqlIkbb9pz623gxWgEbkFBpX' \
      -m 'aes-256-gcm' \
      -t 600 \
      -d $DNS_ADDRS \
      -u \
      $ARGS
