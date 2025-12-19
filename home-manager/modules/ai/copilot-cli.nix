{
  lib,
  pkgs,
  config,
  ...
}: {
  config = let
    wrappedCli = pkgs.symlinkJoin {
      name = "github-copilot-cli-wrapped";
      paths = [pkgs.github-copilot-cli]; # The package you want to wrap
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/copilot \
          --run 'export GITHUB_TOKEN="$(cat ~/.config/sops-nix/secrets/ai/github_copilot/token)"'
      '';
    };
  in {
    home.packages = with pkgs; [
      wrappedCli
    ];
  };
}
