local player = game:GetService("Players").LocalPlayer or game:GetService("Players").PlayerAdded:Wait()
local playerGui = player:WaitForChild("PlayerGui")
local httpService = game:GetService("HttpService")
local assetService = game:GetService("AssetService")
local runService = game:GetService("RunService")
local starterGui = game:GetService("StarterGui")

local PROXY_URL = "https://roproxy.com"
local OriginalDesc = player.Character:WaitForChild("Humanoid"):GetAppliedDescription()
local ReanimConnections = {}

local function Notify(title, text)
    starterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 3
    })
end

local function Reanimate()
    local char = player.Character
    if not char then return end
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            local conn = runService.Stepped:Connect(function()
                v.Velocity = Vector3.new(0, -30, 0)
                v.CanCollide = false
            end)
            table.insert(ReanimConnections, conn)
        end
    end
end

local function ClearReanim()
    for _, conn in pairs(ReanimConnections) do conn:Disconnect() end
    ReanimConnections = {}
    local char = player.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.Velocity = Vector3.new(0, 0, 0) end
        end
        char.Humanoid:ApplyDescription(OriginalDesc)
    end
    Notify("Reset", "Original avatar restored.")
end

local function BypassAndProtect(humanoid)
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldIdx = mt.__index
    mt.__index = newcclosure(function(t, k)
        if not checkcaller() then
            if t == humanoid and (k == "BodyHeightScale" or k == "BodyWidthScale" or k == "BodyDepthScale" or k == "HeadScale") then
                return 1
            end
        end
        return oldIdx(t, k)
    end)
    setreadonly(mt, true)
end

local ScreenGui = Instance.new("ScreenGui", playerGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 480)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.new(1, 1, 1)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 10)

local RainbowStroke = Instance.new("UIStroke", MainFrame)
RainbowStroke.Thickness = 3
RainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

task.spawn(function()
    local hue = 0
    while task.wait() do
        hue = hue + (1/300)
        if hue > 1 then hue = 0 end
        RainbowStroke.Color = Color3.fromHSV(hue, 1, 1)
    end
end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "reanimation bundle thingy"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

local Gradient = Instance.new("UIGradient", MainFrame)
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 0, 75))
})
Gradient.Rotation = 45

local ResetBtn = Instance.new("TextButton", MainFrame)
ResetBtn.Size = UDim2.new(1, -20, 0, 30)
ResetBtn.Position = UDim2.new(0, 10, 1, -40)
ResetBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ResetBtn.BackgroundTransparency = 0.5
ResetBtn.Text = "Un-Reanimate / Reset"
ResetBtn.TextColor3 = Color3.new(1, 1, 1)
ResetBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0, 6)
ResetBtn.MouseButton1Click:Connect(ClearReanim)

local SearchBar = Instance.new("TextBox", MainFrame)
SearchBar.Size = UDim2.new(1, -20, 0, 35)
SearchBar.Position = UDim2.new(0, 10, 0, 40)
SearchBar.PlaceholderText = "Type to search..."
SearchBar.Text = ""
SearchBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SearchBar.BackgroundTransparency = 0.5
SearchBar.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", SearchBar).CornerRadius = UDim.new(0, 8)

local ScrollingFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollingFrame.Size = UDim2.new(1, -20, 1, -125)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 80)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 0
ScrollingFrame.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", ScrollingFrame)
UIList.Padding = UDim.new(0, 8)

local function ApplyBundle(bundleId)
    Notify("Status", "Fetching Bundle Data...")
    local s, details = pcall(function() return assetService:GetBundleDetailsAsync(bundleId) end)
    if s and details then
        local outfitId = 0
        for _, item in pairs(details.Items) do
            if item.Type == "UserOutfit" then outfitId = item.Id break end
        end
        if outfitId > 0 then
            Reanimate()
            local desc = game.Players:GetHumanoidDescriptionFromOutfitId(outfitId)
            local character = player.Character or player.CharacterAdded:Wait()
            local hum = character:WaitForChild("Humanoid")
            BypassAndProtect(hum)
            hum:ApplyDescription(desc)
            Notify("Success", "Bundle " .. details.Name .. " Replicated!")
        end
    else
        Notify("Error", "Failed to load bundle.")
    end
end

local lastSearch = 0
local function LoadBundles(query)
    lastSearch = tick()
    local currentSearch = lastSearch
    
    task.delay(0.5, function()
        if currentSearch ~= lastSearch then return end
        
        for _, child in pairs(ScrollingFrame:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        local url = PROXY_URL .. (query ~= "" and "&keyword=" .. httpService:UrlEncode(query) or "")
        local success, response = pcall(function() return game:HttpGet(url) end)
        
        if success then
            local data = httpService:JSONDecode(response).data
            ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #data * 48)
            for _, bundle in pairs(data) do
                local btn = Instance.new("TextButton", ScrollingFrame)
                btn.Size = UDim2.new(1, 0, 0, 40)
                btn.Text = bundle.name
                btn.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
                btn.BackgroundTransparency = 0.6
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.Font = Enum.Font.SourceSansBold
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
                btn.MouseButton1Click:Connect(function() ApplyBundle(bundle.id) end)
            end
        end
    end)
end

SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    LoadBundles(SearchBar.Text)
end)

LoadBundles("")
