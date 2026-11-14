{
  config,
  lib,
  username,
  ...
}: let
  home = config.home.homeDirectory;
in {
  imports = [../modules/home];

  programs.home-manager.enable = true;

  home.username = username;
  home.homeDirectory = "/Users/${username}";
  # Pins stateful defaults to a Home Manager release. Read the release notes
  # before raising it on an existing install.
  home.stateVersion = "26.11";
  home.enableNixpkgsReleaseCheck = false;

  xdg.enable = true;

  home.sessionPath = [
    "${home}/.cargo/bin"
    "${home}/go/bin"
    "${home}/.local/bin"
  ];

  home.activation.userDirectories = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run mkdir -p \
      "${home}/Development/Work" \
      "${home}/Development/Personal" \
      "${home}/Development/Nix/flakes" \
      "${home}/Development/Nix/shells"
  '';
}
