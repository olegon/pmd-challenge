#!/bin/env bash

set -ev

docker_hub_image="$1"
docker_hub_image_version="$2"
docker_ecr_url="$3"
aws_region="$4"

echo "[DEBUG] docker_hub_image = $docker_hub_image"
echo "[DEBUG] docker_hub_image_version = $docker_hub_image_version"
echo "[DEBUG] docker_ecr_url = $docker_ecr_url"
echo "[DEBUG] aws_region = $aws_region"

# Downloading image from Docker Hub
docker pull "$docker_hub_image:$docker_hub_image_version"

# Authencating on ECR
aws ecr get-login-password --region "$aws_region" | docker login --username AWS --password-stdin "$docker_ecr_url"

# Rettaging docker image
docker tag "$docker_hub_image:$docker_hub_image_version" "$docker_ecr_url:$docker_hub_image_version"

# Pushing to ECR
docker push "$docker_ecr_url:$docker_hub_image_version"
