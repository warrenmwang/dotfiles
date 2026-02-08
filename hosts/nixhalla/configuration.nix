# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, nixpkgs-kernel, ... }:
let
  nixpkgs-kernel-pkgs = import nixpkgs-kernel {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in
{
  # Bootloader.
  boot.kernelPackages = nixpkgs-kernel-pkgs.linuxPackages; # set a "stable" working kernel/nvidia driver config...nvidia...
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "nixhalla"; 
    networkmanager = {
      enable = true;
      dns = "none";

      # NOTE: if needed, insert local router at the front, "192.168.1.1", to resolve hostnames on lan like *.lan, but honestly just don't.
      # however, if u do that u can leak dns queries for now, even on vpn.
      # right now, set to only use cloudflare dns.
      insertNameservers = [ "1.1.1.1" "1.0.0.1" ]; 
    };
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    firewall.checkReversePath = false; # to get protonvpn working...

    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    resolvconf.enable = false;
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    dhcpcd.extraConfig = "nohook resolv.conf";

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # i18n.inputMethod = {
  #   enable = true;
  #   type = "fcitx5";
  #   ignoreUserConfig = true;
  #   fcitx5 = {
  #     plasma6Support = true;
  #     waylandFrontend = true;
  #     addons = with pkgs; [
  #       fcitx5-chinese-addons
  #       # fcitx5-gtk
  #       # kdePackages.fcitx5-qt
  #       # fcitx5-nord
  #     ];
  #     settings = {
  #       inputMethod = {
  #         "Groups/0" = {
  #           Name = "Default";
  #           "Default Layout" = "us";
  #           DefaultIM = "keyboard-us";
  #         };
  #         "Groups/0/Items/0".Name = "keyboard-us";
  #         "Groups/0/Items/1".Name = "chinese"; # TODO: what's the value for simplified pinyin? https://medium.com/@cwentsai/setting-up-chinese-japanese-input-with-fcitx5-on-nixos-2b5503d0b301
  #       };
  #     };
  #   };
  # };

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

  # Desktop Environments and related modules
  services.desktopManager.plasma6.enable = true;
  services.displayManager = {
    sddm = {
      enable = true;
      wayland = {
        enable = true;
        compositor = "kwin";
      };
    };
  };

  # - Hyprland
  # programs.hyprland.enable = true;
  # programs.hyprlock.enable = true;
  # security.pam.services.hyprlock = { };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      # xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      kdePackages.xdg-desktop-portal-kde
    ];
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplipWithPlugin ];
    listenAddresses = [ "*:631" ];
    allowFrom = [ "all" ];
    browsing = true;
    defaultShared = true;
    openFirewall = true;
  };
  # Allow using Internet Printing Protocol (IPP)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
  # SANE Scanners (scan document to raster image/pdf)
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];

  # Enable fonts
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.cousine
  ];

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-substituters = [
      "http://192.168.1.127:5000" # TODO: might want to update to allow working if on tailscale (if i leave ever home)
    ];
    extra-trusted-public-keys = [
      "rock-1:qzs/0lSKcny2zeoLPu9A5QXOk7UkRYIEvA1kiKjw49M="
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
    nmap

    # global packages for nvim default lsps, use devshells for per project needs
    # NOTE: do NOT use Mason to install any lsps, formatters, linters, etc.
    # look into https://github.com/BirdeeHub/nixCats-nvim if need it
    #
    gcc
    clang-tools
    lua-language-server
    nixfmt

    kitty
    # ghostty
    vscode
    # zed-editor
    # evil-helix
    neovim
    # neovide
    yazi
    hyperfine
    emacs
    sqlitestudio
    wineWowPackages.waylandFull
    winetricks

    obsidian
    google-chrome
    brave
    parsec-bin
    kdePackages.kcalc
    kdePackages.kclock
    kdePackages.partitionmanager
    protonvpn-gui
    qbittorrent
    spotify
    discord
    signal-desktop
    element-desktop

    # recording
    obs-studio
    audacity

    # media editting
    shotcut
    gimp

    # drawing
    aseprite
    krita
    xournalpp
    kdePackages.kolourpaint

    # idk if i want these anymore
    # xfce.thunar # file explorer
    # xfce.tumbler # d-bus thumbnailer service (for thunar)
    # xfce.thunar-volman # thunar extension (removeablle media management)
    # eog # image viewer

    vlc # video, sound viewer
    kdePackages.okular # PDF viewer
    calibre # e-book manager
    kdePackages.ark # zip archive tool
    mpv

    # Printer / Scanning
    hplip
    kdePackages.skanlite

    prismlauncher # open source minecraft launcher

    fastfetch
    cbonsai
    asciiquarium

    lshw
    usbutils
    pciutils
    hardinfo2
    ddcutil
    ddcui
    brightnessctl
    wayland-utils
    man-pages
    man-pages-posix

    # Probably only for custom DE w/ hyprland specific things
    # mako                      # a notification daemon
    # wofi                      # program launcher menu
    # waybar                    # top decoration bar
    # networkmanagerapplet
    # hyprshot                  # screenshot tool
    # hyprpicker                # color picker
    # cliphist                  # clipboard manager
    # libnotify
    # pulsemixer                # audio control cli
    # pavucontrol               # audio control gui

    wl-clipboard
    opentabletdriver
    libinput
    libwacom

    displaylink
    exfatprogs
  ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  documentation.dev.enable = true;

  # NOTE: this didn't work in home manager, so putting vars in system env def
  # https://github.com/nix-community/home-manager/issues/1011
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland

    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_CACHE_HOME = "$HOME/.cache";

    BROWSER = "firefox";
    TERMINAL = "kitty";
    EDITOR = "nvim";
    FILE_MANAGER = "thunar";
    MANPAGER = "nvim +Man!";

    QT_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
    XMODIFIERS = "@im=fcitx";

    KWIN_DRM_PREFER_COLOR_DEPTH = "24";
  };

  # =================
  # Hardware Stuff
  # =================
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" "displaylink" "modesetting" ];
  };
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable; # tied to whatever nvidia stable version is based on kernel version selected
  };
  nixpkgs.config.cudaSupport = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true; # gui tool

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # services.emacs = {
  #   enable = true;
  #   package = pkgs.emacs; # replace with emacs-gtk, or a version provided by the community overlay if desired.
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.tailscale.enable = true; # personal devices vpn network

  # NOTE: will need the binary blobs from Synaptic's, after agreeing to EULA for using DisplayLink.
  # Can get it directly via:
  # nix-prefetch-url --name displaylink-620.zip https://www.synaptics.com/sites/default/files/exe_files/2025-09/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu6.2-EXE.zip
  systemd.services.displaylink-server = {
    enable = true;
    requires = [ "systemd-udevd.service" ];
    after = [ "systemd-udevd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.displaylink}/bin/DisplayLinkManager";
      User = "root";
      Group = "root";
      Restart = "on-failure";
      RestartSec = 5; # Wait 5 seconds before restarting
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
