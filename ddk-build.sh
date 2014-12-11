#!/bin/bash

echo "### Setting up host NAT"

expect -c "spawn ssh $HOST_USERNAME@$HOST_IP
		   expect {
               \"Are you sure you want to continue connecting (yes/no)? \" {
                   send -- \"yes\r\"
                   exp_continue
               }
               \"$HOST_USERNAME@$HOST_IP's password: \" {
                    send -- \"$HOST_PASSWORD\r\"
               }
           }
           interact" <<EOF
# Setup NAT - NB, this _disable the firewall_ - be careful!
echo 1 > /proc/sys/net/ipv4/ip_forward
/sbin/iptables -F INPUT

/sbin/iptables -t nat -A POSTROUTING -o xenbr0 -j MASQUERADE
/sbin/iptables -A INPUT -i xenbr0 -p tcp -m tcp --dport 53 -j ACCEPT
/sbin/iptables -A INPUT -i xenbr0 -p udp -m udp --dport 53 -j ACCEPT
/sbin/iptables -A FORWARD -i xenbr0 -o xenapi -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A FORWARD -i xenapi -o xenbr0 -j ACCEPT
EOF

# TODO: setup ISO SR on host automatically

rpmurl='http://www.uk.xensource.com/carbon/trunk-c7/xe-phase-1-latest/binary-packages/RPMS/domain0/RPMS'
packer_dir='/local/scratch/packer'

echo "### Downloading XenServer RPMs"

mkdir -p rpms
pushd rpms
wget -c -r --no-directories --no-parent -R 'index.html,kernel-debuginfo-*,kernel-modules-*' -A 'kernel-*,xe-guest-utilities-*' "$rpmurl/x86_64/"
wget -c -r --no-directories --no-parent -R 'index.html' -A 'supp-pack-build-*,xcp-python-libs-*,xenserver-ddk-files-*' "$rpmurl/noarch/"
popd

echo "### Starting Packer"

PACKER_LOG=1 exec $packer_dir/packer build ddk.conf 2>&1 &
packer_pid=$!

sigterm_handler() {
	echo "### Caught SIGTERM."
	kill -INT $packer_pid 2>/dev/null
}

trap sigterm_handler TERM
wait $packer_pid

echo "### Done."
