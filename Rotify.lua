local p = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local gui = Instance.new("ScreenGui", p.PlayerGui) gui.Name = "RotifyMobile"

local f = Instance.new("Frame", gui)
f.Size = UDim2.new(0, 280, 0, 400)
f.Position = UDim2.new(0.5, -140, 0.5, -200)
f.BackgroundColor3 = Color3.new(1,1,1)
f.ClipsDescendants = true
Instance.new("UICorner", f)

local g = Instance.new("UIGradient", f)
g.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 255))}
g.Rotation = 45

-- Dedicated Mobile Drag Handle
local dragHandle = Instance.new("TextLabel", f)
dragHandle.Size = UDim2.new(1, 0, 0, 30)
dragHandle.BackgroundColor3 = Color3.new(0,0,0)
dragHandle.BackgroundTransparency = 0.8
dragHandle.Text = "≡ TAP & DRAG TO MOVE ≡"
dragHandle.TextColor3 = Color3.new(1,1,1)
dragHandle.Font = Enum.Font.GothamBold
dragHandle.TextSize = 10

local dragStart, startPos
dragHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragStart = input.Position
		startPos = f.Position
	end
end)
UIS.InputChanged:Connect(function(input)
	if dragStart and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
		local delta = input.Position - dragStart
		f.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragStart = nil
	end
end)

local t = Instance.new("TextLabel", f)
t.Text = "ROTIFY" t.Size = UDim2.new(1, 0, 0, 40)
t.Position = UDim2.new(0,0,0,30)
t.TextColor3 = Color3.new(1,1,1) t.BackgroundTransparency = 1
t.Font = Enum.Font.GothamBold t.TextSize = 20

-- Mobile Optimized Slider
local vFrame = Instance.new("Frame", f)
vFrame.Size = UDim2.new(0.5, 0, 0, 12)
vFrame.Position = UDim2.new(0.05, 0, 0, 75)
vFrame.BackgroundColor3 = Color3.new(1,1,1)
vFrame.BackgroundTransparency = 0.6
Instance.new("UICorner", vFrame)

local slider = Instance.new("Frame", vFrame)
slider.Size = UDim2.new(0, 16, 1, 6)
slider.Position = UDim2.new(0.5, -8, 0, -3)
slider.BackgroundColor3 = Color3.new(1,1,1)
Instance.new("UICorner", slider).CornerRadius = UDim.new(1,0)

local conf = Instance.new("TextButton", f)
conf.Size = UDim2.new(0, 90, 0, 30)
conf.Position = UDim2.new(0.6, 0, 0, 65)
conf.BackgroundColor3 = Color3.fromRGB(30, 215, 96)
conf.Text = "Confirm Vol"
conf.TextColor3 = Color3.new(1,1,1)
conf.Font = Enum.Font.GothamBold
Instance.new("UICorner", conf)

local snd = Instance.new("Sound", f) snd.Volume = 0.5
local tempVol = 0.5
local sDrag = false

vFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then sDrag = true end
end)
UIS.InputChanged:Connect(function(input)
	if sDrag and input.UserInputType == Enum.UserInputType.Touch then
		local relX = math.clamp((input.Position.X - vFrame.AbsolutePosition.X) / vFrame.AbsoluteSize.X, 0, 1)
		slider.Position = UDim2.new(relX, -8, 0, -3)
		tempVol = relX
	end
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then sDrag = false end
end)

conf.MouseButton1Click:Connect(function()
	snd.Volume = tempVol
	conf.Text = math.floor(tempVol * 100).."%"
	task.wait(1)
	conf.Text = "Confirm Vol"
end)

local sc = Instance.new("ScrollingFrame", f)
sc.Size = UDim2.new(1, -20, 1, -130)
sc.Position = UDim2.new(0, 10, 0, 115)
sc.BackgroundTransparency = 1
sc.CanvasSize = UDim2.new(0, 0, 0, 650)
sc.ScrollBarThickness = 5

local songs = {
	{"Raining Tacos", 142376088}, {"Mii Channel", 143666548},
	{"Morning Mood", 1846088038}, {"Life In Elevator", 1841647093},
	{"Island Beach", 1839638511}, {"Clair De Lune", 1846051682},
	{"Happy Song", 1843404009}, {"Uptown", 1845554017},
	{"Lofi Chill", 9043887091}, {"Into The Forest", 1845497774}
}

for i, song in ipairs(songs) do
	local b = Instance.new("TextButton", sc)
	b.Text = song[1]
	b.Size = UDim2.new(1, -10, 0, 45) -- Larger tap area for mobile
	b.Position = UDim2.new(0, 5, 0, (i-1)*50)
	b.BackgroundColor3 = Color3.new(0,0,0)
	b.BackgroundTransparency = 0.7
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.Gotham
	Instance.new("UICorner", b)
	b.MouseButton1Click:Connect(function()
		snd.SoundId = "rbxassetid://" .. song[2]
		snd:Play()
		t.Text = "Playing: " .. song[1]
	end)
end
                       
