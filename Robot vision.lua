local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 1. Main HUD Container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RobotVisionV4"
ScreenGui.IgnoreGuiInset = true 
ScreenGui.Parent = game:GetService("CoreGui")

-- 2. Screen Tint & Slim Scan Line
local Tint = Instance.new("Frame")
Tint.Size = UDim2.new(1, 0, 1, 0)
Tint.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
Tint.BackgroundTransparency = 0.92 -- Lighter tint to feel less cramped
Tint.ZIndex = -1
Tint.Parent = ScreenGui

local ScanLine = Instance.new("Frame")
ScanLine.Size = UDim2.new(1, 0, 0, 1)
ScanLine.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
ScanLine.BackgroundTransparency = 0.6
ScanLine.BorderSizePixel = 0
ScanLine.Parent = Tint

task.spawn(function()
    while true do
        ScanLine.Position = UDim2.new(0, 0, 0, 0)
        local tween = game:GetService("TweenService"):Create(ScanLine, TweenInfo.new(5, Enum.EasingStyle.Linear), {Position = UDim2.new(0, 0, 1, 0)})
        tween:Play()
        tween.Completed:Wait()
    end
end)

local function createHUD(player)
    if player == LocalPlayer then return end
    
    local folder = Instance.new("Folder")
    folder.Name = player.Name
    folder.Parent = ScreenGui

    -- Body Part Highlight (Always active)
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.FillTransparency = 0.6
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0.2
    highlight.Parent = folder

    -- Smaller Text Info
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(0, 150, 0, 40) -- Smaller footprint
    info.BackgroundTransparency = 1
    info.TextColor3 = Color3.fromRGB(0, 255, 0)
    info.Font = Enum.Font.Code
    info.TextSize = 12 -- Reduced font size
    info.TextStrokeTransparency = 0.6
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.Visible = false
    info.Parent = folder

    local connection
    connection = RunService.RenderStepped:Connect(function()
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            info.Visible = false
            highlight.Adornee = nil
            return
        end

        local root = char.HumanoidRootPart
        local hum = char:FindFirstChild("Humanoid")
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)

        -- HIGHLIGHT: Always on (even through walls)
        highlight.Adornee = char

        -- TEXT DATA: Only visible when in POV (on screen)
        if onScreen then
            local distance = math.floor((root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
            local health = hum and math.floor(hum.Health) or 0
            
            info.Position = UDim2.new(0, pos.X + 20, 0, pos.Y - 20)
            info.Text = string.format("[%s]\nHP: %d\nDST: %d", player.Name:upper(), health, distance)
            info.Visible = true
        else
            info.Visible = false
        end
    end)

    player.AncestryChanged:Connect(function()
        if not player:IsDescendantOf(game) then
            connection:Disconnect()
            folder:Destroy()
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do createHUD(p) end
Players.PlayerAdded:Connect(createHUD)
