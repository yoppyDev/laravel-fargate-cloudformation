#!/bin/sh

set -u
. "$(cd "$(dirname "$0")/../" && pwd)/.env"

aws ecr get-login-password --profile ${AWS_PROFILE} |
  docker login --username AWS --password-stdin "${REGISTRY_URL}"
