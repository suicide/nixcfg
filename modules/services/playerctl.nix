{...}: {
  internal.modules = {
    home.playerctl = {
      lib,
      pkgs,
      config,
      ...
    }: {
      config = {
        services.playerctld = {
          enable = true;
        };
      };
    };
  };
}
