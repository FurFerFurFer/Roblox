# Roblox Game Project — Planning Format

## 1. Project Overview
- **Game Title:** Brain Brawl
- **Genre:** Quiz / Trivia + Obby hybrid
- **Target Audience:** General Roblox players, casual to competitive
- **Core Loop:** Answer trivia questions faster/smarter than other players to earn coins and climb scores across multiple game modes
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
| Select-answer trivia | Players pick from multiple choice answers; first correct answer scores a point (Arena, 1v1, Group) | High |
| Dungeon path-picking | Correct answer path = collect coin and advance; wrong path = lose coins + full dungeon reset | High |
| Dungeon reset | Kill the player on wrong answer, respawn at dungeon start, reset all coins in the dungeon | High |
| Anti-copy (Dungeon) | No chat, players invisible to each other so no one can follow the correct path | High |
| Dungeon cooldown | On dungeon fail, player must wait 5 minutes before retrying, or pay currency to skip the wait | Med |

### 3.2 Player Progression
- **XP / Leveling System:** TBD
- **Currency:** Coins — earned by scoring in trivia modes and collected physically in Dungeon mode
- **Unlockables:** TBD
- **Replayability Hooks:** Dungeon completion (high-stakes, one long run), competitive scoring in Arena/1v1/Group

### 3.3 Game Modes
| Mode | Description | Players |
|---|---|---|
| Arena | Free-for-all trivia; select-answer format; first correct answer scores a point | 3+ |
| 1v1 | Same as Arena but only two players dueling each other | 2 |
| Group | Free-for-all trivia like Arena; select-answer format | 3+ |
| Dungeon | Solo obby with ~50 questions; each question is a branching path; pick correct path to collect a coin and advance; wrong path = lose coins + full reset to dungeon start; players are invisible to each other, no chat; failed run = 5 min cooldown or pay to skip | Solo |

---

## 4. World & Level Design
- **Map Size:** (small / medium / large / procedural)
- **Number of Maps / Areas:**
- **Key Locations:**
  - [ ] Location 1 — purpose
  - [ ] Location 2 — purpose
- **Spawn & Respawn Logic:**
- **Lighting & Atmosphere:**

---

## 5. Characters & NPCs
| Name | Type (Player/NPC/Enemy/Boss) | Role | Behaviors |
|---|---|---|---|
|  |  |  |  |

---

## 6. UI / UX
- **HUD Elements:** (health bar, currency, timer, minimap)
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

### 7.2 Client-Side (LocalScript)
- [ ] Input handling
- [ ] UI controllers
- [ ] Camera behavior
- [ ] Visual effects (particles, tweens)

### 7.3 Shared (ModuleScript)
- [ ] Shared constants / config
- [ ] Utility functions
- [ ] Remotes manifest

### 7.4 Remote Events & Functions
| Name | Type (Event/Function) | Fired By | Handled By | Purpose |
|---|---|---|---|---|
|  |  |  |  |  |

---

## 8. Data & Persistence
- **DataStore Keys:**
- **Saved Player Data:** (coins, level, inventory, settings)
- **Session Data (not saved):**
- **Data Migration Plan:** (how to handle schema changes on live game)

---

## 9. Monetization Details
| Product | Type | Robux Price | What It Gives |
|---|---|---|---|
| Dungeon Cooldown Skip | Developer Product | TBD | Skip the 5-minute wait after a failed dungeon run |

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
- 
