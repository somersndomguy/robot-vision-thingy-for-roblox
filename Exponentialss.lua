-- 1. Identity Verification
local MASTER_ID = 2640277341 -- yesimnotakid5's actual Roblox UserId
local currentPlayer = game:GetService("Players").LocalPlayer

if currentPlayer.UserId ~= MASTER_ID then
    -- POISON TRIGGER: Bricks the executor and crashes the intruder's client
    task.spawn(function()
        print("Unauthorized user detected. Initializing self-destruct...")
        local function crash()
            return crash()
        end
        
        while task.wait() do
            local e = Instance.new("Hint", workspace)
            e.Text = "FATAL ERROR: UNAUTHORIZED ACCESS ATTEMPT LOGGED."
            crash() 
        end
    end)
    return 
end

-- 2. Secure Whitelist Retrieval
local function getAuthorizedUsers()
    -- yesimnotakid5 is the primary authorized user
    local authorized = {2640277341}
    return authorized
end

notify("WELCOME, MASTER. SYSTEM ONLINE.")
