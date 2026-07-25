# Project Architecture

This document provides a high-level overview of the repository's structure, the
custom module system, and the secrets management workflow.

## Directory Structure

- **`hosts/`**: Contains per-host configurations. Each host (e.g., `psy-fw13`,
  `psy-mac`) has its own directory with a `configuration.nix`.
- **`nixos/`**: Contains system-level NixOS modules (kernel, networking,
  virtualization, system services).
- **`home-manager/`**: Contains user-level configurations (shell, editors, GUI
  apps) managed by Home Manager.
  - **`modules/`**: Atomic Home Manager modules (e.g., `git.nix`, `hyprland/`,
    `neovim/`).
  - **`users/`**: User definitions (e.g., `psy/`).
- **`modules/`**: Auto-discovered flake-parts modules. New configuration belongs
  here and is organized by feature, user, or host.
  - **`core/`**: Flake-wide systems, package outputs, and Home Manager wiring.
  - **`hosts/`**: NixOS and nix-darwin configuration entrypoints.
  - **`services/`**: Cross-cutting service integrations such as SOPS.
  - **`users/`**: User modules shared by host configurations.
- **`packages/`**: Contains custom package definitions exposed by the flake.

## Dendritic Flake Structure

`flake.nix` delegates to `flake-parts` and recursively imports `modules/` with
[`import-tree`](https://github.com/vic/import-tree). Each non-private `.nix`
file in `modules/` is therefore a flake-parts module.

The transition is incremental. Existing NixOS, nix-darwin, Home Manager, host,
and package files remain explicit implementation leaves until their feature is
migrated. Do not add new files to those legacy trees unless they are host-local
or generated inputs such as hardware configuration. New shared configuration
belongs in `modules/`.

Files or directories prefixed with `_` are excluded from `import-tree` and may
be imported explicitly by the module that owns them.

## The `__cfg` Module Pattern

This project uses a custom namespace `__cfg` for all project-specific
configuration options. This separates "our" options from standard NixOS/Home
Manager options, making it clear which settings are defined internally.

### Example

In a module (e.g., `nixos/secureboot.nix`):

```nix
options = {
  __cfg.secureboot.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable secure boot";
  };
};
```

In a host config (`hosts/psy-fw13/configuration.nix`):

```nix
__cfg.secureboot.enable = true;
```

This pattern allows for toggling complex features (like Secure Boot with
Lanzaboote or SOPS integration) with simple boolean flags in the host
configuration.

## Module Hierarchy

1. **Host Configuration**: The entry point is defined in `modules/hosts/` and
   imports its host-local configuration.
2. **System Modules (`nixos/`)**: Define system-wide settings.
3. **User Modules (`home-manager/`)**: Define the user environment. Home Manager
   is integrated into NixOS and nix-darwin, so user configuration is built
   alongside the system.

## Secrets Management (SOPS)

We use [sops-nix](https://github.com/Mic92/sops-nix) to manage secrets.

- **Workflow**: Secrets are encrypted using `age` keys.
- **Key Source**: `age` keys are typically derived from the host's SSH host keys
  (for system secrets) or a user-provided key (for user secrets).
- **Storage**: Encrypted secrets are stored in `.yaml` files (e.g.,
  `secrets.yaml` in `hosts/` or `home-manager/users/`).
- **Decryption**: At runtime, SOPS decrypts the secrets using the private key
  available on the system (e.g., in `/root/.config/sops/age/keys.txt` or derived
  from SSH host key).
