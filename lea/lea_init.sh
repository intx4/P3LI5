#!/bin/bash

# BSD 2-Clause License

# Copyright (c) 2020, Intoci Francesco
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.

# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#apt-get install -y npm
#npm install -g n # install node version manager
#n 18.13.0 # download node version
#curl -qL https://www.npmjs.com/install.sh | sh #install latest npm
#/usr/local/bin/npm install -g serve


## install pyli5
#apt-get install -y git config
#git clone --recursive https://github.com/intx4/pyli5
cp -R /mnt/li/pyli5 ~
cp -R /mnt/pir ~
pip3 install -r ~/pyli5/requirements.txt

sed -i 's|LEA_IP|'${LEA_IP}'|g' ~/pyli5/src/pyli5/lea/client.json
sed -i 's|LEA_ID|'${LEA_ID}'|g' ~/pyli5/src/pyli5/lea/client.json
sed -i 's|LEA_HIQR_ADDR|'${LEA_IP}'|g' ~/pyli5/src/pyli5/lea/client.json
sed -i 's|LEA_HIQR_PORT|'${LEA_HIQR_PORT}'|g' ~/pyli5/src/pyli5/lea/client.json
sed -i 's|IQF_HIQR_ADDR|'${ADMF_IP}'|g' ~/pyli5/src/pyli5/lea/client.json
sed -i 's|IQF_HIQR_PORT|'${IQF_HIQR_PORT}'|g' ~/pyli5/src/pyli5/lea/client.json
sed -i 's|GRPC_PORT|'${GRPC_PORT}'|g' ~/pyli5/src/pyli5/lea/client.json
sed -i 's|LEA_INTERCEPTION_PORT|'${LEA_INTERCEPTION_PORT}'|g' ~/pyli5/src/pyli5/lea/client.json
sed -i 's|LEA_UI_PORT|'${LEA_UI_PORT}'|g' ~/pyli5/src/pyli5/lea/client.json

sed -i 's|LEA_IP|'${LEA_IP}'|g' ~/pir/config/client.json
sed -i 's|LEA_ID|'${LEA_ID}'|g' ~/pir/config/client.json
sed -i 's|LEA_HIQR_ADDR|'${LEA_IP}'|g' ~/pir/config/client.json
sed -i 's|LEA_HIQR_PORT|'${LEA_HIQR_PORT}'|g' ~/pir/config/client.json
sed -i 's|IQF_HIQR_ADDR|'${ADMF_IP}'|g' ~/pir/config/client.json
sed -i 's|IQF_HIQR_PORT|'${IQF_HIQR_PORT}'|g' ~/pir/config/client.json
sed -i 's|GRPC_PORT|'${GRPC_PORT}'|g' ~/pir/config/client.json
sed -i 's|LEA_INTERCEPTION_PORT|'${LEA_INTERCEPTION_PORT}'|g' ~/pir/config/client.json
sed -i 's|LEA_UI_PORT|'${LEA_UI_PORT}'|g' ~/pir/config/client.json
#sleep 2 #wait icf
#echo "Starting PIR Client..."
#cd ~/pir && chmod +x pir && ./pir --client --dir ~/pir/config/ &
#echo "Done!"

echo "Starting LEA Python Proxy..."
cd ~/pyli5/src && python3 start_lea.py &
echo "Done!"
echo "Starting PIR client..."
cd root/pir/ && go build && ./pir --client &
echo "Done"
echo "Starting frontend"
cd /root/pir/client/frontend && serve -s build -l $LEA_UI_PORT
#forever sleep
tail -f /dev/null

# Sync docker time
#ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone