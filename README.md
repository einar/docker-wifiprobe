==========

### What it is

This is a GUI/controller/website for the WiFi probe system. It has been created from/using
instructions and code from UNINETT: "https://github.com/UNINETT/probe-website"

### HowTo 

Basically you need to clone the git repository; build the container & then run it with the
appropriate environments and volumes supplied.

* Install docker and git (if you havent already)  
* Create a dummy user for wifiprobe to use (unless you want to generate new ssh-keys every restart)  
``` useradd -m dummy ```
* Create installation directory locally for the wifiprobeserver (for persistence of database) 
``` mkdir -p /opt/probe-website ```
* Clone this repository  
``` git clone https://github.com/einar/docker-wifiprobe ```  
* Build a local image that you can use with docker run (or docker-compose)  
``` docker build -t wifiprobe-server . ```  
* 1.1 With wifiprobe-server built, either create a docker-compose.yml file (like the following example):  
~~~~
---
version: '2'
services:

   docker-wifiprobe:
     image: 'docker-wifiprobe'
     volumes:
       - /home/dummy:/home/dummy
       - /etc/ssh:/etc/ssh
     environment:
       - "INSTALLDIR=/opt/probe-website"
     container_name: postgres
     ports:
       - '5000:5000'

~~~~
* 1.2 ...or simply run the server from the command line using docker run like so: 
``` docker run -v /home/dummy:/home/dummy -v /etc/ssh:/etc/ssh -p 5000:5000 wifiprobe-server  ```


