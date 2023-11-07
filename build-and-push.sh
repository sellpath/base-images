#!/bin/bash -xe

# Define variables
TAG_NAME="2023110602"
DOCKER_USERNAME="$DOCKER_USER" # Read from environment variable
DOCKER_PASSWORD="$DOCKER_PASS" #
DOCKER_REPO="gosellpath"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

function build_and_push() {
    DOCKERFILE="$1"
    IMAGE_NAME="$2"

    # Build the Docker image
    docker build -t $DOCKER_USERNAME/${IMAGE_NAME}:$TAG_NAME -f $DOCKERFILE .
    # Push the Docker image to Docker Hub
    docker push $DOCKER_USERNAME/${IMAGE_NAME}:$TAG_NAME
}
# Login to Docker Hub
echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
build_and_push "run_stage.Dockerfile" "python_run_stage"
build_and_push "build_stage.Dockerfile" "python_build_stage"
build_and_push "prompteng_run_stage.Dockerfile" "prompteng_run_stage"

cd $SCRIPT_DIR/../../../
build_and_push "./compose/production/postgres/Dockerfile" "postgres15"
