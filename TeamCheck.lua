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

local GameState = nil
if game.PlaceId == 109020905733214 then
    local classes = ReplicatedStorage:FindFirstChild("Classes")
    local userInterface = classes and classes:FindFirstChild("UserInterface")
    local reactApp = userInterface and userInterface:FindFirstChild("ReactApp")
    local gameStateModule = reactApp and reactApp:FindFirstChild("GameState")
    if gameStateModule then
        GameState = require(gameStateModule)
    end
end

local function getMM2Data()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local extras = remotes and remotes:FindFirstChild("Extras")
    local remote = extras and extras:FindFirstChild("GetPlayerData")
    if not remote then return nil end
    local ok, data = pcall(function()
        return remote:InvokeServer()
    end)
    if ok and type(data) == "table" then
        return data
    end
    return nil
end

local function getMM2Role(plr)
    local data = getMM2Data()
    if not data then return nil end
    local info = data[plr.Name]
    if type(info) == "table" then
        return info.Role
    end
    return nil
end

local IsTeam = function(plr)
    if game.PlaceId == 109020905733214 then
        local c = plr.Character
        if not c then
            return false
        end
        
        local success, result = pcall(function()
            local a = c:GetAttribute("BotUniqueId")
            if a and GameState and GameState.isTeammate then
                return GameState.isTeammate(a)
            end

            if plr then
                return GameState and GameState.isTeammate and GameState.isTeammate(plr.UserId) or false
            end

            return false
        end)

        if success and result then
            return true
        end
        return false
    end

    if game.PlaceId == 112757576021097 then
        local myStates = LocalPlayer:FindFirstChild("PlayerStates")
        local plrStates = plr:FindFirstChild("PlayerStates")
        if myStates and plrStates and myStates:FindFirstChild("Team") and plrStates:FindFirstChild("Team") then
            return myStates.Team.Value == plrStates.Team.Value
        end
        return false
    end
    
    if game.PlaceId == 138485390344924 or game.PlaceId == 87204735676240 then
        return LocalPlayer:GetAttribute("Team") == plr:GetAttribute("Team")
    end

    if game.PlaceId == 75959630651788 then
        return LocalPlayer:GetAttribute("MatchTeam") == plr:GetAttribute("MatchTeam")
    end

    if game.PlaceId == 124417592421329 then
        return (LocalPlayer:GetAttribute("_Team") == plr:GetAttribute("_Team")) and (LocalPlayer:GetAttribute("_InMatch") == plr:GetAttribute("_InMatch"))
    end
    if game.PlaceId == 84449017742177 then
        return LocalPlayer:FindFirstChild("RoundValues"):FindFirstChild("Role").Value == plr:FindFirstChild("RoundValues"):FindFirstChild("Role").Value
    end
    if game.PlaceId == 115872975504419 then
        return table.find(TeamManager.Members, plr.UserId) ~= nil
    end
    if game.PlaceId == 142823291 then
        local myRole = getMM2Role(LocalPlayer)
        local theirRole = getMM2Role(plr)
        if not myRole or not theirRole then
            return false
        end
        if myRole == "Murderer" then
            return false
        end
        return theirRole ~= "Murderer"
    end
    return plr.Team == LocalPlayer.Team
end
return IsTeam
