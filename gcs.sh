#!/bin/bash

# Update and upgrade system
sudo apt-mark hold google-cloud-sdk
sudo apt update && sudo apt upgrade --ignore-hold

# Install wget
sudo apt install wget -y

# Install Chrome Remote Desktop
sudo wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
sudo apt install ./chrome-remote-desktop_current_amd64.deb -y

# Install desktop environment and related packages
sudo DEBIAN_FRONTEND=noninteractive apt install --assume-yes xfce4 desktop-base dbus-x11 screensaver
sudo bash -c 'echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session'

# Disable lightdm service
sudo systemctl disable lightdm.service

# Add Mozilla PPA for Firefox ESR
sudo add-apt-repository ppa:mozillateam/ppa -y

# Update repository index
sudo apt update -y

# Install Firefox ESR
sudo apt install firefox-esr -y
