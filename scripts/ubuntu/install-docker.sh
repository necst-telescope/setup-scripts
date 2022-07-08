#!/usr/bin/env bash

# Install Docker Engine on Ubuntu.
# https://docs.docker.com/engine/install/ubuntu/

# Exit code:
# 0: Success
# other: Error

usage = "./$(basename "$0") [-h] -- Install Docker Engine on Ubuntu.\n\n
Where:
\t -h  Show this help.
"

while getopts 'h' option
do
    case "$option" in
        h) echo -e $usage
            exit 0;;
    esac
done

# Remove older versions
sudo apt-get remove docker docker-engine docker.io containerd runc

# Set-up Docker repository
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
    "deb [arch=$(dpkg --print-architecture) \
    signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list > dev/null
sudo chmod +r /etc/apt/keyrings/docker.gpg

# Install Docker Engine
sudo apt-get update
sudo apt-get install \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin
sudo docker run hello-world
