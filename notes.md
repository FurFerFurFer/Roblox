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
- Confirmed: in the first sprint stamina version, bigger stamina is earned through XP milestones directly instead of only through Tower level unlocks, up-level tests, achievements, or shop upgrades.
- Confirmed: add a Progression UI that shows the player's current progression level and the stamina reward connected to that progress.
- Confirmed: the first sprint control should be a toggle. Pressing Shift toggles sprint on or off instead of requiring the player to hold Shift.
- Confirmed: the sprint GUI should include a visible button. Clicking the button toggles sprint, highlights the button while sprint is requested/active, and automatically turns the highlight off when stamina runs out or when the player clicks again to deactivate sprint.
- Confirmed: first build stops at Tower Level 3 physically and functionally, but the config, naming, gate layout, and destination mapping should be easy to extend for Level 4+ later.
- Confirmed: the code should stay in one project directory for now, with place-specific starter modules for Lobby, Tower Level, Dungeon, and Up-Level Test servers.
- Confirmed: Dungeon questions reset automatically every day at UTC midnight, so each daily Dungeon set has fresh questions/routes.
- Confirmed: Battlepass players have no Dungeon cooldown. Normal players still use the regular Dungeon failure cooldown unless another decision changes that rule.
- Confirmed: the old one-by-one Dungeon vision invite idea is superseded. Battlepass players who finish all questions in the current daily Dungeon set automatically gain a post-clear finisher layer where they can see each other and chat only with other Battlepass daily finishers, without sending invites.
- Confirmed: Dungeon visibility and chat remain disabled for normal players and for Battlepass players who have not finished the current daily Dungeon set. Active non-finishers should not be able to see, be seen by, or chat with other Dungeon players.
- Confirmed: Battlepass finisher access is per Dungeon level. Completing one level's daily Dungeon set unlocks whole-Dungeon visibility/chat for that level only, and the access resets at the next UTC midnight reset. Battlepass players must complete that level's new daily set again after reset to regain visibility/chat.
- Confirmed: Dungeon rewards can only be claimed once per question per daily reset. Once a question's reward has already been claimed for that daily version, retries do not pay that same question reward again. If a Dungeon level has a completion reward, that completion reward is also claimable only once per level per daily reset.
- Confirmed: Dungeon question answer choices can be represented by answer coins/pickups. If a player collects a wrong-answer coin, the player fails/dies/resets, the UI shows the correct answer, and that wrong-answer coin is removed for that player's next attempt at that question during the current daily version.
- Confirmed: after a wrong-answer coin is collected once, the next attempt for that question should show only the correct coin/path for that player. The player still has to collect the correct coin to open the path to the next question.
- Confirmed: when a player collects the correct coin for a question, wrong-answer coins for that same question are deleted/hidden for that player. This locks the question as solved for the current daily version and prevents repeated same-question reward claims.
- Confirmed: normal players have two cooldown options after a Dungeon failure: buy a skip for only the current failed-run cooldown once, or buy Battlepass for no-cooldown Dungeon access.
- Confirmed: Dungeon wrong-answer UI should be clear and direct. When a player collects a wrong-answer coin, the UI should tell them they were wrong, show the correct answer, and explain that the next attempt for that question will show only the correct coin/path.

## Design Notes And Reminders

- Note: the shared lobby Tower should feel like a clear, achievable goal because higher floors are visible, more decorated, and carry an elite-genius status fantasy.
- Note: baseline gameplay should not feel punishingly hard; higher Tower levels should mainly communicate stronger tests, greater status, and deeper progression rather than making new players feel blocked by difficulty.
- Idea To Revisit: avoid making lower floors feel like a boring zone; even early floors need enough energy, social proof, and reward feedback to make new players feel included while still wanting to climb higher.
- Note: climbing or riding upward should be atmospheric, but repeated access should not become friction. The Play button remains the direct selection path, while the physical Tower is the prestige and discovery path.
- Note: the launch pad should solve the long-Tower problem by launching the player toward the highest Tower level they have unlocked, not by letting the client choose or spoof a destination.
- Note: extra sprint stamina is the preferred movement progression reward instead of raw speed boosts. The earning path is XP milestones, but the exact milestone thresholds, stamina values, drain rate, and recharge rate still need to be decided.
- Note: even if extra stamina is not competitive, faster Dungeon completion can still affect coin, XP, cooldown, and progression pacing, so Dungeon rewards and stamina scaling should be balanced together.
- Note: the Battlepass Dungeon finisher layer should be server-authorized. The server decides who completed the current daily question set, who owns Battlepass, who can see finisher avatars, and who joins the finisher-only chat.
- Note: post-clear Battlepass visibility/chat is safer than active-run vision access because it preserves the anti-copy rule while players are still solving that day's Dungeon.
- Note: daily Dungeon reset should use a server-authoritative UTC daily version/seed so clients cannot spoof the current question set or route mapping.
- Note: per-question Dungeon reward claim, wrong-answer coin removal, correct-answer reveal, solved-question state, and per-level daily completion reward state should be tracked by player, Dungeon level, question, and daily version, not by client state.
- Note: wrong-answer recovery should help a player learn without becoming an exploit. The server should still validate that the player reached/collected the correct coin before opening the path to the next question.
- Note: sprint prototype tuning currently uses XP milestones 0/100/250, stamina maximums 100/125/150, normal WalkSpeed 16, sprint WalkSpeed 22, drain 20 stamina per second while moving, and recharge 16 stamina per second while sprint is off. These are test numbers for feel experiments, not final balance.
- Idea To Revisit: for a code-first development pass, sprinting and stamina are a strong next mechanic because they can be prototyped before Arena, Dungeon, or Group systems are finished. A good first version would use client input and a small stamina meter for feel, while the server keeps authority over allowed WalkSpeed, drain, recharge, and anti-spam limits.
- Confirmed: the efficient building approach is to decorate milestone floors heavily and use reusable modular pieces for connector floors. Upper floors can feel richer through lighting, signage, materials, silhouettes, and status displays instead of unique assets everywhere.
- Idea To Revisit: leaderboard displays may help communicate Tower status later, but their exact format and placement are deferred.

## Technical Notes And Reminders

- Note: do not add an extra server just to hold the visible lobby Tower. Keep the physical Tower in the home server; use separate places/servers only for Tower level gameplay, dungeons, and up-level tests.
- Confirmed: every Tower gate and direct Play button request must be validated server-side against saved player data: highest unlocked Tower level, required XP threshold, passed up-level test, and destination place ID allowlist. The client may request entry, but the server chooses whether to teleport or deny.
- Confirmed: Tower levels, dungeons, lobby, and up-level tests should start from one shared Rojo project directory, with place-specific modules under `src/places`.
- Note: Quickmatch can route to the Arena destination place during the prototype until a separate matchmaking queue exists.
- Confirmed: the lobby starter code must not auto-create old helper groups or visible helper entities such as `SpawnPoints`, `LobbySpawn`, `Portals`, flat lobby portal trigger pads, `ElevatorStops`, `LobbyTowerElevatorStop_Level1` through `LobbyTowerElevatorStop_Level3`, `LockedBarriers`, or old locked barrier pads. The cleanup removes those old generated names during startup, even if they were saved or moved from their original paths.
- Confirmed: the lobby starter code should not create any Workspace scaffold objects for the lobby now. Lobby Workspace objects should come from the builder's hand-made Studio map instead of initialization code.
- Confirmed: the code must not auto-create a fallback GUI Play button. The client should use the hand-made `PlayerGui > PlayButton` UI copied from Studio, and should warn and stop if that UI is missing instead of drawing an extra button.
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
- Open Question: What XP milestone thresholds should grant bigger sprint stamina?
- Open Question: What sprint stamina values, drain rate, and recharge rate should each XP milestone receive?
- Open Question: In the Progression UI, should the displayed level mean the player's XP milestone level, Tower level, or both?
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
