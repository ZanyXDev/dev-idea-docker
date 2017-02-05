#!/bin/bash

for dir in .idea-home .gradle .idea .android/avd IdeaProjects; do
  mkdir -p ~/.docker-dev/$dir
done

CURRENT_DIR=`pwd`

#xhost +
#set -x

docker run -tdi \
    --rm \
    --privileged=true \
    -e DISPLAY=${DISPLAY} \
    --net=host \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /dev/bus/usb:/dev/bus/usb \
    -v /dev/kvm:/dev/kvm \
    -v $HOME/.Xauthority:/home/developer/.Xauthority \
    -v $CURRENT_DIR:/workspace \
    -v $CURRENT_DIR/.docker-dev/.idea-home:/home/developer/.IdeaIC2016.3 \
    -v $CURRENT_DIR//.android/avd:/home/developer/.android/avd \
    -v $CURRENT_DIR/.docker-dev/IdeaProjects:/home/developer/IdeaProjects \
    zanyxdev/dev-idea-docker:latest

#set +x
#xhost -