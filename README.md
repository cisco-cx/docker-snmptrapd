[![Build Status](https://cloud.drone.io/api/badges/cisco-cx/docker-snmptrapd/status.svg)](https://cloud.drone.io/cisco-cx/docker-snmptrapd)

# docker-snmptrapd

Dockerfile and Docker image for [snmptrapd](http://net-snmp.sourceforge.net/docs/man/snmptrapd.html).

## Usage



```bash
docker pull docker.io/ciscocx/snmptrapd:${DOCKER_TAG}  
```



### Docker Compose example

ref: [docker-compose.yaml](./docker-compose.yaml)

```bash
DOCKER_TAG=${DOCKER_TAG:-0.1.0} docker-compose up
```

## Configuration

The most important configuration files are:

* [filebeat.yml](./filebeat.yml) for output mechanisms
* [snmptrapd.conf](./snmptrapd.conf) for authentication mechanisms

While default configuration files are built into the Docker image, you may bind mount your own files over them.

## Development Notes

### From another container within a docker-compose network

```
docker exec -it of_ubuntu_1 bash
apt-get update && apt-get -y install snmptrapd snmp

snmptrap   -v3 -u user-sha-aes128 -l authPriv -a SHA -A authkey1 -x AES -X privkey1 -e 8000000001020304 2001:3984:3989::10:162        123 1.3.6.1.6.3.1.1.5.1
snmptrap   -v3 -u user-sha-aes128 -l authPriv -a SHA -A authkey1 -x AES -X privkey1 -e 8000000001020304 172.16.238.10:162  123 1.3.6.1.6.3.1.1.5.1
snmpinform -v3 -u user-sha-aes128 -l authPriv -a SHA -A authkey1 -x AES -X privkey1 -e 8000000001020304 2001:3984:3989::10:162        123 1.3.6.1.6.3.1.1.5.1
snmpinform -v3 -u user-sha-aes128 -l authPriv -a SHA -A authkey1 -x AES -X privkey1 -e 8000000001020304 172.16.238.10:162  123 1.3.6.1.6.3.1.1.5.1
```

### From the Host of a docker-compose network

Doesn't seem to work

```
snmptrap   -v3 -u user-sha-aes128 -l authPriv -a SHA -A authkey1 -x AES -X privkey1 -e 8000000001020304 ::1:1162        123 1.3.6.1.6.3.1.1.5.1
snmptrap   -v3 -u user-sha-aes128 -l authPriv -a SHA -A authkey1 -x AES -X privkey1 -e 8000000001020304 127.0.0.1:1162  123 1.3.6.1.6.3.1.1.5.1
snmpinform -v3 -u user-sha-aes128 -l authPriv -a SHA -A authkey1 -x AES -X privkey1 -e 8000000001020304 ::1:1162        123 1.3.6.1.6.3.1.1.5.1
snmpinform -v3 -u user-sha-aes128 -l authPriv -a SHA -A authkey1 -x AES -X privkey1 -e 8000000001020304 127.0.0.1:1162  123 1.3.6.1.6.3.1.1.5.1
```

## From Localhost of the snmptrapd container itself

Haven't tried, because it worked from another container

```
docker exec -it of_snmptrapd_1 bash

snmptrap   -v3 -u user-sha-aes128 -l authPriv -a SHA -A authkey1 -x AES -X privkey1 -e 8000000001020304 ::1:162        123 1.3.6.1.6.3.1.1.5.1
snmptrap   -v3 -u user-sha-aes128 -l authPriv -a SHA -A authkey1 -x AES -X privkey1 -e 8000000001020304 127.0.0.1:162  123 1.3.6.1.6.3.1.1.5.1
snmpinform -v3 -u user-sha-aes128 -l authPriv -a SHA -A authkey1 -x AES -X privkey1 -e 8000000001020304 ::1:162        123 1.3.6.1.6.3.1.1.5.1
snmpinform -v3 -u user-sha-aes128 -l authPriv -a SHA -A authkey1 -x AES -X privkey1 -e 8000000001020304 127.0.0.1:162  123 1.3.6.1.6.3.1.1.5.1
```
