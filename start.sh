#!/bin/bash

if ! grep 'dummy' /etc/passwd; then
    echo '[+] Making dummy user for SSH tunneling'
    useradd -m dummy
fi


if [ ! -f /home/dummy/.ssh/id_rsa ]; then
    echo '[+] Generating SSH keys for dummy user'
    ssh-keygen -t rsa -b 4096 -f dummy_key -N ""
    mkdir /home/dummy/.ssh/

    sed -i 's/\w\+@/dummy@/g' dummy_key
    mv dummy_key /home/dummy/.ssh/id_rsa
    chown dummy /home/dummy/.ssh/id_rsa

    sed -i 's/\w\+@/dummy@/g' dummy_key.pub
    mv dummy_key.pub /home/dummy/.ssh/id_rsa.pub
    chown dummy /home/dummy/.ssh/id_rsa.pub
fi


echo '[+] Make sure root owns get_probe_keys.py & the web root dir'
chown root ${INSTALLDIR}/get_probe_keys.py
chown root ${INSTALLDIR}


if ! grep 'Match User dummy' /etc/ssh/sshd_config; then
    echo '[+] Adding sshd_config entry for dummy user'
cat << EOF >> /etc/ssh/sshd_config
Match User dummy
    ForceCommand /bin/false
    AuthorizedKeysCommand ${INSTALLDIR}/get_probe_keys.py
    AuthorizedKeysCommandUser nobody
EOF
fi

echo [+] Start the server
${INSTALLDIR}/bin/gunicorn probe_website:app -w 4 -b 0.0.0.0:5000
#${INSTALLDIR}/bin/flask run --host=0.0.0.0
