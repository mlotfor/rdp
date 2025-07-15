#!/bin/bash

# Hold Google Cloud CLI packages to avoid breaking updates
sudo apt-mark hold \
  google-cloud-cli google-cloud-cli-anthoscli google-cloud-cli-app-engine-go \
  google-cloud-cli-app-engine-java google-cloud-cli-app-engine-python \
  google-cloud-cli-app-engine-python-extras google-cloud-cli-bigtable-emulator \
  google-cloud-cli-cbt google-cloud-cli-cloud-build-local google-cloud-cli-cloud-run-proxy \
  google-cloud-cli-datastore-emulator google-cloud-cli-gke-gcloud-auth-plugin \
  google-cloud-cli-kpt google-cloud-cli-local-extract google-cloud-cli-minikube \
  google-cloud-cli-nomos google-cloud-cli-package-go-module google-cloud-cli-pubsub-emulator \
  google-cloud-cli-skaffold

# Update and upgrade system, ignoring held packages
sudo apt update && sudo apt upgrade --ignore-hold -y

# Install required tools
sudo apt install wget -y

# Install Chrome Remote Desktop
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
sudo apt install ./chrome-remote-desktop_current_amd64.deb -y

# (Optional) Install Google Chrome Stable
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb -y

# Install XFCE desktop environment
sudo DEBIAN_FRONTEND=noninteractive apt install --assume-yes xfce4 desktop-base dbus-x11 xscreensaver

# Configure Chrome Remote Desktop session to use XFCE
echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" | sudo tee /etc/chrome-remote-desktop-session

# Disable LightDM to avoid conflict with CRD
sudo systemctl disable lightdm.service

# Add Mozilla PPA and install Firefox ESR
sudo add-apt-repository ppa:mozillateam/ppa -y
sudo apt update -y
sudo apt install firefox-esr -y
