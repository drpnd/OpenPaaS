## Only master branch is the target
BRANCH=$(git rev-parse --symbolic --abbrev-ref $1)
if [ "$BRANCH" != "master" ];
then
	#echo -n ""
	exit
fi

rails runner /var/www/OpenPaaS/repos/oplat/scripts/update_instance.rb

exit 0
