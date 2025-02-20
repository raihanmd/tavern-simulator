local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CharacterConfigurations = require(ReplicatedStorage.SharedModules.Configurations.CharacterConfigurations)

local attackDebounces = {}

local module = {}

local attackData = nil

for _, v in CharacterConfigurations do
	if v.CharacterName == script.Parent.Name then
		attackData = v.Attacks
		break
	end
end

module.AttackFunction = function(player: Player)
	if not player.Values.IsAttacking.Value and not attackDebounces[player] then
		attackDebounces[player] = true
		player.Values.IsAttacking.Value = true

		task.delay(attackData[tonumber(script.Name)].AttackDuration, function()
			player.Values.IsAttacking.Value = false
		end)
		task.delay(attackData[tonumber(script.Name)].AttackDebounce, function()
			attackDebounces[player] = nil
		end)
		return true
	else
		return false
	end
end

return module
