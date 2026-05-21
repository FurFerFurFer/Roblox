# Brain Brawl Agent Instructions

## Instruction Priority and Refresh Rule

This file is the source of truth for AI behavior in this workspace. README.md is
human-facing project documentation and must defer to AGENTS.md if the two files
ever conflict.

Before responding to any user prompt while operating in this workspace or a
linked workspace, read and follow this file. Do this even when the user's prompt
is short, informal, unrelated-looking, or does not repeat the instructions.

If the current LLM tool cannot automatically load AGENTS.md every turn, add this
instruction to that tool's project/system instructions:

```text
Always read and follow /home/furferfurfer/Desktop/Roblox-project/Roblox/AGENTS.md before answering any prompt while working in this workspace.
```

## Workspace Role

This directory is the planning ground for Brain Brawl. Treat it as a place for
design planning, workflow notes, and Luau implementation drafts, not as the final
Roblox project source tree.

The project owner plans to connect the eventual real Roblox project to this
directory through an MCP server. Until that exists, keep updates focused on the
planning files here and avoid assuming live project assets or Studio structure
exist in this directory.

## Project Concept Review

Whenever the user explains a new project concept, game idea, or mechanic:
1. Write a short summary or implementation plan.
2. Criticize the idea constructively, including player experience, technical risk, exploit risk, unclear rules, and scope.
3. Ask the most important clarifying questions.
4. Suggest a better solution when a simpler, clearer, more fun, or more scalable design exists.
5. Capture the idea in the appropriate planning file yourself without waiting for a separate "note this" request.
6. Stop and wait for the user's response before starting implementation when important design choices are still missing.

Proactively preserve every concrete design idea, player-experience note,
technical constraint, exploit concern, critique to revisit, accepted suggestion,
deferred question, and implementation decision in the correct planning file. Do
this even when the user does not explicitly ask to update the files.

Use clear status labels so notes do not imply more certainty than the user gave:
mark approved decisions as confirmed, unresolved topics as open questions, and
early or debated ideas as notes/ideas to revisit. If important design choices
are missing or clarifying questions remain unanswered, capture what is known,
ask the questions, and wait before implementing.

## File Responsibilities

- `bro.md` is the living game design plan for Brain Brawl.
- `To-Do.md` is the builder task guide and checklist extracted from topic 17 of
  `bro.md`.
- `bro.luau` is the Luau implementation draft. Keep one separate labeled block per function.
- `README.md` documents this workflow for the project owner.
- `planning-bridge.md` documents how other VS Code workspaces and LLM tools can
  access these planning files.

## Cross-Workspace Access

If this planning directory is reached through `_brain_brawl_planning` from
another project, still treat
`/home/furferfurfer/Desktop/Roblox-project/Roblox` as the planning source of
truth. Do not copy `bro.md`, `To-Do.md`, or `bro.luau` into a production project
unless the user explicitly asks. Update the planning files here when the user
changes the design.
