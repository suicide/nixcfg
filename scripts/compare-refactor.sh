#!/usr/bin/env bash
set -euo pipefail

# Compare the current workspace against a committed baseline.
#
# `base` defaults to HEAD. `ref` is the current workspace state (staged +
# unstaged), so each migration is checked before committing it.
#
# The temporary override MUST remain in both revisions during this test.

base_rev="HEAD"
flake_dir="$PWD"

usage() {
  printf 'Usage: %s [--base REV] [--flake DIR]\n' "$0"
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

base_url="git+file://${flake_dir}?rev=$(git -C "$flake_dir" rev-parse "$base_rev")"
ref_url="$flake_dir"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
rewrite_pattern='^\{"rewrites":\{.*:"([^"]+)"\}\}$'

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

for attr in "${attrs[@]}"; do
  before="$(nix eval --raw "$base_url#$attr")"
  after="$(nix eval --raw "$ref_url#$attr")"

  if [[ "$before" == "$after" ]]; then
    printf '%s\n  before: %s\n  after:  %s\n  => IDENTICAL DERIVATION\n\n' "$attr" "$before" "$after"
    continue
  fi

  printf '%s\n  before: %s\n  after:  %s\n  => DERIVATIONS DIFFER; COMPARING BUILT CONTENT\n\n' "$attr" "$before" "$after"

  target="${attr%.drvPath}"
  base_output="$tmpdir/base"
  ref_output="$tmpdir/ref"

  nix build "$base_url#$target" --out-link "$base_output"
  nix build "$ref_url#$target" --out-link "$ref_output"

  base_ca="$(content_addressed_path "$base_output")"
  ref_ca="$(content_addressed_path "$ref_output")"

  if [[ "$base_ca" == "$ref_ca" ]]; then
    printf '  => IDENTICAL CONTENT\n\n'
    continue
  fi

  printf '  base content: %s\n  ref content:  %s\n  => CONTENT DIFFERS\n\n' "$base_ca" "$ref_ca"
  echo "nix-diff for $attr:"
  nix run nixpkgs#nix-diff -- "$before" "$after"
  echo
  result=1
done

exit "$result"
