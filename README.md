# Nix config

This config is used for nixos and nix-darwin systems.

It uses home manager as a nixos and a nix-darwin module.

The config is based on hosts. Host specific configs for nixos and home manager
are located in each host's directory. Features are generally enabled through
imports in each host's dir but feature flags for larger features like `sops`
also exist.

## Install

To install a new system run `disko-install` from flake with efi write on a disk.
Be aware to diable features like sops and secureboot at first as they will not
work without key files.

Generate hardware config:

```shell
nixos-generate-config --show-hardware-config --no-filesystems
```

Install from flake:

```shell
sudo nix --experimental-features 'nix-command flakes' run 'github:nix-community/disko/latest#disko-install' -- --write-efi-boot-entries --flake 'github:suicide/nixcfg#qemu' --disk main /dev/sda
```

## Rebuild

Rebuild a system from the flake:

```shell
sudo nixos-rebuild switch --flake .#psy-fw13
```

On mac:

```shell
sudo darwin-rebuild switch --flake .#psy-mac
```

## Testing

To test config changes, use `nixos-rebuild test`

```shell
sudo nixos-rebuild test --flake .#psy-fw13
```

On mac:

```shell
sudo darwin-rebuild test --flake .#psy-mac
```

Running `switch` afterwards will persist the changes.

## SOPS

Place `age` key in `${HOME}/.config/sops/age/keys.txt` and enable
`__cfg.sops.enable = true;` in home manager config. Secret decryption will fail
otherwise.

Editing secrets:

```shell
nix run nixpkgs#sops -- home-manager/users/psy/secrets.yaml
```

## Secure boot

Starting out, secure boot should be disabled in the firmware and the nixos
setup, `__cfg.secureboot.enable = false;`. This setup uses lanzaboote for secure
boot.

1. Check status

```shell
$ bootctl status

System:
     Firmware: UEFI 2.70 (Lenovo 0.4720)
  Secure Boot: disabled (disabled)
 TPM2 Support: yes
 Boot into FW: supported
```

2. Create new keys

```shell
$ sudo sbctl create-keys

Created Owner UUID 8ec4b2c3-dc7f-4362-b9a3-0cc17e5a34cd
Creating secure boot keys...✓
Secure boot keys created!
```

Keys are stored in `/var/lib/sbctl`, so it must be included in impermancence!

3. Enable `__cfg.secureboot.enable = true;` and rebuild system.

lanzaboote will sign the necessary boot files.

Verify signatures:

```shell
$ sudo sbctl verify

Verifying file database and EFI images in /boot...
✓ /boot/EFI/BOOT/BOOTX64.EFI is signed
✓ /boot/EFI/Linux/nixos-generation-355.efi is signed
✓ /boot/EFI/Linux/nixos-generation-356.efi is signed
✗ /boot/EFI/nixos/0n01vj3mq06pc31i2yhxndvhv4kwl2vp-linux-6.1.3-bzImage.efi is not signed
✓ /boot/EFI/systemd/systemd-bootx64.efi is signed
```

4. Clear the existing secure boot keys so we can add our own

Reboot into the UEFI and clear the keys in the secure boot settings.

On framework, "Administer Secure Boot" -> "Erase all Secure Boot Settings"

Reboot, while secure boot is still disabled.

5. Enroll keys

Add our own, new keys, microsoft (`-m`) keys and the platform (`-f`) keys
(framework's own keys) to enable firmware updates

```shell
$ sudo sbctl enroll-keys -m -f

Enrolling keys to EFI variables...
With vendor keys from microsoft...✓
Enrolled keys to the EFI variables!
```

This should enable secure boot on its own. On framework, secure boot has to be
enabled manually: "Administer Secure Boot" -> "Enforce Secure Boot"

Reboot

6. Secure boot is enabled and working

Verify

```shell
$ bootctl status
System:
      Firmware: UEFI 2.70 (Lenovo 0.4720)
 Firmware Arch: x64
   Secure Boot: enabled (user)
  TPM2 Support: yes
  Boot into FW: supported
```

## GPG

### export Subkeys from separate store

```bash
gpg --homedir <pathToGpgStore> --pinentry-mode loopback --output <somePath> --export-secret-subkeys <keyID>
```

## MISC

Clean cache / nix-store

```shell
nix-store --gc
```

Run home manager stand alone (not supported anymore)

```shell
nix run 'github:nix-community/home-manager' -- switch --flake .#psy@psy-fw13
```
