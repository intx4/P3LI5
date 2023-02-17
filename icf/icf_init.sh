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



## install pyli5
#apt-get install -y git 
#cp -R /mnt/li/pyli5 ~
#cp -R /mnt/pir ~
#pip3 install -r ~/pyli5/requirements.txt


sed -i 's|ICF_XER_ADDR|'${ICF_IP}'|g' ~/pyli5/src/pyli5/icf/server.json
sed -i 's|ICF_XER_PORT|'${ICF_XER_PORT}'|g' ~/pyli5/src/pyli5/icf/server.json
sed -i 's|ICF_XQR_ADDR|'${ICF_IP}'|g' ~/pyli5/src/pyli5/icf/server.json
sed -i 's|ICF_XQR_PORT|'${ICF_XQR_PORT}'|g' ~/pyli5/src/pyli5/icf/server.json
sed -i 's|GRPC_PORT|'${GRPC_PORT}'|g' ~/pyli5/src/pyli5/icf/server.json

sed -i 's|ICF_XER_ADDR|'${ICF_IP}'|g' ~/pir/config/server.json
sed -i 's|ICF_XER_PORT|'${ICF_XER_PORT}'|g' ~/pir/config/server.json
sed -i 's|ICF_XQR_ADDR|'${ICF_IP}'|g' ~/pir/config/server.json
sed -i 's|ICF_XQR_PORT|'${ICF_XQR_PORT}'|g' ~/pir/config/server.json
sed -i 's|GRPC_PORT|'${GRPC_PORT}'|g' ~/pir/config/server.json

echo "Stating ICF PIR server..."
cd ~/pir &&  chmod +x pir && go build && ./pir --server --dir ~/pir/config/ & #might crash if run as a background process
echo "Done!"
echo "Starting ICF Python proxy..."
cd ~/pyli5/src && python3 start_icf.py
echo "Done!"
tail -f /dev/null

# Sync docker time
#ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone