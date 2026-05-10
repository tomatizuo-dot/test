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
-- ICONS
-- =========================

local ICONS = {
	Home = "rbxassetid://87978649114872",
	Scripts = "rbxassetid://88733495296113",
	Player = "rbxassetid://123299484956173",
	Settings = "rbxassetid://139420333843505"
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
frame.BackgroundTransparency = 0.2
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
-- PAGE SYSTEM
-- =========================

local pageContainer = Instance.new("Frame")
pageContainer.Size = UDim2.new(1,0,1,0)
pageContainer.BackgroundTransparency = 1
pageContainer.Parent = content

local pageLayout = Instance.new("Frame")
pageLayout.Size = UDim2.new(3,0,1,0)
pageLayout.BackgroundTransparency = 1
pageLayout.Parent = pageContainer

local pages = {}

local function makePage(name, index)
	local page = Instance.new("Frame")
	page.Size = UDim2.new(1/3,0,1,0)
	page.Position = UDim2.new((index-1)/3,0,0,0)
	page.BackgroundTransparency = 1
	page.Parent = pageLayout

	pages[name] = {
		frame = page,
		index = index
	}

	return page
end

local homePage = makePage("Home",1)
local scriptPage = makePage("Scripts",2)
local playerPage = makePage("Player",3)

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
-- PLAYER
-- =========================

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0,100,0,100)
avatar.Position = UDim2.new(0,10,0,10)
avatar.BackgroundTransparency = 1
avatar.Parent = playerPage

avatar.Image = Players:GetUserThumbnailAsync(
	player.UserId,
	Enum.ThumbnailType.HeadShot,
	Enum.ThumbnailSize.Size100x100
)

-- =========================
-- SCRIPTS
-- =========================

local function addButton(text)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-20,0,40)
	b.BackgroundColor3 = BUTTON
	b.Text = text
	b.TextColor3 = TEXT
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.Parent = scriptPage

	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)

	return b
end

addButton("tp")
addButton("test")

-- =========================
-- INDICATOR
-- =========================

local indicator = Instance.new("Frame")
indicator.Size = UDim2.new(0,4,0,40)
indicator.Position = UDim2.new(0,0,0,70)
indicator.BackgroundColor3 = ACCENT
indicator.BorderSizePixel = 0
indicator.Parent = sidebar

Instance.new("UICorner", indicator).CornerRadius = UDim.new(1,0)

-- =========================
-- TAB SYSTEM
-- =========================

local tabButtons = {}
local current = "Home"

local function showPage(name)
	local target = pages[name].index - 1

	TweenService:Create(pageLayout, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
		Position = UDim2.new(-target,0,0,0)
	}):Play()

	current = name
end

local function makeTab(name, y)
	local t = Instance.new("TextButton")
	t.Size = UDim2.new(1,-10,0,40)
	t.Position = UDim2.new(0,5,0,y)
	t.BackgroundColor3 = BUTTON
	t.Text = ""
	t.Parent = sidebar

	Instance.new("UICorner", t).CornerRadius = UDim.new(0,12)

	-- icon
	local icon = Instance.new("ImageLabel")
	icon.Size = UDim2.new(0,22,0,22)
	icon.Position = UDim2.new(0,12,0.5,-11)
	icon.BackgroundTransparency = 1
	icon.Image = ICONS[name]
	icon.ImageColor3 = TEXT
	icon.Parent = t

	local scale = Instance.new("UIScale")
	scale.Scale = 1
	scale.Parent = icon

	-- label
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,-50,1,0)
	label.Position = UDim2.new(0,40,0,0)
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

		-- indicator move
		TweenService:Create(indicator, TweenInfo.new(0.35), {
			Position = UDim2.new(0,0,0,t.Position.Y.Offset)
		}):Play()

		-- reset tabs
		for _,btn in pairs(tabButtons) do
			TweenService:Create(btn, TweenInfo.new(0.2), {
				BackgroundColor3 = BUTTON
			}):Play()

			local img = btn:FindFirstChildOfClass("ImageLabel")
			if img and img:FindFirstChildOfClass("UIScale") then
				TweenService:Create(img.UIScale, TweenInfo.new(0.2), {
					Scale = 1
				}):Play()
			end
		end

		-- active
		TweenService:Create(t, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(55,55,80)
		}):Play()

		local activeImg = t:FindFirstChildOfClass("ImageLabel")
		if activeImg and activeImg:FindFirstChildOfClass("UIScale") then
			TweenService:Create(activeImg.UIScale, TweenInfo.new(0.2), {
				Scale = 1.1
			}):Play()
		end
	end)

	return t
end

makeTab("Home",70)
makeTab("Scripts",120)
makeTab("Player",170)

-- =========================
-- START
-- =========================

showPage("Home")

task.wait()
indicator.Position = UDim2.new(0,0,0,tabButtons["Home"].Position.Y.Offset)

tabButtons["Home"].BackgroundColor3 = Color3.fromRGB(55,55,80)
