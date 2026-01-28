#!/bin/bash

DISTROBOX_NAME="neovim-box"

BOX_HOME=$(pwd)/home


if distrobox list | grep -q "$DISTROBOX_NAME "; then
    echo "Distrobox '$DISTROBOX_NAME' already exists."
else
    mkdir -p $BOX_HOME
    cp ~/.my-credentials $BOX_HOME || true

    mkdir -p $BOX_HOME/.config/nvim
    cp init.vim $BOX_HOME/.config/nvim
    cp coc-settings.json $BOX_HOME/.config/nvim


    distrobox-create --init --name $DISTROBOX_NAME --image ubuntu:latest --home $BOX_HOME

    distrobox-enter $DISTROBOX_NAME -- /bin/bash install.sh
fi

# distrobox-enter $DISTROBOX_NAME -- code .
