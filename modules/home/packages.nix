{
  config,
  pkgs,
  ...
}: let
  dotNixRoot = "${config.home.homeDirectory}/Development/Personal/kaynix-minimal";
  obsidianVault = "${config.home.homeDirectory}/Documents/obsidian_vault";

  kaynix-scripts = pkgs.runCommand "kaynix-scripts" {} ''
    mkdir -p $out/bin
    install -m755 ${../../scripts/count-loc} $out/bin/count-loc
    install -m755 ${../../scripts/objsee-check} $out/bin/objsee-check
    install -m755 ${../../scripts/on} $out/bin/on
    install -m755 ${../../scripts/og} $out/bin/og
    cp ${../../scripts/nvim-lazy-update} $out/bin/nvim-lazy-update
    chmod +x $out/bin/nvim-lazy-update
    substituteInPlace $out/bin/nvim-lazy-update \
      --replace-fail '@DOT_NIX_ROOT@' '${dotNixRoot}'
    substituteInPlace $out/bin/on \
      --replace-fail '@OBSIDIAN_VAULT@' '${obsidianVault}'
    substituteInPlace $out/bin/og \
      --replace-fail '@OBSIDIAN_VAULT@' '${obsidianVault}'
  '';

  terminal = with pkgs; [
    alacritty
    zinit
    tmux
    htop
    btop
    bat
    fd
    ripgrep
    tree
  ];

  gitTools = with pkgs; [
    git-filter-repo
    lazyjj
    pre-commit
  ];

  dataParsing = with pkgs; [
    exiftool
    jq
    yq-go
    shellcheck
  ];

  network = with pkgs; [
    croc
    curl
    grpcurl
    wget
    wireguard-tools
  ];

  k8sAndOci = with pkgs; [
    argocd
    cmctl
    k3d
    kubectl
    kubefwd
    kubernetes-helm
    kustomize
    k9s
    kubeconform
    podman
    podman-desktop
    docker
    cosign
  ];

  iacAndCD = with pkgs; [
    bazel-buildtools
    bazelisk
    infracost
    tfenv
    terraform-docs
    tflint
    trivy
    gitleaks
  ];

  cloud = with pkgs; [
    awscli2
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
    ])
    hcloud
  ];

  databases = with pkgs; [
    pgcli
    postgresql_18
    stripe-cli
  ];

  goTools = with pkgs; [
    crane
    goose
    tparse
  ];

  media = with pkgs; [
    imagemagick
    languagetool
  ];

  compilersAndRuntimes = with pkgs; [
    alejandra
    statix
    deadnix
    stylua
    bun
    go
    hugo
    lua5_5
    nodejs_24
    protobuf
    rustup
    uv
    zig
  ];

  nixRebuildTools = with pkgs; [
    nil
    nixos-rebuild
    nixpkgs-review
  ];

  sshAndKeys = with pkgs; [
    openssh
    yubikey-manager
    dotenvx
  ];

  # Runtime dependencies of the aerospace and sketchybar configs.
  desktop = with pkgs; [
    jankyborders
    macmon
    nowplaying-cli
    switchaudio-osx
    shottr
    macfuse-stubs
    e2fsprogs
  ];
in {
  # Copy GUI apps into ~/Applications instead of symlinking them.
  targets.darwin.copyApps.enable = true;
  targets.darwin.linkApps.enable = false;

  home.packages =
    [kaynix-scripts]
    ++ terminal
    ++ gitTools
    ++ dataParsing
    ++ network
    ++ k8sAndOci
    ++ iacAndCD
    ++ cloud
    ++ databases
    ++ goTools
    ++ media
    ++ compilersAndRuntimes
    ++ sshAndKeys
    ++ nixRebuildTools
    ++ desktop;
}
