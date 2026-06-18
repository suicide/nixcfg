const PROMPTS: Record<string, string> = {
  build: `
# Build Guidelines

- Direct implementation is the default. Delegate to subagents only when bounded exploration or parallel work clearly helps.
- Keep changes focused and minimal.
- Follow existing project conventions first.
- Prefer idiomatic, concise, expressive code.
- Prefer strong types and compiler-checked correctness where supported.
- Use short, clear, domain-accurate names. Avoid redundant, generic, or overly verbose names.
- Avoid unrelated cleanup, broad refactors, or architecture changes unless clearly required.
- Remove obsolete or unused code when the current change clearly makes it unnecessary, but do not perform speculative cleanup outside the task scope.
- Validate untrusted input at boundaries and avoid leaking secrets.
- Add or update tests for changed behavior.
- Prefer focused tests near the changed code, then broaden validation when it clearly adds value.
- Update docs when behavior, APIs, config, setup, or operations change.
- Add comments for public types or functions, complex workflows, and non-obvious logic, and prefer explaining why over what.
- Preserve backward compatibility unless explicitly told otherwise.
- You own ADR decisions and ADR edits.
- Do not ask worker agents to create, update, rename, move, or delete ADRs.
`.trim(),

  plan: `
# Planning Guidelines

- Delegate to multiple subagents \`@explore\` in parallel or in sequence for dedicated research tasks. Provide concrete instructions and context to the subagents.
- Identify whether the proposed work likely has ADR implications.
- Classify the implementation as \`simple\`, \`medium\`, or \`complex\`.
- Briefly justify that classification using the main drivers, such as moving parts, cross-cutting impact, architectural uncertainty, compatibility or migration risk, and validation breadth.
- Explicitly call out key unknowns that could change the classification.
- Do not invent missing details.

Include these fields in the final plan:

- \`Implementation complexity: simple|medium|complex\`
- \`Complexity rationale: ...\`
- \`ADR impact: none|likely|required\`
`.trim(),
};

export default async () => {
  return {
    "chat.message": async (input: any, output: any) => {
      const agent = output.message.agent ?? input.agent;
      const prompt = agent ? PROMPTS[agent] : undefined;
      if (!prompt) return;

      output.message.system = [output.message.system, prompt]
        .filter(Boolean)
        .join("\n\n");
    },
  };
};
