#!/bin/bash

# TODO: setup ISO SR on host automatically

rpmurl='http://www.uk.xensource.com/carbon/trunk-c7/xe-phase-1-latest/binary-packages/RPMS/domain0/RPMS'
packer_dir='/local/scratch/packer'

mkdir -p rpms
pushd rpms
wget -c -r --no-directories --no-parent -R 'index.html,kernel-debuginfo-*,kernel-modules-*' -A 'kernel-*,xe-guest-utilities-*' "$rpmurl/x86_64/"
wget -c -r --no-directories --no-parent -R 'index.html' -A 'supp-pack-build-*,xcp-python-libs-*,xenserver-ddk-files-*' "$rpmurl/noarch/"
popd

PACKER_LOG=1 exec $packer_dir/packer build ddk.conf 2>&1 &
packer_pid=$!

sigterm_handler() {
	echo "Caught SIGTERM."
	kill -INT $packer_pid 2>/dev/null
}

trap sigterm_handler TERM
wait $packer_pid
