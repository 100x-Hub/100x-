-- [[ 🔱 100x HUB - ULTIMATE STORAGE REPAIR V3.4 ]] --
-- [[ REASON: FIX PERSISTENT HOLDING & ENSURE REMOTE SYNC ]] --

if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character

local LP = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local Http = game:GetService("HttpService")
local TP = game:GetService("TeleportService")
local RawLink = ""

-- [ 🛡️ REINFORCE SYSTEM ] --
local function Reinforce()
    local source = 'loadstring(game:HttpGet("'..RawLink..'"))()'
    local qot = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
    if qot then pcall(function() qot(source) end) end
end

-- [ 📦 RECURSIVE STORAGE SYSTEM ] --
local function GlobalStore(fruitName, fruitObj)
    -- Try multiple ways to invoke the store command
    local success = false
    local remotes = {
        "StoreFruit",
        "StoreFruitMethod", -- Backup name
        "StoreFruitInInventory" -- Backup name
    }
    
    for _, remoteName in pairs(remotes) do
        pcall(function()
            local res = RS.Remotes.CommF_:InvokeServer(remoteName, fruitName, fruitObj)
            if res == true or res == 1 then success = true end
        end)
        if success then break end
    end
    return success
end

local function SmartCollect()
    print("🔱 100x HUB: Scanning for fruits...")
    pcall(function() 
        if not LP.Team or LP.Team.Name == "Choosing" then 
            RS.Remotes.CommF_:InvokeServer("SetTeam", "Pirates") 
        end 
    end)
    task.wait(1.5)
    
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 500, 0)
        
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Tool") and string.find(v.Name, "Fruit") then
                print("🔱 100x HUB: Target Found -> " .. v.Name)
                LP.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
                task.wait(1)
                
                -- Force Equip
                local hum = LP.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:EquipTool(v) end
                task.wait(1.5) -- Wait for character to fully hold the fruit
                
                -- Recursive Storage Attempt
                print("🔱 100x HUB: Attempting to store...")
                local stored = GlobalStore(v.Name, v)
                
                task.wait(2)
                -- Final Check: Is it still in hand?
                if LP.Character:FindFirstChild(v.Name) or LP.Backpack:FindFirstChild(v.Name) then
                    warn("🔱 100x HUB: Storage Failed. Dropping fruit to continue.")
                    v.Parent = workspace -- Drop it if can't store (likely storage full)
                else
                    print("🔱 100x HUB: SUCCESS! Item Stored.")
                end
                break
            end
        end
    end
end

-- [ 🚀 STABLE SERVER HOP ] --
local function ServerHop()
    print("🔱 100x HUB: Hopping to next server...")
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

-- [ ⚡ EXECUTE ] --
task.spawn(function()
    SmartCollect()
    task.wait(1)
    ServerHop()
end)

game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    task.wait(1)
    TP:Teleport(game.PlaceId)
end)
