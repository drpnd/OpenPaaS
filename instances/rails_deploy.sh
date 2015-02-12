#!/bin/sh

RAILS_ENV=$1
DATABASE_PASSWORD=$2

## The following variables may be moved to arguments of this script.
REPOS_SERVER=$3
REPOS_USERNAME=$4
REPOS_APPNAME=$5
DATABASE_URL=$6

export RAILS_ENV
export DATABASE_PASSWORD
export REPOS_SERVER
export REPOS_USERNAME
export REPOS_APPNAME
export DATABASE_URL

## Kill the running instance
kill -9 `cat rails_instance.pid`

if [ -d $REPOS_APPNAME ]; then
    ## Clone the up-to-date software
    cd $REPOS_APPNAME
    rm Gemfile.lock
    git pull
else
    git clone ssh://git@$REPOS_SERVER/$REPOS_USERNAME/$REPOS_APPNAME
    cd $REPOS_APPNAME
fi

## Execute bundle install and DB migration
bundle install --path vendor/bundle
DATABASE_URL=$DATABASE_URL bundle exec rake db:migrate
