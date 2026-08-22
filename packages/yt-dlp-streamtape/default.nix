{
  lib,
  pkgs,
  ...
}: let
  ytExtraSrc = pkgs.fetchFromGitHub {
    owner = "SAJIBxD";
    repo = "yt-extra";
    rev = "c0455606934cdca199c0729429aab15259a71f94";
    hash = "sha256-AuaZ4O1ez7xFa3Cq8wOjNZf+mQuBNU1Hdt/idgeVk4s=";
  };
  # yt-dlp's --plugin-dirs scans the *children* of each supplied directory for
  # yt_dlp_plugins/. Pointing directly at the checkout (which itself contains
  # yt_dlp_plugins/) does not work — the checkout must be a child of the plugin
  # directory. Create a reproducible parent whose child contains only the
  # Streamtape extractor, copying just yt_dlp_plugins/extractor/streamtape.py
  # from the pinned source. This ensures no KissAsian or m3u8_sniffer extractor
  # is exposed at runtime.
  ytExtraPluginsDir = pkgs.runCommand "yt-dlp-streamtape-plugins" {} ''
    mkdir -p $out/streamtape/yt_dlp_plugins/extractor
    cp ${ytExtraSrc}/yt_dlp_plugins/extractor/streamtape.py $out/streamtape/yt_dlp_plugins/extractor/streamtape.py
    cat > $out/streamtape/yt_dlp_plugins/extractor/__init__.py <<'EOF'
    from .streamtape import StreamtapeIE
    __all__ = ["StreamtapeIE"]
    EOF
  '';
in
  pkgs.symlinkJoin {
    name = "yt-dlp-streamtape";
    paths = [pkgs.yt-dlp];
    buildInputs = [pkgs.makeWrapper];

    # Wrap yt-dlp so it automatically searches the pinned plugin root
    # containing yt_dlp_plugins/. Preserve all user args and avoid global env vars.
    postBuild = ''
      wrapProgram $out/bin/yt-dlp \
        --add-flags "--plugin-dirs ${ytExtraPluginsDir}"
    '';

    meta = with lib; {
      description = "yt-dlp wrapped with Streamtape extractor only from SAJIBxD/yt-extra via --plugin-dirs";
      homepage = "https://github.com/SAJIBxD/yt-extra";
      license = licenses.unlicense;
      platforms = platforms.all;
      mainProgram = "yt-dlp";
    };
  }
