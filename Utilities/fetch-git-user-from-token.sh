#!/bin/bash

TOKENS="$1"
HOST="$2"

# setting up hosts
if [ -z "$HOST" ]; then
    API_ENDPOINT="api.github.com"
else
    API_ENDPOINT="$HOST/api/v3"
fi

# calling Github API in loop
echo "$TOKENS" | tr "," "\n" | while IFS=',' read -r TOKEN; do
    USER=$(curl -sL \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $TOKEN" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        https://"$API_ENDPOINT"/user | awk -F: '/login/ {print $2}' | tr -d ",")
    echo "$TOKEN\t|\t$USER"
done
