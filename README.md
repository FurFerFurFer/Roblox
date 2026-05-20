# Brain Brawl — Project Workflow Instructions

## How This Repo Works

Every time the user explains a new game idea or mechanic:
1. **Review the concept first** — write a short plan or summary, criticize weak points, ask the user clarifying questions, and suggest a stronger solution when one exists
2. **Edit `bro.md`** — add or update the relevant section in the game design plan
3. **Edit `bro.lua`** — add or update the corresponding Lua function block

## Concept Review Function

Whenever the user explains a project concept, respond with:
- **Summary / Plan:** Restate the idea as a practical implementation plan
- **Critique:** Point out risks, unclear parts, player-experience issues, exploit risks, scope problems, or missing systems
- **Questions:** Ask the user the most important clarifying questions before locking the design
- **Better Solution:** Suggest a cleaner, more fun, simpler, or more scalable version of the idea

If the concept is clear enough, update `bro.md` and `bro.lua` after the review. If major choices are still unclear, ask the questions first and wait before making large code changes.

## Rules for `bro.lua`
- One separate labeled block per function — never merge multiple functions into one block
- Each block starts with a clear `-- [ FUNCTION NAME ]` header comment
- Functions must be self-contained and easy to read in isolation

## Rules for `bro.md`
- This is the living game design document for Brain Brawl
- Keep it updated with everything the user explains
- Use plain language — describe what the mechanic does and how it behaves

## File Map
| File | Purpose |
|---|---|
| `README.md` | These workflow instructions |
| `AGENTS.md` | Agent behavior rules for concept review and project updates |
| `bro.md` | Game design plan — updated each session |
| `bro.lua` | Lua code — one block per function, updated each session |
