local Players = game:GetService("Players")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()

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

-- ボタン
local button = Instance.new("TextButton")

button.Size = UDim2.new(0,180,0,60)
button.Position = UDim2.new(1,-260,1,-170)

button.Text = "TP"
button.TextScaled = true

button.BackgroundColor3 = Color3.fromRGB(50,50,50)
button.TextColor3 = Color3.new(1,1,1)

button.BorderSizePixel = 0
button.Parent = gui

-- 角丸
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,12)
corner.Parent = button

-- TP処理
button.MouseButton1Click:Connect(function()

	local character = player.Character
	if not character then return end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local target = mouse.Hit

	if target then
		root.CFrame = target + Vector3.new(0,5,0)
	end
end)
