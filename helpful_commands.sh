#!/bin/bash
bold=$(tput bold)
standout=$(tput smso)
underline=$(tput smul)
green=$(tput setaf 2)
normal=$(tput sgr0)

cat << EOF
🧐🚗 ${bold}Helpful commands at carwow${normal} 🧐🚗

🚙 ${bold}Carwow commands${normal}
${underline}See status of containers${normal}
${green}carwow ps${normal}

${underline}See logs for container${normal}
${green}carwow logs <some_site>${normal}

${underline}Restore a dev database from production${normal}
${green}rake db:restore_dev_database${normal}

${underline}Start webpack in watch mode${normal}
${green}carwow webpack --watch${normal}

===================================
💻 ${bold}Source Files${normal} 💻

${underline}Run the elm formatter against a file (accept the changes!)${normal}
${green}carwow run yarn elm-format <file>${normal}

${underline}Run rubocop against a file and automatically reformat.${normal}
${green}carwow run bundle exec rubocop -A <file>${normal}

===================================
💣 ${bold}Troubleshooting${normal} 💣
${underline}carwow command not found${normal}
The first VS Code terminal usually doesn't have the correct configuration.
Try opening a new terminal window inside VS Code.

${underline}permission denied to clone repo${normal}
You probably haven't copied the SSH keys into the codespace.
👇🏼 Run this from your host machine
${green}gh codespace cp ~/.ssh/id_ed25519 remote:.ssh/${normal}

${underline}Elasticsearch::Transport::Transport::Errors::Forbidden: [403]${normal}
You might have run out of storage space on your codespace.
👇🏼 See if your codespace is running out of storage (can cause ES issues)
${green}df -h${normal}

👇🏼 Find 10 biggest files to rm
${green}du -a / | sort -n -r | head -n 10${normal}
Try removing the database dumps especially as these take up space.

${underline}401 denied when trying to pull gems${normal}
The GITHUB_PACKAGES_TOKEN might not be set. Try this discourse:
https://carwow.discourse.team/t/codespace-github-credentials-expire-too-often/951/4

${underline}No deals on the offerlist?${normal}
You need to have two elasticsearch instances running. Have you started?
${green}carwow start elasticsearch${normal}
${green}carwow start elasticsearch-6-7${normal}

====================================
EOF
