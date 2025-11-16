{
  config,
  pkgs,
  ...
}:

let
  mkSymlink = path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/${path}";
in
{
  home.username = "wang";
  home.homeDirectory = "/home/wang";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };

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
    # global packages for nvim default lsps, use devshells for per project needs
    # NOTE: do NOT use Mason to install any lsps, formatters, linters, etc.
    # look into https://github.com/BirdeeHub/nixCats-nvim if need it
    #
    gcc
    clang-tools
    lua-language-server
    nixfmt-rfc-style

    kitty
    ghostty
    vscode
    zed-editor
    evil-helix
    neovim
    neovide
    yazi
    hyperfine

    obsidian
    google-chrome
    brave
    parsec-bin
    kdePackages.kcalc
    protonvpn-gui
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
    kdePackages.ark # zip archive tool

    # Printer / Scanning
    hplip
    kdePackages.skanlite

    prismlauncher # open source minecraft launcher

    fastfetch
    cbonsai
    asciiquarium
  ];

  home.file = {
    ".icons/default".source = mkSymlink "./icons/Rage-Gothic-Light";
    ".config/hypr".source = mkSymlink "./config/hypr";
    ".config/waybar".source = mkSymlink "./config/waybar";
    ".config/mako".source = mkSymlink "./config/mako";
    ".bashrc".source = mkSymlink "./config/.bashrc";
    ".config/git/config".source = mkSymlink "./config/.gitconfig";
    ".config/nushell/config.nu".source = mkSymlink "./config/nushell/config.nu";
    ".config/nushell/env.nu".source = mkSymlink "./config/nushell/env.nu";
    ".config/tmux/tmux.conf".source = mkSymlink "./config/tmux/tmux.conf";
    ".config/kitty/kitty.conf".source = mkSymlink "./config/kitty/kitty.conf";
    ".config/nvim".source = mkSymlink "./config/nvim";
    ".config/Code/User/settings.json".source = mkSymlink "./config/vscode/settings.json";
    ".config/Code/User/keybindings.json".source = mkSymlink "./config/vscode/keybindings.json";
    "bin".source = mkSymlink "./bin";
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

        "image/jpeg" = "org.kde.gwenview.desktop";
        "image/png" = "org.kde.gwenview.desktop";
        "image/gif" = "org.kde.gwenview.desktop";
        "image/webp" = "org.kde.gwenview.desktop";
        "image/avif" = "org.kde.gwenview.desktop";
        "image/svg+xml" = "org.kde.gwenview.desktop";

        "video/mp4" = "vlc.desktop";
        "video/x-matroska" = "vlc.desktop";
        "video/webm" = "vlc.desktop";
        "video/quicktime=" = "vlc.desktop";

        "audio/mpeg" = "vlc.desktop";
        "audio/wav" = "vlc.desktop";
        "audio/mp4" = "vlc.desktop";
        "audio/flac" = "vlc.desktop";

        "application/pdf" = "org.kde.okular.desktop";

        "application/zip" = "org.kde.ark.desktop";
        "application/x-tar" = "org.kde.ark.desktop";
        "application/x-7z-compressed" = "org.kde.ark.desktop";

        "inode/directory" = "org.kde.dolphin.desktop";

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
