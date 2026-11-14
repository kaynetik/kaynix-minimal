_: {
  programs.jjui = {
    enable = true;
    settings = {
      limit = 0;
      custom_commands = import ./custom-commands.nix;
      preview = {
        show_at_start = true;
        width_percentage = 60.0;
      };
      oplog.limit = 500;
      graph.batch_size = 100;
    };
  };
}
