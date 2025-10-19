{
  config,
  pkgs,
  inputs,
  ...
}: {
  config = {
    # enable suspend and hibernate
    services.logind = {

      settings.Login = {
        # power key handling
        HandlePowerKey = "hibernate";
        HandlePowerKeyLongPress = "poweroff";
      };

    };

    # should switch to hibernate after said time
    # automatic estimation is the default value otherwise
    systemd.sleep.extraConfig = ''
      HibernateDelaySec=1h
    '';
  };
}
