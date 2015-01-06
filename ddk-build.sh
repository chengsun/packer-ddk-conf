#!/bin/bash

rpmurl='http://www.uk.xensource.com/carbon/trunk-c7/xe-phase-1-latest/binary-packages/RPMS/domain0/RPMS'
packer_dir='/local/scratch/packer'

echo "### Downloading XenServer RPMs"

[ -d rpms ] && rm -rf rpms
mkdir -p rpms
pushd rpms
wget -c -r --no-directories --no-parent -R 'index.html,kernel-debuginfo-*,kernel-modules-*' -A 'kernel-*,xe-guest-utilities-*' "$rpmurl/x86_64/"
wget -c -r --no-directories --no-parent -R 'index.html' -A 'supp-pack-build-*,xcp-python-libs-*,xenserver-ddk-files-*' "$rpmurl/noarch/"
popd

echo "### Starting Packer"

PACKER_LOG=1 $packer_dir/packer build ddk.conf 2>&1 &
packer_pid=$!

exit_handler() {
	kill -INT $packer_pid 2>/dev/null && echo "### Killed Packer"
}

trap exit_handler EXIT
wait $packer_pid
ret=$?

echo "### Done."
exit $ret
