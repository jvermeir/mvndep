#!/usr/bin/env bash

#
# create a new branch, update dependencies and run build.
# branch is pushed if build succeeds

if [[ -n $(git status -s) ]]
then
    echo "Uncommitted changes are not allowed"
    exit -1
fi

DATE=$(date +"%Y%m%d%H%M%S")

BRANCH_NAME=feature/mvnUpgrade$DATE
echo "creating branch $BRANCH_NAME"

git checkout -b $BRANCH_NAME

echo "upgrade"
mvn -q versions:update-properties versions:use-latest-versions

DIFFERENCES=$(diff pom.xml pom.xml.versionsBackup)
if [ -z "$DIFFERENCES" ]; then
    echo "No changes detected. Exiting"
    exit 0
fi

echo "test"
mvn -q clean install

if [ $? -eq 0 ]; then
    echo "ok"
    git add pom.xml
    git commit -m "Auto upgrade"
    git push --set-upstream origin $BRANCH_NAME

    echo "changes:"
    diff pom.xml pom.xml.versionsBackup
else
    echo "oh dear. Upgrade failed"
    exit 1
fi

exit 0