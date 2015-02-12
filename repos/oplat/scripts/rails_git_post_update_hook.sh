## Only master branch is the target
BRANCH=$(git rev-parse --symbolic --abbrev-ref $1)
if [ "$BRANCH" != "master" ];
then
	#echo -n ""
	exit
fi

cd /var/www/OpenPaaS/repos/oplat
ruby ./scripts/update_instance.rb
#rails runner ./scripts/update_instance.rb

exit 0
