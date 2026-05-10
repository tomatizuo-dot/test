local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local held = {}
local radius = 6

local function isCharacter(part)
	local model = part:FindFirstAncestorOfClass("Model")
	return model and model:FindFirstChild("Humanoid")
end

mouse.Button1Down:Connect(function()

	local target = mouse.Target

	if not target then return end
	if not target:IsA("BasePart") then return end
	if target.Anchored then return end
	if isCharacter(target) then return end

	-- 解除
	for i, v in ipairs(held) do

		if v == target then

			local bp = target:FindFirstChild("FloatBodyPosition")

			if bp then
				bp:Destroy()
			end

			target.CanCollide = true

			table.remove(held, i)
			return
		end
	end

	-- 追加
	table.insert(held, target)

	target.CanCollide = false

	local bp = Instance.new("BodyPosition")
	bp.Name = "FloatBodyPosition"
	bp.MaxForce = Vector3.new(1e6,1e6,1e6)
	bp.P = 5000
	bp.D = 500
	bp.Parent = target
end)

RunService.RenderStepped:Connect(function()

	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")

	if not root then return end

	local count = #held

	if count == 0 then return end

	local step = (2 * math.pi) / count

	for i, part in ipairs(held) do

		if part and part.Parent then

			local angle = step * (i - 1)

			local offset = Vector3.new(
				math.cos(angle) * radius,
				3,
				math.sin(angle) * radius
			)

			local bp = part:FindFirstChild("FloatBodyPosition")

			if bp then
				bp.Position = root.Position + offset
			end
		end
	end
end)
