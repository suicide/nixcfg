# { lib, pkgs, config, ... }:
#
# {
#   home.persistence."/persist/home/psy" = {
#     directories = [
#       "Downloads"
#       "Music"
#       "Pictures"
#       "Documents"
#       "Videos"
#       "VirtualBox VMs"
#       ".gnupg"
#       ".ssh"
#       ".nixops"
#       ".local/share/keyrings"
#       ".local/share/direnv"
#       {
#         directory = ".local/share/Steam";
#         method = "symlink";
#       }
#     ];
#     files = [
#       ".screenrc"
#     ];
#     allowOther = true;
#   };
# }
