{pkgs, lib, inputs, config, ...}: let

in
{


  config = {
    environment.persistence."/persist" = {
      users.psy = {
        directories = [
          "Downloads"
          "Music"
          "Pictures"
          "Documents"
          "Videos"
          "VirtualBox VMs"
          "projects"
          "tmp"
          { directory = ".gnupg"; mode = "0700"; }
          { directory = ".ssh"; mode = "0700"; }
          { directory = ".nixops"; mode = "0700"; }
          { directory = ".local/share/keyrings"; mode = "0700"; }
          ".local/share/direnv"
        ];
        files = [
          ".screenrc"
          ".zsh_history"
        ];
      };
    };

  };
}
