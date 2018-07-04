#!/usr/bin/env bash

DATE=$(date +"%Y%m%d%M%S")

mvn versions:use-latest-versions

DIFFERENCES=$(diff pom.xml pom.xml.versionsBackup)
if [ -z "$DIFFERENCES" ]; then
    echo "No changes detected. Exiting"
    exit 0
fi

BRANCH_NAME=feature/mvnUpgrade$DATE
echo "creating branch $BRANCH_NAME"

git checkout -b $DATE

mvn -q clean install

if [ $res -eq 0 ]; then
    echo "ok"
    git add pom.xml
    git commit -m "Auto upgrade"
else
    echo "oh dear. Upgrade failed"
fi