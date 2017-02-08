#!/bin/bash

#TODO check if exist volume 
# inside the volume in the  first run creates^
# /home/developer/.IdeaIC2016.3
# /home/developer/IdeaProjects

docker volume create dev_home
docker volume create dev_home_projects

docker run -tdi \
    --rm \
    --privileged=true \
    -e DISPLAY=${DISPLAY} \
    --net=host \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /dev/bus/usb:/dev/bus/usb \
    -v /dev/kvm:/dev/kvm \
    -v $HOME/.Xauthority:/home/developer/.Xauthority \
    -v dev_home:/home/developer/ \
    -v dev_home_projects:/home/developer/IdeaProjects \    
    zanyxdev/dev-idea-docker:latest
