local P, R, L, T = game:GetService("Players"), game:GetService("RunService"), game:GetService("Lighting"), game:GetService("TweenService")
local lp = P.LocalPlayer local pg = lp:WaitForChild("PlayerGui")
local m_steps, m_targ, dist = 15, 4, 160
local steps, targs = {}, {}

-- 1. Automatic Wipe of Previous HUD Assets
if pg:FindFirstChild("MD_TrueVisorHUD") then pg.MD_TrueVisorHUD:Destroy() end
local gui = Instance.new("ScreenGui", pg) gui.Name = "MD_TrueVisorHUD" gui.IgnoreGuiInset = true

-- 2. HARDWARE REBOOT BOOT-SEQUENCE OVERLAY
local bootFrame = Instance.new("Frame", gui) bootFrame.Size = UDim2.fromScale(1, 1) bootFrame.BackgroundColor3 = Color3.fromRGB(0,0,0) bootFrame.ZIndex = 100
local bootText = Instance.new("TextLabel", bootFrame) bootText.Size = UDim2.fromScale(0.8, 0.8) bootText.Position = UDim2.fromScale(0.1, 0.1) bootText.BackgroundTransparency = 1 bootText.TextColor3 = Color3.fromRGB(255, 210, 0) bootText.TextSize = 14 bootText.Font = Enum.Font.Code bootText.TextXAlignment = Enum.TextXAlignment.Left bootText.TextYAlignment = Enum.TextYAlignment.Top
bootText.Text = "JCJENSON_OS(C)2026 V4.02\nLOADING HARDWARE CORE...\nCRITICAL ERROR LOG ENCOUNTERED\nRUNNING CORRECTION INTERFACE...\n\n[SUCCESS] VISOR HUD INJECTED ONLINE."
task.delay(1.2, function()
	T:Create(bootFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
	T:Create(bootText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
	task.delay(0.4, function()
		bootFrame:Destroy()
	end)
end)

-- 3. Lens Framing Plates
local topPlate, bottomPlate, topPlateLine, bottomPlateLine
local function createVisorPlate(name, anchor, size, position, gradRotation)
	local Plate = Instance.new("Frame", gui)
	Plate.Name = name
	Plate.Size = size
	Plate.Position = position
	Plate.AnchorPoint = anchor
	Plate.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Plate.BorderSizePixel = 0
	Plate.ZIndex = 5

	local MainLine = Instance.new("Frame", Plate)
	MainLine.Size = UDim2.new(1, 0, 0, 4)
	MainLine.BorderSizePixel = 0
	MainLine.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
	MainLine.Position = (anchor.Y == 0) and UDim2.new(0, 0, 1, -4) or UDim2.new(0, 0, 0, 0)

	local Fade = Instance.new("Frame", Plate)
	Fade.Size = UDim2.new(1, 0, 2, 0)
	Fade.Position = (anchor.Y == 0) and UDim2.new(0, 0, 1, 0) or UDim2.new(0, 0, -2, 0)
	Fade.BackgroundTransparency = 0
	Fade.BackgroundColor3 = Color3.fromRGB(20, 15, 0)
	Fade.BorderSizePixel = 0

	local UIMod = Instance.new("UIGradient", Fade)
	UIMod.Rotation = gradRotation
	UIMod.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.4),
		NumberSequenceKeypoint.new(1, 1)
	})

	return Plate, MainLine
end

topPlate, topPlateLine = createVisorPlate("TopPlate", Vector2.new(0.5, 0), UDim2.new(1.2, 0, 0, 65), UDim2.new(0.5, 0, 0, 0), 90)
bottomPlate, bottomPlateLine = createVisorPlate("BottomPlate", Vector2.new(0.5, 1), UDim2.new(1.2, 0, 0, 65), UDim2.new(0.5, 0, 1, 0), 270)

local topText = Instance.new("TextLabel", gui)
topText.Size = UDim2.new(1, 0, 0, 30)
topText.Position = UDim2.new(0, 0, 0, 35)
topText.BackgroundTransparency = 1
topText.TextColor3 = Color3.fromRGB(255, 220, 0)
topText.TextSize = 13
topText.Font = Enum.Font.Code
topText.Text = "▼ SENSORS: ONLINE  ||  [ DYNAMIC_RAYCAST_FILTERS: ACTIVE ]  ||  MODE: HUNT_SERIAL_V"

-- Center Reticle Matrix
local centerReticle = Instance.new("Frame", gui)
centerReticle.Size = UDim2.fromOffset(45, 45)
centerReticle.Position = UDim2.fromScale(0.5, 0.5)
centerReticle.AnchorPoint = Vector2.new(0.5, 0.5)
centerReticle.BackgroundTransparency = 1

local chX = Instance.new("Frame", centerReticle)
chX.Size = UDim2.new(1, 0, 0, 1)
chX.Position = UDim2.fromScale(0, 0.5)
chX.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
chX.BorderSizePixel = 0

local chY = Instance.new("Frame", centerReticle)
chY.Size = UDim2.new(0, 1, 1, 0)
chY.Position = UDim2.fromScale(0.5, 0)
chY.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
chY.BorderSizePixel = 0

-- Solver Visual Overlay Panel
local solverOverlay = Instance.new("Frame", gui)
solverOverlay.Size = UDim2.fromScale(1, 1)
solverOverlay.BackgroundTransparency = 1
solverOverlay.BackgroundColor3 = Color3.fromRGB(45, 0, 0)
solverOverlay.ZIndex = 2

local solverGlyph = Instance.new("TextLabel", solverOverlay)
solverGlyph.Size = UDim2.fromOffset(400, 200)
solverGlyph.Position = UDim2.fromScale(0.5, 0.5)
solverGlyph.AnchorPoint = Vector2.new(0.5, 0.5)
solverGlyph.BackgroundTransparency = 1
solverGlyph.TextColor3 = Color3.fromRGB(255, 25, 25)
solverGlyph.TextSize = 40
solverGlyph.Font = Enum.Font.Code
solverGlyph.Text = "⚠️ [NULL] ⚠️\nABSOLUTE SOLVER\nOVERRIDE DETECTED"
solverGlyph.Visible = false

-- Diagnostics Side Text Panels
local sideLog = Instance.new("TextLabel", gui)
sideLog.Size = UDim2.fromOffset(250, 100)
sideLog.Position = UDim2.new(0, 30, 0, 100)
sideLog.BackgroundTransparency = 1
sideLog.TextColor3 = Color3.fromRGB(255, 200, 0)
sideLog.TextSize = 11
sideLog.Font = Enum.Font.Code
sideLog.TextXAlignment = Enum.TextXAlignment.Left
sideLog.TextYAlignment = Enum.TextYAlignment.Top

local audioContainer = Instance.new("Frame", gui)
audioContainer.Size = UDim2.fromOffset(120, 30)
audioContainer.Position = UDim2.new(0, 30, 1, -110)
audioContainer.BackgroundTransparency = 1

local audioTitle = Instance.new("TextLabel", audioContainer)
audioTitle.Size = UDim2.fromOffset(120, 12)
audioTitle.Position = UDim2.fromOffset(0, -14)
audioTitle.BackgroundTransparency = 1
audioTitle.TextColor3 = Color3.fromRGB(255,190,0)
audioTitle.TextSize = 10
audioTitle.Font = Enum.Font.Code
audioTitle.TextXAlignment = Enum.TextXAlignment.Left
audioTitle.Text = "DRONEAMP.EXE Wave"

local waveBars = {}
for i = 1, 10 do
	local bar = Instance.new("Frame", audioContainer)
	bar.Size = UDim2.new(0, 8, 0, 5)
	bar.Position = UDim2.new(0, (i-1)*11, 1, -5)
	bar.AnchorPoint = Vector2.new(0, 1)
	bar.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
	bar.BorderSizePixel = 0
	table.insert(waveBars, bar)
end

-- Target Brackets Framework
local function makeB(p)
	local TargetBox = Instance.new("Frame", gui)
	TargetBox.Size = UDim2.fromOffset(100, 100)
	TargetBox.BackgroundTransparency = 1
	TargetBox.AnchorPoint = Vector2.new(0.5, 0.5)

	local function addCorner(w, h, pX, pY)
		local c = Instance.new("Frame", TargetBox)
		c.Name = "CLine"
		c.BackgroundColor3 = Color3.fromRGB(255, 210, 0)
		c.BorderSizePixel = 0
		c.Size = w
		c.Position = pX

		local c2 = Instance.new("Frame", TargetBox)
		c2.Name = "CLine"
		c2.BackgroundColor3 = Color3.fromRGB(255, 210, 0)
		c2.BorderSizePixel = 0
		c2.Size = h
		c2.Position = pY
	end

	addCorner(UDim2.fromOffset(16, 2), UDim2.fromOffset(2, 16), UDim2.fromScale(0,0), UDim2.fromScale(0,0))
	addCorner(UDim2.fromOffset(16, 2), UDim2.fromOffset(2, 16), UDim2.new(1, -16, 0, 0), UDim2.new(1, -2, 0, 0))
	addCorner(UDim2.fromOffset(16, 2), UDim2.fromOffset(2, 16), UDim2.new(0, 0, 1, -2), UDim2.new(0, 0, 1, -16))
	addCorner(UDim2.fromOffset(16, 2), UDim2.fromOffset(2, 16), UDim2.new(1, -16, 1, -2), UDim2.new(1, -2, 1, -16))

	local nameL = Instance.new("TextLabel", TargetBox)
	nameL.Name = "TargetName"
	nameL.Size = UDim2.new(1, 0, 0, 14)
	nameL.Position = UDim2.new(0, 0, 1, 5)
	nameL.BackgroundTransparency = 1
	nameL.TextColor3 = Color3.fromRGB(255, 210, 0)
	nameL.TextSize = 11
	nameL.Font = Enum.Font.Code
	nameL.Text = "ID // " .. string.upper(p.Name)

	local distL = Instance.new("TextLabel", TargetBox)
	distL.Name = "DistanceMetric"
	distL.Size = UDim2.new(1, 0, 0, 12)
	distL.Position = UDim2.new(0, 0, 1, 18)
	distL.BackgroundTransparency = 1
	distL.TextColor3 = Color3.fromRGB(255, 170, 0)
	distL.TextSize = 10
	distL.Font = Enum.Font.Code
	distL.Text = "DIST -- M"

	return TargetBox
end

local function checkLineOfSight(camera, targetChar, targetRoot)
	local origin = camera.CFrame.Position
	local direction = (targetRoot.Position - origin)

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude

	local ignoreList = {lp.Character, targetChar}

	for _, item in ipairs(workspace:GetDescendants()) do
		if item:IsA("BasePart") and (item.CanCollide == false or item.Transparency >= 0.9) then
			table.insert(ignoreList, item)
		elseif item:IsA("Tool") or item:IsA("Accessory") then
			table.insert(ignoreList, item)
		end
	end

	params.FilterDescendantsInstances = ignoreList
	return workspace:Raycast(origin, direction, params) == nil
end

local function dropStep(pos)
	local p = Instance.new("Part", workspace)
	p.Size = Vector3.new(2, 0.2, 2)
	p.Position = pos
	p.Anchored = true
	p.CanCollide = false
	p.Transparency = 1

	table.insert(steps, p)
	while #steps > m_steps do
		local old = table.remove(steps, 1)
		if old then old:Destroy() end
	end

	local b = Instance.new("BillboardGui", p)
	b.Size = UDim2.fromOffset(150, 45)
	b.AlwaysOnTop = true

	local line = Instance.new("Frame", b)
	line.Size = UDim2.new(1, 0, 0, 1)
	line.Position = UDim2.fromScale(0, 0.5)
	line.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
	line.BorderSizePixel = 0

	local t = Instance.new("TextLabel", b)
	t.Size = UDim2.fromScale(1, 1)
	t.BackgroundTransparency = 1
	t.TextColor3 = Color3.fromRGB(255, 65, 65)
	t.TextSize = 10
	t.Font = Enum.Font.Code
	t.Text = "⚠️ TARGET MISSING\nLOC: " .. string.format("%.1f, %.1f", pos.X, pos.Z)

	task.delay(5, function()
		if p.Parent then
			local idx = table.find(steps, p)
			if idx then table.remove(steps, idx) end
			p:Destroy()
		end
	end)
end

-- 8. Main Render & Ultra-Violent Solver Mutation Loop
local errorStrings = {"MAT_ABSORPTION: ERROR", "SYS_CORE: WARNING", "CORES: OVERCLOCK", "JCJ_BOOT_SECTOR: RECURSIVE"}

local connection
connection = R.RenderStepped:Connect(function()
	if not gui.Parent or not lp.Character then connection:Disconnect() return end

	local cam = workspace.CurrentCamera
	local root = lp.Character:FindFirstChild("HumanoidRootPart")
	local hum = lp.Character:FindFirstChildOfClass("Humanoid")
	if not cam or not root or not hum then return end

	local baseColor = Color3.fromRGB(255, 200, 0)
	local accentColor = Color3.fromRGB(255, 170, 0)

	local isSolverActive = hum.Health <= (hum.MaxHealth * 0.35) and hum.Health > 0

	if isSolverActive then
		baseColor = Color3.fromRGB(255, 25, 25)
		accentColor = Color3.fromRGB(180, 0, 0)

		solverGlyph.Visible = true
		solverOverlay.BackgroundTransparency = 0.70 + (math.sin(tick() * 25) * 0.12)

		topText.Text = "⚠️ CRITICAL FATAL OVERRIDE: HOST MOTOR RE-ROUTING VIA [NULL]"
		sideLog.Text = "▶ SEIZURE_LOCK: TRUE\n▶ MOTOR_DRIVE: CORRUPT\n▶ AXIS_ERR: VELOCITY_SPIKE\n▶ CODE: [SYSTEM_HIJACK]"

		hum:Move(Vector3.new(math.sin(tick() * 40) * 1.5, 0, math.cos(tick() * 40) * 1.5), false)

		if math.random(1, 2) == 1 then
			local snapX = math.random(-30, 30) / 10
			local snapZ = math.random(-30, 30) / 10
			local snapRot = math.rad(math.random(-45, 45))
			root.CFrame = root.CFrame * CFrame.new(snapX, 0, snapZ) * CFrame.Angles(0, snapRot, 0)
		end

		for _, m in ipairs(lp.Character:GetDescendants()) do
			if m:IsA("Motor6D") then
				m.Transform = CFrame.new() * CFrame.Angles(
					math.rad(math.random(-50, 50)),
					math.rad(math.random(-50, 50)),
					math.rad(math.random(-50, 50))
				)
			end
		end
	else
		solverGlyph.Visible = false
		solverOverlay.BackgroundTransparency = 1

		topText.Text = "▼ SENSORS: ONLINE  ||  [ DYNAMIC_RAYCAST_FILTERS: ACTIVE ]  ||  MODE: HUNT_SERIAL_V"
		sideLog.Text =
			"▶ TEMP: " .. string.format("%.1f", 36 + math.sin(tick())*0.4) ..
			"°C\n▶ MEMORY_POOL: OPTIMAL\n▶ LOG: " ..
			errorStrings[math.floor(tick() % #errorStrings) + 1] ..
			"\n▶ SYSTEM_CLOCK: " .. string.format("%.3f", tick() % 100)

		for _, m in ipairs(lp.Character:GetDescendants()) do
			if m:IsA("Motor6D") then
				m.Transform = CFrame.new()
			end
		end
	end

	topText.TextColor3 = baseColor
	chX.BackgroundColor3 = baseColor
	chY.BackgroundColor3 = baseColor
	audioTitle.TextColor3 = baseColor

	topPlateLine.BackgroundColor3 = baseColor
	bottomPlateLine.BackgroundColor3 = baseColor

	for _, bar in ipairs(waveBars) do
		bar.BackgroundColor3 = baseColor
		bar.Size = UDim2.new(0, 8, 0, math.random(3, 25))
	end

	local active_count = 0
	for _, o in ipairs(P:GetPlayers()) do
		if o ~= lp and o.Character then
			local oroot = o.Character:FindFirstChild("HumanoidRootPart")
			local ohum = o.Character:FindFirstChildOfClass("Humanoid")

			if oroot and ohum and ohum.Health > 0 and (root.Position - oroot.Position).Magnitude <= dist then
				local spos, onS = cam:WorldToScreenPoint(oroot.Position)

				if onS then
					if checkLineOfSight(cam, o.Character, oroot) then
						active_count += 1

						if not targs[o] then targs[o] = makeB(o) end

						local bFrame = targs[o]
						bFrame.Visible = true
						bFrame.Position = UDim2.fromOffset(spos.X, spos.Y)

						local calculatedDist = (root.Position - oroot.Position).Magnitude
						local dLabel = bFrame:FindFirstChild("DistanceMetric")
						local nLabel = bFrame:FindFirstChild("TargetName")

						if dLabel then dLabel.Text = "DIST // " .. string.format("%.1f", calculatedDist) .. " STUDS" end
						if nLabel then nLabel.TextColor3 = baseColor end

						for _, cl in ipairs(bFrame:GetChildren()) do
							if cl.Name == "CLine" then cl.BackgroundColor3 = baseColor end
						end
					else
						if targs[o] then targs[o].Visible = false end
						if ohum.MoveDirection.Magnitude > 0 and math.random(1, 18) == 1 then
							dropStep(oroot.Position - Vector3.new(0, 3, 0))
						end
					end
				end
			else
				if targs[o] then targs[o].Visible = false end
			end
		end
	end

	for pl, br in pairs(targs) do
		if not pl.Parent or not pl.Character then
			br:Destroy()
			targs[pl] = nil
		end
	end
end)
