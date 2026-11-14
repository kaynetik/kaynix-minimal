# To drop a program, remove its import (or its block below).
_: {
  imports = [
    ./identity.nix
    ./packages.nix
    ./programs/git
    ./programs/hunk
    ./programs/jjui
    ./programs/jujutsu
    ./programs/k9s
    ./programs/lazygit
    ./programs/neovim
    ./programs/sketchybar
    ./programs/ssh
    ./programs/terminals
    ./programs/yazi
    ./programs/zsh
  ];

  programs = {
    atuin = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    gh.enable = true;

    eza = {
      enable = true;
      enableZshIntegration = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
        "--hyperlink"
        "--follow-symlinks"
      ];
      git = true;
      icons = "auto";
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      # Atuin owns Ctrl-R. An empty command drops fzf's binding and the
      # Home Manager ownership warning.
      historyWidget.command = "";
      defaultOptions = [
        "--height 40%"
        "--layout=reverse"
        "--border"
        "--inline-info"
        "--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284"
        "--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf"
        "--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"
      ];
    };
  };

  home.shellAliases = {
    eld = "eza -lD --icons=auto";
    elf = "eza -lf --color=always --icons=auto | grep -v /";
    elh = "eza -dl .* --group-directories-first --icons=always";
    ell = "eza -al --group-directories-first --icons=always";
    els = "eza -alf --color=always --sort=size --icons=always | grep -v /";
    elt = "eza -lah --tree --level 2 --ignore-glob=.git";
    elt3 = "eza -lah --tree --level 3 --ignore-glob=.git";
  };
}
