#!/bin/bash

IMAGE_NAME=olegon/nginx-pmd-proxy:0.0.1

set -e

docker build -t "$IMAGE_NAME" .

docker push "$IMAGE_NAME"