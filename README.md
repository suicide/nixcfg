# Nix config


run disko install from flake with efi write on a disk
```shell
sudo nix --experimental-features 'nix-command flakes' run 'github:nix-community/disko/latest#disko-install' -- --write-efi-boot-entries --flake 'github:suicide/nixcfg#qemu' --disk main /dev/sda
```

rebuild system from flake

```shell
sudo nixos-rebuild switch --flake .#psy-fw13
```

Clean cache / nix-store
```shell
nix-store --gc
```


```shell
nix run 'github:nix-community/home-manager' -- swith --flake .#psy@psy-fw13
```

### SOPS

60 11 12
