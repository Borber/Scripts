#!/bin/bash

set -e

# You need to set the following variables in advance:
# ONE_REFRESH_TOKEN
# CLIENT_ID
# CLIENT_SECRET

AUTH_URL="https://login.microsoftonline.com/common/oauth2/v2.0/token"

# Build the request body
data="client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&refresh_token=$ONE_REFRESH_TOKEN&grant_type=refresh_token"

# Send the POST request and save the response
response=$(curl -s -X POST -d "$data" "$AUTH_URL")

# Extract the access token from the response
NEW_ACCESS_TOKEN=$(echo "$response" | jq -r '.access_token')
if [[ $NEW_ACCESS_TOKEN == "null" ]]; then
    echo "Access token not found"
    exit 1
fi

# Extract the new refresh token from the response
NEW_REFRESH_TOKEN=$(echo "$response" | jq -r '.refresh_token')
if [[ $NEW_REFRESH_TOKEN == "null" ]]; then
    echo "Refresh token not found"
    exit 1
fi

# Write the access token and refresh token to files
export NEW_ACCESS_TOKEN
export NEW_REFRESH_TOKEN

echo "Token refresh successful"