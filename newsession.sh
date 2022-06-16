#!/bin/bash
set -eo pipefail
bold=$(tput bold)
standout=$(tput smso)
normal=$(tput sgr0)

printf "\n\n 🤔 Checking for the carwow command..."

if ! command -v carwow &> /dev/null; then
  printf "\n\n\n\n🛑 carwow was not found. Close this window and try again!\n\n\n"
  exit
else
  printf "\n ✅ carwow command found, let's begin..."
fi

printf "\n\n👋 ${bold}Welcome to your codespace.${normal} Let's get setup...\n\n"

credentials() {
  printf "\n🔐 ${bold}Checking credentials...${normal}\n"

  SSH_KEY=LOCATION=/home/vscode/.ssh/if_ed25519

  if [ -f "$SSH_KEY_LOCATION" ]; then
    printf "⭐️ Your SSH key exists in this environment!"
  else
    cat << EOF
💥 Your SSH key is not yet saved to this environment.

${standout}gh codespace cp ~/.ssh/id_ed25519 remote:.ssh/${normal}

Go ahead and ${bold}run this 👆 command from your host machine${normal} and then come back here.


EOF
    read -s -r -p "Once you've done that, press ENTER to continue "
  fi

  printf "\n${bold}🕵🏾 The SSH agent...${normal}\n"

  while true; do
    read -p "Would you like to start the SSH agent and add your passphrase? [y/n] " yn
    case $yn in
      [Yy]* ) eval $(ssh-agent); ssh-add; break;;
      [Nn]* ) printf "\n\nNo worries!\n"; break;;
    esac
  done
}

heroku() {
  printf "\n👩🏻‍💻 ${bold}Checking for Heroku...${normal}"

  printf "TODO: add these!"
}

start_core() {
  printf "\n${bold}🏗 Carwow core services...${normal}\n"

  while true; do
    read -p "Would you like to start the carwow core services? [y/n] " yn
    case $yn in
      [Yy]* ) eval carwow start core; break;;
      [Nn]* ) printf "\n\nNo worries!\n"; break;;
    esac
  done
}

start_es67() {
  printf "\n${bold}🔍 ElasticSearch-6-7...${normal}\n"

  while true; do
    read -p "Would you like to start the elasticsearch-6-7 container? [y/n] " yn
    case $yn in
      [Yy]* ) eval carwow start elasticsearch-6-7; break;;
      [Nn]* ) printf "\n\nNo worries!\n"; break;;
    esac
  done
}

check_status() {
  printf "\n${bold}🧐 Here's the status of the carwow containers${normal}\n"

  eval carwow ps
}


credentials
heroku
start_core
start_es67
check_status
