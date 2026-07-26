{
  config,
  pkgs,
  inputs,
  ...
}: {
  config = {
    system.primaryUser = "psy";

    users.users.psy = {
      name = "psy";
      home = "/Users/psy";
      shell = pkgs.zsh;
    };

    __cfg.sops.enable = true;

    system.stateVersion = 6;
  };
}
