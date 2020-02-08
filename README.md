[![Validate Docker Files](https://github.com/RobertoPrevato/AzureDevOps-agents/workflows/Validate%20Docker%20Files/badge.svg)](https://github.com/RobertoPrevato/AzureDevOps-agents/actions?query=workflow%3A"Validate+Docker+Files")

# AzureDevOps-agents
Images for self-hosted DevOps agents running in Docker. The preparation of these images has been described in this post: [Self-hosted Azure DevOps agents running in Docker](https://robertoprevato.github.io/Self-hosted-Azure-DevOps-agents-running-in-Docker/).

## Credit
Most of the bash scripts in this repository are adopted from the official Hosted images prepared by Microsoft, with minor modifications, taken from this repository: [https://github.com/microsoft/azure-pipelines-image-generation/](https://github.com/microsoft/azure-pipelines-image-generation/).

The images in this repository feature a modified `start.sh` script that supports caching of tools and agent files across restarts, as described in the blog post linked above.

## Building images
You can use the provided `build.sh` file to create images on your host.
Otherwise, first create the base image:

```
# from Ubuntu 18.04-base:
docker build -t devopsagentubuntu:18.04 .
```

Then create other images that depend on it.

## Composing tools
It is possible to create an agent with several tools, by editing the `FROM` statement as desired, in the provided Dockerfiles. For example, it is possible to compose an agent with Python, .NET Core, and PowerShell Core by first building the `python` image on top of the `base` image; then building the `dotnet` image on top of the `python` image.

This technique can be used in build pipelines, to compose an agent with all desired tools.

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
