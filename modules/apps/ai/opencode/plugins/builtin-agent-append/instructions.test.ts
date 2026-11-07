import assert from "node:assert/strict"
import test from "node:test"

import {
  AGENT_INSTRUCTIONS,
  INSTRUCTIONS,
  applyAgentInstructions,
  appendInstructions,
  selectInstructions,
  type ContextPart,
  type Instruction,
} from "./instructions.ts"

const blocks = {
  shared: { text: "shared guidance" },
  technical: { text: "technical guidance" },
  product: { text: "product guidance" },
} as const satisfies Readonly<Record<string, Instruction>>

test("selects shared blocks for multiple agents in stable order", () => {
  const routing = {
    codereviewer: ["shared", "technical"],
    productreviewer: ["shared", "product"],
  }

  assert.deepEqual(
    selectInstructions("codereviewer", blocks, routing).map((block) => block.text),
    ["shared guidance", "technical guidance"],
  )
  assert.deepEqual(
    selectInstructions("productreviewer", blocks, routing).map((block) => block.text),
    ["shared guidance", "product guidance"],
  )
})

test("does not leak instructions to unconfigured or unknown agents", () => {
  const routing = { build: ["shared"] } as const

  assert.deepEqual(selectInstructions("plan", blocks, routing), [])
  assert.deepEqual(selectInstructions("unknown", blocks, routing), [])
})

test("rejects routing entries with missing instruction blocks", () => {
  const routing = { build: ["missing"] } as const

  assert.throws(
    () => selectInstructions("build", blocks, routing),
    /Unknown instruction block for agent build: missing/,
  )
})

test("appends once while preserving existing system content", () => {
  const system: ContextPart[] = [
    { type: "text", text: "native instructions" },
    { type: "text", text: "technical guidance" },
  ]

  appendInstructions(system, [blocks.technical, blocks.shared])
  appendInstructions(system, [blocks.technical, blocks.shared])

  assert.deepEqual(system, [
    { type: "text", text: "native instructions" },
    { type: "text", text: "technical guidance" },
    { type: "text", text: "shared guidance" },
  ])
})

test("prompt files load as rendered Markdown", () => {
  assert.match(INSTRUCTIONS["build-guidelines"].text, /^# Build Guidelines\n/)
  assert.match(INSTRUCTIONS["plan-guidelines"].text, /^# Planning Guidelines\n/)

  for (const instruction of Object.values(INSTRUCTIONS)) {
    assert.doesNotMatch(instruction.text, /\\`/)
  }
})

test("configured native agents receive only their own nonempty block", () => {
  const build = applyAgentInstructionsToNewSystem("build")
  const plan = applyAgentInstructionsToNewSystem("plan")

  assert.equal(build.length, 1)
  assert.equal(plan.length, 1)
  assert.equal(build[0].text, INSTRUCTIONS["build-guidelines"].text)
  assert.equal(plan[0].text, INSTRUCTIONS["plan-guidelines"].text)
  assert.notEqual(build[0].text, plan[0].text)
})

test("routing has no duplicate blocks and only configured agents", () => {
  assert.deepEqual(Object.keys(AGENT_INSTRUCTIONS), ["build", "plan"])

  for (const ids of Object.values(AGENT_INSTRUCTIONS)) {
    assert.equal(new Set(ids).size, ids.length)
  }
})

test("agents without routing receive no instructions", () => {
  assert.deepEqual(applyAgentInstructionsToNewSystem("explore"), [])
})

function applyAgentInstructionsToNewSystem(agent: string): ContextPart[] {
  const system: ContextPart[] = []
  applyAgentInstructions(agent, system)
  return system
}
