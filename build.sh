#!/usr/bin/env bash
if [[ -f .env ]]; then
    source .env
else
    echo "Missing .env, copying example .env from template. Edit it before running build.sh again."
    cp .env-example .env
    exit
fi

echo "Building ruTorrent $RUTORRENT_VER"
sleep 2

DOCKER_BUILDKIT=1 docker build --no-cache \
    --build-arg BASEIMAGE_VERSION=$BASEIMAGE_VERSION \
    --build-arg RTORRENT_VER=$RTORRENT_VER \
    --build-arg LIBTORRENT_VER=$LIBTORRENT_VER \
    --build-arg MEDIAINF_VER=$MEDIAINF_VER \
    --build-arg CURL_VER=$CURL_VER \
    --build-arg MAXMIND_LICENSE_KEY=$MAXMIND_LICENSE_KEY \
    --build-arg TARGETARCH=amd64 \
    --build-arg RUTORRENT_VER=$RUTORRENT_VER \
    --network=host \
    --tag "rutorrent:latest" \
    --tag "rutorrent:$RUTORRENT_VER" \
    -f Dockerfile .
