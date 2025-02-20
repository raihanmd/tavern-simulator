local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local events = ReplicatedStorage:WaitForChild("Events")

local character = script.Parent.Parent

local player = Players.LocalPlayer

local playerGui = player:WaitForChild("PlayerGui")
local mainGui = playerGui:WaitForChild("MainGui")
local attacks = mainGui.Attacks
local attackTemplate = script.Parent.AttackTemplate

local sharedModules = ReplicatedStorage:WaitForChild("SharedModules")
local configurations = sharedModules.Configurations

local characterConfigurations = require(configurations.CharacterConfigurations)

local equippedCharacterName = nil

local function UseSpecialAttack(attackNumber: number)
	if equippedCharacterName == nil then
		return
	end

	local result = events.SpecialAttack:InvokeServer(attackNumber)

	if result then
		local attackData = nil
		for _, v in characterConfigurations do
			if v.CharacterName == equippedCharacterName then
				attackData = v.Attacks[attackNumber]
				break
			end
		end

		local attackTemplate = script.Parent.Parent.PlayerGui.MainGui.Attacks[tostring(attackNumber)]
		attackTemplate.DebounceFrame.Size = UDim2.fromScale(1, 1)
		TweenService:Create(
			attackTemplate.DebounceFrame,
			TweenInfo.new(attackData.AttackDebounce),
			{ Size = UDim2.fromScale(1, 0) }
		):Play()
	end
end

UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent or equippedCharacterName == nil then
		return
	end

	if input.KeyCode == Enum.KeyCode.One then
		UseSpecialAttack(1)
	end

	if input.KeyCode == Enum.KeyCode.Two then
		UseSpecialAttack(2)
	end

	if input.KeyCode == Enum.KeyCode.Three then
		UseSpecialAttack(3)
	end

	if input.KeyCode == Enum.KeyCode.Four then
		UseSpecialAttack(4)
	end
end)

events.EquipCharacterClient.OnClientEvent:Connect(function(characterData: string)
	equippedCharacterName = characterData.CharacterName
	for i, v in characterData.Attacks do
		local newTemplate = attackTemplate:Clone()
		newTemplate.Name = tostring(i)
		newTemplate.Number.Text = tostring(i)
		newTemplate.AttackName.Text = v.AttackName
		newTemplate.Visible = true
		newTemplate.DebounceFrame.Size = UDim2.fromScale(1, 0)
		newTemplate.Parent = script.Parent.Parent.PlayerGui.MainGui.Attacks
		newTemplate.MouseButton1Click:Connect(function()
			UseSpecialAttack(i)
		end)
	end
end)
