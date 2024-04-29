# Alpine linux as base image
FROM alpine:3.19.1

# Update repositories
RUN apk update;

# Install curl:8.5.0-r0
RUN apk add curl=8.5.0-r0; \
    curl --version;

# # Install kube-bench (not present in Alpine package repositories)
# RUN curl -LO https://github.com/aquasecurity/kube-bench/releases/download/v0.7.3/kube-bench_0.7.3_linux_amd64.tar.gz && \
#     tar xzf kube-bench_0.7.3_linux_amd64.tar.gz kube-bench && \
#     mv kube-bench /usr/local/bin/ && \
#     chmod +x /usr/local/bin/kube-bench

CMD ["/bin/sh", "-c", "while true; do sleep 3600; done"]

LABEL owner=mikolajtelec