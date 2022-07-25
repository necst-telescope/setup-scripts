FROM ros:humble-ros-base

RUN apt update && apt install -y \
    curl \
    git \
    vim \
    emacs \
    nano \
    python3-pip \
    pciutils

# Install Poetry
ENV PATH=$PATH:/root/.local/bin
ENV POETRY_VIRTUALENVS_CREATE=false
RUN curl -sSL https://install.python-poetry.org | python3 -

# Download NECST ROS package
ENV NECST_ROOT="$HOME/.necst"
# git ...

# Install NECST ROS package
# RUN poetry install
# # pyinterface, neclib, ogameasure # from NECST.setup
