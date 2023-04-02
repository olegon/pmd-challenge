#!/bin/bash

IMAGE_NAME=olegon/custom-apex-pmd:0.0.1

set -e

docker build -t "$IMAGE_NAME" .

docker push "$IMAGE_NAME"
