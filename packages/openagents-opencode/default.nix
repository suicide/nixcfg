{
  lib,
  pkgs,
  openAgentsControlSrc,
  ...
}:
pkgs.symlinkJoin {
  name = "openagents-opencode";
  paths = [pkgs.opencode];
  buildInputs = [pkgs.makeWrapper];

  # opencode wants to write in the config dir (package.json, bun.lock, node_modules)
  # thus, we cannot just use the immutable dir in the nix store
  # we have to copy it over so that opencode may write/install some stuff
  postBuild = ''
    mv $out/bin/opencode $out/bin/openagents-opencode
    wrapProgram $out/bin/openagents-opencode \
     --run "
        # Create unique temp directory
        export WORK_DIR=\$(mktemp -d)
        trap 'rm -rf \"\$WORK_DIR\"' EXIT

        # Copy config subdirectory from store (fresh copy)
        cp -r \"${openAgentsControlSrc}/.opencode\" \"\$WORK_DIR/\"
        chmod -R u+w \"\$WORK_DIR/.opencode\"

        # we cannot use `--set` as it puts the export in single quotes
        # thus we would not be able to use the variable here
        export OPENCODE_CONFIG_DIR="\$WORK_DIR/.opencode"
      "
  '';
}
