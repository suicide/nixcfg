{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  neovimCfg = config.__cfg.neovim;
in {
  options = {
  };

  # neovim includes mcphub
  config = lib.mkIf neovimCfg.enable {
    xdg.configFile."mcphub/servers.json" = let
      podman = "${lib.getExe pkgs.podman}";
    in {
      text = builtins.toJSON {
        servers = {
          # git = {
          #   command = "${podman}";
          #   args = [
          #     "run"
          #     "-i"
          #     "--rm"
          #     "--mount"
          #     "type=bind,src=\${workspaceFolder},dst=/workspace"
          #     "mcp/git"
          #   ];
          # };

          # filesystem = {
          #   args = [
          #     "run"
          #     "-i"
          #     "--rm"
          #     "--mount"
          #     "type=bind,src=\${workspaceFolder},dst=/workspace"
          #     "mcp/filesystem"
          #     "/workspace"
          #   ];
          #   command = "${podman}";
          # };

          # fetch = {
          #   args = [
          #     "run"
          #     "-i"
          #     "--rm"
          #     "mcp/fetch"
          #   ];
          #   command = "${podman}";
          # };

          # sequentialthinking = {
          #   args = [
          #     "run"
          #     "--rm"
          #     "-i"
          #     "mcp/sequentialthinking"
          #   ];
          #   command = "${podman}";
          # };

          context7 = {
            type = "streamable-http";
            url = "https://mcp.context7.com/mcp";
          };

          # github = {
          #   url = "https://api.githubcopilot.com/mcp/";
          #   headers = {
          #     Authorization = "Bearer \${GITHUB_PERSONAL_ACCESS_TOKEN}";
          #   };
          # };

          # perplexity-ask = {
          #   command = "${podman}";
          #   args = [
          #     "run"
          #     "-i"
          #     "--rm"
          #     "-e"
          #     "PERPLEXITY_API_KEY"
          #     "mcp/perplexity-ask"
          #   ];
          #   env = {
          #     PERPLEXITY_API_KEY = "YOUR_PERPLEXITY_API_KEY";
          #   };
          # };

          # tavily = {
          #   command = "${podman}";
          #   args = ["run" "-i" "--rm" "-e" "TAVILY_API_KEY" "mcp/tavily"];
          #   env = {
          #     TAVILY_API_KEY = "\${TAVILY_API_KEY}";
          #   };
          # };
        };
      };
    };
  };
}
