local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local HttpGet = game.HttpGet
local loadstring = loadstring

-- UI作成
local gui = Instance.new("ScreenGui", PlayerGui)

local log = Instance.new("TextLabel")
log.Size = UDim2.new(0, 300, 0, 60)
log.Position = UDim2.new(0.5, -150, 0.5, -30)
log.Text = "Ready"
log.Parent = gui

-- NotifyをUIに接続
getgenv().Notify = function(text)
    log.Text = text
end

-- GitHubから取得
local url = "https://raw.githubusercontent.com/tomatizuo-dot/test/main/Games/123456.lua"

local source = HttpGet(game, url)
local func = loadstring(source)
func()
