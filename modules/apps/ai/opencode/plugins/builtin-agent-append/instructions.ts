import buildGuidelines from "./prompts/build-guidelines.md" with { type: "text" }
import planGuidelines from "./prompts/plan-guidelines.md" with { type: "text" }

export interface Instruction {
  readonly text: string
}

export interface ContextPart {
  type: string
  text: string
}

/** Validate and normalize a prompt imported as raw text. */
function loadInstruction(name: string, source: string): Instruction {
  const text = source.trim()
  if (!text) {
    throw new Error(`Empty instruction block: ${name}`)
  }
  return { text }
}

/**
 * Canonical instruction blocks. Keep each block self-contained so it can be
 * routed to multiple agents without duplicating prompt text.
 */
export const INSTRUCTIONS = {
  "build-guidelines": loadInstruction("build-guidelines", buildGuidelines),
  "plan-guidelines": loadInstruction("plan-guidelines", planGuidelines),
} as const satisfies Readonly<Record<string, Instruction>>

type InstructionID = keyof typeof INSTRUCTIONS

/**
 * Agent IDs map to ordered instruction blocks. Add a block to every agent that
 * needs it; unknown agents deliberately receive no additional instructions.
 */
export const AGENT_INSTRUCTIONS = {
  build: ["build-guidelines"],
  plan: ["plan-guidelines"],
} as const satisfies Readonly<Record<string, readonly InstructionID[]>>

/** Resolve an agent's instruction blocks, rejecting invalid routing entries. */
export function selectInstructions(
  agent: string,
  instructions: Readonly<Record<string, Instruction>>,
  routing: Readonly<Record<string, readonly string[]>>,
): readonly Instruction[] {
  return (routing[agent] ?? []).map((id) => {
    const instruction = instructions[id]
    if (!instruction) {
      throw new Error(`Unknown instruction block for agent ${agent}: ${id}`)
    }
    return instruction
  })
}

/**
 * Append instructions without replacing existing system content or repeating
 * an identical block when the context hook runs more than once.
 */
export function appendInstructions(
  system: ContextPart[],
  instructions: readonly Instruction[],
): void {
  for (const instruction of instructions) {
    if (system.some((part) => part.text === instruction.text)) continue
    system.push({ type: "text", text: instruction.text })
  }
}

export function applyAgentInstructions(agent: string, system: ContextPart[]): void {
  appendInstructions(system, selectInstructions(agent, INSTRUCTIONS, AGENT_INSTRUCTIONS))
}
