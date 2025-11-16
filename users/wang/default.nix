{
  pkgs,
  config,
  lib,
  ...
}:
{
  users.users.wang = {
    isNormalUser = true;
    description = "Warren Wang";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.bash; # other options based on my mood: pkgs.nushell
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.wang = import ./home.nix;
  };
}
