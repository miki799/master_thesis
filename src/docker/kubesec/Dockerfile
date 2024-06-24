ARG IMAGE_NAME_WITH_TAG=alpine:3.19.1

FROM ${IMAGE_NAME_WITH_TAG}

# Install curl:8.5.0-r0
RUN apk update; \
    apk add --no-cache curl=8.5.0-r0; \
    curl --version

# Install kubesec
RUN mkdir kubesec ; \
    curl -LO https://github.com/controlplaneio/kubesec/releases/download/v2.14.0/kubesec_linux_amd64.tar.gz ; \
    tar -zxvf kubesec_linux_amd64.tar.gz -C kubesec ; \
    mv /kubesec/kubesec /usr/local/bin ; \
    kubesec version ; \
    rm -rf kubesec_linux_amd64.tar.gz kubesec

CMD ["/bin/sh"]

LABEL owner=mikolajtelec