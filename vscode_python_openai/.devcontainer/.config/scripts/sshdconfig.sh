#!/bin/bash
#
# try to secure OpenSSH... a bit
#
# comotion@krutt.org

sshver=$(sshd -v 2>&1 | grep -v unknown | head -n 1)
case $sshver in
    OpenSSH_*)
        v=$(echo $sshver | cut -f 2 -d_ | cut -f 1 -d ' ')
        ;;
    *)
        v=UNKNOWN
esac

if [ "$v" = "UNKNOWN" ]
then
    echo "this script currently only supports OpenSSH. Email $sshver to comotion@krutt.org and we shall work it in" 1>&2
    exit 1
fi


cd /etc/ssh
cp sshd_config sshd_config.$$

# these are mostly supported
sed -i \
-e 's/PermitRootLogin *yes.*/PermitRootLogin no/' \
-e 's/UsePrivilegeSeparation *no.*/UsePrivilegeSeparation yes/' \
-e 's/StrictModes *no.*/StrictModes yes/' \
-e 's/IgnoreRhosts *no.*/IgnoreRhosts yes/' \
-e 's/PermitEmptyPasswords *yes.*/PermitEmptyPasswords no/' \
-e 's/^\(HostKey .*ssh_host_dsa_key\)/#\1/' \
sshd_config

# should be this but curve25519 is not supported everywhere
kexup='curve25519-sha256@libssh.org'

kex='diffie-hellman-group-exchange-sha256'

ciphers='aes256-ctr,aes192-ctr,aes128-ctr'
ciphersup='chacha20-poly1305@openssh.com'
macs='hmac-sha2-512,hmac-sha2-256,hmac-ripemd160'
macsup='hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-ripemd160-etm@openssh.com,umac-128-etm@openssh.com'
macsend='umac-128@openssh.com'




if [[ "$v" < "5.9" ]]
then
    echo "shitty old SSH $v detected, please upgrade!"
elif [[ "$v" > "6.4" ]]
then
    ciphers="$ciphersup,$ciphers"
    macs="$macsup,$macs,$macsend"
    kex="$kexup,$kex"
fi



cd /etc/ssh
if grep -q ^KexAlgorithms sshd_config
then
   sed -i "s/^KexAlgorithms .*/KexAlgorithms $kex/" sshd_config
else
    echo "KexAlgorithms $kex" >> sshd_config
fi
if grep -q ^Ciphers sshd_config
then
   sed -i "s/^Ciphers .*/Ciphers $ciphers/" sshd_config
else
    echo "Ciphers $ciphers" >> sshd_config
fi
if grep -q ^MACs sshd_config
then
   sed -i "s/^MACs .*/MACs $macs/" sshd_config
else
    echo "MACs $macs" >> sshd_config
fi

mkdir -p broken
mv ssh_host_dsa_key* ssh_host_ecdsa_key* ssh_host_key* broken
# create broken links to force SSH not to regenerate broken keys
ln -s ssh_host_ecdsa_key ssh_host_ecdsa_key
ln -s ssh_host_dsa_key ssh_host_dsa_key
ln -s ssh_host_key ssh_host_key

# remove weak moduli
[ -f broken/moduli ] || cp moduli broken
awk '{ if ($5 > 2000){ print } }' moduli > /tmp/moduli
mv /tmp/moduli moduli

if ! sshd -t
then
    echo "SSHD config failed, reverting to untouched one. Please investigate sshd_config.$$.new"
    cp sshd_config sshd_config.$$.new
    mv sshd_config.$$ sshd_config
else
    /etc/init.d/ssh reload
    echo "SSH reloaded. Please TEST your SSHD by making a new connection BEFORE disconnecting this session!" >&2
fi

echo
echo "For better client security, configure your ssh_config / .ssh/config like so:"
echo "Host *"
echo "Ciphers aes256-gcm@openssh.com,aes128-gcm@openssh.com,chacha20-poly1305@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr"
echo "MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512"
echo "KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256"



# controversial options:
# X11Forwarding
# AllowTCPForwarding
# AllowUsers
# AllowGroups remote
# ChrootDirectory
#
# Define a remote group and use it for allowed users.
