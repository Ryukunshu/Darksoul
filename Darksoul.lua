local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("JumpscareGui") then
    PlayerGui.JumpscareGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "JumpscareGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(1,0,1,0)
frame.BackgroundColor3 = Color3.new(0,0,0)
frame.Parent = gui

local image = Instance.new("ImageLabel")
image.Size = UDim2.new(1,0,1,0)
image.BackgroundTransparency = 1
image.Image = "https://share.google/images/zr9FFmlIAxG3Q9bO8"
image.Parent = frame

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://9129360055"
sound.Volume = 10
sound.Looped = true
sound.Parent = PlayerGui
sound:Play()

task.spawn(function()
    while gui.Parent do
        frame.BackgroundColor3 = Color3.new(1,0,0)
        task.wait(0.1)
        frame.BackgroundColor3 = Color3.new(0,0,0)
        task.wait(0.1)
    end
end)
