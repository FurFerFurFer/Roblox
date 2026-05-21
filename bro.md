# Roblox Game Project — Planning Format

## 1. Project Overview
- **Game Title:** Brain Brawl
- **Genre:** Quiz / Trivia + Obby hybrid
- **Target Audience:** General Roblox players, casual to competitive
- **Core Loop:** Spawn in the lobby, choose a portal, earn XP through gameplay, and unlock higher Tower levels as progression milestones
- **Monetization Strategy:** Developer Products (buy cooldown skip for dungeon mode), possibly Game Passes

---

## 2. Concept & Vision
- **Elevator Pitch:** Brain Brawl is a competitive trivia game on Roblox with four distinct modes — from fast-paced free-for-all quiz battles to a grueling solo dungeon obby where every wrong answer sets you back. It punishes guessing and rewards real knowledge.
- **Inspiration / References:** Quiz-style games (Kahoot, trivia battle games), obby games
- **Win Condition / End Goal for Player:** Earn coins, beat other players, survive the full 50-question dungeon
- **Mood & Aesthetic:** TBD

---

## 3. Gameplay Design

### 3.1 Core Mechanics
| Mechanic | Description | Priority (High/Med/Low) |
|---|---|---|
| Select-answer trivia | Players pick from multiple choice answers; first correct answer scores a point when the mode is in a scored state (Arena, 1v1, Group) | High |
| Dungeon path-picking | Correct answer path = collect coin and advance; wrong path = lose coins + full dungeon reset | High |
| Dungeon reset | Kill the player on wrong answer, respawn at dungeon start, reset all coins in the dungeon | High |
| Anti-copy (Dungeon) | No chat, players invisible to each other so no one can follow the correct path | High |
| Dungeon cooldown | On dungeon fail, player must wait 5 minutes before retrying, or pay currency to skip the wait | Med |
| Lobby portal hub | Players first spawn in the home/lobby base with mode portals, a Play button for direct Tower level entry, and access to a separate Tower area | High |
| Home Playground | A place next to the lobby for optional activities; the first supported activity is Group mode stages | High |
| Tower XP unlocks | Tower levels are separate server/place destinations; XP qualifies the player for an up-level test, and passing that test unlocks the next level | High |
| Tower Area gates | The Tower physically appears in its own Tower Area as a visual progression landmark and teleport-gate structure; players can climb or ride upward anywhere, but each level gate stays locked until the player's current/highest level allows entry | High |
| Tower Play button | A lobby Play button lets players choose a Tower level directly, using the same server-side current/highest level check as physical Tower gates | High |
| Tower level server format | Every Tower level server uses the same four-area layout: Arena, Dungeon Teleport, Spawn & Level Teleport, and Community | High |
| Up-level boss test server | The up-level test is a separate solo server with boss-fight trivia gameplay: a boss, problem board, timer, boss health bar, and player health bar | High |
| Community housing | Each Tower level has a Community area where players can buy or rent houses | Med |
| Arena visibility | Arena activity is visible by default to everyone in that Tower level server because each level has one large Arena area with a huge question projection | High |
| Arena gate join flow | Unlocked players touch the Arena gate, confirm `Join the Arena?`, then join immediately during intermission or spectate/queue during an active question | High |
| Arena session leaderboard | Arena keeps a top-5 leaderboard only for the current arena session; it resets when the arena becomes empty | High |
| Group stage placement | Group mode creates a stage, problem display, and chairs in either a Tower Community or the home Playground depending on permissions | High |
| Group activity spectate | Group activities are spectatable, but their stage visuals only appear for a player after that player chooses to spectate | High |
| Group stage nearby info | When a player walks near a Group stage, show the host-created stage name and the selected question type as `Level X - Topic` | High |

### 3.2 Player Progression
- **XP / Leveling System:** Players collect XP by answering correctly and completing runs. XP is used as a requirement check for an up-level test, not as the final unlock by itself.
- **Currency:** Coins — earned by scoring in trivia modes and collected physically in Dungeon mode
- **Unlockables:** Tower levels unlock after the player reaches the required XP for the next level and passes the up-level test. Level 1 is unlocked by default; Level 2 requires S2 XP plus the Level 1 up-level test; Level 3 requires S3 XP plus the Level 2 up-level test.
- **XP Cap Rule:** When a player reaches the XP requirement for their next up-level test, they stop gaining more XP until they pass that test and unlock the next Tower level.
- **Replayability Hooks:** Dungeon completion (high-stakes, one long run), competitive scoring in Arena/1v1/Group

### 3.3 Game Modes
| Mode | Description | Players |
|---|---|---|
| Arena | Free-for-all trivia inside the player's unlocked Tower level. One player can play as practice, but score and XP only count when at least two active players are inside. Touching the Arena gate opens `Join the Arena?`; accepted players join during intermission, while mid-question joiners spectate and queue for the next intermission. Unlike Group, Arena is the one large shared activity area on each Tower level, so its activity and huge question projection are visible to everyone in that level server without requiring spectate. | 1+ practice, 2+ scored |
| 1v1 | Same as Arena but only two players dueling each other | 2 |
| Group | Free-for-all trivia like Arena; players can create a physical group stage with the problem shown on stage and chairs for attendants. When players walk near a stage, they see the host-created stage name and the question type label, formatted as `Level X - Topic`. Normal players can create public stages only in unlocked Tower Community zones. Battlepass players can create stages in Tower Community zones or the home Playground, and may switch the activity from public to invite-only. | 3+ |
| Dungeon | Solo obby with ~50 questions; each question is a branching path; pick correct path to collect a coin and advance; wrong path = lose coins + full reset to dungeon start; players are invisible to each other, no chat; failed run = 5 min cooldown or pay to skip | Solo |
| Up-Level Test | Boss-fight trivia in a separate server; only one player plays, answering timed problems to damage the boss before their own health bar is depleted | Solo |

### 3.4 Lobby & Tower Flow
- Every player first spawns in the home server.
- The home server contains distinct spaces: Lobby Base, the broader Lobby area, the Playground, and the Tower area.
- The lobby contains portals for Arena, 1v1, and Dungeon. The Tower is a physical progression landmark and gate structure in the lobby rather than a separate hub server or gameplay interior.
- Group activity creation happens from the Playground in the home server or from Community zones inside unlocked Tower levels.
- Game mode portals send the player into the selected mode.
- Players reach physical Tower gates by entering the Tower area, then using a traversal elevator or climbing route to move upward.
- There is no elevator floor selector. The elevator/climb path is for movement and exploration; the Play button is the direct level-selection shortcut.
- Higher Tower level gates are physically placed higher up the Tower so progression is visible and motivating.
- Tower floors/areas are not locked. Players may explore upward and see higher-level gates before they can enter them.
- A Tower level gate teleports the player directly to that level's separate Tower level server only if that level is unlocked; the lobby Tower itself is not where Tower level gameplay happens.
- Locked Tower gates should be physically and visually blocked. The server still performs the final unlock check, so exploiters cannot enter by clipping, spoofing remotes, or touching the gate from the wrong side.
- The Play button can choose a Tower level directly, but it must use the same server-side current/highest level validation as the physical Tower gates.
- Each Tower level is a different server/place.
- Inside a Tower level, the Spawn & Level Teleport area is the player's spawn area and can include a return portal back to the Lobby Base. Direct level-to-level travel should be secondary to the Tower gates and Play button.
- Inside the Tower area, each level gate checks whether that level has been unlocked. XP/current level alone does not open a gate if an up-level test is still required.
- If the player has reached the XP requirement but has not passed the up-level test, the portal stays locked and should tell them to take the separate solo test.
- If the player has not reached the XP requirement, the portal stays locked and should show the missing XP requirement.
- For the first version, Tower has three physical and functional levels: Level 1 is the starting level, Level 2 requires S2 XP and a passed up-level test, and Level 3 requires S3 XP and a passed up-level test.
- Level 4+ should not be built yet, but the level config, gate naming pattern, destination mapping, and repeated Tower level layout should make adding higher levels straightforward later.
- Up-level tests are not one of the four repeated Tower level areas. They are separate server/place experiences using a solo boss-fight version of the trivia gameplay: a boss appears, a timed problem appears in front of the player, correct answers damage the boss, and wrong or expired answers damage the player.
- The up-level test pass condition is depleting the boss health bar. If the player's health bar reaches zero first, the test is failed and the next Tower level stays locked.

### 3.5 Tower Level Server Layout
Every Tower level server uses the same structure so players always understand where to go:

| Area | Purpose |
|---|---|
| Arena | Local free-for-all arena for players currently inside that same Tower level server. The arena is visible by default, and its oversized question projection can be seen across the level server without a spectate opt-in |
| Dungeon Teleport | Portal to that level's specific dungeon; only players with that Tower level unlocked can enter |
| Spawn & Level Teleport | Player spawn area plus optional return portal to the Lobby Base; direct level travel is optional and must reuse the same unlock checks |
| Community | Social/economy area for that level. Players can buy or rent houses, and Group free-for-all stages can physically appear in the black space with a problem display and attendant chairs |

Each Tower level has one matching dungeon. Example: Tower Level 1 sends to Dungeon Level 1, Tower Level 2 sends to Dungeon Level 2, and Tower Level 3 sends to Dungeon Level 3.
Each up-level test has its own matching test server/place. Example: the Level 1 -> Level 2 test sends one player to Up-Level Test 1, while the Level 2 -> Level 3 test sends one player to Up-Level Test 2.

### 3.6 Arena Visibility Rules
- Each Tower level has one main Arena area, not many hidden player-made arena stages.
- Arena activity visuals are visible by default to everyone in that Tower level server.
- Arena does not require a player to join or click spectate before they can see the activity.
- Arena questions use a very large projection/display, so players elsewhere on the level can see what question is active.
- Seeing the Arena activity does not automatically make the player a participant; it only means the physical activity and projected question are public inside that level server.

### 3.7 Arena Session Rules
- Only players who have unlocked that Tower level can join that level's Arena.
- The Arena starts when at least 1 eligible player joins and stops only when active players reach 0.
- A solo player can practice questions, but solo answers give no session score and no XP.
- Score and XP begin only when at least 2 active players are in the Arena.
- If the Arena began as solo practice, the second active player starts a fresh scored session at the next intermission; if they join during intermission, that same intermission becomes the scored-session start.
- The Arena runs forever until everyone leaves.
- Players cannot die inside Arena; wrong answers give no points and do not eliminate the player.
- Current scoring placeholder: first correct answer for a question scores 1 point. The final score formula can change later.
- Arena questions come from a controlled question bank. AI-generated questions are not planned for the first version.
- Each session shows a top-5 leaderboard using only scores from that session. Scores are not saved and do not carry to later sessions.
- When the Arena becomes empty, the session leaderboard resets.

### 3.8 Arena Join, Intermission, and Exit
- The Arena entrance uses a gate prompt: `Join the Arena?` with Yes / No choices.
- Clicking Yes during intermission joins the player into the active Arena roster immediately.
- Clicking Yes during an active question puts the player into spectator/queue state.
- Queued spectators enter the Arena during the next intermission.
- Intermission lasts 10 seconds between questions and shows a clear countdown.
- When players enter from the queue, they are gathered on the gate side of the Arena facing the opposite side's large question projection screen.
- Arena has an exit button. Leaving removes the player from active, queued, or spectator state.
- If a player leaves/disconnects, the server removes that player from the Arena session.

### 3.9 Playground & Group Activity Rules
- The Playground is part of the home server and sits next to the lobby.
- The first Playground activity is Group mode.
- Normal players cannot create Playground activities.
- Normal players can create Group stages in Tower Community zones for levels they have unlocked.
- Normal players can choose which unlocked Tower level receives their Community stage, but their stage is always public.
- Battlepass players can create Group stages in unlocked Tower Community zones or in the Playground.
- Battlepass players can set Group stages to public or invite-only.
- Invite-only controls who can join the activity, not who can spectate it.
- All Group activities are spectatable.
- Group activity visuals are opt-in for spectators: a client can know the activity exists, but the stage/chairs/problem display should not appear for that player until they click spectate.
- This opt-in visual rule is specific to Group activities and does not apply to Arena.
- Hosts can provide a custom stage name when creating a Group stage.
- Group stage question content is organized by question level, and each level has many topic choices. The stage info should show the selected pair as `Level X - Topic` even while the exact question bank is still TBD.
- Until a live question is active, the stage problem display can use the same two-line stage info text as its placeholder.
- Nearby Group stage info does not auto-join or auto-spectate the player; it is only an information prompt.

---

## 4. World & Level Design
- **Map Size:** (small / medium / large / procedural)
- **Number of Maps / Areas:**
- **Key Locations:**
  - [ ] Lobby Base — first spawn/home landing area with mode portals and the Play button
  - [ ] Lobby — broader home social/navigation area connected to Lobby Base, Playground, and Tower area
  - [ ] Playground — activity area next to the lobby; Battlepass players can place Group stages here
  - [ ] Tower Area — separate home-server area containing the visible high tower, traversal elevator, climb route, and vertically arranged teleport gates; the first build stops at Level 3
  - [ ] Tower Level 1 — separate level server/place with Arena, Dungeon Teleport, Spawn & Level Teleport, and Community areas
  - [ ] Tower Level 2 — separate level server/place with the same four-area format, unlocked by Level 1 up-level test
  - [ ] Tower Level 3 — separate level server/place with the same four-area format, unlocked by Level 2 up-level test
  - [ ] Level 1 Dungeon — specific dungeon destination for Tower Level 1
  - [ ] Level 2 Dungeon — specific dungeon destination for Tower Level 2
  - [ ] Level 3 Dungeon — specific dungeon destination for Tower Level 3
  - [ ] Up-Level Test 1 — separate solo timed boss-fight server for unlocking Tower Level 2
  - [ ] Up-Level Test 2 — separate solo timed boss-fight server for unlocking Tower Level 3
- **Spawn & Respawn Logic:** Players spawn in Lobby Base first. To enter Tower progression, they either use the Play button to choose an unlocked level directly or move to the Tower Area, climb/ride upward, and touch an unlocked level gate. In Tower level servers, players spawn in that level's Spawn & Level Teleport area. Portal touches/clicks handle routing to game modes, dungeons, Tower gates, Tower level servers, Community, or separate up-level test servers.
- **Lighting & Atmosphere:**

---

## 5. Characters & NPCs
| Name | Type (Player/NPC/Enemy/Boss) | Role | Behaviors |
|---|---|---|---|
|  |  |  |  |

---

## 6. UI / UX
- **HUD Elements:** (player health bar, boss health bar, currency, timer, minimap)
- **Menus Required:** (main menu, settings, shop, inventory, leaderboard)
- **Mobile Compatibility:** (yes / no / partial)
- **Accessibility Considerations:**

---

## 7. Scripts & Systems

### 7.1 Server-Side (Script)
- [ ] Game loop manager
- [ ] Data store (player saves)
- [ ] Anti-cheat / sanity checks
- [ ] NPC / AI logic
- [ ] Lobby portal router
- [ ] Tower level unlock checker
- [ ] TeleportService place routing
- [ ] Tower gate router, Play button router, current/highest level checker, locked-gate blocker, and destination place allowlist
- [ ] Tower level server router
- [ ] Tower Arena shared visibility/projection broadcaster
- [ ] Tower Arena gate prompt, join queue, spectator state, intermission loop, and exit handler
- [ ] Tower Arena solo-practice rule, fresh scored-session reset, answer scoring, and top-5 session leaderboard
- [ ] Up-level boss fight test handler
- [ ] XP cap / pause system
- [ ] Community house buy/rent system
- [ ] Community group stage spawner
- [ ] Playground group stage spawner
- [ ] Battlepass permission checker
- [ ] Group stage join/spectate router

### 7.2 Client-Side (LocalScript)
- [ ] Input handling
- [ ] UI controllers
- [ ] Camera behavior
- [ ] Visual effects (particles, tweens)

### 7.3 Shared (ModuleScript)
- [ ] Shared constants / config
- [ ] Utility functions
- [ ] Remotes manifest
- [ ] Tower XP threshold config and level-to-destination mapping that can extend past Level 3 later

### 7.4 Remote Events & Functions
| Name | Type (Event/Function) | Fired By | Handled By | Purpose |
|---|---|---|---|---|
| TowerAccessDenied | Event | Server | Client | Tell the player a Tower level is locked and how much XP is required |
| LobbyTowerGateStatesUpdated | Event | Server | Client | Tell the player which Tower gates and Play button choices are unlocked, locked, or ready for an up-level test |
| TowerLevelPlayRequested | Event | Client | Server | Request direct entry to a chosen Tower level from the lobby Play button |
| UpLevelTestReady | Event | Server | Client | Tell the player they have enough XP to attempt the up-level test |
| ExperienceCapped | Event | Server | Client | Tell the player XP gain is paused until they pass the up-level test |
| TowerCommunityEntered | Event | Server | Client | Tell the player they entered the Community area for a Tower level |
| ArenaActivityStarted | Event | Server | Client | Tell every client in the level server to show the shared Arena activity visuals |
| ArenaJoinPromptShown | Event | Server | Client | Show the `Join the Arena?` Yes / No prompt when an eligible player touches the Arena gate |
| ArenaJoinRequested | Event | Client | Server | Confirm that the player clicked Yes on the Arena gate prompt |
| ArenaJoinDenied | Event | Server | Client | Tell the player they cannot join because the Tower level is locked or unavailable |
| ArenaJoinQueued | Event | Server | Client | Tell a mid-question joiner they are queued for the next intermission |
| ArenaPlayerJoined | Event | Server | Client | Tell clients that a player entered the active Arena roster |
| ArenaSpectateStarted | Event | Server | Client | Tell a queued player they are spectating until the next intermission |
| ArenaIntermissionStarted | Event | Server | Client | Tell clients the 10-second break between Arena questions has started |
| ArenaCountdownTick | Event | Server | Client | Sync the visible Arena intermission countdown |
| ArenaQuestionProjected | Event | Server | Client | Send the current Arena question and answers to the large public Arena projection |
| ArenaQuestionResolved | Event | Server | Client | Tell clients when a question ended, who was first correct if any, and whether score/XP counted |
| ArenaAnswerSelected | Event | Client | Server | Submit a player's selected Arena answer |
| ArenaAnswerResult | Event | Server | Client | Tell a player whether their Arena answer was correct, wrong, already used, or practice-only |
| ArenaExitRequested | Event | Client | Server | Request to leave the active Arena, queue, or spectator state |
| ArenaPlayerLeft | Event | Server | Client | Tell clients that a player left the Arena session |
| ArenaLeaderboardUpdated | Event | Server | Client | Sync the top-5 leaderboard for the current Arena session |
| ArenaScoredSessionStarted | Event | Server | Client | Tell clients that the second active player started a fresh scored session |
| ArenaActivityEnded | Event | Server | Client | Tell every client in the level server to clear the shared Arena activity visuals |
| GroupStageCreateRequested | Event | Client | Server | Request a Group stage in a Tower Community or the Playground |
| GroupStageJoinRequested | Event | Client | Server | Request to join a public or invite-only Group stage |
| GroupStagePrivacyRequested | Event | Client | Server | Request a Battlepass host privacy change for their Group stage |
| GroupStageSpectateRequested | Event | Client | Server | Request to show or hide the visuals for a spectatable Group activity |
| GroupActivityAvailable | Event | Server | Client | Tell clients that a Group activity exists without showing its visuals by default |
| GroupActivityRemoved | Event | Server | Client | Tell clients that an activity ended and any opted-in visuals should be removed |
| GroupStageCreated | Event | Server | Client | Tell the creator that their Group stage was created |
| GroupStageAccessDenied | Event | Server | Client | Tell a player they need Battlepass or an unlocked level for the requested Group stage action |
| GroupStageJoinAllowed | Event | Server | Client | Tell a player they joined a Group stage and should see participant visuals |
| GroupStageJoinDenied | Event | Server | Client | Tell a player they cannot join an invite-only or missing Group stage |
| GroupStagePrivacyChanged | Event | Server | Client | Tell the host that their public/invite-only stage setting changed |
| GroupStageSpectateStarted | Event | Server | Client | Tell one player to render the selected Group activity visuals |
| GroupStageSpectateEnded | Event | Server | Client | Tell one player to hide the selected Group activity visuals |
| GroupStageInfoShown | Event | Server | Client | Tell one nearby player to show the stage name and `Level X - Topic` question type |
| GroupStageInfoHidden | Event | Server | Client | Tell one player to hide nearby stage info after they walk away |
| UpLevelBossFightStarted | Event | Server | Client | Tell the client the solo up-level boss fight has begun |
| UpLevelBossFightQuestion | Event | Server | Client | Send the current timed question, answers, health values, and round timer |
| UpLevelBossFightState | Event | Server | Client | Sync boss/player health, timer ticks, and round results |
| UpLevelBossFightEnded | Event | Server | Client | Tell the client whether the boss was defeated and the test passed |
| UpLevelBossFightAnswerSelected | Event | Client | Server | Submit a player's selected answer for the active up-level boss question |

---

## 8. Data & Persistence
- **DataStore Keys:** `PlayerProgress_v1:{UserId}`
- **Saved Player Data:** coins, total XP, highest unlocked Tower level, passed up-level tests, Battlepass ownership/entitlement, owned/rented houses, settings, inventory
- **Session Data (not saved):** current mode run, active Arena projection state, active Arena roster, queued Arena spectators, Arena intermission countdown, Arena per-session top-5 leaderboard, dungeon run state, active Community group stages, active Playground group stages, per-player group spectate opt-ins, portal touch debounce
- **Data Migration Plan:** (how to handle schema changes on live game)

---

## 9. Monetization Details
| Product | Type | Robux Price | What It Gives |
|---|---|---|---|
| Dungeon Cooldown Skip | Developer Product | TBD | Skip the 5-minute wait after a failed dungeon run |
| Battlepass | Game Pass | TBD | Create Group stages in the Playground and make Group stages invite-only |

- **VIP Server support:** TBD
- **Free-to-play friendly:** Yes — cooldown skip is convenience only

---

## 10. Milestones & Roadmap

| Phase | Goal | Target Date | Status |
|---|---|---|---|
| 0 — Prototype | Core loop playable in Studio | | Not Started |
| 1 — Alpha | All core systems in, no polish | | Not Started |
| 2 — Beta | Content complete, bug fixing | | Not Started |
| 3 — Launch | Public release on Roblox | | Not Started |
| 4 — Post-Launch | Updates, events, monetization | | Not Started |

---

## 11. Team & Roles
| Name | Role | Responsibilities |
|---|---|---|
|  | Lead Developer |  |
|  | Builder / Level Designer |  |
|  | UI Designer |  |
|  | Scripter |  |
|  | Sound / Music |  |
|  | QA / Tester |  |

---

## 12. Assets & Resources
- **Free Models Policy:** (allowed / not allowed / allowed with review)
- **Audio:** (Roblox library / custom uploaded / no audio)
- **External Tools:** VS Code, Rokit, Rojo, Luau Language Server, Wally, Selene, StyLua, Git/GitHub, plus art tools such as Blender, Photoshop, Moon Animator, Aseprite, etc.
- **Version Control:** Use Git/GitHub for scripts, shared config, planning docs, package manifests, and code review. Use branches for isolated feature work before merging into the main version. Keep generated package folders and build artifacts out of Git.
- **Studio Role:** Keep Roblox Studio as the source of truth for maps, lighting, terrain, and visual world building until the project needs a fully managed Rojo setup.

---

## 13. Professional Development Workflow

### 13.1 Recommendation
Brain Brawl should use a professional Roblox workflow built around VS Code, Rojo, Git/GitHub, Rokit, Wally, Selene, StyLua, and the Luau Language Server. Roblox Studio alone is fine for small experiments, but Brain Brawl is planned as a multi-system experience with Arena, Dungeon, Group stages, Tower progression, DataStores, remotes, UI controllers, teleport routing, and up-level boss tests. Those systems will become difficult to maintain if scripts are only edited inside Studio.

Core workflow message:
- VS Code is the main script editor.
- Rojo syncs code from VS Code into Roblox Studio.
- Git tracks every meaningful source change.
- GitHub backs up the project online and supports collaboration, branches, reviews, and restores.
- Rokit manages development tools so every developer can use the same versions.
- Wally manages reusable Luau packages.
- Selene and StyLua keep code quality and style consistent.
- Roblox Studio remains the visual editor for the world, places, UI layout, terrain, lighting, and playtesting.

Use a **partially managed Rojo workflow**:
- Rojo manages game code and shared configuration.
- Roblox Studio manages the physical world, maps, parts, portals, terrain, lighting, UI positioning, and visual layout.
- Do not Rojo-sync the full map in the first version.
- Do not edit Rojo-controlled scripts inside Studio because the file version will overwrite Studio changes.

### 13.2 Constructive Critique
- Rojo adds setup work and can slow down a beginner at first.
- Syncing the entire map too early can create confusion, especially while the world layout is still changing.
- If scripts stay scattered inside random parts, portals, GUI objects, and tools, the project will become hard to maintain.
- Brain Brawl has enough systems that Studio-only scripting will likely become painful once remotes, DataStores, teleport places, and mode logic grow.
- Wally packages add power, but each dependency must be chosen carefully so the game does not become harder to debug or update.
- Linting and formatting help, but rules should be introduced gradually so the team fixes real problems instead of fighting tool noise.
- Git branches are useful only if the team commits small, understandable changes and reviews risky features before merging.
- The safer path is to start with scripts only, then expand Rojo usage later if the project needs it.

### 13.3 Toolchain Setup Steps
1. Install VS Code.
2. Install Git and sign in to GitHub.
3. Install Rokit to manage Roblox development tools.
4. Use Rokit to install pinned project versions of Rojo, Wally, Selene, and StyLua.
5. Install VS Code extensions for Luau Language Server, Rojo, and optional inline Selene/StyLua support.
6. Enable useful Luau Language Server settings such as auto-import suggestions for Roblox services, packages, and require paths.
7. Install the Rojo Roblox Studio plugin.
8. Create the project folders:

```text
src/
  server/
  client/
  shared/
Packages/ (generated by Wally later, or created empty before packages exist)
```

9. Use the folders this way:

```text
src/server = ServerScriptService scripts and server modules
src/client = StarterPlayerScripts client controllers
src/shared = ReplicatedStorage modules, configs, and shared constants
Packages = Wally-installed packages exposed to Roblox through Rojo
```

10. Use script file suffixes consistently: `.server.luau` becomes a server `Script`, `.client.luau` becomes a `LocalScript`, and plain `.luau` becomes a `ModuleScript`.

11. Create `default.project.json` in the project root:

```json
{
  "name": "BrainBrawl",
  "tree": {
    "$className": "DataModel",

    "ReplicatedStorage": {
      "$className": "ReplicatedStorage",
      "$path": "src/shared",
      "Packages": {
        "$className": "Folder",
        "$path": "Packages"
      }
    },

    "ServerScriptService": {
      "$className": "ServerScriptService",
      "$path": "src/server"
    },

    "StarterPlayer": {
      "$className": "StarterPlayer",
      "StarterPlayerScripts": {
        "$className": "StarterPlayerScripts",
        "$path": "src/client"
      }
    }
  }
}
```

12. Add first test files:

```text
src/shared/TowerConfig.luau
src/server/Main.server.luau
src/client/Main.client.luau
```

13. Example `TowerConfig.luau`:

```luau
local TowerConfig = {}

TowerConfig.LevelRequirements = {
	[1] = 0,
	[2] = 100,
	[3] = 250,
}

return TowerConfig
```

14. Example `Main.server.luau`:

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TowerConfig = require(ReplicatedStorage:WaitForChild("TowerConfig"))

print("Brain Brawl server loaded", TowerConfig.LevelRequirements[2])
```

15. Example `Main.client.luau`:

```luau
print("Brain Brawl client loaded")
```

16. Start the Rojo server from the project folder:

```bash
rojo serve
```

17. Open Roblox Studio.
18. Open the Brain Brawl place.
19. Open the Rojo plugin from the Plugins tab.
20. Click Connect.
21. Confirm the synced instances appear: `ReplicatedStorage/TowerConfig`, `ReplicatedStorage/Packages` when Wally packages exist, `ServerScriptService/Main`, and `StarterPlayer/StarterPlayerScripts/Main`.

### 13.4 Git, GitHub, and Branches
- Initialize Git in the real project folder when development begins.
- Create a `.gitignore` that excludes generated package output, temporary files, local tool caches, and build artifacts.
- Commit early project setup files such as `default.project.json`, `wally.toml`, `selene.toml`, `.stylua.toml`, `rokit.toml`, source files, and planning docs.
- Push the repository to GitHub so the project is backed up and visible online.
- Use a main branch for stable work.
- Create feature branches for isolated systems such as `arena-loop`, `tower-progression`, `dungeon-reset`, or `group-stages`.
- Review and test feature branches before merging them back into the main branch.
- Use Git history to restore older versions when a change breaks gameplay.

### 13.5 Wally Packages
- Use Wally when Brain Brawl needs proven reusable libraries instead of hand-rolling everything.
- Good package candidates could include Promise-style async helpers, ProfileService-style data patterns, UI frameworks such as React or Fusion, or small utility libraries.
- Add dependencies to `wally.toml`.
- Run Wally install from the project folder.
- Keep generated package install output out of Git unless the team intentionally chooses vendoring.
- Update `default.project.json` so Roblox Studio can see installed packages through `ReplicatedStorage/Packages`.
- Avoid adding packages before they solve a real problem; every dependency has maintenance cost.

### 13.6 Selene and StyLua
- Use Selene to catch suspicious Luau patterns, bad globals, unused values, and risky mistakes before playtesting.
- Use StyLua to format code automatically so code reviews focus on behavior instead of spacing.
- Prefer format-on-save once the team agrees on the style.
- Keep linting rules practical at first; tighten them after the first prototype is stable.

### 13.7 Day-to-Day Workflow
- Edit scripts in VS Code.
- Run `rojo serve` while developing.
- Connect the Rojo plugin in Roblox Studio.
- Build and adjust physical maps in Studio.
- Use Wally only when a shared package is needed.
- Run Selene before committing meaningful script changes.
- Run StyLua before committing or use format-on-save.
- Save/publish the Roblox place from Studio when map changes are ready.
- Commit script/config changes through Git with clear messages.
- Push branches to GitHub for backup and review.
- Keep `bro.md` as the design plan.
- Keep `To-Do.md` as the builder task guide, checklist, testing routine, and
  handoff checklist.
- Keep `bro.luau` as the rough implementation draft until systems are split into real modules.

### 13.8 Migration Order From `bro.luau`
Move code from `bro.luau` into real Rojo modules in this order:

```text
1. shared/TowerConfig.luau
2. shared/Remotes.luau
3. server/PlayerDataService.luau
4. server/TowerService.luau
5. server/ArenaService.luau
6. server/DungeonService.luau
7. server/GroupStageService.luau
8. server/UpLevelTestService.luau
9. client/UIController.luau
10. client/ArenaController.luau
```

### 13.9 Open Workflow Questions
- Which computer/OS will be used for Rojo development?
- Will the project use GitHub from the start or only local Git at first?
- Should each Tower level place use the same shared code through Rojo, or should each place get separate project files later?
- When real Roblox place IDs exist, should `default.project.json` add `servePlaceIds` to reduce the risk of syncing into the wrong place?
- Which packages are worth adding through Wally for the first production build?
- Should Selene and StyLua be required before every merge, or only used manually at first?
- Will GitHub pull requests be used for review, or will branches be merged locally during solo development?

---

## 14. Testing Checklist
- [ ] Solo playtest in Studio
- [ ] Team test (multi-player server)
- [ ] Mobile device test
- [ ] Data store save/load verified
- [ ] Lobby portals send players to the correct destinations
- [ ] Tower Area elevator/climb route lets players reach visible Tower level gates
- [ ] Tower floors/areas remain explorable even when higher gates are locked
- [ ] Tower gates reject players below the XP/current-level requirement or without the required up-level test
- [ ] Tower gates allow players who have unlocked that Tower level
- [ ] Play button direct level selection rejects locked levels and allows unlocked levels using the same checks as Tower gates
- [ ] Tower gate and Play button routing reject invalid level numbers, missing place IDs, and destination place IDs outside the server allowlist
- [ ] First build exposes only Level 1, Level 2, and Level 3 Tower gates while keeping the naming/config format ready for Level 4+
- [ ] XP stops increasing when the player reaches the next up-level test requirement
- [ ] Up-level tests launch in a separate solo timed boss-fight server
- [ ] Passing an up-level test unlocks the next Tower level and resumes XP gain
- [ ] Each Tower level dungeon portal only accepts players who unlocked that level
- [ ] Any direct level teleport portals only send players to unlocked Tower levels and use the same checks as Tower gates and the Play button
- [ ] Community area allows valid house buy/rent actions only for players with that Tower level unlocked
- [ ] Arena activity and the large question projection are visible to everyone in the Tower level server without clicking spectate
- [ ] Arena gate shows `Join the Arena?` and only unlocked players can accept
- [ ] Arena starts with 1 player as practice and gives no score/XP while solo
- [ ] When the second active player joins, Arena starts a fresh scored session at intermission
- [ ] Players who join during an active Arena question spectate and queue until the next intermission
- [ ] Arena intermission lasts 10 seconds and shows a clear countdown
- [ ] Arena exit button removes active, queued, and spectator players correctly
- [ ] Arena ends and resets the session leaderboard when active players reach 0
- [ ] Arena leaderboard shows only the top 5 scores from the current session and does not persist
- [ ] Group mode creates a physical stage layout in a Community zone or the Playground with problem display and attendant chairs
- [ ] Normal players can create public Group stages only in unlocked Tower Community zones
- [ ] Normal players cannot create Group stages in the Playground
- [ ] Battlepass players can create Group stages in the Playground
- [ ] Battlepass players can switch Group stages between public and invite-only
- [ ] Invite-only stages block non-invited players from joining but still allow spectating
- [ ] Group activity visuals appear only after the player joins or clicks spectate
- [ ] Walking near a Group stage shows the host-created stage name and `Level X - Topic`
- [ ] Monetization products tested (sandbox)
- [ ] Edge cases: afk player, server shutdown mid-game, full server

---

## 15. Launch Checklist
- [ ] Game thumbnail uploaded
- [ ] Game icon uploaded
- [ ] Description written
- [ ] Genre & tags set correctly
- [ ] Privacy set to Public
- [ ] VIP servers configured
- [ ] Social links added (Discord, Twitter/X)
- [ ] First update announcement ready

---

## 16. Notes & Open Questions
- Confirmed: no separate Tower Unite server/place. Tower progression is represented by the visible Tower Area in the home server.
- Confirmed: Lobby Base, the broader Lobby area, and the Tower Area are separate physical spaces.
- Confirmed: Tower floors/areas are not locked. Players can climb or ride upward anywhere so higher gates act as visible motivation.
- Confirmed: locked Tower gates are the actual progression blockers; touching a gate must always check the player's current/highest Tower level on the server.
- Confirmed: current Tower level means the player's highest available Tower level based on their XP/progression state.
- Confirmed: there is no elevator floor selector. The Play button is the direct way to choose and teleport to a Tower level.
- Confirmed: the Play button must reuse the same current/highest level validation as physical Tower gates.
- Confirmed: the lobby Tower is a visual decoration, progression landmark, and physical gate area. It does not contain the actual Tower level gameplay; each unlocked gate teleports to the matching level destination.
- Confirmed: first build stops at Tower Level 3 physically and functionally, but the config, naming, gate layout, and destination mapping should be easy to extend for Level 4+ later.
- Tower motivation note: the shared lobby Tower should feel like a clear, achievable goal because higher floors are visible, more decorated, and carry an elite-genius status fantasy.
- Difficulty/status note: baseline gameplay should not feel punishingly hard; higher Tower levels should mainly communicate stronger tests, greater status, and deeper progression rather than making new players feel blocked by difficulty.
- Player experience critique to revisit later: avoid making lower floors feel like a boring zone; even early floors need enough energy, social proof, and reward feedback to make new players feel included while still wanting to climb higher.
- Navigation note: climbing or riding upward should be atmospheric, but repeated access should not become friction. The Play button remains the fast path, while the physical Tower is the prestige and discovery path.
- Scope note: approved efficient building approach is to decorate milestone floors heavily and use reusable modular pieces for connector floors. Upper floors can feel richer through lighting, signage, materials, silhouettes, and status displays instead of unique assets everywhere.
- Future design note: leaderboard displays may help communicate Tower status later, but their exact format and placement are deferred.
- Technical note: do not add an extra server just to hold the visible lobby Tower. Keep the physical Tower in the home server; use separate places/servers only for Tower level gameplay, dungeons, and up-level tests.
- Server verification note: approved access model is that every Tower gate and direct Play button request must be validated server-side against saved player data: highest unlocked Tower level, required XP threshold, passed up-level test, and destination place ID allowlist. The client may request entry, but the server chooses whether to teleport or deny.
- Pick real numbers for S1, S2, and S3.
- Add the real Roblox place ID for the home/lobby place.
- Add the real Roblox place IDs for Tower Level 1, Tower Level 2, Tower Level 3, and each level-specific dungeon.
- Decide whether game mode portals stay inside the lobby place or teleport players to separate mode places.
- Add the real Roblox place IDs for each separate up-level test server.
- Confirm the exact boss health, player health, timer length, and damage values for each up-level test.
- Decide the final topic choices available inside each question level; current stage labels support `Level X - Topic` placeholders.
- Decide Community house prices, rental duration, limits, and whether houses are level-specific.
- Decide how many physical Group stages can exist in one Community black space at the same time.
- Add the real Battlepass game pass ID.
- Decide how many Group stages can exist in the Playground at the same time.
- Decide final Arena score values, XP rewards, question timer length, and complete question-bank content by Tower level/topic.

---

## 17. To Do List

Moved to [To-Do.md](To-Do.md).

---

## 18. Project Management & Collaboration

### 18.1 Roblox Studio Code Map
This project is connected to Roblox Studio through Rojo. Files in the Rojo project folder sync into Studio, so organizing files on disk also makes Explorer easier to understand.

Current synced code:

```text
ReplicatedStorage
  TowerConfig          <- shared ModuleScript

ServerScriptService
  Main                 <- server Script

StarterPlayer
  StarterPlayerScripts
    Main               <- client LocalScript
```

Current UI screens:

```text
StarterGui
  AdventureGuide
  LoginSystem
  PlayButton
  Tutorial
```

Ignore this Rojo helper object:

```text
ServerStorage
  __Rojo_SessionLock
```

That object only means Rojo is connected to the Roblox Studio session.

### 18.2 Recommended Code Organization
Use this layout to make it obvious which files are server code, client code, shared config, remotes, or visual UI:

```text
ReplicatedStorage
  Shared
    Config
      TowerConfig
    Modules
    Remotes

ServerScriptService
  Server
    ServerMain
    Services
      PlayerDataService
      RoundService
      TowerService

StarterPlayer
  StarterPlayerScripts
    Client
      ClientMain
      Controllers
        UIController
        InputController

StarterGui
  Screens
    AdventureGuide
    LoginSystem
    PlayButton
    Tutorial
```

### 18.3 Folder Meaning
```text
Shared = code both server and client can use
Server = code only the server uses
Client = code only the player/client uses
Screens = visual UI
Services = server systems
Controllers = client systems
Config = settings/data tables
Remotes = RemoteEvents / RemoteFunctions
```

### 18.4 Where Future Files Should Go
Put game rules, saving, rewards, and anti-cheat logic here:

```text
ServerScriptService > Server
```

Examples:

```text
PlayerDataService
RewardService
QuestionService
RoundService
TowerService
```

Put UI button behavior, animations, camera, and input here:

```text
StarterPlayer > StarterPlayerScripts > Client
```

Examples:

```text
UIController
PlayButtonController
TutorialController
CameraController
```

Put shared settings and reusable modules here:

```text
ReplicatedStorage > Shared
```

Examples:

```text
TowerConfig
QuestionConfig
GameConstants
NumberFormatter
```

Put visual UI only here:

```text
StarterGui > Screens
```

Examples:

```text
LoginSystem
PlayButton
Tutorial
AdventureGuide
```

### 18.5 Rojo File Naming Rules
Rojo file names help decide what kind of Roblox object gets created:

```text
.server.luau = server Script
.client.luau = client LocalScript
.luau = ModuleScript / reusable code
```

Current files:

```text
src/shared/TowerConfig.luau
src/server/Main.server.luau
src/client/Main.client.luau
```

Cleaner future layout:

```text
src/shared/Config/TowerConfig.luau
src/server/ServerMain.server.luau
src/client/ClientMain.client.luau
```

Future examples:

```text
src/server/Services/PlayerDataService.luau
src/client/Controllers/UIController.luau
src/shared/Config/GameConfig.luau
```

Best rule: if it has `.server.luau`, it is server code. If it has `.client.luau`, it is client code. If it is just `.luau`, it is usually reusable module code.
