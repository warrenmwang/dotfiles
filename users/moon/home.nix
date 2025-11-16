{
  config,
  pkgs,
  ...
}:
{
  home.username = "moon";
  home.homeDirectory = "/home/moon";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
        darkreader
      ];
    };
  };
}
