local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("SetHitboxSize")

local gui = Instance.new("ScreenGui")
gui.Name = "HitboxPanel"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(260, 110)
panel.Position = UDim2.fromOffset(20, 100)
panel.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
panel.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.fromOffset(10, 5)
title.BackgroundTransparency = 1
title.Text = "Hitbox size"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18
title.Parent = panel

local bar = Instance.new("Frame")
bar.Size = UDim2.new(1, -40, 0, 18)
bar.Position = UDim2.fromOffset(20, 45)
bar.BackgroundColor3 = Color3.fromRGB(80, 80, 85)
bar.Active = true
bar.Parent = panel

local fill = Instance.new("Frame")
fill.Size = UDim2.fromScale(1, 1)
fill.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
fill.BorderSizePixel = 0
fill.Parent = bar

local box = Instance.new("TextBox")
box.Size = UDim2.fromOffset(80, 25)
box.Position = UDim2.new(0.5, -40, 0, 75)
box.BackgroundColor3 = Color3.fromRGB(65, 65, 70)
box.TextColor3 = Color3.new(1, 1, 1)
box.TextSize = 16
box.ClearTextOnFocus = false
box.Text = "100%"
box.Parent = panel

local function setPercent(value)
    value = math.clamp(math.floor(value + 0.5), 0, 100)
    fill.Size = UDim2.fromScale(value / 100, 1)
    box.Text = value .. "%"
    remote:FireServer(value)
end

local function updateFromX(x)
    local fraction = (x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
    setPercent(fraction * 100)
end

local dragging = false

bar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        updateFromX(input.Position.X)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        updateFromX(input.Position.X)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

box.FocusLost:Connect(function()
    local value = tonumber(box.Text:gsub("%%", ""))
    setPercent(value or 100)
end)

player.CharacterAdded:Connect(function()
    setPercent(100)
end)
