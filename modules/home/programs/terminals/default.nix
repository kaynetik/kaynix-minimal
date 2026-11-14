{
  config,
  kaynixStatic,
  ...
}: {
  xdg.configFile."alacritty/alacritty.toml".source = "${kaynixStatic}/alacritty/alacritty.toml";
  xdg.configFile."alacritty/catppuccin-frappe.toml".source = "${kaynixStatic}/alacritty/catppuccin-frappe.toml";

  # Rendered, not linked: tmux does not expand $HOME inside plugin option
  # strings, so @HOME@ is substituted here.
  xdg.configFile."tmux/tmux.conf".text =
    builtins.replaceStrings ["@HOME@"] [config.home.homeDirectory]
    (builtins.readFile "${kaynixStatic}/tmux/tmux.conf");
}
