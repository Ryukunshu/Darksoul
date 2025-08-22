-- Jumpscare (Local only) - paste into your executor
-- Replace IMAGE_ASSET_ID and SOUND_ASSET_ID with actual rbxx asset IDs (numbers).

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then return end

-- === CONFIG ===
local IMAGE_ASSET_ID = "1234567890"   -- <<----- put the killer image asset id here (numbers only)
local SOUND_ASSET_ID = "1234567890"   -- <<----- put the sound asset id here (numbers only)
local IMAGE_DISPLAY_TIME = 99999      -- seconds; set very large to effectively never auto-remove
local SOUND_VOLUME = 1                -- 0..1 (1 is default max); pitching louder requires editing the audio file itself
local FADE_IN_TIME = 0.08             -- fast fade-in
-- ==============

-- create GUI (parented to this player's PlayerGui so only they see it)
local playerGui = player:WaitForChild("PlayerGui")
local gui = Instance.new("ScreenGui")
gui.Name = "LocalJumpscareGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

-- fullscreen image
local image = Instance.new("ImageLabel")
image.Size = UDim2.new(1,0,1,0)
image.Position = UDim2.new(0,0,0,0)
image.BackgroundTransparency = 1
image.Image = "rbxassetid://" .. IMAGE_ASSET_ID
image.Visible = false
image.ZIndex = 9999
image.Parent = gui

-- local sound (parented to the gui so limited to local)
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://" .. SOUND_ASSET_ID
sound.Looped = true
sound.Volume = SOUND_VOLUME
sound.PlaybackSpeed = 1
sound.Parent = gui

-- optional: quick flash / fade in
local function tweenTransparency(obj, from, to, t)
    local start = tick()
    local duration = t
    while tick() - start < duration do
        local alpha = (tick()-start)/duration
        obj.ImageTransparency = from + (to-from) * alpha
        wait()
    end
    obj.ImageTransparency = to
end

-- play jumpscare
local function triggerJumpscare()
    if image.Visible then return end
    image.ImageTransparency = 1
    image.Visible = true
    sound:Play()
    -- fade in quickly
    spawn(function()
        tweenTransparency(image, 1, 0, FADE_IN_TIME)
    end)
    -- optionally auto remove after IMAGE_DISPLAY_TIME (very large by default)
    delay(IMAGE_DISPLAY_TIME, function()
        if image and image.Parent then
            sound:Stop()
            image:Destroy()
            gui:Destroy()
        end
    end)
end

-- stop function (RightShift)
local function stopJumpscare()
    if sound then pcall(function() sound:Stop() end) end
    if image and image.Parent then pcall(function() image:Destroy() end) end
    if gui and gui.Parent then
