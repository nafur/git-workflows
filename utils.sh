#!/bin/bash

REPO_DIR=tmp_repo

create_repo() {
    if [ -d "$REPO_DIR" ] ; then
        rm -rf $REPO_DIR
    fi
    mkdir $REPO_DIR
    pushd $REPO_DIR
    git init -b main
    git config user.email "foo@bar.baz"
    git config user.name "Foo Bar"
}

inspect_repo() {
    git status
    echo ""
    echo "overall history"
    git log --all --decorate --oneline --graph
    echo ""
    echo "main history"
    git log --decorate --oneline --graph
}

destroy_repo() {
    popd
    rm -rf $REPO_DIR
}

change_and_commit() {
    sed -i "$1" test.txt
    git add test.txt
    git commit -m "$2"
}

init_repo() {
    cat << EOF >> test.txt
Lorem ipsum dolor sit amet, consectetur
adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna
aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris
nisi ut aliquip ex ea commodo
consequat. Duis aute irure dolor in
reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur.
Excepteur sint occaecat cupidatat non
proident, sunt in culpa qui officia
deserunt mollit anim id est laborum.
EOF
    git add test.txt
    git commit -m "initial commit"
    change_and_commit 's/aliquip/piuqila/g' "minor modification"
}

create_mergeable() {
    BRANCH=$1

    git checkout -b $BRANCH
    change_and_commit 's/enim/mine/g' "commit 1"
    change_and_commit 's/tempor/ropmet/g' "commit 2"

    git checkout main
    change_and_commit 's/irure/eruri/g' "very important modification"

    git checkout $BRANCH
}

create_conflict() {
    BRANCH=$1

    git checkout -b $BRANCH
    change_and_commit 's/enim/mine/g' "new feature"

    git checkout main
    change_and_commit 's/enim/eenniimm/g' "very important modification"

    git checkout $BRANCH
}

squash_merge() {
    BRANCH=$1
    COMMITMSG=$2

    git checkout $BRANCH
    git merge --no-edit main
    git checkout main
    git checkout -b $BRANCH-squashed
    git merge --squash $BRANCH
    git checkout main
    git merge $BRANCH-squashed
    git commit -m "$COMMITMSG"
    git branch -D $BRANCH-squashed
}