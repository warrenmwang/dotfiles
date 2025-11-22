{
  config,
  pkgs,
  ...
}:
let
  mkSymlinkIcons = 
    path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/${path}";
  mkSymlinkDotfiles =
    path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/users/wang/${path}";
in
{
  home.file = {
    ".icons/default".source = mkSymlinkIcons "icons/Rage-Gothic-Light";
    ".config/hypr".source = mkSymlinkDotfiles "config/hypr";
    ".config/waybar".source = mkSymlinkDotfiles "config/waybar";
    ".config/mako".source = mkSymlinkDotfiles "config/mako";
    ".bashrc".source = mkSymlinkDotfiles "config/.bashrc";
    ".config/git/config".source = mkSymlinkDotfiles "config/.gitconfig";
    ".config/nushell/config.nu".source = mkSymlinkDotfiles "config/nushell/config.nu";
    ".config/nushell/env.nu".source = mkSymlinkDotfiles "config/nushell/env.nu";
    ".config/tmux/tmux.conf".source = mkSymlinkDotfiles "config/tmux/tmux.conf";
    ".config/kitty/kitty.conf".source = mkSymlinkDotfiles "config/kitty/kitty.conf";
    ".config/nvim".source = mkSymlinkDotfiles "config/nvim";
    ".config/Code/User/settings.json".source = mkSymlinkDotfiles "config/vscode/settings.json";
    ".config/Code/User/keybindings.json".source = mkSymlinkDotfiles "config/vscode/keybindings.json";
  };
}
