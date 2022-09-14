#!/bin/bash

source utils.sh

create_repo
init_repo

create_mergeable pr-mergeable

squash_rebase pr-mergeable "Our super duper PR"

inspect_repo
