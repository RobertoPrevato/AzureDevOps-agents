# AzureDevOps-agents
Images for self-hosted DevOps agents.

This is a work in progress, images are not completely working yet.

First create a base image (this works, it is as per Microsoft documentation).

```
# from Ubuntu 16.04-base:
docker built -t devopsagentubuntu:16.04 .
```

Then create the image with tools, that uses it.

## To run the images
Create an access token in Azure DevOps, then:

```bash

docker run -e AZP_URL=https://<YOUR_ORG>.visualstudio.com \
-e AZP_TOKEN=<YOUR-TOKEN> \
-e AZP_AGENT_NAME='Self-hosted Ubuntu 16.04' devopsagentubuntu18:latest

# or, from inside the container, in /azp:
AZP_URL=https://<YOUR_ORG>.visualstudio.com \
AZP_TOKEN=<YOUR-TOKEN> \
AZP_AGENT_NAME='Self-hosted Ubuntu 16.04' ./start.sh

```