local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- 1. HUD Container (Ensures it stays on top)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RobotVision_Elite_V3"
ScreenGui.IgnoreGuiInset = true 
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = game:GetService("CoreGui")

-- 2. Boot Overlay (Forced to the front)
local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Overlay.ZIndex = 9999 -- Maximum Priority
Overlay.Parent = ScreenGui

local MainText = Instance.new("TextLabel")
MainText.Size = UDim2.new(0, 500, 0, 100)
MainText.Position = UDim2.new(0.5, -250, 0.5, -50)
MainText.BackgroundTransparency = 1
MainText.TextColor3 = Color3.fromRGB(0, 255, 0)
MainText.Font = Enum.Font.Code
MainText.TextSize = 24
MainText.Text = "> INITIALISING..."
MainText.ZIndex = 10000
MainText.Parent = Overlay

-- 3. Screen Tint & Global Scan Line
local Tint = Instance.new("Frame")
Tint.Size = UDim2.new(1, 0, 1, 0)
Tint.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
Tint.BackgroundTransparency = 1 
Tint.ZIndex = -1
Tint.Parent = ScreenGui

local MainScanLine = Instance.new("Frame")
MainScanLine.Size = UDim2.new(1, 0, 0, 2)
MainScanLine.Position = UDim2.new(0, 0, -0.1, 0)
MainScanLine.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
MainScanLine.BackgroundTransparency = 0.5
MainScanLine.BorderSizePixel = 0
MainScanLine.Parent = Tint

-- 4. Status Indicator
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0, 250, 0, 30)
StatusLabel.Position = UDim2.new(0, 20, 0, 20)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
StatusLabel.Font = Enum.Font.Code
StatusLabel.TextSize = 18
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = ScreenGui

-- BOOT SEQUENCE WITH FORCED DELAY
task.spawn(function()
    task.wait(0.1) -- Forces screen to draw the black frame first
    local steps = {
        "> CONNECTING TO NEURAL LINK...",
        "> SCANNING BIOMETRICS...",
        "> CALIBRATING HUD...",
        "> SUCCESS!"
    }
    for _, msg in ipairs(steps) do
        MainText.Text = msg
        task.wait(0.8)
    end
    
    TweenService:Create(Overlay, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
    TweenService:Create(MainText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(Tint, TweenInfo.new(1), {BackgroundTransparency = 0.94}):Play()
    
    -- Infinite Scan Line Loop
    while true do
        MainScanLine.Position = UDim2.new(0, 0, -0.01, 0)
        local scan = TweenService:Create(MainScanLine, TweenInfo.new(4, Enum.EasingStyle.Linear), {Position = UDim2.new(0, 0, 1.01, 0)})
        scan:Play()
        scan.Completed:Wait()
    end
end)

-- STATUS & DEATH LOGIC
local hasDied = false
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    
    if hum and hum.Health > 0 then
        hasDied = false
        StatusLabel.Text = "STATUS: ONLINE"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        StatusLabel.TextTransparency = 0
    else
        StatusLabel.Text = "STATUS: DISCONNECTED"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        StatusLabel.TextTransparency = math.random(0, 10) > 7 and 1 or 0
        
        if not hasDied then
            hasDied = true
            Overlay.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            Overlay.BackgroundTransparency = 0.5
            MainText.Text = "CRITICAL ERROR: SYSTEM FAILURE"
            MainText.TextColor3 = Color3.fromRGB(255, 255, 255)
            MainText.TextTransparency = 0
            task.delay(1.5, function()
                TweenService:Create(Overlay, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
                TweenService:Create(MainText, TweenInfo.new(1), {TextTransparency = 1}):Play()
            end)
        end
    end
end)

-- PLAYER TRACKING
local function createHUD(player)
    if player == LocalPlayer then return end
    local highlight = Instance.new("Highlight", ScreenGui)
    local info = Instance.new("TextLabel", ScreenGui)
    info.Size, info.BackgroundTransparency, info.TextColor3, info.Font, info.TextSize = UDim2.new(0, 150, 0, 40), 1, Color3.fromRGB(0, 255, 0), Enum.Font.Code, 12
    info.Visible = false

    RunService.RenderStepped:Connect(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            local hum = char:FindFirstChild("Humanoid")
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            highlight.Adornee = char
            highlight.FillColor = (hum and hum.Health > 0) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            if onScreen then
                info.Position = UDim2.new(0, pos.X + 10, 0, pos.Y - 20)
                info.Text = string.format("[%s]\n%s | HP: %d", player.Name:upper(), (hum.Health > 0 and "ALIVE" or "DEAD"), hum.Health)
                info.Visible = true
            else info.Visible = false end
        else highlight.Adornee = nil info.Visible = false end
    end)
end

for _, p in pairs(Players:GetPlayers()) do createHUD(p) end
Players.PlayerAdded:Connect(createHUD)
