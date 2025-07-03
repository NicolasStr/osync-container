FROM alpine:3.18

# Install curl and bash (for osync)
RUN apk add --no-cache curl bash

# Download osync using the version from osync.version
COPY osync.version /osync.version
RUN set -e; \
    version=$(cat /osync.version | tr -d '\n'); \
    if [ -z "$version" ]; then echo "osync.version is empty"; exit 1; fi; \
    curl -fsSL -o /usr/local/bin/osync "https://raw.githubusercontent.com/deajan/osync/refs/tags/$version/osync.sh" && \
    chmod +x /usr/local/bin/osync

COPY config.tpl config.tpl
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["osync"]