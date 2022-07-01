#!/bin/bash

# ROS 2 Foxy Fitzroy installation script.
# https://docs.ros.org/en/foxy/Installation/Ubuntu-Install-Debians.html
# This script may install ROS 2 distro other than Foxy when specified, but not confirmed.

# Exit code:
# 0: Success
# 1: Argument error
# 2: Permission error

usage="./$(basename "$0") [-h] [-d str] [-u str] -- Install ROS 2 on Ubuntu PC.\n\n
where:\n
\t -h  Show this help.\n
\t -d  Specify which ROS 2 distro to install.\n
\t -u  Specify which user to install ROS 2 for, defaults to current user.
"

# Defaults.
INSTALL_USER=${USER}

# Parse options.
while getopts 'hd:u:' option
do
    case "${option}" in
        h)  echo -e ${usage}
            exit 0;;
        d)  INSTALL_ROS_DISTRO=$(echo $OPTARG | tr '[:upper:]' '[:lower:]')
            ;;
        u)  INSTALL_USER=$OPTARG
            INSTALL_USER_HOME=$(eval echo "~$INSTALL_USER")
            ;;
        *)  echo "Invalid argument; see usage below."
            echo -e ${usage}
            exit 1;;
    esac
done

# Check if ROS 2 distro is specified.
if [ -z "$INSTALL_ROS_DISTRO" ]
then
    echo -e "\033[41;1mSpecify ROS 2 distro.\033[0m\n"
    echo -e ${usage}
    exit 1
fi

# Check if sudo-able.
if ! (sudo true > /dev/null 2>&1)
then
    echo -e "\033[41;1mRun this script with sudo privilege.\033[0m"
    echo -e "If you need to install on a non-root user, please specify the user name.\n"
    echo -e ${usage}
    exit 2
fi

# Confirm installation configuration.
while true
do
    echo -e  "Installing ROS 2 \033[46;1m'$INSTALL_ROS_DISTRO'\033[0m into user \033[46;1m'$INSTALL_USER'\033[0m."
    read -p "Proceed? (y/n) " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit 0;;
        * ) echo "Please choose either of (y/n).";;
    esac
done

# Set variables.
source /etc/os-release

# Check if Ubuntu Universe repository is enabled.
if !(apt-cache policy | grep $UBUNTU_CODENAME/universe) > /dev/null 2>&1
then
    sudo apt-get install software-properties-common
    sudo add-apt-repository universe
fi

# Add ROS 2 apt repository to the system.
sudo apt-get update
sudo apt-get install curl gnupg2 lsb-release
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Install ROS 2 and essential tools.
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install ros-$INSTALL_ROS_DISTRO-ros-base
sudo apt-get install python3-colcon-common-extensions python3-rosdep python3-argcomplete

# Add ROS 2 set-up script.
if [ ! -f $INSTALL_USER_HOME/ros2 ]
then
    setup_content="source /opt/ros/$INSTALL_ROS_DISTRO/setup.bash\n
    source $INSTALL_USER_HOME/ros2_ws/install/setup.bash
    "
    echo -e $setup_content >> $INSTALL_USER_HOME/ros2
fi

# Make ROS 2 commands available.
source /opt/ros/$INSTALL_ROS_DISTRO/setup.bash

# Create ROS 2 workspace.
mkdir -p $INSTALL_USER_HOME/ros2_ws/src
cd $INSTALL_USER_HOME/ros2_ws
sudo colcon build

cd -
exit 0
