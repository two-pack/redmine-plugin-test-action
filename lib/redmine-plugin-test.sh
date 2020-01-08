#!/bin/bash

set -xe
PLUGIN_NAME=$1
REDMINE_VERSION=(${2/v/})
RUBY_VERSION=(${3/v/})

cd $(cd $(dirname $0)/../ && pwd)
docker build -t redmine-plugin-test \
             --build-arg REDMINE_VERSION=${REDMINE_VERSION} \
             --build-arg RUBY_VERSION=${RUBY_VERSION} .
docker run -e "GITHUB_REF=${GITHUB_REF}" \
           -e "GITHUB_REPOSITORY=${GITHUB_REPOSITORY}" \
           -e "PLUGIN_NAME=${PLUGIN_NAME}" \
           -t redmine-plugin-test
