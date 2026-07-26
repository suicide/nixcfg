{...}: {
  # Declares app cask/formula lists.
  # Requires `darwin.brew` (or another module) to enable Homebrew.
  internal.modules = {
    darwin.apps = {
      homebrew = {
        casks = [
          "caffeine"
          "google-chrome"
          "microsoft-teams"
        ];

        brews = [];
      };
    };
  };
}
