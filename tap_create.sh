# Create a bridge named br0
brctl addbr br0
# Add eth0 interface to bridge
brctl addif br0 eth0
# Create tap interface.
tunctl -t tap0 -u `whoami`
tunctl -t tap0 -g netdev
# Add tap0 interface to bridge.
brctl addif br0 tap0
# Check/Bring up all interfaces.
ifconfig eth0 up
ifconfig tap0 up
ifconfig br0 up
# Check if bridge is set properly.
brctl show
# Assign IP address to bridge 'br0'.
#dhclient -v br0 &
echo KERNEL=="tun", GROUP="netdev", MODE="0660", \
  OPTIONS+="static_node=net/tun" > /etc/udev/rules.d/zzz_net_tun.rules
chgrp netdev /dev/net/tun
chmod 660 /dev/net/tun
ip tuntap add dev tap0 mode tap group netdev
tunctl -t tap0 -u $1
echo set up tap interface for user $1
