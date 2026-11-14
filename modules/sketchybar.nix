{
  pkgs,
  username,
  ...
}: let
  luaLibDir = drv: "${drv}/lib/lua/${pkgs.lua5_5.luaversion}";
in {
  services.sketchybar = {
    enable = true;
    extraPackages = [pkgs.lua5_5 pkgs.sbarlua];
  };

  launchd.user.agents.sketchybar = {
    # The module's agent PATH has "$HOME"/"$USER" entries launchd never
    # expands, so widgets cannot reach per-user binaries (SwitchAudioSource,
    # jq, macmon) without this.
    path = ["/etc/profiles/per-user/${username}/bin"];
    # Where the Lua config (homes/static/sketchybar) finds the sbarlua module.
    environment.LUA_CPATH = builtins.concatStringsSep ";" [
      "${luaLibDir pkgs.lua5_5}/?.so"
      "${luaLibDir pkgs.lua5_5}/loadall.so"
      "${luaLibDir pkgs.sbarlua}/?.so"
      "./?.so"
    ];
  };
}
