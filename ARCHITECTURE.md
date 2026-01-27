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
- **`packages/`**: Contains custom package definitions that are exposed via the
  flake overlay.

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

1. **Host Configuration**: The entry point (defined in `flake.nix`). It imports
   the necessary `nixos/` modules and `home-manager` configurations.
2. **System Modules (`nixos/`)**: Define system-wide settings.
3. **User Modules (`home-manager/`)**: Define user environment. The project uses
   Home Manager as a NixOS module, meaning user configuration is built alongside
   the system.

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
