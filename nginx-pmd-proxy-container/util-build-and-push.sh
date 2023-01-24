#!/bin/bash

set -e

docker build -t olegon/nginx-pmd-proxy:latest .

docker push olegon/nginx-pmd-proxy:latest