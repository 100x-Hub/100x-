-- [[ 🔱 100x HUB - THE UNSTOPPABLE V2.8 (PERMANENT) ]] --
-- [[ แก้ไขปัญหาย้ายเซิร์ฟแล้วไม่รันต่อ 100% ]] --

if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character

local LP = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local Http = game:GetService("HttpService")
local TP = game:GetService("TeleportService")
local JobFile = "100x_Loop_Data.json"

-- [ 🔗 ลิงก์ถาวรของคุณ (ห้ามใส่ Token เด็ดขาด) ] --
local RawLink = "https://raw.githubusercontent.com/100x-Hub/100x/main/main.lua"

local function Reinforce()
    local source = 'loadstring(game:HttpGet("'..RawLink..'"))()'
    -- ตรวจสอบว่าตัวรันรองรับการรันข้ามเซิร์ฟไหม
    local qot = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
    if qot then 
        pcall(function() qot(source) end) 
    end
end

-- [ 📦 ระบบเก็บผลไม้ ] --
local function Snatch()
    pcall(function() 
        if not LP.Team or LP.Team.Name == "Choosing" then 
            RS.Remotes.CommF_:InvokeServer("SetTeam", "Pirates") 
        end 
    end)
    task.wait(2)
    
    local isStored = false
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1000, 0)
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Tool") and string.find(v.Name, "Fruit") then
                LP.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
                task.wait(0.7)
                local success = RS.Remotes.CommF_:InvokeServer("StoreFruit", v.Name, v)
                if success or not v:IsDescendantOf(workspace) then
                    task.wait(2.5) -- รอเซฟข้อมูล
                    isStored = true
                end
                break
            end
        end
    end
    return isStored
end

-- [ 🚀 ระบบย้ายเซิร์ฟเวอร์ ] --
local function QuantumHop()
    Reinforce() -- สั่งให้โหลดตัวเองใหม่ในเซิร์ฟหน้า
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local history = {}
    if isfile(JobFile) then pcall(function() history = Http:JSONDecode(readfile(JobFile)) end) end
    if #history > 40 then history = {} end

    local success, res = pcall(function() return game:HttpGet(url) end)
    if success then
        local data = Http:JSONDecode(res)
        for _, server in pairs(data.data) do
            if server.playing >= 1 and server.playing <= 8 and server.id ~= game.JobId then
                local visited = false
                for _, id in pairs(history) do if id == server.id then visited = true break end end
                if not visited then
                    table.insert(history, server.id)
                    writefile(JobFile, Http:JSONEncode(history))
                    pcall(function() TP:TeleportToPlaceInstance(game.PlaceId, server.id, LP) end)
                    return
                end
            end
        end
    end
    TP:Teleport(game.PlaceId)
end

-- [ ⚡ เริ่มทำงาน ] --
task.spawn(function()
    Snatch()
    task.wait(1.5)
    QuantumHop()
end)

-- แก้ปัญหาหน้าจอ Error (เช่น เซิร์ฟเต็ม)
game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    task.wait(1)
    TP:Teleport(game.PlaceId)
end)
