# Notes

This file is the central home for Brain Brawl open questions, reminder notes, unfinished ideas, deferred decisions, and loose planning notes.

Use status labels so notes do not sound more final than they are:
- `Confirmed` means the owner has approved the decision.
- `Note` means useful context or a reminder to preserve.
- `Idea To Revisit` means the idea may be useful later but is not final.
- `Open Question` means the owner needs to decide before final implementation.

## Confirmed Decisions

- Confirmed: no separate Tower Unite server/place. Tower progression is represented by the visible Tower Area in the home server.
- Confirmed: Lobby Base, the broader Lobby area, and the Tower Area are separate physical spaces.
- Confirmed: the home lobby should have two nearby but clearly separable zones. Zone 1 is the main action zone with one portal or entrance for each game mode plus a clear path to the Tower Area. Zone 2 is the info/social route zone with the leaderboard, login board, tutorial board, guide board, and a clear path to the Playground.
- Confirmed: the Play button opens a choice menu with Tower and Quickmatch. Tower opens the three Tower level choices for the first build.
- Confirmed: Tower floors/areas are not locked. Players can climb or ride upward anywhere so higher gates act as visible motivation.
- Confirmed: locked Tower gates are the actual progression blockers; touching a gate must always check the player's current/highest Tower level on the server.
- Confirmed: current Tower level means the player's highest available Tower level based on their XP/progression state.
- Confirmed: there is no elevator floor selector. The Play button is the direct way to choose and teleport to a Tower level.
- Confirmed: the Play button must reuse the same current/highest level validation as physical Tower gates.
- Confirmed: the lobby Tower is a visual decoration, progression landmark, and physical gate area. It does not contain the actual Tower level gameplay; each unlocked gate teleports to the matching level destination.
- Confirmed: do not use a plain speed boost as the Tower traversal reward. The preferred Tower traversal shortcut is a launch pad that sends the player toward their highest unlocked Tower level.
- Confirmed: the highest-level launch pad should use a controlled launch animation, not uncontrolled physics.
- Confirmed: extra sprint stamina can apply everywhere. Current understanding: this does not create a direct competitive advantage because the main benefit is finishing solo Dungeons faster.
- Confirmed: first build stops at Tower Level 3 physically and functionally, but the config, naming, gate layout, and destination mapping should be easy to extend for Level 4+ later.
- Confirmed: the code should stay in one project directory for now, with place-specific starter modules for Lobby, Tower Level, Dungeon, and Up-Level Test servers.

## Design Notes And Reminders

- Note: the shared lobby Tower should feel like a clear, achievable goal because higher floors are visible, more decorated, and carry an elite-genius status fantasy.
- Note: baseline gameplay should not feel punishingly hard; higher Tower levels should mainly communicate stronger tests, greater status, and deeper progression rather than making new players feel blocked by difficulty.
- Idea To Revisit: avoid making lower floors feel like a boring zone; even early floors need enough energy, social proof, and reward feedback to make new players feel included while still wanting to climb higher.
- Note: climbing or riding upward should be atmospheric, but repeated access should not become friction. The Play button remains the direct selection path, while the physical Tower is the prestige and discovery path.
- Note: the launch pad should solve the long-Tower problem by launching the player toward the highest Tower level they have unlocked, not by letting the client choose or spoof a destination.
- Note: extra sprint stamina is the preferred movement progression reward instead of raw speed boosts. The exact way a player earns extra stamina still needs to be decided.
- Note: even if extra stamina is not competitive, faster Dungeon completion can still affect coin, XP, cooldown, and progression pacing, so Dungeon rewards and stamina scaling should be balanced together.
- Confirmed: the efficient building approach is to decorate milestone floors heavily and use reusable modular pieces for connector floors. Upper floors can feel richer through lighting, signage, materials, silhouettes, and status displays instead of unique assets everywhere.
- Idea To Revisit: leaderboard displays may help communicate Tower status later, but their exact format and placement are deferred.

## Technical Notes And Reminders

- Note: do not add an extra server just to hold the visible lobby Tower. Keep the physical Tower in the home server; use separate places/servers only for Tower level gameplay, dungeons, and up-level tests.
- Confirmed: every Tower gate and direct Play button request must be validated server-side against saved player data: highest unlocked Tower level, required XP threshold, passed up-level test, and destination place ID allowlist. The client may request entry, but the server chooses whether to teleport or deny.
- Confirmed: Tower levels, dungeons, lobby, and up-level tests should start from one shared Rojo project directory, with place-specific modules under `src/places`.
- Note: Quickmatch can route to the Arena destination place during the prototype until a separate matchmaking queue exists.
- Note: Community house buy/rent code currently only reserves the request. Real availability checks, price checks, rental duration, and persistence must wait for the economy decisions below.
- Confirmed: Tower Level 1 starter workspace uses the current Studio folder structure: `TowerLevel1/Arena/ArenaStructure`, `TowerLevel1/Arena/Inside`, `TowerLevel1/Arena/Outerpart`, `TowerLevel1/DungeonTeleport`, `TowerLevel1/Community/HousesArea`, `TowerLevel1/Community/GroupStagesArea`, `TowerLevel1/LevelStructure&GameplayBoundaries`, `TowerLevel1/LevelDecorations`, `TowerLevel1/SpawnAndLevelTeleport/ReturnToLobby`, and `TowerLevel1/SpawnAndLevelTeleport/Spawn`.
- Confirmed: Tower Level 1 should not include `SpawnSafeZone`; the spawn area is not a combat battle space.
- Confirmed: Arena answers are chosen through player UI buttons, so Tower Level Arena maps should not use physical `AnswerPad_A`, `AnswerPad_B`, `AnswerPad_C`, or `AnswerPad_D` objects.
- Confirmed: `HousesArea` and `GroupStagesArea` are reserved Community spaces. Actual house models and Group stage models should only appear after a player adds, buys, rents, or creates them.

## Open Builder Questions

- Open Question: What is the final mood and aesthetic for Brain Brawl?
- Open Question: Should Tower levels feel like school grades, sci-fi floors, fantasy towers, city districts, or another theme?
- Open Question: How should future Tower status or leaderboard displays work, if added later?
- Open Question: Should the Tower Area elevator be a real moving platform, a simple animated teleporter along the shaft, or a static visual with climb route only?
- Open Question: Should extra sprint stamina be earned only by unlocking higher Tower levels, by XP milestones, by completing up-level tests, by achievements, by shop upgrades, or by another progression rule?
- Open Question: What sprint stamina values, drain rate, and recharge rate should each Tower level receive?
- Open Question: What target travel time should the Tower climb take for new players and for higher-level players?
- Open Question: How large should each Tower level feel: compact hub, medium social map, or large exploration space?
- Open Question: Should dungeons be pure obby paths, themed rooms, quiz doors, or a mix?
- Open Question: Should Group stages use one standard model, several purchasable skins, or host-customized decoration?
- Open Question: What is the target device priority: mobile-first, desktop-first, or equal support?

## Open Gameplay And Content Questions

- Open Question: Pick real numbers for S1, S2, and S3.
- Open Question: Decide the final topic choices available inside each question level; current stage labels support `Level X - Topic` placeholders.
- Open Question: Confirm the exact boss health, player health, timer length, and damage values for each up-level test.
- Open Question: Decide the DataStore schema migration plan for live updates.
- Open Question: Decide Community house prices, rental duration, limits, and whether houses are level-specific.
- Open Question: Decide how many spawned Group stages can exist in one Community space at the same time.
- Open Question: Decide how many Group stages can exist in the Playground at the same time.
- Open Question: Decide final Arena score values, XP rewards, question timer length, and complete question-bank content by Tower level/topic.

## Open Technical And Publishing Questions

- Open Question: Add the real Roblox place ID for the home/lobby place.
- Open Question: Add the real Roblox place IDs for Tower Level 1, Tower Level 2, Tower Level 3, and each level-specific dungeon.
- Open Question: Decide whether game mode portals stay inside the lobby place or teleport players to separate mode places.
- Open Question: Add the real Roblox place IDs for each separate up-level test server.
- Open Question: Add the real Battlepass game pass ID.
- Open Question: Decide the Dungeon Cooldown Skip developer product Robux price.
- Open Question: Decide the Battlepass Robux price.
- Open Question: Decide whether VIP servers are supported and what settings they allow.
- Open Question: When real Roblox place IDs exist, should `default.project.json` add `servePlaceIds` to reduce the risk of syncing into the wrong place?
- Open Question: Which computer/OS will be used for Rojo development?
- Open Question: Will the project use GitHub from the start or only local Git at first?
- Open Question: Which packages are worth adding through Wally for the first production build?
- Open Question: Should Selene and StyLua be required before every merge, or only used manually at first?
- Open Question: Will GitHub pull requests be used for review, or will branches be merged locally during solo development?
