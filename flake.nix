{
  description = "Minimal nix-darwin + Home Manager flake [kaynix-minimal]";

  inputs = {
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  outputs = {
    nixpkgs-darwin,
    darwin,
    home-manager,
    ...
  }: let
    # Change these three for a new machine or user.
    system = "aarch64-darwin";
    hostname = "mbp";
    username = "kaynetik";

    # Lint shell on the host and on Linux, where CI runs the pre-commit hooks.
    eachLintSystem = f:
      nixpkgs-darwin.lib.genAttrs [system "x86_64-linux"]
      (s: f nixpkgs-darwin.legacyPackages.${s});
  in {
    darwinConfigurations.${hostname} = darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {inherit hostname username;};
      modules = [
        ./modules/nix-core.nix
        ./modules/system.nix
        ./modules/pki.nix
        ./modules/homebrew.nix
        ./modules/sketchybar.nix
        ./modules/aerospace.nix

        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "hm-backup";
            extraSpecialArgs = {
              inherit username;
              kaynixStatic = ./homes/static;
            };
            users.${username} = import ./homes/kaynetik.nix;
          };
        }
      ];
    };

    # Tools the pre-commit hooks call (see .pre-commit-config.yaml).
    devShells = eachLintSystem (pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          alejandra
          statix
          deadnix
          gitleaks
          shellcheck
          stylua
          pre-commit
        ];
      };
    });

    formatter = eachLintSystem (pkgs: pkgs.alejandra);
  };
}
