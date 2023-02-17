#!/bin/bash

############## PROGRESS BAR #################
# from https://stackoverflow.com/questions/238073/how-to-add-a-progress-bar-to-a-shell-script
# 1. Create ProgressBar function
# 1.1 Input is currentState($1) and totalState($2)
function ProgressBar {
# Process data
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
# Build progressbar string lengths
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")

# 1.2 Build progressbar strings and print the ProgressBar line
# 1.2.1 Output example:                           
# 1.2.1.1 Progress : [########################################] 100%
printf "\r[${_fill// /#}${_empty// /-}] ${_progress}%%"
}

# Variables
_start=1

# This accounts as the "totalState" variable for the ProgressBar function
_end=60

mkdir var > /dev/null 2>&1
mkdir var/log > /dev/null 2>&1
rm var/log/boot.log
touch var/log/boot.log

#sudo docker system prune -f
sudo docker-compose logs -f -t >> var/log/boot.log &
echo "Building Core Containers...(cached)"
sudo docker-compose build
echo "Deploying Core Containers..."
sudo docker-compose up --force-recreate -d 2>&1 | tee var/log/boot.log
echo "Estimated time to complete: ${_end} seconds"
for number in $(seq ${_start} ${_end})
do
    sleep 1
    ProgressBar ${number} ${_end}
done
echo "Ok"
echo "Deploying RAN Containers..."
sudo docker-compose -f nr-gnb.yaml up --force-recreate -d 2>&1 | tee var/log/boot.log
sleep 2
sudo docker-compose -f nr-ue.yaml up -d --force-recreate -d 2>&1 | tee var/log/boot.log
_end=30
echo "Estimated time to complete: ${_end} seconds"
for number in $(seq ${_start} ${_end})
do
    sleep 1
    ProgressBar ${number} ${_end}
done
echo "Ok"
echo "[*] Web UI: "
echo "    --> http://localhost:${LEA_UI_PORT}"
