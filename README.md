![CI Checks](https://github.com/jamestrousdale/github-app-jwt-token/actions/workflows/checks.yaml/badge.svg)

# github-app-jwt-token

GitHub action to generate a JWT and an installation access token for a GitHub
app.

This project has influence from 
https://github.com/navikt/github-app-token-generator but solves some issues I
had with this and other existing solutions:

1. I wanted to be able to output both the JWT as well as the access token
2. Dependencies on using `docker` or `javascript` (this solution is entirely
   `bash`-based, and really only requires `curl` and `jq` to be installed)
3. Lack of CI (particularly testing)

## Usage

To use this action in a GitHub actions workflow, add a step like the following
to your job, where here we assume that the application private key has been
provided as a action secret in the calling repo:

```yaml
- name: Generate JWT and token
  id: generate-github-app-tokens
  uses: jamestrousdale/github-app-jwt-token@x.y.z # <- Put version in here
  with:
    app-id: '123456'
    private-key: ${{ secrets.MY_GH_APP_PRIVATE_KEY_SECRET }}
```

The output of the job can then be piped into the GitHub job environment for
subsequent steps:

```yaml
- name: Set environment from action output
  run: |
    {
      echo "GITHUB_APP_JWT=${{ steps.generate-github-app-tokens.outputs.jwt }}"
      echo "GITHUB_APP_ACCESS_TOKEN=${{ steps.generate-github-app-tokens.outputs.access-token }}"
    } >> ${GITHUB_ENV}
```

### Specifying the installation ID or repository

By default, if only the `app-id` and `private-key` inputs are provided, the
access token will be generated against the installation of the app for the
repository in which the action is executing. This requires that the app be
installed on the calling repository.

Alternatively, the `app-installation-id` input can be provided to generate a
token against a specific installation:

```yaml
- name: Generate JWT and token
  id: generate-github-app-tokens
  uses: jamestrousdale/github-app-jwt-token@x.y.z # <- Put version in here
  with:
    app-id: '123456'
    app-installation-id: '9876543'
    private-key: ${{ secrets.MY_GH_APP_PRIVATE_KEY_SECRET }}
```

Another alternative is to specify the `app-installation-repo` input so that the
access token will be specified against the named repo:

```yaml
- name: Generate JWT and token
  id: generate-github-app-tokens
  uses: jamestrousdale/github-app-jwt-token@x.y.z # <- Put version in here
  with:
    app-id: '123456'
    app-installation-repo: 'my-repo-owner/my-repo-name'
    private-key: ${{ secrets.MY_GH_APP_PRIVATE_KEY_SECRET }}
```

## Releases

This project uses [`m`](https://github.com/jmlopez-rod/m) for release 
management.
