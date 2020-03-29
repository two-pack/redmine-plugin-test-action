#!/bin/bash

echo Start redmine-plugin-test-action

echo Set environment variables
set -xe
PLUGIN_REPO=https://github.com/${GITHUB_REPOSITORY}.git
WORKSPACE=/var/lib/redmine
TRACE=--trace

echo Prepare database
cd ${WORKSPACE}
if [ "${DATABASE}" = "postgresql" ]; then
  service postgresql start
  cp config/database.yml.postgresql config/database.yml
elif [ "${DATABASE}" = "mysql" ]; then
  service mysql start
  cp config/database.yml.mysql config/database.yml
else
  cp config/database.yml.sqlite3 config/database.yml
fi

echo Check environment
google-chrome --version
chromedriver --version
RAILS_ENV=test bin/about

echo Install plguin
git clone -b ${PLUGIN_BRANCH} --depth 1 ${PLUGIN_REPO} ${WORKSPACE}/plugins/${PLUGIN_NAME}
bundle install --path vendor/bundle
bundle exec rake redmine:plugins:migrate $TRACE

echo Run tests
RAILS_ENV=test RUBYOPT=-W0 TESTOPTS=-v bundle exec rake $TRACE redmine:plugins:test NAME=${PLUGIN_NAME}

echo Uninstall plugin
bundle exec rake $TRACE redmine:plugins:migrate NAME=${PLUGIN_NAME} VERSION=0

echo Finish redmine-plugin-test-action
