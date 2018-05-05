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

writeToConfig() {
	# $1 = Find and $2 = Replace
	sed -i "s/$1/$2/g" $config
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
else 
	echo "useNgrok=false" >> $config
fi
    

