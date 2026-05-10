local Players = game:GetService("Players")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- 古いUI削除
local old = PlayerGui:FindFirstChild("TeleportUI")

if old then
	old:Destroy()
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "TeleportUI"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- TPボタン
local button = Instance.new("TextButton")

-- 横そのまま / 縦2/3くらい
button.Size = UDim2.new(0,75,0,75)

-- 左へ1.5個分くらい移動
-- 下ボタン高さに合わせる
button.Position = UDim2.new(1,-285,1,-100)

button.Text = "TP"
button.TextScaled = true

button.BackgroundColor3 = Color3.fromRGB(45,45,45)
button.TextColor3 = Color3.new(1,1,1)

button.BorderSizePixel = 0
button.Parent = gui

-- 角丸
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,18)
corner.Parent = button

-- TP処理
button.MouseButton1Click:Connect(function()

	local character = player.Character
	if not character then return end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	-- 画面中央Ray
	local viewport = camera.ViewportSize

	local ray = camera:ViewportPointToRay(
		viewport.X / 2,
		viewport.Y / 2
	)

	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {character}
	params.FilterType = Enum.RaycastFilterType.Blacklist

	local result = workspace:Raycast(
		ray.Origin,
		ray.Direction * 1000,
		params
	)

	if result then
		root.CFrame = CFrame.new(result.Position + Vector3.new(0,5,0))
	end
end)
