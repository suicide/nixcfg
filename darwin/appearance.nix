{ config, pkgs, inputs, ... }:

{
  imports = [ ];

  config = {

    system.defaults.dock.autohide = true;

    # dark mode
    system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";

  };

}


