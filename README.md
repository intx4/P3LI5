# P3LI5
Enabling Practical and Privacy-Preserving Lawful Interception on 5G SA Core with Lattice-Based Weakly Private Information Retrieval

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

## Tested Setup

Docker host machine

- Ubuntu 20.04

## Build and Execution Instructions

* Mandatory requirements:
	* [docker-ce](https://docs.docker.com/install/linux/docker-ce/ubuntu)
	* [docker-compose](https://docs.docker.com/compose)


```
git clone https://github.com/intx4/p3li5
cd docker_open5gs/base
docker build --no-cache --force-rm -t docker_open5gs .

cd ../ueransim
docker build --no-cache --force-rm -t docker_ueransim .
```

### Build and Run using docker-compose

```
cd ..
set -a
source .env
# Build remaining services, use cached previously built services
docker-compose build
docker-compose up

# UERANSIM gNB
docker-compose -f nr-gnb.yaml up -d && docker attach nr_gnb

# UERANSIM NR-UE
docker-compose -f nr-ue.yaml up -d && docker attach nr_ue
```

## Configuration

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

## Not supported
- IPv6 usage in Docker


