-- STAR'S FINALIZED SECURE RUNNER [V1.0]
local _0xLP = game:GetService("Players").LocalPlayer
local _0xCG = game:GetService("CoreGui")
local _0xTS = game:GetService("TweenService")

local _0xSG = Instance.new("ScreenGui")
_0xSG.Name = "RbxInternal_AlphaCore"
_0xSG.Parent = _0xCG

-- YOUR CONFIG
local _0xK_RAW = {101, 120, 101, 99, 117, 116, 111, 114, 104, 101, 104} -- "executorheh"
local _0xL_URL = "https://link-hub.net"

local function _0xG_K()
    local s = ""
    for _, v in ipairs(_0xK_RAW) do s = s .. string.char(v) end
    return s
end

-- SPLASH SCREEN (ALPHA WOLF)
local _0xSF = Instance.new("Frame")
_0xSF.Size = UDim2.new(1, 0, 1, 0)
_0xSF.BackgroundColor3 = Color3.new(0, 0, 0)
_0xSF.ZIndex = 10
_0xSF.Parent = _0xSG

local _0xWI = Instance.new("ImageLabel")
_0xWI.Size = UDim2.new(0, 400, 0, 400)
_0xWI.Position = UDim2.new(0.5, -200, 0.5, -200)
_0xWI.BackgroundTransparency = 1
_0xWI.Image = "rbxassetid://13444747376" 
_0xWI.ImageTransparency = 1
_0xWI.Parent = _0xSF

-- MAIN EXECUTOR (HIDDEN)
local _0xMF = Instance.new("Frame")
_0xMF.Size = UDim2.new(0, 400, 0, 250)
_0xMF.Position = UDim2.new(0.5, -200, 0.5, -125)
_0xMF.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
_0xMF.Visible = false
_0xMF.Active = true
_0xMF.Draggable = true
_0xMF.Parent = _0xSG
Instance.new("UICorner", _0xMF).CornerRadius = UDim.new(0, 10)

local _0xED = Instance.new("TextBox")
_0xED.Size = UDim2.new(0.95, 0, 0.6, 0)
_0xED.Position = UDim2.new(0.025, 0, 0.05, 0)
_0xED.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
_0xED.TextColor3 = Color3.new(1, 1, 1)
_0xED.MultiLine = true
_0xED.Font = Enum.Font.Code
_0xED.Text = ""
_0xED.PlaceholderText = "-- Ready for your scripts, Jon..."
_0xED.Parent = _0xMF
Instance.new("UICorner", _0xED)

-- KEY FRAME
local _0xKF = Instance.new("Frame")
_0xKF.Size = UDim2.new(0, 300, 0, 160)
_0xKF.Position = UDim2.new(0.5, -150, 0.5, -80)
_0xKF.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
_0xKF.Visible = false
_0xKF.Parent = _0xSG
Instance.new("UICorner", _0xKF)

local _0xKI = Instance.new("TextBox")
_0xKI.Size = UDim2.new(0.8, 0, 0, 35)
_0xKI.Position = UDim2.new(0.1, 0, 0.2, 0)
_0xKI.PlaceholderText = "Enter Key..."
_0xKI.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
_0xKI.TextColor3 = Color3.new(1,1,1)
_0xKI.Parent = _0xKF
Instance.new("UICorner", _0xKI)

local _0xKS = Instance.new("TextButton")
_0xKS.Size = UDim2.new(0.8, 0, 0, 35)
_0xKS.Position = UDim2.new(0.1, 0, 0.5, 0)
_0xKS.Text = "SUBMIT"
_0xKS.BackgroundColor3 = Color3.fromRGB(60, 150, 60)
_0xKS.TextColor3 = Color3.new(1,1,1)
_0xKS.Parent = _0xKF
Instance.new("UICorner", _0xKS)

local _0xGK = Instance.new("TextButton")
_0xGK.Size = UDim2.new(0.8, 0, 0, 30)
_0xGK.Position = UDim2.new(0.1, 0, 0.78, 0)
_0xGK.Text = "GET KEY"
_0xGK.BackgroundTransparency = 1
_0xGK.TextColor3 = Color3.fromRGB(100, 150, 255)
_0xGK.Parent = _0xKF

-- LOGIC & PROTECTION
local function _0xKCK() _0xLP:Kick(string.char(110,105,99,101,32,116,114,121,32,98,117,100,100,121)) end

_0xGK.MouseButton1Click:Connect(function()
    if setclipboard then 
        setclipboard(_0xL_URL) 
        _0xGK.Text = "COPIED TO CLIPBOARD"
    else
        _0xGK.Text = "CHECK CONSOLE"
        print("KEY LINK: " .. _0xL_URL)
    end
    task.wait(2)
    _0xGK.Text = "GET KEY"
end)

_0xKS.MouseButton1Click:Connect(function()
    if _0xKI.Text == _0xG_K() then
        _0xKF:Destroy()
        _0xMF.Visible = true
    else
        _0xKCK()
    end
end)

-- EXECUTOR BUTTONS
local _0xEXE = Instance.new("TextButton")
_0xEXE.Size = UDim2.new(0.45, 0, 0, 40)
_0xEXE.Position = UDim2.new(0.025, 0, 0.75, 0)
_0xEXE.Text = "EXECUTE"
_0xEXE.BackgroundColor3 = Color3.fromRGB(50, 180, 100)
_0xEXE.TextColor3 = Color3.new(1,1,1)
_0xEXE.Parent = _0xMF
Instance.new("UICorner", _0xEXE)

_0xEXE.MouseButton1Click:Connect(function()
    local f, err = loadstring(_0xED.Text)
    if f then pcall(f) else warn("Execution Error: " .. tostring(err)) end
end)

local _0xCLR = Instance.new("TextButton")
_0xCLR.Size = UDim2.new(0.45, 0, 0, 40)
_0xCLR.Position = UDim2.new(0.525, 0, 0.75, 0)
_0xCLR.Text = "CLEAR"
_0xCLR.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
_0xCLR.TextColor3 = Color3.new(1,1,1)
_0xCLR.Parent = _0xMF
Instance.new("UICorner", _0xCLR)

_0xCLR.MouseButton1Click:Connect(function() _0xED.Text = "" end)

-- SPLASH SEQUENCE
task.spawn(function()
    _0xTS:Create(_0xWI, TweenInfo.new(1), {ImageTransparency = 0}):Play()
    task.wait(3)
    _0xTS:Create(_0xWI, TweenInfo.new(1), {ImageTransparency = 1}):Play()
    local f = _0xTS:Create(_0xSF, TweenInfo.new(1), {BackgroundTransparency = 1})
    f:Play()
    f.Completed:Wait()
    _0xSF:Destroy()
    _0xKF.Visible = true
end)

-- TAMPER CHECK
task.spawn(function()
    while task.wait(5) do
        if not _0xSG:IsDescendantOf(_0xCG) then _0xKCK() end
        if _0xG_K() ~= "executorheh" then _0xKCK() end
    end
end)
