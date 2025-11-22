{ config, pkgs, ... }:
{
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
