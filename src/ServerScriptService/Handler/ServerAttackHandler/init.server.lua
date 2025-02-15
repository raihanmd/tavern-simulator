local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Events = ReplicatedStorage.Events

local attackHitboxes = require(script.Parent.Parent.Modules.AttackHitboxes)

local attackDebounces = {}

Events.ClickAttack.OnServerEvent:Connect(function(player: Player) 
	local char = player.Character
	
	if char == nil then
		return
	end
	
	local humanoid = char:FindFirstChild('Humanoid')
	
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
	
	loadedPunchAnimation:GetMarkerReachedSignal('Hit'):Connect(function()
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

	local humanoid = char:FindFirstChild('Humanoid')

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
			if v.Name == 'Block' then
				v:Stop()
			end
		end
	else
		local blockAnimation = humanoid.Animator:LoadAnimation(script.Animations.Block)
		blockAnimation:Play()
		local blocking = Instance.new('StringValue')
		blocking.Name = 'Blocking'
		blocking.Parent = char
	end
end)