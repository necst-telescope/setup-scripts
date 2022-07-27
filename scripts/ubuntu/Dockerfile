# syntax=docker/dockerfile:1
# escape=\

FROM ros:humble-ros-base

RUN apt-get -qq update && apt-get -qq install -y \
    curl \
    emacs \
    git \
    nano \
    pciutils \
    python3-pip \
    vim

# Create ROS 2 Workspace
ENV ROS2_WS=$HOME/ros2_ws
RUN mkdir -p $ROS2_WS/src && cd $ROS2_WS; \
    colcon build

# Install Poetry
ENV PATH=$PATH:/root/.local/bin
ENV POETRY_VIRTUALENVS_CREATE=false
RUN curl -sSL https://install.python-poetry.org | python3 -

# Set-up NECST
# RUN git pull && :

# Download NECST ROS package
# ENV NECST_ROOT="$HOME/.necst"
# git ... && :

# Install NECST ROS package
# RUN poetry install
# # pyinterface, neclib, ogameasure # from NECST.setup

# Shell script to configure environment
# ENTRYPOINT []
# Specify which branch to use
# CMD []
