#!/bin/bash
#################################################
# AutoRipper Installer							#
# Written by Steve Tomaszewski					#
# Github: https://github.com/sk8r776/AutoRipper	#
# Version: 0.1 (Alpha Build)                    #
#################################################
echo "Welcome to the auto ripper installer"

# Check for root acces
if [ "$(id -u)" != "0" ]; then
   echo "Please run installer as root" 1>&2
   exit 1
fi

# we need the ripping user login for the MIME autorun system
echo "Please enter username: "
read script_user
echo "Username to be installed under: $script_user"
#if [[ $REPLY =~ ^[Yy]$ ]]
#then
#	
#else
#	exit 1
#fi

# Ask if we want to install CD Ripping
read -p "Install auto CD ripping?" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	installcdrip="1"
else
	installcdrip="0"
fi

# Ask if we want to install DVD Ripping
read -p "Install auto DVD ripping?" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	installdvdrip="1"
else
	installdvdrip="0"
fi

# Ask if we want to install BR Ripping
read -p "Install auto Bluray ripping?" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	installbrrip="1"
else
	installbrrip="0"
fi

# CD Ripping install routine
if [ $installcdrip -eq 1 ]
then
	echo "Updating Aptitude and Installing ABCDE."
	echo "Updating Aptitude and Installing ABCDE." >> install.log
	read -p "Accept any EULAs during this process. Press [Enter] key to continue..."
	sudo apt-get -q update &>> install.log
    sudo apt-get -y install abcde &>> install.log
    sudo cp MIMEs/ripcd.desktop /usr/share/applications/ripcd.desktop
	echo "Auto CD Ripping Installed!"
	echo "Please change the default application for CDs in"
	echo "System Settings -> Details -> Removable Media"
	echo "Change CD audio to Rip CD"
else
	echo "CD Ripping not selected for install." >> install.log
fi

# DVD Ripping install routine
if [ $installdvdrip -eq 1 ]
then
	echo "Updating Aptitude and Installing DVDBackup."
	echo "Updating Aptitude and Installing DVDBackup." >> install.log
	read -p "Accept any EULAs during this process. Press [Enter] key to continue..."
	sudo add-apt-repository -y ppa:stebbins/handbrake-snapshots &>> install.log
	echo 'deb http://download.videolan.org/pub/debian/stable/ /' | sudo sh -c 'cat >> /etc/apt/sources.list' &>> install.log
	echo 'deb-src http://download.videolan.org/pub/debian/stable/ /' | sudo sh -c 'cat >> /etc/apt/sources.list' &>> install.log
	wget -O - http://download.videolan.org/pub/debian/videolan-apt.asc|sudo apt-key add - &>> install.log
	sudo apt-get -q update &>> install.log
   	sudo apt-get -y install dvdbackup git libtool handbrake-cli handbrake-gtk libdvdcss2 &>> install.log
   	sudo cp Scripts/ripdvd /usr/bin/ripdvd
   	sudo chmod +x /usr/bin/ripdvd
   	sudo cp MIMEs/ripdvd.desktop /usr/share/applications/ripdvd.desktop
	echo "Auto DVD Ripping Installed!"
	echo "Please change the default application for DVDs in"
	echo "System Settings -> Details -> Removable Media"
	echo "Change DVD Video to Rip DVD"
else
	echo "DVD Ripping not selected for install." >> install.log
fi

# BR Ripping install routine
#if [ $installbrrip -eq "true" ]
#then
#	echo "Updating Aptitude and Installing ABCDE."
#	echo "Updating Aptitude and Installing ABCDE." >> install.log
#	sudo apt-get -q update &>> install.log
#    sudo apt-get -y install abcde &>> install.log
#    cp MIMEs/ripcd.desktop /usr/share/applications/ripcd.desktop
#    if [ -f /home/$script_user/.local/share/applications/mimeapps.list]
#    then
#    	echo "Existing mimeapps.list found. Moving to .bak file." >> install.log
#    	mv /home/$script_user/.local/share/applications/mimeapps.list /home/$script_user/.local/share/applications/mimeapps.list.bak
#		cp MIMEs/mimeapps.list /home/$script_user/.local/share/applications/
#	else
#		echo "Copying mimeapps.list." >> install.log
#		cp MIMEs/mimeapps.list /home/$script_user/.local/share/applications/
#	fi
#	echo "Auto CD Ripping Installed!"
#	echo "Please change the default application for CDs in"
#	echo "System Settings -> Details -> Removable Media"
#	echo "Change CD audio to Rip CD"
#else
#fi

echo "Existing mimeapps.list found. Moving to .bak file." &>> install.log
echo "Existing mimeapps.list found. Missing file error is OK here!"
echo "Existing mimeapps.list found. Missing file error is OK here!" &>> install.log
mv /home/$script_user/.local/share/applications/mimeapps.list /home/$script_user/.local/share/applications/mimeapps.list.bak
mkdir -p /home/$script_user/.local/share/applications/
cp MIMEs/mimeapps.list /home/$script_user/.local/share/applications/mimeapps.list