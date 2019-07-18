FROM devopsagentubuntu:16.04

COPY packages /packages

ENV TOOLSFOLDER=/azp/_work/_tool

RUN mkdir -p $TOOLSFOLDER

RUN apt-get update && apt-get install rsync unzip # required by azcopy install.sh

COPY scripts /scripts

RUN /scripts/installers/azcopy.sh
# RUN /scripts/installers/hosted-tools-cache.sh
RUN /scripts/installers/python.sh

RUN rm -rf /packages
