{ pkgs, lib, config, nix-openclaw, ... }:
{
  imports = [
    ../default.nix
    ../dotfiles.nix
    nix-openclaw.homeManagerModules.openclaw
  ];

  programs.openclaw = {
    enable = true;
    package = nix-openclaw.packages.x86_64-linux.openclaw;
    bundledPlugins.goplaces.enable = false;

    config = {
      gateway = {
        mode = "local";
        bind = "lan";
        auth.mode = "token";
        controlUi = {
          enabled = true;
          allowInsecureAuth = true;
          dangerouslyDisableDeviceAuth = true;
          allowedOrigins = [
            "http://rock:18789"
            "http://rock.local:18789"
            "http://192.168.0.88:18789"
          ];
        };
      };

      channels.discord.accounts.default = {
        enabled = true;
        dmPolicy = "pairing";
        # Set allowFrom after setup with your Discord user ID
        # allowFrom = [ "YOUR_DISCORD_USER_ID" ];
      };

      models.providers.ollama = {
        api = "ollama";
        baseUrl = "http://127.0.0.1:11434";
        models = [
          {
            id = "qwen3:8b";
            name = "Qwen 3 8B";
          }
        ];
      };

      agents.defaults = {
        model = "ollama/qwen3:8b";
      };

    };

    # Discord bot token loaded from env file
    systemd.enable = true;
  };

  # Patch missing plugin manifests: the nix package puts them in extensions/ but
  # the gateway looks in dist/extensions/. We create a mutable merged tree and
  # point the gateway at it via a wrapper.
  home.activation.openclawPluginManifests = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    gw_store="${nix-openclaw.packages.x86_64-linux.openclaw-gateway}/lib/openclaw"
    merged="$HOME/.openclaw/gateway-merged"
    chmod -R u+w "$merged" 2>/dev/null || true
    rm -rf "$merged"
    mkdir -p "$merged"
    # Copy dist as a real directory tree so __dirname resolves here, not the store
    cp -r "$gw_store/dist" "$merged/dist"
    chmod -R u+w "$merged/dist"
    # Overlay the manifests from extensions/ into dist/extensions/
    if [ -d "$gw_store/extensions" ]; then
      for ext_dir in "$gw_store/extensions"/*/; do
        ext_name="$(basename "$ext_dir")"
        manifest="$ext_dir/openclaw.plugin.json"
        target="$merged/dist/extensions/$ext_name/openclaw.plugin.json"
        if [ -f "$manifest" ] && [ -d "$merged/dist/extensions/$ext_name" ] && [ ! -e "$target" ]; then
          cp "$manifest" "$target"
        fi
      done
    fi
    # Copy other top-level dirs
    for item in "$gw_store"/*; do
      name="$(basename "$item")"
      [ "$name" = "dist" ] && continue
      [ -e "$merged/$name" ] && continue
      ln -s "$item" "$merged/$name"
    done
  '';

  # Load Discord bot token and point gateway at merged tree with plugin manifests
  systemd.user.services.openclaw-gateway = {
    Service.EnvironmentFile = [ "/home/wang/.secrets/openclaw/env" ];
    Service.ExecStart = lib.mkForce "${pkgs.nodejs_22}/bin/node /home/wang/.openclaw/gateway-merged/dist/index.js gateway --port 18789";
    Unit = {
      After = [ "ollama.service" ];
      Wants = [ "ollama.service" ];
    };
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      PS1='\[\e]0;\u@\h: \w\a\]\[\033[1;32m\][\u@\[\033[1;31m\]\h\[\033[1;32m\]\[\033[37m\]:\w\[\033[1;32m\]]\$\[\033[0m\] '
      alias l="ls -a"
      alias ll="ls -al"
      alias cls="clear"
      alias n="nvim"
      alias c="code"
      alias y="yazi"
    '';
  };
}
