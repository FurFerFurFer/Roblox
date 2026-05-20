# Brain Brawl Agent Instructions

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

If the idea is clear enough, update `bro.md` and `bro.luau` after the review. If important design choices are missing, ask questions before making large code changes.

## File Responsibilities

- `bro.md` is the living game design plan for Brain Brawl.
- `bro.luau` is the Luau implementation draft. Keep one separate labeled block per function.
- `README.md` documents this workflow for the project owner.
- `planning-bridge.md` documents how other VS Code workspaces and LLM tools can
  access these planning files.

## Cross-Workspace Access

If this planning directory is reached through `_brain_brawl_planning` from
another project, still treat `/home/furferfurfer/Desktop/Roblox` as the planning
source of truth. Do not copy `bro.md` or `bro.luau` into a production project
unless the user explicitly asks. Update the planning files here when the user
changes the design.
