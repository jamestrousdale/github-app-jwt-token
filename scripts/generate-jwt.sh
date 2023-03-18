#!/bin/bash
set -euo pipefail

# Original credit to this solution goes to https://stackoverflow.com/a/62646786

githubAppID="${GITHUB_APP_ID}"
githubAppPrivateKey="${GITHUB_APP_PRIVATE_KEY}"
iat=$(date +%s)
# Expire 9 minutes in the future. 10 minutes is the max for GitHub
exp=$((iat + 540))

# Generate encoded JWT header
jwtHeaderRaw='{"alg":"RS256"}'
jwtHeader=$( echo -n "${jwtHeaderRaw}" | openssl base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n' )

# Generate encoded JWT payload
jwtPayloadRaw='{"iat":'"${iat}"',"exp":'"${exp}"',"iss":'"${githubAppID}"'}'
jwtPayload=$( echo -n "${jwtPayloadRaw}" | openssl base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n' )

# Generate encoded JWT signature
jwtSignature=$( openssl dgst -sha256 -sign <(echo -n "${githubAppPrivateKey}") <(echo -n "${jwtHeader}.${jwtPayload}") | openssl base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n' )

echo "${jwtHeader}.${jwtPayload}.${jwtSignature}"
