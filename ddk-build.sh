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

PACKER_LOG=1 exec $packer_dir/packer build ddk.json 2>&1
