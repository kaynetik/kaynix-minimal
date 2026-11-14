{config, ...}: let
  identity = config.kaynix.identity;
in {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        inherit (identity) name email;
      };
      fetch.prune = true;
      init.default_branch = "main";
      lfs.enabled = true;
      signing = {
        backend = "ssh";
        key = identity.ssh.keyFile;
      };
      push = {
        autoSetupRemote = true;
        default = "current";
      };
      rebase.auto_stash = true;
      ui.default-command = "log";
    };
  };

  home.shellAliases.jj = "RAYON_NUM_THREADS=4 command jj";
}
