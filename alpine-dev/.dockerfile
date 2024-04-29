# Alpine linux as base image
FROM alpine:3.19.1

# Install curl:8.5.0-r0
RUN apk update; \
    apk add curl=8.5.0-r0; \
    curl --version

CMD ["/bin/sh", "-c", "while true; do sleep 3600; done"]

LABEL owner=mikolajtelec