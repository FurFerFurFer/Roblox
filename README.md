# Brain Brawl Project Workflow

This directory is the planning ground for Brain Brawl. It is used for design
notes, workflow notes, and Luau implementation drafts. It is not the final
Roblox project source tree.

## AI Instruction Source

For AI agents and local LLM tools, [AGENTS.md](AGENTS.md) is the source of truth.
Read and follow it before answering any prompt while working in this workspace
or changing any planning file.

Recommended project/system instruction for tools that support custom rules:

```text
Always read and follow /home/furferfurfer/Desktop/Roblox-project/Roblox/AGENTS.md before answering any prompt while working in this workspace.
```

This README is only the human-facing overview. If README.md and AGENTS.md ever
conflict, AGENTS.md wins.

## Planning Files

| File | Purpose |
|---|---|
| `AGENTS.md` | Mandatory AI behavior rules for concept review and project updates |
| `README.md` | Human-facing workflow overview |
| `bro.md` | Living game design plan |
| `notes.md` | Open questions, reminders, unfinished ideas, and deferred decisions |
| `To-Do.md` | Builder task guide, map checklist, testing routine, and handoff checklist |
| `bro.luau` | Luau implementation draft with one labeled block per function |
| `planning-bridge.md` | Cross-workspace access design for VS Code and LLM tools |
| `tools/link-planning.sh` | Helper that links this planning directory into another project |

## Cross-Workspace Access

When working from another VS Code folder or a future real Roblox project, keep
this planning directory as the source of truth:

```text
/home/furferfurfer/Desktop/Roblox-project/Roblox
```

Recommended workflow:

1. Add `/home/furferfurfer/Desktop/Roblox-project/Roblox` as a second folder in
   a VS Code multi-root workspace.
2. From the active project directory, run:

   ```bash
   bash /home/furferfurfer/Desktop/Roblox-project/Roblox/tools/link-planning.sh .
   ```

3. Tell agents in that project to read `_brain_brawl_planning/AGENTS.md` before
   answering prompts or changing Brain Brawl files.

More detail lives in [planning-bridge.md](planning-bridge.md).

Use [notes.md](notes.md) for open questions, reminders, unfinished ideas, and
deferred decisions instead of storing loose notes inside `bro.md`, `To-Do.md`,
or `bro.luau`.
