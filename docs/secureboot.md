# Secure Boot with Lanzaboote

Starting out, secure boot should be disabled in the firmware and the nixos setup
(`__cfg.secureboot.enable = false;`). This setup uses
[lanzaboote](https://github.com/nix-community/lanzaboote) for secure boot.

## 1. Check status

```shell
$ bootctl status

System:
     Firmware: UEFI 2.70 (Lenovo 0.4720)
  Secure Boot: disabled (disabled)
 TPM2 Support: yes
 Boot into FW: supported
```

## 2. Create new keys

```shell
$ sudo sbctl create-keys

Created Owner UUID 8ec4b2c3-dc7f-4362-b9a3-0cc17e5a34cd
Creating secure boot keys...✓
Secure boot keys created!
```

> **Note:** Keys are stored in `/var/lib/sbctl`, so it must be included in
> impermanence!

## 3. Enable Secure Boot in Config

Enable `__cfg.secureboot.enable = true;` in your host configuration and rebuild
the system.

Lanzaboote will sign the necessary boot files.

### Verify signatures

```shell
$ sudo sbctl verify

Verifying file database and EFI images in /boot...
✓ /boot/EFI/BOOT/BOOTX64.EFI is signed
✓ /boot/EFI/Linux/nixos-generation-355.efi is signed
✓ /boot/EFI/Linux/nixos-generation-356.efi is signed
✗ /boot/EFI/nixos/0n01vj3mq06pc31i2yhxndvhv4kwl2vp-linux-6.1.3-bzImage.efi is not signed
✓ /boot/EFI/systemd/systemd-bootx64.efi is signed
```

## 4. Clear existing Secure Boot keys

Reboot into the UEFI and clear the keys in the secure boot settings.

- **On Framework:** "Administer Secure Boot" -> "Erase all Secure Boot Settings"

Reboot, while secure boot is still disabled.

## 5. Enroll keys

Add our own new keys, Microsoft (`-m`) keys, and the platform (`-f`) keys
(hardware vendor's own keys) to enable firmware updates.

```shell
$ sudo sbctl enroll-keys -m -f

Enrolling keys to EFI variables...
With vendor keys from microsoft...✓
Enrolled keys to the EFI variables!
```

This should enable secure boot on its own. On some hardware (like Framework),
secure boot might need to be enabled manually:

- "Administer Secure Boot" -> "Enforce Secure Boot"

Reboot.

## 6. Verification

Secure boot should now be enabled and working.

```shell
$ bootctl status
System:
      Firmware: UEFI 2.70 (Lenovo 0.4720)
 Firmware Arch: x64
   Secure Boot: enabled (user)
  TPM2 Support: yes
  Boot into FW: supported
```
