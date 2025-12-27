-- [[ 🔱 100x HUB - ULTIMATE STORAGE FIX ]] --
-- [[ REASON: ENSURE FRUIT IS STORED BEFORE SERVER HOP ]] --

if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character

local LP = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local Http = game:GetService("HttpService")
local TP = game:GetService("TeleportService")
local JobFile = "100x_Loop_Data.json"
local RawLink = "https://raw.githubusercontent.com/100x-Hub/100x-/refs/heads/main/main.lua"

-- [ 🛡️ REINFORCE SYSTEM ] --
local function Reinforce()
    local source = 'loadstring(game:HttpGet("'..RawLink..'"))()'
    local qot = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
    if qot then pcall(function() qot(source) end) end
end

-- [ 📦 SECURE STORAGE SYSTEM ] --
local function CollectAndStore()
    print("🔱 100x HUB: Scanning for fruits...")
    pcall(function() 
        if not LP.Team or LP.Team.Name == "Choosing" then 
            RS.Remotes.CommF_:InvokeServer("SetTeam", "Pirates") 
        end 
    end)
    task.wait(2)
    
    local storedSuccessfully = false
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        -- Hide in the sky while scanning
        LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 800, 0)
        
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Tool") and string.find(v.Name, "Fruit") then
                print("🔱 100x HUB: Target identified -> " .. v.Name)
                
                -- Move to fruit and pick it up
                LP.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
                task.wait(1.5) -- Extra time to ensure character is holding the fruit
                
                -- Attempt to Store
                print("🔱 100x HUB: Attempting to store " .. v.Name)
                local storeAttempt = RS.Remotes.CommF_:InvokeServer("StoreFruit", v.Name, v)
                
                -- Verification Logic
                if storeAttempt or not v:IsDescendantOf(workspace) then
                    print("🔱 100x HUB: SUCCESS! Stored in inventory.")
                    storedSuccessfully = true
                    task.wait(5) -- CRITICAL: Wait 5 seconds for Game Server to Save Data
                else
                    warn("🔱 100x HUB: Failed to store. Storage might be full.")
                end
                break
            end
        end
    end
    return storedSuccessfully
end

-- [ 🚀 STABLE SERVER HOP ] --
local function ServerHop()
    print("🔱 100x HUB: Preparing to hop...")
    Reinforce()
    
    local history = {}
    if isfile(JobFile) then 
        pcall(function() history = Http:JSONDecode(readfile(JobFile)) end) 
    end
    if #history > 50 then history = {} end

    local success, res = pcall(function() 
        return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100") 
    end)
    
    if success and res then
        local data = Http:JSONDecode(res)
        for _, server in pairs(data.data) do
            if server.playing >= 1 and server.playing <= 8 and server.id ~= game.JobId then
                local visited = false
                for _, id in pairs(history) do if id == server.id then visited = true break end end
                
                if not visited then
                    table.insert(history, server.id)
                    writefile(JobFile, Http:JSONEncode(history))
                    pcall(function() TP:TeleportToPlaceInstance(game.PlaceId, server.id, LP) end)
                    task.wait(10) -- Wait for teleport
                end
            end
        end
    end
    TP:Teleport(game.PlaceId)
end

-- [ ⚡ EXECUTE ] --
task.spawn(function()
    local check = CollectAndStore()
    task.wait(1)
    ServerHop()
end)

-- Error Handler (Auto-Hop on Error)
game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    task.wait(1)
    TP:Teleport(game.PlaceId)
end)
