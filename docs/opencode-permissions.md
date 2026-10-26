# OpenCode permissions

The shared policy is in
[`_permissions.nix`](../modules/apps/ai/opencode/_permissions.nix). Shell execution
is allowed by default, followed by approval rules for direct high-impact
operations. See [ADR 0002](adr/0002-trusted-opencode-shell-execution.md) for the
accepted trust boundary and matching limitations.

## Exceptions

| Family | Direct operations requiring approval | Reason |
| --- | --- | --- |
| Privilege | `sudo`, `doas` | Escalates host authority |
| Git | push, reset, clean | Remote writes or possible local data loss |
| GitHub | PR merge, repository deletion | Integrates code or destroys remote data |
| Kubernetes | apply, create, delete, replace, patch, edit, scale, rollout restart/undo | Changes cluster state |
| Helm | install, upgrade, uninstall, rollback | Changes deployed releases |

Inspection, project scripts, tests, builds, and rendering do not need an
executable allowlist. Exceptions are raw-text accident guardrails, not a
sandbox or an exhaustive classification of mutations. In particular, wrappers
and scripts can bypass them; saved approvals can bypass `ask`.

Plan/explore remain read-oriented, and the reviewer must not intentionally
edit source. Reviewer/explore allow tools by default, including MCP, skills,
Code Mode, and subagent delegation; direct edit/write/patch operations are
denied. One level of nested delegation is enabled (`subagent_depth = 2`).
Shell and MCP access are not read-only containment. Explicit restriction-error
reporting is retained.
External directories still ask, except Nix-store reads; direct store edits
remain denied.

## Evidence

A bounded local sample around the V2 migration showed predominantly ordinary
inspection, Nix, Git, and `direnv` work, and at least one privilege-escalation
command. It did not show Kubernetes/Helm work; those exceptions reflect the
declared cross-project workflows rather than invented usage counts.

Local deployment/session timestamps put the V2 transition around 22:00 CET on
October 25, 2026 (21:00 UTC). Earlier records are not V2 prompt evidence. The
available V2 logs do not provide a complete approval-decision history, and
tool records and saved rules are not prompt counts. No historical before/after
interruption percentage is claimed; measure a comparable session after reload.
No raw histories, personal paths, or transcripts are retained here.

## Checks and activation

Run the focused settings checks for the host being changed:

```sh
nix eval --json '.#nixosConfigurations.<host>.config.home-manager.users.<user>.programs.opencode.settings' \
  | nix run nixpkgs#python3 -- modules/apps/ai/opencode/tests/permissions.py
nix fmt .
nix flake check
```

The Python checks model V2 matching; they do not execute the scanner, a model,
or any shell command being tested. Runtime checks must additionally inspect
`opencode debug config` and `opencode debug agents` after activating the Home
Manager configuration and running `opencode reload`. Verify that Markdown
frontmatter does not append an obsolete reviewer policy.

On a cold V2.1.1 service, agent listing can precede configuration-plugin
activation and show only built-ins or an empty list. Run
`opencode api model.list --param 'location[directory]=<absolute-project-directory>'`
first to await activation (metadata only; it does not invoke a model), then
inspect agents at that location.

Verification on V2.1.1 loaded the generated permissions and Markdown agents in
an isolated HOME/XDG environment and private service. All seven test groups
passed against the effective agent rules, with no saved approvals; direct
edits remained denied for plan/explore/reviewer. MCP/plugin integrations were
omitted from the test environment, and no model messages or real high-impact
commands were executed. This verifies loading/ordering and modeled matching,
not end-to-end tool execution or observed prompt reduction.

Use a new temporary Git project/session without saved approvals for prompt
checks. Exercise harmless inspection and validation first. For high-impact
commands, use inert executables named `git`, `sudo`, `doas`, `gh`, `kubectl`,
and `helm` at the front of the test environment's `PATH`; never test against
real remotes or clusters, and reject pending requests rather than approving
them. Check flag-prefixed and compound forms as well as bare commands.

Confirm external-directory access still asks, store reads do not, and
reviewer direct edits remain denied. Use the saved-permission API to confirm
the clean project has no approvals masking the outcome. Do not delete existing
project approvals to perform a test. Record remaining prompts and known
wrapper gaps separately from successful direct-command guardrails.
