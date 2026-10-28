local espModule = {}

espModule.Settings = {
    TextFont = "ProggyTiny",
    FlagsFont = "ProggyTiny",
    HealthFont = "ProggyTiny",
    Enemy = {
        Enabled = false,
        BoxEnabled = false,
        BoxType = "Corner",
        Thickness = 1,
        Names = false,
        Distance = false,
        Tool = false,
        HealthBar = false,
        HealthText = false,
        TextSize = 12,
        Skeleton = false,
        SkeletonThickness = 0.5,
        Chams = false,
        ChamsFillTransparency = 0.5,
        ChamsOutlineTransparency = 0,
        ChamsGlow = false,
        ChamsGlowTransparency = 0.7,
        Tracers = false,
        TracerThickness = 1,
        TracerOrigin = "Bottom",
        LineColor = Color3.fromRGB(255, 80, 80),
        TextColor = Color3.fromRGB(255, 255, 255),
        HealthTop = Color3.fromRGB(0, 255, 100),
        HealthBottom = Color3.fromRGB(255, 40, 40),
        SkeletonColor = Color3.fromRGB(255, 80, 80),
        ChamsFillColor = Color3.fromRGB(255, 80, 80),
        ChamsOutlineColor = Color3.fromRGB(255, 80, 80),
        ChamsGlowColor = Color3.fromRGB(255, 80, 80),
        TracerColor = Color3.fromRGB(255, 80, 80),
    },
    Teammate = {
        Enabled = false,
        BoxEnabled = false,
        BoxType = "Corner",
        Thickness = 1,
        Names = false,
        Distance = false,
        Tool = false,
        HealthBar = false,
        HealthText = false,
        TextSize = 12,
        Skeleton = false,
        SkeletonThickness = 0.5,
        Chams = false,
        ChamsFillTransparency = 0.1,
        ChamsOutlineTransparency = 0,
        ChamsGlow = false,
        ChamsGlowTransparency = 0.75,
        Tracers = false,
        TracerThickness = 1,
        TracerOrigin = "Bottom",
        LineColor = Color3.fromRGB(0, 180, 255),
        TextColor = Color3.fromRGB(180, 230, 255),
        HealthTop = Color3.fromRGB(0, 200, 255),
        HealthBottom = Color3.fromRGB(30, 80, 140),
        SkeletonColor = Color3.fromRGB(0, 180, 255),
        ChamsFillColor = Color3.fromRGB(0, 180, 255),
        ChamsOutlineColor = Color3.fromRGB(0, 180, 255),
        ChamsGlowColor = Color3.fromRGB(0, 180, 255),
        TracerColor = Color3.fromRGB(0, 180, 255),
    },
    AI = {
        Enabled = false,
        BoxEnabled = false,
        BoxType = "Corner",
        Thickness = 1,
        Names = false,
        Distance = false,
        Tool = false,
        HealthBar = false,
        HealthText = false,
        TextSize = 12,
        Skeleton = false,
        SkeletonThickness = 0.5,
        Chams = false,
        ChamsFillTransparency = 0.5,
        ChamsOutlineTransparency = 0,
        ChamsGlow = false,
        ChamsGlowTransparency = 0.7,
        Tracers = false,
        TracerThickness = 1,
        TracerOrigin = "Bottom",
        LineColor = Color3.fromRGB(255, 200, 50),
        TextColor = Color3.fromRGB(255, 255, 255),
        HealthTop = Color3.fromRGB(0, 255, 100),
        HealthBottom = Color3.fromRGB(255, 40, 40),
        SkeletonColor = Color3.fromRGB(255, 200, 50),
        ChamsFillColor = Color3.fromRGB(255, 200, 50),
        ChamsOutlineColor = Color3.fromRGB(255, 200, 50),
        ChamsGlowColor = Color3.fromRGB(255, 200, 50),
        TracerColor = Color3.fromRGB(255, 200, 50),
    },
    Items = {
        Enabled = false,
        MaxDistance = 200,
        TextSize = 12,
        ShowNames = false,
        ShowDistance = false,
        ShowContents = false,
        Chams = false,
        ChamsFillTransparency = 0.3,
        Safe = { Enabled = false, Color = Color3.fromRGB(192, 192, 192) },
        CivilianAirdrop = { Enabled = false, Color = Color3.fromRGB(255, 140, 0) },
        AbandonedCar = { Enabled = false, Color = Color3.fromRGB(169, 169, 169) },
        DuffelBag = { Enabled = false, Color = Color3.fromRGB(139, 69, 19) },
        FoodCrate = { Enabled = false, Color = Color3.fromRGB(0, 255, 0) },
        LeatherPouch = { Enabled = false, Color = Color3.fromRGB(160, 82, 45) },
        SupplyCrate = { Enabled = false, Color = Color3.fromRGB(0, 191, 255) },
        MedicalPouch = { Enabled = false, Color = Color3.fromRGB(255, 20, 20) },
        TCRCrate = { Enabled = false, Color = Color3.fromRGB(192, 192, 192) },
        MetalCrate = { Enabled = false, Color = Color3.fromRGB(255, 140, 0) },
        TallMetalCrate = { Enabled = false, Color = Color3.fromRGB(169, 169, 169) },
        SpecopsCrate = { Enabled = false, Color = Color3.fromRGB(139, 69, 19) },
        AmmoBox = { Enabled = false, Color = Color3.fromRGB(0, 255, 0) },
        WoodenCrate = { Enabled = false, Color = Color3.fromRGB(160, 82, 45) },
        DroppedItemContainer = { Enabled = false, Color = Color3.fromRGB(255, 105, 180) },
        Dead = { Enabled = false, Color = Color3.fromRGB(255, 0, 0) },
    }
}

espModule._cache = {}
espModule._itemCache = {}
espModule._bots = {}
espModule._containers = {}
espModule._isRunning = false
espModule._connections = {}
espModule.Fonts = {}
espModule.Holder = nil

local cloneref = cloneref or function(...) return ... end
local GetService = setmetatable({}, {__index = function(_, k) return cloneref(game:GetService(k)) end})
local Services = {
    RunService = GetService.RunService,
    Players = GetService.Players,
    CoreGui = GetService.CoreGui,
    WorkSpace = GetService.Workspace,
    HttpService = GetService.HttpService,
}
Services.LocalPlayer = Services.Players.LocalPlayer
Services.CurrentCamera = Services.WorkSpace.CurrentCamera

local PLACE_ID = game.PlaceId
local HAS_BOTS_ITEMS = PLACE_ID == 79783567666809
local HAS_CUSTOM_CHARS = PLACE_ID == 138485390344924
local MAX_ENTITY_DIST = 1200
local MAX_ITEM_DIST_MULT = 2.81

local IsTeam
pcall(function()
    IsTeam = loadstring(game:HttpGet("https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/TeamCheck.lua"))()
end)
if type(IsTeam) ~= "function" then
    IsTeam = function(plr)
        if not plr or plr == Services.LocalPlayer then return false end
        if plr.Team and Services.LocalPlayer.Team and plr.Team == Services.LocalPlayer.Team then return true end
        local character = plr.Character
        if character and character:FindFirstChild("SquadBillboard") then return true end
        return false
    end
end

local function loadFont()
    if next(espModule.Fonts) then return end
    local FontFolder = "esp_fonts"
    if not isfolder(FontFolder) then pcall(makefolder, FontFolder) end

    local fontList = {
        {"Comfortaa", "Comfortaa-Regular.ttf"},
        {"HankenGrotesk", "HankenGrotesk-SemiBold.ttf"},
        {"Inter Medium", "Inter_28pt-Medium.ttf"},
        {"Inter SemiBold", "Inter_28pt-SemiBold.ttf"},
        {"Light Modern", "Light Modern.ttf"},
        {"Minecraftia", "Minecraftia-Regular.ttf"},
        {"ProggyClean", "ProggyClean.ttf"},
        {"ProggyTiny", "ProggyTiny.ttf"},
        {"Rubik", "Rubik-Regular.ttf"},
        {"Tahoma Modern Bold", "Tahoma-Modern-Bold.ttf"},
        {"Tahoma Modern", "Tahoma-Modern.ttf"},
        {"Verdana", "Verdana-Font.ttf"},
        {"Tahoma 8px", "fs-tahoma-8px.ttf"},
        {"Open Sans PX", "open-sans-px.ttf"},
        {"Smallest Pixel-7", "smallest_pixel-7.ttf"},
        {"Tahoma Bold", "tahoma_bold.ttf"},
        {"XPTahoma", "Tahoma8PTBOLD.ttf"},
    }

    local baseUrl = "https://raw.githubusercontent.com/i77lhm/storage/main/fonts/"
    local altUrls = {
        ["Tahoma8PTBOLD.ttf"] = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/TAHOMA-8PT-BOLD-WINDOWS-XP.TTF",
        ["smallest_pixel-7.ttf"] = "https://raw.githubusercontent.com/sametexe001/luas/main/smallest_pixel-7.ttf",
    }

    for _, entry in ipairs(fontList) do
        local Name, FileName = entry[1], entry[2]
        local Path = FontFolder .. "/" .. FileName
        local data
        pcall(function() if isfile and isfile(Path) then data = readfile(Path) end end)
        if not data or #data < 100 then
            local url = altUrls[FileName] or (baseUrl .. FileName:gsub(" ", "%%20"))
            local ok, content = pcall(function() return game:HttpGet(url) end)
            if ok and content and #content > 100 then
                data = content
                pcall(function() if writefile then writefile(Path, content) end end)
            end
        end
        if data and #data > 100 then
            local ok, font = pcall(function()
                local f = Drawing.new("Font")
                f.Data = data
                return f
            end)
            if ok and font then espModule.Fonts[Name] = font end
        end
    end

    if not espModule.Fonts["Tahoma"] then
        espModule.Fonts["Tahoma"] = espModule.Fonts["Tahoma Modern"] or espModule.Fonts["Tahoma 8px"] or espModule.Fonts["XPTahoma"]
    end
    if not espModule.Fonts["Consolas Bold"] then
        espModule.Fonts["Consolas Bold"] = espModule.Fonts["ProggyClean"] or espModule.Fonts["Smallest Pixel-7"]
    end
end

local function Create(name, props)
    local obj = Instance.new(name)
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

local function getFont(name)
    return espModule.Fonts[name] or Drawing.Fonts.UI or Drawing.Fonts.System
end

function espModule:CreateTarget(entity)
    if self._cache[entity] then return end
    local data = {
        Entity = entity,
        Objects = {},
        Conns = {},
        Highlight = nil,
        GlowHighlight = nil,
    }
    self._cache[entity] = data

    local objs = data.Objects
    objs.Holder = Create("Frame", {
        Parent = self.Holder,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
    })

    objs.BoxOutline = Create("Frame", {
        Parent = objs.Holder,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    })
    Create("UIStroke", {
        Parent = objs.BoxOutline,
        Thickness = 3,
        Color = Color3.new(0, 0, 0),
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    objs.Box = Create("Frame", {
        Parent = objs.Holder,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    })
    Create("UIStroke", {
        Parent = objs.Box,
        Thickness = 1,
        Color = Color3.fromRGB(255, 80, 80),
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    objs.HealthBG = Create("Frame", {
        Parent = objs.Holder,
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderSizePixel = 0,
        Visible = false,
    })
    objs.HealthFill = Create("Frame", {
        Parent = objs.HealthBG,
        BackgroundColor3 = Color3.fromRGB(0, 255, 100),
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
    })

    objs.NameText = Create("TextLabel", {
        Parent = objs.Holder,
        BackgroundTransparency = 1,
        TextStrokeTransparency = 0,
        TextStrokeColor3 = Color3.new(0, 0, 0),
        TextSize = 12,
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Center,
        Visible = false,
    })
    objs.DistanceText = Create("TextLabel", {
        Parent = objs.Holder,
        BackgroundTransparency = 1,
        TextStrokeTransparency = 0,
        TextStrokeColor3 = Color3.new(0, 0, 0),
        TextSize = 12,
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left,
        Visible = false,
    })
    objs.ToolText = Create("TextLabel", {
        Parent = objs.Holder,
        BackgroundTransparency = 1,
        TextStrokeTransparency = 0,
        TextStrokeColor3 = Color3.new(0, 0, 0),
        TextSize = 12,
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Center,
        Visible = false,
    })
    objs.HealthText = Create("TextLabel", {
        Parent = objs.Holder,
        BackgroundTransparency = 1,
        TextStrokeTransparency = 0,
        TextStrokeColor3 = Color3.new(0, 0, 0),
        TextSize = 12,
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Right,
        Visible = false,
    })
end

function espModule:RemoveTarget(entity)
    local data = self._cache[entity]
    if not data then return end
    for _, c in pairs(data.Conns) do pcall(function() c:Disconnect() end) end
    if data.Objects.Holder then data.Objects.Holder:Destroy() end
    if data.Highlight then data.Highlight:Destroy() end
    if data.GlowHighlight then data.GlowHighlight:Destroy() end
    self._cache[entity] = nil
end

function espModule:UpdateTarget(entity)
    local data = self._cache[entity]
    if not data then return end

    local isPlayer = typeof(entity) == "Instance" and entity:IsA("Player")
    local cfg = isPlayer and (IsTeam(entity) and self.Settings.Teammate or self.Settings.Enemy) or self.Settings.AI

    if not cfg.Enabled then
        data.Objects.Holder.Visible = false
        if data.Highlight then data.Highlight.Enabled = false end
        if data.GlowHighlight then data.GlowHighlight.Enabled = false end
        return
    end

    local character = isPlayer and entity.Character or entity
    if not character then
        data.Objects.Holder.Visible = false
        return
    end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid or humanoid.Health <= 0 then
        data.Objects.Holder.Visible = false
        return
    end

    local cam = Services.CurrentCamera
    if not cam then return end

    local pos, onScreen = cam:WorldToViewportPoint(hrp.Position)
    if not onScreen or pos.Z <= 0 then
        data.Objects.Holder.Visible = false
        return
    end

    local dist = (cam.CFrame.Position - hrp.Position).Magnitude
    if dist > MAX_ENTITY_DIST then
        data.Objects.Holder.Visible = false
        return
    end

    local size = Vector2.new(math.clamp(60 * (20 / dist), 20, 80), math.clamp(90 * (20 / dist), 30, 120))
    local x = pos.X - size.X / 2
    local y = pos.Y - size.Y / 2

    data.Objects.Holder.Position = UDim2.fromOffset(x, y)
    data.Objects.Holder.Size = UDim2.fromOffset(size.X, size.Y)
    data.Objects.Holder.Visible = true

    local textFont = getFont(self.Settings.TextFont)
    local flagsFont = getFont(self.Settings.FlagsFont)
    local healthFont = getFont(self.Settings.HealthFont)

    if cfg.BoxEnabled then
        data.Objects.BoxOutline.Size = UDim2.fromOffset(size.X, size.Y)
        data.Objects.BoxOutline.Visible = true
        data.Objects.Box.Size = UDim2.fromOffset(size.X - 2, size.Y - 2)
        data.Objects.Box.Position = UDim2.fromOffset(1, 1)
        data.Objects.Box.Visible = true
        local stroke = data.Objects.Box:FindFirstChildOfClass("UIStroke")
        if stroke then
            stroke.Color = cfg.LineColor
            stroke.Thickness = cfg.Thickness
        end
    else
        data.Objects.BoxOutline.Visible = false
        data.Objects.Box.Visible = false
    end

    if cfg.HealthBar then
        local hp = math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)
        data.Objects.HealthBG.Size = UDim2.fromOffset(3, size.Y)
        data.Objects.HealthBG.Position = UDim2.fromOffset(-6, 0)
        data.Objects.HealthBG.Visible = true
        data.Objects.HealthFill.Size = UDim2.new(1, 0, hp, 0)
        data.Objects.HealthFill.BackgroundColor3 = cfg.HealthBottom:Lerp(cfg.HealthTop, hp)
    else
        data.Objects.HealthBG.Visible = false
    end

    if cfg.Names then
        data.Objects.NameText.Text = isPlayer and entity.DisplayName or character.Name
        data.Objects.NameText.FontFace = textFont
        data.Objects.NameText.TextSize = cfg.TextSize
        data.Objects.NameText.TextColor3 = cfg.TextColor
        data.Objects.NameText.Position = UDim2.fromOffset(0, -16)
        data.Objects.NameText.Size = UDim2.new(1, 0, 0, 14)
        data.Objects.NameText.Visible = true
    else
        data.Objects.NameText.Visible = false
    end

    if cfg.Distance then
        data.Objects.DistanceText.Text = string.format("[%dm]", math.floor(dist / 2.81 + 0.5))
        data.Objects.DistanceText.FontFace = flagsFont
        data.Objects.DistanceText.TextSize = cfg.TextSize
        data.Objects.DistanceText.TextColor3 = cfg.TextColor
        data.Objects.DistanceText.Position = UDim2.fromOffset(size.X + 4, 0)
        data.Objects.DistanceText.Size = UDim2.fromOffset(50, 14)
        data.Objects.DistanceText.Visible = true
    else
        data.Objects.DistanceText.Visible = false
    end

    if cfg.Tool then
        local tool = character:FindFirstChildOfClass("Tool")
        data.Objects.ToolText.Text = tool and tool.Name or "None"
        data.Objects.ToolText.FontFace = textFont
        data.Objects.ToolText.TextSize = cfg.TextSize
        data.Objects.ToolText.TextColor3 = cfg.TextColor
        data.Objects.ToolText.Position = UDim2.fromOffset(0, size.Y + 2)
        data.Objects.ToolText.Size = UDim2.new(1, 0, 0, 14)
        data.Objects.ToolText.Visible = true
    else
        data.Objects.ToolText.Visible = false
    end

    if cfg.HealthText then
        data.Objects.HealthText.Text = tostring(math.floor(humanoid.Health + 0.5))
        data.Objects.HealthText.FontFace = healthFont
        data.Objects.HealthText.TextSize = cfg.TextSize
        data.Objects.HealthText.TextColor3 = Color3.new(1, 1, 1)
        data.Objects.HealthText.Position = UDim2.fromOffset(-32, 0)
        data.Objects.HealthText.Size = UDim2.fromOffset(28, 14)
        data.Objects.HealthText.Visible = true
    else
        data.Objects.HealthText.Visible = false
    end

    if cfg.Chams then
        if not data.Highlight then
            data.Highlight = Instance.new("Highlight")
            data.Highlight.Parent = Services.CoreGui
            data.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        end
        data.Highlight.Adornee = character
        data.Highlight.FillColor = cfg.ChamsFillColor
        data.Highlight.OutlineColor = cfg.ChamsOutlineColor
        data.Highlight.FillTransparency = cfg.ChamsFillTransparency
        data.Highlight.OutlineTransparency = cfg.ChamsOutlineTransparency
        data.Highlight.Enabled = true

        if cfg.ChamsGlow then
            if not data.GlowHighlight then
                data.GlowHighlight = Instance.new("Highlight")
                data.GlowHighlight.Parent = Services.CoreGui
                data.GlowHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            end
            data.GlowHighlight.Adornee = character
            data.GlowHighlight.FillColor = cfg.ChamsGlowColor or cfg.ChamsFillColor
            data.GlowHighlight.OutlineColor = cfg.ChamsGlowColor or cfg.ChamsFillColor
            data.GlowHighlight.FillTransparency = cfg.ChamsGlowTransparency or 0.7
            data.GlowHighlight.OutlineTransparency = 1
            data.GlowHighlight.Enabled = true
        elseif data.GlowHighlight then
            data.GlowHighlight.Enabled = false
        end
    else
        if data.Highlight then data.Highlight.Enabled = false end
        if data.GlowHighlight then data.GlowHighlight.Enabled = false end
    end
end

local _frame = 0
local function loop()
    _frame = _frame + 1
    if _frame % 2 ~= 0 then return end

    local s = espModule.Settings
    local any = s.Enemy.Enabled or s.Teammate.Enabled or s.AI.Enabled
    if not any then
        for entity, data in pairs(espModule._cache) do
            data.Objects.Holder.Visible = false
            if data.Highlight then data.Highlight.Enabled = false end
            if data.GlowHighlight then data.GlowHighlight.Enabled = false end
        end
        return
    end

    if HAS_CUSTOM_CHARS then
        for _, bot in ipairs(espModule._bots) do
            if bot and bot.Parent then
                if not espModule._cache[bot] then
                    espModule:CreateTarget(bot)
                end
                espModule:UpdateTarget(bot)
            end
        end
    else
        for _, player in ipairs(Services.Players:GetPlayers()) do
            if player ~= Services.LocalPlayer then
                if not espModule._cache[player] then
                    espModule:CreateTarget(player)
                end
                espModule:UpdateTarget(player)
            end
        end
        if HAS_BOTS_ITEMS then
            for _, bot in ipairs(espModule._bots) do
                if bot and bot.Parent then
                    if not espModule._cache[bot] then
                        espModule:CreateTarget(bot)
                    end
                    espModule:UpdateTarget(bot)
                end
            end
        end
    end
end

function espModule:Start()
    if self._isRunning then return end
    self._isRunning = true
    loadFont()

    if not self.Holder then
        self.Holder = Create("ScreenGui", {
            Name = "ESPHolder",
            Parent = gethui and gethui() or Services.CoreGui,
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Global,
            IgnoreGuiInset = true,
            DisplayOrder = 10000,
        })
    end

    table.clear(self._bots)
    table.clear(self._containers)

    if HAS_BOTS_ITEMS then
        local folder = Services.WorkSpace:FindFirstChild("IngameBots")
        if folder then
            for _, v in ipairs(folder:GetChildren()) do
                if v:IsA("Model") then self._bots[#self._bots + 1] = v end
            end
            self._connections.BotAdded = folder.ChildAdded:Connect(function(c)
                if c:IsA("Model") then self._bots[#self._bots + 1] = c end
            end)
            self._connections.BotRemoving = folder.ChildRemoved:Connect(function(c)
                local idx = table.find(self._bots, c)
                if idx then table.remove(self._bots, idx) end
                self:RemoveTarget(c)
            end)
        end
    end

    if HAS_CUSTOM_CHARS then
        local gl = Services.WorkSpace:FindFirstChild("GameLogic")
        if gl then
            local chars = gl:FindFirstChild("Characters")
            if chars then
                for _, v in ipairs(chars:GetChildren()) do
                    if v:IsA("Model") then self._bots[#self._bots + 1] = v end
                end
                self._connections.CharAdded = chars.ChildAdded:Connect(function(c)
                    if c:IsA("Model") then self._bots[#self._bots + 1] = c end
                end)
                self._connections.CharRemoving = chars.ChildRemoved:Connect(function(c)
                    local idx = table.find(self._bots, c)
                    if idx then table.remove(self._bots, idx) end
                    self:RemoveTarget(c)
                end)
            end
        end
    end

    self._connections.PlayerRemoving = Services.Players.PlayerRemoving:Connect(function(p)
        self:RemoveTarget(p)
    end)
    self._connections.Heartbeat = Services.RunService.Heartbeat:Connect(loop)
end

function espModule:Stop()
    if not self._isRunning then return end
    self._isRunning = false
    for _, c in pairs(self._connections) do pcall(function() c:Disconnect() end) end
    self._connections = {}
    for entity in pairs(self._cache) do
        self:RemoveTarget(entity)
    end
    self._cache = {}
    if self.Holder then
        self.Holder:Destroy()
        self.Holder = nil
    end
    table.clear(self._bots)
    table.clear(self._containers)
end

function espModule:Restart()
    self:Stop()
    self:Start()
end

function espModule:UpdateSettings(new)
    local function merge(t1, t2)
        for k, v in pairs(t2) do
            if type(v) == "table" and type(t1[k]) == "table" then
                merge(t1[k], v)
            else
                t1[k] = v
            end
        end
    end
    merge(self.Settings, new)
end

function espModule:GetSettings()
    return self.Settings
end

function espModule:Toggle()
    if self._isRunning then self:Stop() else self:Start() end
end

function espModule:GetFonts()
    local list = {}
    for name in pairs(self.Fonts) do list[#list + 1] = name end
    table.sort(list)
    return list
end

return espModule
