{
  description = "suiiii's nix config";

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
      url = "github:nix-community/lanzaboote/v0.4.2";
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
  };
}
