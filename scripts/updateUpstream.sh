#!/usr/bin/env bash

# file utilized in github actions to automatically update upstream

(
set -e
PS1="$"

current=$(cat gradle.properties | grep paperRef | sed 's/paperRef = //')
upstream=$(git ls-remote https://github.com/PaperMC/Paper | grep ver/1.20.2 | cut -f 1)

if [ "$current" != "$upstream" ]; then
    sed -i 's/paperRef = .*/paperRef = '"$upstream"'/' gradle.properties
    {
      ./gradlew applyPatches --stacktrace && ./gradlew build --stacktrace && ./gradlew rebuildPatches --stacktrace
    } || exit

    git add .
    ./scripts/upstreamCommit.sh "$current"
fi

) || exit 1