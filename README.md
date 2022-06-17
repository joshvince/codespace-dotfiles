# Codespace dotfiles

These are dotfiles that are used by me to configure and work with codespaces at Carwow.

Unless you work at carwow, they won't have much use.

If you do work at carwow, you might find some of these scripts useful as inspiration for
your own setup.

# setup.sh
This script will setup a new codespace, installing things like zsh and associated themes/plugins
and a couple of other tools I use to work with in the terminal.

Because this repository is associated with my codespaces, this script will be automatically ran
when a new codespace is started.

# .zshrc
This is what you'd expect: my zsh configuration. The only thing of note in there is the aliases
to the other scripts in this directory.

# newsession.sh
This script contains a bunch of useful commands I found myself carrying out at the start of new sessions in the codespace, things like starting the ssh-agent and signing into Heroku, and starting the backing services.

I alias this as `newsession` inside the `zshrc` file


# helpful_commands.sh
This contains a few of the commands I struggled to remember in my first week. They are almost all
documented somewhere, but it can be hard to remember where you found them, so I collected everything
together I wanted to remember.

I alias this as `helpme` inside the `zshrc` file
