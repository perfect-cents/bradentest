#!/usr/bin/env bash

set -e

VERSION_JSON=$(yarn version apply --json)

if [ -n "$VERSION_JSON" ]; then
  VERSION=$(node -e "console.log(($VERSION_JSON).newVersion)")
  PKG_NAME=$(node -e "console.log(($VERSION_JSON).ident)")

  git add -u
  git commit -m "$PKG_NAME@$VERSION"
  git tag "$PKG_NAME@$VERSION"

  [[ "$GITHUB_HEAD_REF" == 'release' ]] && TAG=latest || TAG=next

  yarn npm publish --tolerate-republish --tag $TAG
fi
