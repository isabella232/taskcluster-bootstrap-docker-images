FROM ubuntu:trusty-20180807@sha256:cb96ec8eb632c873d5130053cf5e2548234e5275d8115a39394289d96c9963a6

RUN apt-get update -q && apt-get install -qy --no-install-recommends \
        docker.io \
        liblz4-tool \
    && \
    rm -rf /var/lib/apt/lists/*
