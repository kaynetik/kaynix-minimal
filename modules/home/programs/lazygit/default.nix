_: {
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        nerdFontsVersion = "3";
        showListFooter = false;
        showRandomTip = false;
        expandFocusedSidePanel = true;
        shortTimeFormat = "15:04";
        # Must sit under gui.theme: lazygit >= 0.66 otherwise tries to migrate
        # the config file, which is a read-only store symlink.
        theme.branchColorPatterns = {
          "^main$" = "#ed8796";
          "^master$" = "#ed8796";
          "^dev" = "#8bd5ca";
        };
      };
      git = {
        overrideGpg = true;
        autoFetch = false;
        mainBranches = ["main" "master" "develop"];
      };
      os.editPreset = "nvim";
      customCommands = import ./custom-commands.nix;
    };
  };
}
