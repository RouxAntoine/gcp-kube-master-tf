#!/bin/sh

swapfile="/swapfile"

# create swap file and enable it
create_swap_file() {
  sudo fallocate -l 5G "$swapfile"
  sudo chmod 600 "$swapfile"
  sudo mkswap "$swapfile"
  echo "$swapfile"' swap swap defaults 0 0' | sudo tee -a /etc/fstab
  sudo swapon "$swapfile"
}

setup_docker_repository() {
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
  sudo add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
}

configure_swap() {
  create_swap_file
  echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.d/13-swapiness.conf
}

setup_user() {
  sudo usermod -aG docker "$USER"
}

# configure swap
configure_swap

# setup dependencies
sudo apt-get update -y
sudo apt-get install -y \
    htop \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common

# setup docker
setup_docker_repository
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# post install add user to docker group
setup_user