local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local teleportPosition = Vector3.new(57, 3, -9000)
local teleportCount = 10
local delayTime = 0.1

for i = 1, teleportCount do
    humanoidRootPart.CFrame = CFrame.new(teleportPosition)
    wait(delayTime)
end

local function enableNoclip()
    game:GetService("RunService").Stepped:Connect(function()
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
    print("Noclip mode enabled.")
end

local vampireCastle = workspace:FindFirstChild("VampireCastle")
if vampireCastle and vampireCastle.PrimaryPart then
    print("VampireCastle at Z:", vampireCastle.PrimaryPart.Position.Z)

    -- Locate MaximGun and teleport
    local closestGun
    for _, item in pairs(workspace.RuntimeItems:GetDescendants()) do
        if item:IsA("Model") and item.Name == "MaximGun" then
            local dist = (item.PrimaryPart.Position - vampireCastle.PrimaryPart.Position).Magnitude
            if dist <= 500 then
                closestGun = item
                break
            end
        end
    end

    if closestGun then
        local seat = closestGun:FindFirstChild("VehicleSeat")
        if seat then
            -- Teleport to MaximGun
            character:PivotTo(seat.CFrame)
            seat:Sit(humanoid)
            print("Seated on MaximGun.")
            enableNoclip() -- Enable noclip after sitting
        else
            warn("No VehicleSeat on MaximGun.")
        end
    else
        warn("No MaximGun near VampireCastle.")
    end

    -- Locate Chair and teleport
    local foundChair = nil
    for _, chair in pairs(workspace.RuntimeItems:GetDescendants()) do
        if chair.Name == "Chair" then
            local seat = chair:FindFirstChild("Seat")
            if seat and seat.Position.Z >= -9500 and seat.Position.Z <= -9000 then
                foundChair = seat
                break
            end
        end
    end

    if foundChair then
        character:PivotTo(foundChair.CFrame)
        foundChair:Sit(humanoid)
        print("Seated on Chair at Z:", foundChair.Position.Z)
        enableNoclip() -- Enable noclip after sitting
    else
        warn("No Chair found in range.")
    end

    -- Teleport back to MaximGun
    if closestGun then
        local seat = closestGun:FindFirstChild("VehicleSeat")
        if seat then
            character:PivotTo(seat.CFrame)
            seat:Sit(humanoid)
            print("Teleported back to MaximGun.")
        else
            warn("MaximGun seat missing on return teleport.")
        end
    else
        warn("No MaximGun to teleport back to.")
    end

else
    warn("VampireCastle missing or invalid PrimaryPart.")
end
