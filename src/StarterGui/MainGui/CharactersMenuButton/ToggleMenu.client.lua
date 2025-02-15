local CharactersFrame = script.Parent.Parent.CharacterFrame

script.Parent.MouseButton1Click:Connect(function()
	CharactersFrame.Visible = not CharactersFrame.Visible
end)