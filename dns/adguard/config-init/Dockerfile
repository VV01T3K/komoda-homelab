FROM alpine:latest

RUN apk add --no-cache apache2-utils

COPY generate-config.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/generate-config.sh

ENTRYPOINT ["/usr/local/bin/generate-config.sh"]
