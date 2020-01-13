#!/bin/bash

set -xe
PLUGIN_NAME=$1
REDMINE_VERSION=(${2/v/})
RUBY_VERSION=(${3/v/})
if [ "${GITHUB_HEAD_REF}" = "" ]; then
  PLUGIN_BRANCH=$(echo ${GITHUB_REF#refs/heads/})
else
  PLUGIN_BRANCH=${GITHUB_HEAD_REF}
fi

cd $(cd $(dirname $0)/../ && pwd)
docker build -t redmine-plugin-test \
             --build-arg REDMINE_VERSION=${REDMINE_VERSION} \
             --build-arg RUBY_VERSION=${RUBY_VERSION} .
docker run -e "GITHUB_REPOSITORY=${GITHUB_REPOSITORY}" \
           -e "PLUGIN_NAME=${PLUGIN_NAME}" \
           -e "PLUGIN_BRANCH=${PLUGIN_BRANCH}" \
           -t redmine-plugin-test
