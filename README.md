# Docker image for IntelliJ IDEA Community and Markdown plugin

[![Circle CI](https://circleci.com/gh/zanyxdev/dev-idea-docker.svg?style=svg)](https://circleci.com/gh/zanyxdev/dev-idea-docker)

The image contains the following software:

- [IntelliJ IDEA Community 2016.2](https://www.jetbrains.com/idea/)
- [Markdown plugin (release, 2016.1.20160405)](https://plugins.jetbrains.com/plugin/7793)

## Running

**NOTE**
As of Docker 1.10(?) you need to specify full paths for mounts.

By running the following command you'll be able to start the container

```bash
docker run -tdi \
           --net="host" \
           --privileged=true \
           -e DISPLAY=${DISPLAY} \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v ${HOME}/.IdeaIC2016.1_docker:/home/developer/.IdeaIC2016.1 \
           zanyxdev/dev-idea-docker
```

The command will do the following:

- save the IDE preferences into `<your-HOME-dir>/.IdeaIC2016.1_docker`

## Customizing the container

You can also choose to save the preferences in another directory.

For an example script to launch this, see below:

```bash
#!/usr/bin/env bash
PREF_DIR=${HOME}/.IdeaIC2016.1_docker

docker run -tdi \
           --net="host" \
           --privileged=true \
           -e DISPLAY=${DISPLAY} \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v ${PREF_DIR}:/home/developer/.IdeaIC2016.1 \
           zanyxdev/dev-idea-docker
```

## Updating the container

To update the container, simply run:

```shell
docker pull zanyxdev/dev-idea-docker
```

Each of the plugins can be updated individually at any time, and other plugins
can be installed as well.

However, to update IntelliJ IDEA itself, the docker image will need to be
updated.

## License

GNU General Public License

If you want to read the full license text, please see the [LICENSE](https://www.gnu.org/licenses/gpl-3.0.en.html) file
in this directory.

IntelliJ IDEA and all the other plugins are or may be trademarks of their
respective owners / creators. Please read the individual licenses for them.
