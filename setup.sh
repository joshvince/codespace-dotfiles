#!/bin/bash

echo "Starting dotfiles install"

set -eo pipefail

# Symlink dotfiles to $HOME dir in codespaces
create_symlinks() {
    # Get the directory in which this script lives.
    script_dir=$(dirname "$(readlink -f "$0")")

    # Get a list of all files in this directory that start with a dot.
    files=$(find $script_dir -maxdepth 1 -type f -name ".*")

    # Create a symbolic link to each file in the home directory.
    for file in $files; do
        name=$(basename $file)
        echo "Creating symlink to $name in home directory."
        rm -rf ~/$name
        ln -s $script_dir/$name ~/$name
    done

    echo "✅ Symlinks have been created"
}

# Attempt to install oh-my-zsh, if it is not already configured
install_ohmyzsh() {
  if [[ -d ~/.oh-my-zsh ]]; then
    echo "✅ ohmyzsh is already installed."
  else
    echo "Installing ohmyzsh"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "✅ Installed ohmyzsh"
  fi
}

# Change default shell to zsh
switch_to_zsh() {
  echo "Changing default shell to zsh"
  sudo chsh -s "$(which zsh)" "$(whoami)"
  echo "✅  Shell: ${SHELL}"
}

# Install powerlevel10k theme
install_powerlevel10k() {
  if [[ -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k ]]; then
    echo "✅ powerlevel10k is already installed."
  else
    echo "Installing powerlevel10k theme"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    echo "✅ Installed powerlevel10k theme"
  fi
}

# Install thefuck
install_thefuck() {
  if command -v fuck &> /dev/null; then
    printf "✅ thefuck is already installed"
  else
    printf "installing thefuck"
    sudo apt update
    sudo apt install python3-dev python3-pip python3-setuptools
    pip3 install thefuck --user
    echo "✅ Installed thefuck"
  fi
}

# Run steps
create_symlinks
install_ohmyzsh
switch_to_zsh
install_powerlevel10k
install_thefuck
