## Directory where the attributes of running instances is saved
INSTANCE_DIR="/home/ubuntu/instances"

## HTTP Load Balancer
HTTP_LB="mgmt@http-load-balancer"

## FQDN
fqdn=`cat $INSTANCE_DIR/$REPOSITORY.fqdn`

## Only master branch is the target
BRANCH=$(git rev-parse --symbolic --abbrev-ref $1)
if [ "$BRANCH" != "master" ];
then
	#echo -n ""
	exit
fi

IFS1="
"
IFS2=" "
## Deploy to all instances
IFS=$IFS1
for ln in `cat "$INSTANCE_DIR/$REPOSITORY"`;
do
	IFS=$IFS2
	set -- $ln
	server=$1
	instance=$2
	## Extract instances except for the target one
	arg=""
	IFS=$IFS1
	for ln in `cat "$INSTANCE_DIR/$REPOSITORY"`;
	do
		IFS=$IFS2
		set -- $ln
		i2=$2
		if [ "$i2" != "$instance" ];
		then
			arg="$arg $2" 
		fi
	done
	ssh $HTTP_LB sudo /opt/nginx_autoconfig.sh $fqdn $arg
	## Deploy
	ssh ubuntu@$instance "./rdeploy.sh"
	ssh -f -n ubuntu@$instance "./rinstance.sh" > /dev/null 2>&1
done

## Extract instances
arg=""
IFS=$IFS1
for ln in `cat "$INSTANCE_DIR/$REPOSITORY"`;
do
	IFS=$IFS2
	set -- $ln
	i2=$2
	arg="$arg $2" 
done
ssh $HTTP_LB sudo /opt/nginx_autoconfig.sh $fqdn $arg

exit 0
