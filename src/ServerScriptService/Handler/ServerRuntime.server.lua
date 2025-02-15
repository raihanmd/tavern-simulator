for _, v in script.Parent.Parent.Services:GetChildren() do
	pcall(function()
		task.spawn(function()
			require(v)
		end)
	end)
end