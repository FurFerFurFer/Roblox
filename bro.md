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
| Lobby portal hub | Players first spawn in the home lobby with mode portals plus one Tower portal that sends them to their current/highest unlocked Tower level | High |
| Home Playground | A place next to the lobby for optional activities; the first supported activity is Group mode stages | High |
| Tower XP unlocks | Tower levels are separate server/place destinations; XP qualifies the player for an up-level test, and passing that test unlocks the next level | High |
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
- Every player first spawns in the lobby server.
- The home server contains the lobby and the Playground area next to it.
- The lobby contains portals for Arena, 1v1, Dungeon, and Tower.
- Group activity creation happens from the Playground in the home server or from Community zones inside unlocked Tower levels.
- Game mode portals send the player into the selected mode.
- The Tower portal is not a game mode. When stepped into, it automatically transports the player to their current Tower level, meaning the highest Tower level they have unlocked.
- Each Tower level is a different server/place.
- Inside a Tower level, the Spawn & Level Teleport area lets players travel to other Tower levels they have already unlocked.
- Inside the Tower, each level portal checks whether that level has been unlocked. XP alone does not open the next level.
- If the player has reached the XP requirement but has not passed the up-level test, the portal stays locked and should tell them to take the separate solo test.
- If the player has not reached the XP requirement, the portal stays locked and should show the missing XP requirement.
- For the first version, Tower has three levels: Level 1 is the starting level, Level 2 requires S2 XP and a passed up-level test, and Level 3 requires S3 XP and a passed up-level test.
- Up-level tests are not one of the four repeated Tower level areas. They are separate server/place experiences using a solo boss-fight version of the trivia gameplay: a boss appears, a timed problem appears in front of the player, correct answers damage the boss, and wrong or expired answers damage the player.
- The up-level test pass condition is depleting the boss health bar. If the player's health bar reaches zero first, the test is failed and the next Tower level stays locked.

### 3.5 Tower Level Server Layout
Every Tower level server uses the same structure so players always understand where to go:

| Area | Purpose |
|---|---|
| Arena | Local free-for-all arena for players currently inside that same Tower level server. The arena is visible by default, and its oversized question projection can be seen across the level server without a spectate opt-in |
| Dungeon Teleport | Portal to that level's specific dungeon; only players with that Tower level unlocked can enter |
| Spawn & Level Teleport | Player spawn area plus portals for travelling to other unlocked Tower levels |
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
  - [ ] Lobby — first spawn area with all mode portals
  - [ ] Playground — activity area next to the lobby; Battlepass players can place Group stages here
  - [ ] Tower entrance — non-game-mode portal that sends the player to their current/highest unlocked Tower level
  - [ ] Tower Level 1 — separate level server/place with Arena, Dungeon Teleport, Spawn & Level Teleport, and Community areas
  - [ ] Tower Level 2 — separate level server/place with the same four-area format, unlocked by Level 1 up-level test
  - [ ] Tower Level 3 — separate level server/place with the same four-area format, unlocked by Level 2 up-level test
  - [ ] Level 1 Dungeon — specific dungeon destination for Tower Level 1
  - [ ] Level 2 Dungeon — specific dungeon destination for Tower Level 2
  - [ ] Level 3 Dungeon — specific dungeon destination for Tower Level 3
  - [ ] Up-Level Test 1 — separate solo timed boss-fight server for unlocking Tower Level 2
  - [ ] Up-Level Test 2 — separate solo timed boss-fight server for unlocking Tower Level 3
- **Spawn & Respawn Logic:** Players spawn in the lobby first. In Tower level servers, players spawn in that level's Spawn & Level Teleport area. Portal touches/clicks handle routing to game modes, dungeons, Tower level servers, Community, or separate up-level test servers.
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
- [ ] Tower XP threshold config

### 7.4 Remote Events & Functions
| Name | Type (Event/Function) | Fired By | Handled By | Purpose |
|---|---|---|---|---|
| TowerAccessDenied | Event | Server | Client | Tell the player a Tower level is locked and how much XP is required |
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
- **External Tools:** (Blender, Photoshop, Moon Animator, Aseprite, etc.)
- **Version Control:** (GitHub, Rojo, manual backups)

---

## 13. Testing Checklist
- [ ] Solo playtest in Studio
- [ ] Team test (multi-player server)
- [ ] Mobile device test
- [ ] Data store save/load verified
- [ ] Lobby portals send players to the correct destinations
- [ ] Lobby Tower portal sends each player to their current/highest unlocked Tower level
- [ ] Tower level portals reject players below the XP requirement or without the required up-level test
- [ ] Tower level portals allow players who have unlocked that Tower level
- [ ] XP stops increasing when the player reaches the next up-level test requirement
- [ ] Up-level tests launch in a separate solo timed boss-fight server
- [ ] Passing an up-level test unlocks the next Tower level and resumes XP gain
- [ ] Each Tower level dungeon portal only accepts players who unlocked that level
- [ ] Level teleport portals only send players to unlocked Tower levels
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

## 14. Launch Checklist
- [ ] Game thumbnail uploaded
- [ ] Game icon uploaded
- [ ] Description written
- [ ] Genre & tags set correctly
- [ ] Privacy set to Public
- [ ] VIP servers configured
- [ ] Social links added (Discord, Twitter/X)
- [ ] First update announcement ready

---

## 15. Notes & Open Questions
- Pick real numbers for S1, S2, and S3.
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
