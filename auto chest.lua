local player = game.Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local collected = {}
local visitedServers = {}

-- CHỜ GAME LOAD
repeat task.wait() until game:IsLoaded()

-- AUTO CHỌN MARINE
task.spawn(function()

    repeat task.wait() until player.PlayerGui:FindFirstChild("Main")

    local choose = player.PlayerGui.Main:FindFirstChild("ChooseTeam", true)

    if choose then

        local marine = choose:FindFirstChild("Marine", true)

        if marine then
            repeat
                task.wait(0.3)
                pcall(function()
                    marine:Activate()
                end)
            until player.Team ~= nil
        end

    end

end)

-- CHỜ CHARACTER SPAWN
repeat task.wait() until player.Character
repeat task.wait() until player.Character:FindFirstChild("HumanoidRootPart")

-- SERVER HOP THÔNG MINH
function serverHop()

    local place = game.PlaceId

    local req = game:HttpGet(
        "https://games.roblox.com/v1/games/"..place.."/servers/Public?sortOrder=Asc&limit=100"
    )

    local data = HttpService:JSONDecode(req)

    for _,v in pairs(data.data) do
        
        if v.playing < v.maxPlayers and not visitedServers[v.id] then
            
            visitedServers[v.id] = true
            
            TeleportService:TeleportToPlaceInstance(place,v.id,player)
            
            break
            
        end
        
    end

end

-- AUTO CHEST
while task.wait(0.6) do
    
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if not hrp then continue end
    
    local chestFound = false
    
    for _,v in pairs(workspace:GetDescendants()) do
        
        if string.find(v.Name,"Chest") then
            
            local part
            
            if v:IsA("Model") then
                part = v:FindFirstChildWhichIsA("BasePart")
            elseif v:IsA("BasePart") then
                part = v
            end
            
            if part and part.Parent then
                
                chestFound = true
                
                if not collected[v] then
                    
                    collected[v] = true
                    
                    hrp.CFrame = part.CFrame + Vector3.new(0,3,0)
                    
                    task.wait(0.8)
                    
                end
                
            end
            
        end
        
    end
    
    if not chestFound then
        task.wait(3)
        serverHop()
    end
    
end
