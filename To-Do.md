# 17. To Do List

This file is the builder and scripting checklist for turning the Brain Brawl plan into an actual Roblox experience. It is the standalone version of topic 17 from `bro.md`. It also contains the start-of-coding GitHub, Roblox Studio, and Rojo routine so every coding session begins from the same workflow.

Update this file whenever the design plan changes physical spaces, gameplay objects, Studio organization, testing needs, exploit risks, or handoff requirements. Keep each task in one section only. If a task affects multiple areas, put it in the shared review or handoff section instead of repeating it under every map.

Status labels:
- `[x] Confirmed Done` means the task is already completed in the planning/code workspace.
- `[ ] Todo` means the task is not done yet.

Open questions, future-development notes, deferred decisions, and ideas to
revisit live in [notes.md](notes.md), not in this checklist. Confirmed,
clarified, implemented, or obsolete items should be removed from `notes.md`
after any lasting truth is captured here, in `bro.md`, or in `bro.luau`.

## Start Every Coding Session

Use this first before coding, syncing scripts, or testing Studio changes. This
section is the canonical daily GitHub, Roblox Studio, and Rojo routine.

### One-Time Setup

- [ ] Confirm the owner controls the GitHub repo; collaborators either request changes through PRs or receive approved push access.
- [ ] Move the Roblox game to a Group when multiple builders/scripters need reliable edit and publish access; the Group solves Roblox permissions, not Rojo sync by itself.
- [ ] For Rojo sync work, open the place through `File > Open from Roblox`, not by joining Team Create.

### Daily Dev Loop

1. [ ] Pull the latest code from GitHub.
2. [ ] Open the place through `File > Open from Roblox`, not by joining Team Create.
3. [ ] In a terminal, go to `Desktop/Roblox-project/test-server`.
4. [ ] Run `rojo serve`.
5. [ ] Connect the Rojo plugin in Studio and confirm scripts sync automatically.
6. [ ] Build and test.
7. [ ] Save and publish to Roblox.
8. [ ] Push code changes to GitHub.

### Building With A Friend

- [ ] Use Team Create normally for world building.
- [ ] Remember that Rojo only touches scripts; it does not modify Workspace.
- [ ] For script sync, collaborators should use the same Git repo and Rojo project mapping, and the Studio script hierarchy should match `default.project.json`; local computer folder paths do not need to be identical.
- [ ] If a friend's Workspace needs to be merged into the local place, use the merge routine below.

Workspace merge routine:

1. Join the friend's Team Create session.
2. Select all of `Workspace` in Explorer, then copy it.
3. Open the local place file.
4. Right-click `Workspace`, then choose `Paste Into`.
5. Save and publish.

### Rojo And Team Create Rule

- [ ] Do not use a Team Create join session for Rojo script syncing.
- [ ] Roblox blocks plugins from writing `Script.Source` in Team Create sessions.
- [ ] If Rojo silently appears to do nothing, check whether the place was opened from Team Create instead of `File > Open from Roblox` or a local `.rbxlx` file.

### Rojo Quick Reference

| Task | Command |
|---|---|
| Start Rojo server | `rojo serve` in `test-server/` |
| Build static place file | `rojo build -o test-server.rbxlx` |
| Check server is running | `curl http://localhost:34872/api/rojo` |

- Rojo port: `34872`.
- Project config: `test-server/default.project.json`.

## How To Use This Checklist

Most building sessions should move through these chunks in order:

1. Choose the next task in `Use Chunk 1`.
2. Read the always-on build rules in `Use Chunk 2`.
3. Build the matching area checklist in `Use Chunk 3`.
4. Use `Use Chunk 4` when the blockout works and needs polish.
5. Run safety, testing, and scripting handoff in `Use Chunk 5`.
6. Use `Use Chunk 6` when connecting real Roblox places and code.
7. Put uncertain ideas, future-development notes, and owner questions in `Use Chunk 7`.

If new work is discovered while building, add it to the most specific matching
section instead of leaving it only in chat. If the work is uncertain or depends
on an owner decision, put only the unresolved follow-up in [notes.md](notes.md)
as an open question, actionable note, or idea to revisit.

## Use Chunk 1: Pick What To Build Next

Use this chunk at the start of a build session. It tells you what to work on
next and points you to the detailed checklist for that area.

### 17.1 Current Build Order

Use this order unless the owner changes priorities. The detailed work for each phase lives in the matching section, so this list only controls sequence.

1. [ ] Figure out how to properly sync code from VS Code to Roblox Studio (Argon/Rojo).
2. [ ] Lobby foundation: complete section 17.4.
3. [ ] Tower Area landmark and gates: complete section 17.5.
4. [ ] Tower Level 1 destination: complete section 17.6 for Level 1 first.
5. [ ] Arena prototype: complete section 17.7.
6. [ ] Dungeon prototype: complete section 17.8.
7. [ ] Group stage prototype: complete section 17.9.
8. [ ] Up-Level Test 1 prototype: complete section 17.10.
9. [ ] Tower Level 2 and Tower Level 3 variations: return to section 17.6.
10. [ ] Shared visual and performance pass: complete sections 17.11 and 17.12.
11. [ ] Final safety, testing, and handoff pass: complete sections 17.13, 17.14, and 17.15.

## Use Chunk 2: Read Before Building Anything

Use this chunk before you start making or changing map objects. These rules
apply to every area, even when the active task is in a later chunk.

### 17.2 Global Build Rules

- [ ] Build simple blockouts before art polish so scale, movement, camera, portals, and script anchors can be tested early.
- [ ] Make every area explain its purpose through layout, color, lighting, signs, landmarks, and barriers before adding extra decoration.
- [ ] Keep decorative models separate from gameplay-critical collision, trigger parts, and script folders.
- [ ] Use anchored, simple collision for prototypes unless a moving object is required for a confirmed mechanic.
- [ ] Add invisible walls, fall protection, reset zones, and clear exits before an area is considered testable.
- [ ] Keep important UI prompts, question screens, portals, and danger zones free of visual clutter.
- [ ] Verify each route on desktop and mobile camera distances before final art.

### 17.3 Studio Organization And Naming

- [ ] Create clear Workspace folders for `LobbyBase`, `Lobby`, `Playground`, `TowerArea`, `TowerLevel1`, `TowerLevel2`, `TowerLevel3`, `Dungeons`, `UpLevelTests`, and `SharedMapAssets`.
- [ ] Put actual Tower level gameplay in separate Tower level destinations, not inside the home-server `TowerArea`.
- [ ] Name script-relevant parts and reserved folders predictably, such as `ArenaGateTrigger`, `ArenaExitTrigger`, `LobbyTowerGate_Level2`, `LobbyTowerLaunchPad`, `LobbyTowerLaunchLanding_Level2`, `LobbyTowerElevatorStop_Level2`, `QuestionScreen`, `DungeonPortal_Level1`, `DungeonResetZone`, `HousesArea`, and `GroupStagesArea`.
- [ ] Add attributes when scripts need per-object configuration, such as `LevelNumber`, `ModeName`, `DestinationKey`, `UnlockRequirement`, or `StageCapacity`.
- [ ] Keep Tower gate parts non-authoritative: gates may expose the requested level number, but server code must validate the real destination place ID.
- [ ] Plan CollectionService tags for repeated script-driven objects, such as portals, spawned houses, spawned Group stages, kill zones, spectate triggers, and coin pickups.
- [ ] Do not rename, move, resize, or change collision on scripted objects without recording the change for scripters.

## Use Chunk 3: Build The Current Area

Use this chunk after `Use Chunk 1` tells you which area is active. Build the
matching area first, then run that area's `Validation:` checklist before moving
on.

### 17.4 Lobby Base, Lobby, And Playground

Goal: players spawn, understand where to go, and can choose the main activity without needing long instructions.

- [ ] Place the first spawn point so players face the main navigation choices.
- [ ] Make Lobby Base, Lobby, Playground, and Tower Area feel like separate connected spaces.
- [ ] Organize the lobby into two nearby but clearly separable zones: the main action zone and the info/social route zone.
- [ ] Build the main action zone with one portal or entrance for each game mode and a clear path into the Tower Area. Keep the mode portals and Tower Area entrance close enough that players understand them as the main play choices.
- [ ] Build the info/social route zone with the leaderboard, login board, tutorial board, guide board, and the clear path to the Playground. Keep these items close enough that players understand them as information and social navigation.
- [ ] Make the main action zone easy to separate visually from the info/social route zone with floor shape, spacing, lighting, signs, railings, arches, or another simple layout cue.
- [ ] Add visually distinct portals or entrances for Arena, 1v1, Dungeon, and Tower-related play.
- [ ] Add a Play button access point that clearly supports Tower level selection, Quickmatch, and Lesson Mode access for house-owned/rented levels.
- [ ] Place the Playground beside the lobby with enough open space for social activity and Group stages.
- [ ] Reserve clean paths from spawn to the main portals so Group stages and crowds cannot block movement.
- [ ] Add readable signs, arrows, lighting, or landmark shapes for each main mode.
- [ ] Add real portal trigger parts by hand only when the lobby design needs them, then record the intended destination or mode. The starter code must not auto-create the old `Portals` helper folder or flat placeholder portal pads during Play or Simulate.

Validation:
- [ ] A new player can identify the main choices within the first few seconds after spawning.
- [ ] A new player can tell that the portals and Tower Area path are one main action zone, while the leaderboard, login/tutorial/guide boards, and Playground path are a separate info/social route zone.
- [ ] Several players can stand near each portal without blocking each other or hiding prompts.
- [ ] Players reading boards or walking to the Playground do not block the game mode portals or the Tower Area path.
- [ ] The Play button Tower choice opens Level 1-3 choices, Quickmatch requests the fast match route, and Lesson Mode always shows the free intro lesson/question plus house-gated lessons for levels where the player owns or rents an active house.

### 17.5 Tower Area And Level Gates

Goal: the home-server Tower Area should sell progression visually while acting only as a teleport-gate landmark.

- [ ] Build the Tower Area as a tall progression landmark, not as a full Tower level gameplay map.
- [ ] Add a clear entrance from the lobby into the Tower Area.
- [ ] Add traversal up the Tower Area through an elevator, climb route, or approved hybrid route.
- [ ] Add a Tower Area launch pad that plays a controlled launch animation and sends the player toward their server-validated highest unlocked Tower level.
- [ ] Add safe launch landing positions near Level 1, Level 2, and Level 3 gates if the launch pad uses separate physical landings.
- [ ] Place Level 1, Level 2, and Level 3 gates upward so progression is communicated through height.
- [ ] Name gates `LobbyTowerGate_Level1`, `LobbyTowerGate_Level2`, and `LobbyTowerGate_Level3`.
- [ ] Stop the first build at Level 3 and leave future Level 4+ expansion as inactive structure only.
- [ ] Let players explore Tower floors or viewing areas even when higher gates are locked.
- [ ] Make locked gates visually locked, physically blocked, and server-validated.
- [ ] Add elevator stop parts by hand only if an elevator or climb-stop route is chosen. The starter code must not auto-create the old `ElevatorStops` helper folder, `LobbyTowerElevatorStop_Level1`, `LobbyTowerElevatorStop_Level2`, or `LobbyTowerElevatorStop_Level3`.

Validation:
- [ ] Level 4+ cannot be reached or requested in the first build.
- [ ] The launch pad cannot send a player to a locked Tower level, and the client cannot choose or spoof the target level.
- [ ] The controlled launch animation lands players cleanly without fall damage, clipping, camera confusion, or missed gate access.
- [ ] Locked gates cannot be reached from behind, above, below, or through side gaps.
- [ ] Gate parts request only a level number; server code decides whether teleport is allowed.

### 17.6 Tower Level Destinations

Goal: each Tower level is its own destination with the same core layout and stronger theme as level difficulty rises.

- [ ] Build Tower Level 1 with four clear areas: Arena, Dungeon Teleport, Spawn & Level Teleport, and Community.
- [ ] Organize Tower Level 1 with the current Studio folders: `Arena/ArenaStructure`, `Arena/Inside`, `Arena/Outerpart`, `DungeonTeleport`, `Community/HousesArea`, `Community/GroupStagesArea`, `LevelStructure&GameplayBoundaries`, `LevelDecorations`, and `SpawnAndLevelTeleport`.
- [ ] Build Tower Level 2 with the same four-area structure and a stronger visual theme than Level 1.
- [ ] Build Tower Level 3 with the same four-area structure and the highest-tier visual theme for the first release.
- [ ] Place the level spawn so players face the main choices without spawning into crowds or collision.
- [ ] Add a level teleport area that returns players to allowed levels or the lobby as designed.
- [ ] Add signs or visual language that clearly tell players which Tower level they are in.
- [ ] Do not add `SpawnSafeZone` to Tower Level 1; the spawn is not a combat battle space.
- [ ] Keep each level expandable for future Arena variants, Dungeon entrances, Community features, and status displays.

Validation:
- [ ] Players can tell Level 1, Level 2, and Level 3 apart by layout cues and visual theme.
- [ ] Every Tower level has the same essential navigation pattern, so players do not have to relearn the hub.
- [ ] Higher-level decoration does not make prompts, portals, question screens, or UI answer readability harder to understand.

### 17.7 Arena Prototype

Goal: players can enter a visible trivia Arena, answer questions through UI clearly, leave safely, and spectate without confusion.

- [ ] Build a large open Arena with a question projection visible from inside the Arena and from nearby spectator areas.
- [ ] Place and name `ArenaGateTrigger` at the entry point.
- [ ] Place and name `ArenaExitTrigger` or a clear exit button.
- [ ] Place and name `QuestionScreen` or the approved projection part.
- [ ] Do not place physical Arena answer pads. Arena answers are selected through player UI buttons.
- [ ] Add player standing zones that face the question display.
- [ ] Add spectator positions that show the action without allowing accidental joining.
- [ ] Keep the Arena open enough for camera movement, mobile readability, and multiple avatars.
- [ ] Block access behind question screens or trigger zones if those positions can break interactions.

Validation:
- [ ] A spectator can understand the question activity without entering the Arena.
- [ ] A player can find the exit route quickly after joining.
- [ ] UI answer buttons and the public question screen remain readable with several players nearby.

### 17.8 Dungeon Prototype

Goal: a solo or separated trivia path challenges players without letting them copy routes, skip questions, or get softlocked.

- [ ] Build a short Dungeon Level 1 prototype with a few question checkpoints before expanding toward 50 checkpoints.
- [ ] Decide whether the final dungeon format is obby paths, themed rooms, quiz doors, or a mix.
- [ ] Place and name question checkpoint zones in sequence, such as `DungeonQuestion_001`.
- [ ] Place answer paths, quiz doors, or another approved dungeon answer route for each checkpoint and label them clearly for testing.
- [ ] Place reset zones and kill zones named clearly, such as `DungeonResetZone_001` or `DungeonKillZone_001`.
- [ ] Place coin pickup locations on correct paths without encouraging accidental wrong turns.
- [ ] Plan answer coins/pickups per question: wrong coin fails/resets the player, shows a clear UI message with the correct answer, and is removed for that player's next attempt; correct coin claims the once-per-question daily reward, deletes/hides wrong coins for that player, and opens the next path.
- [ ] Plan question rewards as once-per-question-per-UTC-daily-reset pickups and completion rewards as once-per-level-per-UTC-daily-reset rewards; claimed question rewards, solved-question state, and wrong-coin-removal state should persist for that player until the next daily reset.
- [ ] Separate players enough that one player cannot easily follow another player's correct route.
- [ ] Plan the UTC daily Dungeon reset and post-clear Battlepass finisher layer: active solvers stay invisible/no-chat, Battlepass daily finishers automatically see and chat only with same-level Battlepass daily finishers in the whole Dungeon, Battlepass players have no Dungeon cooldown, and finisher access must be earned again after each reset.
- [ ] Add anti-skip walls, ceilings, route bends, or distance breaks where jumping or camera peeking could reveal answers.
- [ ] Add a clear return route after failure or completion.

Validation:
- [ ] Wrong answers reset, damage, or fail the player without trapping them in a loop.
- [ ] Wrong-answer routes reveal the correct answer clearly before or during the reset, explain that the next attempt for that question will show only the correct coin/path, and keep the feedback readable on mobile and desktop.
- [ ] Correct routes reward the player clearly, delete/hide wrong-answer coins for that player, continue the path smoothly, and do not re-award already claimed daily question rewards or already claimed daily level completion rewards.
- [ ] Players cannot skip questions by jumping, wall-hopping, clipping, falling, or watching another route.

### 17.9 Group Stages And Community Spaces

Goal: Group stages create social activity without blocking main navigation or confusing public/private access.

- [ ] Reserve `Community/GroupStagesArea` as blank/open space for player-created Group stages.
- [ ] Reserve `Community/HousesArea` as the area where player-added, bought, or rented houses can appear.
- [ ] Plan each owned/rented house as a Lesson Mode access point for that house's Tower level slides, examples, and milestone tests.
- [ ] Build one standard spawnable Group stage prototype before making skins or host customization.
- [ ] Do not pre-place finished Group stage models in the starter Community map; stages should appear only after a player creates/adds them.
- [ ] Plan chair anchors, host position, join prompt, spectate prompt, info trigger, and problem display anchor for spawned stages.
- [ ] Keep stage placement away from spawns, portals, exits, and required paths.
- [ ] Make public, invite-only, joinable, and spectatable states visually different.
- [ ] Add enough spacing so multiple stages can run without prompt overlap.
- [ ] Adapt the approved Community stage layout for Playground after the first prototype works.

Validation:
- [ ] Maximum expected stage count does not make the area crowded or slow.
- [ ] Invite-only stages block joining correctly while still allowing approved spectating.
- [ ] Stage prompts remain readable when players gather around them.

### 17.10 Up-Level Test Boss Arena

Goal: the up-level test should feel like a focused boss challenge with readable questions, timer pressure, and clear pass/fail flow.

- [ ] Build Up-Level Test 1 as a separate boss arena prototype.
- [ ] Place and name the boss anchor, player anchor, answer zones, and question display.
- [ ] Reserve visible space for timer, boss health bar, player health/status, and pass/fail feedback.
- [ ] Make boss placement dramatic but keep the question display and answer choices easy to read.
- [ ] Add entry, retry, failure, success, and teleport-return positions as placeholders.
- [ ] Keep the arena bounded so players cannot leave the test space while the challenge is active.

Validation:
- [ ] The player can see the boss, question, timer, answer choices, and status information from the expected camera position.
- [ ] Fail and success routes cannot be confused with active combat space.
- [ ] The arena supports later scripting for timed questions, health changes, saving results, and teleport return.

## Use Chunk 4: Polish After The Blockout Works

Use this chunk after the area is readable, walkable, and testable. It is for
theme, visual clarity, optimization, and technical cleanup before deeper review.

### 17.11 Visual Readability And Theme

- [ ] Choose the final mood and aesthetic for Brain Brawl before final art polish.
- [ ] Give each mode a recognizable color, material, sign, and lighting language.
- [ ] Give each Tower level a stronger or more advanced theme than the previous level.
- [ ] Build the lobby Tower efficiently with reusable floor modules and heavier decoration only on milestone floors.
- [ ] Reserve clean spaces for possible future Tower status or leaderboard displays, but do not build those displays yet.
- [ ] Use signs, arrows, lighting, and landmark shapes to guide players without long text.
- [ ] Keep UI answer choices, question screens, and dungeon answer routes visually simple so trivia choices stay readable.
- [ ] Use high contrast for interactable objects, locked objects, danger, rewards, and exits.
- [ ] Keep the Dungeon tense but readable; decoration should never hide correct or incorrect choices.
- [ ] Make the Playground social and flexible instead of overfilled with fixed props.

### 17.12 Performance And Technical Hygiene

- [ ] Keep early versions low-detail until the gameplay loop is proven.
- [ ] Avoid excessive unanchored parts and physics-heavy decorations.
- [ ] Merge, simplify, or reuse decorative meshes when possible.
- [ ] Limit particle effects, transparency, and animated decorations in heavy gameplay views.
- [ ] Test memory and frame rate on a lower-end device before launch.
- [ ] Test StreamingEnabled if the final map becomes large.
- [ ] Use modular decoration so Tower floors feel different without making every floor uniquely heavy.
- [ ] Track how many active Group stages can exist before the area becomes crowded or slow.

## Use Chunk 5: Test, Review, And Hand Off

Use this chunk before calling an area done. Run it after each playable blockout,
after major decoration changes, and before handing work to scripting.

### 17.13 Exploit And Safety Review

Run this review after each playable area is blocked out and again after major decoration changes.

- [ ] Players cannot touch portals or gates they have not unlocked by jumping around barriers.
- [ ] Players cannot enter Arena, Dungeon, Group, or up-level test spaces through gaps, clipping spots, or one-way geometry mistakes.
- [ ] Players cannot stand behind question screens or trigger zones to break interactions.
- [ ] Players cannot skip Dungeon questions or view another player's correct route while actively solving. Post-clear Battlepass finisher visibility must not reveal active non-finishers.
- [ ] Competitive rewards cannot be farmed through chosen opponents, friend/alt boosting, empty-server hopping, private/VIP servers, invite-only stages, or repeated same-opponent matches.
- [ ] Saved XP/coin reward code for 1v1, Arena, and Group validates match quality on the server before paying rewards: eligible public context, cross-server random Quickmatch for rewarded 1v1, at least four active eligible players for Arena/Group rewards, enough answered questions or match duration, and repeat-opponent/server caps.
- [ ] Private/VIP servers, invite-only Group rooms, and Battlepass-created custom 1v1 rooms never grant competitive saved XP or coins.
- [ ] Same-server 1v1 Quickmatch prototype gives local score only; saved 1v1 rewards stay disabled until cross-server matchmaking places matched players into server-owned reserved match servers.
- [ ] House-gated Lesson Mode requests from the Play menu or a house are denied unless the server confirms the player owns or rents an active house in the requested Tower level; free intro Lesson Mode stays available without a house.
- [ ] Lesson milestone rewards are server-authorized, one-time per player/content version, and cannot be farmed by repeating the same lesson or milestone test.
- [ ] Free intro Lesson Mode content is available without a house, but still uses server-authorized one-time milestone reward tracking.
- [ ] Group stage placement cannot block important paths, spawns, portals, exits, or reset routes.
- [ ] Kill zones and reset zones cannot repeatedly trap a player.
- [ ] Spawn points do not place players inside collision, under the map, facing away from the main route, or inside another player's likely path.
- [ ] Remote-spoofed requests, invalid level numbers, invalid destination IDs, and Play button abuse are denied by server code.

### 17.14 Builder Testing Routine

- [ ] Walk each area slowly as a new player and confirm the next action is obvious.
- [ ] Sprint, jump, climb, and fall around every boundary to search for escape routes.
- [ ] Test with default Roblox avatar sizes and several scaled avatars if scaling is allowed.
- [ ] Test camera readability on desktop and mobile.
- [ ] Test portal and prompt spacing with several players standing nearby.
- [ ] Run the validation checklist inside the area section being tested.
- [ ] Run the exploit and safety review in section 17.13 after every playable blockout.
- [ ] Test Arena, 1v1, and Group reward behavior for solo Arena practice, public valid Arena with 4+ players, same-server no-reward 1v1 Quickmatch prototype, future cross-server reward-eligible 1v1 Quickmatch, Battlepass custom 1v1, public Group with 4+ players at 20% Arena reward, private/VIP/custom match, repeated opponent, friend/alt boosting attempt, server hop, disconnect, and AFK edge cases.
- [ ] Test Lesson Mode access from the Play menu and from a house: owned/rented house in same Tower level allows lessons, no house denies access, wrong-level house denies access, locked Tower level denies access, and spoofed client requests are rejected.
- [ ] Test Lesson Mode milestone rewards: first valid pass grants the one-time reward, repeat attempts do not re-award, failed attempts do not reward, and content-version changes are handled deliberately.
- [ ] Test free intro lesson/question access for brand-new players with no house and verify its one-time reward cannot be farmed.
- [ ] Test all areas with Studio graphics lowered to catch readability problems.
- [ ] Save screenshots or short clips when asking AI, teammates, or the owner for review.

### 17.15 Scripting Handoff Requirements

For each finished or semi-finished area, record the following before moving to the next major area:

- [ ] Area name, purpose, and current completion status.
- [ ] Screenshot or short walkthrough video.
- [ ] Workspace folder path and important object names.
- [ ] Trigger parts, attributes, tags, and what each one should do.
- [ ] Spawn points, portal destinations, return routes, reset zones, and kill zones.
- [ ] Signs, UI prompts, screens, and feedback messages needed.
- [ ] Known unfinished art, scale, collision, or readability work.
- [ ] Known exploit risks, confusing spots, or places where testers got lost.
- [ ] Required RemoteEvents, RemoteFunctions, data keys, teleport IDs, or server validation rules.

## Use Chunk 6: Connect Code And Real Places

Use this chunk when the Roblox universe, Rojo sync, place IDs, and place-specific
startup systems are being connected.

### 17.16 Multi-Place Code Organization

- [x] Confirmed Done: Create a one-directory code skeleton with `src/shared`, `src/server`, `src/client`, and `src/places`.
- [x] Confirmed Done: Add place-specific starter folders for `lobby`, `tower-level`, `dungeon`, and `up-level-test`.
- [x] Confirmed Done: Add a shared `PlaceConfig` module that maps real Roblox place IDs to broad place roles.
- [x] Confirmed Done: Add a server `PlaceBootstrap` module that starts the correct place-specific module.
- [x] Confirmed Done: Update Rojo config so `src/places` syncs into `ServerScriptService > PlaceScripts`.
- [x] Confirmed Done: Disable lobby Workspace scaffolding so the lobby startup code does not auto-create generated map entities.
- [x] Confirmed Done: Clean up old generated lobby helper names during startup if they were saved from older prototypes, including `SpawnPoints`, `LobbySpawn`, `Portals`, flat lobby portal trigger pads, `ElevatorStops`, `LobbyTowerElevatorStop_Level1` through `LobbyTowerElevatorStop_Level3`, `LockedBarriers`, and old locked barrier pads.
- [ ] Replace every placeholder `0` in `TowerConfig.PlaceIds` with real Roblox place IDs from the Brain Brawl universe.
- [ ] Decide whether to add Rojo `servePlaceIds` after real place IDs exist, so syncing into the wrong Studio place is harder.
- [ ] Open each real Roblox place in Studio, connect Rojo, and confirm the correct starter module prints in Output.
- [ ] Move any Studio-only GUI behavior scripts, such as Play button or Tower teleport LocalScripts under `StarterGui`, into VS Code client controllers under `src/client`; keep the Studio GUI objects as visual layout unless `StarterGui` is intentionally added to `default.project.json`. Do not auto-create fallback Play button UI from code; if the hand-made `PlayerGui > PlayButton` UI is missing, warn and stop instead of drawing a replacement.
- [ ] Move lobby Play-menu routing from the general `Main.server.luau` script into a lobby-specific service once the first lobby systems are stable.
- [ ] Add real Tower Level startup logic for Arena, Dungeon Teleport, Spawn & Level Teleport, and Community.
- [ ] Add a CompetitiveRewardService that separates local session score from saved XP/coin payouts and enforces the confirmed reward order: Arena public 4+ highest, cross-server random 1v1 Quickmatch next, eligible public Group at 20% of Arena.
- [ ] Add Lesson Mode routing and feedback through the Play menu and through house interaction points, with server validation for active house ownership/rental in the selected Tower level.
- [ ] Add Lesson Mode slide content, checkpoint questions, milestone tests, and one-time server-authorized milestone rewards.
- [ ] Put free intro lesson content under the `FreeIntro` lesson catalog path, and put buy-house/house-gated lesson questions under the matching `TowerLevelX/<Topic>` lesson catalog path.
- [ ] Add random 1v1 Quickmatch routing where the server chooses the opponent; same-server 1v1 is a no-reward prototype, and saved 1v1 rewards must wait for cross-server matchmaking.
- [ ] Add Battlepass-only custom 1v1 room creation and joining with no saved XP or coin rewards.
- [ ] Prototype future cross-server 1v1 matchmaking separately with MemoryStoreService queueing and TeleportService reserved match servers before relying on it for launch rewards.
- [ ] Add Tower Area launch pad server logic that validates the player's highest unlocked Tower level, then starts the controlled launch to the matching landing.
- [ ] Add sprint stamina config and runtime logic using XP milestones once the exact milestone thresholds and stamina values are confirmed.
- [ ] Make sprint a toggle controlled by Shift and by a visible GUI button; the button should highlight while sprint is requested/active and turn off automatically when stamina runs out or the player clicks it again.
- [x] Confirmed Done: Add first Rojo-ready Progression UI source files: `src/shared/ProgressionConfig.luau` and `src/client/Controllers/ProgressionUIController.client.luau`.
- [ ] Add a Studio-owned `StarterGui > ProgressionUI` ScreenGui with descendants named `TowerLevelLabel`, `XPLabel`, `NextLabel`, and optionally `ProgressBar > ProgressFill`; the VS Code controller binds to those names and must not auto-create fallback UI.
- [ ] Test the lobby Progression UI through Rojo and confirm it updates from server-owned `Experience` and `TowerLevel` values. When checking the fill bar, test `Experience = 50` at Tower Level 1 for a half bar, `Experience = 100` at Tower Level 1 for a full ready bar, or `Experience = 175` at Tower Level 2 for a half bar toward 250 XP.
- [ ] Add real Dungeon startup logic for solo runs, UTC daily question reset, question checkpoints, per-question reward claim tracking, wrong-answer coin removal, clear correct-answer UI reveal, solved-question state, per-level completion reward claim tracking, coin resets, normal-player cooldowns, one-time current failed-run cooldown skip purchases, Battlepass no-cooldown access, anti-copy rules, post-clear same-level Battlepass finisher visibility across the whole Dungeon, and finisher-only chat.
- [ ] Add real Up-Level Test startup logic for the boss fight, health bars, timed questions, pass/fail saving, and teleport return handling.
- [ ] Document the final Studio/VS Code workflow for editing one code directory while opening one Roblox place at a time.

## Use Chunk 7: Store Open Work Elsewhere

Use this chunk when an unresolved question, future-development note, deferred
decision, or idea to revisit is not ready to become a checklist task yet.

### 17.17 Notes File

Moved to [notes.md](notes.md).
