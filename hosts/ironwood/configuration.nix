# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, kernel-nixpkgs, brave-nixpkgs, tailscalePkgs, ... }:
let
  kernel-nixpkgs-pkgs = import kernel-nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
  # NVIDIA 580 LTSB (last branch supporting Maxwell / GTX 970) built with the
  # pinned nixpkgs' own driver packaging against the pinned 6.12 kernel.
  # Replaces 570.153.02, which has a UVM suspend deadlock that crashed every
  # hibernate attempt (nvidia-hibernate.service SEGV in uvm_suspend).
  nvidiaPackages580 = config.boot.kernelPackages.nvidiaPackages.extend (
    final: prev: {
      legacy_580 = prev.mkDriver {
        version = "580.173.02";
        sha256_64bit = "sha256-jY65AB4FqaimY9PV0wT+tk7yhE7hhczf2VJ4aCD0bhs=";
        sha256_aarch64 = "sha256-1lvVYIfvTXjwSoCNp4g8NaWQHF/TfpXRUKdgLrqXqoA=";
        openSha256 = "sha256-lhloZdf6XbaAFTZBF1DxE0Nv9VC6obY8UPf0VyfVepE=";
        settingsSha256 = "sha256-dfdu/3tnwHUfP7WoeQFNOMalMlpmUWjeMDIOnu+yi8E=";
        persistencedSha256 = "sha256-j8YM1w231X+JIP3c3TpUNurEBumEu1stVjzFGWu1JXE=";
      };
    }
  );
  bravePkgs = import brave-nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in
{
  # Bootloader.
  boot.kernelPackages = kernel-nixpkgs-pkgs.linuxPackages; # pinned "stable" working kernel
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.resumeDevice = "/dev/disk/by-uuid/8370001a-e559-4bda-8d8b-c6994763a115"; # swap partition, needed to resume from hibernation

  systemd.services."systemd-suspend" = {
    serviceConfig = {
      Environment = ''"SYSTEMD_SLEEP_FREEZE_USER_SESSIONS=false"'';
    };
  };

  networking.hostName = "ironwood"; # Define your hostname.
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

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

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

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      kdePackages.xdg-desktop-portal-kde
    ];
  };

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-substituters = [
      "http://rock:5000" # TODO: might want to update to allow working if on tailscale (if i leave ever home)
    ];
    extra-trusted-public-keys = [
      "rock-1:qzs/0lSKcny2zeoLPu9A5QXOk7UkRYIEvA1kiKjw49M="
    ];
    trusted-users = [
      "wang"
    ];
  };
  
  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    file
    git
    wget
    google-chrome
    bravePkgs.brave
    moonlight-qt
    vim
    btop
    vlc
    libreoffice-qt6-fresh
    kdePackages.kcalc
    kdePackages.kolourpaint
    kdePackages.kate
    kdePackages.ksystemlog
    kdePackages.partitionmanager

    wayland-utils
    hplip # hp printer printing
    xsane # hp printer SANE scanning frontend
    kdePackages.skanlite # another frontend for SANE
  ];

  # Set environment variables
  environment.variables.EDITOR = "vim";
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Hint Electron apps to use Wayland

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false; # GTX 970 (Maxwell) is not supported by the open kernel modules
    nvidiaSettings = true;
    package = nvidiaPackages580.legacy_580;
  };

  # Enable OpenGL
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.tailscale = {
    enable = true;
    package = tailscalePkgs.tailscale;
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    openFirewall = true;
    capSysAdmin = true;
  };

  # Sunshine keeps persistent CUDA/NVENC contexts on the GPU; if they exist
  # during hibernation the NVIDIA driver deadlocks in uvm_suspend (SEGV in
  # nvidia-hibernate.service, seen on both 570.153.02 and 580.173.02) and the
  # whole hibernate chain aborts. Stop Sunshine before sleep and restart it
  # after resume, but only if it was actually running.
  systemd.services.sunshine-pre-sleep = {
    description = "Stop Sunshine before hibernation/suspend";
    wantedBy = [ "systemd-hibernate.service" "systemd-suspend.service" ];
    before = [
      "systemd-hibernate.service"
      "systemd-suspend.service"
      # must also run before the nvidia suspend hooks: they are only ordered
      # against systemd-hibernate/suspend.service themselves, so without this
      # they race us and can hit Sunshine's CUDA contexts while still live
      "nvidia-hibernate.service"
      "nvidia-suspend.service"
    ];
    serviceConfig.Type = "oneshot";
    script = ''
      if systemctl --user -M sun@ is-active --quiet sunshine.service 2>/dev/null; then
        touch /run/sunshine-was-running
        systemctl --user -M sun@ stop sunshine.service
      else
        rm -f /run/sunshine-was-running
      fi
    '';
  };
  systemd.services.sunshine-post-resume = {
    description = "Restart Sunshine after resume (if it was running)";
    requiredBy = [ "systemd-hibernate.service" "systemd-suspend.service" ];
    after = [
      "systemd-hibernate.service"
      "systemd-suspend.service"
      "nvidia-resume.service"
    ];
    serviceConfig.Type = "oneshot";
    # systemd-hibernate/suspend.service only complete after the image is
    # restored, so ExecStart here runs post-resume; tolerate the session
    # being gone (reboot etc.)
    script = ''
      if [ -e /run/sunshine-was-running ]; then
        rm -f /run/sunshine-was-running
        systemctl --user -M sun@ start sunshine.service || true
      fi
      # tailscaled's local DNS forwarder does not come back after resume
      # (nothing serves 100.100.100.100:53 and all name lookups fail until
      # restart); restart it so MagicDNS works again
      systemctl restart tailscaled.service || true
    '';
  };

  # The machine was powering itself back on shortly after shutdown/hibernate
  # (PCIe PME from the GPU when the monitor goes to standby, presumably).
  # Disable S4 wake via the GPU's PCIe root port; USB (XHC) stays enabled.
  systemd.services.disable-peg-wake = {
    description = "Disable PCIe (GPU) wake from S4/S5";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      for dev in PEG0 RP01 PXSX; do
        if grep -q "^$dev.*\*enabled" /proc/acpi/wakeup 2>/dev/null; then
          echo "$dev" > /proc/acpi/wakeup || true
        fi
      done
    '';
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
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
