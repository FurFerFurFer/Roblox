# 17. To Do List

This file is the builder guide for turning the Brain Brawl plan into an actual Roblox experience. It is the standalone version of topic 17 from `bro.md`, and it should be updated whenever the design plan changes physical spaces, gameplay objects, Studio organization, testing, or handoff work.

## 17.1 Builder Mission
- Build the physical spaces players understand immediately: lobby, Playground, the visual Tower Area, Tower level destinations, Arena, Dungeon routes, Community zones, Group stages, and up-level boss test arenas.
- Keep gameplay readable before making it pretty. Players should always know where to go, what mode they are entering, and what is dangerous, locked, public, private, or spectatable.
- Use simple blockouts first, then add detail after movement, scale, camera visibility, UI prompts, and teleport flow all work.
- Treat every map object as part of gameplay communication: color, lighting, signs, portals, paths, walls, chairs, stages, screens, and barriers should all explain rules without needing long text.

## 17.2 What AI Can Help With
- Draft design plans, build checklists, naming conventions, module plans, data schemas, UI copy, question bank formats, and Luau implementation drafts.
- Review map plans for player flow, exploit risks, unclear rules, scope problems, accessibility, and performance concerns.
- Generate reference prompts, mood boards, placeholder text, asset lists, layout diagrams, and construction steps.
- Help write scripts that connect to builder-made objects after the builder creates and names those objects in Studio.
- Help document handoff requirements so scripters know which parts, folders, attributes, tags, and RemoteEvents to expect.

## 17.3 What AI Cannot Do Directly
- Build the final map inside Roblox Studio unless a future Studio/MCP connection is added and explicitly approved.
- Visually inspect unpublished Studio-only work unless screenshots, files, or exported models are provided.
- Publish places, configure universe permissions, upload thumbnails/icons/audio, or set final monetization IDs.
- Make final subjective art decisions for the owner; it can recommend, but the owner/builder must approve the look.
- Verify exact mobile feel, controller feel, network behavior, DataStore behavior, or live monetization behavior without real playtests.
- Replace a human builder's scale judgment for jumps, sightlines, portal spacing, collision, mood, and readability.

## 17.4 Builder Workflow
1. Read `bro.md` and `To-Do.md` before starting a new area.
2. Choose one build target, such as Lobby Base blockout, Tower Area blockout, Tower Level 1 Arena, Dungeon Level 1, or Up-Level Test 1.
3. Write a short goal for the build: what the player should do there, what they should see first, and what system scripts need from the map.
4. Block out the space with simple parts, labels, and placeholder colors.
5. Playtest movement scale before adding decoration.
6. Add named anchor parts for scripts: spawn points, portal triggers, arena gates, question displays, answer pads, exit buttons, stage anchors, chair anchors, and boss arena markers.
7. Add collision boundaries, anti-fall protection, invisible walls, kill planes, and reset zones where needed.
8. Add lighting, materials, signs, props, effects, and sound only after the gameplay path is clear.
9. Test in Studio solo, then test with multiple players.
10. Record unresolved builder issues in `To-Do.md` before moving to the next area.

## 17.5 Studio Organization Rules
- Use clear folders in Workspace for each area: `LobbyBase`, `Lobby`, `Playground`, `TowerArea`, `TowerLevel1`, `TowerLevel2`, `TowerLevel3`, `Dungeons`, `UpLevelTests`, and `SharedMapAssets`.
- Treat `TowerArea` as the home-server visual landmark and teleport-gate area only. Actual Tower level gameplay belongs in the separate Tower level destinations.
- Use predictable part names so scripts can find them later, such as `ArenaGateTrigger`, `ArenaExitTrigger`, `LobbyTowerGate_Level2`, `LobbyTowerElevatorStop_Level2`, `QuestionScreen`, `AnswerPad_A`, `GroupStageAnchor`, and `DungeonResetZone`.
- Add Roblox CollectionService tags later for script-driven objects that appear many times, such as portals, answer pads, kill zones, stage seats, and spectate triggers.
- Keep decorative models separate from gameplay-critical collision and trigger parts.
- Do not hide important trigger parts inside decorative models without naming them clearly.
- Prefer anchored, simple collision for early prototypes.
- Use attributes for level numbers, mode names, non-authoritative destination keys, unlock requirements, or stage capacity when a script needs per-object configuration. Tower gates should expose only the level they request; the server validates the real destination place ID.

## 17.6 Map Building Checklist
- [ ] Lobby has a first spawn point that faces the main mode portals.
- [ ] Lobby Base, Lobby, and Tower Area read as separate spaces.
- [ ] Lobby portals are visually distinct for Arena, 1v1, and Dungeon.
- [ ] The visible Tower Area reads as a progression landmark and teleport-gate structure, not a normal game mode portal or actual Tower level gameplay space.
- [ ] Play button is available from Lobby Base and clearly supports direct Tower level selection.
- [ ] Playground is visibly next to the lobby and has room for Group stages.
- [ ] Tower Area has a clear entrance, traversal elevator, and climb route.
- [ ] Tower gates climb upward so the tower communicates progression through height.
- [ ] Tower gates are named clearly, such as `LobbyTowerGate_Level1`, `LobbyTowerGate_Level2`, and `LobbyTowerGate_Level3`.
- [ ] First build stops at Level 3 with no active Level 4+ gates, but the structure is easy to extend later.
- [ ] Tower floors/areas can be explored even when higher gates are locked.
- [ ] Locked Tower gates are visually locked, physically blocked, and still checked by the server when touched.
- [ ] Tower Level 1 has Arena, Dungeon Teleport, Spawn & Level Teleport, and Community areas.
- [ ] Tower Level 2 repeats the same four-area structure with a stronger visual theme.
- [ ] Tower Level 3 repeats the same four-area structure with the highest-tier visual theme.
- [ ] Each Tower level has a large Arena with a question projection visible from the wider level server.
- [ ] Arena entrance has a gate/prompt area and a clear exit route.
- [ ] Arena has standing/player zones that face the projected question display.
- [ ] Arena spectators can understand the activity without joining.
- [ ] Community zones have black/open space reserved for player-created Group stages.
- [ ] Group stages have enough space for stage, display, chairs, host position, join/spectate prompt, and nearby info trigger.
- [ ] Dungeons have about 50 question checkpoints or a planned path system that can scale to 50.
- [ ] Dungeon wrong-answer paths can reliably reset/kill the player without softlocking them.
- [ ] Dungeon correct paths can place collectible coins clearly without encouraging accidental wrong turns.
- [ ] Dungeon layout prevents players from easily watching or following other players.
- [ ] Up-level test arenas have boss placement, player placement, question display, answer area, timer visibility, and health bar sightlines.
- [ ] All maps include invisible boundaries, fall protection, and reset handling.
- [ ] All important routes are readable on mobile screens and from Roblox's default camera distance.

## 17.7 Gameplay Object Checklist
- [ ] Spawn locations are placed and named.
- [ ] Portal trigger parts are placed and named.
- [ ] Portal destination labels are visible.
- [ ] Locked portal visuals are different from available portal visuals.
- [ ] Arena gate trigger is placed.
- [ ] Arena exit trigger or button is placed.
- [ ] Arena question screen/projection part is placed.
- [ ] Arena answer selection zones are placed.
- [ ] Dungeon checkpoint/question zones are placed.
- [ ] Dungeon answer paths or answer pads are placed.
- [ ] Dungeon reset zones and kill zones are placed.
- [ ] Coin pickup locations are placed.
- [ ] Group stage anchors are placed in Community and Playground spaces.
- [ ] Group stage chair anchors are planned.
- [ ] Group stage problem display anchor is planned.
- [ ] Nearby info trigger range is planned around each Group stage.
- [ ] Up-level boss anchor, player anchor, answer zones, and camera-friendly display positions are placed.

## 17.8 Visual Design Checklist
- [ ] Choose a clear visual identity for Brain Brawl before final art polish.
- [ ] Give each mode a recognizable color/material language.
- [ ] Give each Tower level a stronger or more advanced theme than the previous level.
- [ ] Build the lobby Tower efficiently with reusable floor modules and heavier decoration on milestone floors.
- [ ] Make the upper Tower floors feel like elite-genius status through lighting, materials, signage, silhouettes, and status-display placeholders.
- [ ] Do not build lobby Tower leaderboard displays yet; reserve clean spaces where they could be designed later.
- [ ] Use signs, arrows, lighting, and landmark shapes to guide players without too much text.
- [ ] Keep answer areas visually simple so trivia choices stay readable.
- [ ] Avoid clutter around UI prompts, question screens, and answer pads.
- [ ] Use contrast for interactable objects, locked objects, danger, and rewards.
- [ ] Keep the Dungeon tense but readable; do not hide correct/incorrect path choices with decoration.
- [ ] Keep the Arena open enough for spectators to understand what is happening.
- [ ] Make the Playground feel social and flexible, with room for player-created activity.

## 17.9 Performance Checklist
- [ ] Use low-detail blockouts until the gameplay loop is proven.
- [ ] Avoid excessive unanchored parts.
- [ ] Merge or simplify decorative meshes where possible.
- [ ] Keep particle effects limited and purposeful.
- [ ] Avoid too many transparent parts in one view.
- [ ] Check memory and frame rate on a lower-end device before launch.
- [ ] Use StreamingEnabled testing if the final map becomes large.
- [ ] Keep physics-heavy decorations away from core gameplay.
- [ ] Avoid making every Tower floor uniquely heavy; use modular decoration so the lobby stays performant.
- [ ] Test how many active Group stages can exist before the area becomes crowded or slow.

## 17.10 Collaboration With Scripters
- [ ] Tell scripters the exact names and locations of all gameplay-critical parts.
- [ ] Do not rename scripted objects without telling the scripting side.
- [ ] Use placeholder parts first so scripts can be connected before final art is finished.
- [ ] Ask scripters before changing trigger size, collision, part hierarchy, or object names.
- [ ] Keep one simple test map for each system before building the final polished map.
- [ ] When a script needs an object, add a clear placeholder instead of waiting for final art.
- [ ] When an object is only decorative, keep it outside script folders or mark it clearly.

## 17.11 Exploit And Safety Review
- [ ] Players cannot touch portals they have not unlocked by jumping around barriers.
- [ ] Locked Tower gates cannot be entered from behind, above, below, or through wall clipping.
- [ ] Tower gate parts only request a level number; they do not decide the teleport destination without the server.
- [ ] Players cannot enter Arena, Dungeon, Group, or up-level test spaces through gaps.
- [ ] Players cannot stand behind question screens or answer pads to break the interaction.
- [ ] Players cannot skip Dungeon questions by jumping, clipping, wall-hopping, or falling to a lower route.
- [ ] Players cannot view another Dungeon player's correct route.
- [ ] Group stage placement cannot block important paths, spawns, portals, or exits.
- [ ] Invite-only Group stages still allow spectating but block joining correctly.
- [ ] Kill zones and reset zones cannot repeatedly trap a player.
- [ ] Spawn points do not place players inside collision, under the map, or facing away from the main route.

## 17.12 Testing Routine For Builders
- [ ] Walk the map slowly as a new player and check whether the next action is obvious.
- [ ] Sprint and jump around every boundary looking for escape routes.
- [ ] Test with default Roblox avatar sizes and several scaled avatars if allowed.
- [ ] Test camera readability on desktop and mobile.
- [ ] Test portal spacing with several players standing nearby.
- [ ] Test Tower gate access for Level 1, Level 2, and Level 3 profiles.
- [ ] Confirm that Level 4+ is not reachable in the first build.
- [ ] Test Play button level selection for Level 1, Level 2, and Level 3 profiles.
- [ ] Test that each locked Tower gate denies touch entry, remote-spoofed entry, Play button abuse, invalid level numbers, invalid destination IDs, and physical bypass attempts.
- [ ] Test Arena viewing from inside and outside the Arena.
- [ ] Test Dungeon paths for accidental wrong-answer triggers.
- [ ] Test Group stage placement with the maximum expected number of stages.
- [ ] Test all areas with Studio graphics lowered to catch readability problems.
- [ ] Save screenshots or short clips when asking AI or teammates for review.

## 17.13 Handoff Requirements
For each finished or semi-finished build area, provide:
- Area name and purpose.
- Screenshot or short walkthrough video.
- List of important folders and object names.
- List of trigger parts and what each one should do.
- List of signs/UI prompts needed.
- Known unfinished art or collision work.
- Known risks, confusing spots, or places where players got lost during testing.
- Any script requirements, such as attributes, tags, RemoteEvents, or teleport destination IDs.

## 17.14 Priority Order
1. Lobby blockout and mode portals.
2. Tower Area blockout with traversal elevator, climb route, Level 1-3 upward gates, and locked-gate visuals.
3. Tower Level 1 blockout with the four required areas.
4. Arena prototype space with question display, answer pads, gate, and exit.
5. Dungeon Level 1 prototype with a small number of question paths before scaling to 50.
6. Group stage prototype in Community, then Playground.
7. Up-Level Test 1 boss arena prototype.
8. Tower Level 2 and Tower Level 3 variations.
9. Full Dungeon content and polish.
10. Final visual pass, lighting, sound, signage, optimization, and launch screenshots.

## 17.15 Open Builder Questions
- What is the final mood and aesthetic for Brain Brawl?
- Should Tower levels feel like school grades, sci-fi floors, fantasy towers, city districts, or another theme?
- How should future Tower status or leaderboard displays work, if added later?
- Should the Tower Area elevator be a real moving platform, a simple animated teleporter along the shaft, or a static visual with climb route only?
- How large should each Tower level feel: compact hub, medium social map, or large exploration space?
- Should dungeons be pure obby paths, themed rooms, quiz doors, or a mix?
- Should Group stages use one standard model, several purchasable skins, or host-customized decoration?
- What is the target device priority: mobile-first, desktop-first, or equal support?
