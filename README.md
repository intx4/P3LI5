# P3LI5
Fork of docker_open5gs modified for the P3LI5 project: Enabling Practical Privacy-Preserving Lawful Interception on 5G Core with Lattice-Based Weakly Private Information Retrieval.

## THE PROJECT
P3LI5 is my master thesis project for my master degree at EPFL in collaboration with Armasuisse CYD campus. P3LI5 is a PoC for private lawful interception in 5G Core:

### Abstract
Lawful Interception (LI) is a security process which allows Law Enforcement Agencies (LEAs) to gain insightful data
from mobile networks communication (e.g, network identifiers sent by devices in the network), and it is used for
critical operations like criminal investigations or search and rescue operations. 5G is the new generation standard
for mobile network communication developed by 3GPP. Compared to previous generations (2G, 3G, 4G/LTE), it
offers enhancements in terms of security and users privacy. In particular, 5G security specifications mandate that
all network long-term identifiers sent by users’ devices to the mobile network should be sent in concealed form to
protect users’ privacy against eavesdroppers. On the other hand, this complicates LI operations relying on network
sniffing to capture network identifiers, as LEAs now need collaboration from the Communication Service Providers
(CSPs) to access the identifiers in unconcealed form. 5G LI specifications define a set of interfaces through which
authorized LEAs can recover associations between short-term and long-term identifiers via a query-response
protocol. However, this process creates a new privacy problem, as an untrusted CSPs might now be able to infer
sensitive information about ongoing LEAs operations or about potential suspects identities, by observing the pattern
of resolved identifiers. We thus propose P3LI5 (Practical and Privacy-Preserving Lawful Interception on 5G Core),
a novel Information-Retrieval protocol which allows LEAs to privately query CSPs for identity resolution. P3LI5
exploits a state-of-the-art Private Information Retrieval (PIR) scheme to prevent information leakage. Furthermore,
in order to scale with the massive quantity of information stored by the CSPs and to meet the latency requirements
of mission-critical deployments, P3LI5 enables LEAs to selectively allow a bounded information leakage to reduce
the overhead of the PIR protocol and achieve a speedup of several order of magnitudes. For this, P3LI5 relies on a
generalization of PIR called Weakly-Private Information Retrieval (WPIR). To the best of our knowledge, we present
the first design and open-source implementation of an Information Retrieval scheme which supports selective
information leakage: SparseWPIR. Furthermore, we implement P3LI5 enabling concurrent execution of SparseWPIR
on multiple processors, improving performance over previous works. Finally, we implement a Proof-of-Concept
(PoC) of P3LI5 on a virtualized 5G core by implementing a minimalist LI infrastructure and modifying well known
open-source projects to emulate the Network Core and the Radio Access Network. To the best of our knowledge, this
is the first proposal of a more privacy-preserving LI architecture for the new 5G Core network, which might be of
high interest for Law Enforcement and Intelligence Agencies.

## MODULES
The project builds on several submodules

### P3LI5
This repo, forked from ```docker_open5gs``` -> Docker files to build and run open5gs in a docker

### PIR
[Implementation of a WPIR scheme based on BFV](https://github.com/intx4/pir)

### PYLI5
[Minimal PoC for LI on open5gs core in Python](https://github.com/intx4/pyli5)

### open5gsLI
[Forked from open5gs to enable logging of Association events at AMF](https://github.com/intx4/open5gsLI)

### UERANSIMLI
[Forked from UERANSIM to enable logging of registration traces at UEs](https://github.com/intx4/UERANSIMLI)

#### To update
```git pull --recurse-submodules && git submodule update --remote```

## Tested Setup

Docker host machine

- Ubuntu 20.04

### Remote setup
In case of deployment on a remove VM, it is needed to setup the following SSH tunnel:
```
ssh user@remote_IP -L 8080:127.0.0.1:8080 -L 3000:127.0.0.1:3000 -L 8484:127.0.0.1:8484
```

## Build and Execution Instructions

* Mandatory requirements:
	* [docker-ce](https://docs.docker.com/install/linux/docker-ce/ubuntu)
	* [docker-compose](https://docs.docker.com/compose) (tested with version 1.25.01)

```
git clone --recursive https://github.com/intx4/P3LI5
cd P3LI5
sudo docker build -f base/Dockerfile --no-cache --force-rm -t docker_open5gs .
sudo docker build -f ueransim/Dockerfile --no-cache --force-rm -t docker_ueransim .
sudo docker-compose build
```


### Automatic Deployment 
```
cd ..
./deploy.sh
```
The script will automatically set the environment variables, build the containers from cache, and start them.
Use ```sudo docker ps -aq | xargs sudo docker stop``` for stopping.

#### Warnings
- **It can happen that the ```docker_open5gs_default``` has conflicts with another already allocated pool. In that case you should change the subnet and IPs in ```.env``` and re-build the containers.**
- **Before using the demo, you have to register the subscribers in the Database. See following section**

## Configuration (not needed for standard setup)

For the quick run (eNB/gNB, CN in same docker network), edit only the following parameters in .env as per your setup

```
MCC
MNC
TEST_NETWORK --> Change this only if it clashes with the internal network at your home/office
DOCKER_HOST_IP --> This is the IP address of the host running your docker setup
SGWU_ADVERTISE_IP --> Change this to value of DOCKER_HOST_IP set above only if gNB is not running the same docker network/host
UPF_ADVERTISE_IP --> Change this to value of DOCKER_HOST_IP set above only if gNB is not running the same docker network/host
```

If gNB is NOT running in the same docker network/host as the host running the dockerized Core then follow the below additional steps

Under amf section in docker compose file (docker-compose.yaml, nsa-deploy.yaml, sa-deploy.yaml), uncomment the following part
```
...
    # ports:
    #   - "38412:38412/sctp"
...
```

If deploying in SA mode only (sa-deploy.yaml), then uncomment the following part under upf section
```
...
    # ports:
    #   - "2152:2152/udp"
...
```

## Register a UE information

Open (http://<DOCKER_HOST_IP>:3000) in a web browser, where <DOCKER_HOST_IP> is the IP of the machine/VM running the open5gs containers. Login with following credentials
```
Username : admin
Password : 1423
```

Using Web UI, add a subscriber --> you can login, open the browser console, and inspect the storage for the cookie ```connection.sid``` value and the session ```value```, and use them in the ```populate_db.py``` script. Pass ```-h``` for help
Example (add 1000 users):
```
python3 populate_db.py -c s%3AHSSnq7NdPPWGmWKI0q0lQITV5knUV3tn.p6D8CaL4cKsF%2BtoY2%2BLH2IeRMaUvKeX01BR1kb6P8mU -s '{"clientMaxAge":60000,"csrfToken":"4Aa676KYOez1Ylye3d5jJXid8QSf1SCOKa7RQ=","user":{"_id":"63ee371aedf72c1630020681","roles":["admin"],"username":"admin","__v":0},"authToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Il9pZCI6IjYzZWUzNzFhZWRmNzJjMTYzMDAyMDY4MSIsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyJhZG1pbiJdfSwiaWF0IjoxNjc2NTY2OTY4fQ.mGR4DgDrtrfzZGcLarOK7ubEbI58JwJvJz7RYhd4dbA","expires":1676567028601}' -i 999700154321050 -n 1000

```

## DEMO
The demo consists in a Proof-of-concept for our system. You will impersonate some Law Enforcement trying to privately resolve identifiers from network captures.
The demo will simulate 100 UEs trying to connect to the network. At ```:8080``` you will access a GUI to be used by the law enforcement. You can play around in the GUI by observing the intercepted traffic* and sending resolution request with dynamic level of privacy.

*the traffic is not actually sniffed on the network (e.g using Scapy or tcpdump) due to problem parsing the NAS protocol. Instead we rely on a log watcher deployed on the ```nr_ue``` container which sniffs the logs of UERANSIM.
<div style="display: flex; flex-wrap: wrap; justify-content: center;">
  <div style="width: 50%;">
    <img src="assets/start_p3li5ui.png" style="width: 100%;">
  </div>
  <div style="width: 50%;">
    <img src="assets/midcapture_p3li5ui.png" style="width: 100%;">
  </div>
  <div style="width: 50%;">
    <img src="assets/resolveall_p3li5ui.png" style="width: 100%;">
  </div>
  <div style="width: 50%;">
    <img src="assets/end_p3li5ui.png" style="width: 100%;">
  </div>
</div>

<video width="640" height="480" controls>
  <source src="assets/demo.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>



