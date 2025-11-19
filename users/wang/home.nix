{
  pkgs,
  config,
  lib,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.wang = import ./home-config.nix;
  };
}
