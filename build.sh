#!/bin/sh

CONTAINER_IMAGE=${CONTAINER_IMAGE:-chiptainer_adafruit_gpio}

case "$1" in
    build)
        docker build --no-cache=true -t "${CONTAINER_IMAGE}" .
        ;;
    tag)
        docker tag chiptainer_adafruit_gpio xtacocorex/chiptainer_adafruit_gpio
        ;;
    push)
        docker push xtacocorex/chiptainer_adafruit_gpio
        ;;
    all)
        echo "BUILDING"
        docker build --no-cache=true -t "${CONTAINER_IMAGE}" .
        echo "TAGGING"
        docker tag chiptainer_adafruit_gpio xtacocorex/chiptainer_adafruit_gpio
        echo "PUSHING"
        docker push xtacocorex/chiptainer_adafruit_gpio
        ;;
    remove-tags)
        docker rmi `docker images | grep chiptainer_adafruit_gpio | grep "<none>" | tr -s " " | cut -d " " -f 3`
        ;;
esac
