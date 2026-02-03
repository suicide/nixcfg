{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  cfg = config.__cfg.shares;
in {
  options = {
    __cfg.shares.luna = {
      credentials = lib.mkOption {
        type = lib.types.str;
        example = "/run/secrets/samba/luna/credentials";
        description = "Luna credentials path";
      };
    };
  };

  config = let
    mainUser = config.__cfg.mainUser;
    mainUserGroup = "users";
    mainUserId = toString config.users.users.${mainUser}.uid;
    mainUserGroupId = toString config.users.groups.${mainUserGroup}.gid;
    homebaseNfs = [
      {
        hostPath = "private/downloads";
        target = "downloads";
      }
      {
        hostPath = "public/audiobooks";
        target = "audiobooks";
      }
      {
        hostPath = "public/books";
        target = "books";
      }
      {
        hostPath = "public/movies";
        target = "movies";
      }
      {
        hostPath = "public/series";
        target = "series";
      }
      {
        hostPath = "public/temp";
        target = "temp";
      }
    ];
    nfsMountPoint = remote: localPath: {
      type = "nfs";
      mountConfig = {
        Options = "noatime";
      };
      what = remote;
      where = "/net/${localPath}";
    };
    homebaseMounts =
      map (
        pair:
          nfsMountPoint pair.remote pair.localPath
      ) (map (pair: {
          remote = "homebase.get-it.us:/share/${pair.hostPath}";
          localPath = "homebase/${pair.target}";
        })
        homebaseNfs);
    homebaseAutomounts =
      map (t: {
        wantedBy = ["multi-user.target"];
        automountConfig = {
          TimeoutIdleSec = "600";
        };
        where = "/net/${t}";
      })
      (map (t: "homebase/${t}")
        (map (pair: pair.target) homebaseNfs));
  in {
    boot.supportedFilesystems = ["nfs"];
    services.rpcbind.enable = true; # needed for NFS

    environment.systemPackages = with pkgs; [
      cifs-utils
    ];

    systemd.mounts =
      homebaseMounts
      ++ [
        {
          type = "cifs";
          mountConfig = {
            Options = "noatime,credentials=${cfg.luna.credentials},uid=${mainUserId},gid=${mainUserGroupId},dir_mode=0775,file_mode=0664";
          };
          what = "//luna.homenet2.hastybox.com/storage";
          where = "/net/luna/storage";
        }
      ];

    systemd.automounts =
      homebaseAutomounts
      ++ [
        {
          wantedBy = ["multi-user.target"];
          automountConfig = {
            TimeoutIdleSec = "600";
          };
          where = "/net/luna/storage";
        }
      ];
  };
}
