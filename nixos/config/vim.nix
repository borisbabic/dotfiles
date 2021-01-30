{ pkgs, ... }:
{
  environment.variables = { EDITOR = "vim"; };

  environment.systemPackages = with pkgs; [
    (neovim.override {
      vimAlias = true;
      configure = {
        packages.myPlugins = with pkgs.vimPlugins; {
          start = [ 
            vim-lastplace vim-nix 
          ]; 
          opt = [];
        };
        customRC = ''
          " your custom vimrc

          set nocompatible              " be iMproved, required
          filetype off                  " required

          set nocompatible
          set backspace=indent,eol,start

          " ...
        '';
      };
    }
  )];
}
