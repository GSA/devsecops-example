#!/bin/bash

# adapted from
# https://github.com/hashicorp/terraform/issues/2740#issuecomment-288549352

set -e
set -x

# note the name doesn't match the device_name in Terraform
DEVICE=/dev/xvdf
OWNER=www-data
DEST=/usr/share/wordpress/wp-content
OLDDEST=$DEST-old
# if this directory is present, assume volume contains initial data
CHECK_DIR=$DEST/themes

devpath=$(readlink -f $DEVICE)

if [[ $(sudo file -s $devpath) != *ext4* && -b $devpath ]]; then
  # Filesystem has not been created. Create it!
  sudo mkfs -t ext4 $devpath
fi

sudo mv $DEST $OLDDEST
sudo mkdir -p $DEST

# add to fstab if not present
if ! egrep "^${devpath}" /etc/fstab; then
  echo "$devpath $DEST ext4 defaults,nofail,noatime,nodiratime,barrier=0,data=writeback 0 2" | sudo tee -a /etc/fstab > /dev/null
fi
sudo mount $DEST

sudo chown $OWNER:$OWNER $DEST
sudo chmod 0775 $DEST

# TODO: /etc/rc3.d/S99local to maintain on reboot
echo deadline | sudo tee /sys/block/$(basename "$devpath")/queue/scheduler
echo never | sudo tee /sys/kernel/mm/transparent_hugepage/enabled

if [ ! -d "$CHECK_DIR" ]; then
  # Copy initial content in.
  # https://askubuntu.com/a/86891/501568
  sudo cp -a $OLDDEST/. $DEST/
fi
