getgenv().Notify("外部スクリプト読み込み成功")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.Parent = gui

local text = Instance.new("TextLabel")
text.Size = UDim2.new(1,0,1,0)
text.Text = "Hello from GitHub"
text.TextColor3 = Color3.new(1,1,1)
text.Parent = frame
