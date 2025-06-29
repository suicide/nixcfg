{
  config,
  pkgs,
  inputs,
  ...
}: {
  config = {
    home = {
      username = "psy";
      homeDirectory = "/Users/psy";
    };

    programs.git = {
      userName = "Patrick Sy";
      userEmail = "patrick.sy@telekom.de";

      extraConfig = {
        user.signingkey = "DDDC8EC51823195E";
      };
    };
  };
}
