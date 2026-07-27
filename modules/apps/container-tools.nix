{...}: {
  internal.modules = {
    home.container-tools = {
      lib,
      pkgs,
      config,
      ...
    }: {
      config = {
        home.packages = with pkgs; [
          dive
          ctop
        ];
      };
    };
  };
}
