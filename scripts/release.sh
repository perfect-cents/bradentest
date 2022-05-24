#!/usr/bin/env bash

set -e

VERSION_JSON=$(yarn version apply --json)

echo VERSION_JSON $VERSION_JSON

VERSION=$(node -e "console.log(($VERSION_JSON).newVersion)")

git add -u
git commit -m "v$VERSION"
git tag "v$VERSION"

yarn npm publish --tolerate-republish

git push --tags
