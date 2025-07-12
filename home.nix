{ config, pkgs, ... } : {
  home.username = "wang";
  home.homeDirectory = "/home/wang";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";

  home.packages = with pkgs; [
    kitty
    vscode
    zed-editor
    helix
    neovim
    neovide

    obsidian
    google-chrome

    obs-studio
    audacity

    # editting tools
    shotcut
    gimp

    # drawing tools
    aseprite
    krita
    xournalpp
    kdePackages.kolourpaint

    # file tools
    xfce.thunar        # file explorer
    xfce.tumbler       # d-bus thumbnailer service (for thunar)
    xfce.thunar-volman # thunar extension (removeablle media management)
    kdePackages.okular # PDF viewer
    eog                # image viewer
    vlc                # video, sound viewer
    kdePackages.ark    # zip archive tool

    # office
    hplip
    kdePackages.skanlite

    prismlauncher # open source minecraft launcher
  ];

  # how lovely, i needed to find this thread to learn about this symlink magic
  # https://discourse.nixos.org/t/how-to-manage-dotfiles-with-home-manager/30576/7
  # manual and llms didn't give it to me.
  home.file = {
    ".config/hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/hypr";
    };
    ".config/waybar" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/waybar";
    };
    ".config/nushell/config.nu" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nushell/config.nu";
    };
    ".config/nushell/env.nu" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nushell/env.nu";
    };
    ".config/tmux/tmux.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/tmux/tmux.conf";
    };
    ".config/kitty/kitty.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/kitty/kitty.conf";
    };
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim-plain";
    };
    ".config/Code/User/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/vscode/settings.json";
    };
    ".config/Code/User/keybindings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/vscode/keybindings.json";
    };
    "bin" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/bin";
    };
  };

  programs.git = {
    enable = true;
    userName = "Warren Wang";
    userEmail = "warren.min.wang@gmail.com";
    aliases = {
      a = "add";
      s = "status";
      d = "diff";
      l = "log";
      ci = "commit";
      co = "checkout";
    };
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      push = {
        autoSetupRemote = true;
        default = "current";
      };
    };
  };

  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "google-chrome.desktop";
        "x-scheme-handler/http" = "google-chrome.desktop";
        "x-scheme-handler/https" = "google-chrome.desktop";
        "x-scheme-handler/about" = "google-chrome.desktop";
        "x-scheme-handler/unknown" = "google-chrome.desktop";

        "text/plain" = "code.desktop";
        "text/x-python" = "code.desktop";
        "text/javascript" = "code.desktop";
        "text/json" = "code.desktop";
        "text/csv" = "code.desktop";
        "text/css" = "code.desktop";
        "text/xml" = "code.desktop";
        "text/x-c" = "code.desktop";
        "text/x-c++" = "code.desktop";
        "text/rust" = "code.desktop";
        "text/bash" = "code.desktop";
        "text/nu" = "code.desktop";
        "application/x-shellscript" = "code.desktop";
        
        "image/jpeg" = "eog.desktop";
        "image/png" = "eog.desktop";
        "image/gif" = "eog.desktop";
        "image/webp" = "eog.desktop";
        "image/avif" = "eog.desktop";
        "image/svg+xml" = "eog.desktop";
        
        "video/mp4" = "vlc.desktop";
        "video/x-matroska" = "vlc.desktop";
        "video/webm" = "vlc.desktop";
        
        "audio/mpeg" = "vlc.desktop";
        "audio/wav" = "vlc.desktop";
        "audio/mp4" = "vlc.desktop";
        "audio/flac" = "vlc.desktop";
        
        "application/pdf" = "org.kde.okular.desktop";
        
        "application/zip" = "org.kde.ark.desktop";
        "application/x-tar" = "org.kde.ark.desktop";
        "application/x-7z-compressed" = "org.kde.ark.desktop";
        
        "inode/directory" = "thunar.desktop";
      };
    };
    
    userDirs = {
      enable = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland

    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";
    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
    
    BROWSER = "google-chrome-stable";
    TERMINAL = "kitty";
    EDITOR = "vim";
    PAGER = "vim";
    VISUAL = "code";
    FILE_MANAGER = "thunar";
  };
}
