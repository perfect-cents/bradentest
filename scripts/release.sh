#!/usr/bin/env bash

set -e

VERSION=$(node -e "console.log(($(yarn version apply --json)).newVersion)")

git add package.json
git commit -m "v$VERSION"
git tag "v$VERSION"

yarn npm publish --tolerate-republish

git push --tags
