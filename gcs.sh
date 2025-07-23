#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Define ANSI escape codes for colors
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting Google Cloud CLI and Remote Desktop setup...${NC}"

# Hold Google Cloud CLI packages to avoid breaking updates
echo -e "${BLUE}Holding Google Cloud CLI packages...${NC}"
sudo apt-mark hold \
  google-cloud-cli google-cloud-cli-anthoscli google-cloud-cli-app-engine-go \
  google-cloud-cli-app-engine-java google-cloud-cli-app-engine-python \
  google-cloud-cli-app-engine-python-extras google-cloud-cli-bigtable-emulator \
  google-cloud-cli-cbt google-cloud-cli-cloud-build-local google-cloud-cli-cloud-run-proxy \
  google-cloud-cli-datastore-emulator google-cloud-cli-gke-gcloud-auth-plugin \
  google-cloud-cli-kpt google-cloud-cli-local-extract google-cloud-cli-minikube \
  google-cloud-cli-nomos google-cloud-cli-package-go-module google-cloud-cli-pubsub-emulator \
  google-cloud-cli-skaffold

# Update system package lists (no full upgrade to save time)
echo -e "${BLUE}Updating system package lists...${NC}"
sudo apt update -y

# Install required tools
echo -e "${BLUE}Installing wget...${NC}"
sudo apt install wget -y

# --- Chrome Remote Desktop Clean-up and Reinstallation ---
echo -e "${BLUE}Removing existing Chrome Remote Desktop configurations...${NC}"
# Remove old host ID and private key files to ensure a clean setup
sudo rm -f "/home/$USER/.config/chrome-remote-desktop/host_id"
sudo rm -f "/home/$USER/.config/chrome-remote-desktop/private_key"
# Remove the system-wide configuration if it exists
sudo rm -f /etc/chrome-remote-desktop-host
# Purge the existing chrome-remote-desktop package to remove all associated files
sudo apt purge chrome-remote-desktop -y || true # '|| true' to prevent script exit if not installed

echo -e "${BLUE}Downloading Chrome Remote Desktop...${NC}"
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb -O chrome-remote-desktop_current_amd64.deb
echo -e "${BLUE}Installing Chrome Remote Desktop...${NC}"
sudo apt install ./chrome-remote-desktop_current_amd64.deb -y
# Clean up the downloaded .deb file
rm chrome-remote-desktop_current_amd64.deb

# (Optional) Install Google Chrome Stable
echo -e "${BLUE}Downloading Google Chrome Stable (optional)...${NC}"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O google-chrome-stable_current_amd64.deb
echo -e "${BLUE}Installing Google Chrome Stable (optional)...${NC}"
sudo apt install ./google-chrome-stable_current_amd64.deb -y
# Clean up the downloaded .deb file
rm google-chrome-stable_current_amd64.deb

# Install XFCE desktop environment
echo -e "${BLUE}Installing XFCE desktop environment...${NC}"
sudo DEBIAN_FRONTEND=noninteractive apt install --assume-yes xfce4 desktop-base dbus-x11 xscreensaver

# Configure Chrome Remote Desktop session to use XFCE
echo -e "${BLUE}Configuring Chrome Remote Desktop session for XFCE...${NC}"
echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" | sudo tee /etc/chrome-remote-desktop-session

# LightDM disable command removed as systemd is not present.

# Add Mozilla PPA and install Firefox ESR
echo -e "${BLUE}Adding Mozilla PPA and installing Firefox ESR...${NC}"
sudo add-apt-repository ppa:mozillateam/ppa -y
sudo apt update -y # Update again after adding the PPA
sudo apt install firefox-esr -y

# Chrome Remote Desktop service start commands removed as systemd is not present.

echo -e "${BLUE}Script completed successfully!${NC}"
echo ""
echo "======================================================================="
echo "IMPORTANT NOTE:"
echo "This script has been optimized for speed by skipping a full system"
echo "upgrade. Your existing packages will not be updated to their latest"
echo "versions. If you wish to perform a full system upgrade later, you can"
echo "run 'sudo apt update && sudo apt upgrade' manually."
echo ""
echo "NEXT STEPS:"
echo "To enable Chrome Remote Desktop, you need to authorize it with your"
echo "Google account. Follow the instructions provided by Google, which"
echo "typically involve running a command like:"
echo "  /opt/google/chrome-remote-desktop/start-host --code=\"<AUTH_CODE>\" --pin=\"<YOUR_PIN>\""
echo "You will get the <AUTH_CODE> from the Chrome Remote Desktop website."
echo "======================================================================="
