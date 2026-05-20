--!nocheck
-- ============================================================
-- [ GAME MODE ROUTER ]
-- Sends the player into the correct mode: Arena, 1v1, Group, Dungeon,
-- or the solo timed up-level boss test.
-- Optional context can identify which Tower level/server started the mode.
-- ============================================================

local beginArenaActivity
local beginUpLevelBossFight

local function startGameMode(player, mode, context)
	context = context or {}

	if mode == "Arena" then
		if beginArenaActivity then
			return beginArenaActivity(player, context)
		end
		return false, "ArenaActivityNotReady"
	elseif mode == "1v1" then
		-- launch 1v1 duel trivia for 2 players
	elseif mode == "Group" then
		-- launch group free-for-all trivia, optionally from a Community stage
	elseif mode == "Dungeon" then
		-- launch solo dungeon obby mode
	elseif mode == "UpLevelTest" then
		if beginUpLevelBossFight then
			return beginUpLevelBossFight(player, context)
		end
		return false, "UpLevelBossFightNotReady"
	end
end


-- ============================================================
-- [ LOBBY AND TOWER CONFIG ]
-- Portal routes, Tower XP requirements, and level-specific places.
-- Replace placeId = 0 with the real Roblox place IDs.
-- ============================================================

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

local PLACE_IDS = {
	Arena       = 0,
	OneVOne    = 0,
	Group      = 0,
	Dungeon    = 0,
	TowerLevel1 = 0,
	TowerLevel2 = 0,
	TowerLevel3 = 0,
	DungeonLevel1 = 0,
	DungeonLevel2 = 0,
	DungeonLevel3 = 0,
	UpLevelTest1 = 0,
	UpLevelTest2 = 0,
}

local GAME_PASS_IDS = {
	Battlepass = 0,
}

local S1 = 0    -- Tower Level 1 starting XP requirement
local S2 = 100  -- XP needed to attempt the Level 1 -> Level 2 test
local S3 = 250  -- XP needed to attempt the Level 2 -> Level 3 test
local DEFAULT_UNLOCKED_TOWER_LEVEL = 1

local XP_REWARDS = {
	CorrectAnswer = 10,
	DungeonComplete = 100,
}

local TowerLevelAreas = {
	Arena = "Arena",
	DungeonTeleport = "DungeonTeleport",
	SpawnTeleport = "SpawnTeleport",
	Community = "Community",
}

local HomeServerAreas = {
	Lobby = "Lobby",
	Playground = "Playground",
}

local GROUP_STAGE_LOCATIONS = {
	Community = TowerLevelAreas.Community,
	Playground = HomeServerAreas.Playground,
}

local GROUP_STAGE_PRIVACY = {
	Public = "Public",
	InviteOnly = "InviteOnly",
}
local GROUP_STAGE_DEFAULT_SEAT_COUNT = 8
local GROUP_STAGE_INFO_RADIUS = 24
local GROUP_STAGE_INFO_CHECK_INTERVAL = 0.5
local GROUP_STAGE_NAME_MAX_LENGTH = 48
local GROUP_STAGE_TOPIC_MAX_LENGTH = 40
local DEFAULT_GROUP_STAGE_QUESTION_LEVEL = 1
local DEFAULT_GROUP_STAGE_QUESTION_TOPIC = "Mixed Trivia"

local ARENA_QUESTION_PROJECTION_SIZE = Vector3.new(96, 36, 1)
local ARENA_INTERMISSION_SECONDS = 10
local ARENA_QUESTION_SECONDS = 20
local ARENA_MIN_SCORED_PLAYERS = 2
local ARENA_LEADERBOARD_LIMIT = 5

local UP_LEVEL_TEST_ENTRY_SOURCE = "UpLevelTestEntry"

local COMMUNITY_HOUSE_ACTIONS = {
	Buy = "Buy",
	Rent = "Rent",
}

local communityGroupStages = {}
local playgroundGroupStages = {}
local activeGroupStages = {}
local groupStageSpectators = {}
local groupStageNearbyPlayers = {}
local groupStageInfoTrackerRunning = false

local GROUP_STAGE_CREATE_REMOTE = "GroupStageCreateRequested"
local GROUP_STAGE_JOIN_REMOTE = "GroupStageJoinRequested"
local GROUP_STAGE_PRIVACY_REMOTE = "GroupStagePrivacyRequested"
local GROUP_STAGE_SPECTATE_REMOTE = "GroupStageSpectateRequested"
local GROUP_STAGE_REMOTE_EVENTS = {
	GROUP_STAGE_CREATE_REMOTE,
	GROUP_STAGE_JOIN_REMOTE,
	GROUP_STAGE_PRIVACY_REMOTE,
	GROUP_STAGE_SPECTATE_REMOTE,
	"GroupActivityAvailable",
	"GroupActivityRemoved",
	"GroupStageCreated",
	"GroupStageAccessDenied",
	"GroupStageJoinAllowed",
	"GroupStageJoinDenied",
	"GroupStagePrivacyChanged",
	"GroupStageSpectateStarted",
	"GroupStageSpectateEnded",
	"GroupStageInfoShown",
	"GroupStageInfoHidden",
}
local groupStageCreateRemoteConnected = false
local groupStageJoinRemoteConnected = false
local groupStagePrivacyRemoteConnected = false
local groupStageSpectateRemoteConnected = false

local ARENA_JOIN_REQUEST_REMOTE = "ArenaJoinRequested"
local ARENA_ANSWER_REMOTE = "ArenaAnswerSelected"
local ARENA_EXIT_REMOTE = "ArenaExitRequested"
local ARENA_ACTIVITY_REMOTE_EVENTS = {
	"ArenaJoinPromptShown",
	ARENA_JOIN_REQUEST_REMOTE,
	"ArenaJoinDenied",
	"ArenaJoinQueued",
	"ArenaPlayerJoined",
	"ArenaSpectateStarted",
	"ArenaIntermissionStarted",
	"ArenaCountdownTick",
	"ArenaActivityStarted",
	"ArenaQuestionProjected",
	"ArenaQuestionResolved",
	ARENA_ANSWER_REMOTE,
	"ArenaAnswerResult",
	ARENA_EXIT_REMOTE,
	"ArenaPlayerLeft",
	"ArenaLeaderboardUpdated",
	"ArenaScoredSessionStarted",
	"ArenaActivityEnded",
}
local arenaJoinRemoteConnected = false
local arenaAnswerRemoteConnected = false
local arenaExitRemoteConnected = false

local createGroupStage
local joinGroupStage
local setGroupStagePrivacy
local setGroupStageSpectating
local requestArenaJoin
local submitArenaAnswer
local leaveArena
local promptArenaJoin
local handleArenaJoinRequested
local handleArenaAnswerSelected
local handleArenaExitRequested
local clearPlayerArenaPresence
local awardExperience
local notifyTowerAccessDenied
local notifyUpLevelTestReady

local LobbyPortalRoutes = {
	Arena = {
		kind = "GameMode",
		mode = "Arena",
		placeId = PLACE_IDS.Arena,
	},
	["1v1"] = {
		kind = "GameMode",
		mode = "1v1",
		placeId = PLACE_IDS.OneVOne,
	},
	Group = {
		kind = "PlaygroundGroup",
		mode = "Group",
	},
	Dungeon = {
		kind = "GameMode",
		mode = "Dungeon",
		placeId = PLACE_IDS.Dungeon,
	},
	Tower = {
		kind = "TowerCurrentLevel",
	},
}

local TowerLevelRequirements = {
	[1] = {
		requiredXP = S1,
		placeId = PLACE_IDS.TowerLevel1,
		dungeonPlaceId = PLACE_IDS.DungeonLevel1,
		upLevelTestPlaceId = PLACE_IDS.UpLevelTest1,
		nextLevel = 2,
		nextLevelRequiredXP = S2,
	},
	[2] = {
		requiredXP = S2,
		placeId = PLACE_IDS.TowerLevel2,
		dungeonPlaceId = PLACE_IDS.DungeonLevel2,
		upLevelTestPlaceId = PLACE_IDS.UpLevelTest2,
		nextLevel = 3,
		nextLevelRequiredXP = S3,
	},
	[3] = {
		requiredXP = S3,
		placeId = PLACE_IDS.TowerLevel3,
		dungeonPlaceId = PLACE_IDS.DungeonLevel3,
		upLevelTestPlaceId = 0,
		nextLevel = nil,
		nextLevelRequiredXP = nil,
	},
}


-- ============================================================
-- [ GET PLAYER EXPERIENCE ]
-- Reads the player's current saved/session XP.
-- ============================================================

local function getPlayerExperience(player)
	local attributeXP = player:GetAttribute("Experience")
	if type(attributeXP) == "number" then
		return attributeXP
	end

	local leaderstats = player:FindFirstChild("leaderstats")
	local experienceValue = leaderstats and leaderstats:FindFirstChild("Experience")
	if experienceValue and type(experienceValue.Value) == "number" then
		return experienceValue.Value
	end

	return 0
end


-- ============================================================
-- [ SET PLAYER EXPERIENCE ]
-- Updates player XP in attributes and leaderstats.
-- ============================================================

local function setPlayerExperience(player, amount)
	local newXP = math.max(0, math.floor(tonumber(amount) or 0))
	player:SetAttribute("Experience", newXP)

	local leaderstats = player:FindFirstChild("leaderstats")
	local experienceValue = leaderstats and leaderstats:FindFirstChild("Experience")
	if experienceValue then
		experienceValue.Value = newXP
	end

	return newXP
end


-- ============================================================
-- [ GET PLAYER UNLOCKED TOWER LEVEL ]
-- Reads the highest Tower level the player has unlocked by tests.
-- ============================================================

local function getPlayerUnlockedTowerLevel(player)
	local maxLevel = #TowerLevelRequirements
	local attributeLevel = player:GetAttribute("UnlockedTowerLevel")
	if type(attributeLevel) == "number" then
		return math.clamp(math.floor(attributeLevel), DEFAULT_UNLOCKED_TOWER_LEVEL, maxLevel)
	end

	local leaderstats = player:FindFirstChild("leaderstats")
	local towerLevelValue = leaderstats and leaderstats:FindFirstChild("TowerLevel")
	if towerLevelValue and type(towerLevelValue.Value) == "number" then
		return math.clamp(math.floor(towerLevelValue.Value), DEFAULT_UNLOCKED_TOWER_LEVEL, maxLevel)
	end

	return DEFAULT_UNLOCKED_TOWER_LEVEL
end


-- ============================================================
-- [ SET PLAYER UNLOCKED TOWER LEVEL ]
-- Saves the highest Tower level unlocked after passing tests.
-- ============================================================

local function setPlayerUnlockedTowerLevel(player, towerLevel)
	local maxLevel = #TowerLevelRequirements
	local requestedLevel = math.floor(tonumber(towerLevel) or DEFAULT_UNLOCKED_TOWER_LEVEL)
	local newLevel = math.clamp(requestedLevel, DEFAULT_UNLOCKED_TOWER_LEVEL, maxLevel)

	player:SetAttribute("UnlockedTowerLevel", newLevel)

	local leaderstats = player:FindFirstChild("leaderstats")
	local towerLevelValue = leaderstats and leaderstats:FindFirstChild("TowerLevel")
	if towerLevelValue then
		towerLevelValue.Value = newLevel
	end

	return newLevel
end


-- ============================================================
-- [ SETUP PLAYER PROGRESS VALUES ]
-- Creates the lobby-visible XP and Tower level stats when a player joins.
-- ============================================================

local function setupPlayerProgressValues(player, savedData)
	local data = savedData or {}

	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then
		leaderstats = Instance.new("Folder")
		leaderstats.Name = "leaderstats"
		leaderstats.Parent = player
	end

	local experienceValue = leaderstats:FindFirstChild("Experience")
	if not experienceValue then
		experienceValue = Instance.new("IntValue")
		experienceValue.Name = "Experience"
		experienceValue.Parent = leaderstats
	end

	local towerLevelValue = leaderstats:FindFirstChild("TowerLevel")
	if not towerLevelValue then
		towerLevelValue = Instance.new("IntValue")
		towerLevelValue.Name = "TowerLevel"
		towerLevelValue.Parent = leaderstats
	end

	setPlayerUnlockedTowerLevel(player, data.UnlockedTowerLevel or DEFAULT_UNLOCKED_TOWER_LEVEL)
	return setPlayerExperience(player, data.Experience or 0)
end


-- ============================================================
-- [ GET HIGHEST UNLOCKED TOWER LEVEL ]
-- Returns the highest Tower level unlocked by completed tests.
-- ============================================================

local function getHighestUnlockedTowerLevel(player)
	return getPlayerUnlockedTowerLevel(player)
end


-- ============================================================
-- [ CAN ENTER TOWER LEVEL ]
-- Checks whether a Tower level is unlocked and XP-qualified.
-- ============================================================

local function canEnterTowerLevel(player, towerLevel)
	local config = TowerLevelRequirements[towerLevel]
	local currentXP = getPlayerExperience(player)
	local unlockedLevel = getPlayerUnlockedTowerLevel(player)

	if not config then
		return false, "UnknownLevel", 0, currentXP, unlockedLevel
	end

	if currentXP < config.requiredXP then
		return false, "NotEnoughXP", config.requiredXP, currentXP, unlockedLevel
	end

	if towerLevel > unlockedLevel then
		return false, "UpLevelTestRequired", config.requiredXP, currentXP, unlockedLevel
	end

	return true, "Unlocked", config.requiredXP, currentXP, unlockedLevel
end


-- ============================================================
-- [ FIRE PLAYER REMOTE EVENT ]
-- Sends a small payload to a client remote if that remote exists.
-- ============================================================

local function getRemotesFolder(createIfMissing)
	local remotes = ReplicatedStorage:FindFirstChild("Remotes")
	if not remotes and createIfMissing then
		remotes = Instance.new("Folder")
		remotes.Name = "Remotes"
		remotes.Parent = ReplicatedStorage
	end
	return remotes
end

local function getRemoteEvent(eventName, createIfMissing)
	local remotes = getRemotesFolder(createIfMissing)
	if not remotes then
		return nil
	end

	local event = remotes:FindFirstChild(eventName)
	if event and not event:IsA("RemoteEvent") then
		warn(("Remotes.%s exists but is not a RemoteEvent"):format(eventName))
		return nil
	end

	if not event and createIfMissing then
		event = Instance.new("RemoteEvent")
		event.Name = eventName
		event.Parent = remotes
	end

	return event
end

local function firePlayerRemoteEvent(player, eventName, payload)
	local event = getRemoteEvent(eventName, false)

	if not event then
		return false
	end

	event:FireClient(player, payload or {})
	return true
end


-- ============================================================
-- [ FIRE ALL CLIENTS REMOTE EVENT ]
-- Sends a payload to every client in the current server if it exists.
-- ============================================================

local function fireAllClientsRemoteEvent(eventName, payload)
	local event = getRemoteEvent(eventName, false)

	if not event then
		return false
	end

	event:FireAllClients(payload or {})
	return true
end


-- ============================================================
-- [ HANDLE ARENA JOIN REQUESTED ]
-- Receives the client confirmation from the Arena gate prompt.
-- ============================================================

handleArenaJoinRequested = function(player, request)
	if requestArenaJoin then
		return requestArenaJoin(player, request)
	end

	return false, "ArenaJoinHandlerNotReady"
end


-- ============================================================
-- [ HANDLE ARENA ANSWER SELECTED ]
-- Receives a player's Arena answer from the client UI.
-- ============================================================

handleArenaAnswerSelected = function(player, request)
	if submitArenaAnswer then
		return submitArenaAnswer(player, request)
	end

	return false, "ArenaAnswerHandlerNotReady"
end


-- ============================================================
-- [ HANDLE ARENA EXIT REQUESTED ]
-- Receives an exit-button request from active, queued, or spectator state.
-- ============================================================

handleArenaExitRequested = function(player, request)
	if leaveArena then
		return leaveArena(player, request, "ExitRequested")
	end

	return false, "ArenaExitHandlerNotReady"
end


-- ============================================================
-- [ ENSURE ARENA ACTIVITY REMOTES ]
-- Creates server/client remotes for the level-wide Arena activity.
-- ============================================================

local function ensureArenaActivityRemotes()
	for _, eventName in ipairs(ARENA_ACTIVITY_REMOTE_EVENTS) do
		getRemoteEvent(eventName, true)
	end

	if not arenaJoinRemoteConnected then
		local joinEvent = getRemoteEvent(ARENA_JOIN_REQUEST_REMOTE, true)
		if joinEvent then
			joinEvent.OnServerEvent:Connect(handleArenaJoinRequested)
			arenaJoinRemoteConnected = true
		end
	end

	if not arenaAnswerRemoteConnected then
		local answerEvent = getRemoteEvent(ARENA_ANSWER_REMOTE, true)
		if answerEvent then
			answerEvent.OnServerEvent:Connect(handleArenaAnswerSelected)
			arenaAnswerRemoteConnected = true
		end
	end

	if not arenaExitRemoteConnected then
		local exitEvent = getRemoteEvent(ARENA_EXIT_REMOTE, true)
		if exitEvent then
			exitEvent.OnServerEvent:Connect(handleArenaExitRequested)
			arenaExitRemoteConnected = true
		end
	end
end


-- ============================================================
-- [ GET ARENA ACTIVITY PAYLOAD ]
-- Describes the one visible Arena area shared by a Tower level server.
-- ============================================================

local function getArenaActivityPayload(player, context, extra)
	context = context or {}

	local payload = {
		mode = "Arena",
		source = context.source or TowerLevelAreas.Arena,
		towerLevel = context.towerLevel,
		serverOnly = context.serverOnly == true,
		oneArenaPerTowerLevel = true,
		physicalArena = true,
		largeQuestionProjection = true,
		questionProjectionSize = context.questionProjectionSize or ARENA_QUESTION_PROJECTION_SIZE,
		visibleToEntireLevelServer = true,
		visualOptInRequired = false,
		spectateRequired = false,
		showVisuals = true,
		joinDuringQuestionQueues = true,
		soloPractice = false,
		minScoredPlayers = ARENA_MIN_SCORED_PLAYERS,
		intermissionSeconds = ARENA_INTERMISSION_SECONDS,
		questionSeconds = ARENA_QUESTION_SECONDS,
		leaderboardLimit = ARENA_LEADERBOARD_LIMIT,
		startedByUserId = player and player.UserId or nil,
		startedByName = player and player.Name or nil,
		startedAt = os.time(),
	}

	if extra then
		for key, value in pairs(extra) do
			payload[key] = value
		end
	end

	return payload
end


-- ============================================================
-- [ ARENA QUESTION BANK ]
-- Server-owned questions used by Arena until larger content banks exist.
-- ============================================================

local ArenaQuestionBank = {
	{
		questionId = "arena_math_001",
		question = "What is 5 + 3?",
		answers = { "6", "7", "8", "9" },
		correct = "8",
	},
	{
		questionId = "arena_science_001",
		question = "Which planet is known as the Red Planet?",
		answers = { "Venus", "Mars", "Jupiter", "Mercury" },
		correct = "Mars",
	},
	{
		questionId = "arena_geo_001",
		question = "What is the capital of Thailand?",
		answers = { "Bangkok", "Chiang Mai", "Phuket", "Pattaya" },
		correct = "Bangkok",
	},
	{
		questionId = "arena_math_002",
		question = "How many degrees are in a right angle?",
		answers = { "45", "60", "90", "180" },
		correct = "90",
	},
}

local arenaRandom = Random.new()
local arenaSessions = {}


-- ============================================================
-- [ GET ARENA SESSION KEY ]
-- Builds the per-Tower-level key for the shared Arena session.
-- ============================================================

function getArenaSessionKey(towerLevel)
	local normalizedLevel = tonumber(towerLevel)
	if normalizedLevel then
		return "TowerLevel:" .. tostring(math.floor(normalizedLevel))
	end

	return "TowerLevel:Server"
end


-- ============================================================
-- [ GET ARENA MAP COUNT ]
-- Counts players in an Arena lookup table.
-- ============================================================

function getArenaMapCount(map)
	local count = 0
	for _ in pairs(map or {}) do
		count = count + 1
	end
	return count
end


-- ============================================================
-- [ GET ARENA PLAYER SUMMARY ]
-- Copies player identity data for Arena remote payloads.
-- ============================================================

function getArenaPlayerSummary(map)
	local players = {}
	for userId, player in pairs(map or {}) do
		table.insert(players, {
			userId = userId,
			name = player and player.Name or tostring(userId),
		})
	end

	table.sort(players, function(left, right)
		return left.name < right.name
	end)

	return players
end


-- ============================================================
-- [ GET ARENA SESSION ]
-- Finds or creates the shared Arena session for a Tower level.
-- ============================================================

function getArenaSession(towerLevel, context, createIfMissing)
	local key = getArenaSessionKey(towerLevel)
	local state = arenaSessions[key]

	if not state and createIfMissing then
		state = {
			key = key,
			towerLevel = towerLevel,
			context = context or {},
			status = "Idle",
			sessionId = 0,
			scoredSessionId = 0,
			roundIndex = 0,
			questionSequence = 0,
			activePlayers = {},
			queuedPlayers = {},
			spectators = {},
			scores = {},
			scoreNames = {},
			answeredThisQuestion = {},
			running = false,
			scoredSessionStarted = false,
			scoringEnabled = false,
		}
		arenaSessions[key] = state
	elseif state and context then
		state.context = context
		state.towerLevel = towerLevel or state.towerLevel
	end

	return state
end


-- ============================================================
-- [ FIND ARENA SESSION FOR PLAYER ]
-- Finds the Arena session where a player is active, queued, or spectating.
-- ============================================================

function findArenaSessionForPlayer(player, towerLevel)
	local userId = player.UserId

	if towerLevel then
		local state = getArenaSession(towerLevel, nil, false)
		if state and (state.activePlayers[userId] or state.queuedPlayers[userId] or state.spectators[userId]) then
			return state
		end
	end

	for _, state in pairs(arenaSessions) do
		if state.activePlayers[userId] or state.queuedPlayers[userId] or state.spectators[userId] then
			return state
		end
	end

	return nil
end


-- ============================================================
-- [ COPY ARENA ANSWERS ]
-- Copies answer text so question-bank rows are not mutated by a round.
-- ============================================================

function copyArenaAnswers(questionData)
	local answers = {}
	for index, answer in ipairs(questionData.answers or {}) do
		answers[index] = answer
	end
	return answers
end


-- ============================================================
-- [ GET ARENA QUESTION FOR ROUND ]
-- Picks a random Arena question, avoiding a direct repeat when possible.
-- ============================================================

function getArenaQuestionForRound(state)
	local questionCount = #ArenaQuestionBank
	if questionCount == 0 then
		return nil
	end

	local questionIndex = 1
	if questionCount > 1 then
		repeat
			questionIndex = arenaRandom:NextInteger(1, questionCount)
		until questionIndex ~= state.lastQuestionBankIndex
	end

	state.lastQuestionBankIndex = questionIndex
	local questionData = ArenaQuestionBank[questionIndex]
	return {
		questionId = questionData.questionId or ("arena_question_" .. tostring(questionIndex)),
		question = questionData.question,
		answers = copyArenaAnswers(questionData),
		correct = questionData.correct,
	}
end


-- ============================================================
-- [ GET ARENA LEADERBOARD ]
-- Builds the top session scores for the current Arena session.
-- ============================================================

function getArenaLeaderboard(state)
	local rows = {}
	local includedUserIds = {}

	for userId, score in pairs(state.scores or {}) do
		includedUserIds[userId] = true
		table.insert(rows, {
			userId = userId,
			name = state.scoreNames[userId] or ("Player " .. tostring(userId)),
			score = score,
		})
	end

	for userId, player in pairs(state.activePlayers or {}) do
		if not includedUserIds[userId] then
			table.insert(rows, {
				userId = userId,
				name = player.Name,
				score = 0,
			})
		end
	end

	table.sort(rows, function(left, right)
		if left.score == right.score then
			return left.name < right.name
		end
		return left.score > right.score
	end)

	local leaderboard = {}
	for index = 1, math.min(ARENA_LEADERBOARD_LIMIT, #rows) do
		leaderboard[index] = rows[index]
	end
	return leaderboard
end


-- ============================================================
-- [ GET ARENA SESSION PAYLOAD ]
-- Builds the shared remote payload for Arena state updates.
-- ============================================================

function getArenaSessionPayload(state, extra)
	local activePlayerCount = getArenaMapCount(state.activePlayers)
	local payload = getArenaActivityPayload(nil, state.context or {}, {
		arenaSessionKey = state.key,
		arenaSessionId = state.sessionId,
		scoredSessionId = state.scoredSessionId,
		status = state.status,
		towerLevel = state.towerLevel,
		activePlayerCount = activePlayerCount,
		queuedPlayerCount = getArenaMapCount(state.queuedPlayers),
		spectatorCount = getArenaMapCount(state.spectators),
		activePlayers = getArenaPlayerSummary(state.activePlayers),
		queuedPlayers = getArenaPlayerSummary(state.queuedPlayers),
		scoredSessionStarted = state.scoredSessionStarted == true,
		scoringEnabled = state.scoringEnabled == true,
		soloPractice = activePlayerCount < ARENA_MIN_SCORED_PLAYERS,
		leaderboard = getArenaLeaderboard(state),
		roundIndex = state.roundIndex,
		questionSequence = state.questionSequence,
	})

	if state.currentQuestion then
		payload.questionId = state.currentQuestion.questionId
		payload.question = state.currentQuestion.question
		payload.answers = state.currentQuestion.answers
	end

	if extra then
		for key, value in pairs(extra) do
			payload[key] = value
		end
	end

	return payload
end


-- ============================================================
-- [ FIRE ARENA LEADERBOARD ]
-- Broadcasts the current top-5 session leaderboard.
-- ============================================================

function fireArenaLeaderboard(state, reason)
	fireAllClientsRemoteEvent("ArenaLeaderboardUpdated", getArenaSessionPayload(state, {
		reason = reason or "LeaderboardUpdated",
		leaderboard = getArenaLeaderboard(state),
	}))
end


-- ============================================================
-- [ GET ARENA ROOT PART ]
-- Finds the character part used for Arena teleport/facing.
-- ============================================================

function getArenaRootPart(player)
	local character = player.Character
	if not character then
		return nil
	end

	local root = character:FindFirstChild("HumanoidRootPart")
	if root and root:IsA("BasePart") then
		return root
	end

	return character:FindFirstChildWhichIsA("BasePart")
end


-- ============================================================
-- [ GET ARENA PART ]
-- Finds a named Arena world part from context or workspace fallback.
-- ============================================================

function getArenaPart(context, preferredName, fallbackName)
	context = context or {}

	local requestedName = context[preferredName]
	if type(requestedName) == "string" and requestedName ~= "" then
		local requestedPart = workspace:FindFirstChild(requestedName, true)
		if requestedPart and requestedPart:IsA("BasePart") then
			return requestedPart
		end
	end

	local fallbackPart = workspace:FindFirstChild(fallbackName, true)
	if fallbackPart and fallbackPart:IsA("BasePart") then
		return fallbackPart
	end

	return nil
end


-- ============================================================
-- [ GET ARENA GATE SIDE CFRAME ]
-- Reads the spawn CFrame where active Arena players gather.
-- ============================================================

function getArenaGateSideCFrame(context)
	context = context or {}
	if typeof(context.gateSideCFrame) == "CFrame" then
		return context.gateSideCFrame
	end

	local gatePart = getArenaPart(context, "gateSideSpawnName", "ArenaGateSideSpawn")
		or getArenaPart(context, "gateSideName", "ArenaGateSide")
	if gatePart then
		return gatePart.CFrame + Vector3.new(0, 3, 0)
	end

	return nil
end


-- ============================================================
-- [ GET ARENA SCREEN POSITION ]
-- Finds the projection screen position for player facing direction.
-- ============================================================

function getArenaScreenPosition(context)
	context = context or {}
	if typeof(context.questionScreenCFrame) == "CFrame" then
		return context.questionScreenCFrame.Position
	end

	local screenPart = getArenaPart(context, "questionScreenName", "ArenaQuestionScreen")
		or getArenaPart(context, "projectionScreenName", "ArenaProjectionScreen")
	if screenPart then
		return screenPart.Position
	end

	return nil
end


-- ============================================================
-- [ MOVE PLAYER TO ARENA GATE SIDE ]
-- Places a joined player on the gate side facing the question screen.
-- ============================================================

function movePlayerToArenaGateSide(player, context)
	local root = getArenaRootPart(player)
	local gateCFrame = getArenaGateSideCFrame(context)
	if not root or not gateCFrame then
		return false
	end

	local position = gateCFrame.Position
	local lookAt = getArenaScreenPosition(context) or (position + gateCFrame.LookVector)
	local flatLookAt = Vector3.new(lookAt.X, position.Y, lookAt.Z)

	if (flatLookAt - position).Magnitude > 0.05 then
		root.CFrame = CFrame.lookAt(position, flatLookAt)
	else
		root.CFrame = gateCFrame
	end

	return true
end


-- ============================================================
-- [ REFRESH ARENA SCORING STATE ]
-- Starts or pauses scoring based on active player count.
-- ============================================================

function refreshArenaScoringState(state, reason)
	local activePlayerCount = getArenaMapCount(state.activePlayers)
	local shouldEnableScoring = activePlayerCount >= ARENA_MIN_SCORED_PLAYERS

	if shouldEnableScoring and not state.scoredSessionStarted then
		state.scoredSessionStarted = true
		state.scoringEnabled = true
		state.scoredSessionId = state.scoredSessionId + 1
		state.scoredSessionStartedAt = os.time()
		state.scores = {}
		state.scoreNames = {}

		for userId, player in pairs(state.activePlayers) do
			state.scores[userId] = 0
			state.scoreNames[userId] = player.Name
		end

		fireAllClientsRemoteEvent("ArenaScoredSessionStarted", getArenaSessionPayload(state, {
			reason = reason or "SecondPlayerJoined",
			freshScoredSession = true,
		}))
		fireArenaLeaderboard(state, "FreshScoredSession")
		return true
	end

	state.scoringEnabled = state.scoredSessionStarted and shouldEnableScoring
	return false
end

local finishArenaSession
local runArenaSessionLoop


-- ============================================================
-- [ PROJECT ARENA QUESTION ]
-- Broadcasts the Arena question projection to everyone in the level server.
-- ============================================================

local function projectArenaQuestion(player, context, questionData, state, extra)
	ensureArenaActivityRemotes()
	context = context or {}

	local question = nil
	local answers = nil
	local questionId = nil
	if type(questionData) == "table" then
		question = questionData.question
		answers = questionData.answers
		questionId = questionData.questionId
	end

	local payload = nil
	local projectionExtra = {
		question = question or context.question,
		answers = answers or context.answers,
		questionId = questionId or context.questionId,
		questionSeconds = ARENA_QUESTION_SECONDS,
	}

	if extra then
		for key, value in pairs(extra) do
			projectionExtra[key] = value
		end
	end

	if state then
		payload = getArenaSessionPayload(state, projectionExtra)
	else
		payload = getArenaActivityPayload(player, context, projectionExtra)
	end

	fireAllClientsRemoteEvent("ArenaQuestionProjected", payload)
	return true, "ArenaQuestionProjected", payload
end


-- ============================================================
-- [ APPLY QUEUED ARENA PLAYERS ]
-- Moves queued spectators into the active Arena during intermission.
-- ============================================================

function applyQueuedArenaPlayers(state)
	local joinedPlayers = {}

	for userId, player in pairs(state.queuedPlayers) do
		state.queuedPlayers[userId] = nil

		if player and player.Parent then
			state.activePlayers[userId] = player
			state.spectators[userId] = nil
			player:SetAttribute("InArena", true)
			player:SetAttribute("ArenaQueued", false)
			player:SetAttribute("ArenaSpectating", false)
			movePlayerToArenaGateSide(player, state.context)
			table.insert(joinedPlayers, {
				userId = userId,
				name = player.Name,
			})
		end
	end

	if #joinedPlayers > 0 then
		fireAllClientsRemoteEvent("ArenaPlayerJoined", getArenaSessionPayload(state, {
			reason = "QueuedPlayersEntered",
			joinedPlayers = joinedPlayers,
		}))
	end

	refreshArenaScoringState(state, "QueuedPlayersEntered")
	return joinedPlayers
end


-- ============================================================
-- [ START ARENA INTERMISSION ]
-- Runs the 10-second break and countdown between Arena questions.
-- ============================================================

function startArenaIntermission(state, reason)
	state.status = "Intermission"
	state.currentQuestion = nil
	state.acceptingAnswers = false
	state.answeredThisQuestion = {}

	applyQueuedArenaPlayers(state)

	if getArenaMapCount(state.activePlayers) <= 0 then
		return false
	end

	fireAllClientsRemoteEvent("ArenaIntermissionStarted", getArenaSessionPayload(state, {
		reason = reason or "BetweenQuestions",
		intermissionSeconds = ARENA_INTERMISSION_SECONDS,
		countdown = ARENA_INTERMISSION_SECONDS,
		canJoinNow = true,
	}))

	for remaining = ARENA_INTERMISSION_SECONDS, 1, -1 do
		if not state.running or getArenaMapCount(state.activePlayers) <= 0 then
			return false
		end

		fireAllClientsRemoteEvent("ArenaCountdownTick", getArenaSessionPayload(state, {
			countdown = remaining,
			canJoinNow = true,
		}))
		task.wait(1)
	end

	fireAllClientsRemoteEvent("ArenaCountdownTick", getArenaSessionPayload(state, {
		countdown = 0,
		canJoinNow = false,
	}))

	return getArenaMapCount(state.activePlayers) > 0
end


-- ============================================================
-- [ PRESENT ARENA QUESTION ]
-- Projects one Arena question and waits for first correct answer or timeout.
-- ============================================================

function presentArenaQuestion(state)
	if getArenaMapCount(state.activePlayers) <= 0 then
		return false
	end

	local questionData = getArenaQuestionForRound(state)
	if not questionData then
		finishArenaSession(state, "NoArenaQuestionsConfigured")
		return false
	end

	state.status = "Question"
	state.roundIndex = state.roundIndex + 1
	state.questionSequence = state.questionSequence + 1
	state.currentQuestion = questionData
	state.acceptingAnswers = true
	state.answeredThisQuestion = {}
	state.questionResolved = false
	state.questionStartedAt = os.clock()
	state.questionDeadline = state.questionStartedAt + ARENA_QUESTION_SECONDS

	projectArenaQuestion(nil, state.context, questionData, state, {
		canJoinNow = false,
		queuedPlayersJoinNextIntermission = true,
	})

	local questionSequence = state.questionSequence
	while state.running
		and state.acceptingAnswers
		and state.questionSequence == questionSequence
		and getArenaMapCount(state.activePlayers) > 0 do
		local remaining = (state.questionDeadline or os.clock()) - os.clock()
		if remaining <= 0 then
			break
		end
		task.wait(0.25)
	end

	if not state.running or getArenaMapCount(state.activePlayers) <= 0 then
		return false
	end

	if state.acceptingAnswers and state.questionSequence == questionSequence then
		state.acceptingAnswers = false
		state.questionResolved = true
		fireAllClientsRemoteEvent("ArenaQuestionResolved", getArenaSessionPayload(state, {
			reason = "TimeExpired",
			correctAnswer = state.currentQuestion and state.currentQuestion.correct,
			scoreAwarded = false,
			xpAwarded = false,
		}))
	end

	task.wait(1)
	return true
end


-- ============================================================
-- [ FINISH ARENA SESSION ]
-- Ends Arena when active players reach zero and resets session state.
-- ============================================================

finishArenaSession = function(state, reason)
	if not state then
		return false, "MissingArenaSession"
	end

	local finalPayload = getArenaSessionPayload(state, {
		reason = reason or "ArenaEmpty",
		finalLeaderboard = getArenaLeaderboard(state),
		showVisuals = false,
	})

	state.running = false
	state.status = "Idle"
	state.activePlayers = {}
	state.queuedPlayers = {}
	state.spectators = {}
	state.scores = {}
	state.scoreNames = {}
	state.answeredThisQuestion = {}
	state.currentQuestion = nil
	state.acceptingAnswers = false
	state.scoredSessionStarted = false
	state.scoringEnabled = false
	state.roundIndex = 0
	state.questionSequence = 0

	fireAllClientsRemoteEvent("ArenaActivityEnded", finalPayload)
	return true, "ArenaActivityEnded", finalPayload
end


-- ============================================================
-- [ RUN ARENA SESSION LOOP ]
-- Keeps Arena running intermission/question cycles until empty.
-- ============================================================

runArenaSessionLoop = function(state)
	if state.running then
		return
	end

	state.running = true
	task.spawn(function()
		while state.running do
			if getArenaMapCount(state.activePlayers) <= 0 then
				break
			end

			local hasPlayers = startArenaIntermission(state, state.roundIndex == 0 and "ArenaStarted" or "BetweenQuestions")
			if not hasPlayers then
				break
			end

			local questionStarted = presentArenaQuestion(state)
			if not questionStarted then
				break
			end
		end

		if state.running then
			finishArenaSession(state, "NoActivePlayers")
		end
	end)
end


-- ============================================================
-- [ BEGIN ARENA ACTIVITY ]
-- Queues or joins a player into the shared Tower Arena session.
-- ============================================================

beginArenaActivity = function(player, context)
	return requestArenaJoin(player, context or {})
end


-- ============================================================
-- [ PROMPT ARENA JOIN ]
-- Touching the gate asks an eligible player whether they want to join.
-- ============================================================

promptArenaJoin = function(player, towerLevel)
	ensureArenaActivityRemotes()

	local allowed, reason, requiredXP, currentXP = canEnterTowerLevel(player, towerLevel)
	if not allowed then
		if reason == "NotEnoughXP" then
			notifyTowerAccessDenied(player, towerLevel, requiredXP, currentXP)
		elseif reason == "UpLevelTestRequired" then
			notifyUpLevelTestReady(player, towerLevel, requiredXP, currentXP)
		end

		firePlayerRemoteEvent(player, "ArenaJoinDenied", {
			towerLevel = towerLevel,
			reason = reason,
			requiredXP = requiredXP,
			currentXP = currentXP,
		})
		return false, reason, requiredXP, currentXP
	end

	firePlayerRemoteEvent(player, "ArenaJoinPromptShown", {
		towerLevel = towerLevel,
		prompt = "Join the Arena?",
		yesAction = ARENA_JOIN_REQUEST_REMOTE,
		noAction = "Dismiss",
	})
	return true, "ArenaJoinPromptShown"
end


-- ============================================================
-- [ REQUEST ARENA JOIN ]
-- Adds the player now during intermission/idle, or queues them mid-question.
-- ============================================================

requestArenaJoin = function(player, request)
	ensureArenaActivityRemotes()

	local context = {}
	local towerLevel = nil
	if type(request) == "table" then
		context = request
		towerLevel = request.towerLevel or request.level
	elseif tonumber(request) then
		towerLevel = tonumber(request)
	end

	towerLevel = math.floor(tonumber(towerLevel or context.towerLevel or getHighestUnlockedTowerLevel(player)) or DEFAULT_UNLOCKED_TOWER_LEVEL)
	context.towerLevel = towerLevel
	context.source = context.source or TowerLevelAreas.Arena
	context.serverOnly = true
	context.oneArenaPerTowerLevel = true
	context.largeQuestionProjection = true
	context.visibleToEntireLevelServer = true
	context.visualOptInRequired = false
	context.spectateRequired = false
	context.showVisuals = true

	local allowed, reason, requiredXP, currentXP = canEnterTowerLevel(player, towerLevel)
	if not allowed then
		if reason == "NotEnoughXP" then
			notifyTowerAccessDenied(player, towerLevel, requiredXP, currentXP)
		elseif reason == "UpLevelTestRequired" then
			notifyUpLevelTestReady(player, towerLevel, requiredXP, currentXP)
		end

		firePlayerRemoteEvent(player, "ArenaJoinDenied", {
			towerLevel = towerLevel,
			reason = reason,
			requiredXP = requiredXP,
			currentXP = currentXP,
		})
		return false, reason, requiredXP, currentXP
	end

	local state = getArenaSession(towerLevel, context, true)
	local userId = player.UserId

	if state.activePlayers[userId] then
		firePlayerRemoteEvent(player, "ArenaPlayerJoined", getArenaSessionPayload(state, {
			reason = "AlreadyInArena",
			participant = true,
		}))
		return true, "AlreadyInArena", state
	end

	if state.status == "Question" then
		state.queuedPlayers[userId] = player
		state.spectators[userId] = player
		player:SetAttribute("ArenaQueued", true)
		player:SetAttribute("ArenaSpectating", true)

		local payload = getArenaSessionPayload(state, {
			reason = "QueuedUntilIntermission",
			participant = false,
			spectating = true,
		})
		firePlayerRemoteEvent(player, "ArenaJoinQueued", payload)
		firePlayerRemoteEvent(player, "ArenaSpectateStarted", payload)
		return true, "QueuedUntilIntermission", state
	end

	local wasIdle = getArenaMapCount(state.activePlayers) == 0 and state.status == "Idle"
	state.activePlayers[userId] = player
	state.queuedPlayers[userId] = nil
	state.spectators[userId] = nil
	player:SetAttribute("InArena", true)
	player:SetAttribute("ArenaQueued", false)
	player:SetAttribute("ArenaSpectating", false)
	movePlayerToArenaGateSide(player, state.context)

	if wasIdle then
		state.sessionId = state.sessionId + 1
		state.startedAt = os.time()
		state.status = "Intermission"
		state.scoredSessionStarted = false
		state.scoringEnabled = false
		state.scores = {}
		state.scoreNames = {}

		fireAllClientsRemoteEvent("ArenaActivityStarted", getArenaSessionPayload(state, {
			reason = "FirstPlayerJoined",
		}))
	else
		fireAllClientsRemoteEvent("ArenaPlayerJoined", getArenaSessionPayload(state, {
			reason = "JoinedDuringIntermission",
			joinedPlayers = {
				{
					userId = userId,
					name = player.Name,
				},
			},
		}))
	end

	refreshArenaScoringState(state, "PlayerJoined")
	runArenaSessionLoop(state)
	return true, wasIdle and "ArenaStarted" or "JoinedArena", state
end


-- ============================================================
-- [ SUBMIT ARENA ANSWER ]
-- Correct answers only score/award XP while at least 2 players are active.
-- ============================================================

submitArenaAnswer = function(player, request)
	local selectedAnswer = request
	local towerLevel = nil

	if type(request) == "table" then
		selectedAnswer = request.selectedAnswer or request.answer or request.choice
		towerLevel = request.towerLevel
	end

	local state = findArenaSessionForPlayer(player, towerLevel)
	if not state or not state.activePlayers[player.UserId] then
		firePlayerRemoteEvent(player, "ArenaAnswerResult", {
			reason = "NotArenaParticipant",
			wasCorrect = false,
		})
		return false, "NotArenaParticipant"
	end

	if not state.acceptingAnswers or not state.currentQuestion then
		firePlayerRemoteEvent(player, "ArenaAnswerResult", getArenaSessionPayload(state, {
			reason = "NoActiveQuestion",
			wasCorrect = false,
		}))
		return false, "NoActiveQuestion"
	end

	if state.answeredThisQuestion[player.UserId] then
		firePlayerRemoteEvent(player, "ArenaAnswerResult", getArenaSessionPayload(state, {
			reason = "AlreadyAnswered",
			wasCorrect = false,
		}))
		return false, "AlreadyAnswered"
	end

	local question = state.currentQuestion
	local answerText = selectedAnswer
	if type(answerText) == "number" then
		answerText = question.answers[answerText]
	end
	answerText = tostring(answerText or "")

	state.answeredThisQuestion[player.UserId] = true
	local wasCorrect = answerText == question.correct
	local scoreAwarded = false
	local xpAwarded = false

	if wasCorrect then
		local activePlayerCount = getArenaMapCount(state.activePlayers)
		local canScore = state.scoredSessionStarted and activePlayerCount >= ARENA_MIN_SCORED_PLAYERS

		if canScore then
			state.scores[player.UserId] = (state.scores[player.UserId] or 0) + 1
			state.scoreNames[player.UserId] = player.Name
			scoreAwarded = true

			if awardExperience then
				awardExperience(player, XP_REWARDS.CorrectAnswer)
				xpAwarded = true
			end

			fireArenaLeaderboard(state, "CorrectAnswer")
		end

		state.acceptingAnswers = false
		state.questionResolved = true

		local resultPayload = getArenaSessionPayload(state, {
			reason = canScore and "CorrectAnswer" or "PracticeCorrectNoScore",
			wasCorrect = true,
			selectedAnswer = answerText,
			correctAnswer = question.correct,
			winnerUserId = player.UserId,
			winnerName = player.Name,
			scoreAwarded = scoreAwarded,
			xpAwarded = xpAwarded,
			practiceOnly = not canScore,
		})

		firePlayerRemoteEvent(player, "ArenaAnswerResult", resultPayload)
		fireAllClientsRemoteEvent("ArenaQuestionResolved", resultPayload)
		return true, scoreAwarded and "CorrectScoreAwarded" or "PracticeCorrectNoScore", state
	end

	firePlayerRemoteEvent(player, "ArenaAnswerResult", getArenaSessionPayload(state, {
		reason = "WrongAnswer",
		wasCorrect = false,
		selectedAnswer = answerText,
		correctAnswer = question.correct,
		scoreAwarded = false,
		xpAwarded = false,
		playerEliminated = false,
	}))
	return false, "WrongAnswer", state
end


-- ============================================================
-- [ LEAVE ARENA ]
-- Exit button/disconnect cleanup. The session ends when 0 active players remain.
-- ============================================================

leaveArena = function(player, request, reason)
	local towerLevel = nil
	if type(request) == "table" then
		towerLevel = request.towerLevel
	elseif tonumber(request) then
		towerLevel = tonumber(request)
	end

	local state = findArenaSessionForPlayer(player, towerLevel)
	if not state then
		return false, "NotInArena"
	end

	local userId = player.UserId
	local wasActive = state.activePlayers[userId] ~= nil
	state.activePlayers[userId] = nil
	state.queuedPlayers[userId] = nil
	state.spectators[userId] = nil
	player:SetAttribute("InArena", false)
	player:SetAttribute("ArenaQueued", false)
	player:SetAttribute("ArenaSpectating", false)

	local payload = getArenaSessionPayload(state, {
		reason = reason or "LeftArena",
		leftUserId = userId,
		leftName = player.Name,
	})

	firePlayerRemoteEvent(player, "ArenaPlayerLeft", payload)
	fireAllClientsRemoteEvent("ArenaPlayerLeft", payload)

	if wasActive then
		refreshArenaScoringState(state, "PlayerLeft")
		fireArenaLeaderboard(state, "PlayerLeft")

		if getArenaMapCount(state.activePlayers) <= 0 then
			return finishArenaSession(state, "NoActivePlayers")
		end
	end

	return true, "LeftArena", state
end


-- ============================================================
-- [ CLEAR PLAYER ARENA PRESENCE ]
-- Removes a disconnecting player from any Arena state.
-- ============================================================

clearPlayerArenaPresence = function(player)
	leaveArena(player, nil, "PlayerRemoving")
end

Players.PlayerRemoving:Connect(clearPlayerArenaPresence)


-- ============================================================
-- [ GET BOOLEAN PLAYER FLAG ]
-- Reads a true/false permission flag from attributes or child BoolValues.
-- ============================================================

local function getBooleanPlayerFlag(player, flagNames)
	for _, flagName in ipairs(flagNames) do
		local attributeValue = player:GetAttribute(flagName)
		if attributeValue ~= nil then
			return attributeValue == true
		end

		local valueObject = player:FindFirstChild(flagName)
		if valueObject and valueObject:IsA("BoolValue") then
			return valueObject.Value == true
		end
	end

	return false
end


-- ============================================================
-- [ GET PLAYER ROOT PART ]
-- Finds the character part used for distance checks and local spawning.
-- ============================================================

local function getPlayerRootPart(player)
	local character = player.Character
	if not character then
		return nil
	end

	local root = character:FindFirstChild("HumanoidRootPart")
	if root and root:IsA("BasePart") then
		return root
	end

	return character:FindFirstChildWhichIsA("BasePart")
end


-- ============================================================
-- [ PLAYER HAS BATTLEPASS ]
-- Checks whether the player owns the Battlepass playground/group perks.
-- ============================================================

local function playerHasBattlepass(player)
	if getBooleanPlayerFlag(player, { "HasBattlepass", "HasBattlePass", "Battlepass", "BattlePass" }) then
		return true
	end

	local battlepassId = GAME_PASS_IDS.Battlepass
	if not battlepassId or battlepassId == 0 then
		return false
	end

	local ok, ownsPass = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, battlepassId)
	end)

	if not ok then
		warn(("Battlepass ownership check failed for %s: %s"):format(player.Name, tostring(ownsPass)))
		return false
	end

	return ownsPass == true
end


-- ============================================================
-- [ NORMALIZE GROUP STAGE LOCATION ]
-- Converts a requested stage location into Community or Playground.
-- ============================================================

local function normalizeGroupStageLocation(location)
	local locationText = string.lower(tostring(location or GROUP_STAGE_LOCATIONS.Community))

	if locationText == "playground" then
		return GROUP_STAGE_LOCATIONS.Playground
	end

	return GROUP_STAGE_LOCATIONS.Community
end


-- ============================================================
-- [ NORMALIZE GROUP STAGE PRIVACY ]
-- Converts a requested privacy value into Public or InviteOnly.
-- ============================================================

local function normalizeGroupStagePrivacy(privacy)
	local privacyText = string.lower(tostring(privacy or GROUP_STAGE_PRIVACY.Public))
	privacyText = privacyText:gsub("%s+", "")

	if privacyText == "inviteonly" or privacyText == "invitesonly" or privacyText == "private" then
		return GROUP_STAGE_PRIVACY.InviteOnly
	end

	return GROUP_STAGE_PRIVACY.Public
end


-- ============================================================
-- [ NORMALIZE GROUP STAGE DISPLAY TEXT ]
-- Cleans player-facing stage labels before they are sent to clients.
-- ============================================================

local function normalizeGroupStageDisplayText(value, fallback, maxLength)
	local text = tostring(value or "")
	text = text:gsub("[%c\r\n\t]", " ")
	text = text:gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s%s+", " ")

	if text == "" then
		text = fallback
	end

	if maxLength and #text > maxLength then
		text = string.sub(text, 1, maxLength)
	end

	return text
end


-- ============================================================
-- [ NORMALIZE GROUP STAGE NAME ]
-- Uses the host-created group name, with a fallback if it is blank.
-- ============================================================

local function normalizeGroupStageName(player, groupName)
	return normalizeGroupStageDisplayText(
		groupName,
		player.Name .. "'s Group",
		GROUP_STAGE_NAME_MAX_LENGTH
	)
end


-- ============================================================
-- [ NORMALIZE GROUP STAGE QUESTION TYPE ]
-- Stores the selected question level plus the chosen topic as "Level X - Topic".
-- ============================================================

local function normalizeGroupStageQuestionType(options, fallbackTowerLevel)
	options = options or {}

	local questionType = options.questionType
	local requestedLevel = options.questionLevel or options.level
	local requestedTopic = options.questionTopic or options.topic or options.selectedTopic

	if type(questionType) == "table" then
		requestedLevel = requestedLevel or questionType.level or questionType.questionLevel
		requestedTopic = requestedTopic or questionType.topic or questionType.questionTopic or questionType.name
	elseif type(questionType) == "string" then
		local parsedLevel, parsedTopic = questionType:match("^%s*[Ll]evel%s+(%d+)%s*%-%s*(.-)%s*$")
		if parsedLevel then
			requestedLevel = requestedLevel or parsedLevel
			requestedTopic = requestedTopic or parsedTopic
		else
			requestedTopic = requestedTopic or questionType
		end
	end

	requestedLevel = requestedLevel or fallbackTowerLevel or DEFAULT_GROUP_STAGE_QUESTION_LEVEL
	local questionLevel = math.max(1, math.floor(tonumber(requestedLevel) or DEFAULT_GROUP_STAGE_QUESTION_LEVEL))
	local questionTopic = normalizeGroupStageDisplayText(
		requestedTopic,
		DEFAULT_GROUP_STAGE_QUESTION_TOPIC,
		GROUP_STAGE_TOPIC_MAX_LENGTH
	)

	return {
		level = questionLevel,
		topic = questionTopic,
		label = ("Level %d - %s"):format(questionLevel, questionTopic),
	}
end


-- ============================================================
-- [ BUILD GROUP STAGE INFO TEXT ]
-- Combines the host-created stage name with its question type label.
-- ============================================================

local function buildGroupStageInfoText(stageData)
	return ("%s\n%s"):format(
		stageData.groupName or "Group Stage",
		stageData.questionTypeLabel or ("Level 1 - " .. DEFAULT_GROUP_STAGE_QUESTION_TOPIC)
	)
end


-- ============================================================
-- [ SANITIZE INVITED USER IDS ]
-- Builds a clean invite list for invite-only Battlepass group stages.
-- ============================================================

local function sanitizeInvitedUserIds(player, invitedUserIds)
	local list = {}
	local map = {}

	local function addUserId(userId)
		local sanitizedUserId = math.floor(tonumber(userId) or 0)
		if sanitizedUserId <= 0 or map[sanitizedUserId] then
			return
		end

		map[sanitizedUserId] = true
		table.insert(list, sanitizedUserId)
	end

	addUserId(player.UserId)

	if type(invitedUserIds) == "table" then
		for _, userId in ipairs(invitedUserIds) do
			addUserId(userId)
		end
	end

	return list, map
end


-- ============================================================
-- [ GET GROUP STAGE PAYLOAD ]
-- Copies stage data for remotes without sending server-only lookup tables.
-- ============================================================

local function getGroupStagePayload(stageData, showVisuals, extra)
	local invitedUserIds = {}
	for _, userId in ipairs(stageData.invitedUserIds or {}) do
		table.insert(invitedUserIds, userId)
	end

	local payload = {
		stageId = stageData.stageId,
		hostUserId = stageData.hostUserId,
		hostName = stageData.hostName,
		groupName = stageData.groupName,
		questionLevel = stageData.questionLevel,
		questionTopic = stageData.questionTopic,
		questionType = stageData.questionTypeLabel,
		questionTypeLabel = stageData.questionTypeLabel,
		stageInfoText = stageData.stageInfoText or buildGroupStageInfoText(stageData),
		stageDisplayText = stageData.stageDisplayText or stageData.stageInfoText or buildGroupStageInfoText(stageData),
		source = stageData.source,
		location = stageData.location,
		towerLevel = stageData.towerLevel,
		privacy = stageData.privacy,
		invitedUserIds = invitedUserIds,
		problemText = stageData.problemText or stageData.stageDisplayText or stageData.stageInfoText,
		layout = stageData.layout,
		attendantSeats = stageData.attendantSeats or {},
		spectatable = true,
		visualOptInRequired = true,
		showVisuals = showVisuals == true,
		createdAt = stageData.createdAt,
	}

	if extra then
		for key, value in pairs(extra) do
			payload[key] = value
		end
	end

	return payload
end


-- ============================================================
-- [ GET GROUP STAGE ]
-- Finds an active Community or Playground group stage by id.
-- ============================================================

local function getGroupStage(stageId)
	return activeGroupStages[tostring(stageId or "")]
end


-- ============================================================
-- [ GET GROUP STAGE INFO POSITION ]
-- Reads the world position used for near-stage info prompts.
-- ============================================================

local function getGroupStageInfoPosition(stageData)
	local layout = stageData and stageData.layout
	local stageCFrame = layout and layout.stageCFrame

	if stageCFrame then
		return stageCFrame.Position
	end

	return nil
end


-- ============================================================
-- [ SET GROUP STAGE NEARBY INFO ]
-- Tells one player when they enter or leave a stage info radius.
-- ============================================================

local function setGroupStageNearbyInfo(player, stageData, isNearby)
	if not player or not stageData then
		return
	end

	local stageId = stageData.stageId
	groupStageNearbyPlayers[stageId] = groupStageNearbyPlayers[stageId] or {}

	if isNearby then
		if groupStageNearbyPlayers[stageId][player.UserId] then
			return
		end

		groupStageNearbyPlayers[stageId][player.UserId] = true
		firePlayerRemoteEvent(player, "GroupStageInfoShown", getGroupStagePayload(stageData, false, {
			nearby = true,
			infoRadius = GROUP_STAGE_INFO_RADIUS,
		}))
		return
	end

	if not groupStageNearbyPlayers[stageId][player.UserId] then
		return
	end

	groupStageNearbyPlayers[stageId][player.UserId] = nil
	firePlayerRemoteEvent(player, "GroupStageInfoHidden", {
		stageId = stageId,
		nearby = false,
		showVisuals = false,
	})
end


-- ============================================================
-- [ ENSURE GROUP STAGE INFO TRACKER ]
-- Watches player distance and shows stage info when they walk nearby.
-- ============================================================

local function ensureGroupStageInfoTracker()
	if groupStageInfoTrackerRunning then
		return
	end

	groupStageInfoTrackerRunning = true
	task.spawn(function()
		while groupStageInfoTrackerRunning do
			for _, stageData in pairs(activeGroupStages) do
				local infoPosition = getGroupStageInfoPosition(stageData)

				if infoPosition then
					for _, player in ipairs(Players:GetPlayers()) do
						local rootPart = getPlayerRootPart(player)
						local isNearby = false

						if rootPart then
							isNearby = (rootPart.Position - infoPosition).Magnitude <= GROUP_STAGE_INFO_RADIUS
						end

						setGroupStageNearbyInfo(player, stageData, isNearby)
					end
				end
			end

			task.wait(GROUP_STAGE_INFO_CHECK_INTERVAL)
		end
	end)
end


-- ============================================================
-- [ NOTIFY GROUP STAGE ACCESS DENIED ]
-- Tells one client why a group stage action was rejected.
-- ============================================================

local function notifyGroupStageAccessDenied(player, reason, payload)
	local data = payload or {}
	data.reason = reason
	firePlayerRemoteEvent(player, "GroupStageAccessDenied", data)
end


-- ============================================================
-- [ ENSURE GROUP ACTIVITY REMOTES ]
-- Creates server/client remotes for group creation, joining, and spectating.
-- ============================================================

local function ensureGroupActivityRemotes()
	for _, eventName in ipairs(GROUP_STAGE_REMOTE_EVENTS) do
		getRemoteEvent(eventName, true)
	end

	ensureGroupStageInfoTracker()

	if not groupStageCreateRemoteConnected then
		local createEvent = getRemoteEvent(GROUP_STAGE_CREATE_REMOTE, true)
		if createEvent then
			createEvent.OnServerEvent:Connect(function(player, request)
				if type(request) ~= "table" then
					request = {}
				end

					createGroupStage(
						player,
						request.location or request.targetLocation or request.source,
						request.towerLevel,
						request.groupName or request.stageName or request.name,
						request
					)
				end)
			groupStageCreateRemoteConnected = true
		end
	end

	if not groupStageJoinRemoteConnected then
		local joinEvent = getRemoteEvent(GROUP_STAGE_JOIN_REMOTE, true)
		if joinEvent then
			joinEvent.OnServerEvent:Connect(function(player, stageId)
				joinGroupStage(player, stageId)
			end)
			groupStageJoinRemoteConnected = true
		end
	end

	if not groupStagePrivacyRemoteConnected then
		local privacyEvent = getRemoteEvent(GROUP_STAGE_PRIVACY_REMOTE, true)
		if privacyEvent then
			privacyEvent.OnServerEvent:Connect(function(player, stageId, privacy, invitedUserIds)
				setGroupStagePrivacy(player, stageId, privacy, invitedUserIds)
			end)
			groupStagePrivacyRemoteConnected = true
		end
	end

	if not groupStageSpectateRemoteConnected then
		local spectateEvent = getRemoteEvent(GROUP_STAGE_SPECTATE_REMOTE, true)
		if spectateEvent then
			spectateEvent.OnServerEvent:Connect(function(player, stageId, shouldSpectate)
				setGroupStageSpectating(player, stageId, shouldSpectate ~= false)
			end)
			groupStageSpectateRemoteConnected = true
		end
	end
end


-- ============================================================
-- [ GET PLAYER EXPERIENCE CAP ]
-- Gets the XP cap before the next up-level test is passed.
-- ============================================================

local function getPlayerExperienceCap(player)
	local unlockedLevel = getPlayerUnlockedTowerLevel(player)
	local config = TowerLevelRequirements[unlockedLevel]

	if not config or not config.nextLevel or not config.nextLevelRequiredXP then
		return nil, nil, unlockedLevel
	end

	return config.nextLevelRequiredXP, config.nextLevel, unlockedLevel
end


-- ============================================================
-- [ NOTIFY EXPERIENCE CAPPED ]
-- Tells the client that XP is paused until the up-level test is passed.
-- ============================================================

local function notifyExperienceCapped(player, nextLevel, requiredXP, currentXP)
	firePlayerRemoteEvent(player, "ExperienceCapped", {
		nextTowerLevel = nextLevel,
		requiredXP = requiredXP,
		currentXP = currentXP,
	})
end


-- ============================================================
-- [ NOTIFY UP-LEVEL TEST READY ]
-- Tells the client the player can attempt the next up-level test.
-- ============================================================

notifyUpLevelTestReady = function(player, nextLevel, requiredXP, currentXP)
	firePlayerRemoteEvent(player, "UpLevelTestReady", {
		nextTowerLevel = nextLevel,
		requiredXP = requiredXP,
		currentXP = currentXP,
	})
end


-- ============================================================
-- [ AWARD EXPERIENCE ]
-- Adds XP, capped at the next up-level test requirement.
-- ============================================================

awardExperience = function(player, amount)
	local gain = math.max(0, math.floor(tonumber(amount) or 0))
	local currentXP = getPlayerExperience(player)
	local capXP, nextLevel = getPlayerExperienceCap(player)
	local targetXP = currentXP + gain
	local capped = false

	if gain > 0 and capXP and targetXP >= capXP then
		targetXP = capXP
		capped = true
	end

	local newXP = setPlayerExperience(player, targetXP)
	local highestUnlocked = getHighestUnlockedTowerLevel(player)

	if capped and nextLevel then
		notifyExperienceCapped(player, nextLevel, capXP, newXP)
		notifyUpLevelTestReady(player, nextLevel, capXP, newXP)
	end

	return newXP, highestUnlocked, capped, nextLevel, capXP
end


-- ============================================================
-- [ TELEPORT PLAYER TO PLACE ]
-- Sends one player to another Roblox place/server.
-- ============================================================

local function teleportPlayerToPlace(player, placeId, teleportData)
	if not placeId or placeId == 0 then
		warn(("Missing placeId for %s"):format(player.Name))
		return false, "MissingPlaceId"
	end

	local teleportOptions = Instance.new("TeleportOptions")
	teleportOptions:SetTeleportData(teleportData or {})

	local ok, err = pcall(function()
		TeleportService:TeleportAsync(placeId, { player }, teleportOptions)
	end)

	if not ok then
		warn(("Teleport failed for %s: %s"):format(player.Name, tostring(err)))
		return false, err
	end

	return true, "TeleportStarted"
end


-- ============================================================
-- [ ROUTE LOBBY TOWER PORTAL ]
-- Sends the player from the home lobby to their current Tower level.
-- ============================================================

local function routeLobbyTowerPortal(player)
	local currentTowerLevel = getHighestUnlockedTowerLevel(player)
	local allowed, reason, requiredXP, currentXP, unlockedLevel = canEnterTowerLevel(player, currentTowerLevel)

	if not allowed then
		if reason == "NotEnoughXP" then
			firePlayerRemoteEvent(player, "TowerAccessDenied", {
				towerLevel = currentTowerLevel,
				requiredXP = requiredXP,
				currentXP = currentXP,
			})
		elseif reason == "UpLevelTestRequired" then
			notifyUpLevelTestReady(player, currentTowerLevel, requiredXP, currentXP)
		end
		return false, reason, requiredXP, currentXP, unlockedLevel
	end

	local config = TowerLevelRequirements[currentTowerLevel]
	return teleportPlayerToPlace(player, config.placeId, {
		destination = "TowerLevel",
		source = "LobbyTowerPortal",
		towerLevel = currentTowerLevel,
		currentTowerLevel = currentTowerLevel,
		highestUnlockedTowerLevel = unlockedLevel,
		requiredXP = requiredXP,
		currentXP = currentXP,
	})
end


-- ============================================================
-- [ ROUTE LOBBY PORTAL ]
-- Handles lobby portals for game modes and the Tower entrance.
-- ============================================================

local function routeLobbyPortal(player, portalName)
	local route = LobbyPortalRoutes[portalName]
	if not route then
		return false, "UnknownPortal"
	end

	if route.kind == "GameMode" then
		if route.placeId and route.placeId ~= 0 then
			return teleportPlayerToPlace(player, route.placeId, {
				destination = route.mode,
				source = "LobbyPortal",
			})
		end

		startGameMode(player, route.mode)
		return true, "StartedGameMode"
	end

	if route.kind == "PlaygroundGroup" then
		return createGroupStage(player, GROUP_STAGE_LOCATIONS.Playground, nil, player.Name .. "'s Group", {
			privacy = GROUP_STAGE_PRIVACY.Public,
		})
	end

	if route.kind == "TowerCurrentLevel" then
		return routeLobbyTowerPortal(player)
	end

	return false, "UnknownRouteKind"
end


-- ============================================================
-- [ NOTIFY TOWER ACCESS DENIED ]
-- Tells the client that a Tower level is locked.
-- ============================================================

notifyTowerAccessDenied = function(player, towerLevel, requiredXP, currentXP)
	firePlayerRemoteEvent(player, "TowerAccessDenied", {
		towerLevel = towerLevel,
		requiredXP = requiredXP,
		currentXP = currentXP,
	})
end


-- ============================================================
-- [ ROUTE TOWER LEVEL PORTAL ]
-- Checks unlock state, then teleports the player to a Tower level.
-- ============================================================

local function routeTowerLevelPortal(player, towerLevel)
	local allowed, reason, requiredXP, currentXP = canEnterTowerLevel(player, towerLevel)
	if not allowed then
		if reason == "NotEnoughXP" then
			notifyTowerAccessDenied(player, towerLevel, requiredXP, currentXP)
		elseif reason == "UpLevelTestRequired" then
			notifyUpLevelTestReady(player, towerLevel, requiredXP, currentXP)
		end
		return false, reason, requiredXP, currentXP
	end

	local config = TowerLevelRequirements[towerLevel]
	return teleportPlayerToPlace(player, config.placeId, {
		destination = "TowerLevel",
		towerLevel = towerLevel,
		requiredXP = requiredXP,
		currentXP = currentXP,
	})
end


-- ============================================================
-- [ ROUTE TOWER LEVEL ARENA ]
-- Starts the free-for-all arena for players in the current level server.
-- ============================================================

local function routeTowerLevelArena(player, towerLevel)
	local allowed, reason, requiredXP, currentXP = canEnterTowerLevel(player, towerLevel)
	if not allowed then
		if reason == "NotEnoughXP" then
			notifyTowerAccessDenied(player, towerLevel, requiredXP, currentXP)
		elseif reason == "UpLevelTestRequired" then
			notifyUpLevelTestReady(player, towerLevel, requiredXP, currentXP)
		end
		return false, reason, requiredXP, currentXP
	end

	startGameMode(player, "Arena", {
		source = TowerLevelAreas.Arena,
		towerLevel = towerLevel,
		serverOnly = true,
		oneArenaPerTowerLevel = true,
		largeQuestionProjection = true,
		visibleToEntireLevelServer = true,
		visualOptInRequired = false,
		spectateRequired = false,
		showVisuals = true,
	})

	return true, "StartedTowerArena"
end


-- ============================================================
-- [ ROUTE TOWER LEVEL DUNGEON ]
-- Sends the player to the dungeon that belongs to this Tower level.
-- ============================================================

local function routeTowerLevelDungeon(player, towerLevel)
	local allowed, reason, requiredXP, currentXP = canEnterTowerLevel(player, towerLevel)
	if not allowed then
		if reason == "NotEnoughXP" then
			notifyTowerAccessDenied(player, towerLevel, requiredXP, currentXP)
		elseif reason == "UpLevelTestRequired" then
			notifyUpLevelTestReady(player, towerLevel, requiredXP, currentXP)
		end
		return false, reason, requiredXP, currentXP
	end

	local config = TowerLevelRequirements[towerLevel]
	return teleportPlayerToPlace(player, config.dungeonPlaceId, {
		destination = "TowerDungeon",
		source = TowerLevelAreas.DungeonTeleport,
		towerLevel = towerLevel,
		requiredXP = requiredXP,
		currentXP = currentXP,
	})
end


-- ============================================================
-- [ ROUTE TOWER LEVEL TRAVEL ]
-- Teleports between unlocked Tower level servers.
-- ============================================================

local function routeTowerLevelTravel(player, destinationTowerLevel)
	local allowed, reason, requiredXP, currentXP = canEnterTowerLevel(player, destinationTowerLevel)
	if not allowed then
		if reason == "NotEnoughXP" then
			notifyTowerAccessDenied(player, destinationTowerLevel, requiredXP, currentXP)
		elseif reason == "UpLevelTestRequired" then
			notifyUpLevelTestReady(player, destinationTowerLevel, requiredXP, currentXP)
		end
		return false, reason, requiredXP, currentXP
	end

	local config = TowerLevelRequirements[destinationTowerLevel]
	return teleportPlayerToPlace(player, config.placeId, {
		destination = "TowerLevel",
		source = TowerLevelAreas.SpawnTeleport,
		towerLevel = destinationTowerLevel,
		requiredXP = requiredXP,
		currentXP = currentXP,
	})
end


-- ============================================================
-- [ ROUTE TOWER LEVEL COMMUNITY ]
-- Enters the social/economy area inside the current Tower level server.
-- ============================================================

local function routeTowerLevelCommunity(player, towerLevel)
	local allowed, reason, requiredXP, currentXP = canEnterTowerLevel(player, towerLevel)
	if not allowed then
		if reason == "NotEnoughXP" then
			notifyTowerAccessDenied(player, towerLevel, requiredXP, currentXP)
		elseif reason == "UpLevelTestRequired" then
			notifyUpLevelTestReady(player, towerLevel, requiredXP, currentXP)
		end
		return false, reason, requiredXP, currentXP
	end

	firePlayerRemoteEvent(player, "TowerCommunityEntered", {
		source = TowerLevelAreas.Community,
		towerLevel = towerLevel,
		requiredXP = requiredXP,
		currentXP = currentXP,
	})

	return true, "EnteredTowerCommunity"
end


-- ============================================================
-- [ RENT OR BUY COMMUNITY HOUSE ]
-- Reserves a level-specific Community house for a player.
-- ============================================================

local function rentOrBuyCommunityHouse(player, towerLevel, houseId, action)
	local allowed, reason, requiredXP, currentXP = canEnterTowerLevel(player, towerLevel)
	if not allowed then
		if reason == "NotEnoughXP" then
			notifyTowerAccessDenied(player, towerLevel, requiredXP, currentXP)
		elseif reason == "UpLevelTestRequired" then
			notifyUpLevelTestReady(player, towerLevel, requiredXP, currentXP)
		end
		return false, reason, requiredXP, currentXP
	end

	if action ~= COMMUNITY_HOUSE_ACTIONS.Buy and action ~= COMMUNITY_HOUSE_ACTIONS.Rent then
		return false, "UnknownHouseAction", houseId, action
	end

	local reservation = {
		userId = player.UserId,
		towerLevel = towerLevel,
		houseId = houseId,
		action = action,
		source = TowerLevelAreas.Community,
	}

	-- TODO: check availability, price, rental duration, and persistence.
	return true, "CommunityHouseReserved", reservation
end


-- ============================================================
-- [ CREATE GROUP STAGE ID ]
-- Builds a unique id for Community and Playground group activities.
-- ============================================================

local function createGroupStageId(location, towerLevel, player)
	local levelKey = math.floor(tonumber(towerLevel) or 0)
	return ("%s:%d:%d:%d"):format(location, levelKey, player.UserId, math.floor(os.clock() * 1000))
end


-- ============================================================
-- [ CREATE GROUP STAGE LAYOUT ]
-- Builds local-render data for the stage, problem board, and chairs.
-- ============================================================

local function createGroupStageLayout(location, towerLevel)
	local levelOffset = math.max(0, (math.floor(tonumber(towerLevel) or 1) - 1) * 80)
	local basePosition = Vector3.new(0, 1, 160 + levelOffset)

	if location == GROUP_STAGE_LOCATIONS.Playground then
		basePosition = Vector3.new(0, 1, 72)
	end

	local stageCFrame = CFrame.new(basePosition)
	local boardCFrame = CFrame.new(basePosition + Vector3.new(0, 5, -7))
	local attendantSeats = {}
	local seatCount = GROUP_STAGE_DEFAULT_SEAT_COUNT
	local startX = -((seatCount - 1) * 4) / 2

	for index = 1, seatCount do
		table.insert(attendantSeats, {
			seatId = "Seat_" .. tostring(index),
			cframe = CFrame.new(basePosition + Vector3.new(startX + ((index - 1) * 4), 1, 10)),
		})
	end

	return {
		stageCFrame = stageCFrame,
		stageSize = Vector3.new(28, 1.5, 14),
		problemDisplayCFrame = boardCFrame,
		problemDisplaySize = Vector3.new(18, 8, 1),
		attendantSeats = attendantSeats,
	}
end


-- ============================================================
-- [ CREATE GROUP STAGE ]
-- Creates a Group mode stage in a Tower Community or the home Playground.
-- ============================================================

createGroupStage = function(player, location, towerLevel, groupName, options)
	options = options or {}
	if type(location) == "table" then
		options = location
		location = options.location or options.targetLocation or options.source
		towerLevel = options.towerLevel
		groupName = options.groupName or options.stageName or options.name
	elseif type(groupName) == "table" then
		options = groupName
		groupName = options.groupName or options.stageName or options.name
	end

	ensureGroupActivityRemotes()

	local stageLocation = normalizeGroupStageLocation(location)
	local hasBattlepass = playerHasBattlepass(player)
	local requestedPrivacy = normalizeGroupStagePrivacy(options.privacy)
	local privacy = GROUP_STAGE_PRIVACY.Public
	local invitedUserIds = {}
	local invitedUserIdMap = {}
	local stageTowerLevel = nil
	local requiredXP = nil
	local currentXP = getPlayerExperience(player)

	if stageLocation == GROUP_STAGE_LOCATIONS.Playground and not hasBattlepass then
		notifyGroupStageAccessDenied(player, "BattlepassRequiredForPlayground", {
			location = stageLocation,
		})
		return false, "BattlepassRequiredForPlayground"
	end

	if requestedPrivacy == GROUP_STAGE_PRIVACY.InviteOnly then
		if not hasBattlepass then
			notifyGroupStageAccessDenied(player, "BattlepassRequiredForInviteOnly", {
				location = stageLocation,
				towerLevel = towerLevel,
			})
			return false, "BattlepassRequiredForInviteOnly"
		end

		privacy = GROUP_STAGE_PRIVACY.InviteOnly
		invitedUserIds, invitedUserIdMap = sanitizeInvitedUserIds(player, options.invitedUserIds)
	end

	if stageLocation == GROUP_STAGE_LOCATIONS.Community then
		stageTowerLevel = math.floor(tonumber(towerLevel or options.towerLevel or getHighestUnlockedTowerLevel(player)) or DEFAULT_UNLOCKED_TOWER_LEVEL)
		local allowed, reason, levelRequiredXP, levelCurrentXP = canEnterTowerLevel(player, stageTowerLevel)
		requiredXP = levelRequiredXP
		currentXP = levelCurrentXP

		if not allowed then
			if reason == "NotEnoughXP" then
				notifyTowerAccessDenied(player, stageTowerLevel, requiredXP, currentXP)
			elseif reason == "UpLevelTestRequired" then
				notifyUpLevelTestReady(player, stageTowerLevel, requiredXP, currentXP)
			end
			return false, reason, requiredXP, currentXP
		end
	end

	local normalizedGroupName = normalizeGroupStageName(player, groupName or options.groupName or options.stageName or options.name)
	local questionType = normalizeGroupStageQuestionType(options, stageTowerLevel)
	local stageInfoText = ("%s\n%s"):format(normalizedGroupName, questionType.label)
	local layout = createGroupStageLayout(stageLocation, stageTowerLevel)
	local stageId = createGroupStageId(stageLocation, stageTowerLevel, player)
	local stageData = {
		stageId = stageId,
		hostUserId = player.UserId,
		hostName = player.Name,
		groupName = normalizedGroupName,
		questionLevel = questionType.level,
		questionTopic = questionType.topic,
		questionTypeLabel = questionType.label,
		stageInfoText = stageInfoText,
		stageDisplayText = stageInfoText,
		source = stageLocation,
		location = stageLocation,
		towerLevel = stageTowerLevel,
		requiredXP = requiredXP,
		currentXP = currentXP,
		privacy = privacy,
		invitedUserIds = invitedUserIds,
		invitedUserIdMap = invitedUserIdMap,
		problemText = stageInfoText,
		layout = layout,
		attendantSeats = layout.attendantSeats,
		spectatable = true,
		visualOptInRequired = true,
		createdAt = os.time(),
	}

	activeGroupStages[stageId] = stageData
	if stageLocation == GROUP_STAGE_LOCATIONS.Playground then
		playgroundGroupStages[stageId] = stageData
	else
		communityGroupStages[stageId] = stageData
	end

	fireAllClientsRemoteEvent("GroupActivityAvailable", getGroupStagePayload(stageData, false, {
		availabilityOnly = true,
	}))
	firePlayerRemoteEvent(player, "GroupStageCreated", getGroupStagePayload(stageData, true, {
		participant = true,
	}))

	startGameMode(player, "Group", {
		source = stageLocation,
		towerLevel = stageTowerLevel,
		stageId = stageId,
		physicalStage = true,
		spectatable = true,
		visualOptInRequired = true,
		showVisuals = true,
		privacy = privacy,
		invitedUserIds = invitedUserIds,
		groupName = stageData.groupName,
		questionLevel = stageData.questionLevel,
		questionTopic = stageData.questionTopic,
		questionTypeLabel = stageData.questionTypeLabel,
		stageInfoText = stageData.stageInfoText,
		stageDisplayText = stageData.stageDisplayText,
	})

	local createdReason = stageLocation == GROUP_STAGE_LOCATIONS.Playground
		and "PlaygroundGroupStageCreated"
		or "CommunityGroupStageCreated"
	return true, createdReason, stageData
end


-- ============================================================
-- [ CREATE COMMUNITY GROUP STAGE ]
-- Lets any eligible player place a public Group stage in a Tower level Community.
-- ============================================================

local function createCommunityGroupStage(player, towerLevel, groupName, options)
	return createGroupStage(player, GROUP_STAGE_LOCATIONS.Community, towerLevel, groupName, options)
end


-- ============================================================
-- [ CREATE PLAYGROUND GROUP STAGE ]
-- Lets Battlepass players place a Group stage in the home Playground.
-- ============================================================

local function createPlaygroundGroupStage(player, groupName, options)
	return createGroupStage(player, GROUP_STAGE_LOCATIONS.Playground, nil, groupName, options)
end


-- ============================================================
-- [ CAN JOIN GROUP STAGE ]
-- Enforces public vs invite-only join rules for Group activities.
-- ============================================================

local function canJoinGroupStage(player, stageId)
	local stageData = getGroupStage(stageId)
	if not stageData then
		return false, "UnknownGroupStage"
	end

	if stageData.privacy == GROUP_STAGE_PRIVACY.Public then
		return true, "Public", stageData
	end

	if player.UserId == stageData.hostUserId then
		return true, "Host", stageData
	end

	if stageData.invitedUserIdMap and stageData.invitedUserIdMap[player.UserId] then
		return true, "Invited", stageData
	end

	return false, "InviteOnly", stageData
end


-- ============================================================
-- [ JOIN GROUP STAGE ]
-- Starts Group mode for a player if the stage join rules allow it.
-- ============================================================

joinGroupStage = function(player, stageId)
	ensureGroupActivityRemotes()

	local allowed, reason, stageData = canJoinGroupStage(player, stageId)
	if not allowed then
		firePlayerRemoteEvent(player, "GroupStageJoinDenied", {
			stageId = tostring(stageId or ""),
			reason = reason,
		})
		return false, reason
	end

	firePlayerRemoteEvent(player, "GroupStageJoinAllowed", getGroupStagePayload(stageData, true, {
		participant = true,
		joinReason = reason,
	}))

	startGameMode(player, "Group", {
		source = stageData.source,
		towerLevel = stageData.towerLevel,
		stageId = stageData.stageId,
		physicalStage = true,
		spectatable = true,
		visualOptInRequired = true,
		showVisuals = true,
		privacy = stageData.privacy,
		groupName = stageData.groupName,
		questionLevel = stageData.questionLevel,
		questionTopic = stageData.questionTopic,
		questionTypeLabel = stageData.questionTypeLabel,
		stageInfoText = stageData.stageInfoText,
		stageDisplayText = stageData.stageDisplayText,
	})

	return true, "JoinedGroupStage", stageData
end


-- ============================================================
-- [ SET GROUP STAGE PRIVACY ]
-- Lets a Battlepass host switch a Group stage between public and invite-only.
-- ============================================================

setGroupStagePrivacy = function(player, stageId, privacy, invitedUserIds)
	ensureGroupActivityRemotes()

	local normalizedStageId = tostring(stageId or "")
	local stageData = getGroupStage(normalizedStageId)
	if not stageData then
		notifyGroupStageAccessDenied(player, "UnknownGroupStage", {
			stageId = normalizedStageId,
		})
		return false, "UnknownGroupStage"
	end

	if stageData.hostUserId ~= player.UserId then
		notifyGroupStageAccessDenied(player, "OnlyHostCanChangePrivacy", {
			stageId = normalizedStageId,
		})
		return false, "OnlyHostCanChangePrivacy", stageData
	end

	if not playerHasBattlepass(player) then
		notifyGroupStageAccessDenied(player, "BattlepassRequiredForPrivacyControl", {
			stageId = normalizedStageId,
		})
		return false, "BattlepassRequiredForPrivacyControl", stageData
	end

	local requestedPrivacy = normalizeGroupStagePrivacy(privacy)
	stageData.privacy = requestedPrivacy

	if requestedPrivacy == GROUP_STAGE_PRIVACY.InviteOnly then
		stageData.invitedUserIds, stageData.invitedUserIdMap = sanitizeInvitedUserIds(player, invitedUserIds)
	else
		stageData.invitedUserIds = {}
		stageData.invitedUserIdMap = {}
	end

	fireAllClientsRemoteEvent("GroupActivityAvailable", getGroupStagePayload(stageData, false, {
		availabilityOnly = true,
		privacyChanged = true,
	}))
	firePlayerRemoteEvent(player, "GroupStagePrivacyChanged", getGroupStagePayload(stageData, true, {
		participant = true,
	}))

	return true, "GroupStagePrivacyChanged", stageData
end


-- ============================================================
-- [ SET GROUP STAGE SPECTATING ]
-- Shows or hides a group activity's visuals for one spectating player.
-- ============================================================

setGroupStageSpectating = function(player, stageId, shouldSpectate)
	ensureGroupActivityRemotes()

	local normalizedStageId = tostring(stageId or "")
	local stageData = getGroupStage(normalizedStageId)
	if not stageData then
		firePlayerRemoteEvent(player, "GroupStageSpectateEnded", {
			stageId = normalizedStageId,
			reason = "UnknownGroupStage",
			showVisuals = false,
		})
		return false, "UnknownGroupStage"
	end

	groupStageSpectators[normalizedStageId] = groupStageSpectators[normalizedStageId] or {}

	if shouldSpectate == false then
		groupStageSpectators[normalizedStageId][player.UserId] = nil
		firePlayerRemoteEvent(player, "GroupStageSpectateEnded", getGroupStagePayload(stageData, false, {
			spectating = false,
		}))
		return true, "StoppedSpectating", stageData
	end

	groupStageSpectators[normalizedStageId][player.UserId] = true
	firePlayerRemoteEvent(player, "GroupStageSpectateStarted", getGroupStagePayload(stageData, true, {
		spectating = true,
	}))
	return true, "StartedSpectating", stageData
end


-- ============================================================
-- [ REMOVE GROUP STAGE ]
-- Clears a hosted activity and tells clients to remove any opted-in visuals.
-- ============================================================

local function removeGroupStage(stageId, reason)
	local normalizedStageId = tostring(stageId or "")
	if normalizedStageId == "" then
		return false, "MissingStageId"
	end

	activeGroupStages[normalizedStageId] = nil
	communityGroupStages[normalizedStageId] = nil
	playgroundGroupStages[normalizedStageId] = nil
	groupStageSpectators[normalizedStageId] = nil
	groupStageNearbyPlayers[normalizedStageId] = nil

	fireAllClientsRemoteEvent("GroupActivityRemoved", {
		stageId = normalizedStageId,
		reason = reason or "Removed",
		showVisuals = false,
	})

	return true, "GroupStageRemoved"
end


-- ============================================================
-- [ CLEAR PLAYER GROUP STAGE PRESENCE ]
-- Removes hosted group stages and spectate state when a player leaves.
-- ============================================================

local function clearPlayerGroupStagePresence(player)
	local hostedStageIds = {}

	for stageId, stageData in pairs(activeGroupStages) do
		if stageData.hostUserId == player.UserId then
			table.insert(hostedStageIds, stageId)
		end
	end

	for _, stageId in ipairs(hostedStageIds) do
		removeGroupStage(stageId, "HostLeft")
	end

	for _, spectatorMap in pairs(groupStageSpectators) do
		spectatorMap[player.UserId] = nil
	end

	for _, nearbyMap in pairs(groupStageNearbyPlayers) do
		nearbyMap[player.UserId] = nil
	end
end

Players.PlayerRemoving:Connect(clearPlayerGroupStagePresence)


-- ============================================================
-- [ INITIALIZE GROUP ACTIVITY REMOTES ]
-- Makes create/join/spectate remotes available as soon as the server starts.
-- ============================================================

ensureGroupActivityRemotes()


-- ============================================================
-- [ CAN ATTEMPT UP-LEVEL TEST ]
-- Checks whether the player is ready to test into the next level.
-- ============================================================

local function canAttemptUpLevelTest(player, towerLevel)
	local config = TowerLevelRequirements[towerLevel]
	local currentXP = getPlayerExperience(player)
	local unlockedLevel = getPlayerUnlockedTowerLevel(player)

	if not config then
		return false, "UnknownLevel", nil, 0, currentXP, unlockedLevel
	end

	if not config.nextLevel then
		return false, "NoNextLevel", nil, config.requiredXP, currentXP, unlockedLevel
	end

	if towerLevel < unlockedLevel then
		return false, "AlreadyUnlocked", config.nextLevel, config.nextLevelRequiredXP, currentXP, unlockedLevel
	end

	if towerLevel > unlockedLevel then
		return false, "LevelLocked", config.nextLevel, config.nextLevelRequiredXP, currentXP, unlockedLevel
	end

	if currentXP < config.nextLevelRequiredXP then
		return false, "NotEnoughXP", config.nextLevel, config.nextLevelRequiredXP, currentXP, unlockedLevel
	end

	return true, "Ready", config.nextLevel, config.nextLevelRequiredXP, currentXP, unlockedLevel
end


-- ============================================================
-- [ START UP-LEVEL TEST ]
-- Starts the solo timed boss-fight test fallback.
-- ============================================================

local function startUpLevelTest(player, towerLevel, nextLevel)
	return startGameMode(player, "UpLevelTest", {
		source = UP_LEVEL_TEST_ENTRY_SOURCE,
		towerLevel = towerLevel,
		nextTowerLevel = nextLevel,
		solo = true,
		timed = true,
		arenaStructure = true,
		bossFight = true,
	})
end


-- ============================================================
-- [ COMPLETE UP-LEVEL TEST ]
-- Unlocks the next Tower level when the test is passed.
-- ============================================================

local function completeUpLevelTest(player, towerLevel, passed)
	if not passed then
		return false, "TestFailed"
	end

	local allowed, reason, nextLevel, requiredXP, currentXP = canAttemptUpLevelTest(player, towerLevel)
	if not allowed then
		return false, reason, nextLevel, requiredXP, currentXP
	end

	local unlockedLevel = setPlayerUnlockedTowerLevel(player, nextLevel)
	return true, "NextLevelUnlocked", unlockedLevel, requiredXP, currentXP
end


-- ============================================================
-- [ UP-LEVEL BOSS FIGHT TEST ]
-- Solo timed trivia fight: correct answers damage the boss, while
-- wrong answers and expired timers damage the player. Passing requires
-- depleting the boss health bar.
-- ============================================================

local UP_LEVEL_BOSS_ANSWER_REMOTE = "UpLevelBossFightAnswerSelected"
local UP_LEVEL_BOSS_REMOTE_EVENTS = {
	"UpLevelBossFightStarted",
	"UpLevelBossFightQuestion",
	"UpLevelBossFightState",
	"UpLevelBossFightEnded",
	UP_LEVEL_BOSS_ANSWER_REMOTE,
}

local UpLevelBossFightConfig = {
	BossMaxHealth = 100,
	PlayerMaxHealth = 100,
	BossDamagePerCorrectAnswer = 25,
	PlayerDamagePerMiss = 25,
	QuestionSeconds = 15,
	InterRoundSeconds = 1.25,
	CleanupSeconds = 4,
	AnswerPadSpacing = 4.25,
	AnswerPadArmingSeconds = 0.25,
}

local UpLevelBossFightQuestions = {
	{
		question = "What is 8 + 7?",
		answers = { "13", "14", "15", "16" },
		correct = "15",
	},
	{
		question = "Which planet is known as the Red Planet?",
		answers = { "Venus", "Mars", "Jupiter", "Mercury" },
		correct = "Mars",
	},
	{
		question = "What is the capital of Thailand?",
		answers = { "Bangkok", "Chiang Mai", "Phuket", "Pattaya" },
		correct = "Bangkok",
	},
	{
		question = "How many degrees are in a right angle?",
		answers = { "45", "60", "90", "180" },
		correct = "90",
	},
}

local upLevelBossFightState = {}
local upLevelAnswerRemoteConnected = false

local submitUpLevelBossAnswer
local presentUpLevelBossQuestion
local resolveUpLevelBossRound
local finishUpLevelBossFight

local function waitForPlayerRootPart(player, timeoutSeconds)
	local startedAt = os.clock()
	repeat
		local root = getPlayerRootPart(player)
		if root then
			return root
		end
		task.wait(0.1)
	until os.clock() - startedAt >= timeoutSeconds

	return nil
end

local function createHealthBillboard(parent, name, title, fillColor, studsOffset)
	local gui = Instance.new("BillboardGui")
	gui.Name = name
	gui.Size = UDim2.new(0, 190, 0, 54)
	gui.StudsOffset = studsOffset or Vector3.new(0, 5, 0)
	gui.AlwaysOnTop = true
	gui.Parent = parent

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, 0, 0, 22)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.TextColor3 = Color3.new(1, 1, 1)
	titleLabel.TextScaled = true
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Parent = gui

	local barBack = Instance.new("Frame")
	barBack.Name = "BarBack"
	barBack.Position = UDim2.new(0.05, 0, 0, 28)
	barBack.Size = UDim2.new(0.9, 0, 0, 16)
	barBack.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	barBack.BorderSizePixel = 0
	barBack.Parent = gui

	local barFill = Instance.new("Frame")
	barFill.Name = "BarFill"
	barFill.Size = UDim2.new(1, 0, 1, 0)
	barFill.BackgroundColor3 = fillColor
	barFill.BorderSizePixel = 0
	barFill.Parent = barBack

	return {
		gui = gui,
		titleLabel = titleLabel,
		barFill = barFill,
	}
end

local function setHealthBillboard(bar, title, currentHealth, maxHealth)
	if not bar then
		return
	end

	local ratio = 0
	if maxHealth > 0 then
		ratio = math.clamp(currentHealth / maxHealth, 0, 1)
	end

	bar.titleLabel.Text = ("%s %d/%d"):format(title, math.max(0, math.ceil(currentHealth)), maxHealth)
	bar.barFill.Size = UDim2.new(ratio, 0, 1, 0)
end

local function clearUpLevelAnswerPads(state)
	for _, pad in ipairs(state.answerPads or {}) do
		if pad and pad.Parent then
			pad:Destroy()
		end
	end
	state.answerPads = {}
end

local function destroyUpLevelBossFightVisuals(state)
	clearUpLevelAnswerPads(state)

	if state.arenaFolder and state.arenaFolder.Parent then
		state.arenaFolder:Destroy()
	end

	if state.playerHealthGui and state.playerHealthGui.gui and state.playerHealthGui.gui.Parent then
		state.playerHealthGui.gui:Destroy()
	end
end

local function getUpLevelPayload(state, extra)
	local payload = {
		towerLevel = state.towerLevel,
		nextTowerLevel = state.nextTowerLevel,
		bossHealth = state.bossHealth,
		bossMaxHealth = state.bossMaxHealth,
		playerHealth = state.playerHealth,
		playerMaxHealth = state.playerMaxHealth,
		questionId = state.questionId,
		timeRemaining = math.max(0, math.ceil(state.timeRemaining or 0)),
	}

	if state.currentQuestion then
		payload.question = state.currentQuestion.question
		payload.answers = state.currentQuestion.answers
	end

	if extra then
		for key, value in pairs(extra) do
			payload[key] = value
		end
	end

	return payload
end

local function updateUpLevelBossBoard(state, message)
	if not state.questionLabel or not state.timerLabel then
		return
	end

	local question = state.currentQuestion
	local answersText = ""
	if question then
		for index, answerText in ipairs(question.answers) do
			answersText = answersText .. ("%d. %s\n"):format(index, answerText)
		end

		state.questionLabel.Text = ("%s\n\n%s"):format(question.question, answersText)
	else
		state.questionLabel.Text = message or "Up-Level Boss Fight"
	end

	if message and message ~= "" then
		state.timerLabel.Text = message
	else
		state.timerLabel.Text = ("Time: %ds"):format(math.max(0, math.ceil(state.timeRemaining or 0)))
	end
end

local function updateUpLevelBossState(state, eventName, extra)
	local player = state.player
	player:SetAttribute("UpLevelBossHealth", state.bossHealth)
	player:SetAttribute("UpLevelPlayerHealth", state.playerHealth)
	player:SetAttribute("UpLevelQuestionTimeRemaining", math.max(0, math.ceil(state.timeRemaining or 0)))

	setHealthBillboard(state.bossHealthGui, "Boss", state.bossHealth, state.bossMaxHealth)
	setHealthBillboard(state.playerHealthGui, "You", state.playerHealth, state.playerMaxHealth)

	firePlayerRemoteEvent(player, eventName or "UpLevelBossFightState", getUpLevelPayload(state, extra))
end

local function getQuestionForUpLevelRound(questionIndex)
	local questionCount = #UpLevelBossFightQuestions
	if questionCount == 0 then
		return nil
	end

	local wrappedIndex = ((questionIndex - 1) % questionCount) + 1
	return UpLevelBossFightQuestions[wrappedIndex]
end

local function createUpLevelBossEncounter(state, rootPart)
	local player = state.player
	local rootCFrame = rootPart.CFrame
	local basePosition = rootPart.Position
	local lookVector = rootCFrame.LookVector
	local rightVector = rootCFrame.RightVector

	local arenaFolder = Instance.new("Folder")
	arenaFolder.Name = "UpLevelBossFight_" .. tostring(player.UserId)
	arenaFolder.Parent = workspace
	state.arenaFolder = arenaFolder

	local bossPosition = basePosition + lookVector * 28 + Vector3.new(0, 4, 0)
	local boardPosition = basePosition + lookVector * 16 + Vector3.new(0, 4, 0)
	state.answerPadOrigin = basePosition + lookVector * 8 + Vector3.new(0, -2.5, 0)
	state.answerPadRight = rightVector

	local bossModel = Instance.new("Model")
	bossModel.Name = "UpLevelBoss"
	bossModel.Parent = arenaFolder
	state.bossModel = bossModel

	local bossCore = Instance.new("Part")
	bossCore.Name = "BossCore"
	bossCore.Size = Vector3.new(7, 8, 3)
	bossCore.Anchored = true
	bossCore.CanCollide = true
	bossCore.Material = Enum.Material.Neon
	bossCore.BrickColor = BrickColor.new("Really red")
	bossCore.CFrame = CFrame.lookAt(bossPosition, basePosition + Vector3.new(0, 2, 0))
	bossCore.Parent = bossModel
	state.bossPart = bossCore

	local bossHead = Instance.new("Part")
	bossHead.Name = "BossHead"
	bossHead.Shape = Enum.PartType.Ball
	bossHead.Size = Vector3.new(4, 4, 4)
	bossHead.Anchored = true
	bossHead.CanCollide = false
	bossHead.Material = Enum.Material.SmoothPlastic
	bossHead.BrickColor = BrickColor.new("Bright red")
	bossHead.CFrame = bossCore.CFrame + Vector3.new(0, 5.25, 0)
	bossHead.Parent = bossModel

	state.bossHealthGui = createHealthBillboard(bossCore, "BossHealthBar", "Boss", Color3.fromRGB(255, 65, 65), Vector3.new(0, 6.5, 0))

	local board = Instance.new("Part")
	board.Name = "UpLevelProblemBoard"
	board.Size = Vector3.new(15, 8, 0.4)
	board.Anchored = true
	board.CanCollide = false
	board.Material = Enum.Material.SmoothPlastic
	board.Color = Color3.fromRGB(23, 29, 43)
	board.CFrame = CFrame.lookAt(boardPosition, basePosition + Vector3.new(0, 2, 0))
	board.Parent = arenaFolder
	state.questionBoard = board

	local surfaceGui = Instance.new("SurfaceGui")
	surfaceGui.Name = "QuestionGui"
	surfaceGui.Face = Enum.NormalId.Front
	surfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	surfaceGui.PixelsPerStud = 48
	surfaceGui.Parent = board

	local questionLabel = Instance.new("TextLabel")
	questionLabel.Name = "Question"
	questionLabel.Position = UDim2.new(0.04, 0, 0.05, 0)
	questionLabel.Size = UDim2.new(0.92, 0, 0.72, 0)
	questionLabel.BackgroundTransparency = 1
	questionLabel.TextColor3 = Color3.new(1, 1, 1)
	questionLabel.TextScaled = true
	questionLabel.TextWrapped = true
	questionLabel.Font = Enum.Font.GothamBold
	questionLabel.Parent = surfaceGui
	state.questionLabel = questionLabel

	local timerLabel = Instance.new("TextLabel")
	timerLabel.Name = "Timer"
	timerLabel.Position = UDim2.new(0.04, 0, 0.78, 0)
	timerLabel.Size = UDim2.new(0.92, 0, 0.17, 0)
	timerLabel.BackgroundColor3 = Color3.fromRGB(255, 210, 80)
	timerLabel.BorderSizePixel = 0
	timerLabel.TextColor3 = Color3.fromRGB(20, 20, 20)
	timerLabel.TextScaled = true
	timerLabel.TextWrapped = true
	timerLabel.Font = Enum.Font.GothamBold
	timerLabel.Parent = surfaceGui
	state.timerLabel = timerLabel

	local character = player.Character
	local head = character and character:FindFirstChild("Head")
	if head and head:IsA("BasePart") then
		state.playerHealthGui = createHealthBillboard(head, "UpLevelPlayerHealthBar", "You", Color3.fromRGB(79, 184, 255), Vector3.new(0, 2.7, 0))
	end

	return true
end

local function spawnUpLevelAnswerPads(state, question)
	clearUpLevelAnswerPads(state)

	local pads = {}
	local answerCount = #question.answers
	local startOffset = ((answerCount - 1) * UpLevelBossFightConfig.AnswerPadSpacing) / 2

	for index, answerText in ipairs(question.answers) do
		local pad = Instance.new("Part")
		pad.Name = "UpLevelAnswerPad_" .. tostring(index)
		pad.Size = Vector3.new(3.5, 0.35, 3.5)
		pad.Anchored = true
		pad.CanCollide = true
		pad.Material = Enum.Material.Neon
		pad.Color = Color3.fromRGB(68, 112, 255)
		pad.Position = state.answerPadOrigin + state.answerPadRight * ((index - 1) * UpLevelBossFightConfig.AnswerPadSpacing - startOffset)
		pad:SetAttribute("AnswerValue", answerText)
		pad.Parent = state.arenaFolder

		local gui = Instance.new("BillboardGui")
		gui.Name = "AnswerLabel"
		gui.Size = UDim2.new(0, 120, 0, 46)
		gui.StudsOffset = Vector3.new(0, 2.2, 0)
		gui.AlwaysOnTop = true
		gui.Parent = pad

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = answerText
		label.TextColor3 = Color3.new(1, 1, 1)
		label.TextScaled = true
		label.TextWrapped = true
		label.Font = Enum.Font.GothamBold
		label.Parent = gui

		pad.Touched:Connect(function(hit)
			local touchedPlayer = Players:GetPlayerFromCharacter(hit.Parent)
			if touchedPlayer ~= state.player then
				return
			end

			submitUpLevelBossAnswer(touchedPlayer, answerText, "AnswerPad")
		end)

		table.insert(pads, pad)
	end

	state.answerPads = pads
end

finishUpLevelBossFight = function(state, passed, reason)
	if state.finished then
		return
	end

	state.finished = true
	state.acceptingAnswer = false
	state.timeRemaining = 0
	clearUpLevelAnswerPads(state)

	local player = state.player
	local completion = nil
	if passed then
		local ok, completeReason, unlockedLevel, requiredXP, currentXP = completeUpLevelTest(player, state.towerLevel, true)
		completion = {
			ok = ok,
			reason = completeReason,
			unlockedTowerLevel = unlockedLevel,
			requiredXP = requiredXP,
			currentXP = currentXP,
		}

		if not ok then
			passed = false
			reason = completeReason
		end
	else
		completeUpLevelTest(player, state.towerLevel, false)
	end

	local message = passed and "Boss defeated! Test passed." or "You were defeated. Test failed."
	updateUpLevelBossBoard(state, message)
	updateUpLevelBossState(state, "UpLevelBossFightEnded", {
		passed = passed,
		reason = reason,
		completion = completion,
	})

	task.delay(UpLevelBossFightConfig.CleanupSeconds, function()
		if upLevelBossFightState[player] == state then
			upLevelBossFightState[player] = nil
		end
		destroyUpLevelBossFightVisuals(state)
	end)
end

resolveUpLevelBossRound = function(state, wasCorrect, reason, selectedAnswer)
	if state.finished or not state.acceptingAnswer then
		return false, "RoundClosed"
	end

	state.acceptingAnswer = false
	state.timeRemaining = math.max(0, (state.questionDeadline or os.clock()) - os.clock())

	local question = state.currentQuestion
	local roundMessage
	if wasCorrect then
		state.bossHealth = math.max(0, state.bossHealth - UpLevelBossFightConfig.BossDamagePerCorrectAnswer)
		roundMessage = "Correct! Boss took damage."
	else
		state.playerHealth = math.max(0, state.playerHealth - UpLevelBossFightConfig.PlayerDamagePerMiss)
		if reason == "Timeout" then
			roundMessage = "Time up! You took damage."
		else
			roundMessage = "Wrong answer! You took damage."
		end
	end

	updateUpLevelBossBoard(state, roundMessage)
	updateUpLevelBossState(state, "UpLevelBossFightState", {
		roundResult = wasCorrect and "Correct" or reason,
		selectedAnswer = selectedAnswer,
		correctAnswer = question and question.correct,
	})

	clearUpLevelAnswerPads(state)

	if state.bossHealth <= 0 then
		finishUpLevelBossFight(state, true, "BossDefeated")
		return true, "BossDefeated"
	end

	if state.playerHealth <= 0 then
		finishUpLevelBossFight(state, false, "PlayerDefeated")
		return true, "PlayerDefeated"
	end

	task.delay(UpLevelBossFightConfig.InterRoundSeconds, function()
		if upLevelBossFightState[state.player] == state and not state.finished then
			presentUpLevelBossQuestion(state)
		end
	end)

	return true, wasCorrect and "Correct" or reason
end

submitUpLevelBossAnswer = function(player, selectedAnswer, source)
	local state = upLevelBossFightState[player]
	if not state or state.finished or not state.acceptingAnswer then
		return false, "NoActiveUpLevelQuestion"
	end

	local question = state.currentQuestion
	if not question then
		return false, "MissingQuestion"
	end

	if source == "AnswerPad"
		and state.questionStartedAt
		and os.clock() - state.questionStartedAt < UpLevelBossFightConfig.AnswerPadArmingSeconds then
		return false, "AnswerPadArming"
	end

	local answerText = selectedAnswer
	if type(selectedAnswer) == "number" then
		answerText = question.answers[selectedAnswer]
	end

	answerText = tostring(answerText or "")
	local wasCorrect = answerText == question.correct
	return resolveUpLevelBossRound(state, wasCorrect, wasCorrect and "Correct" or "WrongAnswer", answerText, source)
end

local function ensureUpLevelBossRemotes()
	for _, eventName in ipairs(UP_LEVEL_BOSS_REMOTE_EVENTS) do
		getRemoteEvent(eventName, true)
	end

	if upLevelAnswerRemoteConnected then
		return
	end

	local answerEvent = getRemoteEvent(UP_LEVEL_BOSS_ANSWER_REMOTE, true)
	if not answerEvent then
		return
	end

	answerEvent.OnServerEvent:Connect(function(player, selectedAnswer)
		submitUpLevelBossAnswer(player, selectedAnswer, "RemoteEvent")
	end)
	upLevelAnswerRemoteConnected = true
end

presentUpLevelBossQuestion = function(state)
	if state.finished then
		return
	end

	state.questionIndex = state.questionIndex + 1
	state.questionId = state.questionId + 1
	state.currentQuestion = getQuestionForUpLevelRound(state.questionIndex)

	if not state.currentQuestion then
		finishUpLevelBossFight(state, false, "NoQuestionsConfigured")
		return
	end

	state.acceptingAnswer = true
	state.questionStartedAt = os.clock()
	state.questionDeadline = state.questionStartedAt + UpLevelBossFightConfig.QuestionSeconds
	state.timeRemaining = UpLevelBossFightConfig.QuestionSeconds

	spawnUpLevelAnswerPads(state, state.currentQuestion)
	updateUpLevelBossBoard(state)
	updateUpLevelBossState(state, "UpLevelBossFightQuestion", {
		questionSeconds = UpLevelBossFightConfig.QuestionSeconds,
	})

	local questionId = state.questionId
	task.spawn(function()
		while upLevelBossFightState[state.player] == state and not state.finished and state.acceptingAnswer and state.questionId == questionId do
			local remaining = (state.questionDeadline or os.clock()) - os.clock()
			state.timeRemaining = math.max(0, remaining)

			if remaining <= 0 then
				break
			end

			updateUpLevelBossBoard(state)
			updateUpLevelBossState(state, "UpLevelBossFightState", {
				tick = true,
			})
			task.wait(1)
		end

		if upLevelBossFightState[state.player] == state and not state.finished and state.acceptingAnswer and state.questionId == questionId then
			resolveUpLevelBossRound(state, false, "Timeout")
		end
	end)
end

beginUpLevelBossFight = function(player, context)
	context = context or {}
	local towerLevel = math.floor(tonumber(context.towerLevel) or getPlayerUnlockedTowerLevel(player))
	local allowed, reason, nextLevel, requiredXP, currentXP = canAttemptUpLevelTest(player, towerLevel)
	if not allowed then
		firePlayerRemoteEvent(player, "UpLevelBossFightEnded", {
			passed = false,
			reason = reason,
			towerLevel = towerLevel,
			nextTowerLevel = nextLevel,
			requiredXP = requiredXP,
			currentXP = currentXP,
		})
		return false, reason, nextLevel, requiredXP, currentXP
	end

	if upLevelBossFightState[player] then
		local existingState = upLevelBossFightState[player]
		existingState.finished = true
		upLevelBossFightState[player] = nil
		destroyUpLevelBossFightVisuals(existingState)
	end

	local rootPart = waitForPlayerRootPart(player, 5)
	if not rootPart then
		return false, "MissingCharacter"
	end

	ensureUpLevelBossRemotes()

	local state = {
		player = player,
		towerLevel = towerLevel,
		nextTowerLevel = nextLevel,
		requiredXP = requiredXP,
		currentXP = currentXP,
		bossHealth = UpLevelBossFightConfig.BossMaxHealth,
		bossMaxHealth = UpLevelBossFightConfig.BossMaxHealth,
		playerHealth = UpLevelBossFightConfig.PlayerMaxHealth,
		playerMaxHealth = UpLevelBossFightConfig.PlayerMaxHealth,
		questionIndex = 0,
		questionId = 0,
		timeRemaining = 0,
		acceptingAnswer = false,
		finished = false,
		answerPads = {},
	}

	upLevelBossFightState[player] = state

	local encounterCreated, createReason = createUpLevelBossEncounter(state, rootPart)
	if not encounterCreated then
		upLevelBossFightState[player] = nil
		destroyUpLevelBossFightVisuals(state)
		return false, createReason or "BossEncounterCreateFailed"
	end

	updateUpLevelBossState(state, "UpLevelBossFightStarted", {
		questionSeconds = UpLevelBossFightConfig.QuestionSeconds,
		bossDamagePerCorrectAnswer = UpLevelBossFightConfig.BossDamagePerCorrectAnswer,
		playerDamagePerMiss = UpLevelBossFightConfig.PlayerDamagePerMiss,
	})
	presentUpLevelBossQuestion(state)

	return true, "StartedUpLevelBossFight", {
		towerLevel = towerLevel,
		nextTowerLevel = nextLevel,
		requiredXP = requiredXP,
		currentXP = currentXP,
	}
end

Players.PlayerRemoving:Connect(function(player)
	local state = upLevelBossFightState[player]
	if not state then
		return
	end

	state.finished = true
	upLevelBossFightState[player] = nil
	destroyUpLevelBossFightVisuals(state)
end)

local function startUpLevelBossFightFromTeleportData(player)
	task.defer(function()
		local joinData = player:GetJoinData()
		local teleportData = joinData and joinData.TeleportData
		if type(teleportData) ~= "table" or teleportData.destination ~= "UpLevelTest" then
			return
		end

		local teleportTowerLevel = tonumber(teleportData.towerLevel)
		local teleportXP = tonumber(teleportData.currentXP)
		if teleportTowerLevel then
			setPlayerUnlockedTowerLevel(player, teleportTowerLevel)
		end
		if teleportXP then
			setPlayerExperience(player, teleportXP)
		end

		startUpLevelTest(player, teleportData.towerLevel, teleportData.nextTowerLevel)
	end)
end

Players.PlayerAdded:Connect(startUpLevelBossFightFromTeleportData)
for _, player in ipairs(Players:GetPlayers()) do
	startUpLevelBossFightFromTeleportData(player)
end


-- ============================================================
-- [ ROUTE UP-LEVEL TEST PORTAL ]
-- Sends one qualified player to the separate up-level test server.
-- ============================================================

local function routeUpLevelTestPortal(player, towerLevel)
	local allowed, reason, nextLevel, requiredXP, currentXP = canAttemptUpLevelTest(player, towerLevel)
	if not allowed then
		if reason == "NotEnoughXP" then
			notifyTowerAccessDenied(player, nextLevel or towerLevel, requiredXP, currentXP)
		end
		return false, reason, nextLevel, requiredXP, currentXP
	end

	local config = TowerLevelRequirements[towerLevel]
	if config.upLevelTestPlaceId and config.upLevelTestPlaceId ~= 0 then
		return teleportPlayerToPlace(player, config.upLevelTestPlaceId, {
			destination = "UpLevelTest",
			source = UP_LEVEL_TEST_ENTRY_SOURCE,
			towerLevel = towerLevel,
			nextTowerLevel = nextLevel,
			requiredXP = requiredXP,
			currentXP = currentXP,
			solo = true,
			timed = true,
			arenaStructure = true,
			bossFight = true,
		})
	end

	return startUpLevelTest(player, towerLevel, nextLevel)
end


-- ============================================================
-- [ GET PLAYER FROM PORTAL TOUCH ]
-- Converts a touched character part into a Player.
-- ============================================================

local function getPlayerFromPortalTouch(hit)
	local character = hit and hit.Parent
	if not character then
		return nil
	end

	return Players:GetPlayerFromCharacter(character)
end


-- ============================================================
-- [ PORTAL TOUCH DEBOUNCE ]
-- Prevents one touch from firing portal logic many times.
-- ============================================================

local portalTouchDebounces = {}
local PORTAL_TOUCH_DEBOUNCE_SECONDS = 1

local function canUsePortalNow(player, portalKey)
	local debounceKey = tostring(player.UserId) .. ":" .. tostring(portalKey)
	local now = os.clock()

	if portalTouchDebounces[debounceKey] and now < portalTouchDebounces[debounceKey] then
		return false
	end

	portalTouchDebounces[debounceKey] = now + PORTAL_TOUCH_DEBOUNCE_SECONDS
	return true
end


-- ============================================================
-- [ BIND LOBBY PORTAL ]
-- Connects a lobby portal Part to a configured portal route.
-- ============================================================

local function bindLobbyPortal(portalPart, portalName)
	portalPart.Touched:Connect(function(hit)
		local player = getPlayerFromPortalTouch(hit)
		if not player then
			return
		end

		if not canUsePortalNow(player, "Lobby:" .. tostring(portalName)) then
			return
		end

		routeLobbyPortal(player, portalName)
	end)
end


-- ============================================================
-- [ BIND TOWER LEVEL PORTAL ]
-- Connects a Tower level portal Part to its XP-gated level.
-- ============================================================

local function bindTowerLevelPortal(portalPart, towerLevel)
	portalPart.Touched:Connect(function(hit)
		local player = getPlayerFromPortalTouch(hit)
		if not player then
			return
		end

		if not canUsePortalNow(player, "Tower:" .. tostring(towerLevel)) then
			return
		end

		routeTowerLevelPortal(player, towerLevel)
	end)
end


-- ============================================================
-- [ BIND TOWER LEVEL ARENA PORTAL ]
-- Connects the level Arena gate to the join prompt.
-- ============================================================

local function bindTowerLevelArenaPortal(portalPart, towerLevel)
	portalPart.Touched:Connect(function(hit)
		local player = getPlayerFromPortalTouch(hit)
		if not player then
			return
		end

		if not canUsePortalNow(player, "TowerArena:" .. tostring(towerLevel)) then
			return
		end

		promptArenaJoin(player, towerLevel)
	end)
end


-- ============================================================
-- [ BIND TOWER LEVEL DUNGEON PORTAL ]
-- Connects the level dungeon teleport to its specific dungeon place.
-- ============================================================

local function bindTowerLevelDungeonPortal(portalPart, towerLevel)
	portalPart.Touched:Connect(function(hit)
		local player = getPlayerFromPortalTouch(hit)
		if not player then
			return
		end

		if not canUsePortalNow(player, "TowerDungeon:" .. tostring(towerLevel)) then
			return
		end

		routeTowerLevelDungeon(player, towerLevel)
	end)
end


-- ============================================================
-- [ BIND TOWER LEVEL TRAVEL PORTAL ]
-- Connects a level travel portal to another unlocked Tower level.
-- ============================================================

local function bindTowerLevelTravelPortal(portalPart, destinationTowerLevel)
	portalPart.Touched:Connect(function(hit)
		local player = getPlayerFromPortalTouch(hit)
		if not player then
			return
		end

		if not canUsePortalNow(player, "TowerTravel:" .. tostring(destinationTowerLevel)) then
			return
		end

		routeTowerLevelTravel(player, destinationTowerLevel)
	end)
end


-- ============================================================
-- [ BIND TOWER LEVEL COMMUNITY PORTAL ]
-- Connects a level doorway/portal to its Community area.
-- ============================================================

local function bindTowerLevelCommunityPortal(portalPart, towerLevel)
	portalPart.Touched:Connect(function(hit)
		local player = getPlayerFromPortalTouch(hit)
		if not player then
			return
		end

		if not canUsePortalNow(player, "TowerCommunity:" .. tostring(towerLevel)) then
			return
		end

		routeTowerLevelCommunity(player, towerLevel)
	end)
end


-- ============================================================
-- [ BIND UP-LEVEL TEST PORTAL ]
-- Connects an optional test entry control to the separate solo test server.
-- ============================================================

local function bindUpLevelTestPortal(portalPart, towerLevel)
	portalPart.Touched:Connect(function(hit)
		local player = getPlayerFromPortalTouch(hit)
		if not player then
			return
		end

		if not canUsePortalNow(player, "UpLevelTest:" .. tostring(towerLevel)) then
			return
		end

		routeUpLevelTestPortal(player, towerLevel)
	end)
end


-- ============================================================
-- [ ANSWER SELECTION / SCORING FALLBACK ]
-- Used by simple trivia modes. Arena uses submitArenaAnswer so solo
-- practice and session leaderboard rules can be enforced.
-- First correct answer scores a point and awards XP; wrong answer scores nothing.
-- ============================================================

local function onAnswerSelected(player, selectedAnswer, correctAnswer, scores)
	if selectedAnswer == correctAnswer then
		scores[player] = (scores[player] or 0) + 1
		awardExperience(player, XP_REWARDS.CorrectAnswer)
		return true  -- correct
	end
	return false  -- wrong
end


-- ============================================================
-- [ DUNGEON QUESTIONS ]
-- Each entry: { question, answers = { "A", "B", ... }, correct = "A" }
-- ============================================================

local DungeonQuestions = {
	{
		question = "What is 2 + 2?",
		answers  = { "3", "4", "5", "6" },
		correct  = "4",
	},
	{
		question = "What color is the sky?",
		answers  = { "Red", "Blue", "Green", "Yellow" },
		correct  = "Blue",
	},
	{
		question = "How many sides does a triangle have?",
		answers  = { "2", "3", "4", "5" },
		correct  = "3",
	},
}

-- Tracks each player's current question index and spawned coin parts
local dungeonState = {}  -- { [player] = { questionIndex, coins = {}, barrier = Part } }

-- forward declarations (defined later in this file)
local onCoinTouched
local onDungeonComplete
local resetDungeon


-- ============================================================
-- [ SPAWN ANSWER COINS ]
-- Creates one gold coin Part per answer option in front of the barrier.
-- Each coin gets a BillboardGui label and stores its answer value.
-- ============================================================

local COIN_SPACING       = 4
local COIN_COLOR_DEFAULT = BrickColor.new("Bright yellow")
local COIN_COLOR_CORRECT = BrickColor.new("Neon orange")

local function spawnAnswerCoins(player, questionIndex, barrierPart)
	local qData = DungeonQuestions[questionIndex]
	if not qData then return {} end

	local coins      = {}
	local numAnswers = #qData.answers
	local origin     = barrierPart.Position + barrierPart.CFrame.LookVector * 6
	local startPos   = origin - Vector3.new((numAnswers - 1) * COIN_SPACING / 2, 0, 0)

	for i, answerText in ipairs(qData.answers) do
		local coin        = Instance.new("Part")
		coin.Name         = "AnswerCoin_" .. i
		coin.Size         = Vector3.new(1.5, 1.5, 0.3)
		coin.Shape        = Enum.PartType.Cylinder
		coin.BrickColor   = COIN_COLOR_DEFAULT
		coin.Material     = Enum.Material.SmoothPlastic
		coin.Anchored     = false
		coin.CanCollide   = false
		coin.Position     = startPos + Vector3.new((i - 1) * COIN_SPACING, 1.5, 0)
		coin:SetAttribute("AnswerValue", answerText)
		coin:SetAttribute("IsCorrect",   answerText == qData.correct)
		coin.Parent       = workspace

		local gui           = Instance.new("BillboardGui", coin)
		gui.Size            = UDim2.new(0, 120, 0, 40)
		gui.AlwaysOnTop     = true
		local label         = Instance.new("TextLabel", gui)
		label.Size          = UDim2.new(1, 0, 1, 0)
		label.Text          = answerText
		label.TextColor3    = Color3.new(1, 1, 1)
		label.BackgroundTransparency = 1
		label.TextScaled    = true
		label.Font          = Enum.Font.GothamBold

		coin.Touched:Connect(function(hit)
			local character     = hit.Parent
			local touchedPlayer = game:GetService("Players"):GetPlayerFromCharacter(character)
			if touchedPlayer ~= player then return end
			if coin:GetAttribute("Used") then return end
			coin:SetAttribute("Used", true)
			onCoinTouched(player, coin)
		end)

		table.insert(coins, coin)
	end

	return coins
end


-- ============================================================
-- [ ON COIN TOUCHED ]
-- Correct coin → glow, open barrier, advance to next question.
-- Wrong coin   → clear coins, reset the dungeon run.
-- ============================================================

local function clearCoins(coins)
	for _, c in ipairs(coins) do
		if c and c.Parent then c:Destroy() end
	end
end

local function openBarrier(barrierPart)
	barrierPart.Transparency = 1
	barrierPart.CanCollide   = false
end

onCoinTouched = function(player, coin)
	local state = dungeonState[player]
	if not state then return end

	if coin:GetAttribute("IsCorrect") then
		coin.BrickColor = COIN_COLOR_CORRECT
		task.wait(0.35)
		clearCoins(state.coins)
		openBarrier(state.barrier)

		state.questionIndex = state.questionIndex + 1
		if state.questionIndex > #DungeonQuestions then
			onDungeonComplete(player)
		end
		-- next call to startDungeonQuestion happens when player reaches the next barrier trigger
	else
		clearCoins(state.coins)
		resetDungeon(player)
	end
end


-- ============================================================
-- [ START DUNGEON QUESTION ]
-- Call this when the player reaches a new question barrier.
-- barrierPart is the Part blocking the path for this question.
-- ============================================================

local function startDungeonQuestion(player, barrierPart)
	if not dungeonState[player] then
		dungeonState[player] = { questionIndex = 1 }
	end
	local state   = dungeonState[player]
	state.barrier = barrierPart

	local qData = DungeonQuestions[state.questionIndex]
	if not qData then
		onDungeonComplete(player)
		return
	end

	-- show the question text on the barrier face
	local existing = barrierPart:FindFirstChild("QuestionGui")
	if existing then existing:Destroy() end

	local surfGui           = Instance.new("SurfaceGui", barrierPart)
	surfGui.Name            = "QuestionGui"
	surfGui.Face            = Enum.NormalId.Front
	local label             = Instance.new("TextLabel", surfGui)
	label.Size              = UDim2.new(1, 0, 1, 0)
	label.Text              = qData.question
	label.TextColor3        = Color3.new(1, 1, 1)
	label.BackgroundColor3  = Color3.fromRGB(30, 30, 80)
	label.TextScaled        = true
	label.Font              = Enum.Font.GothamBold

	state.coins = spawnAnswerCoins(player, state.questionIndex, barrierPart)
end


-- ============================================================
-- [ DUNGEON COMPLETE ]
-- All questions answered correctly — run finished.
-- ============================================================

onDungeonComplete = function(player)
	dungeonState[player] = nil
	awardExperience(player, XP_REWARDS.DungeonComplete)
	-- reward player, show victory UI, etc.
end


-- ============================================================
-- [ COIN COLLECTION ]
-- Awards a coin to the player when they land on the correct dungeon path.
-- ============================================================

local function collectCoin(player, coinData)
	-- increment player's dungeon coin count for this run
	-- remove the coin object from the dungeon
end


-- ============================================================
-- [ DUNGEON RESET ]
-- Kills the player, respawns them at the dungeon start, and wipes
-- all coins they collected during this run.
-- ============================================================

resetDungeon = function(_)
	-- kill the player (humanoid health to 0)
	-- teleport to dungeon spawn point
	-- clear all coins the player collected this run
	-- start the cooldown timer
end


-- ============================================================
-- [ DUNGEON COOLDOWN TIMER ]
-- Starts a 5-minute wait after a failed dungeon run.
-- Player cannot re-enter until the timer expires or they pay to skip.
-- ============================================================

local cooldowns = {}  -- { [player] = os.time() of when cooldown ends }

local COOLDOWN_SECONDS = 300  -- 5 minutes

local function startCooldown(player)
	cooldowns[player] = os.time() + COOLDOWN_SECONDS
end

local function isCoolingDown(player)
	if cooldowns[player] and os.time() < cooldowns[player] then
		return true, cooldowns[player] - os.time()  -- still cooling down, seconds remaining
	end
	return false, 0
end


-- ============================================================
-- [ DUNGEON COOLDOWN SKIP (PAY TO SKIP) ]
-- Lets the player spend currency to immediately end their cooldown.
-- ============================================================

local function skipCooldown(player)
	-- verify player has enough currency
	-- deduct the cost
	-- clear cooldowns[player]
	cooldowns[player] = nil
end


-- ============================================================
-- [ ANTI-COPY ENFORCEMENT (DUNGEON) ]
-- Hides all other players and disables chat while inside the dungeon
-- so no one can follow another player's correct path.
-- ============================================================

local function enforceDungeonAntiCopy(player)
	-- make all other players' characters invisible to this player
	-- disable chat for this player for the dungeon session
end

local function liftDungeonAntiCopy(player)
	-- restore visibility of other players
	-- re-enable chat
end
