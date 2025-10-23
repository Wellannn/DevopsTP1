FROM ubuntu

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

RUN useradd nonRootUser
USER nonRootUser

ENTRYPOINT ["curl"]

CMD ["--help"]