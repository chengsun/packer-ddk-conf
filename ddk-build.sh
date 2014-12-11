#!/bin/bash

# TODO: setup ISO SR on host automatically

rpmurl='http://www.uk.xensource.com/carbon/trunk-c7/xe-phase-1-latest/binary-packages/RPMS/domain0/RPMS'
x86_64_rpms='(kernel|kernel-devel|kernel-headers|xe-guest-utilities|xe-guest-utilities-xenstore)'
noarch_rpms='(supp-pack-build|xcp-python-libs|xenserver-ddk-files)'
packer_dir='/root/packer'

mkdir -p rpms
pushd rpms
wget -r --no-directories --no-parent -R index.html --accept-regex "$x86_64_rpms-[0-9.\\-]*.x86_64.rpm" $rpmurl/x86_64/
wget -r --no-directories --no-parent -R index.html --accept-regex "$noarch_rpms-[0-9.\\-]*.noarch.rpm" $rpmurl/noarch/
popd

$packer_dir/packer build ddk.conf
