{...}: {
  internal.modules = {
    nixos.containers = {
      virtualisation.containers = {
        # creates common containers config
        enable = true;
      };
    };
  };
}
