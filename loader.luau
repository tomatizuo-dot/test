-- =========================
--  CONFIG
-- =========================
local BASE_URL = "https://raw.githubusercontent.com/tomatizuo-dot/test/main/Games/"
local API_URL = "https://api.github.com/repos/tomatizuo-dot/test/contents/Games"

-- =========================
--  SERVICES
-- =========================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local HttpGet = game.HttpGet
local loadstring = loadstring

-- =========================
--  UI
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "OneFileLoader"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 400)
frame.Position = UDim2.new(0.5, -160, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.Text = "One File Loader"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.Parent = frame

local log = Instance.new("TextLabel")
log.Size = UDim2.new(1, -10, 0, 40)
log.Position = UDim2.new(0,5,0,30)
log.Text = "Ready"
log.TextColor3 = Color3.fromRGB(200,200,200)
log.BackgroundTransparency = 1
log.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -80)
scroll.Position = UDim2.new(0,5,0,80)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Parent = scroll

-- =========================
--  NOTIFY
-- =========================
getgenv().Notify = function(text)
	log.Text = text
end

-- =========================
--  RUN SCRIPT
-- =========================
local function run(file)
	log.Text = "Loading: " .. file

	local success, src = pcall(function()
		return HttpGet(game, BASE_URL .. file)
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
		log.Text = "Executed: " .. file
	else
		log.Text = "Runtime error"
	end
end

-- =========================
--  LOAD LIST (AUTO)
-- =========================
local function loadList()
	local response = HttpGet(game, API_URL)
	local data = HttpService:JSONDecode(response)

	for _, file in ipairs(data) do
		if file.name:match("%.luau$") then

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -10, 0, 40)
			btn.Text = file.name
			btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
			btn.TextColor3 = Color3.fromRGB(255,255,255)
			btn.Parent = scroll

			btn.MouseButton1Click:Connect(function()
				run(file.name)
			end)
		end
	end

	task.wait()
	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
	log.Text = "Loaded"
end

-- =========================
--  START
-- =========================
loadList()
