{
  config,
  lib,
  pkgs,
  kaynixStatic,
  ...
}: let
  zdir = "${config.xdg.configHome}/zsh";
in {
  # aliases, history options, prompt libraries, fzf-tab styling.
  xdg.configFile."zsh" = {
    source = "${kaynixStatic}/zsh";
    recursive = true;
  };

  programs.zsh = {
    enable = true;
    # compinit is deferred through zinit below.
    enableCompletion = false;
    dotDir = zdir;
    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # Static expansion of `eval "$(brew shellenv)"`, which saves two forks
        # per shell. Re-check against `brew shellenv` if Homebrew relocates.
        export HOMEBREW_PREFIX="/opt/homebrew"
        export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
        export HOMEBREW_REPOSITORY="/opt/homebrew"
        export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
        export INFOPATH="/opt/homebrew/share/info:''${INFOPATH:-}"
        [ -z "''${MANPATH-}" ] || export MANPATH=":''${MANPATH#:}"
        fpath[1,0]="/opt/homebrew/share/zsh/site-functions"

        source ${pkgs.zinit}/share/zinit/zinit.zsh

        # -C skips the compaudit pass unless the dump is missing or older
        # than 24h; -u trusts nix-store fpath dirs.
        _kaynix_compinit() {
          setopt localoptions extendedglob
          autoload -Uz compinit
          local zcd=''${ZDOTDIR:-$HOME}/.zcompdump
          if [[ ! -f $zcd || -n $zcd(#qN.mh+24) ]]; then
            compinit -u -d "$zcd"
          else
            compinit -C -u -d "$zcd"
          fi
        }

        # Turbo-loaded after the first prompt. Order matters: fzf-tab needs
        # compinit before it, the widget-wrapping plugins come after it, and
        # zicdreplay replays compdefs queued by atuin, fzf, and zoxide.
        zinit ice wait'0a' lucid atinit'_kaynix_compinit; zicdreplay'
        zinit light Aloxaf/fzf-tab
        zinit ice wait'0b' lucid
        zinit light zdharma-continuum/fast-syntax-highlighting
        zinit ice wait'0c' lucid atload'_zsh_autosuggest_start'
        zinit light zsh-users/zsh-autosuggestions

        source ${zdir}/fzf-tab.zsh
        ulimit -n 65536
        source ${zdir}/setopt-history.zsh
        source ${zdir}/aliases.zsh
      '')
      (lib.mkOrder 550 ''
        export GPG_TTY=$TTY
        autoload -Uz colors && colors
        setopt prompt_subst

        # Unmanaged local fragments (work env, KUBE_CTX_ALIASES); never tracked
        # in the repo. Must precede lib-kube-prompt.
        for f in ${zdir}/conf-*.zsh(N); do source "$f"; done; unset f

        source ${zdir}/lib-git-prompt.zsh
        source ${zdir}/lib-kube-prompt.zsh
        source ${zdir}/theme-bira.zsh
      '')
      ''
        bindkey '^[[1;9A' beginning-of-line
        bindkey '^[[1;9B' end-of-line
      ''
      # nix openssh ahead of /usr/bin/ssh, matching the agent in ../ssh.
      (lib.mkAfter ''
        export PATH="${pkgs.openssh}/bin:$PATH"
      '')
    ];
  };
}
