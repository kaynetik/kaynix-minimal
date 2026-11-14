_: {
  # Analytics are not managed here: run `brew analytics off` once.
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      # "none" leaves existing Homebrew packages alone. Switch to "zap" to
      # uninstall everything not listed below, once the lists are complete.
      cleanup = "none";
      upgrade = true;
    };

    brews = [
      "keychain"
      "gnupg"
      "pinentry-mac"
      "secp256k1"
      "tor"
    ];

    casks = [
      # Browsers
      "brave-browser"
      "google-chrome"

      # Security
      # "keepassxc"
      "gpg-suite"
      # "protonvpn"
      "lulu"
      # "knockknock"
      # "dhs"
      # "whatsyoursign"
      "pareto-security"

      # Productivity
      "raycast"
      "obsidian"

      # Development
      "cursor"
      # "postman"
      # "figma"
      # "lens"

      # Fonts
      "sf-symbols"
      "font-sf-pro"
      "font-sf-mono"

      # Media
      # "calibre"
      "vlc"
      "spotify"
      # "gimp"
      "transmission"

      # Communication
      "telegram"
      "slack"
    ];
  };
}
