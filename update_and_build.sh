#!/usr/bin/env bash

DATE=$(date +"%Y%m%d%M%S")

DIFFERENCES=$(diff pom.xml pom.xml.versionsBackup)
if [ -z "$DIFFERENCES" ]; then
    echo "No changes detected. Exiting"
    exit 0
fi

git branch -b $DATE

mvn clean install
