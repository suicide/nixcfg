# Oh my opencode

Generate config via
[guide](https://github.com/code-yeongyu/oh-my-opencode/blob/dev/docs/guide/installation.md)

```shell
bunx oh-my-opencode install --no-tui --claude=no --gemini=yes --copilot=no
```

You can run the command in a `oven/bun` container. The output shows where it
wrote the necessary config.

In `.config/opencode/opencode.json` the `oh-my-opencode` plugin is added (also
the antigravity installation):

```json
{
  "plugin": [
    "oh-my-opencode@latest",
    "opencode-antigravity-auth@1.4.6"
  ]
}
```

The installer then creates `.config/opencode/oh-my-opencode.json`.
