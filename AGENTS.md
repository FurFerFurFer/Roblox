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

## Start-of-Coding Routine

Before starting coding work, script sync work, Rojo troubleshooting, or Roblox
Studio handoff steps, read the first section of `To-Do.md` and follow the
start-every-coding-session routine there. Treat that section as the canonical
daily coding and Rojo workflow.

## Studio Handoff Property Guidance

When giving the owner Roblox Studio GUI or Workspace instructions, include brief
basic style/property guidance alongside the Explorer tree or object path. For
GUI, name the important properties a beginner should set, such as `Size`,
`Position`, `AnchorPoint`, color, transparency, text scaling, visibility, and
parent/child layout. For Workspace objects, name practical setup properties such
as object type, size or scale, position purpose, color/readability, anchoring,
collision, transparency, and whether the object is visible or invisible.

When updating `studiowork-data.md`, record these short property/style notes near
the matching GUI or Workspace object so future Studio work has both the required
object names and the basic visual/setup guidance.

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

When a feature, rule, mechanic, or workflow decision is clearly confirmed and is
implementation-relevant, also update `bro.luau` as a Luau-facing reference draft
for the future real project. Keep `bro.luau` aligned with `bro.md` and
`notes.md`: use clearly labeled blocks, describe behavior in code-shaped terms,
and do not leave superseded behavior in the draft. Do not add uncertain/open
ideas to `bro.luau` as if they are final; keep those in `notes.md` until the
owner confirms them. Once the owner confirms or clarifies a note, move the
durable detail into `bro.md`, `To-Do.md`, or `bro.luau` as appropriate, then
delete that settled item from `notes.md`.

Use `notes.md` only for items that still lead to future development, follow-up
tuning, risk review, or owner decisions. Accepted labels are `Open Question`,
`Idea To Revisit`, and actionable `Note`. Do not keep confirmed, clarified,
implemented, or obsolete items in `notes.md`. If important design choices are
missing or clarifying questions remain unanswered, capture what is known in the
durable planning files, put only the unresolved parts in `notes.md`, ask the
questions, and wait before implementing.

## File Responsibilities

- `bro.md` is the living game design plan for Brain Brawl.
- `notes.md` is the temporary open-work queue for open questions,
  future-development notes, deferred decisions, and ideas to revisit.
- `To-Do.md` is the start-of-coding routine, builder task guide, and checklist
  extracted from topic 17 of `bro.md`.
- `bro.luau` is the Luau implementation draft. Keep one separate labeled block per function.
- `README.md` documents this workflow for the project owner.
- `planning-bridge.md` documents how other VS Code workspaces and LLM tools can
  access these planning files.

## Cross-Workspace Access

If this planning directory is reached through `_brain_brawl_planning` from
another project, still treat
`/home/furferfurfer/Desktop/Roblox-project/Roblox` as the planning source of
truth. Do not copy `bro.md`, `notes.md`, `To-Do.md`, or `bro.luau` into a
production project unless the user explicitly asks. Update the planning files
here when the user changes the design.
