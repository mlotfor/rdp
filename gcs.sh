#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Print commands and their arguments as they are executed.
set -x

echo "Starting Google Cloud CLI and Remote Desktop setup..."

# Hold Google Cloud CLI packages to avoid breaking updates
echo "Holding Google Cloud CLI packages..."
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
echo "Updating and upgrading system packages..."
sudo apt update && sudo apt upgrade --ignore-hold -y

# Install required tools
echo "Installing wget..."
sudo apt install wget -y

# Install Chrome Remote Desktop
echo "Downloading Chrome Remote Desktop..."
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb -O chrome-remote-desktop_current_amd64.deb
echo "Installing Chrome Remote Desktop..."
sudo apt install ./chrome-remote-desktop_current_amd64.deb -y
# Clean up the downloaded .deb file
rm chrome-remote-desktop_current_amd64.deb

# (Optional) Install Google Chrome Stable
echo "Downloading Google Chrome Stable (optional)..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O google-chrome-stable_current_amd64.deb
echo "Installing Google Chrome Stable (optional)..."
sudo apt install ./google-chrome-stable_current_amd64.deb -y
# Clean up the downloaded .deb file
rm google-chrome-stable_current_amd64.deb

# Install XFCE desktop environment
echo "Installing XFCE desktop environment..."
sudo DEBIAN_FRONTEND=noninteractive apt install --assume-yes xfce4 desktop-base dbus-x11 xscreensaver

# Configure Chrome Remote Desktop session to use XFCE
echo "Configuring Chrome Remote Desktop session for XFCE..."
echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" | sudo tee /etc/chrome-remote-desktop-session

# Disable LightDM to avoid conflict with CRD
echo "Disabling LightDM service to avoid conflicts..."
sudo systemctl disable lightdm.service

# Add Mozilla PPA and install Firefox ESR
echo "Adding Mozilla PPA and installing Firefox ESR..."
sudo add-apt-repository ppa:mozillateam/ppa -y
sudo apt update -y # Update again after adding the PPA
sudo apt install firefox-esr -y

echo "Script completed successfully!"
echo ""
echo "======================================================================="
echo "NEXT STEPS:"
echo "To enable Chrome Remote Desktop, you need to authorize it with your"
echo "Google account. Follow the instructions provided by Google, which"
echo "typically involve running a command like:"
echo "  /opt/google/chrome-remote-desktop/start-host --code=\"<AUTH_CODE>\" --pin=\"<YOUR_PIN>\""
echo "You will get the <AUTH_CODE> from the Chrome Remote Desktop website."
echo "======================================================================="
