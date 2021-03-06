# Create a bridge interface
ip link add br0 type bridge

# Activate the bridge interface
ip link set dev br0 up

# Set IP address to the Ethernet interface
ip addr add 10.1.1.$(echo $HOSTNAME | sed 's|.*-||')/24 dev eth0

# Create the VXLAN interface according to RFC 7348 (STATIC)
ip link add name vxlan10 type vxlan id 10 dev eth0 remote 10.1.1.$(echo $HOSTNAME | sed 's|.*-||' | awk '{ if ($0 == 1) {print 2} else {print 1}}') local 10.1.1.$(echo $HOSTNAME | sed 's|.*-||') dstport 4789

# Set IP address to the VXLAN interface
ip addr add 20.1.1.$(echo $HOSTNAME | sed 's|.*-||')/24 dev vxlan10

# Add eth1 to bridge interface
brctl addif br0 eth1

# Add vxlan10 to bridge interface
brctl addif br0 vxlan10

ip link set dev vxlan10 up

tail -f /dev/null
