-- [[ 🔱 100x HUB - EMERGENCY STORAGE FIX ]] --
-- [[ REASON: FIX HOLDING FRUIT IN HAND WITHOUT STORING ]] --

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

-- [ 📦 THE "NO-HOLD" STORAGE SYSTEM ] --
local function ForceStore()
    print("🔱 100x HUB: Scanning world...")
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
                print("🔱 100x HUB: Found " .. v.Name)
                
                -- 1. Get the fruit
                LP.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
                task.wait(1.5)
                
                -- 2. Equip and try multiple store methods
                local humanoid = LP.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:EquipTool(v)
                    task.wait(1)
                    
                    print("🔱 100x HUB: Executing Multi-Store Method...")
                    -- Method A: CommF Remote (Standard)
                    RS.Remotes.CommF_:InvokeServer("StoreFruit", v.Name, v)
                    
                    -- Method B: Direct Tool Parent Change (Legacy Store)
                    task.wait(0.5)
                    if v.Parent == LP.Character then
                        RS.Remotes.CommF_:InvokeServer("StoreFruit", v.Name, LP.Character:FindFirstChild(v.Name))
                    end
                end
                
                -- 3. Verification
                task.wait(2)
                if not LP.Character:FindFirstChild(v.Name) and not LP.Backpack:FindFirstChild(v.Name) then
                    print("🔱 100x HUB: SUCCESS! Item moved to storage.")
                    task.wait(3)
                    return true
                else
                    warn("🔱 100x HUB: Item still in hand. Storage might be full!")
                    -- If full, drop it so we can continue hopping
                    if LP.Character:FindFirstChild(v.Name) then
                        v.Parent = workspace
                    end
                end
                break
            end
        end
    end
    return false
end

-- [ 🚀 SERVER HOPPER ] --
local function ServerHop()
    print("🔱 100x HUB: Searching for new session...")
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
    ForceStore()
    task.wait(1)
    ServerHop()
end)

game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    task.wait(1)
    TP:Teleport(game.PlaceId)
end)
