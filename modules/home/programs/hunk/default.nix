{
  lib,
  pkgs,
  ...
}: {
  home.packages = [pkgs.hunk];

  xdg.configFile."hunk/config.toml".source = (pkgs.formats.toml {}).generate "hunk-config" {
    theme = "graphite";
    mode = "auto";
    line_numbers = true;
    wrap_lines = false;
  };

  programs.git.settings.core.pager = "${lib.getExe pkgs.hunk} pager";
}
