{
  pkgs,
  hostname,
  username,
  ...
}: {
  # Pins stateful defaults to a nix-darwin release. Read the nix-darwin
  # changelog before raising it on an existing install.
  system.stateVersion = 7;
  system.primaryUser = username;

  users.users.${username}.home = "/Users/${username}";

  time.timeZone = "Europe/Belgrade";

  networking = {
    hostName = hostname;
    computerName = hostname;
    # From `networksetup -listallnetworkservices`. VPN services are left out
    # so they keep managing their own DNS.
    knownNetworkServices = ["Wi-Fi" "Thunderbolt Bridge"];
    dns = ["1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4"];
  };

  fonts.packages =
    [pkgs.sketchybar-app-font]
    ++ (with pkgs.nerd-fonts; [jetbrains-mono fira-code meslo-lg]);

  system.defaults = {
    menuExtraClock.Show24Hour = true;

    trackpad = {
      Clicking = true;
      Dragging = true;
      TrackpadRightClick = true;
    };

    dock = {
      autohide = true;
      magnification = true;
      mru-spaces = false;
      tilesize = 32;
      largesize = 96;
    };

    # Hidden in favour of sketchybar.
    NSGlobalDomain._HIHideMenuBar = true;

    screencapture.location = "~/Pictures/screenshots";
    screensaver.askForPasswordDelay = 15;

    finder = {
      ShowStatusBar = true;
      ShowPathbar = true;
      FXPreferredViewStyle = "clmv";
      _FXShowPosixPathInTitle = true;
      AppleShowAllExtensions = true;
    };

    loginwindow.LoginwindowText = "nixing";
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  programs.zsh.enable = true;
  # Home Manager's zsh config runs compinit itself (deferred).
  programs.zsh.enableGlobalCompInit = false;
}
