#!/bin/bash

# Überprüfe, ob UFW installiert ist
if ! command -v ufw &> /dev/null; then
    echo "UFW ist nicht installiert. Installiere es mit 'sudo apt install ufw' und versuche es erneut."
    exit 1
fi

# Überprüfe den Status der UFW
ufw_status=$(ufw status | grep Status | awk '{print $2}')

if [ "$ufw_status" != "active" ]; then
    echo "UFW ist nicht aktiviert. Aktiviere es mit 'sudo ufw enable' und versuche es erneut."
    exit 1
fi

# Überprüfe, ob der Port 21 bereits geöffnet ist
if ufw status | grep 21/tcp | grep ALLOW &> /dev/null; then
    echo "Port 21 ist bereits freigegeben."
    exit 0
fi

# Freigabe von Port 21 für vsftpd
ufw allow 21/tcp

echo "Port 21 für vsftpd wurde erfolgreich freigegeben."
