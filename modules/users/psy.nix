{
  lib,
  config,
  ...
}: let
  flakePartsConfig = config;
in {
  internal.modules = {
    nixos.psy = {
      config,
      pkgs,
      hostname,
      ...
    }: let
      nixosCfg = config;
      cfg = nixosCfg.__cfg;
    in {
      imports = [
        flakePartsConfig.internal.modules.nixos."home-personal-data"
        flakePartsConfig.internal.modules.nixos."home-credentials"
        flakePartsConfig.internal.modules.nixos.brave
        flakePartsConfig.internal.modules.nixos.chromium
        flakePartsConfig.internal.modules.nixos.firefox
        flakePartsConfig.internal.modules.nixos.librewolf
        flakePartsConfig.internal.modules.nixos."crypto-wallets"
        flakePartsConfig.internal.modules.nixos.direnv
        flakePartsConfig.internal.modules.nixos.neovim
        flakePartsConfig.internal.modules.nixos.opencode
        flakePartsConfig.internal.modules.nixos."copilot-cli"
        flakePartsConfig.internal.modules.nixos."antigravity-cli"
        flakePartsConfig.internal.modules.nixos.zsh
        flakePartsConfig.internal.modules.nixos."github-cli"
      ];
      options.__cfg.mainUser = lib.mkOption {
        type = lib.types.str;
        default = "psy";
        description = "Main user to provision";
      };

      config = {
        users.users.${cfg.mainUser} = {
          isNormalUser = true;
          uid = 1000;
          description = cfg.mainUser;
          hashedPassword = "$6$Y147CW7B3CWybgq7$VDfH7eOp4YaYLAP6QWAX.KEZ2YYwzoFkzvOLpzMUifFZBwluIBtmjdf7hHLBbyRsg.c6WT5qMTTITit2pc2Xt/";
          extraGroups = ["networkmanager" "wheel"];
          shell = pkgs.zsh;
        };

        home-manager.users.${cfg.mainUser}.imports = [
          # Core baseline
          flakePartsConfig.internal.modules.home.base
          flakePartsConfig.internal.modules.home.linux-base

          # User-specific module registration
          flakePartsConfig.internal.modules.home.psy

          # Host-specific overrides
          ../hosts/_${hostname}/home.nix

          # Services
          flakePartsConfig.internal.modules.home.ssh
          flakePartsConfig.internal.modules.home.gpg
          flakePartsConfig.internal.modules.home.nh
          flakePartsConfig.internal.modules.home.network
          flakePartsConfig.internal.modules.home.tpm
          flakePartsConfig.internal.modules.home.fonts
          flakePartsConfig.internal.modules.home.hyprland
          flakePartsConfig.internal.modules.home.waybar
          flakePartsConfig.internal.modules.home.dunst
          flakePartsConfig.internal.modules.home.playerctl
          flakePartsConfig.internal.modules.home.gtk
          flakePartsConfig.internal.modules.home.xdg

          # Desktop applications
          flakePartsConfig.internal.modules.home.rofi
          flakePartsConfig.internal.modules.home.feh
          flakePartsConfig.internal.modules.home.zathura

          # Security / integrations
          flakePartsConfig.internal.modules.home.sops
          flakePartsConfig.internal.modules.home.brave
          flakePartsConfig.internal.modules.home.misc
          flakePartsConfig.internal.modules.home.chromium
          flakePartsConfig.internal.modules.home.firefox
          flakePartsConfig.internal.modules.home.librewolf
          flakePartsConfig.internal.modules.home.direnv
          flakePartsConfig.internal.modules.home.neovim
          flakePartsConfig.internal.modules.home."neovim-mcphub"
          flakePartsConfig.internal.modules.home.opencode
          flakePartsConfig.internal.modules.home."copilot-cli"
          flakePartsConfig.internal.modules.home."antigravity-cli"

          # CLI tools
          flakePartsConfig.internal.modules.home.git
          flakePartsConfig.internal.modules.home.tmux
          flakePartsConfig.internal.modules.home.kitty
          flakePartsConfig.internal.modules.home.yazi
          flakePartsConfig.internal.modules.home.mpv
          flakePartsConfig.internal.modules.home.zsh
        ];
      };
    };

    darwin.psy = {
      config,
      hostname,
      ...
    }: {
      home-manager.users.${config.system.primaryUser}.imports = [
        # Core baseline
        flakePartsConfig.internal.modules.home.base

        # User-specific module registration
        flakePartsConfig.internal.modules.home.psy

        # Host-specific overrides
        ../hosts/_${hostname}/home.nix

        # Services (Darwin-compatible subset)
        flakePartsConfig.internal.modules.home.ssh
        flakePartsConfig.internal.modules.home.gpg
        flakePartsConfig.internal.modules.home.nh
        flakePartsConfig.internal.modules.home.network
        flakePartsConfig.internal.modules.home.fonts

        # Darwin-specific applications
        flakePartsConfig.internal.modules.home."container-tools"
        flakePartsConfig.internal.modules.home.utm

        # Security / integrations
        flakePartsConfig.internal.modules.home.sops
        flakePartsConfig.internal.modules.home.brave
        flakePartsConfig.internal.modules.home.misc
        flakePartsConfig.internal.modules.home.firefox
        flakePartsConfig.internal.modules.home.librewolf
        flakePartsConfig.internal.modules.home.direnv
        flakePartsConfig.internal.modules.home.neovim
        flakePartsConfig.internal.modules.home.opencode

        # CLI tools
        flakePartsConfig.internal.modules.home.git
        flakePartsConfig.internal.modules.home.tmux
        flakePartsConfig.internal.modules.home.kitty
        flakePartsConfig.internal.modules.home.yazi
        flakePartsConfig.internal.modules.home.mpv
        flakePartsConfig.internal.modules.home.zsh
      ];
    };
  };
}
