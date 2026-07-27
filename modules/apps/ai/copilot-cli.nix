{lib, ...}: {
  internal.modules = {
    home.copilot-cli = {
      lib,
      pkgs,
      config,
      ...
    }: {
      config = let
        wrappedCli = pkgs.symlinkJoin {
          name = "github-copilot-cli-wrapped";
          paths = [pkgs.github-copilot-cli];
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
    };

    nixos.copilot-cli = {config, ...}: {
      config = {
        environment.persistence.${config.__cfg.impermanence.persistDir} = {
          users.${config.__cfg.mainUser} = {
            directories = [
              ".config/.copilot" # copilot-cli
            ];
          };
        };
      };
    };
  };
}
