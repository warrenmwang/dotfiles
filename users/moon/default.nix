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
      "input" # sunshine virtual input via /dev/uinput
    ];
    packages = with pkgs; [ ];
    shell = pkgs.bash;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    users.moon = import ./home.nix;
  };
}
