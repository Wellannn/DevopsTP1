#!/bin/bash

set -e

IMAGE_NAME="dev-broken-app-fixed"

docker build -t $IMAGE_NAME -f 4-dev-app.dockerfile .

CONTAINER_ID=$(docker run -d --rm -p 3000:3000 $IMAGE_NAME)

trap "docker stop $CONTAINER_ID > /dev/null" EXIT

sleep 5

RESPONSE=$(curl -s http://localhost:3000/health)

if [[ "$RESPONSE" == *'"status":"healthy"'* ]]; then
    echo "Le test est réussi."
else
    echo "La réponse n'est pas celle attendue."
    exit 1
fi