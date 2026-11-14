{pkgs, ...}: let
  # Upstream flavor pack; bump rev and hash together.
  yaziFlavors = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "flavors";
    rev = "06708015bfb53b169d99bb3907829f9175105d57";
    hash = "sha256-Gm6ThktOLUR+KDs6f3s1WCgrw2TOKQ4tolVvVdCxnCM=";
  };
in {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";

    # Previewer/opener helpers exposed only on yazi's PATH.
    extraPackages = with pkgs; [
      ffmpegthumbnailer
      jq
      poppler-utils
      fd
      ripgrep
      fzf
      zoxide
      mediainfo
      ouch
      imagemagick
    ];

    plugins = {
      inherit
        (pkgs.yaziPlugins)
        chmod
        full-border
        git
        jump-to-char
        lazygit
        mediainfo
        mount
        ouch
        piper
        smart-enter
        smart-paste
        starship
        ;
    };

    flavors = {
      catppuccin-mocha = "${yaziFlavors}/catppuccin-mocha.yazi";
    };

    settings = {
      mgr = {
        show_hidden = true;
        show_symlink = true;
        sort_by = "natural";
        sort_dir_first = true;
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
    };

    theme = {
      flavor = {
        dark = "catppuccin-mocha";
      };
    };

    keymap = {
      mgr.prepend_keymap = [
        {
          on = "G";
          run = "plugin lazygit";
          desc = "Open lazygit";
        }
        {
          on = ["c" "m"];
          run = "plugin chmod";
          desc = "chmod selection";
        }
        {
          on = "<Enter>";
          run = "plugin smart-enter";
          desc = "Enter dir or open file";
        }
        {
          on = "p";
          run = "plugin smart-paste";
          desc = "Paste into hovered dir";
        }
        {
          on = "f";
          run = "plugin jump-to-char";
          desc = "Jump to char";
        }
      ];
    };

    initLua = ''
      require("full-border"):setup()
      require("git"):setup()
      require("starship"):setup()
    '';
  };
}
