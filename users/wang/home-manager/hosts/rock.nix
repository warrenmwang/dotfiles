{ pkgs, config, ... }:
{
  imports = [
    ../default.nix
    ../dotfiles.nix
  ];

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
