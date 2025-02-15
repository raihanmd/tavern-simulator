local UserInputService = game:GetService("UserInputService")
local ReplicatedStorageService = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Events = ReplicatedStorageService:WaitForChild("Events")

local Char = script.Parent.Parent

local isBlocking = false

UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean) 
	if gameProcessedEvent then return end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 and not isBlocking then
		Events.ClickAttack:FireServer()
	end
	
	if input.KeyCode == Enum.KeyCode.F then
		isBlocking = true
		Events.Block:FireServer(true)
	end
end)

UserInputService.InputEnded:Connect(function(input: InputObject, gameProcessedEvent: boolean) 
	if gameProcessedEvent then return end
	
	if input.KeyCode == Enum.KeyCode.F then
		isBlocking = false
		Events.Block:FireServer(false)
	end
end)