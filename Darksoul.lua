-- Robust local-only jumpscare (works in most games)
pcall(function()
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")

    -- wait for LocalPlayer (timeout if not found)
    local player
    local start = tick()
    repeat
        player = Players.LocalPlayer
        task.wait(0.05)
    until player or tick() - start > 8
    if not player then return end

    local playerGui = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 5)
    if not playerGui then return end

    -- avoid duplicates
    local EXISTING = playerGui:FindFirstChild("LocalJumpscareGui_v2")
    if EXISTING then
        pcall(function() EXISTING:Destroy() end)
    end

    -- ======= CONFIG: put your ids here (numbers only) =======
    local IMAGE_ASSET_ID = "1234567890" -- replace with decal id for the killer image
    local SOUND_ASSET_ID = "1234567890" -- replace with uploaded audio id
    local FADE_IN_TIME = 0.07
    local MAX_WAIT_BEFORE_EXIT = 8
    -- =======================================================

    if not tonumber(IMAGE_ASSET_ID) or not tonumber(SOUND_ASSET_ID) then
        warn("Jumpscare: please replace IMAGE_ASSET_ID and SOUND_ASSET_ID with numeric asset IDs.")
        return
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "LocalJumpscareGui_v2"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 9999
    gui.Parent = playerGui

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1,0,1,0)
    bg.Position = UDim2.new(0,0,0,0)
    bg.BackgroundColor3 = Color3.new(0,0,0)
    bg.BackgroundTransparency = 1
    bg.BorderSizePixel = 0
    bg.ZIndex = 9998
    bg.Parent = gui

    local image = Instance.new("ImageLabel")
    image.Name = "JumpscareImage"
    image.AnchorPoint = Vector2.new(0.5,0.5)
    image.Size = UDim2.new(1,0,1,0)
    image.Position = UDim2.new(0.5,0,0.5,0)
    image.BackgroundTransparency = 1
    image.Image = "rbxassetid://" .. IMAGE_ASSET_ID
    image.ImageTransparency = 1
    image.ZIndex = 9999
    image.ScaleType = Enum.ScaleType.Stretch
    image.Parent = gui

    -- local sound parented to GUI (only this player hears it)
    local sound = Instance.new("Sound")
    sound.Name = "JumpscareSound"
    sound.SoundId = "rbxassetid://" .. SOUND_ASSET_ID
    sound.Looped = true
    sound.Volume = 1 -- Roblox caps at 1; if not loud enough, normalize the file before upload
    sound.PlaybackSpeed = 1
    sound.Parent = gui

    -- Play safely
    pcall(function() sound:Play() end)
    -- fallback: if Ended fires for any reason, restart
    pcall(function()
        sound.Ended:Connect(function()
            pcall(function() sound:Play() end)
        end)
    end)

    -- quick fade-in for image & optional bg flash
    pcall(function()
        bg.BackgroundTransparency = 0
        local t1 = TweenService:Create(bg, TweenInfo.new(0.03), {BackgroundTransparency = 0})
        t1:Play()
        task.wait(0.01)
    end)
    local tween = TweenService:Create(image, TweenInfo.new(FADE_IN_TIME, Enum.EasingStyle.Linear), {ImageTransparency = 0})
    tween:Play()

    -- stop function
    local function stopAll()
        pcall(function() sound:Stop() end)
        pcall(function() gui:Destroy() end)
    end

    -- stop via RightShift or left click (works on mobile too via touch/click)
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.RightShift then
            stopAll()
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            stopAll()
        end
    end)

    -- auto-clean if player leaves
    player.AncestryChanged:Connect(function()
        if not player:IsDescendantOf(game) then stopAll() end
    end)
end)
