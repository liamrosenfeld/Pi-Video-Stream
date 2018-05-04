#!/bin/bash

# Setup Flask App
python app.py &

# Set Up Ngrok
./ngrok http 8080 &
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"https:..([^"]*).*/\1/p'
sleep 10