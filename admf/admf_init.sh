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

apt-get install lsof
apt-get install net-tools


## install pyli5
#apt-get install -y git 
#git clone --recursive https://github.com/intx4/pyli5
cp -R /mnt/li/pyli5 ~
pip3 install -r ~/pyli5/requirements.txt
sed -i 's|LIPF_H1_ADDRESS|'${ADMF_IP}'|g' ~/pyli5/src/pyli5/admf/admf.json
sed -i 's|LIPF_H1_PORT|'${LIPF_H1_PORT}'|g' ~/pyli5/src/pyli5/admf/admf.json
sed -i 's|ADMF_ID|'${ADMF_ID}'|g' ~/pyli5/src/pyli5/admf/admf.json
sed -i 's|IEF_XEM_ADDR|'${AMF_IP}'|g' ~/pyli5/src/pyli5/admf/admf.json
sed -i 's|IEF_XEM_PORT|'${IEF_XEM_PORT}'|g' ~/pyli5/src/pyli5/admf/admf.json
sed -i 's|IEF_XEM_URL|'${IEF_XEM_URL}'|g' ~/pyli5/src/pyli5/admf/admf.json
sed -i 's|IEF_XEM_ID|'${IEF_XEM_ID}'|g' ~/pyli5/src/pyli5/admf/admf.json
sed -i 's|ICF_XER_ADDR|'${ICF_IP}'|g' ~/pyli5/src/pyli5/admf/admf.json
sed -i 's|ICF_XER_PORT|'${ICF_XER_PORT}'|g' ~/pyli5/src/pyli5/admf/admf.json
sed -i 's|IQF_HIQR_ADDR|'${ADMF_IP}'|g' ~/pyli5/src/pyli5/admf/admf.json
sed -i 's|IQF_HIQR_PORT|'${IQF_HIQR_PORT}'|g' ~/pyli5/src/pyli5/admf/admf.json
sed -i 's|ICF_XQR_ADDR|'${ICF_IP}'|g' ~/pyli5/src/pyli5/admf/admf.json
sed -i 's|ICF_XQR_PORT|'${ICF_XQR_PORT}'|g' ~/pyli5/src/pyli5/admf/admf.json

echo "Starting ADMF application..."
cd ~/pyli5/src/ && python3 start_admf.py &
echo "Done!"
tail -f /dev/null

# Sync docker time
#ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone