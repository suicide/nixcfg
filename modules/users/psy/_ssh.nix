{
  lib,
  pkgs,
  config,
  ...
}: let
  secrets = "~/.config/sops-nix/secrets/ssh";
  hosts = ["unikorn" "homegate2" "thering" "luna" "deimos" "ganymede" "ceres" "auberon"];
  simpleIdentity = name: let
    fqdn = "${name}.homenet2.hastybox.com";
  in {
    header = "Host ${fqdn}";
    HostName = fqdn;
    IdentityFile = "${secrets}/${name}/privateKey";
    User = "psy";
  };
in {
  config = {
    programs.ssh = {
      extraConfig = ''
        Include ~/.ssh/config.d/*.conf
      '';

      settings =
        {
          "homebase.get-it.us" = {
            HostName = "homebase.get-it.us";
            IdentityFile = "${secrets}/homebase/privateKey";
            User = "psy";
          };

          "github.com" = {
            HostName = "github.com";
            IdentityFile = "${secrets}/github/privateKey";
            User = "git";
          };

          "codeberg.org" = {
            HostName = "codeberg.org";
            IdentityFile = "${secrets}/codeberg/privateKey";
            User = "git";
          };

          "codeberg-ler" = {
            HostName = "codeberg.org";
            IdentityFile = "${secrets}/codeberg-ler/privateKey";
            User = "git";
          };

          "bitbucket.org" = {
            HostName = "bitbucket.org";
            IdentityFile = "${secrets}/bitbucket/privateKey";
            User = "git";
            HostKeyAlgorithms = "ssh-rsa";
            PubkeyAcceptedKeyTypes = "ssh-rsa";
          };

          "remote_hop" = {
            HostName = "somewhere";
            IdentityFile = "${secrets}/remote_hop/privateKey";
            Port = 50044;
            User = "psyremote";
            LocalForward = [
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
            ServerAliveInterval = 10;
            StrictHostKeyChecking = "no";
            UserKnownHostsFile = "/dev/null";
          };

          "macarco" = {
            HostName = "localhost";
            IdentityFile = "${secrets}/remote_macarco/privateKey";
            Port = 2224;
            User = "psy";
            ServerAliveInterval = 10;
            Compression = true;
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
          Port 22
          User ubuntu
          IdentityFile ${secrets}/outterworld2/privateKey
          LocalForward 6443 localhost:6443
      '';
      mode = "0600"; # Secure perms
      path = "${config.home.homeDirectory}/.ssh/config.d/outterworld2.conf";
    };

    sops.templates."ssh-config-outterworld3" = {
      content = ''
        Host outterworld3
          HostName ${config.sops.placeholder."ssh/outterworld3/host"}
          Port 22
          User ubuntu
          IdentityFile ${secrets}/outterworld3/privateKey
          LocalForward 6443 localhost:6443
      '';
      mode = "0600"; # Secure perms
      path = "${config.home.homeDirectory}/.ssh/config.d/outterworld3.conf";
    };
  };
}
