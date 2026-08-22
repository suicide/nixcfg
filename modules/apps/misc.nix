{...}: {
  internal.modules = {
    home.misc = {
      pkgs,
      inputs,
      ...
    }: {
      config = {
        home.packages = with pkgs;
          [
            btop
            htop
            dust
          ]
          ++ [
            inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.yt-dlp-streamtape
          ];
      };
    };
  };
}
