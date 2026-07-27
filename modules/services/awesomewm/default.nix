{...}: {
  internal.modules = {
    # Inactive: commented/unselected in legacy entrypoint, preserved for reference.
    home.awesomewm = {
      lib,
      pkgs,
      config,
      ...
    }: {
      imports = [
        ./_awesome.nix
      ];
    };
  };
}
