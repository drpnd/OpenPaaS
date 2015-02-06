#!/bin/sh

## Working repository
WORKING_REPOSITORY=$OPLAT_OPLAT_GITOLITE_REPOSITORY

## Arguments
username=$1

## Only one process is allowed
[ -f /tmp/oplat.lock ] && exit 1

## Lock
touch /tmp/oplat.lock
trap 'rm -f /tmp/oplat.lock' 1 2

## Check the argument
if [ "$username" = "" ];
then
	printf "%s <username>\n" $0
	echo "Error: Please specify username"
	rm -f /tmp/oplat.lock
	exit 1
fi

cd $WORKING_REPOSITORY
if [ -f keydir/$username.pub ];
then
	echo "Error: User already exists."
	exit 1
fi
touch keydir/$username.pub
git add keydir/$username.pub
git commit -m "add $username."
git push

## Unlock
rm -f /tmp/oplat.lock
