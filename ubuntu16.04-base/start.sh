#!/bin/bash
set -e

if [ -z "$AZP_URL" ]; then
  echo 1>&2 "error: missing AZP_URL environment variable"
  exit 1
fi

if [ -z "$AZP_TOKEN_FILE" ]; then
  if [ -z "$AZP_TOKEN" ]; then
    echo 1>&2 "error: missing AZP_TOKEN environment variable"
    exit 1
  fi

  AZP_TOKEN_FILE=/azp/.token
  echo -n $AZP_TOKEN > "$AZP_TOKEN_FILE"
fi

unset AZP_TOKEN

print_info() {
  lightcyan='\033[1;36m'
  nocolor='\033[0m'
  echo -e "${lightcyan}[*] $1${nocolor}"
}

# Let the user decide whether to update the agent or not
FORCEUPDATE=0
if [ -z "$AZP_UPDATE" ]; then
    print_info "Reusing agent files, if present"
else
    FORCEUPDATE=$AZP_UPDATE
fi

if [ -n "$AZP_WORK" ]; then
  mkdir -p "$AZP_WORK"
fi

if [ $FORCEUPDATE == "1" ]; then
  print_info 'Forcing agent update: deleting /azp/agent folder'
  print_info 'Note: if your AZP_WORK variable is inside /azp/agent; installed tools will be deleted, too'

  rm -rf /azp/agent
  mkdir /azp/agent
fi

if [ ! -e /azp/agent ]; then
  mkdir /azp/agent
fi
cd /azp/agent

export AGENT_ALLOW_RUNASROOT="1"

cleanup() {
  if [ -e config.sh ]; then
    print_info "Cleanup. Removing Azure Pipelines agent..."

    ./config.sh remove --unattended \
      --auth PAT \
      --token $(cat "$AZP_TOKEN_FILE")
  fi
}

# Let the agent ignore the token env variables
export VSO_AGENT_IGNORE=AZP_TOKEN,AZP_TOKEN_FILE

# Is there already a client here? Maybe we don't need to download 88MB...
if [ -e config.sh ]; then
    print_info "Azure Pipelines files are already installed"
else
    print_info "Need to download an Azure Pipelines package: obtaining Azure Pipelines agent version..."

    AZP_AGENT_RESPONSE=$(curl -LsS \
      -u user:$(cat "$AZP_TOKEN_FILE") \
      -H 'Accept:application/json;api-version=3.0-preview' \
      "$AZP_URL/_apis/distributedtask/packages/agent?platform=linux-x64")

    if echo "$AZP_AGENT_RESPONSE" | jq . >/dev/null 2>&1; then
      AZP_AGENTPACKAGE_URL=$(echo "$AZP_AGENT_RESPONSE" \
        | jq -r '.value | map([.version.major,.version.minor,.version.patch,.downloadUrl]) | sort | .[length-1] | .[3]')
    fi

    if [ -z "$AZP_AGENTPACKAGE_URL" -o "$AZP_AGENTPACKAGE_URL" == "null" ]; then
      echo 1>&2 "error: could not determine a matching Azure Pipelines agent - check that account '$AZP_URL' is correct and the token is valid for that account"
      exit 1
    fi

    print_info "Downloading and installing Azure Pipelines agent..."

    curl -LsS $AZP_AGENTPACKAGE_URL | tar -xz & wait $!
fi

source ./env.sh

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

print_info "Configuring Azure Pipelines agent..."

STARTED_FILE=/azp/.started

# NB: a trick to avoid confusing messages: the remove command would 
# not block code execution, even if there is no agent to be removed.
# This way we support restarting the same Docker container; without downloading a package every time.
if [ -e $STARTED_FILE ]; then
  print_info "Removing the previous agent..."
  cleanup
fi

touch $STARTED_FILE

./config.sh --unattended \
  --agent "${AZP_AGENT_NAME:-$(hostname)}" \
  --url "$AZP_URL" \
  --auth PAT \
  --token $(cat "$AZP_TOKEN_FILE") \
  --pool "${AZP_POOL:-Default}" \
  --work "${AZP_WORK:-/_work}" \
  --replace \
  --acceptTeeEula & wait $!

print_info "Running Azure Pipelines agent..."

# `exec` the node runtime so it's aware of TERM and INT signals
# AgentService.js understands how to handle agent self-update and restart
exec ./externals/node/bin/node ./bin/AgentService.js interactive
