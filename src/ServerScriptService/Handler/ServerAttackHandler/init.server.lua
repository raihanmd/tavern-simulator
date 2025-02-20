local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Events = ReplicatedStorage.Events

local attackHitboxes = require(script.Parent.Parent.Modules.AttackHitboxes)
local characterConfigurations = require(ReplicatedStorage.SharedModules.Configurations.CharacterConfigurations)

local attackDebounces = {}

local function equipCharacter(player: Player, characterName: string)
	local values = player:WaitForChild("Values")
	values.Character.Value = characterName

	local characterData = nil

	for _, v in characterConfigurations do
		if v.CharacterName == characterName then
			characterData = v
			break
		end
	end

	Events.EquipCharacterClient:FireClient(player, characterData)
end

local function playerAdded(player: Player)
	player.CharacterAdded:Connect(function(char)
		task.wait(1)
		equipCharacter(player, "Hunter")
	end)
end

Events.ClickAttack.OnServerEvent:Connect(function(player: Player)
	local char = player.Character

	if char == nil then
		return
	end

	local humanoid = char:FindFirstChild("Humanoid")

	if humanoid == nil then
		return
	end

	if humanoid.Health <= 0 then
		return
	end

	if attackDebounces[player] then
		return
	end

	attackDebounces[player] = true
	local punchCombo = player.Values.PunchCombo
	local animation = script.PunchAnimationCycle[tostring(punchCombo.Value)]
	local loadedPunchAnimation = humanoid.Animator:LoadAnimation(animation)
	loadedPunchAnimation:Play()

	if punchCombo.Value >= #script.PunchAnimationCycle:GetChildren() then
		punchCombo.Value = 1
	else
		punchCombo.Value += 1
	end

	loadedPunchAnimation:GetMarkerReachedSignal("Hit"):Connect(function()
		attackHitboxes.CreateHitbox(char, Vector3.new(7, 7, 5), 40, true)
	end)

	task.wait(loadedPunchAnimation.Length + 0.1)
	if attackDebounces[player] then
		attackDebounces[player] = nil
	end
end)

Events.Block.OnServerEvent:Connect(function(player: Player, isBlocking: boolean)
	local char = player.Character

	if char == nil then
		return
	end

	local humanoid = char:FindFirstChild("Humanoid")

	if humanoid == nil then
		return
	end

	if humanoid.Health <= 0 then
		return
	end

	if attackDebounces[player] then
		return
	end

	if not isBlocking then
		local loadedAnimation = humanoid.Animator:GetPlayingAnimationTracks()
		for _, v in loadedAnimation do
			if v.Name == "Block" then
				v:Stop()
			end
		end
	else
		local blockAnimation = humanoid.Animator:LoadAnimation(script.Animations.Block)
		blockAnimation:Play()
		local blocking = Instance.new("StringValue")
		blocking.Name = "Blocking"
		blocking.Parent = char
	end
end)

Events.SpecialAttack.OnServerInvoke = function(player: Players, attackNumber: number)
	local playerCharacter = player.Values.Character.Value
	local result = require(script.Characters[playerCharacter][tostring(attackNumber)]).AttackFunction(player)
	return result
end

Players.PlayerAdded:Connect(playerAdded)

for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(function()
		playerAdded(player)
	end)
end
