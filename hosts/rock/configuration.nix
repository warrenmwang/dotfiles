{
  config,
  pkgs,
  tailscalePkgs,
  immichPkgs,
  llm-agents,
  ...
}:
let
  kavitaAppsettings = pkgs.writeText "kavita-appsettings.json" ''
    {
      "TokenKey": "super secret unguessable key that is longer because we require it",
      "Port": 3002,
      "IpAddresses": "",
      "BaseUrl": "/",
      "Cache": 75
    }
  '';
in
{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "consoleblank=300" ];
  boot.supportedFilesystems = [ "btrfs" ];

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
  nix.settings = {
    extra-substituters = [
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "wang"
    ];
  };

  environment.systemPackages = with pkgs; [
    wget
    file
    git
    gh
    ripgrep
    fd
    btop
    tmux
    vim
    unzip
    nushell
    jq

    btrfs-progs

    gcc
    clang-tools
    lua-language-server
    nixfmt-rfc-style

    neovim

    llm-agents.packages.x86_64-linux.opencode
    llm-agents.packages.x86_64-linux.claude-code
  ];

  programs.nix-ld.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

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
  services.tailscale = {
    enable = true;
    package = tailscalePkgs.tailscale;
  };
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
      UseDns = false;
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
  fileSystems."/mnt/data2" = {
    device = "/dev/disk/by-uuid/e1315b76-bb20-dd01-c021-5b76bb20dd01";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"
    ];
  };

  # Apps services
  services.nix-serve = {
    enable = true;
    secretKeyFile = "/etc/nix/cache-priv-key.pem";
    port = 5000;
    openFirewall = true;
  };

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
    "d /mnt/data1/KavitaData 2775 kavita users"
    "d /var/lib/kavita/config 0750 kavita kavita"
    "C /var/lib/kavita/config/appsettings.json 0640 kavita kavita - ${kavitaAppsettings}"
    "d /mnt/data2 0755 root root -"
  ];
  systemd.services.rockdrive = {
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      User = "rockdrive";
      Restart = "on-failure";
      ExecStart = ''
        ${pkgs.filebrowser}/bin/filebrowser \
          --address "0.0.0.0" \
          --port 3001 \
          --database /mnt/data1/rockdrive/filebrowser.db \
          --root /mnt/data1/rockdrive/storage \
      '';
    };
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true; # port 8096
    user = "jellyfin";
    group = "users";
  };

  users.users.kavita = {
    isSystemUser = true;
    group = "kavita";
    extraGroups = [ "users" ];
  };
  users.groups.kavita = { };
  systemd.services.kavita-data-permissions = {
    description = "Fix Kavita data permissions";
    after = [ "mnt-data1.mount" ];
    requires = [ "mnt-data1.mount" ];
    before = [ "kavita.service" ];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [
      coreutils
      findutils
    ];
    script = ''
      mkdir -p /mnt/data1/KavitaData
      chown kavita:users /mnt/data1/KavitaData
      chmod 2775 /mnt/data1/KavitaData
      chgrp -R users /mnt/data1/KavitaData
      find /mnt/data1/KavitaData -type d -exec chmod g+rws {} +
      find /mnt/data1/KavitaData -type f -exec chmod g+rw {} +
    '';
    serviceConfig.Type = "oneshot";
  };
  systemd.services.kavita = {
    description = "Kavita Reading Server";
    after = [
      "network.target"
      "kavita-data-permissions.service"
    ];
    requires = [ "kavita-data-permissions.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      User = "kavita";
      Group = "kavita";
      SupplementaryGroups = [ "users" ];
      UMask = "0002";
      Restart = "on-failure";
      RestartSec = "5s";
      ExecStart = "${pkgs.kavita}/bin/kavita --urls http://0.0.0.0:3002";
      StateDirectory = "kavita";
      WorkingDirectory = "/var/lib/kavita";
    };
  };

  services.immich = {
    enable = true;
    package = immichPkgs.immich;
    host = "0.0.0.0";
    mediaLocation = "/mnt/data2/immich";
    database.enableVectors = false;
  };
  services.postgresql.package = immichPkgs.postgresql_17;
  services.redis.package = immichPkgs.redis;
  systemd.services.immich-data-permissions = {
    description = "Fix Immich data permissions";
    after = [ "mnt-data2.mount" ];
    requires = [ "mnt-data2.mount" ];
    before = [ "immich-server.service" ];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [ coreutils ];
    script = ''
      mkdir -p /mnt/data2/immich
      chown immich:immich /mnt/data2/immich
      chmod 0700 /mnt/data2/immich
    '';
    serviceConfig.Type = "oneshot";
  };
  services.redis.servers.immich.logLevel = "warning";

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    3000 # Gitea
    3001 # Rockdrive
    3002 # Kavita
    2283 # Immich
    5000 # Nix-serve
    8787 # LLM Orchestrator
    8096 # Jellyfin
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  systemd.timers."mirror-github-to-gitea" = {
    description = "Mirror GitHub repos to Gitea";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Wed *-*-* 00:00:00";
      OnBootSec = "5min";
      Persistent = true;
    };
  };

  systemd.services."mirror-github-to-gitea" = {
    description = "Mirror GitHub repos to Gitea";
    path = with pkgs; [
      bash
      curl
      jq
      git
    ];
    script = ''
      ${pkgs.bash}/bin/bash /home/wang/config_files/home_server/gitea-backup.bash
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "wang";
      StandardOutput = "journal";
      StandardError = "journal";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
