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
DATE=$(date +%F_%H-%M-%S)

if [ $OP = '-c' ]
then
	# REMOVING THE LAST CHAR IF ITS A /
	FOLDER="$(echo $3 | sed 's|/$||g')"
	FullFileName="$FOLDER/rasp-$DATE.img.gz"
	echo 'CREATING THE IMAGE'
	echo "Writing from $DEVICE to $FOLDER/rasp-$DATE.img.gz"
	# MAKING THE IMAGE
	start=`date +%s`
	
	sudo dd bs=4M if=$DEVICE | gzip > $FOLDER/rasp-$DATE.img.gz
	
	end=`date +%s`
	runtime=$((end-start))
	
	hours=$((runtime / 3600))
	minutes=$(( (runtime % 3600) / 60 ))
	seconds=$(( (runtime % 3600) % 60 ))

	BotMessage="Backup made from $DEVICE to $FullFileName in:    $hours:$minutes:$seconds (hh:mm:ss)"
	echo $BotMessage



elif [ $OP = '-r' ]
then
	echo "MAKE SURE THE DEVICE IS WRITABLE BEFORE THIS OPERATION"
	sleep 2
	FILE=$3
	echo 'RESTORING THE IMAGE'
	echo "Restoring image from $FILE to device $DEVICE"
	# RESTORING THE IMAGE
	start=`date +%s`
	
	gunzip --stdout $FILE | sudo dd bs=4M of=$DEVICE
	
	end=`date +%s`
	runtime=$((end-start))

	hours=$((runtime / 3600))
	minutes=$(( (runtime % 3600) / 60 ))
	seconds=$(( (runtime % 3600) % 60 ))

	BotMessage="Restored image from $FILE to $DEVICE in:    $hours:$minutes:$seconds (hh:mm:ss)"
	echo $BotMessage

fi


BOT=/usr/bin/telegram_msg
if [ -f "$BOT" ]; then
   $BOT "$BotMessage"
fi

# MAKE IMAGE
#sudo dd bs=4M if=/dev/sdc | gzip > rasp-$(date +%F_%H-%M-%S).img.gz

# RESTORE IMAGE
#gunzip --stdout rasp.img.gz | sudo dd bs=4M of=/dev/sdc

# TO WATCH file created
# watch "ls -lh rasp-*.gz | cut -d' ' -f5-10"

notify-send "DONE"
spd-say "DONE"
exit 0
