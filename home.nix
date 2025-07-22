{ config, pkgs, ... } : {
  home.username = "wang";
  home.homeDirectory = "/home/wang";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";

  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
        darkreader
        vimium
      ];
    };
  };

  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings = {
        # Turn off notification sound/alert
        "mail.biff.play_sound" = false;
        "mail.biff.show_alert" = false;

        "mailnews.default_sort_type" = 18; # 18 = threaded view
        "mailnews.default_sort_order" = 2; # 1 = ascending, 2 = descending
        "mailnews.thread_pane_column_unthreads" = false;
        "mail.thread_without_re" = true;
        "mailnews.scroll_to_new_message" = true;
        "mail.showCondensedAddresses" = true;
      };
    };
  };

  home.packages = with pkgs; [
    # global packages honestly just for nvim right now...use devshells for per project deps management.
    # TODO: look into https://github.com/BirdeeHub/nixCats-nvim
    # i am indeed having Mason issues and other whatnots like lua_lsp, rust_analyzer lsp's not being able to run bc they are dynamically linked...
    gcc
    nodejs_24
    python3

    kitty
    vscode
    zed-editor
    # helix
    evil-helix
    neovim
    # neovide
    yazi
    hyperfine

    obsidian
    google-chrome
    parsec-bin
    gnome-calculator

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

    # files
    xfce.thunar        # file explorer
    xfce.tumbler       # d-bus thumbnailer service (for thunar)
    xfce.thunar-volman # thunar extension (removeablle media management)
    kdePackages.okular # PDF viewer
    eog                # image viewer
    vlc                # video, sound viewer
    kdePackages.ark    # zip archive tool

    # physical office
    hplip
    kdePackages.skanlite

    prismlauncher # open source minecraft launcher

    fastfetch
    cbonsai
    asciiquarium
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
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim";
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
      cm = "commit -m";
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
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";

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

        "x-scheme-handler/mailto" = "thunderbird.desktop";
        "message/rfc822" = "thunderbird.desktop";
        "application/x-extension-eml" = "thunderbird.desktop";
      
        "text/calendar" = "thunderbird.desktop";
        "application/x-extension-ics" = "thunderbird.desktop";
        "x-scheme-handler/webcal" = "thunderbird.desktop";
        "x-scheme-handler/webcals" = "thunderbird.desktop";
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

}
