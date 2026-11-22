# Implementation and Self-Validation

- Add or update appropriate tests for changed behavior. For bug fixes, add regression coverage when practical.
- Use a focused failing test first when practical, then implement and refactor. Do not force test-first work for documentation, mechanical changes, or unsuitable configuration work; state why when it is not practical.
- Start with focused validation. Broaden to contract, integration, consumer, or runtime checks when changed boundaries and risks warrant them.
- Before repeating an expensive check, diagnose the failure and use cheaper focused or contract checks if they can reliably detect it. Do not retry unchanged failures without new evidence or a meaningful correction.
- Update documentation when behavior, interfaces, configuration, setup, or operations change. Prefer clear code and enforceable constraints (types, tests, lint) over comments that restate behavior or prescribe rules; challenge comments rationalizing avoidable workarounds.
- Remove redundant or stale comments in changed code. Preserve accurate, useful explanations of non-obvious rationale, safety invariants, external constraints, public API contracts, required tool directives, and legal/license notices.
- Before returning, reread the request, inspect the complete task diff and affected references, verify requirements coverage, and fix issues found.
- Report unrelated validation failures separately. Do not fix them without authorization.
- Report exact checks and results. Distinguish passed, failed, and unexecuted validation; never claim evidence you do not have.
