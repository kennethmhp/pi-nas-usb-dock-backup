# pi-nas-usb-dock-backup

This is a mini project of making use of hardware relay, crontab, shell, python, GOIP, IFTTT to have a power saving daily backup the NAS (host by Raspberry Pi) to a USB hard drive.

## Main features
* auto power-on-off of usb backup hard drive
* verify number of changes before copy to backup to avoid ransomware attack
* IFTTT email notification for exceptions

## Hardware Requirement
* Raspberry Pi 2 or above (recommended for Pi 3 for real GE)
* hardware relay operate for 5A
* USB to SATA dock with external power

Wiring please refer to:
https://github.com/kennethmhp/pi-nas-usb-dock-backup/blob/master/pi_relay_dock_wiring.png

## General Guideline
The script is designed for my personal use. Any personl data is removed for this github version such as the IFTTT Rest key. The following notes vary by person and hardware.
* I operate the relay as is a low trigger ( 0 is power on)
* My script placed under the pi's home directory
* The line of firing to IFTTT Maker is commented
* The backup is aborted if there are more than 500 changes, manual handle is required
* Crontab setting is not included
* backup source and dest directory are all commented
* mount/unmount are commented

## Files
usb_hdd_pwr.py - turning on/off the power supply to the USD HDD dock, usage:
```
python usb_hdd_pwr.py [on|off]
```
nas_backup.sh - main shell scipt to: power on the HDD dock > check USB device > mounting > rsync dryrun > change check > rsync > unmount > power off
