#!/bin/bash

echo Start redmine-plugin-test-action

echo Set environment variables
set -xe
PLUGIN_REPO=https://github.com/${GITHUB_REPOSITORY}.git
WORKSPACE=/var/lib/redmine
TRACE=--trace

echo Install plguin
cd ${WORKSPACE}
git clone -b ${PLUGIN_BRANCH} --depth 1 ${PLUGIN_REPO} ${WORKSPACE}/plugins/${PLUGIN_NAME}
bundle install --path vendor/bundle
bundle exec rake redmine:plugins:migrate $TRACE

echo Run tests
RAILS_ENV=test RUBYOPT=-W0 TESTOPTS=-v bundle exec rake $TRACE redmine:plugins:test NAME=${PLUGIN_NAME}

echo Uninstall plugin
bundle exec rake $TRACE redmine:plugins:migrate NAME=${PLUGIN_NAME} VERSION=0

echo Finish redmine-plugin-test-action
