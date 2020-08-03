# example.sh
# The script will help launch mountHelper and diskHelper
# Then the user could use vmware-vdiskmanager
# Finally, the script will stop the mountHelper and diskHelper

#PREREQUISITES:
#Installclear
 VMWARE FUSION DMG
#Open the DMG in DISK UTIL.
#Select the HDD "InstallESD".
#Now click the button named ‘Unmount’ .
#The text ‘InstallESD’ in the list of disks, should now be dimmed slightly.
#GET INFO to get the disk number.
#Close DISK UTIL.
#EDIT bottom section of this script and Run this script


Fusion="/Applications/VMware Fusion.app"

LIBDIR='/Applications/VMware Fusion.app/Contents/Library'
HELPER_DIR='/Library/PrivilegedHelperTools'
HELPERPLIST_DIR='/Library/LaunchDaemons'

# Stage and start a privileged helper in exactly the same fashion as SMJobBless.
startPrivilegedHelper() {
local helper="$1"

cp -f -- "$LIBDIR"/LaunchServices/"$helper" "$HELPER_DIR"
chmod 544 "$HELPER_DIR"/"$helper"
cp -f -- "$LIBDIR"/LaunchServices/"$helper".plist "$HELPERPLIST_DIR"
chmod 644 "$HELPERPLIST_DIR"/"$helper".plist
launchctl load "$HELPERPLIST_DIR"/"$helper".plist
}

# Stop and remove a privileged helper.
stopPrivilegedHelper() {
local helper="$1"

launchctl stop "$helper"
launchctl unload "$HELPERPLIST_DIR"/"$helper".plist
rm "$HELPER_DIR"/"$helper"
rm "$HELPERPLIST_DIR"/"$helper".plist
}

startPrivilegedHelper com.vmware.MountHelper
startPrivilegedHelper com.vmware.DiskHelper

#NOTICE!!!!  MOUNT DISKS FIRST BEFORE RUNNING THIS -- GET THE DISK NUMBERS AND AMEND

#CREATE CATALINA
	#tidy up old relics
rm -rf /users/dglab/Desktop/Catalina_Beta*.vmdk
	#run vmware disk link
/Applications/VMware\ Fusion.app/Contents/Library/vmware-rawdiskCreator create /dev/disk2 fullDevice /users/dglab/Desktop/Catalina_Beta-link lsilogic
	#run vmdk conversion
/Applications/VMware\ Fusion.app/Contents/Library/vmware-vdiskmanager -r /users/dglab/Desktop/Catalina_Beta-link.vmdk -t 4 /users/dglab/Desktop/Catalina_Beta.vmdk

#CREATE MOJAVE
	#tidy up old relics
#rm -rf /users/dglab/Desktop/Mojave*.vmdk
	#run vmware disk link
#/Applications/VMware\ Fusion.app/Contents/Library/vmware-rawdiskCreator create /dev/disk2 fullDevice /users/dglab/Desktop/Mojave-link lsilogic
	#run vmdk conversion
#/Applications/VMware\ Fusion.app/Contents/Library/vmware-vdiskmanager -r /users/dglab/Desktop/Mojave-link.vmdk -t 4 /users/dglab/Desktop/Mojave.vmdk

#CREATE HIGHSIERRA
	#tidy up old relics
#rm -rf /users/dglab/Desktop/High_Sierra*.vmdk
	#run vmware disk link
#/Applications/VMware\ Fusion.app/Contents/Library/vmware-rawdiskCreator create /dev/disk2 fullDevice /users/dglab/Desktop/High_Sierra-link lsilogic
	#run vmdk conversion
#/Applications/VMware\ Fusion.app/Contents/Library/vmware-vdiskmanager -r /users/dglab/Desktop/High_Sierra-link.vmdk -t 4 /users/dglab/Desktop/High_Sierra.vmdk

stopPrivilegedHelper com.vmware.MountHelper
stopPrivilegedHelper com.vmware.DiskHelper
