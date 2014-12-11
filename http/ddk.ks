install
cdrom
lang en_US.UTF-8
keyboard us
unsupported_hardware
network --bootproto=dhcp
rootpw --iscrypted $1$DIlig7gp$FuhFdeHj.R1VrEzZsI4uo0
firewall --disabled
authconfig --enableshadow --passalgo=sha512
selinux --permissive
timezone UTC
bootloader --location=mbr
text
skipx
zerombr
clearpart --all --initlabel
autopart
auth  --useshadow  --enablemd5
firstboot --disabled
poweroff

%packages
@Core
%end

%post
yum -y update
yum -y groupinstall "Development Tools"
yum -y install rpm-build mkisofs
%end
