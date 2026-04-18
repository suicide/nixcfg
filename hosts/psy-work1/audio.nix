{pkgs, ...}: let
  audioInitScript = pkgs.writeShellScript "psy-work1-audio-init" ''
    set -eu

    wpctl=${pkgs.wireplumber}/bin/wpctl
    sleep_bin=${pkgs.coreutils}/bin/sleep
    awk_bin=${pkgs.gawk}/bin/awk

    combined_sink="psy_work1_all_outputs"
    display_sink="alsa_output.pci-0000_09_00.1.hdmi-stereo-extra2"
    headphones_sink="alsa_output.pci-0000_0b_00.4.analog-stereo"

    sink_id() {
      "$wpctl" status -n | "$awk_bin" -v target="$1" '
        $2 == "*" && $4 == target && ($0 ~ /\[vol:/ || $0 ~ /\[Audio\/Sink\]/) {
          sub(/\.$/, "", $3)
          print $3
          exit 0
        }
        $3 == target && ($0 ~ /\[vol:/ || $0 ~ /\[Audio\/Sink\]/) {
          sub(/\.$/, "", $2)
          print $2
          exit 0
        }
      '
    }

    i=0
    while [ "$i" -lt 30 ]; do
      combined_id=$(sink_id "$combined_sink" || true)
      display_id=$(sink_id "$display_sink" || true)
      headphones_id=$(sink_id "$headphones_sink" || true)

      if [ -n "$combined_id" ] \
        && [ -n "$display_id" ] \
        && [ -n "$headphones_id" ]; then
        break
      fi

      i=$((i + 1))
      "$sleep_bin" 1
    done

    if [ -z "''${combined_id:-}" ] \
      || [ -z "''${display_id:-}" ] \
      || [ -z "''${headphones_id:-}" ]; then
      exit 1
    fi

    "$wpctl" set-default "$combined_id"
    "$wpctl" set-mute "$combined_id" 0
    "$wpctl" set-mute "$display_id" 1
    "$wpctl" set-mute "$headphones_id" 0
    "$wpctl" set-volume "$combined_id" 0.3
    "$wpctl" set-volume "$headphones_id" 1
  '';
in {
  config = {
    __cfg.audio.defaultVolume = 0.3;

    services.pipewire.extraConfig.pipewire."10-psy-work1-combined-sink" = {
      "context.modules" = [
        {
          name = "libpipewire-module-combine-stream";
          args = {
            "combine.mode" = "sink";
            "node.name" = "psy_work1_all_outputs";
            "node.description" = "All Outputs";
            # The HDMI display and capture card will not share a clock with the
            # onboard output, so latency compensation reduces audible drift.
            "combine.latency-compensate" = true;
            "combine.props" = {
              "audio.position" = ["FL" "FR"];
            };
            "stream.props" = {
              "stream.dont-remix" = true;
            };
            "stream.rules" = [
              {
                matches = [
                  {
                    "media.class" = "Audio/Sink";
                    "node.name" = "alsa_output.pci-0000_0b_00.4.analog-stereo";
                  }
                ];
                actions = {
                  create-stream = {
                    "combine.audio.position" = ["FL" "FR"];
                    "audio.position" = ["FL" "FR"];
                  };
                };
              }
              {
                matches = [
                  {
                    "media.class" = "Audio/Sink";
                    "node.name" = "alsa_output.pci-0000_09_00.1.hdmi-stereo-extra2";
                  }
                ];
                actions = {
                  create-stream = {
                    "combine.audio.position" = ["FL" "FR"];
                    "audio.position" = ["FL" "FR"];
                  };
                };
              }
            ];
          };
        }
      ];
    };

    services.pipewire.wireplumber.extraConfig."10-psy-work1-audio-labels" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {
              "node.name" = "alsa_output.pci-0000_09_00.1.hdmi-stereo-extra2";
            }
          ];
          actions = {
            "update-props" = {
              "node.description" = "Display Speakers";
              "node.nick" = "Display Speakers";
            };
          };
        }
      ];
    };

    systemd.user.services.psy-work1-audio-init = {
      description = "Restore psy-work1 audio defaults";
      after = [
        "pipewire.service"
        "pipewire-pulse.service"
        "wireplumber.service"
      ];
      wants = [
        "pipewire.service"
        "pipewire-pulse.service"
        "wireplumber.service"
      ];
      wantedBy = ["default.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = audioInitScript;
      };
    };

    # To include the Elgato capture card as a third sink again, switch the GPU
    # audio card to the "pro-audio" profile and match these sink names instead:
    # - display: alsa_output.pci-0000_09_00.1.pro-output-8 (VE248)
    # - capture: alsa_output.pci-0000_09_00.1.pro-output-9 (Elgato)
  };
}
