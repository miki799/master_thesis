ARG IMAGE_NAME_WITH_TAG=alpine:3.19.1

FROM ${IMAGE_NAME_WITH_TAG}

# Install curl:8.5.0-r0
RUN apk update; \
    apk add --no-cache curl=8.5.0-r0; \
    curl --version

# Sets current workdir to /app dir
WORKDIR /app

# Copy files from local dir to the /app dir
COPY ./request.sh /app/

# Go back to root dir
WORKDIR /

CMD ["/bin/sh", "-c", "./app/request.sh"]

LABEL owner=mikolajtelec