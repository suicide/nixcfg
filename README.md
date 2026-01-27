# Nix Config

This repository contains NixOS and nix-darwin system configurations, using Home
Manager as a module.

## Table of Contents

- [Directory Structure](#directory-structure)
- [Install](#install)
- [Rebuild](#rebuild)
- [Testing](#testing)
- [SOPS Secrets](#sops-secrets)
- [Secure Boot](#secure-boot)
- [GPG](#gpg)
- [Misc](#misc)

## Directory Structure

- `flake.nix`: Entry point for all configurations.
- `hosts/`: Host-specific configurations (e.g., `psy-fw13/`, `psy-mac/`).
- `nixos/`: Shared system-level modules (systemd, kernel, hardware).
- `home-manager/`: Shared user-level modules (shell, editors, GUI apps).
  - `modules/`: Atomic configuration units.
  - `users/`: User profiles.
- `packages/`: Custom package definitions (e.g., `openagents-opencode`).
- `docs/`: detailed documentation.

See [ARCHITECTURE.md](ARCHITECTURE.md) for details on the module system and
`__cfg` pattern.

## Install

To install a new system, use `disko-install` from the flake. **Note:** Disable
features like sops and secureboot (`__cfg.secureboot.enable = false;`)
initially, as they require keys generated _after_ installation.

1. **Generate hardware config**:
   ```shell
   nixos-generate-config --show-hardware-config --no-filesystems
   ```

2. **Install from flake**: Replace `<config>` with the target host config (e.g.,
   `qemu`, `psy-fw13`) and `<disk>` with the target device.
   ```shell
   sudo nix --experimental-features 'nix-command flakes' run 'github:nix-community/disko/latest#disko-install' -- --write-efi-boot-entries --flake 'github:suicide/nixcfg#<config>' --disk main <disk>
   ```

## Rebuild

To apply changes to your current system:

**NixOS:**

```shell
sudo nixos-rebuild switch --flake .#<hostname>
```

**macOS:**

```shell
sudo darwin-rebuild switch --flake .#<hostname>
```

## Testing

To test config changes without persisting boot entries:

```shell
sudo nixos-rebuild test --flake .#<hostname>
```

## SOPS Secrets

Secrets are managed via [sops-nix](https://github.com/Mic92/sops-nix). Place
your `age` key in `${HOME}/.config/sops/age/keys.txt`.

Ensure `__cfg.sops.enable = true;` is set in your configuration.

**Editing secrets:**

```shell
nix run nixpkgs#sops -- home-manager/users/psy/secrets.yaml
```

## Secure Boot

See the [Secure Boot Guide](docs/secureboot.md) for detailed setup instructions
using Lanzaboote.

Quick summary:

1. Boot with Secure Boot disabled in firmware.
2. Generate keys: `sudo sbctl create-keys`
3. Enable in config: `__cfg.secureboot.enable = true;`
4. Rebuild.
5. Enroll keys and enable in firmware.

## GPG

**Export Subkeys from separate store:**

```bash
gpg --homedir <pathToGpgStore> --pinentry-mode loopback --output <somePath> --export-secret-subkeys <keyID>
```

## Misc

**Clean cache / nix-store:**

```shell
nix-store --gc
```

**Run home-manager standalone (legacy):**

```shell
nix run 'github:nix-community/home-manager' -- switch --flake .#psy@psy-fw13
```
