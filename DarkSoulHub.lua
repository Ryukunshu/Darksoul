local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local img = Instance.new("ImageLabel")
img.Size = UDim2.new(1, 0, 1, 0)
img.Position = UDim2.new(0, 0, 0, 0)
img.BackgroundTransparency = 1
img.Image = "rbxassetid://14120578933" 
img.Parent = gui

task.spawn(function()
    while true do
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://1842533877"
        sound.Volume = 10 -- very loud
        sound.Looped = false
        sound.Parent = player:WaitForChild("PlayerGui")
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 5)
        task.wait(0.2) -- 
    end
end)
