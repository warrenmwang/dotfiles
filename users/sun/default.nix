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
      "wheel" # TODO: remove admin?
      
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
    backupFileExtension = "hm-backup";
    users.sun = import ./home.nix;
  };
}
