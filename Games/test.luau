local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local userInputService = game:GetService("UserInputService")
local event = game.ReplicatedStorage:WaitForChild("GrabEvent")

local function getCenterTarget()
	local ray = camera:ViewportPointToRay(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.FilterDescendantsInstances = {player.Character}

	local result = workspace:Raycast(ray.Origin, ray.Direction * 500, params)
	return result and result.Instance
end

userInputService.InputBegan:Connect(function(input, gp)
	if gp then return end

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		local target = getCenterTarget()
		if target then
			event:FireServer(target)
		end
	end
end)
