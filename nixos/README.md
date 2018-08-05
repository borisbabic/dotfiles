# Usage
This package is an exception from the others, you should clone this repo into `/etc/nixos/` instead of `~/` to use it.

After cloning the directory run `git stow nixos` from within the directory. Create a configuration.nix based on the configuration.nix.skel file then run `nixos-rebuild switch)


NOTE: When installing from a liveusb/livecd to avoid running out of space you can copy tmp.nix to /etc/nixos/configuration.nix, build that and then build the full thing after rebooting.

Copy/pastable commands:

```shell
git clone git@github.com:borisbabic/dotfiles.git --recurse-submodules /etc/nixos/dotfiles # or using https git clone https://github.com/borisbabic/dotfiles.git --recurse-submodules /etc/nixos/dotfiles
cd /etc/nixos/dotfiles
stow nixos
cp nixos/configuration.nix.skel /etc/nixos/configuration.nix
vim /etc/nixos/configuration.nix #choose what you want, and update the state version to a newer one if avilable
sudo nixos-rebuild switch
```
## nixpkgs-channels
It is advisable to add an nixpkgs-channels as an additional remote to the submodule and base updates on branches there.

```shell
cd nixpkgs
git remote add channels git://github.com/NixOS/nixpkgs-channels.git
git fetch channels nixos-unstable
git checkout channels/nixos-unstable
```

## Updating
To update first update the nixpkgs submodule then run `nixos-rebuild switch`


## Future plans

- Use [home-manager](https://github.com/rycee/home-manager) to replace some other packages here 
- Better file splitting to better accomadate non desktop usecases (servers/RPIs)
