# Inception: Docker inside Docker
This Docker image can be used for Azure DevOps pipelines that require Docker.

To use it from a Linux host having Docker installed, run it this way:

## Example 1; interactive run
```bash
# interactively:
docker run -it -v /var/run/docker.sock:/var/run/docker.sock devopsubuntu16.04-docker:latest /bin/bash

# run Azure DevOps agent:
AZP_URL=<YOUR-ORGANIZATION-URL> \
AZP_TOKEN=<YOUR-TOKEN> \
AZP_AGENT_NAME='Ubuntu 16.04 Docker' ./start.sh
```

## Example 2; straight to the point
```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock \
-e AZP_URL=<YOUR-ORGANIZATION-URL> \
-e AZP_TOKEN=<YOUR-TOKEN> \
-e AZP_AGENT_NAME='Ubuntu 16.04 Docker' devopsubuntu16.04-docker:latest
```

## Images in Docker Hub
These images have been published in [Docker Hub, at `robertoprevato` account](https://hub.docker.com/u/robertoprevato).