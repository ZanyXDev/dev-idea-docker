# dev-idea-docker
Docker image for IntelliJ IDEA Community, Markdown  plugin
NOTE As of Docker 1.10(?) you need to specify full paths for mounts.

By running the following command you'll be able to start the container

docker run -tdi \
           --net="host" \
           --privileged=true \
           -e DISPLAY=${DISPLAY} \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v ${HOME}/.IdeaIC2016.1_docker:/home/developer/.IdeaIC2016.1 \
           zanyxdev/dev-idea-docker

The command will do the following:

    save the IDE preferences into <your-HOME-dir>/.IdeaIC2016.1_docker
    mounts the GOPATH from your computer to the one in the container. This assumes you have a single directory. If you have multiple directories in your GOPATH, then see below how you can customize this to run correctly.

Customizing the container
