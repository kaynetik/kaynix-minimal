{
  config,
  lib,
  pkgs,
  ...
}: let
  identity = config.kaynix.identity;
  sshDir = "${config.home.homeDirectory}/.ssh";
  agentSocket = "${sshDir}/nix-ssh-agent.sock";
  github = host: {
    HostName = host;
    User = "git";
    IdentityFile = identity.ssh.keyFile;
    IdentitiesOnly = true;
  };
in {
  home.activation.sshSocketDir = lib.hm.dag.entryBefore ["linkGeneration"] ''
    run mkdir -p "${sshDir}/sockets"
    run chmod 700 "${sshDir}/sockets"
  '';

  # One launchd-supervised ssh-agent per login on a fixed socket, instead of
  # shells probing for or spawning agents. Keys are added on first use
  # (AddKeysToAgent).
  launchd.agents.nix-ssh-agent = {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        ''rm -f "${agentSocket}"; exec ${pkgs.openssh}/bin/ssh-agent -D -a "${agentSocket}"''
      ];
      KeepAlive = true;
      RunAtLoad = true;
    };
  };

  home.sessionVariables.SSH_AUTH_SOCK = agentSocket;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        ControlMaster = "auto";
        ControlPath = "~/.ssh/sockets/%r@%h-%p";
        ControlPersist = "10m";
        IgnoreUnknown = "UseKeychain";
        UseKeychain = "yes";
        AddKeysToAgent = "yes";
        ServerAliveInterval = 60;
        ServerAliveCountMax = 3;
      };
      "github.com" = github "github.com";
      "gist.github.com" = github "gist.github.com";
    };
    # Unmanaged per-host config; nothing here is tracked in the repo.
    extraConfig = lib.mkBefore ''
      Include ~/.ssh/conf.d/*
    '';
  };
}
