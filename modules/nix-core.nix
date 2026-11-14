{
  pkgs,
  username,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  nix = {
    enable = true;
    package = pkgs.nix;

    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = [username];
      builders-use-substitutes = false;
      max-jobs = 8;
      cores = 0;
      # Corrupts the store on macOS: https://github.com/NixOS/nix/issues/7273
      auto-optimise-store = false;
      warn-dirty = false;
    };

    # Monthly, on day 1 at 15:15.
    gc = {
      automatic = true;
      interval = {
        Day = 1;
        Hour = 15;
        Minute = 15;
      };
      options = "--delete-older-than 30d";
    };
  };
}
