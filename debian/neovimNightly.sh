#!/bin/bash
echo "Adding Neovim PPA for those who like their software fresh out the oven..."
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install -y neovim

