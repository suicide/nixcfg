# Clipboard & Primary Selection Workflow

This document describes the clipboard and primary selection setup in this Nix
configuration.

## Mental Model

Wayland (wlroots) provides two independent selection buffers:

| Buffer            | Purpose                                       | Policy |
|-------------------|-----------------------------------------------|--------|
| **Clipboard**     | Explicit copy/paste (Ctrl+C / Ctrl+V)         | Runtime-persisted and text-history-managed |
| **Primary**       | Middle-click paste, tmux copy-mode selections | Transient, no history |

They are deliberately kept **separate and unsynchronised**. There is no
clipboard manager syncing them, and third-party tools that unify them are not
used.

## Components

### wl-clipboard (`wl-copy` / `wl-paste`)

Low-level Wayland clipboard utilities. Not invoked directly by the user; used
by the automation below.

### wl-clip-persist

Runs as a background daemon, started by Hyprland. It monitors the regular
clipboard buffer and re-owns the selection whenever the owning application
closes, so clipboard content survives application exit.

Only the **regular clipboard** is runtime-persisted. This is not clipboard
history and is not intentional disk storage; it just keeps the current regular
clipboard pasteable after the source application exits.

Primary selection is ephemeral by design. It should represent the current live
selection, not a second durable clipboard.

### cliphist

A clipboard history manager. It watches `wl-paste --type text` and stores text
entries into a persistent history. Images are not tracked.

Accessed via **SUPER+V** in Hyprland, which opens a rofi dmenu with recent
clipboard entries. Selecting an entry copies it back to the regular clipboard.

## Daily Workflow

| Action                                      | Buffer     | Key / Gesture                          |
|---------------------------------------------|------------|----------------------------------------|
| Copy (explicit)                             | Clipboard  | Ctrl+Shift+C (kitty), Ctrl+C (GUI)     |
| Paste (explicit)                            | Clipboard  | Ctrl+Shift+V (kitty), Ctrl+V (GUI)     |
| Select text with mouse                      | Primary    | automatic in kitty/Linux               |
| Paste primary                               | Primary    | Middle click                           |
| Open clipboard history                      | Clipboard  | SUPER+V (rofi picker)                  |
| Wipe clipboard history & clear buffers      | —          | SUPER+SHIFT+V                          |
| Copy in tmux copy-mode (`y`, `Enter`, drag) | Primary    | (automatic, see tmux section)          |
| Paste tmux buffer                           | Tmux       | prefix + `]` or middle click           |

## Tmux Behavior

tmux is configured with `set -g set-clipboard off`. This prevents tmux from
writing copied selections to the regular system clipboard via the terminal's
OSC 52 integration. Mouse selection in tmux behaves like a normal terminal:
selected text goes to primary selection only, never to the regular clipboard.

### Middle-click paste

Unbinds the default `MouseDown2Pane` and replaces it with a command that:

1. Reads the current **primary selection** with `wl-paste --primary --no-newline`
2. Loads it into the tmux buffer
3. Pastes the buffer

This means clicking the middle mouse button in tmux pastes whatever is in the
primary selection (e.g. text selected in another terminal or editor).

### Copy-mode selections

Three actions in copy-mode-vi copy the selected text to the **primary
selection** via `wl-copy --primary`:

- `y` (yank)
- `Enter`
- `MouseDragEnd1Pane` (mouse drag release)

To paste the selection elsewhere, use middle click.

## Zsh Baseline

zsh-vi-mode system clipboard integration is **disabled**
(`ZVM_SYSTEM_CLIPBOARD_ENABLED=false`). Clipboard handling is delegated to the
compositor-layer tools above, avoiding conflicts and keeping the mental model
simple.

## Neovim

Neovim clipboard integration is investigated separately. This repository only
documents the desired behavior.

**Desired behavior** (documented here for reference):

- `y` / `p` stay Neovim-local.
- Register `+` reads/writes the regular Wayland clipboard.
- Register `*` reads/writes the Wayland primary selection.
- Do not globally set `unnamedplus` unless explicitly chosen later.
- Do not sync clipboard and primary.

## History Policy

cliphist stores its database in `$XDG_RUNTIME_DIR/cliphist/db`. This is a
tmpfs path that disappears on logout/reboot, so clipboard history never
survives a session. On lock, history is wiped explicitly (see below).

| Feature              | Status     |
|----------------------|------------|
| Regular clipboard    | Tracked by cliphist (text only) |
| Primary selection    | Not tracked |
| Images               | Not tracked |
| Across sessions      | No (tmpfs, wiped on logout) |

Clipboard history can be cleared with:

```shell
cliphist -db-path "$XDG_RUNTIME_DIR/cliphist/db" wipe
```

Or use the keyboard shortcut: **SUPER+SHIFT+V**. This also clears the current
regular clipboard and primary selection.

## Security

The clipboard history, the current regular clipboard, and the current primary
selection are all **cleared on lock** (before hyprlock appears). This is wired
into hypridle's `lock_cmd`.

Emergency manual wipe: **SUPER+SHIFT+V**.

### Bitwarden

If you use the Bitwarden browser extension, prefer **autofill** (Ctrl+Shift+L)
over copy/paste wherever possible. Enable Bitwarden's "Clear clipboard after
N seconds" setting as a fallback, but note that this only clears the current
clipboard - any entry already stored in cliphist before the timer fires will
persist until the next lock or manual wipe.

```shell
# Full emergency clipboard wipe
cliphist -db-path "$XDG_RUNTIME_DIR/cliphist/db" wipe
wl-copy --clear
wl-copy --primary --clear
```

Check that the clipboard daemons are running:

```shell
# wl-clip-persist daemon (persists regular clipboard)
pgrep -a wl-clip-persist

# cliphist store (watches for clipboard changes)
pgrep -a cliphist
```

Check clipboard content:

```shell
# Regular clipboard
wl-paste

# Primary selection
wl-paste --primary
```

Check cliphist history:

```shell
cliphist list
```

## Cleanup Commands

```shell
# Wipe entire clipboard history
cliphist -db-path "$XDG_RUNTIME_DIR/cliphist/db" wipe

# Clear current regular clipboard
wl-copy --clear

# Clear current primary selection
wl-copy --primary --clear

# Delete individual entries (interactive)
cliphist -db-path "$XDG_RUNTIME_DIR/cliphist/db" list | fzf | xargs cliphist -db-path "$XDG_RUNTIME_DIR/cliphist/db" delete
```

## Gotchas

- **wl-clip-persist must start before any application that owns the clipboard.**
  It is started in Hyprland's `on` startup handler; this is early enough for
  normal desktop use.
- **Primary selection is ephemeral.** If you copy to primary in a terminal/tmux
  and then close the owner, the primary selection may be lost. This is by design.
- **cliphist only tracks text.** Images and other MIME types are not stored.
- **tmux `set -g set-clipboard off`** prevents tmux from writing copied
  selections to the regular clipboard via OSC 52. Mouse selection in tmux
  affects primary selection only.
- **Wayland clipboard commands need Wayland environment variables.** tmux
  middle-click/copy-mode bindings call `wl-paste`/`wl-copy`; they need
  `WAYLAND_DISPLAY` and `XDG_RUNTIME_DIR` from the desktop session. A tmux
  server started before Hyprland, for example from a TTY, may need to be
  restarted inside the Wayland session.
- **If clipboard history seems missing**, ensure `wl-paste --type text --watch
  cliphist store` is running. Check with `pgrep -a cliphist`.
