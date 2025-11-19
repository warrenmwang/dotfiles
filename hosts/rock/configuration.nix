# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "consoleblank=300" ];

  networking.hostName = "rock";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [
    "wang"
  ];

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    btop
    file
    bat
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true; # enabling to test wake from sleep issues.

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # package = config.boot.kernelPackages.nvidiaPackages.legacy_530;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  services.tailscale.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  services.logind.settings.Login.HandleLidSwitch = "ignore"; # this is an "old laptop as a server" type shi

  # Data drive mounts
  fileSystems."/mnt/data1" = {
    device = "/dev/disk/by-uuid/676f6e78-e5cc-d901-606c-6e78e5ccd901";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"
    ];
  };

  # Apps services
  systemd.services.gitea = {
    after = [
      "mnt-data1.mount"
    ];
    requires = [
      "mnt-data1.mount"
    ];
    serviceConfig.ExecStartPre = [
      "+${pkgs.coreutils}/bin/mkdir -p /mnt/data1/gitea/custom/conf"
      "+${pkgs.coreutils}/bin/mkdir -p /mnt/data1/gitea/repositories"
      "+${pkgs.coreutils}/bin/chown -R gitea:gitea /mnt/data1/gitea"
    ];
  };
  services.gitea = {
    enable = true;
    stateDir = "/mnt/data1/gitea";
    repositoryRoot = "/mnt/data1/gitea/repositories";
    settings.server.DOMAIN = "rock";
  };

  users.users.rockdrive.isSystemUser = true;
  users.users.rockdrive.group = "rockdrive";
  users.groups.rockdrive = { };
  systemd.tmpfiles.rules = [
    "d /mnt/data1/rockdrive 0770 rockdrive rockdrive"
    "d /mnt/data1/rockdrive/storage 0770 rockdrive rockdrive"
  ];
  systemd.services.rockdrive = {
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      User = "rockdrive";
      Restart = "on-failure";

      # NOTE: address is needed for access from other computers, using tailscale ip
      ExecStart = ''
        ${pkgs.filebrowser}/bin/filebrowser \
          --address "rock.tail901c17.ts.net" \
          --port 3001 \
          --database /mnt/data1/rockdrive/filebrowser.db \
          --root /mnt/data1/rockdrive/storage
      '';
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    3000
    3001
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
