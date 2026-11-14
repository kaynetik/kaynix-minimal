# kaynix-minimal

Minimal [nix-darwin](https://github.com/nix-darwin/nix-darwin) flake with [Home Manager](https://github.com/nix-community/home-manager), built around [AeroSpace](https://github.com/nikitabobko/AeroSpace) and [SketchyBar](https://github.com/FelixKratz/SketchyBar). One host, one user, no secrets management.

## Prerequisites

Apple Silicon Mac with [Lix](https://lix.systems/) and [Homebrew](https://brew.sh/) installed:

```bash
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Setup

1. Clone to this exact path. The git hooks and the `nvim-lazy-update` script reference it.

   ```bash
   git clone https://github.com/kaynetik/kaynix-minimal.git ~/Development/Personal/kaynix-minimal
   cd ~/Development/Personal/kaynix-minimal
   ```

2. Replace the original author's values with your own.

   | What                                           | Where                                |
   | ---------------------------------------------- | ------------------------------------ |
   | `username`, `hostname`                         | top of `outputs` in `flake.nix`      |
   | Git name, email, PGP signing key, ssh key path | `modules/home/identity.nix`          |
   | Time zone, DNS servers, macOS defaults         | `modules/system.nix`                 |
   | Homebrew apps                                  | `modules/homebrew.nix`               |
   | CLI packages                                   | `modules/home/packages.nix`          |
   | Keybindings, workspaces, startup commands      | `modules/aerospace.nix`              |

   > [!WARNING]
   > Git signs every commit with the PGP key in `modules/home/identity.nix`. Without that key on your machine, `git commit` fails. Set your own key id, or set `signByDefault = false` in `modules/home/programs/git/default.nix`.

3. Build and switch. Use your `hostname` in place of `mbp`.

   ```bash
   nix build .#darwinConfigurations.mbp.system
   sudo ./result/sw/bin/darwin-rebuild switch --flake .#mbp
   ```

After the first switch, apply changes with:

```bash
sudo darwin-rebuild switch --flake .#mbp
```

## Layout

| Path                         | Purpose                                                  |
| ---------------------------- | -------------------------------------------------------- |
| `flake.nix`                  | Inputs, the darwin system, lint shell                    |
| `modules/aerospace.nix`      | Tiling window manager and keybindings                    |
| `modules/sketchybar.nix`     | Bar service; its config is `homes/static/sketchybar/`    |
| `modules/system.nix`         | macOS defaults, networking, fonts, `system.stateVersion` |
| `modules/nix-core.nix`       | Nix settings and garbage collection                      |
| `modules/homebrew.nix`       | Casks and brews                                          |
| `modules/pki.nix`            | CA bundle hardening                                      |
| `modules/home/`              | Home Manager modules: packages, identity, `programs/*`   |
| `homes/kaynetik.nix`         | Home Manager entry point, `home.stateVersion`            |
| `homes/static/`              | Dotfiles: nvim, tmux, alacritty, sketchybar, zsh, git    |
| `scripts/`                   | Helper scripts installed into `home.packages`            |

## Maintenance

- **Update**: run `nix flake update`, then switch. If a package fails to build, remove it from `modules/home/packages.nix` or restore `flake.lock` with git.
- **Remove a program**: delete its import or block in `modules/home/default.nix`.
- **Local config**: zsh sources `~/.config/zsh/conf-*.zsh` and ssh includes `~/.ssh/conf.d/*`. Neither is tracked here.
- **SketchyBar theme**: set the default palette in `homes/static/sketchybar/colors.lua`.
- **Homebrew cleanup**: `cleanup = "none"` in `modules/homebrew.nix` keeps packages installed by hand. `"zap"` uninstalls everything not listed.
- **State versions**: `system.stateVersion` and `home.stateVersion` pin stateful defaults. Read the release notes before raising them on an existing install.
- **Lint**: `nix develop -c pre-commit run --all-files`.
