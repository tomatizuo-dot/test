-- =========================
-- CONFIG
-- =========================

local BASE_URL = "https://raw.githubusercontent.com/tomatizuo-dot/test/main/Games/"
local API_URL = "https://api.github.com/repos/tomatizuo-dot/test/contents/Games"

-- =========================
-- SERVICES
-- =========================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local HttpGet = game.HttpGet
local loadstring = loadstring

-- =========================
-- CLEAN OLD UI
-- =========================

local old = PlayerGui:FindFirstChild("ModernLoader")
if old then old:Destroy() end

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
frame.Size = UDim2.new(0,520,0,420)
frame.Position = UDim2.new(0.5,-260,0.5,-210)
frame.BackgroundColor3 = PANEL
frame.BackgroundTransparency = 0.3
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

local stroke = Instance.new("UIStroke")
stroke.Color = ACCENT
stroke.Transparency = 0.45
stroke.Thickness = 2
stroke.Parent = frame

-- =========================
-- SIDEBAR
-- =========================

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0,90,1,0)
sidebar.BackgroundColor3 = Color3.fromRGB(24,24,32)
sidebar.BackgroundTransparency = 0.15
sidebar.Parent = frame

Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0,16)

local sideStroke = Instance.new("UIStroke")
sideStroke.Color = ACCENT
sideStroke.Transparency = 0.6
sideStroke.Parent = sidebar

-- =========================
-- CONTENT
-- =========================

local content = Instance.new("Frame")
content.Size = UDim2.new(1,-100,1,-10)
content.Position = UDim2.new(0,95,0,5)
content.BackgroundTransparency = 1
content.Parent = frame

-- =========================
-- TITLE
-- =========================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,50)
title.BackgroundTransparency = 1
title.Text = "FriHub"
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
log.Text = "Ready"
log.TextColor3 = Color3.fromRGB(190,190,210)
log.Font = Enum.Font.Gotham
log.TextScaled = true
log.Parent = frame

-- =========================
-- PAGES SYSTEM
-- =========================

local pages = {}

local function makePage(name)
	local page = Instance.new("Frame")
	page.Size = UDim2.new(1,0,1,0)
	page.BackgroundTransparency = 1
	page.Visible = false
	page.Parent = content
	pages[name] = page
	return page
end

local homePage = makePage("Home")
local scriptPage = makePage("Scripts")
local playerPage = makePage("Player")

local function showPage(name)
	for n, page in pairs(pages) do
		page.Visible = (n == name)
	end
end

-- =========================
-- SCROLL (Scripts page)
-- =========================

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,0,1,0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 2
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.Parent = scriptPage

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,8)
layout.Parent = scroll

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end)

-- =========================
-- RUN SCRIPT
-- =========================

local function run(file)
	log.Text = "Loading "..file

	local ok, src = pcall(function()
		return HttpGet(game, BASE_URL .. file .. "?t=" .. os.time())
	end)

	if not ok then
		log.Text = "Fetch failed"
		return
	end

	local func = loadstring(src)
	if not func then
		log.Text = "Compile error"
		return
	end

	local success = pcall(func)
	log.Text = success and ("Executed "..file) or "Runtime error"
end

-- =========================
-- BUTTONS
-- =========================

local function createButton(file)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1,-5,0,45)
	button.BackgroundColor3 = BUTTON
	button.BackgroundTransparency = 0.2
	button.Text = file.name:gsub("%.luau$","")
	button.TextColor3 = TEXT
	button.Font = Enum.Font.GothamBold
	button.TextScaled = true
	button.Parent = scroll

	Instance.new("UICorner", button).CornerRadius = UDim.new(0,14)

	local s = Instance.new("UIStroke")
	s.Color = ACCENT
	s.Transparency = 0.5
	s.Parent = button

	button.MouseButton1Click:Connect(function()
		run(file.name)
	end)
end

-- =========================
-- SIDEBAR TABS
-- =========================

local function makeTab(name, y)
	local tab = Instance.new("TextButton")
	tab.Size = UDim2.new(1,-10,0,40)
	tab.Position = UDim2.new(0,5,0,y)
	tab.BackgroundColor3 = BUTTON
	tab.BackgroundTransparency = 0.25
	tab.Text = name
	tab.TextColor3 = TEXT
	tab.Font = Enum.Font.GothamBold
	tab.TextScaled = true
	tab.BorderSizePixel = 0
	tab.Parent = sidebar

	Instance.new("UICorner", tab).CornerRadius = UDim.new(0,12)

	local s = Instance.new("UIStroke")
	s.Color = ACCENT
	s.Transparency = 0.6
	s.Parent = tab

	return tab
end

local homeTab = makeTab("Home",70)
local scriptTab = makeTab("Scripts",120)
local playerTab = makeTab("Player",170)

homeTab.MouseButton1Click:Connect(function()
	showPage("Home")
end)

scriptTab.MouseButton1Click:Connect(function()
	showPage("Scripts")
end)

playerTab.MouseButton1Click:Connect(function()
	showPage("Player")
end)

-- =========================
-- HOME CONTENT
-- =========================

local homeText = Instance.new("TextLabel")
homeText.Size = UDim2.new(1,0,0,100)
homeText.BackgroundTransparency = 1
homeText.Text = "Welcome to FriHub"
homeText.TextColor3 = TEXT
homeText.Font = Enum.Font.GothamBold
homeText.TextScaled = true
homeText.Parent = homePage

-- =========================
-- CLOSE / MINIMIZE
-- =========================

local minimized = false

local close = Instance.new("TextButton")
close.Size = UDim2.new(0,32,0,32)
close.Position = UDim2.new(1,-40,0,10)
close.BackgroundColor3 = Color3.fromRGB(55,55,70)
close.Text = "✕"
close.TextColor3 = TEXT
close.TextScaled = true
close.Font = Enum.Font.GothamBold
close.Parent = frame

Instance.new("UICorner", close).CornerRadius = UDim.new(0,10)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0,32,0,32)
minimize.Position = UDim2.new(1,-80,0,10)
minimize.BackgroundColor3 = Color3.fromRGB(55,55,70)
minimize.Text = "-"
minimize.TextColor3 = TEXT
minimize.TextScaled = true
minimize.Font = Enum.Font.GothamBold
minimize.Parent = frame

Instance.new("UICorner", minimize).CornerRadius = UDim.new(0,10)

minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	content.Visible = not minimized
	log.Visible = not minimized
	frame.Size = minimized and UDim2.new(0,360,0,60) or UDim2.new(0,520,0,420)
end)

-- =========================
-- DRAG
-- =========================

local dragging = false
local dragStart
local startPos

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- =========================
-- OPEN ANIMATION
-- =========================

frame.Size = UDim2.new(0,0,0,0)

TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
	Size = UDim2.new(0,520,0,420)
}):Play()

-- DEFAULT PAGE
showPage("Home")
