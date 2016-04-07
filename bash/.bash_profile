# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

if [ -f ~/.shell_common ]; then
	. ~/.shell_common
fi

export PATH
if [ -e /home/boris/.nix-profile/etc/profile.d/nix.sh ]; then . /home/boris/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
