#!/bin/bash
set -euo pipefail

githubApiUrl="${GITHUB_API_URL:-https://api.github.com}"
githubAppInstallationId="${GITHUB_APP_INSTALLATION_ID}"

# Allow a GitHub JWT to be input, and if not provided, generate one
githubJwt="${GITHUB_JWT:-}"
[[ -z "${githubJwt}" ]] && githubJwt=$("$(dirname "$0")/generate-jwt.sh")

token=$(curl --fail --silent -X POST -H "Authorization: Bearer ${githubJwt}" -H "Accept: application/vnd.github.v3+json" "${githubApiUrl}/app/installations/${githubAppInstallationId}/access_tokens" | jq -r .token)

echo "$token"
