#!/bin/sh

#info
TOPIC=Persistence
DESCRIPTION="This script will dump the persistence database"

#Volumes/files
ORIGINAL=/var/fw/persistence.sqlite

echo $DESCRIPTION

. /eso/hmi/engdefs/scripts/mqb/util_info.sh
. /eso/hmi/engdefs/scripts/mqb/util_mountsd.sh
if [[ -z "$VOLUME" ]] 
then
	echo "No SD-card found, quitting"
	exit 0
fi

#Make dump folder
DUMPFOLDER=$VOLUME/Dump/$VERSION/$FAZIT/$TOPIC

echo Dump-folder: $DUMPFOLDER
mkdir -p $DUMPFOLDER
echo Dumping, please wait. This can take a while.
sleep 1

echo Copying files
cp -R $ORIGINAL $DUMPFOLDER

# Make readonly again
mount -ur $VOLUME

echo "Done. Persistence.sqlite dump can be found in the Dump folder on your SD-card"

exit 0
