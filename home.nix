{ config, pkgs, ... } : {
  home.username = "wang";
  home.homeDirectory = "/home/wang";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  # how lovely, i needed to find this thread to learn about this symlink magic
  # https://discourse.nixos.org/t/how-to-manage-dotfiles-with-home-manager/30576/7
  # manual and llms didn't give it to me.
  home.file = {
    ".config/hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/hypr";
    };
    ".config/waybar" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/waybar";
    };
    ".config/nushell/config.nu" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nushell/config.nu";
    };
    ".config/nushell/env.nu" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nushell/env.nu";
    };
    ".config/tmux/tmux.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/tmux/tmux.conf";
    };
    ".config/kitty/kitty.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/kitty/kitty.conf";
    };
    ".config/xdg-desktop-portal" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/xdg-desktop-portal";
    };
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim";
    };
    ".config/Code/User/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/vscode/settings.json";
    };
    ".config/Code/User/keybindings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/vscode/keybindings.json";
    };
    "bin" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/bin";
    };
  };

  programs.git = {
    enable = true;
    userName = "Warren Wang";
    userEmail = "warren.min.wang@gmail.com";
    aliases = {
      a = "add";
      s = "status";
      d = "diff";
      l = "log";
      ci = "commit";
      co = "checkout";
    };
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      push = {
        autoSetupRemote = true;
        default = "current";
      };
    };
  };
}
