# Contributing Guide

This repository contains my personal system configurations.

## Adding a New Host

To add a new NixOS machine to this flake:

1. **Generate Hardware Config**: Run this on the new machine:
   ```shell
   nixos-generate-config --show-hardware-config --no-filesystems > hardware-configuration.nix
   ```
2. **Create Host Directory**: Create a new directory in `hosts/<hostname>/`.
   Move the generated `hardware-configuration.nix` there.
3. **Create Configuration**: Create `hosts/<hostname>/configuration.nix`. Import
   `../../nixos/base.nix` (or similar) and your `hardware-configuration.nix`.
4. **Register in Flake**: Add the new host to `nixosConfigurations` in
   `flake.nix`.
   ```nix
   nixosConfigurations = {
     <hostname> = mkSystem "<hostname>" ./hosts/<hostname>/configuration.nix;
   };
   ```
5. **Secrets**: If the host needs secrets, generate a `secrets.yaml` and update
   `.sops.yaml` with the host's public SSH key (converted to age).

## Adding New Modules

- **System Services/Hardware**: Place in `nixos/`.
  - Example: `nixos/bluetooth.nix`
- **User Applications/Config**: Place in `home-manager/modules/`.
  - Example: `home-manager/modules/zsh.nix`

## Conventions

- **Custom Options**: Use the `__cfg` namespace for all custom feature flags.
- **Formatting**: Run `nix fmt` before committing.
