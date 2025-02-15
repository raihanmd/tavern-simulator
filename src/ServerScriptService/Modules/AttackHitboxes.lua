local Players = game:GetService('Players')
local ServerScriptService = game:GetService('ServerScriptService')

local ProfileManager = require(ServerScriptService.Services.ProfileManager)

local module = {}

function module.CreateHitbox(character: Model, hitboxSize: Vector3, damage: number, blockable: boolean)
	local player = Players:GetPlayerFromCharacter(character)
	local profile = ProfileManager.Profiles[player]
	local hitbox = Instance.new("Part")
	hitbox.Transparency = 1
	hitbox.CanCollide = false
	hitbox.Anchored = true
	hitbox.Size = hitboxSize
	hitbox.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -4)
	hitbox.Parent = workspace
	
	local partsInHitbox = workspace:GetPartsInPart(hitbox)
	local debounces = {}
	
	for _, v in partsInHitbox do
		local humanoid = v.Parent:FindFirstChild('Humanoid') or v.Parent.Parent:FindFirstChild('Humanoid')
		
		if humanoid and humanoid.Parent ~= character and not debounces[humanoid] and humanoid.Health > 0 then
			debounces[humanoid] = true
			if blockable then
				if not humanoid.Parent:FindFirstChild('Blocking') then
					humanoid.Health = math.max(0, humanoid.Health - damage)
					if humanoid.Health == 0 then
						profile.Data.leaderstats.Kills += 1
					end
				end
			else
				humanoid.Health = math.max(0, humanoid.Health - damage)
				profile.Data.leaderstats.Kills += 1
			end
		end
	end
	
	task.delay(.3, function()
		hitbox:Destroy()
	end)
end

return module
