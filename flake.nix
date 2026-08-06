{
  description = "suiiii's nix config";

  # Inputs
  # Most inputs follow 'nixpkgs' to ensure version consistency across the system.
  # Exceptions (like hyprland or neovim) are pinned or independent to avoid build issues or leverage caches.
  inputs = {
    # Nixpkgs
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    import-tree = {
      url = "github:vic/import-tree";
    };

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # darwin
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hardware
    nixos-hardware = {url = "github:NixOS/nixos-hardware/master";};

    # disko
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # impermanence
    impermanence = {url = "github:nix-community/impermanence";};

    # sops
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # lanzaboote secure boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland
    # pinned to the v0.56.2 release tag. The tag still requires glaze 7...<8 in
    # CMakeLists.txt and breaks with glaze 8 in nixpkgs; the repo-local patch
    # modules/services/hyprland/glaze.patch applies the known "drop glaze version
    # requirement" fix (upstream commit 91f29f23) on top of the tag.
    hyprland = {
      url = "github:hyprwm/Hyprland/v0.56.2";
      # do not change hyprland's nixpkgs to take advantage of cache and not to mess with build
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-split-monitor-workspaces = {
      url = "github:zjeffer/split-monitor-workspaces/v0.56.2";
      # url = "github:suicide/split-monitor-workspaces/fix-nix-0.54.3";
      inputs.hyprland.follows = "hyprland";
    };

    # waybar
    # using upstream to address https://github.com/Alexays/Waybar/issues/5035
    # may switch back to nixpks or pin to tag in future
    waybar = {
      url = "github:Alexays/Waybar/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # firefox addons
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # homebrew
    nix-homebrew = {url = "github:zhaofengli/nix-homebrew";};

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    # OpenAgentsControl config
    OpenAgentsControl = {
      url = "github:darrenhinde/OpenAgentsControl/main";
      flake = false;
    };

    # google antigravity auth for opencode
    # we are not using the actual code, but only extract the latest version from the package.json
    opencode-antigravity-auth = {
      url = "github:NoeFabris/opencode-antigravity-auth/main";
      flake = false;
    };

    # my nvf neovim
    neovim = {
      url = "github:suicide/nvim-nvf";
      # not following nixpkgs currently due to tree-sitter update https://github.com/NotAShelf/nvf/pull/1315
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;}
    (inputs.import-tree ./modules);
}
