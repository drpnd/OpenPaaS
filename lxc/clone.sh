#!/bin/sh

VERSION=00

for i in `seq 200`;
do
    n=`printf %03 $i`
    lxc-clone -o template -n instance-v00-$n
    echo "lxc.network.ipv4 = 10.0.1.$n/8" >> /var/lib/lxc/instance-v00-$n/config
done
