{
  lib,
  pkgs,
  config,
  ...
}: let
  secrets = "~/.config/sops-nix/secrets/ssh";
in {
  config = {
    programs.ssh = {
      extraConfig = let
        hosts = ["unikorn" "homegate2" "thering" "luna" "deimos" "ganymede" "ceres" "auberon"];

        simpleIdentity = name: ''
          host ${name}.homenet2.hastybox.com
           HostName ${name}.homenet2.hastybox.com
           IdentityFile ${secrets}/${name}/privateKey
           User psy
        '';

        blocks = lib.concatStringsSep "\n\n" (map simpleIdentity hosts);
      in ''
          host homebase.get-it.us
           HostName homebase.get-it.us
           IdentityFile ${secrets}/homebase/privateKey
           User psy

          host github.com
           HostName github.com
           IdentityFile ${secrets}/github/privateKey
           User git

          host bitbucket.org
           HostName bitbucket.org
           IdentityFile ${secrets}/bitbucket/privatekey
           User git
           HostKeyAlgorithms ssh-rsa
           PubkeyAcceptedKeyTypes ssh-rsa

          host remote_hop
           HostName somewhere
           Port 50044
           IdentityFile ${secrets}/remote_hop/privatekey
           User psyremote
           LocalForward 2224 localhost:2224
           LocalForward 2280 localhost:2280
           LocalForward 3128 localhost:3128
           StrictHostKeyChecking no
           UserKnownHostsFile=/dev/null
           ServerAliveInterval=10

          host macarco
           HostName localhost
           Port 2224
           IdentityFile ${secrets}/remote_macarco/privatekey
           User psy
           ServerAliveInterval=10
           Compression yes

        ${blocks}
      '';
    };
  };
}
