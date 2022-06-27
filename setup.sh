#!/bin/bash

# Thank you to @bebbs for the inspiration (in some cases the actual code) for this script
# https://github.com/bebbs/dotfiles/blob/main/install.sh

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

install_solargraph() {
  custom_ruby_build_prefix=/usr/local/custom
  custom_ruby_location=~/local/.ruby

  if [[ -d ${custom_ruby_location}/bin/solargraph ]]; then
    printf "\n\n\n\n🛑 solargraph was not found.\n\n\n"
    while true; do
      read -p "Would you like to install a custom version of ruby-build, ruby 3.1.2 and solargraph?" yn
      case $yn in
        [Yy]* ) printf "👷🏻‍♂️ Installing ruby-build..."
                eval `sudo mkdir /usr/local/custom`;
                eval `sudo cd ~ && git clone https://github.com/rbenv/ruby-build.git`;
                eval `sudo PREFIX=${custom_ruby_build} ./ruby-build/install.sh`;
                printf "👷🏻‍♂️ Ruby build installed."
                printf "💍 Installing ruby build dependencies. This will take a while..."
                eval `sudo apt-get install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev`;
                printf "💍 Ruby's build dependencies installed."
                printf "💎 Installing Ruby (3.1.2) Better go make a coffee..."
                eval `sudo /usr/local/custom/bin/ruby-build 3.1.2 ${custom_ruby_location}`;
                printf "💎 Ruby installed."
                printf "🌞 Installing solargraph...."
                eval `sudo ${custom_ruby_location}/bin/gem install solargraph`;
                printf "🌞 Solargraph was installed!"

                break;;
        [Nn]* ) printf "\n\nNo worries! You can add this later\n"; break;;
      esac
    done
  else
    printf "⭐️ Solargraph is already installed and should be good to use with VS Code \n"
    printf "Be sure to set your solargraph up to look at ${custom_ruby_location}/bin/solargraph \n"

    printf "✅ Ruby tooling all sorted\n"
  fi
}

# Run steps
create_symlinks
install_ohmyzsh
switch_to_zsh
install_powerlevel10k
install_thefuck
install_solargraph

# enable running of other helpful scripts in this folder
chmod +x ./newsession.sh
chmod +x ./setup.sh
chmod +x ./helpful_commands.sh
