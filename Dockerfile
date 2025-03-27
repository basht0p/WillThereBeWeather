FROM nginx:alpine

RUN apk add --no-cache certbot certbot-nginx bash curl openssl gettext

COPY index.html /var/www/html/index.html
COPY nginx.template.conf /nginx.template.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
