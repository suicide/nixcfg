import { Plugin } from "@opencode/plugin"

import { applyAgentInstructions } from "./instructions.ts"

export default Plugin.define({
  id: "psy.builtin-agent-append",
  async setup(ctx) {
    await ctx.session.hook("context", (event) => {
      applyAgentInstructions(event.agent, event.system)
    })
  },
})
