#!/usr/bin/env bash

# Install Docker Engine on Ubuntu.
# https://docs.docker.com/engine/install/ubuntu/

# Exit code:
# 0: Success
# 1: Permission error

usage="./$(basename "$0") [-h] [-u str] -- Install Docker Engine on Ubuntu.\n\n
Where:\n
\t -h  Show this help.\n
\t -u  Specify which user to install docker for, defaults to current user.
"

# Default value
INSTALL_USER=$USER

while getopts 'hu:' option
do
    case "$option" in
        h) echo -e $usage
            exit 0 ;;
        u) INSTALL_USER=$OPTARG ;;
    esac
done

# Check if sudo-able
if ! (sudo true > /dev/null 2>&1)
then
    echo -e "\033[41;1mRun this script with sudo privilege.\033[0m"
    echo -e "If you need to install on a non-root user, please specify the user name.\n"
    echo -e ${usage}
    exit 1
fi

# Remove older versions
sudo apt-get -qqy remove \
    docker \
    docker-engine \
    docker.io \
    containerd \
    runc
sudo snap remove docker

# Set-up Docker repository
sudo apt-get -qqy update && sudo apt-get -qqy install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    sudo
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
    "deb [arch=$(dpkg --print-architecture) \
    signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo chmod +r /etc/apt/keyrings/docker.gpg

# Install Docker Engine
sudo apt-get -qqy update && sudo apt-get -qqy install \
    containerd.io \
    docker-ce \
    docker-ce-cli \
    docker-compose-plugin \
    ssh-askpass

# Use docker without sudo
sudo groupadd docker && :
sudo gpasswd -a $INSTALL_USER docker
sudo systemctl restart docker

echo -e "\033[46m----------------------------------------------------------------\033[0m"

if docker run --rm hello-world > /dev/null 2>&1
then
    echo -e "\033[46mPlease re-login to complete set-up.\033[0m"
else
    echo -e "\033[41mFailed to install docker.\033[0m"
fi
