#!/usr/bin/env bash

set -e

versionjson=$(yarn version apply --json)

echo versionjson $versionjson

yarn npm publish --tolerate-republish
