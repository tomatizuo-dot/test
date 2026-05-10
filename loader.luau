-- =========================
-- SERVICES
-- =========================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- =========================
-- CLEAN
-- =========================

local old = PlayerGui:FindFirstChild("ModernLoader")
if old then old:Destroy() end

-- =========================
-- STYLE
-- =========================

local PANEL = Color3.fromRGB(28,28,36)
local BUTTON = Color3.fromRGB(36,36,46)
local ACCENT = Color3.fromRGB(145,105,255)
local TEXT = Color3.fromRGB(235,235,235)

-- =========================
-- ICONS（更新済み）
-- =========================

local ICONS = {
	Home = "rbxassetid://118285470604863",
	Scripts = "rbxassetid://117494037243077",
	Player = "rbxassetid://113102983109919",
	Settings = "rbxassetid://132024129395162"
}

-- =========================
-- GUI
-- =========================

local gui = Instance.new("ScreenGui")
gui.Name = "ModernLoader"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,520,0,420)
frame.Position = UDim2.new(0.5,-260,0.5,-210)
frame.BackgroundColor3 = PANEL
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

-- =========================
-- SIDEBAR
-- =========================

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0,90,1,0)
sidebar.BackgroundColor3 = Color3.fromRGB(24,24,32)
sidebar.Parent = frame

Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0,16)

-- =========================
-- CONTENT
-- =========================

local content = Instance.new("Frame")
content.Size = UDim2.new(1,-100,1,-10)
content.Position = UDim2.new(0,95,0,5)
content.BackgroundTransparency = 1
content.Parent = frame

-- =========================
-- PAGES
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
local settingsPage = makePage("Settings")

-- =========================
-- HOME
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
-- SCRIPTS
-- =========================

local function addScript(text)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-20,0,40)
	b.Position = UDim2.new(0,10,0,0)
	b.BackgroundColor3 = BUTTON
	b.Text = text
	b.TextColor3 = TEXT
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.Parent = scriptPage

	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)

	b.MouseButton1Click:Connect(function()
		if text == "tp" then
			player.Character:MoveTo(Vector3.new(0,50,0))
		end
	end)
end

addScript("tp")
addScript("test")

-- =========================
-- PLAYER
-- =========================

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0,90,0,90)
avatar.Position = UDim2.new(0,10,0,10)
avatar.BackgroundTransparency = 1
avatar.ScaleType = Enum.ScaleType.Fit
avatar.Parent = playerPage

avatar.Image = Players:GetUserThumbnailAsync(
	player.UserId,
	Enum.ThumbnailType.HeadShot,
	Enum.ThumbnailSize.Size420x420
)

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1,-120,0,40)
nameLabel.Position = UDim2.new(0,120,0,10)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = player.Name
nameLabel.TextColor3 = TEXT
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextScaled = true
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Parent = playerPage

-- =========================
-- SETTINGS TOGGLE
-- =========================

local function createToggle(text,y,callback)
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1,-20,0,40)
	holder.Position = UDim2.new(0,10,0,y)
	holder.BackgroundColor3 = BUTTON
	holder.Parent = settingsPage

	Instance.new("UICorner", holder).CornerRadius = UDim.new(0,10)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,-80,1,0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = TEXT
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = holder

	local back = Instance.new("Frame")
	back.Size = UDim2.new(0,50,0,24)
	back.Position = UDim2.new(1,-60,0.5,-12)
	back.BackgroundColor3 = Color3.fromRGB(60,60,70)
	back.Parent = holder

	Instance.new("UICorner", back).CornerRadius = UDim.new(1,0)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0,20,0,20)
	knob.Position = UDim2.new(0,2,0.5,-10)
	knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
	knob.Parent = back

	Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

	local state = false

	holder.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			state = not state

			TweenService:Create(back,TweenInfo.new(0.2),{
				BackgroundColor3 = state and ACCENT or Color3.fromRGB(60,60,70)
			}):Play()

			TweenService:Create(knob,TweenInfo.new(0.2),{
				Position = state and UDim2.new(1,-22,0.5,-10) or UDim2.new(0,2,0.5,-10)
			}):Play()

			if callback then callback(state) end
		end
	end)
end

createToggle("UI Enabled",10,function(v)
	gui.Enabled = v
end)

-- =========================
-- INDICATOR
-- =========================

local indicator = Instance.new("Frame")
indicator.Size = UDim2.new(0,4,0,40)
indicator.Position = UDim2.new(0,0,0,70)
indicator.BackgroundColor3 = ACCENT
indicator.Parent = sidebar

Instance.new("UICorner", indicator).CornerRadius = UDim.new(1,0)

-- =========================
-- TAB SYSTEM
-- =========================

local tabButtons = {}
local current = nil

local function showPage(name)
	if current then
		pages[current].Visible = false
	end
	pages[name].Visible = true
	current = name
end

local function makeTab(name,y)
	local t = Instance.new("TextButton")
	t.Size = UDim2.new(1,-10,0,40)
	t.Position = UDim2.new(0,5,0,y)
	t.BackgroundColor3 = BUTTON
	t.Text = ""
	t.Parent = sidebar

	Instance.new("UICorner", t).CornerRadius = UDim.new(0,12)

	local icon = Instance.new("ImageLabel")
	icon.Size = UDim2.new(0,28,0,28)
	icon.Position = UDim2.new(0,10,0.5,-14)
	icon.BackgroundTransparency = 1
	icon.Image = ICONS[name]
	icon.ImageColor3 = TEXT
	icon.ScaleType = Enum.ScaleType.Fit
	icon.Parent = t

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,-50,1,0)
	label.Position = UDim2.new(0,44,0,0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = TEXT
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = t

	tabButtons[name] = t

	t.MouseButton1Click:Connect(function()
		showPage(name)

		for _,b in pairs(tabButtons) do
			b.BackgroundColor3 = BUTTON
		end

		t.BackgroundColor3 = Color3.fromRGB(55,55,80)

		TweenService:Create(indicator,TweenInfo.new(0.3),{
			Position = UDim2.new(0,0,0,t.Position.Y.Offset)
		}):Play()
	end)
end

makeTab("Home",70)
makeTab("Scripts",120)
makeTab("Player",170)
makeTab("Settings",220)

-- =========================
-- MINIMIZE
-- =========================

local minimized = false

local function setMinimized(state)
	minimized = state
	content.Visible = not state
	sidebar.Visible = not state
	frame.Size = state and UDim2.new(0,520,0,60) or UDim2.new(0,520,0,420)
end

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0,30,0,30)
minBtn.Position = UDim2.new(1,-80,0,10)
minBtn.Text = "-"
minBtn.TextScaled = true
minBtn.BackgroundColor3 = BUTTON
minBtn.TextColor3 = TEXT
minBtn.Parent = frame

Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,8)

minBtn.MouseButton1Click:Connect(function()
	setMinimized(not minimized)
end)

-- =========================
-- START
-- =========================

showPage("Home")
tabButtons["Home"].BackgroundColor3 = Color3.fromRGB(55,55,80)
