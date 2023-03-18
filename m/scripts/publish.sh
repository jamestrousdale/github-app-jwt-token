#!/bin/bash

set -xeuo pipefail

# source the m environment
m ci env m >/dev/null
source m/.m/env.list
export $(cut -d= -f1 m/.m/env.list)

# Only publish with the CI tool
[ "$M_CI" == "True" ] || exit 0

# Only on release
[ "$M_IS_RELEASE" == "True" ] || exit 0
m github release --owner "$M_OWNER" --repo "$M_REPO" --version "$M_TAG"
