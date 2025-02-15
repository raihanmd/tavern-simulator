local noobert = workspace.Noobert
local book = workspace.Receptionist["Open book"]
local seat = workspace.Chair.Seat -- Reference to the Seat part in the chair
local chairPrompt = seat.Parent.Base:FindFirstChild("ProximityPrompt")
local followDistance = 5
local isFollowing = false
local isSitting = false

-- Follow the player
book.ProximityPrompt.Triggered:Connect(function(plr)
	local character = plr.Character
	if character and not isFollowing and not isSitting then
		isFollowing = true

		game:GetService("RunService").Heartbeat:Connect(function()
			if isFollowing and character then
				local targetPosition = character.HumanoidRootPart.Position
				local currentPosition = noobert.HumanoidRootPart.Position

				if (currentPosition - targetPosition).Magnitude > followDistance then
					noobert.Humanoid:MoveTo(targetPosition)
				else
					noobert.Humanoid:MoveTo(currentPosition) -- Stop moving
				end
			end
		end)
	end
end)

-- Move noobert to the seat and make him sit down
chairPrompt.Triggered:Connect(function()
	if not isSitting then
		isFollowing = false
		isSitting = true

		-- Move noobert to the seat position
		noobert.Humanoid:MoveTo(seat.Position)

		-- Wait until noobert reaches the seat and sits down
		noobert.Humanoid.MoveToFinished:Wait()

		-- Ensure he sits by setting `Sit` to true
		noobert.Humanoid.Sit = true
	end
end)
