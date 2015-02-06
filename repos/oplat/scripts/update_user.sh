#!/bin/sh

## Working repository
WORKING_REPOSITORY=$OPLAT_OPLAT_GITOLITE_REPOSITORY

## Arguments
username=$1
ssh_pub_key=$2

## Only one process is allowed
[ -f /tmp/oplat.lock ] && exit 1

## Lock
touch /tmp/oplat.lock
trap 'rm -f /tmp/oplat.lock' 1 2

## Check the argument
if [ "$username" = "" ];
then
	printf "%s <username> <ssh_pub_key>\n" $0
	echo "Error: Please specify username"
	rm -f /tmp/oplat.lock
	exit 1
fi
if [ "$ssh_pub_key" = "" ];
then
	printf "%s <username> <ssh_pub_key>\n" $0
	echo "Error: Please specify SSH public key"
	rm -f /tmp/oplat.lock
	exit 1
fi

cd $WORKING_REPOSITORY
if [ ! -f keydir/$username.pub ];
then
	echo "Error: User not found."
	exit 1
fi
echo $ssh_pub_key > keydir/$username.pub
git commit -m "update $username." keydir/$username.pub
git push

## Unlock
rm -f /tmp/oplat.lock
