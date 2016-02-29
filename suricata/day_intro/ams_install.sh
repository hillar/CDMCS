#!/bin/bash

apt-get install docker.io
pip install docker-compose amsterdam
export COMPOSE_API_VERSION=1.18
amsterdam -d ee -i eth0 setup
amsterdam -d ee start
