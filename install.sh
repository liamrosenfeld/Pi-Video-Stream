#!/bin/bash

echo -n "Enter your ngrok token and press [ENTER]: "
read token
./ngrok authtoken $token
