{
  config,
  pkgs,
  inputs,
  ...
}: {
  config = {
    virtualisation.containers = {
      # creates common containers config
      enable = true;
    };
  };
}

