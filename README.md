# chef-nginx-test
This repo is created as a part of assignment for an awesome startup which installs/configures nginx , dnsmasq and add entries to network loop .

**TASK**

1. Nginx is configured, running and has the following config in its home.conf file.

``` bash
server_name <NODE_NAME>.XYZ.in <PRIVATE IP > ;
	upstream django-zaya-home {
	# Distribute requests to servers based on client IP. This keeps load
	# balancing fair but consistent per-client. In this instance we're
	# only using one uWGSI worker anyway.
	ip_hash;
	#server unix:///tmp/home-zaya-uwsgi.sock;
	server localhost:8005;
	}
```

2. DNSMasq is running, it exists and has the following config

``` bash
address=/<NODE_NAME>.XYZ.in/<PRIVATE IP >
```

3. Interfaces file exists, network manager is running and the following config is applied to all Client nodes 
```
 
```
#/etc/network/interfaces

#This file describes the network interfaces available on your system
#and how to activate them. For more information, see interfaces(5).

	# The loopback network interface
	auto lo
	iface lo inet loopback

	# The primary network interface
	auto eth0
	iface eth0 inet dhcp
	# Example to keep MAC address between reboots
	#hwaddress ether DE:AD:BE:EF:CA:FE

	# WiFi Example
	auto wlan0
	iface wlan0 inet static
	address 192.168.10.1
	netmask 255.255.255.0
	network 192.168.1.0
	gateway 192.168.1.1
```

**How Repo works**

The chef repo is using [nginx cookbook](https://supermarket.chef.io/cookbooks/nginx) to install nginx. To install dnsmasq using the [dnsmasq](https://supermarket.chef.io/cookbooks/dnsmasq) cookbook .

This chef repo has one cookbook written by name - `custom_book` which does the nginx, dnsmasq and network interface configuration as described in task1 ,task2 and task3 respectively .

**Assumptions :** 

* We have one node server, node workstation and a new node(registered with chef server ) on which chef-client can be run .
* Nginx will be installed one time using the "nginx::default" by adding it either into the runlist or either defined in Role for that node.
* The root user for the system is 'root'
* The normal user for the system who is added to sudoer's list is 'ubuntu'
* Node name do not contains any kind of domain name

**Following are the steps to run the repo "

* Upload the code on chef-server
* Edit node's run list to run "custom_book::default" recipe
* Execute the code in node using `sudo chef-client` and it will run the recipes which are needed.

