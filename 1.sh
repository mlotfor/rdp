#!/bin/bash

# This script automates the installation of Chrome Remote Desktop with the XFCE desktop environment,
# Firefox ESR, and restarts the Chrome Remote Desktop service on Debian/Ubuntu-based systems.

## Section 1: Update System and Install wget
echo "Updating system packages and installing wget..."
sudo apt update -y && sudo apt upgrade -y
sudo apt install wget -y
echo "System update and wget installation complete. ✅"
echo "----------------------------------------------------"

## Section 2: Download and Install Chrome Remote Desktop
echo "Downloading and installing Chrome Remote Desktop..."
sudo wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
sudo apt install ./chrome-remote-desktop_current_amd64.deb -y
echo "Chrome Remote Desktop installation complete. 🚀"
echo "----------------------------------------------------"

## Section 3: Install Desktop Environment and Configure Display Manager (XFCE with LightDM)
echo "Installing XFCE desktop environment and configuring LightDM..."
sudo DEBIAN_FRONTEND=noninteractive \
apt install --assume-yes xfce4 desktop-base dbus-x11 xscreensaver
echo "XFCE desktop environment installed. 🖼️"

echo "Configuring Chrome Remote Desktop for XFCE..."
sudo bash -c 'echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session'
echo "Chrome Remote Desktop configured for XFCE. ⚙️"

echo "Disabling GDM3 if it was previously enabled..."
sudo systemctl disable gdm3.service
echo "GDM3 disabled. 🚫"

echo "Enabling LightDM..."
sudo systemctl enable lightdm.service
echo "LightDM enabled. ✨"

## Section 4: Install Firefox ESR
echo "Installing Firefox ESR..."
sudo apt install firefox-esr -y
echo "Firefox ESR installation complete. 🦊"
echo "----------------------------------------------------"

## Section 5: Enable and Start/Restart Chrome Remote Desktop Service
echo "Enabling and starting/restarting Chrome Remote Desktop service..."
sudo systemctl enable chrome-remote-desktop
sudo service chrome-remote-desktop restart
echo "Chrome Remote Desktop service enabled and restarted. ▶️"
echo "----------------------------------------------------"

echo "Chrome Remote Desktop with XFCE and Firefox ESR installation complete! 🎉"
echo "You can now connect to your remote desktop."
