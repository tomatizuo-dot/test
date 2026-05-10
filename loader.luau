-- =========================
-- CONFIG
-- =========================

local BASE_URL = "https://raw.githubusercontent.com/tomatizuo-dot/test/main/Games/"
local API_URL = "https://api.github.com/repos/tomatizuo-dot/test/contents/Games"

-- =========================
-- SERVICES
-- =========================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local HttpGet = game.HttpGet
local loadstring = loadstring

-- =========================
-- REMOVE OLD UI
-- =========================

local old = PlayerGui:FindFirstChild("ModernLoader")

if old then
	old:Destroy()
end

-- =========================
-- DESIGN
-- =========================

local PANEL = Color3.fromRGB(28,28,36)
local BUTTON = Color3.fromRGB(36,36,46)

local ACCENT = Color3.fromRGB(145,105,255)

local TEXT = Color3.fromRGB(235,235,235)

-- =========================
-- GUI
-- =========================

local gui = Instance.new("ScreenGui")
gui.Name = "ModernLoader"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- =========================
-- MAIN FRAME
-- =========================

local frame = Instance.new("Frame")

frame.Size = UDim2.new(0,360,0,420)
frame.Position = UDim2.new(0.5,-180,0.5,-210)

frame.BackgroundColor3 = PANEL
frame.BackgroundTransparency = 0.3

frame.Parent = gui

-- Corner
local frameCorner = Instance.new("UICorner")

frameCorner.CornerRadius = UDim.new(0,16)
frameCorner.Parent = frame

-- Stroke
local frameStroke = Instance.new("UIStroke")

frameStroke.Thickness = 2
frameStroke.Color = ACCENT
frameStroke.Transparency = 0.45

frameStroke.Parent = frame

-- Gradient
local frameGradient = Instance.new("UIGradient")

frameGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(
		0,
		Color3.fromRGB(40,40,50)
	),

	ColorSequenceKeypoint.new(
		1,
		Color3.fromRGB(18,18,24)
	)
}

frameGradient.Rotation = 90
frameGradient.Parent = frame

-- =========================
-- TITLE
-- =========================

local title = Instance.new("TextLabel")

title.Size = UDim2.new(1,0,0,50)
title.BackgroundTransparency = 1

title.Text = "Modern Loader"

title.TextColor3 = TEXT
title.TextScaled = true
title.Font = Enum.Font.GothamBold

title.Parent = frame

-- =========================
-- LOG
-- =========================

local log = Instance.new("TextLabel")

log.Size = UDim2.new(1,-20,0,35)
log.Position = UDim2.new(0,10,0,50)

log.BackgroundTransparency = 1

log.Text = "Loading..."

log.TextColor3 = Color3.fromRGB(190,190,210)

log.Font = Enum.Font.Gotham
log.TextScaled = true

log.Parent = frame

-- =========================
-- SCROLL
-- =========================

local scroll = Instance.new("ScrollingFrame")

scroll.Size = UDim2.new(1,-20,1,-100)
scroll.Position = UDim2.new(0,10,0,90)

scroll.BackgroundTransparency = 1

scroll.ScrollBarThickness = 2

scroll.CanvasSize = UDim2.new(0,0,0,0)

scroll.Parent = frame

local layout = Instance.new("UIListLayout")

layout.Padding = UDim.new(0,8)
layout.Parent = scroll

-- =========================
-- RUN SCRIPT
-- =========================

local function run(file)

	log.Text = "Loading "..file

	local success, src = pcall(function()

		return HttpGet(
			game,
			BASE_URL .. file .. "?t=" .. tostring(os.time())
		)

	end)

	if not success then

		log.Text = "Fetch failed"
		return

	end

	local func, err = loadstring(src)

	if not func then

		log.Text = "Compile error"
		return

	end

	local ok = pcall(func)

	if ok then

		log.Text = "Executed "..file

	else

		log.Text = "Runtime error"

	end
end

-- =========================
-- CREATE BUTTON
-- =========================

local function createButton(file)

	local button = Instance.new("TextButton")

	button.Size = UDim2.new(1,-5,0,45)

	button.BackgroundColor3 = BUTTON
	button.BackgroundTransparency = 0.2

	button.Text =
		file.name:gsub("%.luau$","")

	button.TextColor3 = TEXT

	button.Font = Enum.Font.GothamBold
	button.TextScaled = true

	button.BorderSizePixel = 0

	button.Parent = scroll

	-- Corner
	local corner = Instance.new("UICorner")

	corner.CornerRadius = UDim.new(0,14)
	corner.Parent = button

	-- Stroke
	local stroke = Instance.new("UIStroke")

	stroke.Thickness = 1.5
	stroke.Color = ACCENT
	stroke.Transparency = 0.5

	stroke.Parent = button

	-- Click effect
	button.MouseButton1Down:Connect(function()

		TweenService:Create(
			button,
			TweenInfo.new(0.08),
			{
				BackgroundTransparency = 0.05
			}
		):Play()

	end)

	button.MouseButton1Up:Connect(function()

		TweenService:Create(
			button,
			TweenInfo.new(0.08),
			{
				BackgroundTransparency = 0.2
			}
		):Play()

	end)

	-- Run
	button.MouseButton1Click:Connect(function()

		run(file.name)

	end)
end

-- =========================
-- LOAD FILE LIST
-- =========================

local success, response = pcall(function()

	return HttpGet(
		game,
		API_URL .. "?t=" .. tostring(os.time())
	)

end)

if not success then

	log.Text = "Failed to load list"
	return

end

local data = HttpService:JSONDecode(response)

for _, file in ipairs(data) do

	if file.name:match("%.luau$") then

		createButton(file)

	end
end

task.wait()

scroll.CanvasSize =
	UDim2.new(
		0,
		0,
		0,
		layout.AbsoluteContentSize.Y + 10
	)

log.Text = "Loaded"
