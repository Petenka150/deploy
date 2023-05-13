#!/bin/bash

# BRANCH_NAME is a default variable set by Jenkins
#    on Jenkins agents it's equal to the branch that's being built

# -e option will make sure that script stops on first error
# -x option will show you everything that script is running to the output, helpful for troubleshooting
set -ex

export AWS_DEFAULT_REGION=us-east-1

# define current stage based on branch name
if [[ $BRANCH_NAME == final ]]
then
    current_stage=dev
    
elif [[ $BRANCH_NAME == main ]]
then
    current_stage=prod
fi

# this will happen only in dev and staging stages
#   to prevent build/push happening in prod stage
if [[ $current_stage == dev ]] || [[ $current_stage == staging ]]
then
    pushd backend/
    make build stage=$current_stage
    make push stage=$current_stage
    popd
fi

# this will happen regardless of the stage
pushd backend/
make deploy stage=$current_stage
popd