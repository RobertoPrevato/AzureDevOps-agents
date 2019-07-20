FROM devopsubuntu16.04:latest

COPY scripts /scripts

ENV AGENT_TOOLSDIRECTORY=/_work/_tool

RUN apt-get install make \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libsqlite3-dev \
    unixodbc-dev

RUN /scripts/installers/python.sh && \
    /scripts/installers/python373.sh
