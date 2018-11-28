#!/bin/bash

HELP='# Dockerized Standard Actions
* `./chef-workstaiton/docker.sh --create` -- create docker containers for chef-workstation
* `./chef-workstation/docker.sh --shell` -- drop to an interactive shell in the default container
* `./chef-workstation/docker.sh --check workstation_name` -- check the docker contianer and chef config '

repo="chef-workstation"

set -e

while [[ "$#" > 0 ]]
do
    cmd="$1"
    shift
    if [[ $cmd != --* ]]; then 
        continue
    fi
    case $cmd in
        --help)
            printf '%s' "$HELP";
            exit 0
            ;;
        #
        # Create Docker Images
        #
        --create)
            echo "Rebuilding $repo image"
            docker build -t $repo -f $repo/ChefWorkstationDockerfile .
            ;;
        #
        # Running container with mounted working directory.
        #
        #
        --shell)
            echo "Running $repo container image"
            docker run -it -v "`pwd`/.chef:/root/.chef" $repo /bin/bash
            exit 0
            ;;
        #
        # Running container and check setup
        #
        --check)
            echo "Running $repo container checking"
            wokestation_name=$2
            docker run -v "`pwd`/.chef:/root/.chef" $repo sh -c "/root/$repo/test_chef_workstation.sh $workstation_name"
            ;;
        *)
            echo "Unknown command $1"
            exit 1
            ;;
    esac;
done

exit 0
