#!/bin/bash

# Überprüfen, ob das Skript mit Root-Rechten ausgeführt wird
if [ "$EUID" -ne 0 ]; then
  echo "Dieses Skript muss mit Root-Rechten ausgeführt werden. Bitte als Root oder mit sudo ausführen."
  exit 1
fi

# Aktualisiere die Paketliste
apt update

# Installiere Apache
apt install -y apache2

# Installiere PHP
apt install -y php libapache2-mod-php

# Installiere vsftpd (FTP-Server)
apt install -y vsftpd

# Konfiguriere vsftpd
echo "local_enable=YES" >> /etc/vsftpd.conf
echo "write_enable=YES" >> /etc/vsftpd.conf
echo "chroot_local_user=YES" >> /etc/vsftpd.conf

# Neustart von vsftpd, um die Änderungen zu übernehmen
systemctl restart vsftpd

# Erstelle einen FTP-Nutzer mit vollen Rechten auf das Webserver-Verzeichnis
read -p "Geben Sie den Benutzernamen für den FTP-Nutzer ein: " ftp_user
read -s -p "Geben Sie das Passwort für den FTP-Nutzer ein: " ftp_password

useradd -m -d /var/www/html -s /usr/sbin/nologin $ftp_user
echo "$ftp_user:$ftp_password" | chpasswd

# Ändere den Besitzer des Webserver-Verzeichnisses
chown -R $ftp_user:$ftp_user /var/www/html

# Ausgabe von Informationen
echo "Installation abgeschlossen."
echo "Apache wurde installiert und ist jetzt verfügbar."
echo "PHP wurde installiert."
echo "FTP-Nutzer wurde erstellt mit vollen Rechten auf das Webserver-Verzeichnis."
