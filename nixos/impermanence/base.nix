{pkgs, lib, inputs, config, ...}: let

volumeGrp = "mapper/${config.__cfg.impermanence.disko.luksName}";
cfg = config.__cfg.impermanence;
in
{
  imports = [
      inputs.impermanence.nixosModules.impermanence
      ./disko.nix
  ];

  options = {
    __cfg = {
      impermanence = {
        persistDir = lib.mkOption {
          description = "Persistence directory";
          default = "/persist";
        };
      };
    };
  };

  config = {
    boot.initrd.postResumeCommands = lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/${volumeGrp} /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';

    environment.persistence.${cfg.persistDir} = {
      enable = true;  # NB: Defaults to true, not needed
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/etc/NetworkManager/system-connections"
        { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
        "/var/lib/sbctl" # secure boot keys
      ];
      files = [
        "/etc/machine-id"
        { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
      ];
    };

    # needed for root to access user files in home manager
    # programs.fuse.userAllowOther = true;

  };
}
