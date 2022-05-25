#!/bin/sh

KEYCLOAK_URL=http://lauwinds1.temenosgroup.com:8180
KEYCLOAK_REALM=master
KEYCLOAK_USER=admin
KEYCLOAK_SECRET=admin
REALM_FILE=realm.json

CURL_CMD="curl --silent --show-error"

TOKEN=$(${CURL_CMD} -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=${KEYCLOAK_USER}" \
  -d "password=${KEYCLOAK_SECRET}" \
  -d "grant_type=password" \
  -d 'client_id=admin-cli' \
   "${KEYCLOAK_URL}/auth/realms/${KEYCLOAK_REALM}/protocol/openid-connect/token"| grep -Eo '"access_token"[^,]*' | grep -Eo '[^:]*$')
   
temp="${TOKEN%\"}"
ACCESS_TOKEN="${temp#\"}" 
  
${CURL_CMD} \
  -X POST \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d @"${REALM_FILE}" \
  "${KEYCLOAK_URL}/auth/admin/realms";