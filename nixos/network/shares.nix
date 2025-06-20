{ config, pkgs, inputs, ... }:

{
  config = let
    homebaseNfs = [
      {hostPath = "private/downloads"; target = "downloads"; }
      {hostPath = "public/audiobooks"; target = "audiobooks"; }
      {hostPath = "public/books"; target = "books"; }
      {hostPath = "public/movies"; target = "movies"; }
      {hostPath = "public/series"; target = "series"; }
      {hostPath = "public/temp"; target = "temp"; }
    ];
    nfsMountPoint = remote: localPath: {
      type = "nfs";
      mountConfig = {
        Options = "noatime";
      };
      what = remote;
      where = "/net/${localPath}";
    };
  in 
  {
    boot.supportedFilesystems = [ "nfs" ];
    services.rpcbind.enable = true; # needed for NFS

    systemd.mounts = 
    map (pair:
      nfsMountPoint pair.remote pair.localPath
    ) (map (pair:
      {
        remote = "homebase.get-it.us:/share/${pair.hostPath}";
        localPath = "homebase/${pair.target}";
      }) homebaseNfs);

    systemd.automounts = 
      map (t: {
          wantedBy = [ "multi-user.target" ];
          automountConfig = {
            TimeoutIdleSec = "600";
          };
          where = "/net/${t}";
        })
      (map (t: "homebase/${t}")
        (map (pair: pair.target) homebaseNfs));
  };
}
