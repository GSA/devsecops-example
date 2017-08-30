#!/bin/bash

# adapted from
# https://github.com/hashicorp/terraform/issues/2740#issuecomment-288549352

set -e
set -x

# note the name doesn't match the device_name in Terraform
DEVICE=/dev/xvdf
MOUNT=/usr/share/wordpress/wp-content-mount
# TODO pass in
OWNER=www-data
DEST=/usr/share/wordpress/wp-content

devpath=$(readlink -f $DEVICE)

sudo file -s $devpath | grep -q ext4
if [[ 1 == $? && -b $devpath ]]; then
  sudo mkfs -t ext4 $devpath
fi

sudo mkdir $MOUNT
sudo chown $OWNER:$OWNER $MOUNT
sudo chmod 0775 $MOUNT

echo "$devpath $MOUNT ext4 defaults,nofail,noatime,nodiratime,barrier=0,data=writeback 0 2" | sudo tee -a /etc/fstab > /dev/null
sudo mount $MOUNT

# TODO: /etc/rc3.d/S99local to maintain on reboot
echo deadline | sudo tee /sys/block/$(basename "$devpath")/queue/scheduler
echo never | sudo tee /sys/kernel/mm/transparent_hugepage/enabled

# if themes directory doesn't exist
if [ ! -d "$MOUNT/themes" ]; then
  # volume doesn't contain initial data - copy existing content in
  cp -R $DEST $MOUNT
fi

ln -s $MOUNT $DEST
