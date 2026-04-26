local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 1. Main HUD Container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RobotVisionV10"
ScreenGui.IgnoreGuiInset = true 
ScreenGui.Parent = game:GetService("CoreGui")

-- 2. Screen Tint
local Tint = Instance.new("Frame")
Tint.Size = UDim2.new(1, 0, 1, 0)
Tint.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
Tint.BackgroundTransparency = 0.94
Tint.ZIndex = -1
Tint.Parent = ScreenGui

-- 3. Fixed Radar UI
local RadarFrame = Instance.new("Frame")
RadarFrame.Size = UDim2.new(0, 150, 0, 150)
RadarFrame.Position = UDim2.new(1, -170, 0, 20)
RadarFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
RadarFrame.BorderSizePixel = 2
RadarFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
RadarFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = RadarFrame

-- Crosshair/Center Dot (Shows where YOU are)
local CenterX = Instance.new("Frame")
CenterX.Size = UDim2.new(0, 10, 0, 1)
CenterX.Position = UDim2.new(0.5, -5, 0.5, 0)
CenterX.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
CenterX.Parent = RadarFrame

local CenterY = Instance.new("Frame")
CenterY.Size = UDim2.new(0, 1, 0, 10)
CenterY.Position = UDim2.new(0.5, 0, 0.5, -5)
CenterY.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
CenterY.Parent = RadarFrame

-- CORRECTED Scanning Line (Anchored to center)
local SweepContainer = Instance.new("Frame")
SweepContainer.Size = UDim2.new(0, 0, 0, 0)
SweepContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
SweepContainer.BackgroundTransparency = 1
SweepContainer.Parent = RadarFrame

local Sweep = Instance.new("Frame")
Sweep.Size = UDim2.new(0, 75, 0, 2)
Sweep.Position = UDim2.new(0, 0, 0, 0)
Sweep.AnchorPoint = Vector2.new(0, 0.5) -- Rotates around the container's center
Sweep.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
Sweep.BorderSizePixel = 0
Sweep.Parent = SweepContainer

-- Alert Warning
local AlertText = Instance.new("TextLabel")
AlertText.Size = UDim2.new(0, 250, 0, 50)
AlertText.Position = UDim2.new(0.5, -125, 0.15, 0)
AlertText.BackgroundTransparency = 1
AlertText.TextColor3 = Color3.fromRGB(255, 0, 0)
AlertText.Font = Enum.Font.Code
AlertText.TextSize = 25
AlertText.Text = "⚠️ PROXIMITY ALERT ⚠️"
AlertText.Visible = false
AlertText.Parent = ScreenGui

-- Toggle Button
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0, 65, 0, 25)
Toggle.Position = UDim2.new(1, -75, 0, 180)
Toggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Toggle.TextColor3 = Color3.fromRGB(0, 255, 0)
Toggle.Text = "[RADAR]"
Toggle.Font = Enum.Font.Code
Toggle.TextSize = 12
Toggle.Parent = ScreenGui

Toggle.MouseButton1Click:Connect(function()
    RadarFrame.Visible = not RadarFrame.Visible
end)

-- Animation Loop
task.spawn(function()
    local angle = 0
    while true do
        angle = (angle + 4) % 360
        SweepContainer.Rotation = angle
        if AlertText.Visible then
            AlertText.TextTransparency = (math.sin(tick() * 12) + 1) / 2
        end
        task.wait()
    end
end)

local function createHUD(player)
    if player == LocalPlayer then return end
    
    local folder = Instance.new("Folder")
    folder.Name = player.Name
    folder.Parent = ScreenGui

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.FillTransparency = 0.65
    highlight.Parent = folder

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(0, 160, 0, 50)
    info.BackgroundTransparency = 1
    info.TextColor3 = Color3.fromRGB(0, 255, 0)
    info.Font = Enum.Font.Code
    info.TextSize = 11
    info.Visible = false
    info.Parent = folder

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 5, 0, 5)
    dot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    dot.BorderSizePixel = 0
    dot.ZIndex = 2
    dot.Parent = RadarFrame
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot

    local connection
    connection = RunService.RenderStepped:Connect(function()
        local char = player.Character
        local lChar = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not lChar or not lChar:FindFirstChild("HumanoidRootPart") then
            info.Visible, dot.Visible = false, false
            highlight.Adornee = nil
            return
        end

        local root = char.HumanoidRootPart
        local lRoot = lChar.HumanoidRootPart
        local hum = char:FindFirstChild("Humanoid")
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        local distance = (root.Position - lRoot.Position).Magnitude

        -- Status Logic
        local status = "ALIVE"
        local statusColor = Color3.fromRGB(0, 255, 0)
        local health = hum and hum.Health or 0
        
        if health <= 0 then
            status = "DEAD"
            statusColor = Color3.fromRGB(255, 0, 0)
        end

        highlight.Adornee = char
        highlight.FillColor = statusColor
        
        -- Radar Tracking (Rotates with Camera)
        local lookVector = Camera.CFrame.LookVector
        local flatLook = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
        local relativePos = root.Position - lRoot.Position
        
        local x = relativePos:Dot(Camera.CFrame.RightVector)
        local z = -relativePos:Dot(flatLook)
        
        local radarX = (x / 200) * 75
        local radarZ = (z / 200) * 75
        
        local distScale = math.sqrt(radarX^2 + radarZ^2)
        if distScale > 70 then
            radarX, radarZ = (radarX / distScale) * 70, (radarZ / distScale) * 70
        end

        dot.Position = UDim2.new(0.5, radarX - 2.5, 0.5, radarZ - 2.5)
        dot.BackgroundColor3 = statusColor
        dot.Visible = RadarFrame.Visible

        -- Proximity Alert Logic
        local isAnyoneClose = false
        if health > 0 and distance < 15 then
            isAnyoneClose = true
        end
        AlertText.Visible = isAnyoneClose

        -- POV Info
        if onScreen then
            info.Position = UDim2.new(0, pos.X + 15, 0, pos.Y - 15)
            info.Text = string.format("[%s]\nSTATUS: %s\nHP: %d\nDST: %d", player.Name:upper(), status, health, math.floor(distance))
            info.Visible = true
            info.TextColor3 = (distance < 15 or health <= 0) and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
        else
            info.Visible = false
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do createHUD(p) end
Players.PlayerAdded:Connect(createHUD)
