# Gearmand Dockerfile

This repository contains **Dockerfile** of [Gearman Job Server](http://gearman.org/manual/job_server/).

# Installation
* Install [Docker](https://www.docker.com/)
* Build `docker build -t=gearmand:latest github.com/pandeyanshuman/docker-gearmand`
 
# Usage
* Run the gearman job server in foreground (for testing)
 

``
docker run --rm -it gearmand gearmand --verbose=DEBUG
``
* Run the gearman job server
 

``
docker run --name=gearmand1 -P -d gearmand
``
* Run the gearman client (job server is linked and is available at hostname gearmand1)
 

``
docker run --rm -it --link=gearmand1:gearmand1 gearmand gearman
``
