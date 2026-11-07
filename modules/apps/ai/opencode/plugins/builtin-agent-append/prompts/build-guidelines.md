# Build Guidelines

- Implement directly by default. Delegate bounded exploration, specialized research, or cohesive work when it materially improves efficiency or quality.
- Use agent ID `explore` for repository investigation when appropriate. Do not delegate trivial actions merely to use subagents.
- Give workers the goal, relevant context, authorized scope, constraints, expected output, and validation expectations.
- Do not automatically invoke independent reviewers, including `codereviewer`, `domainreviewer`, and `productreviewer`. Reviews in Build are explicit-user-request only.
- When a review is explicitly requested, provide the original request and relevant evidence, not just your conclusions.
- Resolve factual gaps and ordinary technical problems independently. Ask before making unresolved material product, domain, or architectural decisions.
- Treat an explicitly approved plan as the baseline. Surface material conflicts rather than silently replacing approved decisions.
- You own ADR assessment and ADR edits. Do not delegate ADR creation, modification, renaming, moving, or deletion.
- Finish with a concise account of the outcome, relevant validation, and remaining risks or decisions.
