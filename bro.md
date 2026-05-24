# Roblox Game Project — Planning Format

## 1. Project Overview
- **Game Title:** Brain Brawl
- **Genre:** Quiz / Trivia + Obby hybrid
- **Target Audience:** General Roblox players, casual to competitive
- **Core Loop:** Spawn in the lobby, choose a portal, earn XP through gameplay, and unlock higher Tower levels as progression milestones
- **Monetization Strategy:** Developer Products (buy cooldown skip for normal Dungeon players), plus a Battlepass Game Pass for social/private activity perks, no-cooldown Dungeon access, and post-clear Dungeon finisher visibility/chat

---

## 2. Concept & Vision
- **Elevator Pitch:** Brain Brawl is a competitive trivia game on Roblox with four distinct modes — from fast-paced free-for-all quiz battles to a grueling solo dungeon obby where every wrong answer sets you back. It punishes guessing and rewards real knowledge.
- **Inspiration / References:** Quiz-style games (Kahoot, trivia battle games), obby games
- **Win Condition / End Goal for Player:** Earn coins, beat other players, survive the full 50-question dungeon
- **Mood & Aesthetic:** Deferred; track the open aesthetic decision in [notes.md](notes.md).

---

## 3. Gameplay Design

### 3.1 Core Mechanics
| Mechanic | Description | Priority (High/Med/Low) |
|---|---|---|
| Select-answer trivia | Players pick from multiple choice answers in the player UI; first correct answer scores a point when the mode is in a scored state (Arena, 1v1, Group). Arena and Group do not use physical answer pads. | High |
| Dungeon path-picking | Answer choices can be represented by answer coins/pickups. Correct coin = claim that question's once-per-daily reward, delete/hide wrong coins for that player, and open the path forward; wrong coin = fail/reset, reveal the correct answer in UI, and remove that wrong coin from the player's next attempt so only the correct coin remains for that question. | High |
| Dungeon reset | Kill the player on wrong answer and respawn at dungeon start. Already claimed, solved, or wrong-answer-removed question states do not reset for that player until the next UTC daily reset. | High |
| Anti-copy (Dungeon) | No chat, players invisible to each other so no one can follow the correct path | High |
| Daily Dungeon reset | Dungeon questions/routes reset automatically every day at UTC midnight so route knowledge expires and players get a fresh daily challenge. | High |
| Battlepass Dungeon finisher layer | Battlepass players who finish all questions in the current daily set for a Dungeon level automatically gain whole-Dungeon visibility/chat for that level with other Battlepass daily finishers. No invite is needed. Access resets at UTC midnight and must be earned again after the daily reset. Non-finishers and normal players remain invisible and cannot use Dungeon chat. | Med |
| Dungeon cooldown | On dungeon fail, normal players must wait 5 minutes before retrying, buy a one-time skip for the current failed-run cooldown, or buy Battlepass for no-cooldown Dungeon access. Battlepass players have no Dungeon cooldown. | Med |
| Lobby portal hub | Players first spawn in the home/lobby base with mode portals, a Play button for direct Tower level entry, and access to a separate Tower area | High |
| Home Playground | A place next to the lobby for optional activities; the first supported activity is Group mode stages | High |
| Tower XP unlocks | Tower levels are separate server/place destinations; XP qualifies the player for an up-level test, and passing that test unlocks the next level | High |
| Tower Area gates | The Tower physically appears in its own Tower Area as a visual progression landmark and teleport-gate structure; players can climb or ride upward anywhere, but each level gate stays locked until the player's current/highest level allows entry | High |
| Highest-level launch pad | A Tower Area launch pad uses a controlled launch animation to send a player toward their server-validated highest unlocked Tower level, reducing repeated climb time while still letting the physical Tower show progression | Med |
| Progression sprint stamina | Extra sprint stamina applies everywhere as the preferred movement progression reward instead of raw speed boosts; bigger stamina is earned through XP milestones, while exact milestone thresholds, stamina values, drain rate, and recharge rate are still undecided | Med |
| Tower Play button | A lobby Play button lets players choose a Tower level directly, using the same server-side current/highest level check as physical Tower gates | High |
| Tower level server format | Every Tower level server uses the same four-area layout: Arena, Dungeon Teleport, Spawn & Level Teleport, and Community | High |
| Up-level boss test server | The up-level test is a separate solo server with boss-fight trivia gameplay: a boss, problem board, timer, boss health bar, and player health bar | High |
| Community housing | Each Tower level has a Community area with a reserved `HousesArea`; actual house models only appear after a player buys, rents, or adds one | Med |
| Arena visibility | Arena activity is visible by default to everyone in that Tower level server because each level has one large Arena area with a huge question projection | High |
| Arena gate join flow | Unlocked players touch the Arena gate, confirm `Join the Arena?`, then join immediately during intermission or spectate/queue during an active question | High |
| Arena session leaderboard | Arena keeps a top-5 leaderboard only for the current arena session; it resets when the arena becomes empty | High |
| Group stage placement | Group mode uses a reserved `GroupStagesArea`; actual stage models, problem displays, and chairs appear only after a player creates/adds a stage in a Tower Community or the home Playground, depending on permissions | High |
| Group activity spectate | Group activities are spectatable, but their stage visuals only appear for a player after that player chooses to spectate | High |
| Group stage nearby info | When a player walks near a Group stage, show the host-created stage name and the selected question type as `Level X - Topic` | High |

### 3.2 Player Progression
- **XP / Leveling System:** Players collect XP by answering correctly and completing runs. XP is used as a requirement check for an up-level test, not as the final unlock by itself.
- **Currency:** Coins — earned by scoring in trivia modes and collected physically in Dungeon mode
- **Unlockables:** Tower levels unlock after the player reaches the required XP for the next level and passes the up-level test. Level 1 is unlocked by default; Level 2 requires S2 XP plus the Level 1 up-level test; Level 3 requires S3 XP plus the Level 2 up-level test.
- **Sprint Stamina:** Players gain bigger sprint stamina through XP milestones. Sprint is toggled on/off with Shift or by clicking a visible sprint GUI button. The button highlights while sprint is requested/active, then turns off automatically when stamina runs out or when the player clicks it again. The stamina benefit applies everywhere, but the exact milestone thresholds, stamina values, drain rate, and recharge rate are still open decisions.
- **XP Cap Rule:** When a player reaches the XP requirement for their next up-level test, they stop gaining more XP until they pass that test and unlock the next Tower level.
- **Competitive Reward Policy:** Session score and saved progression rewards are separate. Private/VIP, invite-only, and custom matches can show score and feedback, but they do not give competitive saved XP or coins. Lesson Mode rewards are separate one-time educational milestone rewards. The competitive saved reward priority is Arena public 4+ active players highest, cross-server random 1v1 Quickmatch next, and eligible public Group rooms at 20% of Arena rewards.
- **Replayability Hooks:** Dungeon completion (high-stakes, one long run), competitive scoring in Arena/1v1/Group

### 3.3 Game Modes
| Mode | Description | Players |
|---|---|---|
| Arena | Free-for-all trivia inside the player's unlocked Tower level. One player can play as unscored solo practice inside Arena, and local session score can start with at least two active players, but saved XP/coin rewards require a public, non-private Arena room with at least four active eligible players. Touching the Arena gate opens `Join the Arena?`; accepted players join during intermission, while mid-question joiners spectate and queue for the next intermission. Unlike Group, Arena is the one large shared activity area on each Tower level, so its activity and huge question projection is visible to everyone in that level server without requiring spectate. | 1+ solo practice, 2+ local score, 4+ reward-eligible |
| Lesson Mode | Personal learning mode shown as a popup/slide UI in the current server. A lesson is made of short slide-style explanations, examples, and milestone practice tests. Milestone tests grant small server-authorized, one-time XP/coin rewards plus lesson badges when passed, but repeated lesson attempts do not farm rewards. A free intro lesson/question is available to everyone from the Play menu. Level-specific lessons are available through the Play menu and from the player's house in that Tower level, only if the server confirms they own or rent an active house in that same Tower level. | 1 |
| Quickmatch | Fast Play-menu option that sends the player toward the default public trivia match flow. Quickmatch is the required path for 1v1 because players must not choose their rewarded opponent. The first 1v1 Quickmatch prototype can pair players within the same Roblox server, but saved 1v1 rewards stay disabled until cross-server matchmaking sends matched players into server-owned reserved match servers. | 1+ |
| 1v1 | Two-player duel trivia. Rewarded 1v1 is random Quickmatch only, and real saved 1v1 rewards require the cross-server matchmaking version. Same-server random 1v1 is a prototype path with local score only until that exists. Custom 1v1 matches can be created only by Battlepass players and give no saved XP or coins. Player-picked opponents, private/VIP servers, invite-only rooms, and custom matches can still show local score but are not progression-reward eligible. | 2 |
| Group | Free-for-all trivia like Arena; players can create a physical group stage with the problem shown on stage and chairs for attendants. When players walk near a stage, they see the host-created stage name and the question type label, formatted as `Level X - Topic`. Normal players can create public stages only in unlocked Tower Community zones. Battlepass players can create stages in Tower Community zones or the home Playground, and may switch the activity from public to invite-only. Saved rewards require the same public-room style as Arena, at least four active eligible players, and any other match-quality checks; eligible Group rewards pay 20% of Arena rewards. Private or invite-only Group rooms give no saved rewards. | 3+ play, 4+ reward-eligible |
| Dungeon | Solo obby with ~50 daily-reset questions; each question is a branching path with answer coins/pickups. Pick the correct coin to claim that question's once-per-daily-reset reward, delete/hide wrong coins for that player, and open the next path. Pick a wrong coin to fail/reset, show a clear UI message with the correct answer, and remove that wrong coin from the player's next attempt so only the correct coin remains for that question. Dungeon level completion rewards are also once per level per daily reset. During active solving, players are invisible to each other and cannot chat. Normal players get a 5-minute failure cooldown, can buy a one-time skip for the current failed-run cooldown, or can buy Battlepass for no-cooldown Dungeon access. Battlepass players have no Dungeon cooldown. After finishing all questions in one Dungeon level's current daily set, Battlepass players automatically gain whole-Dungeon visibility/chat for that level with other Battlepass daily finishers until the next UTC reset. | Solo, with post-clear Battlepass finisher social layer |
| Up-Level Test | Boss-fight trivia in a separate server; only one player plays, answering timed problems to damage the boss before their own health bar is depleted | Solo |

### 3.4 Lobby & Tower Flow
- Every player first spawns in the home server.
- The home server contains distinct spaces: Lobby Base, the broader Lobby area, the Playground, and the Tower area.
- The home lobby should be organized into two nearby but clearly separable zones. The main action zone contains the game mode portals and the clear path to the Tower Area. The info/social route zone contains the leaderboard, login board, tutorial board, guide board, and the clear path to the Playground.
- The game mode portals and Tower Area path should be close to each other so players understand them as the main play choices. The leaderboard, login/tutorial/guide boards, and Playground path should be close to each other so players understand them as information and social navigation. These two zones should be easy to separate visually through layout, spacing, floor shape, lighting, signs, railings, arches, or another simple cue.
- The lobby contains portals for Arena, 1v1, and Dungeon. The Tower is a physical progression landmark and gate structure in the lobby rather than a separate hub server or gameplay interior.
- Group activity creation happens from the Playground in the home server or from Community zones inside unlocked Tower levels.
- Game mode portals send the player into the selected mode.
- The Play button opens a small choice menu. The first choices are Tower, Quickmatch, and Lesson Mode. Tower opens the Level 1, Level 2, and Level 3 selection buttons. Quickmatch sends the player toward the default public match flow. Lesson Mode always shows the free intro lesson/question, then shows level-specific lesson choices only for Tower levels where the server confirms the player owns or rents an active house.
- Lesson Mode is also accessible from inside the player's house in that Tower level. House-launched lessons use that house's Tower level lesson and question set.
- Players reach physical Tower gates by entering the Tower area, then using a traversal elevator or climbing route to move upward.
- There is no elevator floor selector. The elevator/climb path is for movement and exploration; the Play button is the direct level-selection shortcut.
- Higher Tower level gates are physically placed higher up the Tower so progression is visible and motivating.
- Tower floors/areas are not locked. Players may explore upward and see higher-level gates before they can enter them.
- Current direction: do not use a plain speed boost as the Tower traversal reward. Instead, add a Tower Area launch pad that uses a controlled launch animation to send the player toward their highest unlocked Tower level after the server validates saved progression.
- Extra sprint stamina can apply everywhere as a progression reward instead of higher movement speed. The main current gameplay benefit is faster solo Dungeon completion, which is not directly competitive, but stamina scaling still needs to be balanced with Dungeon reward and progression pacing.
- A Tower level gate teleports the player directly to that level's separate Tower level server only if that level is unlocked; the lobby Tower itself is not where Tower level gameplay happens.
- Locked Tower gates should be physically and visually blocked. The server still performs the final unlock check, so exploiters cannot enter by clipping, spoofing remotes, or touching the gate from the wrong side.
- In routing, UI, and gate checks, current/highest Tower level means the highest Tower level the server says the player can access from saved XP/progression state and passed up-level tests.
- When the Play button's Tower choice is used, the selected Tower level must use the same server-side current/highest level validation as the physical Tower gates.
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
| Arena | Local free-for-all arena for players currently inside that same Tower level server. The arena is visible by default, and its oversized question projection can be seen across the level server without a spectate opt-in. Players choose answers from their player UI, so Arena does not need physical answer pads |
| Dungeon Teleport | Portal to that level's specific dungeon; only players with that Tower level unlocked can enter |
| Spawn & Level Teleport | Player spawn area plus optional return portal to the Lobby Base; direct level travel is optional and must reuse the same unlock checks |
| Community | Social/economy area for that level. It reserves `HousesArea` and `GroupStagesArea`, but actual house models and Group stage models only appear when a player buys/rents/adds a house or creates/adds a Group stage |

Each Tower level has one matching dungeon. Example: Tower Level 1 sends to Dungeon Level 1, Tower Level 2 sends to Dungeon Level 2, and Tower Level 3 sends to Dungeon Level 3.
Each up-level test has its own matching test server/place. Example: the Level 1 -> Level 2 test sends one player to Up-Level Test 1, while the Level 2 -> Level 3 test sends one player to Up-Level Test 2.

#### Tower Level 1 Workspace Folder Plan
Tower Level 1 should follow the current Studio organization below. These are starter folders and reserved spaces, not a list of every object that must already exist.

```text
Workspace
├─ SharedMapAssets
└─ TowerLevel1
   ├─ Arena
   │  ├─ ArenaStructure
   │  ├─ Inside
   │  └─ Outerpart
   ├─ DungeonTeleport
   ├─ Community
   │  ├─ HousesArea
   │  └─ GroupStagesArea
   ├─ LevelStructure&GameplayBoundaries
   ├─ LevelDecorations
   └─ SpawnAndLevelTeleport
      ├─ ReturnToLobby
      └─ Spawn
```

Do not add `SpawnSafeZone` to Tower Level 1. There is no combat battle in the spawn area, so the spawn only needs clear space, readable direction, and collision-safe placement.

Do not add `AnswerPad_A`, `AnswerPad_B`, `AnswerPad_C`, or `AnswerPad_D` to Arena. The player answers through UI buttons. The physical Arena still needs readable space, a public question screen/projection, join/exit flow, and spectator readability.

`HousesArea` and `GroupStagesArea` are reserved areas. They should show where houses and Group stages can be placed, but the actual house or stage objects should only exist after a player adds, buys, rents, or creates them.

Owned or rented houses also act as level-specific Lesson Mode access points. A house in Tower Level 1 can launch Level 1 lessons and milestone tests, a house in Tower Level 2 can launch Level 2 lessons and milestone tests, and so on. The Play-menu Lesson Mode option must use the same server-side house ownership/rental check before showing or launching a level's lessons.

### 3.6 Arena Visibility Rules
- Each Tower level has one main Arena area, not many hidden player-made arena stages.
- Arena activity visuals are visible by default to everyone in that Tower level server.
- Arena does not require a player to join or click spectate before they can see the activity.
- Arena questions use a very large projection/display, so players elsewhere on the level can see what question is active.
- Arena answer choices are selected through the player's UI, not by stepping on physical answer pads.
- Seeing the Arena activity does not automatically make the player a participant; it only means the physical activity and projected question are public inside that level server.

### 3.7 Arena Session Rules
- Only players who have unlocked that Tower level can join that level's Arena.
- The Arena starts when at least 1 eligible player joins and stops only when active players reach 0.
- A solo player can practice questions, but solo answers give no session score and no XP.
- Local session score can begin when at least 2 active players are in the Arena, but saved XP/coin rewards require a public Arena room with at least 4 active eligible players.
- If the Arena began as solo practice, the second active player starts a fresh scored session at the next intermission; if they join during intermission, that same intermission becomes the scored-session start.
- The Arena runs forever until everyone leaves.
- Players cannot die inside Arena; wrong answers give no points and do not eliminate the player.
- Current prototype scoring: first correct answer for a question scores 1 local session point. Final score, XP, and coin values are tracked in [notes.md](notes.md).
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
- During an active Arena question, players answer through UI buttons. The map should support visibility and movement, not physical answer pad gameplay.
- Arena has an exit button. Leaving removes the player from active, queued, or spectator state.
- If a player leaves/disconnects, the server removes that player from the Arena session.

### 3.9 Playground & Group Activity Rules
- The Playground is part of the home server and sits next to the lobby.
- The first Playground activity is Group mode.
- Normal players cannot create Playground activities.
- Normal players can create Group stages in Tower Community zones for levels they have unlocked.
- Starter Community maps should reserve `GroupStagesArea`, but should not pre-place finished Group stage models. Stage models appear only after a player creates/adds one.
- Normal players can choose which unlocked Tower level receives their Community stage, but their stage is always public.
- Battlepass players can create Group stages in unlocked Tower Community zones or in the Playground.
- Battlepass players can set Group stages to public or invite-only.
- Invite-only controls who can join the activity, not who can spectate it.
- All Group activities are spectatable.
- Group activity visuals are opt-in for spectators: a client can know the activity exists, but the stage/chairs/problem display should not appear for that player until they click spectate.
- This opt-in visual rule is specific to Group activities and does not apply to Arena.
- Hosts can provide a custom stage name when creating a Group stage.
- Group stage question content is organized by question level, and each level has many topic choices. The stage info should show the selected pair as `Level X - Topic`; exact question-bank decisions are tracked in [notes.md](notes.md).
- Until a live question is active, the stage problem display can use the same two-line stage info text as its placeholder.
- Nearby Group stage info does not auto-join or auto-spectate the player; it is only an information prompt.

### 3.10 Competitive Reward Rules
- Saved XP/coin rewards use this priority order after 1v1 cross-server matchmaking exists: Arena public 4+ active players pays the highest competitive reward, random cross-server 1v1 Quickmatch pays less than Arena but more than Group, and eligible Group rooms pay 20% of Arena rewards.
- Private competitive contexts never give saved XP or coins. This includes private/VIP servers, invite-only Group rooms, Battlepass-created custom 1v1 matches, and any other custom room where players choose opponents or attendees.
- Lesson Mode is a separate personal learning mode, not a competitive mode. It uses a personal popup/slide UI with explanations, examples, progress, and milestone tests. The free intro lesson/question is available from the Play menu without a house. Level-specific lessons are entered from the Play menu or from a player's house, and the server only allows those lessons for Tower levels where the player owns or rents an active house. Milestone rewards are small XP/coins plus lesson badges, allowed only as server-authorized, once-per-lesson or once-per-milestone rewards, not repeatable farming rewards.
- Arena can still support solo practice and smaller local-score sessions, but saved Arena rewards require a public room with at least four active eligible players.
- Group uses the Arena-style public-room reward rule, but with three reward conditions: public room, at least four active eligible players, and match-quality validation such as enough answered questions or duration. Eligible Group rewards pay 20% of Arena rewards.
- 1v1 saved rewards only come from random Quickmatch after the cross-server matchmaking version exists. A player-selected opponent is too easy to farm, even when the match happens in a normal public Roblox server.
- Roblox public servers should not be treated as secure matchmaking by themselves because players can choose servers, follow friends, and coordinate with alts. The first build can prototype random 1v1 within the current Roblox server if the server chooses the opponent from a queue, but that same-server prototype gives local score only. The reward-eligible version uses cross-server matchmaking: live servers add queued players to a shared MemoryStoreService queue, a server process forms valid pairs, then TeleportService sends the matched players to a reserved 1v1 match server.
- Competitive reward code must run on the server. The client can request to join, answer, or create a room, but the server decides whether the match is public, private, random, custom, reward-eligible, and how much saved XP/coins to grant.
- The final numeric reward amounts, cross-server random 1v1 multiplier, daily caps, minimum duration, minimum answered-question count, AFK checks, and repeat-opponent cooldowns are still tuning decisions tracked in [notes.md](notes.md).

### 3.11 Lesson Mode Rules
- Lesson Mode replaces the earlier dedicated Practice Mode idea. Instead of only drilling questions, it teaches knowledge first through short slide-style explanations, examples, and then practice tests as milestones.
- Confirmed first implementation: keep Lesson Mode as a personal popup/slide UI overlay inside the current server/place. The server sends the lesson definition, validates milestone test answers, and grants any one-time rewards. A separate Roblox place/server is not required for normal slide lessons.
- Use a separate Lesson place/server only if lessons become long immersive rooms, cinematic classrooms, multiplayer classes, or high-stakes exams that need isolated performance, camera, or world state. For the current house-gated lesson concept, a personal popup/UI is simpler and safer.
- Lesson content should be organized into one free intro lesson/question plus Tower-level/topic lessons. A lesson can contain multiple slides, examples, checkpoint questions, and a final milestone test.
- Milestone rewards are small XP/coins plus lesson badges. They must be server-authorized and one-time per player, access type, Tower level, lesson, milestone, and content version. Repeating lessons can give learning feedback, but should not re-award the same milestone reward.
- Lesson access has two confirmed tiers: the free intro lesson/question is available to everyone through the Play menu, while level-specific lessons are gated by active house ownership/rental in that same Tower level. The client may ask to open a lesson, but the server decides whether the player can see the intro or house-gated lesson list.
- Lesson Mode should help players prepare for Arena, 1v1, Group, Dungeon, and up-level tests, but should not reveal exact live competitive questions in a way that damages the game. Lesson questions can use the same topic/difficulty style while keeping live scored banks protected.
- Exact lesson reward amounts, passing score, retry cooldown, badge list, and whether lessons consume the same question bank as competitive modes are open decisions tracked in [notes.md](notes.md).

#### Lesson Content Placement
Use this content split when the project moves into real Rojo modules:

```text
src/shared/LessonCatalog.luau
  FreeIntro
  TowerLevel1
  TowerLevel2
  TowerLevel3

src/shared/LessonSlides/
  FreeIntro/*.luau
  TowerLevel1/<Topic>/*.luau
  TowerLevel2/<Topic>/*.luau
  TowerLevel3/<Topic>/*.luau

src/server/Content/LessonMilestones/
  FreeIntro/*.luau
  TowerLevel1/<Topic>/*.luau
  TowerLevel2/<Topic>/*.luau
  TowerLevel3/<Topic>/*.luau
```

Put free intro lesson slides/questions under `FreeIntro`. These are visible from the Play menu for every player, even before they own a house. Put buy-house/house-gated lesson questions under the matching `TowerLevelX/<Topic>` folder. Those lessons should appear in the Play menu only after the server confirms an active house in that level, and should also be launchable from that house.

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
- **HUD Elements:** player health bar, boss health bar, currency, timer, minimap, sprint stamina meter, and a lobby Progression UI showing both Tower Level and XP progress toward the next up-level test. Stamina reward display can be added later after sprint milestone numbers are final.
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
- [ ] Tower Area launch pad validator and controlled launch handler
- [ ] Tower level server router
- [ ] Sprint stamina progression and runtime validator
- [ ] Tower Arena shared visibility/projection broadcaster
- [ ] Tower Arena gate prompt, join queue, spectator state, intermission loop, and exit handler
- [ ] Tower Arena solo-practice rule, fresh scored-session reset, answer scoring, and top-5 session leaderboard
- [ ] Competitive reward validator for Arena, random 1v1 Quickmatch, Group, private/VIP, invite-only, and custom no-reward contexts
- [ ] 1v1 same-server no-reward Quickmatch prototype, cross-server reward-eligible Quickmatch queue, and Battlepass-only custom 1v1 room creator
- [ ] Future cross-server matchmaking queue using MemoryStoreService and TeleportService reserved match servers
- [ ] Lesson Mode access validator that always allows the free intro lesson/question, and allows level lessons from the Play menu or a player's house only when the player owns or rents an active house in that same Tower level
- [ ] Lesson Mode slide, checkpoint question, milestone test, one-time milestone reward, and content-version progress tracker
- [ ] Lesson content catalog split into free intro content and house-gated Tower-level/topic content
- [ ] Dungeon daily question reset, Battlepass no-cooldown rule, post-clear Battlepass finisher visibility, and finisher-only chat access
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
- [ ] Controlled launch camera and movement presentation
- [ ] Sprint stamina toggle input, GUI button highlight, meter, drain, and recharge presentation
- [ ] Progression UI that shows both Tower Level and XP progress toward the next up-level test
- [ ] Dungeon daily progress display, Battlepass finisher visibility/chat state, and clear messaging for cooldown or no-cooldown status
- [ ] Visual effects (particles, tweens)

### 7.3 Shared (ModuleScript)
- [ ] Shared constants / config
- [ ] Utility functions
- [ ] Remotes manifest
- [ ] Tower XP threshold config and level-to-destination mapping that can extend past Level 3 later
- [ ] Progression display config shared by the lobby UI and server-side progress rules
- [ ] Sprint stamina config for XP milestones after the exact milestone thresholds and stamina values are confirmed

### 7.4 Remote Events & Functions
| Name | Type (Event/Function) | Fired By | Handled By | Purpose |
|---|---|---|---|---|
| TowerAccessDenied | Event | Server | Client | Tell the player a Tower level is locked and how much XP is required |
| PlayTeleportFailed | Event | Server | Client | Tell the player a Play-menu teleport could not start, such as when a place ID is still missing |
| LobbyTowerGateStatesRequested | Event | Client | Server | Ask the server for fresh Tower level button states when the Play menu opens |
| LobbyTowerGateStatesUpdated | Event | Server | Client | Tell the player which Tower gates, Tower Play choices, and house-gated Lesson Mode choices are unlocked, locked, or ready for an up-level test |
| TowerLevelPlayRequested | Event | Client | Server | Request direct entry to a chosen Tower level from the lobby Play button |
| QuickmatchPlayRequested | Event | Client | Server | Request the Play-menu Quickmatch route |
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
| CompetitiveRewardResult | Event | Server | Client | Tell a player whether a competitive action paid saved XP/coins, gave local score only, or was blocked by practice/private/custom/repeat-opponent rules |
| OneVOneQuickmatchRequested | Event | Client | Server | Request random 1v1 matchmaking; same-server prototype gives local score only, while cross-server reserved match servers can become reward-eligible |
| OneVOneCustomCreateRequested | Event | Client | Server | Request a Battlepass-only custom 1v1 room; custom rooms give no saved XP or coins |
| OneVOneCustomJoinRequested | Event | Client | Server | Request to join a custom 1v1 room; custom rooms give no saved XP or coins |
| LessonModeRequested | Event | Client | Server | Request a personal Lesson Mode session from the Play menu or house; the server allows free intro lessons and validates unlocked level plus active house ownership/rental for house-gated level lessons |
| LessonAccessDenied | Event | Server | Client | Tell a player they need an active house in that Tower level before opening that level's lessons |
| LessonSlideOpened | Event | Server | Client | Send one player the approved lesson slide content for the selected Tower level/topic |
| LessonMilestoneSubmitted | Event | Client | Server | Submit a Lesson Mode milestone test answer or result for server validation |
| LessonMilestoneResult | Event | Server | Client | Tell a player whether the milestone test passed and whether a one-time lesson reward was granted |
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
| DungeonDailyStateChanged | Event | Server | Client | Sync the current UTC daily Dungeon version, per-level completion/reward state, per-question reward/solved/wrong-coin-removal state, cooldown state, and Battlepass no-cooldown status |
| DungeonCorrectAnswerRevealed | Event | Server | Client | Clearly tell the player they picked a wrong-answer Dungeon coin, show the correct answer, and explain that only the correct coin/path will remain on the next attempt |
| DungeonFinisherLayerChanged | Event | Server | Client | Tell a Battlepass daily finisher which other same-level Battlepass finishers should be visible in the whole Dungeon |
| DungeonFinisherChatChanged | Event | Server | Client | Enable or disable the finisher-only Dungeon chat channel for a Battlepass daily finisher |
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
- **Saved Player Data:** coins, total XP, highest unlocked Tower level, passed up-level tests, Battlepass ownership/entitlement, per-level daily Dungeon completion/reward claim state, per-question daily Dungeon reward claim/wrong-answer-removal state, recent rewarded 1v1 opponents or daily competitive reward anti-farm counters if needed, owned/rented houses with Tower level and active ownership/rental state for Lesson Mode access, free intro and per-level lesson milestone completion, lesson badge ownership, and one-time reward claim state by lesson content version, settings, inventory
- **Session Data (not saved):** current mode run, active Arena projection state, active Arena roster, queued Arena spectators, Arena intermission countdown, Arena per-session top-5 leaderboard, current no-reward same-server 1v1 quickmatch queue state, future cross-server 1v1 reservation state, active no-reward custom 1v1 rooms, current Lesson Mode slide/milestone session state, dungeon run state, active daily Dungeon version, active Dungeon finisher layer visibility/chat state, active Community group stages, active Playground group stages, per-player group spectate opt-ins, portal touch debounce
- **Data Migration Plan:** Deferred; track the live schema migration decision in [notes.md](notes.md).

---

## 9. Monetization Details
| Product | Type | Robux Price | What It Gives |
|---|---|---|---|
| Dungeon Cooldown Skip | Developer Product | Deferred | Skip only the current failed-run cooldown once for a normal player |
| Battlepass | Game Pass | Deferred | Create no-reward custom 1v1 rooms, create Group stages in the Playground, make Group stages invite-only, remove Dungeon cooldown, and unlock post-clear Dungeon finisher visibility/chat with other Battlepass daily finishers |

- **VIP Server support:** Deferred; if VIP/private servers are supported, they must not grant saved competitive XP or coins.
- **Free-to-play friendly:** Yes — normal players can still complete Dungeon; paid perks reduce retry friction and add post-clear social visibility/chat.

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

Confirmed multi-place code organization:
- Use one VS Code/Rojo project directory for the first build.
- Keep shared rules in `src/shared`, general server startup in `src/server`, general client code in `src/client`, and place-specific starter modules in `src/places`.
- Sync `src/places` into `ServerScriptService > PlaceScripts` so each real Roblox place can start the module that matches its role.
- Open and test one Roblox place at a time in Studio, while still editing the code from the same VS Code directory.

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
- Keep `notes.md` as the temporary open-work queue for open questions,
  future-development notes, deferred decisions, and ideas to revisit.
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

### 13.9 Workflow Notes File

Moved to [notes.md](notes.md).

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
- [ ] Play button opens the first-choice menu with Tower, Quickmatch, and Lesson Mode
- [ ] Play button Tower choice opens Level 1, Level 2, and Level 3 buttons
- [ ] Quickmatch rejects missing place IDs clearly until the real destination is configured
- [ ] Lesson Mode from the Play menu always shows the free intro lesson/question and shows/launches house-gated Tower lessons only where the player owns or rents an active house
- [ ] Play button direct level selection rejects locked levels and allows unlocked levels using the same checks as Tower gates
- [ ] Tower gate and Play button routing reject invalid level numbers, missing place IDs, and destination place IDs outside the server allowlist
- [ ] First build exposes only Level 1, Level 2, and Level 3 Tower gates while keeping the naming/config format ready for Level 4+
- [ ] XP stops increasing when the player reaches the next up-level test requirement
- [ ] Up-level tests launch in a separate solo timed boss-fight server
- [ ] Passing an up-level test unlocks the next Tower level and resumes XP gain
- [ ] Each Tower level dungeon portal only accepts players who unlocked that level
- [ ] Any direct level teleport portals only send players to unlocked Tower levels and use the same checks as Tower gates and the Play button
- [ ] Community area allows valid house buy/rent actions only for players with that Tower level unlocked
- [ ] House Lesson Mode access launches that house's Tower level lessons and milestone tests
- [ ] Lesson Mode access rejects no-house, wrong-level-house, locked-level, and spoofed client requests
- [ ] Lesson milestone rewards are one-time per player/content version and cannot be farmed by repeating slides or tests
- [ ] Free intro lesson/question is available to every player without house ownership and still uses one-time reward tracking
- [ ] Arena activity and the large question projection are visible to everyone in the Tower level server without clicking spectate
- [ ] Arena gate shows `Join the Arena?` and only unlocked players can accept
- [ ] Arena starts with 1 player as practice and gives no score/XP while solo
- [ ] When the second active player joins, Arena starts a fresh scored session at intermission
- [ ] Players who join during an active Arena question spectate and queue until the next intermission
- [ ] Arena intermission lasts 10 seconds and shows a clear countdown
- [ ] Arena exit button removes active, queued, and spectator players correctly
- [ ] Arena ends and resets the session leaderboard when active players reach 0
- [ ] Arena leaderboard shows only the top 5 scores from the current session and does not persist
- [ ] Same-server 1v1 Quickmatch prototype gives local score only and no saved XP/coins
- [ ] Cross-server 1v1 Quickmatch is required before saved 1v1 rewards are enabled
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

## 16. Notes File

Moved to [notes.md](notes.md).

---

## 17. To Do List

Moved to [To-Do.md](To-Do.md), starting with the daily coding and Rojo routine.

---

## 18. Project Management & Collaboration

### 18.1 Roblox Studio Code Map
This project is connected to Roblox Studio through Rojo. Files in the Rojo project folder sync into Studio, so organizing files on disk also makes Explorer easier to understand.

Current synced code:

```text
ReplicatedStorage
  TowerConfig          <- shared ModuleScript
  PlaceConfig          <- shared ModuleScript that identifies the current place role

ServerScriptService
  Main                 <- server Script
  PlaceBootstrap       <- server ModuleScript that starts place-specific code
  PlaceScripts
    lobby
      LobbyPlace
    tower-level
      TowerLevelPlace
    dungeon
      DungeonPlace
    up-level-test
      UpLevelTestPlace

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

Important GUI scripting rule:

- Always apply the Studio-owned visual UI workflow for GUI, HUD, menu, button,
  label, image, bar, or screen features unless the owner explicitly asks for a
  different temporary approach.
- Codex should give the owner an exact `StarterGui` Explorer tree with object
  names and object types when a polished GUI should be built in Studio.
- In the current partially managed Rojo setup, `StarterGui` screens are visual UI
  objects made in Roblox Studio. Scripts placed directly under those GUI objects
  in Studio, such as a `LocalScript` under a Play button, are not automatically
  connected to VS Code unless `StarterGui` is added to `default.project.json`.
- For the first build, keep GUI behavior in VS Code under
  `src/client/Controllers`, then have the client controller find the real GUI in
  `Players.LocalPlayer.PlayerGui` with `WaitForChild`.
- Codex may create a temporary code-made GUI first when a quick prototype helps
  prove the feature, but the final path should connect VS Code behavior to the
  owner-built Studio GUI.
- Example: the Tower/Play button behavior should become a client controller such
  as `src/client/Controllers/PlayButtonController.client.luau`, instead of a
  Studio-only script nested inside `StarterGui > PlayButton`.
- Do not place scripts under visual helper objects like `UICorner`. `UICorner`
  only changes how a UI object looks; it is not a good home for gameplay or menu
  behavior.
- If the team later wants UI screens themselves to sync from VS Code, add a
  planned `StarterGui` mapping to `default.project.json` and move the screen
  hierarchy into a matching source folder. Until that decision is made, treat
  `StarterGui` as Studio-owned visual layout and `src/client` as VS Code-owned
  client behavior.

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
src/shared/PlaceConfig.luau
src/shared/ProgressionConfig.luau
src/server/Main.server.luau
src/server/PlaceBootstrap.luau
src/client/Main.client.luau
src/client/Controllers/ProgressionUIController.client.luau
src/places/lobby/LobbyPlace.luau
src/places/tower-level/TowerLevelPlace.luau
src/places/dungeon/DungeonPlace.luau
src/places/up-level-test/UpLevelTestPlace.luau
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
