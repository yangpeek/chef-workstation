#!/bin/bash

help='Command: ./chef-workstation/prepare_chef_workstation chef_workstation_name
1. Will mv the knife.rb to the knife-$chef_workstation_name.rb 
   if knife.rb is not symlink
2. Prepare the symlink for knife.rb'


chef_workstation_name=$1
repo="chef-workstation"

function check_usage()
{
  if [ -z "$chef_workstation_name" ]; then
    echo "$help"
  exit
  fi
}

function prepare_chef_server()
{
  cd ./.chef/
  if [ ! -L 'knife.rb' ]; then
    mv knife.rb knife-"$chef_workstation_name".rb
  fi
  ln -sf knife-"$chef_workstation_name".rb knife.rb
  cd ../
}

function docker_chef_workstation()
{
  ./$repo/docker.sh --create
  ./$repo/docker.sh --check $chef_workstation_name
  if [[ $? == 0 ]]; then 
    ./$repo/docker.sh --shell
  else 
    echo "The Envronment is worng!!!"
  fi
}

function main() 
{
  check_usage
  prepare_chef_server
  docker_chef_workstation
}

main
