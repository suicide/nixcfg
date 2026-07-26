{...}: {
  internal.modules = {
    darwin.finder = {
      system.defaults.finder.AppleShowAllExtensions = true;
      system.defaults.finder.AppleShowAllFiles = true;
    };
  };
}
