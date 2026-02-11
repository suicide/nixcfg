{
  lib,
  pkgs,
  config,
  ...
}: let
  secrets = "~/.config/sops-nix/secrets/ssh";
  hosts = ["unikorn" "homegate2" "thering" "luna" "deimos" "ganymede" "ceres" "auberon"];
  simpleIdentity = name: {
    host = "${name}.homenet2.hastybox.com";
    hostname = "${name}.homenet2.hastybox.com";
    identityFile = "${secrets}/${name}/privateKey";
    user = "psy";
  };
in {
  config = {
    programs.ssh = {
      extraConfig = ''
        Include ~/.ssh/config.d/*.conf
      '';

      matchBlocks =
        {
          "homebase.get-it.us" = {
            hostname = "homebase.get-it.us";
            identityFile = "${secrets}/homebase/privateKey";
            user = "psy";
          };

          "github.com" = {
            hostname = "github.com";
            identityFile = "${secrets}/github/privateKey";
            user = "git";
          };

          "codeberg.org" = {
            hostname = "codeberg.org";
            identityFile = "${secrets}/codeberg/privateKey";
            user = "git";
          };

          "codeberg-ler" = {
            hostname = "codeberg.org";
            identityFile = "${secrets}/codeberg-ler/privateKey";
            user = "git";
          };

          "bitbucket.org" = {
            hostname = "bitbucket.org";
            identityFile = "${secrets}/bitbucket/privateKey";
            user = "git";
            extraOptions = {
              "HostKeyAlgorithms" = "ssh-rsa";
              "PubkeyAcceptedKeyTypes" = "ssh-rsa";
            };
          };

          "remote_hop" = {
            hostname = "somewhere";
            identityFile = "${secrets}/remote_hop/privateKey";
            port = 50044;
            user = "psyremote";
            localForwards = [
              {
                bind.port = 2224;
                host.address = "localhost";
                host.port = 2224;
              }
              {
                bind.port = 2280;
                host.address = "localhost";
                host.port = 2280;
              }
              {
                bind.port = 3128;
                host.address = "localhost";
                host.port = 3128;
              }
            ];
            serverAliveInterval = 10;
            extraOptions = {
              "StrictHostKeyChecking" = "no";
              "UserKnownHostsFile" = "/dev/null";
            };
          };

          "macarco" = {
            hostname = "localhost";
            identityFile = "${secrets}/remote_macarco/privateKey";
            port = 2224;
            user = "psy";
            serverAliveInterval = 10;
            compression = true;
          };
        }
        // lib.genAttrs hosts simpleIdentity;
    };

    sops.templates."ssh-config-outterworld" = {
      content = ''
        Host outterworld
          HostName ${config.sops.placeholder."ssh/outterworld/host"}
          User ubuntu
          IdentityFile ${secrets}/outterworld/privateKey
          LocalForward 6443 localhost:6443
      '';
      mode = "0600"; # Secure perms
      path = "${config.home.homeDirectory}/.ssh/config.d/outterworld.conf";
    };

    sops.templates."ssh-config-outterworld2" = {
      content = ''
        Host outterworld2
          HostName ${config.sops.placeholder."ssh/outterworld2/host"}
          Port 41233
          User ubuntu
          IdentityFile ${secrets}/outterworld2/privateKey
          LocalForward 6443 localhost:6443
      '';
      mode = "0600"; # Secure perms
      path = "${config.home.homeDirectory}/.ssh/config.d/outterworld2.conf";
    };
  };
}
