# Brain Brawl — Project Workflow Instructions

## How This Repo Works

Every time the user explains a new game idea or mechanic:
1. **Edit `bro.md`** — add or update the relevant section in the game design plan
2. **Edit `bro.lua`** — add or update the corresponding Lua function block

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
| `README.md` | These workflow instructions (for Claude) |
| `bro.md` | Game design plan — updated each session |
| `bro.lua` | Lua code — one block per function, updated each session |
