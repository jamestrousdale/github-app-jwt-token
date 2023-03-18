#!/bin/bash
set -euxo pipefail

githubApiUrl="${GITHUB_API_URL:-https://api.github.com}"
githubAppId="${GITHUB_APP_ID}"
githubAppJwt="${GITHUB_APP_JWT}"

getAppId=$(curl --silent --fail -H "Authorization: Bearer ${githubAppJwt}" "${githubApiUrl}/app" | jq -r .id)
[[ "${getAppId}" == "${githubAppId}" ]] || exit 1
