#!/bin/bash

echo Start redmine-plugin-test-action

echo Set environment variables
set -xe
PLUGIN=$1
REDMINE_VERSION=$2
REDMINE_GIT_REPO=$3
WORKSPACE=$(cd $GITHUB_WORKSPACE/../.. && pwd)/workspace
PATH_TO_PLUGIN=$GITHUB_WORKSPACE
PATH_TO_REDMINE=$WORKSPACE/redmine
PATH_TO_PLUGINS=$PATH_TO_REDMINE/plugins/$PLUGIN
PATH_DBYML=$(cd $(dirname $0)/../config && pwd)/database.yml
TRACE=--trace

echo Install Redmine
mkdir $WORKSPACE
rm -rf $PATH_TO_REDMINE
git clone -b $REDMINE_VERSION $REDMINE_GIT_REPO $PATH_TO_REDMINE
cd $PATH_TO_REDMINE

echo Install plguin
ln -s $PATH_TO_PLUGIN $PATH_TO_PLUGINS
cp $PATH_DBYML config/database.yml
mkdir -p vendor/bundle
bundle install --path vendor/bundle
bundle exec rake db:migrate $TRACE
bundle exec rake redmine:load_default_data REDMINE_LANG=en $TRACE
bundle exec rake generate_secret_token $TRACE
bundle exec rake redmine:plugins:migrate $TRACE

echo Run tests
RAILS_ENV=test RUBYOPT=-W0 TESTOPTS=-v bundle exec rake $TRACE redmine:plugins:test NAME=$PLUGIN

echo Uninstall plugin
bundle exec rake $TRACE redmine:plugins:migrate NAME=$PLUGIN VERSION=0

echo Finish redmine-plugin-test-action
