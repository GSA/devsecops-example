#!/bin/bash

set -e
set -x

sudo apt-get update -y
sudo apt-get install -y python

python --version
