#!/bin/sh

export RAILS_ENV=$1
export DATABASE_PASSWORD=$2

## The following variables may be moved to arguments of this script.
REPOS_SERVER=$3
REPOS_USERNAME=$4
REPOS_APPNAME=$5

## Kill the running instance
kill `cat rails_instance.pid`

## Remove the old software
rm -rf $REPOS_APPNAME

## Clone the up-to-date software
git clone ssh://git@$REPOS_SERVER/$REPOS_USERNAME/$REPOS_APPNAME

## Execute bundle install and DB migration
cd $REPOS_APPNAME
bundle install --path vendor/bundle
bundle exec rake db:migrate
