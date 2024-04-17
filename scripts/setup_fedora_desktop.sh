#!/bin/bash
#file 		:setup_fedora_desktop.sh
#date		:2024-04-17
#description 	:This script will make a header for a bash script.
#author 	:thecastrodev
#version 	:1.0.0
#usage		:bash setup_fedora_desktop.sh
#notes 	:use vim or nano to edit file and customize scrit
#bash_version 	:5.2.26(1)-release

# update dnf
cd /tmp
sudo dnf update -y
sudo dnf upgrade -y

# install dev dependences
sudo dnf install -y \
	git curl make automake \
	gcc gcc-c++ kernel-devel \
	java-21-openjdk.x86_64 unzip \
	openssh openssl openssl-devel \
	vim neovim docker docker-compose \
	autoconf rust patch \
	bzip2 libyaml-devel \
	libffi-devel readline-devel zlib-devel \
	gdbm-devel ncurses-devel

# install nerd fonts
git clone https://github.com/terroo/fonts.git
cd fonts/fonts
rm *.woff *.woff2 *Complete.ttf *Mono.ttf *.otf *.bdf *.pcf *Complete.ttf *Mono.ttf
mkdir ~/.local/share/fonts
mv JetBrains* Roboto* Noto* material* Material* FiraCode* ~/.local/share/fonts
fc-cache -fv

# configure docker
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
bash
docker ps
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# install code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update
sudo dnf update -y
sudo dnf install code -y

# install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0

echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.bashrc
echo 'always_keep_download = yes' >> ~/.asdfrc

declare -A stacks
stacks["nodejs"]="20.12.1"
stacks["python"]="3.11.8"
stacks["rust"]="1.77.2"
stacks["ruby"]="3.3.0"
stacks["erlang"]="26.2.3"
stacks["elixir"]="1.16.2"

for key in ${!stacks[@]}; do
	asdf plugin add ${key} # add plugins
done

for key in ${!stacks[@]}; do
	asdf install ${key} ${stacks[${key}]}  # install
	asdf global ${key} ${stacks[${key}]} # globally
done


