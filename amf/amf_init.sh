#!/bin/bash

# BSD 2-Clause License

# Copyright (c) 2020, Supreeth Herle
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

cp /mnt/amf/amf.yaml install/etc/open5gs
sed -i 's|AMF_IP|'$AMF_IP'|g' install/etc/open5gs/amf.yaml
sed -i 's|SCP_IP|'$SCP_IP'|g' install/etc/open5gs/amf.yaml
sed -i 's|MNC|'$MNC'|g' install/etc/open5gs/amf.yaml
sed -i 's|MCC|'$MCC'|g' install/etc/open5gs/amf.yaml

## install pyli5
#apt-get install -y git 
#git clone --recursive https://github.com/intx4/pyli5
cp -R /mnt/li/pyli5 ~
pip3 install -r ~/pyli5/requirements.txt

chmod o+r $IEF_POI_LOG_PATH
sed -i 's|IEF_NE_ID|'${IEF_NE_ID}'|g' ~/pyli5/src/pyli5/ief/ief.json
sed -i 's|IEF_NE_IP|'${AMF_IP}'|g' ~/pyli5/src/pyli5/ief/ief.json
sed -i 's|IEF_XEM_PORT|'${IEF_XEM_PORT}'|g' ~/pyli5/src/pyli5/ief/ief.json
sed -i 's|IEF_XEM_URL|'${IEF_XEM_URL}'|g' ~/pyli5/src/pyli5/ief/ief.json
sed -i 's|IEF_POI_LOG_PATH|'${IEF_POI_LOG_PATH}'|g' ~/pyli5/src/pyli5/ief/ief.json

cd ~/pyli5/src/ && python3 start_ief.py &


# Sync docker time
#ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
