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

const expectedRouting = {
  build: ["local-safety", "engineering-principles", "implementation-method", "build-guidelines"],
  plan: ["local-safety", "plan-guidelines"],
  implementer: ["local-safety", "engineering-principles", "implementation-method"],
  "orchestrator-build": ["local-safety", "engineering-principles"],
  codereviewer: ["local-safety", "engineering-principles", "review-contract"],
  domainreviewer: ["local-safety", "review-contract"],
  productreviewer: ["local-safety", "review-contract"],
  documentation: ["local-safety"],
} as const

test("routes role-appropriate canonical blocks in stable order", () => {
  assert.deepEqual(AGENT_INSTRUCTIONS, expectedRouting)

  for (const [agent, ids] of Object.entries(expectedRouting)) {
    const system: ContextPart[] = [{ type: "text", text: "native instructions" }]
    applyAgentInstructions(agent, system)
    applyAgentInstructions(agent, system)
    assert.deepEqual(system.map((part) => part.text), [
      "native instructions",
      ...ids.map((id) => INSTRUCTIONS[id].text),
    ])
  }
})

test("routing has no duplicate blocks and only configured agents", () => {
  assert.deepEqual(Object.keys(AGENT_INSTRUCTIONS), Object.keys(expectedRouting))

  for (const ids of Object.values(AGENT_INSTRUCTIONS)) {
    assert.equal(new Set(ids).size, ids.length)
  }
})

test("agents without routing receive no instructions", () => {
  assert.deepEqual(applyAgentInstructionsToNewSystem("explore"), [])
  assert.deepEqual(applyAgentInstructionsToNewSystem("unknown"), [])
  assert.deepEqual(applyAgentInstructionsToNewSystem("compaction"), [])
})

test("native agents keep independent review explicit-only for every lens", () => {
  for (const id of ["build-guidelines", "plan-guidelines"] as const) {
    const text = INSTRUCTIONS[id].text
    assert.match(text, /Do not automatically invoke independent reviewers/)
    for (const reviewer of ["codereviewer", "domainreviewer", "productreviewer"]) {
      assert.ok(text.includes(`\`${reviewer}\``))
    }
    assert.match(text, /explicit.*(?:request|review)/i)
  }
})

test("reviewers receive the same verdict contract without implementation methods", () => {
  for (const agent of ["codereviewer", "domainreviewer", "productreviewer"]) {
    const texts = applyAgentInstructionsToNewSystem(agent).map((part) => part.text)
    assert.equal(texts.filter((text) => text === INSTRUCTIONS["review-contract"].text).length, 1)
    assert.ok(!texts.includes(INSTRUCTIONS["implementation-method"].text))
  }
  for (const verdict of ["PASS", "ADVISORY", "BLOCKED", "INSUFFICIENT_CONTEXT"]) {
    assert.ok(INSTRUCTIONS["review-contract"].text.includes(verdict))
  }
})

function applyAgentInstructionsToNewSystem(agent: string): ContextPart[] {
  const system: ContextPart[] = []
  applyAgentInstructions(agent, system)
  return system
}
