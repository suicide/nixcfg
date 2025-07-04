{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
  ];

  config = {
    environment.systemPackages = with pkgs; [
      colima
      docker
      docker-compose
    ];

    # thanks to https://github.com/nix-darwin/nix-darwin/issues/1182#issuecomment-2485401568
    launchd.agents."colima.default" = {
      command = "${pkgs.colima}/bin/colima start --foreground";
      serviceConfig = {
        Label = "com.colima.default";
        RunAtLoad = true;
        KeepAlive = true;

        # not sure where to put these paths and not reference a hard-coded `$HOME`; `/var/log`?
        StandardOutPath = "/Users/${config.system.primaryUser}/.colima/default/daemon/launchd.stdout.log";
        StandardErrorPath = "/Users/${config.system.primaryUser}/.colima/default/daemon/launchd.stderr.log";

        # not using launchd.agents.<name>.path because colima needs the system ones as well
        EnvironmentVariables = {
          PATH = "${pkgs.colima}/bin:${pkgs.docker}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
        };
      };
    };
  };
}
