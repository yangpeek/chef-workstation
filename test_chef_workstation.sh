#!/bin/bash

usage='Check the chef-worksation docker container and .chef setup inside the docker contianer'

chef_server_config=$1

function BasicSetupCheck() 
{
  knife block list | grep "$chef_server_config \[ Currently Selected \]"
}

BasicSetupCheck
