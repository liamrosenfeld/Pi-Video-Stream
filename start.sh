#!/bin/bash

config="./config.txt"

# Start Flask App
python app.py &

# Start Ngrok
temp=$(awk '/^useNgrok/{print $NF}' $config)
IFS="=" read name useNgrok <<< "$temp"
if [[ "$useNgrok" == "true" ]]; then
	./ngrok http 8080 &
fi

# Send Pushbullet
temp=$(awk '/^usePushbullet/{print $NF}' $config)
IFS="=" read name usePush <<< "$temp"
if [[ "$usePush" == "true" ]]; then
	while : ; do
		url=$(curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"https:..([^"]*).*/\1/p')
		if [[ "$url" = *"ngrok.io"* ]]; then
			temp=$(awk '/^pushbulletToken/{print $NF}' $config)
			IFS="=" read name token <<< "$temp"
			curl --silent -u "$token": -d type="note" -d body="$url" -d title="Pi Video Stream URL" 'https://api.pushbullet.com/v2/pushes'
			break
		fi
	done
fi
