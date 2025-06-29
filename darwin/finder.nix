{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [];

  config = {
    system.defaults.finder.AppleShowAllExtensions = true;
    system.defaults.finder.AppleShowAllFiles = true;
  };
}
