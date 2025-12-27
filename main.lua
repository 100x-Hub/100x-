-- [[ 🔱 100x HUB - FINAL STORAGE FIX ]] --
-- [[ REASON: ENSURE FRUIT IS EQUIPPED BEFORE STORING ]] --

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

-- [ 📦 ADVANCED STORAGE SYSTEM ] --
local function SecureCollect()
    print("🔱 100x HUB: Scanning for fruits...")
    pcall(function() 
        if not LP.Team or LP.Team.Name == "Choosing" then 
            RS.Remotes.CommF_:InvokeServer("SetTeam", "Pirates") 
        end 
    end)
    task.wait(2)
    
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 500, 0)
        
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Tool") and string.find(v.Name, "Fruit") then
                print("🔱 100x HUB: Target -> " .. v.Name)
                
                -- 1. Teleport and pick up
                LP.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
                task.wait(1)
                
                -- 2. Force Equip (Hold the fruit in hand)
                local humanoid = LP.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:EquipTool(v)
                    print("🔱 100x HUB: Fruit equipped.")
                end
                task.wait(1)
                
                -- 3. Store Command
                print("🔱 100x HUB: Storing...")
                local storeResult = RS.Remotes.CommF_:InvokeServer("StoreFruit", v.Name, v)
                
                -- 4. Double Check
                if not v:IsDescendantOf(workspace) or storeResult then
                    print("🔱 100x HUB: SUCCESS! Stored in Inventory.")
                    task.wait(3) -- Sync delay
                    return true
                else
                    warn("🔱 100x HUB: Failed to store. Your storage might be full for this fruit.")
                end
                break
            end
        end
    end
    return false
end

-- [ 🚀 SERVER HOPPER ] --
local function ServerHop()
    print("🔱 100x HUB: Searching for new server...")
    Reinforce()
    
    local success, res = pcall(function() 
        return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100") 
    end)
    
    if success and res then
        local data = Http:JSONDecode(res)
        for _, server in pairs(data.data) do
            if server.playing >= 1 and server.playing <= 8 and server.id ~= game.JobId then
                pcall(function() TP:TeleportToPlaceInstance(game.PlaceId, server.id, LP) end)
                task.wait(5)
            end
        end
    end
    TP:Teleport(game.PlaceId)
end

-- [ ⚡ RUN ] --
task.spawn(function()
    SecureCollect()
    task.wait(1)
    ServerHop()
end)

-- Error Handler
game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    task.wait(1)
    TP:Teleport(game.PlaceId)
end)
