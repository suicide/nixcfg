{...}: {
  internal.modules = {
    home.network = {
      lib,
      pkgs,
      config,
      ...
    }: {
      config = {
        home.packages = with pkgs; [
          netcat
        ];
      };
    };
  };
}
