#netns-vrf - a linux netns wrapper
---------------------------------

##install

* required: ruby, linux 3.0.2+

* clone the repo with: git clone https://github.com/nopedial/netns-vrf

* build the gem with: gem build netns-vrf.gemspec

* install the gem with: gem install ./netns-vrf-0.0.2.gem

* run with: netns-vrf

##howto

1. create a VRF:

	`root@chemdawg:~# netns-vrf show all
	root@chemdawg:~# netns-vrf create public-inet
	+ vrf created: public-inet
	root@chemdawg:~# netns-vrf show all
	display vrf: public-inet
	--------------------------
	15: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN 
    	link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    	inet 127.0.0.1/8 scope host lo
    	inet6 ::1/128 scope host 
       	   valid_lft forever preferred_lft forever
	--------------------------
	
	root@chemdawg:~#`

2. add interface to VRF:

	`root@chemdawg:~# netns-vrf interface push eth0.2333 public-inet
	+ interface eth0.2333 correctly added to vrf: public-inet
	root@chemdawg:~# netns-vrf show all
	display vrf: public-inet
	--------------------------
	13: eth0.2333@if2: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UP 
    	link/ether b8:27:eb:2f:a3:b9 brd ff:ff:ff:ff:ff:ff
    	inet6 fe80::ba27:ebff:fe2f:a3b9/64 scope link 
           valid_lft forever preferred_lft forever
	15: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN 
    	link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    	inet 127.0.0.1/8 scope host lo
    	inet6 ::1/128 scope host 
       	   valid_lft forever preferred_lft forever
	--------------------------
	
	root@chemdawg:~#` 

3. add ip address to VRF interface:

	`root@chemdawg:~# netns-vrf ip address inet add 10.23.32.2/30 eth0.2333 public-inet
	+ IP address 10.23.32.2/30 correctly added to interface eth0.2333 : VRF public-inet
	root@chemdawg:~# netns-vrf show all
	display vrf: public-inet
	--------------------------
	13: eth0.2333@if2: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UP 
    	link/ether b8:27:eb:2f:a3:b9 brd ff:ff:ff:ff:ff:ff
    	inet 10.23.32.2/30 scope global eth0.2333
    	inet6 fe80::ba27:ebff:fe2f:a3b9/64 scope link 
      	   valid_lft forever preferred_lft forever
	15: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN 
    	link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    	inet 127.0.0.1/8 scope host lo
    	inet6 ::1/128 scope host 
       	   valid_lft forever preferred_lft forever
	--------------------------	
	
	root@chemdawg:~#`

4. add route to VRF:

	`root@chemdawg:~# netns-vrf ip route inet add 10.2.2.0/24 10.23.32.1 eth0.2333 public-inet
	+ route to 10.2.2.0/24 added - nexthop: 10.23.32.1 - iface: eth0.2333 - VRF public-inet
	root@chemdawg:~# netns-vrf ip route inet show public-inet
	display vrf public-inet routing table:

	10.2.2.0/24 via 10.23.32.1 dev eth0.2333 
	10.23.32.0/30 dev eth0.2333  proto kernel  scope link  src 10.23.32.2 
	
	
	root@chemdawg:~#`

