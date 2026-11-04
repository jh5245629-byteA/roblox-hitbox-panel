local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote = Instance.new("RemoteEvent")
remote.Name = "SetHitboxSize"
remote.Parent = ReplicatedStorage

-- Hitbox dimensions at 100%, in studs.
local MAX_SIZE = Vector3.new(4, 5, 4)

local function createHitbox(character)
    local root = character:WaitForChild("HumanoidRootPart", 10)
    if not root then return end

    local hitbox = Instance.new("Part")
    hitbox.Name = "AdjustableHitbox"
    hitbox.Size = MAX_SIZE
    hitbox.Transparency = 0.7
    hitbox.Color = Color3.fromRGB(255, 50, 50)
    hitbox.Material = Enum.Material.ForceField
    hitbox.CanCollide = false
    hitbox.CanTouch = true
    hitbox.CanQuery = true
    hitbox.Massless = true
    hitbox.CFrame = root.CFrame
    hitbox.Parent = character

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = root
    weld.Part1 = hitbox
    weld.Parent = hitbox
end

local function setupPlayer(player)
    player.CharacterAdded:Connect(createHitbox)
    if player.Character then
        task.spawn(createHitbox, player.Character)
    end
end

Players.PlayerAdded:Connect(setupPlayer)
for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end

remote.OnServerEvent:Connect(function(player, percent)
    if typeof(percent) ~= "number" or percent ~= percent then return end
    percent = math.clamp(percent, 0, 100)

    local character = player.Character
    local hitbox = character and character:FindFirstChild("AdjustableHitbox")
    if not hitbox then return end

    local enabled = percent > 0
    -- Roblox parts must have a nonzero size.
    local scale = math.max(percent / 100, 0.01)
    hitbox.Size = MAX_SIZE * scale
    hitbox.Transparency = enabled and 0.7 or 1
    hitbox.CanTouch = enabled
    hitbox.CanQuery = enabled
end)
