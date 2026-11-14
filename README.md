# kaynix-minimal

Minimal [nix-darwin](https://github.com/nix-darwin/nix-darwin) flake with [Home Manager](https://github.com/nix-community/home-manager), built around [AeroSpace](https://github.com/nikitabobko/AeroSpace) and [SketchyBar](https://github.com/FelixKratz/SketchyBar). One host (`mbp`, `aarch64-darwin`), one user, no secrets management.

## Prerequisites

1. Install [Lix](https://lix.systems/):

   ```bash
   curl -sSf -L https://install.lix.systems/lix | sh -s -- install
   ```

2. Install [Homebrew](https://brew.sh/), which `modules/homebrew.nix` needs for casks and brews:

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

## Deploy

Hostname and username are set at the top of the `outputs` block in `flake.nix`.

```bash
git clone https://github.com/kaynetik/kaynix-minimal.git ~/Development/Personal/kaynix-minimal
cd ~/Development/Personal/kaynix-minimal

# First run: bootstraps nix-darwin and Home Manager
nix build .#darwinConfigurations.mbp.system
sudo ./result/sw/bin/darwin-rebuild switch --flake .#mbp

# Afterwards
sudo darwin-rebuild switch --flake .#mbp
```

The clone path matters: `modules/home/programs/git` and `modules/home/packages.nix` reference `~/Development/Personal/kaynix-minimal`.

## Make it yours

Before the first switch, change what is specific to the original author:

| What | Where |
| --- | --- |
| `username`, `hostname`, `system` | top of `outputs` in `flake.nix` |
| Git name, email, PGP signing key, ssh key path | `modules/home/identity.nix` |
| Commit signing (needs that PGP key to exist) | `signing` in `modules/home/programs/git/default.nix` |
| Time zone, DNS servers, macOS defaults | `modules/system.nix` |
| Apps installed through Homebrew | `modules/homebrew.nix` |
| CLI packages | `modules/home/packages.nix` |
| Keybindings, workspaces, startup commands | `modules/aerospace.nix` |

Rename `homes/kaynetik.nix` if you like; it is imported once, in `flake.nix`.

## Layout

```text
.
├── flake.nix          # inputs, package overlay, the darwin system, lint shell
├── modules/           # nix-darwin modules
│   ├── aerospace.nix  # tiling WM, keybindings
│   ├── sketchybar.nix # bar service (config: homes/static/sketchybar)
│   ├── system.nix     # macOS defaults, networking, fonts, stateVersion
│   ├── nix-core.nix   # nix settings, GC
│   ├── homebrew.nix   # casks and brews
│   ├── pki.nix        # CA bundle hardening
│   └── home/          # Home Manager: packages.nix, identity.nix, programs/*
├── homes/
│   ├── kaynetik.nix   # Home Manager entry point, stateVersion
│   └── static/        # dotfiles: nvim, tmux, alacritty, sketchybar, zsh, git
└── scripts/           # helper scripts installed into home.packages
```

## Maintenance

- **Local, untracked config**: zsh sources `~/.config/zsh/conf-*.zsh` and ssh includes `~/.ssh/conf.d/*`. Put machine or work specific settings there.
- **Removing a program**: delete its import or block in `modules/home/default.nix`.
- **SketchyBar theme**: the default palette is set in `homes/static/sketchybar/colors.lua`.
- **Updating**: `nix flake update`, then rebuild. If a package fails to build after an update, remove it from `modules/home/packages.nix` or roll back `flake.lock` with git.
- **Homebrew cleanup**: `modules/homebrew.nix` uses `cleanup = "none"`, so packages installed by hand are kept. `"zap"` makes the lists authoritative and uninstalls everything else.
- **State versions**: `system.stateVersion` (`modules/system.nix`) and `home.stateVersion` (`homes/kaynetik.nix`) pin stateful defaults. Do not raise them on an existing install without reading the release notes.
- **Linting**: `nix develop -c pre-commit run --all-files`.
