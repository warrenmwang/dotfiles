{
  pkgs,
  config,
  lib,
  ...
}:
{
  users.users.sun = {
    isNormalUser = true;
    description = "sun";
    extraGroups = [
      "networkmanager"
      "wheel"
      # TODO: do we need the groups below?
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
    backupFileExtension = "backup";
    users.sun = import ./home.nix;
  };
}
