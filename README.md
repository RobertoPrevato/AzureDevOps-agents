![Validate Docker Files](https://github.com/RobertoPrevato/AzureDevOps-agents/workflows/Validate%20Docker%20Files/badge.svg)

# AzureDevOps-agents
Images for self-hosted DevOps agents running in Docker. The preparation of these images has been described in this post: [Self-hosted Azure DevOps agents running in Docker](https://robertoprevato.github.io).

## Credit
Most of the bash scripts in this repository are adopted from the official Hosted images prepared by Microsoft, with minor modifications, from this repository: [https://github.com/microsoft/azure-pipelines-image-generation/](https://github.com/microsoft/azure-pipelines-image-generation/); these images feature a modified `start.sh` script that supports caching of tools and agent files across restarts, as described in the post linked above.

## Building images
You can use the provided `build.sh` file to create images on your host.
Otherwise, first create the base image:

```
# from Ubuntu 18.04-base:
docker build -t devopsagentubuntu:18.04 .
```

Then create other images that depend on it.

## To run the images
Create an access token in Azure DevOps, then:

```bash

docker run -e AZP_URL=<YOUR-ORGANIZATION-URL> \
-e AZP_TOKEN=<YOUR-TOKEN> \
-e AZP_AGENT_NAME='Self-hosted Ubuntu 18.04' devopsubuntu18.04:latest

# or, from inside the container, in /azp:
AZP_URL=<YOUR-ORGANIZATION-URL> \
AZP_TOKEN=<YOUR-TOKEN> \
AZP_AGENT_NAME='Self-hosted Ubuntu 18.04' ./start.sh
```
