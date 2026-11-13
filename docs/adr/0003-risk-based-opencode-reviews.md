# 0003. Risk-Based OpenCode Reviews

**Status:** Accepted

**Date:** 2026-11-07

**Amended:** 2026-11-13 — bounded reviewer → Explore research delegation.

## Context

Independent review should catch consequential technical, domain, and product
problems without making every local task expensive or turning native Plan and
Build into orchestration runtimes. Repeated engineering guidance in agent
prompts also makes the quality bar difficult to maintain consistently.

## Decision

- Keep native V2 Plan and Build prompts and append instructions through the
  existing plugin's supported session context hook. Their independent reviews
  require explicit user requests.
- Maintain canonical Markdown blocks for engineering principles, implementation
  methods, local safety, and a common review contract. Route only relevant
  blocks to each agent; Explore receives no coding procedures.
- Retain a technical `codereviewer` and add independent `domainreviewer` and
  `productreviewer` subagents. Reuse each platform's existing reviewer model.
- Let `orchestrator-build` select pre/post reviews based on separate technical,
  domain, and product significance, not implementation size. Preserve approved
  decisions and stop before implementation on unresolved material product,
  domain, or architecture decisions.
- Resolve ordinary factual/technical gaps autonomously. Consolidate in-scope
  blocking technical fixes into at most two correction rounds by default;
  stop earlier on repetition or lack of progress. Escalate substantive changes.
- Require evidence appropriate to risk, not reviewer agreement, for completion.
  Report review coverage, findings dispositions, validation, and unresolved gaps.
- Keep ADR edits owned by the primary agent. Follow repository spec/ADR
  conventions without mandatory documentation ceremony for small tasks.
- Keep work local unless separately authorized: no automatic commits, pushes,
  PR creation, or merges, and no discarding unrelated changes.
- Allow reviewers to delegate only focused investigative work to the existing
  `explore` agent. Deny other reviewer child targets and all Explore delegation
  with final permission overlays; retain `subagent_depth = 2` for the
  orchestrator → reviewer → Explore chain. This narrows ADR 0002's broad
  reviewer/research delegation allowance, without changing trusted shell access.
- Keep known-file/local investigation direct; normally one research delegation,
  a second only for an independent question. Explore supplies evidence, not
  verdicts. Reviewers verify consequential evidence, retain independent judgment,
  and must not use research to obtain another reviewer's judgment or delegate
  implementation, editing, further review, or orchestration.

ADR 0002's trusted-shell policy remains unchanged and extends to all reviewers.
A narrower reviewer shell policy was considered but is not introduced: project
validation may require arbitrary toolchains, and an allowlist would change the
accepted usability tradeoff. Direct edits remain denied; shell/MCP access is
not containment. This decision supersedes only ADR 0002's placement of
restriction reporting exclusively in individual agent prompts: common safety
and reviewer gap reporting now live in selectively injected canonical blocks.

## Consequences

- Agent role prompts stay focused while shared guidance is injected once per
  block without replacing native prompts.
- Reviewers return compatible PASS, ADVISORY, BLOCKED, or INSUFFICIENT_CONTEXT
  reports; the orchestrator adjudicates findings rather than following orders.
- Prompt instructions guide behavior but do not enforce a security sandbox or
  guarantee model judgment. Runtime evaluation is separate from routing tests.
- No durable controller, mandatory master skill, automatic publishing workflow,
  or new isolation infrastructure is introduced. Optional method skills remain
  follow-up work justified by observed needs.

## Verification

See [workflow and evaluation](../opencode-workflow.md), the plugin instruction
tests, and the permission tests. Deterministic checks establish routing and
modeled permissions; live scenarios must establish actual review selection,
defect detection, escalation, and correction behavior.
