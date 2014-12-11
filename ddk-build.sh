#!/bin/bash

# TODO: setup ISO SR on host automatically

rpmurl='http://www.uk.xensource.com/carbon/trunk-c7/xe-phase-1-latest/binary-packages/RPMS/domain0/RPMS'
packer_dir='/root/packer'

mkdir -p rpms
pushd rpms
wget -r --no-directories --no-parent -R 'index.html,kernel-debuginfo-*' -A 'kernel-*,xe-guest-utilities-*' "$rpmurl/x86_64/"
wget -r --no-directories --no-parent -R 'index.html' -A 'supp-pack-build-*,xcp-python-libs-*,xenserver-ddk-files-*' "$rpmurl/noarch/"
popd

$packer_dir/packer build ddk.conf
