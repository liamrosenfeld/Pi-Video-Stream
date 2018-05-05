#!/bin/bash

config="./config.txt"

# Start Flask App
python app.py &

# Start Ngrok
temp=$(awk '/^useNgrok/{print $NF}' $config)
IFS="=" read name value <<< "$temp"
if [[ "$value" == "true" ]]; then
	./ngrok http 8080 &
	url = $(curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"https:..([^"]*).*/\1/p')
fi
