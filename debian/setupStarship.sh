#!/bin/bash

# Installing Starship, because even your terminal deserves to look sharp.
echo "Installing Starship... Stand back, I'm going to try science."
curl -sS https://starship.rs/install.sh | sudo sh -s -- --bin-dir /usr/local/bin
echo 'eval "$(starship init bash)"' >> ~/.bashrc

