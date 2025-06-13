{ config, pkgs, inputs, ... }:

{
  config = {
    # enable suspend and hibernate
    services.logind = {
      lidSwitch = "suspend-then-hibernate";

      # power key handling
      powerKey = "hibernate";
      powerKeyLongPress = "poweroff";
    };

  };
}

