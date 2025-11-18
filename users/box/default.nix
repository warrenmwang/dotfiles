{
  pkgs,
  config,
  lib,
  ...
}:
{
  users.users.box = {
    isNormalUser = true;
    description = "box";
    extraGroups = [
      "networkmanager"
      "wheel"
      "gitea"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.bash;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.box = import ./home.nix;
  };
}
