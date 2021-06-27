#!/bin/bash

echo "MAKE SURE TO UNMOUNT THE DEVICE BEFORE ANY ACTIONS!!"
sleep 1

if [ -z $1 ] || [ -z $2 ] || [ -z $3 ]
then
	echo 'you need to specify the operation and the device or the file'
	echo 'To create:'
	echo 'bash script.sh -c /dev/device path/to/the/parent/folder '
	echo 'To restore:'
	echo 'bash script.sh -r /dev/device path/to/the/file'
	exit 1
fi

OP=$1
DEVICE=$2

if [ $OP = '-c' ]
then
	# REMOVING THE LAST CHAR IF ITS A /
	FOLDER="$(echo $3 | sed 's|/$||g')"
	echo 'CREATING THE IMAGE'
	echo "Writing from $DEVICE to $FOLDER/rasp-$(date +%F_%H-%M-%S).img.gz"
	# MAKE IMAGE
	sudo dd bs=4M if=$DEVICE | gzip > $FOLDER/rasp-$(date +%F_%H-%M-%S).img.gz

elif [ $OP = '-r' ]
then
	echo "MAKE SURE THE DEVICE IS WRITABLE BEFORE THIS OPERATION"
	sleep 2
	FILE=$3
	echo 'RESTORING THE IMAGE'
	echo "Restoring image from $FILE to device $DEVICE"
	# RESTORE IMAGE
	gunzip --stdout $FILE | sudo dd bs=4M of=$DEVICE
fi

# MAKE IMAGE
#sudo dd bs=4M if=/dev/sdc | gzip > rasp-$(date +%F_%H-%M-%S).img.gz

# RESTORE IMAGE
#gunzip --stdout rasp.img.gz | sudo dd bs=4M of=/dev/sdc

# TO WATCH file created
# watch "ls -lh rasp-*.gz | cut -d' ' -f5-9"


spd-say "DONE"
exit 0
