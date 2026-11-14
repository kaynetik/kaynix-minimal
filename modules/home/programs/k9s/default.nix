{kaynixStatic, ...}: {
  xdg.configFile."k9s/config.yaml".text = ''
    k9s:
      ui:
        skin: catppuccin-frappe
  '';

  xdg.configFile."k9s/skins/catppuccin-frappe.yaml".source = "${kaynixStatic}/k9s/skins/catppuccin-frappe.yaml";
}
