{
  config,
  pkgs,
  inputs,
  ...
}: {
  config = {
    programs.zsh.enable = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      git
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      clang
      gnumake
    ];
  };
}
