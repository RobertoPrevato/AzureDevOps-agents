FROM devopsubuntu16.04:latest

COPY scripts /scripts

ENV AGENT_TOOLSDIRECTORY=/_work/_tool

RUN /scripts/installers/dotnetcore-sdk.sh

RUN /scripts/installers/powershellcore.sh && \
    /scripts/installers/azpowershell.sh
