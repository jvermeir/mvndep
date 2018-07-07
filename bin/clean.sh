#!/usr/bin/env bash

BRANCHES=$(git branch | grep -v "*")

echo "branches: $BRANCHES"

for BRANCH in "$BRANCHES"; do
    B=$(echo $BRANCH|xargs)
    if [[ $B == feature/mvnUpgrade* ]]
    then
        git branch -D $B
    fi
done
