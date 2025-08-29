{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks."*" = {
        forwardAgent = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        compression = false;
        extraOptions = {
          "AddKeysToAgent" = "no";
          "HashKnownHosts" = "no";
          "UserKnownHostsFile" = "~/.ssh/known_hosts";
          "ControlMaster" = "no";
          "ControlPath" = "~/.ssh/master-%r@%n:%p";
          "ControlPersist" = "no";
        };
      };
    };
  };
}
