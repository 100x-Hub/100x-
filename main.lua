-- [[ 🔱 100x HUB - GLOBAL EDITION ]] --
-- [[ REWRITTEN IN ENGLISH | ANTI-ERROR 772 | AUTO-STORAGE ]] --

if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character

local LP = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local Http = game:GetService("HttpService")
local TP = game:GetService("TeleportService")
local JobFile = "100x_Loop_Data.json"

-- [ 🔗 PERMANENT RAW LINK ] --
local RawLink = "https://raw.githubusercontent.com/100x-Hub/100x-/refs/heads/main/main.lua"

local function Reinforce()
    local source = 'loadstring(game:HttpGet("'..RawLink..'"))()'
    local qot = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
    if qot then pcall(function() qot(source) end) end
end

-- [ 📦 FRUIT COLLECTOR ] --
local function CollectFruits()
    print("🔱 100x HUB: Scanning for fruits...")
    pcall(function() 
        if not LP.Team or LP.Team.Name == "Choosing" then 
            RS.Remotes.CommF_:InvokeServer("SetTeam", "Pirates") 
        end 
    end)
    task.wait(2)
    
    local fruitFound = false
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1000, 0)
        
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Tool") and string.find(v.Name, "Fruit") then
                print("🔱 100x HUB: Target Found -> " .. v.Name)
                LP.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
                task.wait(0.8) -- Wait for pickup
                
                -- Store to Inventory
                local stored = RS.Remotes.CommF_:InvokeServer("StoreFruit", v.Name, v)
                if stored or not v:IsDescendantOf(workspace) then
                    print("🔱 100x HUB: Successfully Stored!")
                    task.wait(2.5) -- Safety delay for data saving
                    fruitFound = true
                end
                break
            end
        end
    end
    return fruitFound
end

-- [ 🚀 SERVER HOPPER ] --
local function ServerHop()
    print("🔱 100x HUB: Finding new server...")
    Reinforce()
    
    local history = {}
    if isfile(JobFile) then 
        pcall(function() history = Http:JSONDecode(readfile(JobFile)) end) 
    end
    if #history > 40 then history = {} end

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
                    print("🔱 100x HUB: Joining Server -> " .. server.id)
                    pcall(function() TP:TeleportToPlaceInstance(game.PlaceId, server.id, LP) end)
                    task.wait(5)
                end
            end
        end
    end
    -- Fallback: If no server found, Random Hop
    print("🔱 100x HUB: Target server full or not found. Force Hopping...")
    TP:Teleport(game.PlaceId)
end

-- [ ⚡ MAIN EXECUTION ] --
task.spawn(function()
    CollectFruits()
    task.wait(1.5)
    ServerHop()
end)

-- Anti-Stuck (Error Monitor)
game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    task.wait(1)
    TP:Teleport(game.PlaceId)
end)
