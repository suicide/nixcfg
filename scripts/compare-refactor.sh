#!/usr/bin/env bash
set -euo pipefail

# Compare the current workspace against a committed baseline.
#
# `base` defaults to HEAD. `ref` is the current workspace state (staged +
# unstaged), so each migration is checked before committing it.
#
# Default: when derivations differ, nix-diff is shown for diagnostics and
# exit is 0 (no building).  Use --closures and/or --strict for deeper checks.

base_rev="HEAD"
flake_dir="$PWD"
do_closures=false
do_strict=false

usage() {
  cat <<EOF
Usage: $0 [OPTIONS]

Compare ref (current workspace) derivations against a base revision.

By default, when derivations differ, nix-diff is shown for diagnostics and
exit is 0.  No builds are performed.

Options:
  --base REV     Baseline revision (default: HEAD)
  --flake DIR    Flake directory (default: \$PWD)
  --closures     Build both outputs and show nix store diff-closures + nvd
                 diff results (informational, exit 0)
  --strict       Build both outputs and enforce content-addressed identity.
                 On differing content, print canonical paths and exit non-zero.
  --help         Show this help and exit
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --base)
      base_rev="$2"
      shift 2
      ;;
    --flake)
      flake_dir="$2"
      shift 2
      ;;
    --closures)
      do_closures=true
      shift
      ;;
    --strict)
      do_strict=true
      shift
      ;;
    --help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      exit 2
      ;;
  esac
done

base_url="git+file://${flake_dir}?rev=$(git -C "$flake_dir" rev-parse "$base_rev")" || exit 1
ref_url="$flake_dir"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
rewrite_pattern='^\{"rewrites":\{"[^"]*":"([^"]+)"\}\}$'

content_addressed_path() {
  local rewrites
  rewrites="$(nix store make-content-addressed --quiet --json "$1")"

  if [[ "$rewrites" =~ $rewrite_pattern ]]; then
    printf '%s\n' "${BASH_REMATCH[1]}"
    return
  fi

  printf 'Unable to read the content-addressed store path.\n' >&2
  return 1
}

attrs=(
  # nixosConfigurations.psy-fw13.config.system.build.toplevel.drvPath
  nixosConfigurations.psy-work1.config.system.build.toplevel.drvPath
  # nixosConfigurations.qemu.config.system.build.toplevel.drvPath
  # darwinConfigurations.psy-mac.system.drvPath
)

echo "base: $base_url"
echo "ref : $ref_url"
echo

result=0
idx=0

for attr in "${attrs[@]}"; do
  idx=$((idx + 1))
  before="$(nix eval --raw "$base_url#$attr")" || exit 1
  after="$(nix eval --raw "$ref_url#$attr")" || exit 1

  if [[ "$before" == "$after" ]]; then
    printf '%s\n  before: %s\n  after:  %s\n  => IDENTICAL DERIVATION\n\n' "$attr" "$before" "$after"
    continue
  fi

  # Derivations differ – always show nix-diff for diagnostic context.
  printf '%s\n  before: %s\n  after:  %s\n  => DERIVATIONS DIFFER\n\n' "$attr" "$before" "$after"

  echo "nix-diff for $attr:"
  # Intentionally not guarded (set -e above): a failing diff is fatal.
  nix run nixpkgs#nix-diff -- "$before" "$after"
  echo

  target="${attr%.drvPath}"

  if "$do_closures" || "$do_strict"; then
    # Build each required side exactly once per attribute (shared when both
    # flags are used).  $tmpdir paths are fresh each loop iteration so the
    # builds are always performed unconditionally.
    base_output="$tmpdir/base.$idx"
    ref_output="$tmpdir/ref.$idx"

    nix build "$base_url#$target" --out-link "$base_output"
    nix build "$ref_url#$target" --out-link "$ref_output"

    if "$do_closures"; then
      echo "nix store diff-closures for $attr:"
      nix store diff-closures "$base_output" "$ref_output" || true
      echo
      echo "nvd diff for $attr:"
      nix run nixpkgs#nvd -- diff "$base_output" "$ref_output" || true
      echo
    fi

    if "$do_strict"; then
      base_ca="$(content_addressed_path "$base_output")" || exit 1
      ref_ca="$(content_addressed_path "$ref_output")" || exit 1

      if [[ "$base_ca" == "$ref_ca" ]]; then
        printf '  => IDENTICAL CONTENT\n\n'
      else
        printf '  base content: %s\n  ref content:  %s\n  => CONTENT DIFFERS\n\n' "$base_ca" "$ref_ca"
        result=1
      fi
    fi
  fi
done

exit "$result"
