#!/bin/bash
#-------Installing go----------
# Fetch the latest version line of Go and snag only the first line
GO_LATEST=$(curl -s https://go.dev/VERSION?m=text | head -n 1)
# Now we're cooking with gas - download it
wget https://dl.google.com/go/${GO_LATEST}.linux-amd64.tar.gz
# Extract the tarball to a system-wide location
sudo tar -C /usr/local -xzf ${GO_LATEST}.linux-amd64.tar.gz
# Clean up after yourself, don't leave a mess
rm ${GO_LATEST}.linux-amd64.tar.gz
# Add Go to the system path for all users
echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/go.sh
# Set up Go workspace environment variable
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export GOBIN=$GOPATH/bin' >> ~/.bashrc
# Apply the changes to the current session
source ~/.bashrc
source /etc/profile.d/go.sh
# Just double-checking everything's tickety-boo
go version

