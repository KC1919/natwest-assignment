#!/bin/bash

# Check if URLs file is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <URLs_file>"
    exit 1
fi

# URLs file
URLS_FILE="$1"

# Check if URLs file exists
if [ ! -f "$URLS_FILE" ]; then
    echo "Error: URLs file not found."
    exit 1
fi

# Function to check HTTP status code and log the result
check_http_status() {
    local url=$1
    local http_status=$(curl -s -o /dev/null -w "%{http_code}" "$url")

    echo "URL: $url | HTTP Status Code: $http_status"
}

# Loop through each URL in the file
while IFS= read -r url; do
    check_http_status "$url"
done < "$URLS_FILE"
