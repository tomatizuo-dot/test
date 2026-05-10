-- =========================
--  SERVICES
-- =========================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local HttpGet = game.HttpGet
local loadstring = loadstring

-- =========================
--  REMOVE OLD UI
-- =========================
local old = PlayerGui:FindFirstChild("OneFileLoader")

if old then
	old:Destroy()
end

-- =========================
--  CONFIG
-- =========================
local BASE_URL = "https://raw.githubusercontent.com/tomatizuo-dot/test/main/Games/"
local API_URL = "https://api.github.com/repos/tomatizuo-dot/test/contents/Games"

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
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

-- タイトルバー
local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1,0,0,30)
topbar.BackgroundColor3 = Color3.fromRGB(35,35,35)
topbar.BorderSizePixel = 0
topbar.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-70,1,0)
title.Position = UDim2.new(0,10,0,0)
title.Text = "One File Loader"
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.Parent = topbar

-- 最小化
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0,30,0,30)
minimize.Position = UDim2.new(1,-60,0,0)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(50,50,50)
minimize.TextColor3 = Color3.fromRGB(255,255,255)
minimize.BorderSizePixel = 0
minimize.Parent = topbar

-- 閉じる
local close = Instance.new("TextButton")
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-30,0,0)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(120,40,40)
close.TextColor3 = Color3.fromRGB(255,255,255)
close.BorderSizePixel = 0
close.Parent = topbar

-- ログ
local log = Instance.new("TextLabel")
log.Size = UDim2.new(1,-10,0,40)
log.Position = UDim2.new(0,5,0,35)
log.Text = "Loading..."
log.TextColor3 = Color3.fromRGB(200,200,200)
log.BackgroundTransparency = 1
log.Parent = frame

-- スクロール
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,-10,1,-80)
scroll.Position = UDim2.new(0,5,0,80)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 4
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,5)
layout.Parent = scroll

-- =========================
--  NOTIFY
-- =========================
getgenv().Notify = function(text)
	log.Text = text
end

-- =========================
--  DRAG (PC + MOBILE)
-- =========================
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)

	local delta = input.Position - dragStart

	frame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

topbar.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()

			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

topbar.InputChanged:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then

		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)

	if input == dragInput and dragging then
		update(input)
	end
end)

-- =========================
--  MINIMIZE
-- =========================
local minimized = false

minimize.MouseButton1Click:Connect(function()

	minimized = not minimized

	if minimized then

		scroll.Visible = false
		log.Visible = false
		frame.Size = UDim2.new(0,320,0,30)
		minimize.Text = "+"

	else

		scroll.Visible = true
		log.Visible = true
		frame.Size = UDim2.new(0,320,0,400)
		minimize.Text = "-"
	end
end)

-- =========================
--  CLOSE
-- =========================
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

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

	local ok, runtimeErr = pcall(func)

	if ok then
		log.Text = "Executed: " .. file
	else
		log.Text = tostring(runtimeErr)
	end
end

-- =========================
--  LOAD LIST
-- =========================
local function loadList()

	local success, response = pcall(function()
		return HttpGet(game, API_URL)
	end)

	if not success then
		log.Text = "API failed"
		return
	end

	local data = HttpService:JSONDecode(response)

	for _, file in ipairs(data) do

		if file.name:match("%.luau$") then

			local btn = Instance.new("TextButton")

			btn.Size = UDim2.new(1,-5,0,40)
			btn.Text = file.name
			btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
			btn.TextColor3 = Color3.fromRGB(255,255,255)
			btn.BorderSizePixel = 0
			btn.Parent = scroll

			btn.MouseButton1Click:Connect(function()
				run(file.name)
			end)
		end
	end

	task.wait()

	scroll.CanvasSize = UDim2.new(
		0,
		0,
		0,
		layout.AbsoluteContentSize.Y + 10
	)

	log.Text = "Loaded"
end

-- =========================
--  START
-- =========================
loadList()
