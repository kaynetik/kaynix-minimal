# Who commits, signs, and authenticates from this machine. Read by git,
# jujutsu, and ssh. homes/static/git/template.gitconfig repeats these values
# and must be kept in sync by hand.
{
  config,
  lib,
  ...
}: {
  options.kaynix.identity = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "kaynetik";
    };

    email = lib.mkOption {
      type = lib.types.str;
      default = "aleksandar@nesovic.dev";
    };

    pgp.signingKey = lib.mkOption {
      type = lib.types.str;
      default = "FC04210D2782C032";
      description = "Long key id that signs git commits (fingerprint 3E32D82218ED44AA9E8C147DFC04210D2782C032).";
    };

    ssh.keyFile = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/.ssh/prim_sk_id_ed25519";
      description = "Primary ssh private key: jj signing key and GitHub IdentityFile.";
    };
  };
}
