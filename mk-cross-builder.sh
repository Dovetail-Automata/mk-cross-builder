#!/bin/bash -e

IMAGE=zultron/mk-cross-builder
BASE_NAME=mk-cross-builder

# Build: If called with args `mk-cross-builder build [...]`, then
# build the image instead of running it, and add arguments to the
# `docker build` command
if test "$1" = "build"; then
    shift
    TAG="$1"
    if test -z "$TAG"; then
	echo "Please specify tag to build" >&/dev/null
	exit 1
    fi
    shift
    cd $(dirname $0)
    OLD_TAG="$(git branch | awk '/\*/ { print $2 }')"
    git checkout $TAG
    docker build -t ${IMAGE}:${TAG} "$@" .
    git checkout "${OLD_TAG}"
    exit
fi

TAG="$1"
if test -z "$TAG"; then
    echo "Please specify tag to run:  amd64, i386, armhf, raspbian" >&/dev/null
    exit 1
fi
NAME=${BASE_NAME}-${TAG}

# Check for existing containers
EXISTING="$(docker ps -aq --filter=name=${NAME})"
if test -n "${EXISTING}"; then
    # Container exists; is it running?
    RUNNING=$(docker inspect ${EXISTING} | awk '/"Running":/ { print $2 }')
    if test "${RUNNING}" = "false,"; then
	# Remove stopped container
	echo docker rm ${EXISTING}
    elif test "${RUNNING}" = "true,"; then
	# Container already running; error
	echo "Error:  container '${NAME}' already running" >&2
	exit 1
    else
	# Something went wrong
	echo "Error:  unable to determine status of " \
	    "existing container '${EXISTING}'" >&2
	exit 1
    fi
fi

docker run --rm \
    -it --privileged \
    -u `id -u`:`id -g` \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /dev/dri:/dev/dri \
    -v $HOME:$HOME -e HOME \
    -v $PWD:$PWD \
    -w $PWD \
    -e DISPLAY \
    -h ${NAME} --name ${NAME} \
    ${IMAGE}:${TAG} "$@"
