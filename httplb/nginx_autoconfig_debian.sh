#!/bin/bash

target=$1
servers=${@:2:($#-1)}
fname="/etc/nginx/sites-available/$target"

if [ ! -f "$fname" ];
then
	exit 1
fi

echo "server {
        listen 80;
        server_name $target;
        location / {
                proxy_pass  http://lxc.$target;
                include /etc/nginx/proxy_params;
        }
}
upstream lxc.$target {" > $fname
for s in `echo "$servers"`;
do
	echo "        server $s:3000;" >> $fname
done
echo "}" >> $fname

ln -s $fname /etc/nginx/sites-enabled/$target

service nginx reload
