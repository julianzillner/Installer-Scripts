#!/bin/bash

# Überprüfe, ob das Skript mit Root-Rechten ausgeführt wird
if [ "$EUID" -ne 0 ]; then
  echo "Dieses Skript muss mit Root-Rechten ausgeführt werden. Bitte als Root oder mit sudo ausführen."
  exit 1
fi

# Aktualisiere die Paketliste
apt update

# Installiere Apache und PHP
apt install -y apache2 php libapache2-mod-php

# Installiere vsftpd (FTP-Server)
apt install -y vsftpd

# Konfiguriere vsftpd
echo "local_enable=YES" >> /etc/vsftpd.conf
echo "write_enable=YES" >> /etc/vsftpd.conf
echo "chroot_local_user=YES" >> /etc/vsftpd.conf

# Neustart von vsftpd, um die Änderungen zu übernehmen
systemctl restart vsftpd

# Erstelle einen FTP-Nutzer mit vollen Rechten auf das Webserver-Verzeichnis
ftp_user="julianzillner"
ftp_password="lagersystem5"

useradd -m -d /var/www/html -s /usr/sbin/nologin $ftp_user
echo "$ftp_user:$ftp_password" | chpasswd

# Ändere den Besitzer des Webserver-Verzeichnisses
chown -R $ftp_user:$ftp_user /var/www/html

# Erlaube den externen SSH-Zugriff
ufw allow 22

# Erlaube den FTP-Port (Port 21) in der Firewall
ufw allow 21/tcp

# Aktualisiere die Firewall-Regeln
ufw --force enable

# Ausgabe von Informationen
echo "Installation abgeschlossen."
echo "Apache und PHP wurden installiert und sind jetzt verfügbar."
echo "FTP-Server wurde installiert. Benutzer: $ftp_user, Passwort: $ftp_password"
echo "Externer SSH-Zugriff ist erlaubt."
echo "FTP-Port (Port 21) ist in der Firewall erlaubt."
