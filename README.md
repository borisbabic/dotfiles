# dotfiles
## Prerequisites

This repo is based on the usage of [GNU Stow](https://www.gnu.org/software/stow/). An alternative that does the same is acceptable (like xstow). 

Stow should be available from your package manager (including homebrew for macos)

## Usage 
```shell
git clone git@github.com:borisbabic/dotfiles.git ~/dotfiles # or using https git clone https://github.com/borisbabic/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow $package
```

You should clone the repository in your home folder. After that you enter the repo and then `stow` the desired packages (ie. folders), example: `stow viw`. Stow creates symlinks in your home repository.

For nixos see [here](nixos)

## Packages with their own documentation
- [awesome3.5](awesome3.5)
- [nixos](nixos)

## Outdated packages
List of packages I don't use anymore
- awesome3.4
- vim-janus
- zsh-antigen
### Old Hardware
List of hardware I don't actively use anymore
- t540p
- x230
