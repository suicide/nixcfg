{
  config,
  pkgs,
  inputs,
  ...
}: {
  config = {
    # enable suspend and hibernate
    services.logind = {
      lidSwitch = "suspend-then-hibernate";

      # power key handling
      powerKey = "hibernate";
      powerKeyLongPress = "poweroff";
    };

    # should switch to hibernate after said time
    # automatic estimation is the default value otherwise
    systemd.sleep.extraConfig = ''
      HibernateDelaySec=1h
    '';
  };
}
