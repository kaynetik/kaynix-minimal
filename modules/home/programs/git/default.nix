{
  config,
  kaynixStatic,
  ...
}: let
  identity = config.kaynix.identity;
  repoRoot = "${config.home.homeDirectory}/Development/Personal/kaynix-minimal";
in {
  home.file.".gitignore_global".source = "${kaynixStatic}/git/ignore_global";

  programs.git = {
    enable = true;
    lfs.enable = true;
    signing = {
      format = "openpgp";
      signByDefault = true;
      key = identity.pgp.signingKey;
    };
    # Hooks for this checkout only: a global core.hooksPath would hide other
    # repos' .git/hooks. Files under .githooks must be committed as 100755,
    # git silently skips non-executable hooks.
    includes = [
      {
        condition = "gitdir:${repoRoot}/";
        contents.core.hooksPath = "${repoRoot}/.githooks";
      }
    ];
    settings = {
      user = {
        inherit (identity) name email;
      };
      credential.helper = "osxkeychain";
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      core = {
        excludesFile = "${config.home.homeDirectory}/.gitignore_global";
        autocrlf = "input";
      };
      advice.detachedHead = false;
      http.postBuffer = "524288000";
    };
  };
}
