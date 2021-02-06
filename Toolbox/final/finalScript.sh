#!/bin/ksh

echo FinalScript for HW ${1} on medium ${2}...

VOLUME="${2}"

if [ -z "$VOLUME" ]; then
    if [[ -d /net/mmx/fs/sda0 ]]
    then
        echo SDA0 found
        export VOLUME=/net/mmx/fs/sda0
    elif [[ -d /net/mmx/fs/sdb0 ]]
   then
       echo SDB0 found
        export VOLUME=/net/mmx/fs/sdb0
    else
        echo No SD-cards found.
        exit 0
    fi
fi

# Make SD writable for logging
on -f mmx /bin/mount -uw $VOLUME

LOGDIR=$VOLUME/Log
LOGFILE=$LOGDIR/install_final.txt

mkdir -p $LOGDIR

/bin/ksh $VOLUME/Toolbox/final/install_scripts.sh $VOLUME > $LOGFILE 2>&1

# Cleanup old MQBToolbox installations
/bin/ksh $VOLUME/Toolbox/final/cleanup.sh >> $LOGFILE 2>&1

# Set unit into developer mode
export LD_LIBRARY_PATH=/mnt/app/root/lib-target:/eso/lib:/mnt/app/usr/lib:/mnt/app/armle/lib:/mnt/app/armle/lib/dll:/mnt/app/armle/usr/lib 
export IPL_CONFIG_DIR=/etc/eso/production
on -f mmx /net/mmx/mnt/app/eso/bin/apps/pc b:0:0xC002000D 1

# Make SD readonly again
on -f mmx /bin/mount -ur $VOLUME

echo Done.
touch /tmp/SWDLScript.Result

