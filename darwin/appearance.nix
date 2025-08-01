{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [];

  config = {
    system.defaults.dock.autohide = true;

    # dark mode
    system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";

    # natural scrolling off
    system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;

    # disable swipe between pages, page back and forward
    system.defaults.NSGlobalDomain.AppleEnableMouseSwipeNavigateWithScrolls = false;
    system.defaults.NSGlobalDomain.AppleEnableSwipeNavigateWithScrolls = false;

  };
}
