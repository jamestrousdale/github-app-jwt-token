#!/bin/bash
set -euxo pipefail

githubApiUrl="${GITHUB_API_URL:-https://api.github.com}"
githubAppId="${GITHUB_APP_ID}"
githubAppAccessToken="${GITHUB_APP_ACCESS_TOKEN}"

getAppId=$(curl --silent --fail -H "Authorization: token ${githubAppAccessToken}" "${githubApiUrl}/apps/token-action-test-app" | jq -r .id)
[[ "${getAppId}" == "${githubAppId}" ]] || exit 1
