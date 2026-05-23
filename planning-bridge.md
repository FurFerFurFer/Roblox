# Brain Brawl Planning Bridge

## Goal

Brain Brawl planning should stay centralized in this directory:

`/home/furferfurfer/Desktop/Roblox-project/Roblox`

When working in another VS Code folder or a future real Roblox project, that
project should be able to see these planning files without copying them:

- `AGENTS.md`
- `README.md`
- `bro.md`
- `notes.md`
- `To-Do.md`
- `bro.luau`

This keeps `bro.md`, `notes.md`, `To-Do.md`, and `bro.luau` as the active
source of truth while still letting Claude, Codex, and other LLM tools read the
plan from the active project.

## Recommended Setup

Use two access layers together:

1. **VS Code multi-root workspace**
   - Open the real project folder in VS Code.
   - Add `/home/furferfurfer/Desktop/Roblox-project/Roblox` as another workspace folder.
   - Save the workspace when the folder pairing is useful.

2. **Local planning symlink inside the active project**
   - Create a symlink named `_brain_brawl_planning` inside the project you are
     actively editing.
   - LLM tools that can only see the current project can then read:
     `_brain_brawl_planning/bro.md`
     `_brain_brawl_planning/notes.md`
     `_brain_brawl_planning/To-Do.md`
     `_brain_brawl_planning/bro.luau`
     `_brain_brawl_planning/AGENTS.md`

The symlink is the important part for Claude and other local coding agents,
because many of them limit file access to the currently opened project.

## Helper Script

From any target project directory, run:

```bash
bash /home/furferfurfer/Desktop/Roblox-project/Roblox/tools/link-planning.sh .
```

That creates:

```text
_brain_brawl_planning -> /home/furferfurfer/Desktop/Roblox-project/Roblox
```

If the target project is a Git repository, the script also adds the symlink name
to `.git/info/exclude` so it stays local and does not pollute the real project.

## Agent Context Snippet

Add this to the target project's `AGENTS.md`, `CLAUDE.md`, or equivalent agent
instruction file:

```md
## Brain Brawl Planning Bridge

Brain Brawl planning lives at `_brain_brawl_planning/`, which links to
`/home/furferfurfer/Desktop/Roblox-project/Roblox`.

Before answering prompts or changing Brain Brawl logic, read:
- `_brain_brawl_planning/AGENTS.md`
- `_brain_brawl_planning/README.md`
- `_brain_brawl_planning/bro.md`
- `_brain_brawl_planning/notes.md`
- `_brain_brawl_planning/To-Do.md`, starting with its start-of-coding routine
- `_brain_brawl_planning/bro.luau`

Treat those files as planning and Luau draft artifacts, not as the final Roblox
Studio source tree. Update the planning files when the user changes the design.
Put open questions, reminders, unfinished ideas, and deferred decisions in
`_brain_brawl_planning/notes.md`. Do not copy these files into the production
project unless the user explicitly asks.
```

## Why Not Copy Files?

Copying `bro.md`, `notes.md`, `To-Do.md`, or `bro.luau` into each project would
create stale versions. The bridge keeps one canonical planning directory and
gives every tool a stable path to it.

## Future MCP Version

When the real MCP server exists, it should expose this directory as read/write
planning resources first:

- `brain-brawl://agents`
- `brain-brawl://design`
- `brain-brawl://notes`
- `brain-brawl://to-do`
- `brain-brawl://luau-draft`

The MCP server can later add sync commands for the real Roblox project, but the
first version should only expose these planning artifacts.
