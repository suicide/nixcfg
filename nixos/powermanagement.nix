{
  config,
  pkgs,
  inputs,
  ...
}: {
  config = {
    powerManagement = {
      enable = true;
    };

    services.power-profiles-daemon.enable = false;

    services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "ondemand";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        # CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        # CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      };
    };
  };
}
