local bundleId = 148351107651039
local player = game:GetService("Players").LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local userInputService = game:GetService("UserInputService")

local isReanimated = false
local connections = {}
local fakeChar = nil

local function toggleReanimation()
    isReanimated = not isReanimated
    if isReanimated then
        fakeChar = Instance.new("Model")
        fakeChar.Name = "Bundle_Reanim"
        fakeChar.Parent = workspace
        local hum = Instance.new("Humanoid", fakeChar)
        local success, bundleDesc = pcall(function()
            return game:GetService("Players"):GetHumanoidDescriptionFromOutfitId(bundleId)
        end)
        if success then hum:ApplyDescription(bundleDesc) end
        char.Archivable = true
        for _, v in pairs(char:GetDescendants()) do if v:IsA("Motor6D") then v.Enabled = false end end
        connections.noclip = runService.Stepped:Connect(function()
            for _, v in pairs({fakeChar, char}) do
                for _, part in pairs(v:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
            end
        end)
        connections.align = runService.Heartbeat:Connect(function()
            settings().Physics.AllowSleep = false
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    local target = fakeChar:FindFirstChild(part.Name)
                    if target then
                        part.CFrame = target.CFrame
                        part.Velocity = Vector3.new(0, 35, 0)
                    end
                end
            end
        end)
        workspace.CurrentCamera.CameraSubject = hum
    else
        if connections.noclip then connections.noclip:Disconnect() end
        if connections.align then connections.align:Disconnect() end
        if fakeChar and fakeChar:FindFirstChild("HumanoidRootPart") then
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    local bundlePart = fakeChar:FindFirstChild(part.Name)
                    if bundlePart then tweenService:Create(part, tweenInfo, {CFrame = bundlePart.CFrame}):Play() end
                end
            end
            task.wait(0.5)
        end
        if fakeChar then fakeChar:Destroy() end
        for _, v in pairs(char:GetDescendants()) do if v:IsA("Motor6D") then v.Enabled = true end end
        workspace.CurrentCamera.CameraSubject = char:FindFirstChild("Humanoid")
    end
end

local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
sg.Name = "reanimation bundle thingy"
sg.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 220, 0, 120)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -60)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.BorderSizePixel = 0

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

runService.RenderStepped:Connect(function()
    stroke.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
end)

local gradient = Instance.new("UIGradient", mainFrame)
gradient.Rotation = 45
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(45, 0, 75)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(15, 0, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(75, 0, 130))
})

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0.3, 0)
title.BackgroundTransparency = 1
title.Text = "reanimation bundle thingy"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

local toggleBtn = Instance.new("TextButton", mainFrame)
toggleBtn.Size = UDim2.new(0.8, 0, 0.4, 0)
toggleBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleBtn.BackgroundTransparency = 0.6
toggleBtn.Text = "TOGGLE"
toggleBtn.TextColor3 = Color3.fromRGB(200, 150, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14

Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

-- Drag Logic
local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
userInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    toggleReanimation()
    toggleBtn.Text = isReanimated and "ACTIVE" or "INACTIVE"
end)
