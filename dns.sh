#!/bin/bash

# www.porkbun.com/account
source keys.sh

# === Configuration ===
SUBDOMAIN=$1                         # Subdomain to update
TTL=60                               # TTL in seconds

# === Get current public IPs ===
IPV4=$(curl -s https://api.ipify.org)

# === Function to update a record ===
TYPE="A"
IP=$IPV4

# Skip if no IP
[ -z "$IP" ] && return

# Retrieve DNS records to find record ID
RECORDS_JSON=$(curl -s -X POST "$API/json/v3/dns/retrieve/$DOMAIN" \
	-H "Content-Type: application/json" \
	-d "{\"apikey\": \"$API_KEY\", \"secretapikey\": \"$API_SECRET\"}")

echo "$RECORDS_JSON" | jq
FULLNAME="$SUBDOMAIN.$DOMAIN"

# Extract record ID matching the full name
RECORD_ID=$(echo "$RECORDS_JSON" | jq -r ".records[] | select(.type==\"$TYPE\" and .name==\"$FULLNAME\") | .id")

if [ -z "$RECORD_ID" ]; then
	echo "Error: Could not find $TYPE record for $SUBDOMAIN.$DOMAIN"
	return
fi

# Update the record
UPDATE_JSON=$(curl -s -X POST "$API/json/v3/dns/edit/$DOMAIN/$RECORD_ID" \
-H "Content-Type: application/json" \
-d "{
  \"apikey\": \"$API_KEY\",
  \"secretapikey\": \"$API_SECRET\",
  \"type\": \"$TYPE\",
  \"name\": \"$SUBDOMAIN\",
  \"content\": \"$IP\",
  \"ttl\": $TTL
}")

echo "$TYPE record updated for $FULLNAME -> $UPDATE_JSON" > report_${SUBDOMAIN}.log


