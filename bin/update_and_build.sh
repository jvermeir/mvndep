#!/usr/bin/env bash

if [[ -n $(git status -s) ]]
then
    echo "Uncommitted changes are not allowed"
    exit -1
fi

DATE=$(date +"%Y%m%d%M%S")

BRANCH_NAME=feature/mvnUpgrade$DATE
echo "creating branch $BRANCH_NAME"

git checkout -b $BRANCH_NAME

mvn versions:use-latest-versions

DIFFERENCES=$(diff pom.xml pom.xml.versionsBackup)
if [ -z "$DIFFERENCES" ]; then
    echo "No changes detected. Exiting"
    exit 0
fi

mvn -q clean install

if [ $? -eq 0 ]; then
    echo "ok"
    git add pom.xml
    git commit -m "Auto upgrade"
else
    echo "oh dear. Upgrade failed"
fi