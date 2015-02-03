

## Install gitolite

Create an administrator account

    # useradd -m admin -s /bin/bash

Switch the user and create an SSH key pair

    # su - admin
    $ ssh-keygen -b 2048 -t rsa

Create git account as common user name for gitolite
    
    # uesradd -m git -s /bin/bash

Setup gitolite with administrator's public key

    # cp /home/admin/.ssh/id_rsa.pub /tmp/admin.pub
    # su - git
    $ gl-setup /tmp/admin.pub



