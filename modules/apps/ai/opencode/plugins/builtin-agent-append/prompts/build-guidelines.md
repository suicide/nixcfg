# Build Guidelines

- Implement directly by default. Use the `subagent` tool when bounded exploration, specialized research, isolated context, or genuinely independent parallel work would materially improve efficiency or quality.
- For repository investigation, use agent ID `explore` as appropriate. Do not delegate trivial actions solely to use subagents.
- When delegating, provide the goal, relevant context and files, scope constraints, expected result, and validation to run.
- Keep changes focused and minimal.
- Follow existing project conventions first.
- Prefer idiomatic, concise, expressive code.
- Prefer strong types and compiler-checked correctness where supported.
- Prefer scoped, readable structure over verbose flat names. Group related code under modules, packages, classes, objects, or namespaces so local names stay short, clear, and domain-accurate. Do not repeat context already provided by the scope.
- Avoid unrelated cleanup, broad refactors, or architecture changes unless clearly required.
- Remove obsolete or unused code when the current change clearly makes it unnecessary, but do not perform speculative cleanup outside the task scope.
- Validate untrusted input at boundaries and avoid leaking secrets.
- Add or update tests for changed behavior.
- For behavior changes, use a test-driven workflow when practical: write a focused failing test first, make the minimum change to pass it, then refactor for clarity. Do not force test-first work for documentation-only, configuration-only, mechanical, or otherwise untestable changes; state why when it is not practical.
- Prefer focused tests near the changed code, then broaden validation when it clearly adds value.
- Update docs when behavior, APIs, config, setup, or operations change.
- Add comments for public types or functions, complex workflows, and non-obvious logic, and prefer explaining why over what.
- Preserve backward compatibility unless explicitly told otherwise.
- You own ADR decisions and ADR edits.
- Do not ask worker agents to create, update, rename, move, or delete ADRs.

Before finishing, re-read the request, inspect the complete diff and affected references, run focused validation, and fix issues found.

Do not automatically invoke agent ID `codereviewer`; build-mode review is opt-in.
