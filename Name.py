local prompt = script.Parent:WaitForChild("ProximityPrompt")
local toolName = game.ServerStorage:WaitForChild("meelt")

prompt.Triggered:Connect(function(player)
	
	if player.Character and not player.Backpack:FindFirstChild("meetl") and not player.Character:FindFirstChild(too_meetl.Name) then
		
		local tool1 = tool_meetl:Clone()
		player.Character.Humanoid:EquipTool(tool1)
		
	end
	
end) 
