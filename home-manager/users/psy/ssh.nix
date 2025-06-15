{ lib, pkgs, config, ... }:
let
  secrets = "~/.config/sops-nix/secrets/ssh";
in 

{
  config = {
    programs.ssh = {
      extraConfig = ''
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

        host unikorn.homenet2.hastybox.com
         HostName unikorn.homenet2.hastybox.com
         IdentityFile ${secrets}/unikorn/privateKey
         User psy

        host homegate2.homenet2.hastybox.com
         HostName homegate2.homenet2.hastybox.com
         IdentityFile ${secrets}/homegate2/privateKey
         User psy

        host thering.homenet2.hastybox.com
         HostName thering.homenet2.hastybox.com
         IdentityFile ${secrets}/thering/privateKey
         User psy


        host luna.homenet2.hastybox.com
         HostName luna.homenet2.hastybox.com
         IdentityFile ${secrets}/luna/privateKey
         User psy

        host deimos.homenet2.hastybox.com
         HostName deimos.homenet2.hastybox.com
         IdentityFile ${secrets}/deimos/privateKey
         User psy

        host ganymede.homenet2.hastybox.com
         HostName ganymede.homenet2.hastybox.com
         IdentityFile ${secrets}/ganymede/privateKey
         User psy

        host ceres.homenet2.hastybox.com
         HostName ceres.homenet2.hastybox.com
         IdentityFile ${secrets}/ceres/privateKey
         User psy

        host auberon.homenet2.hastybox.com
         HostName auberon.homenet2.hastybox.com
         IdentityFile ${secrets}/auberon/privateKey
         User psy
      '';
    };
  };
}
