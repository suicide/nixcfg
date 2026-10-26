# 0002. Trusted OpenCode Shell Execution

**Status:** Accepted

**Date:** 2026-10-26

## Context

The OpenCode V2 migration made shell execution approval-controlled by default.
An allowlist of ordinary tools interrupts research and validation across Rust,
Nix, Node, Go, Java, and Kubernetes projects and cannot cover project scripts
without continually growing. Project/host sandboxing is a separate effort.

## Decision

- Allow ordinary shell execution for all working agents, including plan,
  explore, and the reviewer. Do not maintain a development-tool allowlist.
- Ask for direct privilege escalation (`sudo`, `doas`), Git push/reset/clean,
  GitHub PR merges/repository deletion, common Kubernetes mutations, and Helm
  install/upgrade/uninstall/rollback. These exceptions prevent accidental direct
  operations; they are not comprehensive security controls.
- Define the ordered policy once in the application's private
  `_permissions.nix`. Reviewer/explore allow tools by default, including MCP,
  skills, Code Mode, and delegation, then reapply shared guardrails and deny
  direct edits. Do not preserve the migration's blanket tool denials.
- Allow one level of nested delegation (`subagent_depth = 2`) so these
  subagents can delegate without permitting unbounded delegation chains.
- Keep external-directory approval and read-only Nix-store tool access.
- Preserve direct-edit restrictions for research/review roles. Read-oriented
  instructions guide shell use but do not contain shell writes or execution.
- Keep restriction-error reporting in individual custom agent definitions,
  not globally injected instructions.

## Consequences

- Tests, builds, scripts, inspection, and new toolchains work without adding
  permission exceptions. Validation may create build artifacts.
- Allowed shell commands have the host user's filesystem, process, network, and
  credential access. MCP tools may also modify state using their own authority.
  Scripts, aliases, interpreters, wrappers such as `direnv`,
  environment prefixes, and alternate clients can bypass the prompt patterns.
  This usability/security tradeoff is explicitly accepted until sandboxing.
- Patterns match raw command text. Middle wildcards cover options before
  subcommands but can over-prompt: `git stash push` and `git log --grep=push`
  also match the push guardrail. Kubernetes/Helm rules do not distinguish
  development from production, dry runs, or every possible mutation.
- GitHub API mutations and other publishing/deployment mechanisms are not
  comprehensively classified. Adding an ever-growing pattern list would not
  turn this policy into containment.
- Directory inference is best effort, and tool-level store edit denial does
  not restrict arbitrary shell programs. Normal Nix-store immutability remains
  the primary write protection.
- Saved project approvals can bypass `ask`, but not configured `deny`. Verify
  prompts in clean projects and prefer one-time approval for sensitive actions;
  wrapper/flag prefixes may produce overly broad saved approvals.
- Shell-based read-only containment, stronger credential/network boundaries,
  and comprehensive deployment protection remain sandbox requirements.

## Verification

See [the permission checks](../../modules/apps/ai/opencode/tests/permissions.py)
and [operational notes](../opencode-permissions.md). Check generated settings
and effective agents, not just the source rules, because agent permissions are
appended after global permissions.
