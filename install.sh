#!/bin/bash

# Functions to Reduce Redundancy
confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}


# Setup Config File
config="./config.txt"
if [ ! -e "$config" ]; then
	echo "Creating Config File..."
	touch "$config"
	echo "Config File Created"
else
	echo "Config file already present"
	if confirm "Do you want to reconfigure? (Y/n):"; then
		cat /dev/null > $config
		echo "Config file reset"
	else 
		exit 0
	fi
fi


# Setup Ngrok
if confirm "Do you want to use ngrok? (Y/n):"; then 
	echo "useNgrok=true" >> $config
	echo -n "Please enter your ngrok token: "
	read token
	./ngrok authtoken "$token"
	
	# Setup Pushbullet
	if confirm "Do you want to recieve your ngrok url with pushbullet? (Y/n):"; then 
		echo "usePushbullet=true" >> $config
		echo -n "Please enter your pushbullet access token: "
		read token
		echo "pushbulletToken=$token" >> $config
	else 
		echo "usePushbullet=false" >> $config
	fi
	
else 
	echo "useNgrok=false" >> $config
	echo "usePushbullet=false" >> $config
fi


# Setup Autorun
if confirm "Do you want to autorun? (Y/n):"; then 
	sudo apt-get install -y supervisor
	echo "Supervisor Installed!"
	chmod +x start.sh

	supervisorConf="/etc/supervisor/conf.d/piCamStart.conf"

	if [ ! -e "$supervisorConf" ]; then 
		sudo touch "$supervisorConf"
	else 
		sudo truncate -s 0 "$supervisorConf"
	fi

	echo "[program:PiCam]" | sudo tee --append "$supervisorConf" > /dev/null
	echo "command=/home/pi/Pi-Video-Stream/start.sh"| sudo tee --append "$supervisorConf" > /dev/null
	echo "directory=/home/pi/Pi-Video-Stream" | sudo tee --append "$supervisorConf" > /dev/null
	echo "autostart=true" | sudo tee --append "$supervisorConf" > /dev/null
	echo "startretries=0" | sudo tee --append "$supervisorConf" > /dev/null
	echo "stderr_logfile=./autostart.err.log" | sudo tee --append "$supervisorConf" > /dev/null
	echo "stdout_logfile=./autostart.log" | sudo tee --append "$supervisorConf" > /dev/null
	echo "Start Config Setup!"

	cd /etc/supervisor/conf.d
	sudo service supervisor start
	sudo supervisorctl reread
	sudo supervisorctl reload
	sudo supervisorctl start PiCam
	echo "Started!"
fi



