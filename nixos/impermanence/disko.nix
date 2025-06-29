{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.__cfg.impermanence.disko;
in {
  imports = [
  ];

  options = {
    __cfg.impermanence.disko = {
      device = lib.mkOption {
        type = lib.types.str;
        default = "/dev/sda";
        description = "The main disk to format and use in the impermanence setup";
      };
      swapSize = lib.mkOption {
        type = lib.types.str;
        default = "20M";
        description = "Swap size suffixed by M or G";
      };
      persistPath = lib.mkOption {
        type = lib.types.str;
        default = "/persist";
        description = "Mount point and subsvolume or persistence";
      };
      luksName = lib.mkOption {
        type = lib.types.str;
        default = "crypted";
        description = "Name of the LUKS volume";
      };
    };
  };

  config = {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = cfg.device;
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "512M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = ["umask=0077"];
                };
              };
              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = cfg.luksName;
                  # disable settings.keyFile if you want to use interactive password entry
                  #passwordFile = "/tmp/secret.key"; # Interactive
                  settings = {
                    allowDiscards = true;
                    # keyFile = "/tmp/secret.key";
                  };
                  # additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
                  content = {
                    type = "btrfs";
                    extraArgs = ["-f"];
                    subvolumes = {
                      "/root" = {
                        mountpoint = "/";
                        mountOptions = [
                          "compress=zstd"
                          "noatime"
                        ];
                      };
                      "${cfg.persistPath}" = {
                        mountpoint = cfg.persistPath;
                        mountOptions = [
                          "compress=zstd"
                          "noatime"
                        ];
                      };
                      "/nix" = {
                        mountpoint = "/nix";
                        mountOptions = [
                          "compress=zstd"
                          "noatime"
                        ];
                      };
                      "/swap" = {
                        mountpoint = "/.swapvol";
                        swap.swapfile.size = cfg.swapSize;
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };

    fileSystems."${cfg.persistPath}".neededForBoot = true;
  };
}
