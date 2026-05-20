# Brain Brawl — Project Workflow Instructions

## How This Repo Works

This directory is the planning ground for Brain Brawl. It is used for design notes,
workflow instructions, and Luau implementation drafts, not as the final Roblox
project source tree.

When the actual Roblox project exists, the owner plans to connect that project to
this planning directory through an MCP server. Until then, agents should treat
`bro.md` and `bro.luau` as living planning artifacts that can later be translated
or synced into the real project.

Every time the user explains a new game idea or mechanic:
1. **Review the concept first** — write a short plan or summary, criticize weak points, ask the user clarifying questions, and suggest a stronger solution when one exists
2. **Edit `bro.md`** — add or update the relevant section in the game design plan
3. **Edit `bro.luau`** — add or update the corresponding Luau function block

## Concept Review Function

Whenever the user explains a project concept, respond with:
- **Summary / Plan:** Restate the idea as a practical implementation plan
- **Critique:** Point out risks, unclear parts, player-experience issues, exploit risks, scope problems, or missing systems
- **Questions:** Ask the user the most important clarifying questions before locking the design
- **Better Solution:** Suggest a cleaner, more fun, simpler, or more scalable version of the idea

If the concept is clear enough, update `bro.md` and `bro.luau` after the review. If major choices are still unclear, ask the questions first and wait before making large code changes.

## Rules for `bro.luau`
- One separate labeled block per function — never merge multiple functions into one block
- Each block starts with a clear `-- [ FUNCTION NAME ]` header comment
- Functions must be self-contained and easy to read in isolation

## Rules for `bro.md`
- This is the living game design document for Brain Brawl
- Keep it updated with everything the user explains
- Use plain language — describe what the mechanic does and how it behaves

## Cross-Workspace Planning Access

Use the planning bridge when working from another VS Code folder or a future real
Roblox project. The bridge keeps this directory as the source of truth while
making the files visible to Claude, Codex, and other local LLM tools.

Recommended workflow:
1. Add `/home/furferfurfer/Desktop/Roblox` as a second folder in a VS Code
   multi-root workspace.
2. From the active project directory, run:
   ```bash
   bash /home/furferfurfer/Desktop/Roblox/tools/link-planning.sh .
   ```
3. Tell other agents to read `_brain_brawl_planning/AGENTS.md`,
   `_brain_brawl_planning/README.md`, `_brain_brawl_planning/bro.md`, and
   `_brain_brawl_planning/bro.luau` before changing Brain Brawl logic.

More detail lives in `planning-bridge.md`.

## File Map
| File | Purpose |
|---|---|
| `README.md` | These workflow instructions |
| `AGENTS.md` | Agent behavior rules for concept review and project updates |
| `bro.md` | Game design plan — updated each session |
| `bro.luau` | Luau code — one block per function, updated each session |
| `planning-bridge.md` | Cross-workspace access design for VS Code and LLM tools |
| `tools/link-planning.sh` | Helper that links this planning directory into another project |
