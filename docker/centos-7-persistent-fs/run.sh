#!/usr/bin/env bash

####################################################################################
# Script Name: Interactive Shell within 'Persistent' CentOS 7 Docker Container
# Description: This script drops you into an interactive shell (bash) 
#              within a file-persistent CentOS 7 Docker container. 
#              The persistent data is stored in a local 'fs' directory, which is
#              populated with the necessary file system structure using a Docker 
#              image for CentOS 7. If the 'fs' directory already exists, the script
#              just uses it. Various directories from 'fs' are then mounted to 
#              the corresponding paths within the container. This allows the 
#              container to retain its state across multiple runs, hence making it 
#              "persistent".
#
#              Note to future self, this only works if the docker image has one 'layer.tar'
#              when creating the 'fs' directory... CentOS 7 currently does, so this works!

# Usage:       Execute this script from its parent directory. It will create a 'fs/'
#              folder within the parent directory.
#              ./run.sh
####################################################################################

DOCKER_IMAGE="centos"
DOCKER_TAG="7"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR

# Check if the fs directory already exists
if [ -d "./fs" ]; then
    echo -e "\nThe persistent 'fs' directory already exists."
else
    # Pull the Docker image
    docker pull $DOCKER_IMAGE:$DOCKER_TAG

    # Save the Docker image to a tar file
    mkdir -pv ./temp/
    cd temp
    docker save $DOCKER_IMAGE:$DOCKER_TAG > $DOCKER_IMAGE.$DOCKER_TAG.tar

    # Extract the tar file to a temporary directory
    tar -xf $DOCKER_IMAGE.$DOCKER_TAG.tar -C .

    # Create 'fs' directory
    mkdir -pv ../fs

    # Find the layer.tar file and extract it to the desired location
    find . -name 'layer.tar' -exec tar -xf {} -C ../fs \;

    cd ..

    # Clean up temporary files
    rm -rfv ./temp

    echo -e "\nCreated persistent 'fs' directory"
fi

echo "Launching interactive bash shell within $DOCKER_IMAGE:$DOCKER_TAG ... " 
echo "Data (should) be persistent across runs of this script ..."
echo -e "\nNOTE: Type 'exit' to drop back to your main shell at any time.\n"

docker run -it --rm \
        -v "$SCRIPT_DIR/fs/home:/home" \
        -v "$SCRIPT_DIR/fs/etc:/etc" \
        -v "$SCRIPT_DIR/fs/root:/root" \
        -v "$SCRIPT_DIR/fs/opt:/opt" \
        -v "$SCRIPT_DIR/fs/tmp:/tmp" \
        -v "$SCRIPT_DIR/fs/var:/var" \
        -v "$SCRIPT_DIR/fs/usr:/usr" \
        -v "$SCRIPT_DIR/fs/mnt:/mnt" \
        -v "$SCRIPT_DIR/fs/run:/run" \
        -v "$SCRIPT_DIR/fs/media:/media" \
        -v "$SCRIPT_DIR/fs/srv:/srv" \
        $DOCKER_IMAGE:$DOCKER_TAG \
        /bin/bash
