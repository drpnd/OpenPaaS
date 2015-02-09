#!/bin/sh

VERSION=00

for i in `seq 200`;
do
    n=`printf "%03d" $i`
    lxc-clone -o template -n instance-v$VERSION-$n
    echo "lxc.network.ipv4 = 10.0.1.$i/8" >> /var/lib/lxc/instance-v$VERSION-$n/config
done
