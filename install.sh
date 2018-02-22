#!/bin/bash
#
# Debian micro home server installation(c) Igor Pecovnik
# 

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use the root user to install the software."
    exit 1
fi

# Debian only
if [ ! -f /etc/debian_version ]; then 
    echo "Unsupported Linux Distribution. Prepared for Debian"
    exit 1
fi

# Ramlog must be disabled
if [ -f /run/ramlog.lock ]; then
    echo "RAMlog is running. Please disable before running (service ramlog stop). Reboot may be required."
    exit 1
fi

#--------------------------------------------------------------------------------------------------------------------------------
# Updated to check if packages are installed to save time
# What do we need anyway
function updatecheck ()
{ 
apt-get clean	
if dpkg-query -W curl net-tools debconf-utils git whiptail build-essential stunnel4 html2text apt-transport-https; then
return
else
debconf-apt-progress -- apt-get update
apt-get -y install sudo net-tools curl debconf-utils dnsutils unzip whiptail git build-essential stunnel4 html2text apt-transport-https --force-yes
#debconf-apt-progress -- apt-get upgrade -y
fi
}
updatecheck
#--------------------------------------------------------------------------------------------------------------------------------

SECTION="Basic configuration"
# Read IP address
#
serverIP=$(ip route get 8.8.8.8 | awk '{ print $NF; exit }')
set ${serverIP//./ }
SUBNET="$1.$2.$3."
#Get host name, commenting out for media server
# Read full qualified hostname
#HOSTNAMEFQDN=$(hostname -f)
#HOSTNAMEFQDN=$(whiptail --inputbox "\nWhat is your full qualified hostname for $serverIP ?" 10 78 $HOSTNAMEFQDN --title "$SECTION" 3>&1 1>&2 2>&3)
#exitstatus=$?; if [ $exitstatus = 1 ]; then exit 1; fi
#set ${HOSTNAMEFQDN//./ }
#HOSTNAMESHORT="$1"

whiptail --title "Welcome to HTPC Guides Media Server" --msgbox "This Debian Wheezy/Jessie and Ubuntu installer will prompt for valid users and ports, defaults are suggested in () for those in doubt" 8 78

source "functions.sh"

whiptail --ok-button "Install" --title "HTPC Guides Media Server ARMv7 (c) HTPCGuides.com and Igor Pecovnik" --checklist --separate-output "\nIP:   $serverIP\n\nChoose what you want to install:" 20 78 9 \
"Plex" "Plex Media Server        " off \
"Kodi" "Raspberry Pi only        " off \
"NZBGet" "Usenet Downloader written in C++" off \
"Sabnzbd" "Usenet Downloader written in Python" off \
"SickRage" "Python Show Automation Finder" off \
"Sonarr" ".NET Show Automation Finder" off \
"Jackett" "Add custom providers to Sonarr" off \
"CouchPotato" "Video Automation Finder" off \
"Mylar" "Comic Automation Finder" off \
"Headphones" "Music Automation Finder" off \
"LazyLibrarian" "Book Automation Finder" off \
"Transmission" "Torrent downloading" off \
"CherryMusic" "Personal Grooveshark Server" off \
"HTPC Manager" "HTPC Management system" off \
"pyLoad" "Online locker downloader" off \
"miniDLNA" "ReadyMedia miniDLNA Latest" off \
"Ubooquity" "eBook Management" off \
"Madsonic" "Java media server" off \
"Subsonic" "Java media server" off \
"Samba" "Windows compatible file sharing        " off \
"NFS Tools" "Windows compatible file sharing        " off \
"Rpi monitor" "Status page and statistics" off \
"TV headend" "TV streaming / proxy" off \
"Syncthing" "Personal cloud" off \
"BitTorrent Sync" "Personal cloud" off \
"Webmin" "Admin server web interface" off \
"SoftEther VPN server" "Advanced VPN solution" off \
"Varnish" "Reverse Proxy HTTP Accelerator" off \
"LEMP" "nginx, PHP, MariaDB" off 2>results
while read choice
do
   case $choice in
   		   "Samba") 			ins_samba="true";;
		   "Syncthing") 			ins_syncthing="true";;
		   "Madsonic") 			ins_madsonic="true";;
		   "Subsonic") 			ins_subsonic="true";;
		   "pyLoad") 			ins_pyload="true";;
		   "Kodi") 			ins_kodi="true";;
		   "Plex") 			ins_plex="true";;
		   "Ubooquity") 		ins_ubooquity="true";;
		   "NFS Tools") 		ins_nfs="true";;
                   "TV headend") 		ins_tvheadend="true";;
                   "BitTorrent Sync") 	  	ins_btsync="true";;
                   "SoftEther VPN server") 	ins_vpn_server="true";;
		   "NZBGet") 			ins_nzbget="true";;
		   "miniDLNA") 			ins_minidlna="true";;
		   "Jackett") 			ins_jackett="true";;		   
		   "Sabnzbd") 			ins_sabnzbd="true";;
                   "SickRage") 			ins_sickrage="true";;
                   "Headphones") 			ins_headphones="true";;
                   "LazyLibrarian") 			ins_lazylibrarian="true";;
                   "Sonarr") 			ins_sonarr="true";;
                   "CouchPotato")		ins_couchpotato="true";;
                   "Mylar")			ins_mylar="true";;
                   "HTPC Manager")		ins_htpcmanager="true";;
		   "Rpi monitor") 		ins_rpimonitor="true";;
                   "Transmission")		ins_transmission="true";;
                   "CherryMusic")		ins_cherrymusic="true";;
		   "ISPConfig")			ins_ispconfig="true";;
		   "Webmin")			ins_webmin="true";;
		   "LEMP")			ins_lemp="true";;
		   "Varnish")			ins_varnish="true";;
                *)
                ;;
        esac
done < results

if [[ "$ins_syncthing" == "true" ]]; 			then install_syncthing;			fi
if [[ "$ins_subsonic" == "true" ]]; 			then install_subsonic;			fi
if [[ "$ins_madsonic" == "true" ]]; 			then install_madsonic;			fi
if [[ "$ins_lazylibrarian" == "true" ]]; 			then install_lazylibrarian;			fi
if [[ "$ins_webmin" == "true" ]]; 			then install_webmin;			fi
if [[ "$ins_pyload" == "true" ]]; 			then install_pyload;			fi
if [[ "$ins_minidlna" == "true" ]]; 			then install_minidlna;			fi
if [[ "$ins_ubooquity" == "true" ]]; 			then install_ubooquity;			fi
if [[ "$ins_jackett" == "true" ]]; 			then install_jackett;			fi
if [[ "$ins_kodi" == "true" ]]; 			then install_kodi;			fi
if [[ "$ins_plex" == "true" ]]; 			then install_plex;			fi
if [[ "$ins_samba" == "true" ]]; 			then install_samba; 			fi
if [[ "$ins_nfs" == "true" ]]; 				then install_nfs; 			fi
if [[ "$ins_tvheadend" == "true" ]]; 			then install_tvheadend; 		fi
if [[ "$ins_headphones" == "true" ]]; 			then install_headphones; 		fi
if [[ "$ins_btsync" == "true" ]]; 			then install_btsync; 			fi
if [[ "$ins_vpn_server" == "true" ]]; 			then install_vpn_server; 		fi
if [[ "$ins_nzbget" == "true" ]]; 			then install_nzbget; 			fi
if [[ "$ins_sabnzbd" == "true" ]];			then install_sabnzbd; 			fi
if [[ "$ins_sickrage" == "true" ]]; 			then install_sickrage; 			fi
if [[ "$ins_sonarr" == "true" ]]; 			then install_sonarr; 			fi
if [[ "$ins_couchpotato" == "true" ]]; 			then install_couchpotato; 		fi
if [[ "$ins_mylar" == "true" ]]; 			then install_mylar; 			fi
if [[ "$ins_htpcmanager" == "true" ]];                 then install_htpcmanager;              fi
if [[ "$ins_rpimonitor" == "true" ]]; 			then install_bmc180; install_tsl2561; install_rpimonitor;  			fi
if [[ "$ins_transmission" == "true" ]];                 then install_transmission;              fi
if [[ "$ins_cherrymusic" == "true" ]];                 then install_cherrymusic;              fi
if [[ "$ins_lemp" == "true" ]];                 	then install_lemp;              fi
if [[ "$ins_varnish" == "true" ]];                 	then install_varnish;              fi
#rm results
