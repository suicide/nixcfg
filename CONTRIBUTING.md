# Contributing Guide

This repository contains my personal system configurations.

## Adding a New Host

To add a new NixOS machine to this flake:

1. **Generate Hardware Config**: Run this on the new machine:
   ```shell
   nixos-generate-config --show-hardware-config --no-filesystems > hardware-configuration.nix
   ```
2. **Create Host Leaf**: Create a new directory under `modules/hosts/_<hostname>/`.
   Move the generated `hardware-configuration.nix` there.
3. **Create Configuration**: Create `modules/hosts/_<hostname>/configuration.nix`.
   Import your `hardware-configuration.nix`.
4. **Register in Flake-Parts**: Add a new entrypoint in
   `modules/hosts/<hostname>.nix`, importing `./_<hostname>/configuration.nix`.
   See existing entrypoints (e.g., `psy-fw13.nix`) for the pattern.
5. **Secrets**: If the host needs secrets, generate a `secrets/hosts/<hostname>.yaml`
   and update `.sops.yaml` with the host's public SSH key (converted to age).

## Adding New Modules

- **System Services/Hardware**: Place in `nixos/`.
  - Example: `nixos/bluetooth.nix`
- **User Applications/Config**: Place in `home-manager/modules/`.
  - Example: `home-manager/modules/zsh.nix`

## Conventions

- **Custom Options**: Use the `__cfg` namespace for all custom feature flags.
- **Formatting**: Run `nix fmt .` before committing. This flake uses `alejandra` for Nix formatting.
