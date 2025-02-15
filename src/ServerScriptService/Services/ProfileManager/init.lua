local ServerScriptService = game:GetService('ServerScriptService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')

local ProfileService = require(ServerScriptService.Modules.ProfileService)
local ProfileTemplate = require(script.ProfileTemplate)
local ProfileStore = ProfileService.GetProfileStore(
	'PlayerData',
	ProfileTemplate
)

local module = {}

module.Profiles = {}

local function LoadPlayerInstances(player, profile)
	for _, v in script.PlayerValues:GetChildren() do
		v:Clone().Parent = player
	end
	print(player)
	task.spawn(function()
		while true do
			for _, v in player.leaderstats:GetChildren() do
				local actualValue = profile.Data.leaderstats[v.Name]
				v.Value = actualValue
			end
			task.wait(0.1)
		end
	end)
end

local function PlayerAdded(player: Player)
	local profile = ProfileStore:LoadProfileAsync('Player_' .. player.UserId)
	if profile then
		profile:AddUserId(player.UserId)
		profile:Reconcile()
		profile:ListenToRelease(function()
			module.Profiles[player] = nil
			player:Kick()
		end)
		
		print(player)
		
		if player:IsDescendantOf(Players) == true then
			module.Profiles[player] = profile
			LoadPlayerInstances(player, profile)
		else
			profile:Release()
		end
	else
		player:Kick()
	end
end

for _, player in Players:GetPlayers() do
	task.spawn(PlayerAdded, player)
end

Players.PlayerAdded:Connect(PlayerAdded)

Players.PlayerRemoving:Connect(function(player)
	local profile = module.Profiles[player]
	if profile then
		profile:Release()
	end
end)

return module
