local CollectionService = game:GetService("CollectionService")

local CCTVProximity = workspace:WaitForChild("Computer"):WaitForChild("Proximity").ProximityPrompt

local camera = workspace.CurrentCamera

local CCTVGui = script.CCTVGui

CCTVProximity.Triggered:Connect(function(palyer: Player)
	local cctv = CollectionService:GetTagged("CCTV_Prototype")

	camera.CameraType = Enum.CameraType.Scriptable

	camera.CFrame = cctv[1].CFrame
end)
