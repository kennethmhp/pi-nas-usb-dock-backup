#!/bin/bash

# the change check value, 3 lines of overhead for standard rsync output
lnth=503

log(){
        echo "$(date)> $1"
}

postIFTTT(){
curl -k --header "Content-Type: application/json" \
  --request POST \
  --data "{\"value1\":\"$1\"}" \
  https://maker.ifttt.com/trigger/nas_backup_fail/with/key/__your_IFTTT_Maker_KEY___
}

dryrunRsync(){
rm -f /home/pi/rsync_f*_log
log "Verifying Changes"
rsync -razvh /__your_nas_directory__/ /__your_backup_directory__/ --delete --dry-run --log-file=/home/pi/rsync_f1_log
}

doRsync(){
rm -f /home/pi/rsync_f*_log
log "Start rsync...fserver1"
rsync -razvh /__your_nas_directory__/ /__your_backup_directory__/ --delete --log-file=/home/pi/rsync_f1_log
log "All rsync complete... 10 sec cooldown"
sleep 10
}

log "Start backup"
python /home/pi/usb_hdd_pwr.py on
log "USB dock power on..."
sleep 30
# check if USB HDD is connected on /dev/sdb
sdb=$(lsblk | grep sdb1 |wc -l)
if [ $sdb -eq 1 ]
then
        log "Backup HDD plugged..."
        #mount /dev/sdb1 /__your_backup_directory__/
        # My Backup HDD has a Volume label of "2T"
        mnt2t=$(lsblk | grep 2T |wc -l)
        if [ $mnt2t -eq 1 ]
        then
                log "Backup HDD mounted..."
                dryrunRsync
                cnt1=$(cat /home/pi/rsync_f1_log |wc -l)
                if [ $cnt1 -gt $lnth ]
                then
                        #need attention and stop script
                        log "Too many changes, Rsync aborted"
                        postIFTTT "Too many changes, Rsync aborted"
                else
                        doRsync
                fi
        else
                log "Mount failed"
                postIFTTT "Mount HDD failed"
        fi
        umount /dev/sdb1
        log "All drive unmounted... 10 sec cooldown"
        sleep 10
else
        log "No USB found"
        postIFTTT "No USB dock found"
fi
python /home/pi/usb_hdd_pwr.py off
log "USB dock power off"
log "Backup ended"
# my crontab will output the log, copy it to my NAS share folder for easy access
#cp /home/pi/nas_backup.log /__your_nas_directory__/
