# Notes

This file is the temporary open-work queue for Brain Brawl. It only contains open questions, deferred decisions, ideas to revisit, and actionable notes that still lead to future development, follow-up tuning, risk review, or implementation work.

Use only these labels:
- `Open Question` means the owner needs to decide before final implementation.
- `Idea To Revisit` means the idea may be useful later but is not final.
- `Note` means actionable future-development context, tuning guidance, risk review, or implementation follow-up.

Do not store confirmed, clarified, implemented, or obsolete items here. Once an item is settled, move any durable truth into `bro.md`, `To-Do.md`, or `bro.luau`, then delete it from this file.

## Design Development Notes

- Note: Future Tower visual design should make the shared lobby Tower feel like a clear, achievable goal through visible higher floors, stronger decoration, and an elite-genius status fantasy.
- Note: Future difficulty tuning should keep baseline gameplay from feeling punishing; higher Tower levels should communicate stronger tests, greater status, and deeper progression without making new players feel blocked by difficulty.
- Idea To Revisit: avoid making lower floors feel like a boring zone; even early floors need enough energy, social proof, and reward feedback to make new players feel included while still wanting to climb higher.
- Note: Future Tower traversal tuning should make climbing or riding upward atmospheric without turning repeated access into friction.
- Note: Future launch pad implementation should solve the long-Tower problem by using server-chosen destinations, not by letting the client choose or spoof a destination.
- Note: extra sprint stamina is the preferred movement progression reward instead of raw speed boosts. The earning path is XP milestones, but the exact milestone thresholds, stamina values, drain rate, and recharge rate still need to be decided.
- Note: even if extra stamina is not competitive, faster Dungeon completion can still affect coin, XP, cooldown, and progression pacing, so Dungeon rewards and stamina scaling should be balanced together.
- Note: competitive reward tuning still needs exact numbers for Arena rewards, cross-server random 1v1 Quickmatch rewards, Group's 20% Arena reward conversion, daily soft caps, minimum answered questions, minimum match duration, AFK checks, repeat-opponent cooldowns, and server farming caps.
- Note: 1v1 Quickmatch should use a same-server no-reward prototype first, but real saved 1v1 rewards wait for cross-server matchmaking. The confirmed future design is a server-owned MemoryStoreService queue across live servers, followed by TeleportService sending matched players into reserved 1v1 match servers.
- Note: Lesson Mode replaces the earlier dedicated Practice Mode idea. Confirmed first version is a personal popup/slide UI overlay in the current server/place, with server-authorized lesson definitions, milestone test validation, and one-time milestone rewards. A separate Roblox place/server should be reserved for later if lessons become immersive rooms, cinematic classrooms, multiplayer classes, or high-stakes exams.
- Note: Lesson milestone rewards must not become a farming path. Track reward claims by player, Tower level, lesson id, milestone id, and content version; repeated attempts should show learning feedback but not re-award the same milestone.
- Note: Lesson content should be split into free intro lessons/questions available to every player from the Play menu, and house-gated Tower-level/topic lessons that require an active house in the matching Tower level.
- Note: the Battlepass Dungeon finisher layer should be server-authorized. The server decides who completed the current daily question set, who owns Battlepass, who can see finisher avatars, and who joins the finisher-only chat.
- Note: Future Dungeon implementation should preserve the anti-copy rule by keeping post-clear Battlepass visibility/chat separate from active-run solving.
- Note: daily Dungeon reset should use a server-authoritative UTC daily version/seed so clients cannot spoof the current question set or route mapping.
- Note: per-question Dungeon reward claim, wrong-answer coin removal, correct-answer reveal, solved-question state, and per-level daily completion reward state should be tracked by player, Dungeon level, question, and daily version, not by client state.
- Note: wrong-answer recovery should help a player learn without becoming an exploit. The server should still validate that the player reached/collected the correct coin before opening the path to the next question.
- Note: sprint prototype tuning currently uses XP milestones 0/100/250, stamina maximums 100/125/150, normal WalkSpeed 16, sprint WalkSpeed 22, drain 20 stamina per second while moving, and recharge 16 stamina per second while sprint is off. These are test numbers for feel experiments, not final balance.
- Idea To Revisit: for a code-first development pass, sprinting and stamina are a strong next mechanic because they can be prototyped before Arena, Dungeon, or Group systems are finished. A good first version would use client input and a small stamina meter for feel, while the server keeps authority over allowed WalkSpeed, drain, recharge, and anti-spam limits.
- Idea To Revisit: leaderboard displays may help communicate Tower status later, but their exact format and placement are deferred.

## Technical Development Notes

- Note: Before adding more lobby UI controllers, finish the real Rojo sync loop and test the Progression UI in Studio. Otherwise VS Code code can drift from the actual `StarterGui` object names and Rojo mappings.
- Note: Quickmatch can route to the Arena destination place during the earliest prototype, and same-server 1v1 Quickmatch can be prototyped without rewards. Reward-eligible 1v1 Quickmatch needs cross-server server-owned matchmaking so players cannot choose rewarded opponents.
- Note: Community house buy/rent code currently only reserves the request. Real availability checks, price checks, rental duration, and persistence must wait for the economy decisions below.

## Open Builder Questions

- Open Question: What is the final mood and aesthetic for Brain Brawl?
- Open Question: Should Tower levels feel like school grades, sci-fi floors, fantasy towers, city districts, or another theme?
- Open Question: How should future Tower status or leaderboard displays work, if added later?
- Open Question: Should the Tower Area elevator be a real moving platform, a simple animated teleporter along the shaft, or a static visual with climb route only?
- Open Question: What XP milestone thresholds should grant bigger sprint stamina?
- Open Question: What sprint stamina values, drain rate, and recharge rate should each XP milestone receive?
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
- Open Question: Decide final Arena score values, Arena XP/coin rewards, cross-server random 1v1 Quickmatch XP/coin rewards, question timer length, and complete question-bank content by Tower level/topic.
- Open Question: What exact minimum match-quality rules should saved competitive rewards require, such as minimum answered questions, minimum duration, AFK cutoff, and repeat-opponent cooldown length?
- Open Question: What passing score, retry rule, and cooldown should Lesson Mode milestone tests use?
- Open Question: Should Lesson Mode teach from a separate lesson question bank, a non-live training subset of the competitive bank, or generated topic templates reviewed by the owner?
- Open Question: Pick exact small XP/coin reward amounts and badge names for each Lesson Mode milestone.

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
