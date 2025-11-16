{
  config,
  pkgs,
  ...
}:

let
  mkSymlink =
    path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/${path}";
in
{
  home.username = "box";
  home.homeDirectory = "/home/box";
  home.stateVersion = "25.05";
  home.file = {
    ".icons/default".source = mkSymlink "./icons/Rage-Gothic-Light";
    ".config/hypr".source = mkSymlink "./config/hypr";
    ".config/waybar".source = mkSymlink "./config/waybar";
    ".config/mako".source = mkSymlink "./config/mako";
    ".bashrc".source = mkSymlink "./config/.bashrc";
    ".config/git/config".source = mkSymlink "./config/.gitconfig";
    ".config/nushell/config.nu".source = mkSymlink "./config/nushell/config.nu";
    ".config/nushell/env.nu".source = mkSymlink "./config/nushell/env.nu";
    ".config/tmux/tmux.conf".source = mkSymlink "./config/tmux/tmux.conf";
    ".config/kitty/kitty.conf".source = mkSymlink "./config/kitty/kitty.conf";
    ".config/nvim".source = mkSymlink "./config/nvim";
    ".config/Code/User/settings.json".source = mkSymlink "./config/vscode/settings.json";
    ".config/Code/User/keybindings.json".source = mkSymlink "./config/vscode/keybindings.json";
    "bin".source = mkSymlink "./bin";
  };
  programs.home-manager.enable = true;
}
