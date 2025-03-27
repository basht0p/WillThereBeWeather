#!/bin/bash

envsubst '${DOMAIN}' < /nginx.template.conf > /etc/nginx/conf.d/default.conf

nginx

until curl -s --head "http://${DOMAIN}" | grep "200 OK" > /dev/null; do
  echo "Waiting for ${DOMAIN} to resolve..."
  sleep 3
done

if [ ! -d "/etc/letsencrypt/live/${DOMAIN}" ]; then
  echo "Requesting Let's Encrypt certs for ${DOMAIN} and www.${DOMAIN}..."
  certbot --nginx -d "${DOMAIN}" -d "www.${DOMAIN}" \
    --agree-tos --email "${EMAIL}" --non-interactive
fi

echo "0 3 * * * certbot renew --quiet --nginx && nginx -s reload" | crontab -
crond -f
