-- [[ 🔱 100x HUB - THE ETERNAL LOOP V3.0 ]] --

if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character

local LP = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local Http = game:GetService("HttpService")
local TP = game:GetService("TeleportService")
local RawLink = "https://raw.githubusercontent.com/100x-Hub/100x-/refs/heads/main/main.lua"

-- [ 🛡️ ระบบฝังโค้ดข้ามเซิร์ฟ (หัวใจหลัก) ] --
local function Reinforce()
    local source = 'loadstring(game:HttpGet("'..RawLink..'"))()'
    -- ตรวจสอบตัวรันทุกค่าย (Synapse, Fluxus, Delta, Codex, Arceus)
    local qot = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport) or (Arceus and Arceus.queue_on_teleport)
    
    if qot then 
        pcall(function() qot(source) end) 
        print("🔱 100x HUB: ล็อคเป้าหมายเซิร์ฟหน้าแล้ว!")
    else
        warn("🔱 100x HUB: ตัวรันของคุณไม่รองรับการรันอัตโนมัติ ต้องใช้ระบบ Auto-Execute ช่วย!")
    end
end

-- [ 📦 ระบบเก็บผลไม้ ] --
local function Snatch()
    pcall(function() 
        if not LP.Team or LP.Team.Name == "Choosing" then 
            RS.Remotes.CommF_:InvokeServer("SetTeam", "Pirates") 
        end 
    end)
    task.wait(2.5)
    
    local isStored = false
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 800, 0)
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Tool") and string.find(v.Name, "Fruit") then
                LP.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
                task.wait(0.8)
                RS.Remotes.CommF_:InvokeServer("StoreFruit", v.Name, v)
                task.wait(2) -- รอเซฟข้อมูล
                isStored = true
                break
            end
        end
    end
    return isStored
end

-- [ 🚀 ระบบย้ายเซิร์ฟเวอร์ ] --
local function QuantumHop()
    print("🔱 100x HUB: กำลังเตรียมตัวย้ายเซิร์ฟเวอร์...")
    Reinforce() -- ฝังโค้ดก่อนวาร์ป
    task.wait(1)
    
    -- ระบบวาร์ปแบบเสถียร (สุ่มเซิร์ฟที่มีคนน้อย)
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local res = game:HttpGet(url)
    local data = Http:JSONDecode(res)
    
    for _, server in pairs(data.data) do
        if server.playing >= 1 and server.playing <= 8 and server.id ~= game.JobId then
            print("🔱 100x HUB: ย้ายไปเซิร์ฟเวอร์ " .. server.id)
            pcall(function() TP:TeleportToPlaceInstance(game.PlaceId, server.id, LP) end)
            task.wait(3)
        end
    end
    -- ถ้าหาเซิร์ฟเจาะจงไม่ได้ ให้วาร์ปสุ่ม
    TP:Teleport(game.PlaceId)
end

-- [ เริ่มทำงาน ] --
task.spawn(function()
    Snatch()
    task.wait(2)
    QuantumHop()
end)

-- กันค้างหน้า Error
game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    task.wait(1)
    TP:Teleport(game.PlaceId)
end)
