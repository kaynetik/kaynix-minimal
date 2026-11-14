{
  lib,
  pkgs,
  kaynixStatic,
  ...
}: let
  # Vendored FelixKratz event provider: pushes en0 throughput to sketchybar.
  # items/widgets/wifi.lua spawns it from the LaunchAgent PATH.
  network-load = pkgs.stdenv.mkDerivation {
    pname = "sketchybar-network-load";
    version = "0-unstable-2026-07-04";
    src = ./network_load;

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild
      $CC -std=c99 -O3 network_load.c -o network_load
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm755 network_load $out/bin/network_load
      runHook postInstall
    '';

    meta = {
      description = "SketchyBar network throughput event provider";
      platforms = lib.platforms.darwin;
      mainProgram = "network_load";
    };
  };
in {
  home.packages = [network-load];

  # The bar itself is the nix-darwin service in modules/sketchybar.nix.
  xdg.configFile."sketchybar" = {
    source = "${kaynixStatic}/sketchybar";
    recursive = true;
  };
}
