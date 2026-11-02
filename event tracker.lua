local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local placeId = game.PlaceId
local hopInterval = 12 -- Time to wait in a server before hopping to the next

-- Function to check if the outburst or supercharged meteor is present
local function checkEventActive()
    -- Check Workspace for meteor objects
    for _, obj in ipairs(Workspace:GetChildren()) do
        local name = obj.Name:lower()
        if name:find("meteor") or name:find("outburst") then
            return true
        end
    end
    
    -- Check UI/Chat notifications currently on screen
    for _, descendant in ipairs(PlayerGui:GetDescendants()) do
        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
            local text = descendant.Text:lower()
            if text:find("meteoric outburst") or text:find("supercharged meteor") then
                return true
            en
        end
    end
    
    return false
end

-- Function to hop to a different public server
local function serverHop()
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    
    if success and result and result.data then
        for _, server in ipairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(placeId, server.id, Players.LocalPlayer)
                return
            end
        end
    end
end

-- Main logic loop
task.spawn(function()
    -- Give the server a few seconds to fully load assets upon joining
    task.wait(5)
    
    if checkEventActive() then
        print("🚨 METEORIC OUTBURST FOUND ON THIS SERVER!")
    else
        print("No event found. Hopping to a new server in " .. hopInterval .. " seconds...")
        task.wait(hopInterval)
        serverHop()
    end
end)
