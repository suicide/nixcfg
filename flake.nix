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
    hyprland = {
      url = "github:hyprwm/Hyprland";
      # do not change hyprland's nixpkgs to take advantage of cache and not to mess with build
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
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

    # my nvf neovim
    neovim = {
      url = "github:suicide/nvim-nvf";
      # not following nixpkgs currently due to tree-sitter update https://github.com/NotAShelf/nvf/pull/1315
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    mkSystem = hostname: cfg:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs hostname;};
        # path to host specific config modules
        modules = [
          cfg
        ];
      };
    mkDarwin = hostname: cfg:
      nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs outputs hostname;};
        system = "aarch64-darwin";
        # path to host specific config modules
        modules = [
          cfg
        ];
      };
    mkHome = arch: cfg:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${arch}; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        # specific config file
        modules = [cfg];
      };
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      psy-fw13 = mkSystem "psy-fw13" ./hosts/psy-fw13/configuration.nix;
      psy-work1 = mkSystem "psy-work1" ./hosts/psy-work1/configuration.nix;
      qemu = mkSystem "qemu" ./hosts/qemu/configuration.nix;
    };

    darwinConfigurations = {
      psy-mac = mkDarwin "psy-mac" ./hosts/psy-mac/configuration.nix;
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "psy@psy-fw13" = mkHome "x86_64-linux" ./home-manager/home.nix;
    };

    # packages
    packages = let
      systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
      forAllSystems (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        openagents-opencode = pkgs.callPackage ./packages/openagents-opencode {
          openAgentsControlSrc = inputs.OpenAgentsControl;
        };
      });

  };
}
