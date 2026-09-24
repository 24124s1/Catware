getgenv().cloneref = cloneref or function(...) return ... end

local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Players = cloneref(game:GetService("Players"))
local LocalPlayer = Players.LocalPlayer

local TeamManager = {
    Members = {},
}

if game.PlaceId == 79783567666809 then
    local SquadRemotes = ReplicatedStorage:WaitForChild("SquadRemotes")
    SquadRemotes.SquadUpdate.OnClientEvent:Connect(function(data)
        if data and data.members then
            TeamManager.Members = data.members
        end
    end)
end

local IsTeam = function(plr)
    if game.PlaceId == 112757576021097 then
        local myStates = LocalPlayer:FindFirstChild("PlayerStates")
        local plrStates = plr:FindFirstChild("PlayerStates")
        if myStates and plrStates and myStates:FindFirstChild("Team") and plrStates:FindFirstChild("Team") then
            return myStates.Team.Value == plrStates.Team.Value
        end
        return false
    end
    
    if game.PlaceId == 138485390344924 then
        return LocalPlayer:GetAttribute("Team") == plr:GetAttribute("Team")
    end

    if game.PlaceId == 115872975504419 then
        return table.find(TeamManager.Members, plr.UserId) ~= nil
    end

    return plr.Team == LocalPlayer.Team
end

return IsTeam
