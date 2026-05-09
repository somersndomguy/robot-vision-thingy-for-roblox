-- Execute in Dev Console -> Server Tab
local LP = game:GetService("Players").LocalPlayer
local Char = LP.Character
local Root = Char:WaitForChild("HumanoidRootPart")
local RunService = game:GetService("RunService")

-- The "Pixel Perfect" Sequencer
local LEAN = math.rad(65)      -- Intense forward dive
local SNAP_STRENGTH = 2.4      -- How far the legs kick out
local JITTER_FPS = 18         -- Forces the "laggy" animation look
local lastStep = 0

local function GetM(p, n)
    local l = Char:FindFirstChild(p)
    return l and l:FindFirstChild(n)
end

local motors = {
    Root = GetM("LowerTorso", "Root"),
    Waist = GetM("UpperTorso", "Waist"),
    LHip = GetM("LeftUpperLeg", "LeftHip"),
    RHip = GetM("RightUpperLeg", "RightHip"),
    LKnee = GetM("LeftLowerLeg", "LeftKnee"),
    RKnee = GetM("RightLowerLeg", "RightKnee"),
    LShoulder = GetM("LeftUpperArm", "LeftShoulder"),
    RShoulder = GetM("RightUpperArm", "RightShoulder")
}

local _c0 = {}
for k, v in pairs(motors) do _c0[k] = v.C0 end

local conn
conn = RunService.Heartbeat:Connect(function()
    if not Char.Parent then conn:Disconnect() return end
    
    -- Jitter-lock: Only update at a specific "low" framerate to match the meme
    if tick() - lastStep < (1/JITTER_FPS) then return end
    lastStep = tick()

    local vel = Root.Velocity.Magnitude
    if vel > 1 then
        local t = tick() * 32
        local step = math.sin(t)
        local altStep = math.cos(t)

        -- Root Lean (The "Faceplant" angle)
        motors.Root.C0 = _c0.Root * CFrame.Angles(LEAN, math.rad(math.random(-5,5)), 0)
        
        -- The "Broken" Arms (Flailing behind)
        motors.LShoulder.C0 = _c0.LShoulder * CFrame.Angles(math.rad(-110) + (step*0.5), 0, math.rad(-30))
        motors.RShoulder.C0 = _c0.RShoulder * CFrame.Angles(math.rad(-110) + (altStep*0.5), 0, math.rad(30))

        -- Leg snapping (Pixel-perfect stumbling)
        -- Left Leg
        motors.LHip.C0 = _c0.LHip * CFrame.Angles(step * SNAP_STRENGTH, 0, 0) 
            * CFrame.new(0, math.abs(step) * 0.9, -math.abs(step) * 0.5)
        motors.LKnee.C0 = _c0.LKnee * CFrame.Angles(math.abs(step) * -2.2, 0, 0)

        -- Right Leg
        motors.RHip.C0 = _c0.RHip * CFrame.Angles(-step * SNAP_STRENGTH, 0, 0) 
            * CFrame.new(0, math.abs(altStep) * 0.9, -math.abs(altStep) * 0.5)
        motors.RKnee.C0 = _c0.RKnee * CFrame.Angles(math.abs(altStep) * -2.2, 0, 0)

        -- Head Jitter
        local neck = GetM("Head", "Neck")
        if neck then
            neck.C0 = neck.C0 * CFrame.Angles(0, math.rad(math.random(-20, 20)), 0)
        end
    else
        -- Clean reset
        for k, v in pairs(motors) do v.C0 = _c0[k] end
    end
end)
