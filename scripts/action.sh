#!/bin/bash
set -euxo pipefail

githubApiUrl="${GITHUB_API_URL:-https://api.github.com}"

# Generate and export the JWT to be used by the access token script
GITHUB_JWT=$("$(dirname "$0")/generate-jwt.sh")
export GITHUB_JWT

# In a GitHub action context, if an installation ID is not explicitly provided,
# we will get one based on the contextual repo
if [[ -z "${GITHUB_APP_INSTALLATION_ID:-}" ]]; then
    # Use APP_INSTALLATION_REPO env var if provided; if not, use 
    # GITHUB_REPOSITORY
    githubAppInstallationRepo="${GITHUB_APP_INSTALLATION_REPO:-}"
    [[ -z "${githubAppInstallationRepo}" ]] \
        && githubAppInstallationRepo="${GITHUB_REPOSITORY}"

    GITHUB_APP_INSTALLATION_ID=$(curl --fail --silent -H "Authorization: Bearer ${GITHUB_JWT}" -H "Accept: application/vnd.github.v3+json" "${githubApiUrl}/repos/${githubAppInstallationRepo}/installation" | jq -r .id)
fi

export GITHUB_APP_INSTALLATION_ID

githubAccessToken=$("$(dirname "$0")/generate-access-token.sh")

echo "jwt=${GITHUB_JWT}" >> "${GITHUB_OUTPUT}"
echo "access_token=${githubAccessToken}" >> "${GITHUB_OUTPUT}"
