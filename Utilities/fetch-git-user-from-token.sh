#!/bin/bash

get_user() {
    TOKENS="$1"
    HOST="$2"

    # setting up hosts
    if [ -z "$HOST" ]; then
        API_ENDPOINT="api.github.com"
        echo "Hostname defaulted to github"
    else
        API_ENDPOINT="$HOST/api/v3"
    fi

    # calling Github API in loop
    echo ""
    echo "------------------------------------------------------------------------------"
    echo "$TOKENS" | tr "," "\n" | while IFS=',' read -r TOKEN; do
        USER=$(curl -sL \
            -H "Accept: application/vnd.github+json" \
            -H "Authorization: Bearer $TOKEN" \
            -H "X-GitHub-Api-Version: 2022-11-28" \
            https://"$API_ENDPOINT"/user | awk -F: '/login/ {print $2}' | tr -d "," | tr -d '"')
        echo "$TOKEN\t|\t$USER"
    done
}

usage() {
    echo "Usage: $0 <comma-seperated-tokens> [git-host-name]"
}

# -------- main ------------

if [ "$#" -lt 1 ]; then
    usage
else
    get_user "$1" "$2"
fi
