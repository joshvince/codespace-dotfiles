#!/bin/bash
set -eo pipefail
bold=$(tput bold)
standout=$(tput smso)
green=$(tput setaf 2)
normal=$(tput sgr0)

check_carwow() {
  printf "\n\n š¤ Checking for the carwow command..."

  if ! command -v carwow &> /dev/null; then
    printf "\n\n\n\nš carwow was not found. Close this window and try again!\n\n\n"
    exit
  else
    printf "\n ā carwow command found, let's begin..."
  fi
}

credentials() {
  printf "\nš ${bold}Checking credentials...${normal}\n"

  SSH_KEY_LOCATION=/home/vscode/.ssh/id_ed25519
  SSH_PUB_LOCATION=/home/vscode/.ssh/id_ed25519.pub

  if [[ -f "$SSH_KEY_LOCATION" && -f "$SSH_PUB_LOCATION" ]]; then
    printf "ā Your SSH key exists in this environment!\n"
  else
    printf "š„ Your SSH key is not yet saved to this environment.\n\n"
    printf "${green}gh codespace cp ~/.ssh/id_ed25519 remote:.ssh/${normal}\n"
    printf "${green}gh codespace cp ~/.ssh/id_ed25519.pub remote:.ssh/${normal}\n"
    printf "Go ahead and ${bold}run these š commands from your host machine${normal} and then come back here."

    read -s -r -p "Once you've done that, press ENTER to continue "
    printf "ā Your SSH key exists in this environment!\n"
  fi
}

keychain() {
  printf "\n${bold}š The SSH keychain${normal}\n"

  if ! command -v keychain &> /dev/null; then
    printf "\n\n\n\nš keychain was not found.\n\n\n"
    while true; do
      read -p "Would you like to install keychain and add your keys? [y/n] " yn
      case $yn in
        [Yy]* ) eval `sudo apt-get install keychain`; eval `keychain --eval --agents ssh id_ed25519`; break;;
        [Nn]* ) printf "\n\nNo worries! You can add this later\n"; break;;
      esac
    done
  else
    if command -v keychain id_ed25519 &> /dev/null; then
      printf "ā­ļø Your SSH key is already saved to the keychain\n"
    else
      printf "š„ The SSH key isn't saved to the keychain yet. Trying to save now...\n\n"
      eval `keychain --eval --agents ssh id_ed25519`
    fi
    printf "ā Keys sorted\n"
  fi
}

heroku() {
  printf "\nš©š»āš» ${bold}Checking for Heroku...${normal}"

  printf "š„ I can't tell if you are logged into Heroku. To be sure, let's log in\n"
  printf "${green}bin/carwow codespace heroku-login${normal}\n"
  printf "Go ahead and ${bold}run this š command from your host machine${normal} and then come back here."

  read -s -r -p "Once you've done that, press ENTER to continue "
  printf "ā Heroku sorted\n"
}

start_core() {
  printf "\n${bold}š Carwow core services...${normal}\n"

  while true; do
    read -p "Would you like to start the carwow core services? [y/n] " yn
    case $yn in
      [Yy]* ) eval carwow start core; break;;
      [Nn]* ) printf "\n\nNo worries!\n"; break;;
    esac
  done
  printf "ā Carwow core services started\n"
}

start_es67() {
  printf "\n${bold}š ElasticSearch-6-7...${normal}\n"

  while true; do
    read -p "Would you like to start the elasticsearch-6-7 container? [y/n] " yn
    case $yn in
      [Yy]* ) eval carwow start elasticsearch-6-7; break;;
      [Nn]* ) printf "\n\nNo worries!\n"; break;;
    esac
  done
  printf "ā Elasticsearch-6-7 started\n"
}

check_status() {
  printf "\n${bold}š§ Here's the status of the carwow containers${normal}\n"

  eval carwow ps
}

# the program
check_carwow
printf "\n\nš ${bold}Welcome to your codespace.${normal} Let's get setup...\n\n"
credentials
keychain
heroku
start_core
start_es67
check_status
printf "\n\n\n š ${bold}Done! Happy coding!${normal}\n\n\n"
