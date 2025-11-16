{
  pkgs,
  config,
  lib,
  ...
}:
{
  users.users.moon = {
    isNormalUser = true;
    description = "moon";
    extraGroups = [
      "networkmanager"
      "wheel"
      "scanner"
      "lp"
      "lpadmin"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.bash;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.moon = import ./home.nix;
  };
}
