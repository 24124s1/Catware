print('1')

local cloneref = cloneref or function(o) return o end

local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local HttpService = cloneref(game:GetService("HttpService"))
local LocalPlayer = Players.LocalPlayer

local rgb = Color3.fromRGB
local floor = math.floor
local clamp = math.clamp
local mmin = math.min
local mmax = math.max
local huge = math.huge
local sqrt = math.sqrt
local abs = math.abs
local deg = math.deg
local atan2 = math.atan2
local newInstance = Instance.new
local fromOffset = UDim2.fromOffset
local fromScale = UDim2.fromScale
local v2 = Vector2.new
local v3 = Vector3.new
local tfind = table.find
local tclear = table.clear
local clock = os.clock
local pcall = pcall
local pairs = pairs
local ipairs = ipairs
local type = type
local typeof = typeof
local tostring = tostring
local envTable = (typeof(getgenv) == "function" and getgenv()) or _G

local espModule = {}

local KEY_COLORS = {
    [0] = rgb(255, 0, 255),
    [1] = rgb(0, 255, 255),
    [2] = rgb(0, 0, 255),
}

local CHAMS_DESIGNS = {
    Neon = { Style = 0, Brightness = 1.1, Contrast = 1.1, Bloom = 0.4, BloomSpread = 3.0, Speed = 1.5, Scale = 3.0 },
    Matrix = { Style = 1, Brightness = 1.2, Contrast = 1.0, Bloom = 0.5, BloomSpread = 3.5, Speed = 1.2, Scale = 2.5 },
    Frost = { Style = 2, Brightness = 1.1, Contrast = 1.1, Bloom = 0.4, BloomSpread = 3.0, Speed = 1.2, Scale = 3.0 },
    Lava = { Style = 3, Brightness = 1.1, Contrast = 1.0, Bloom = 0.55, BloomSpread = 3.0, Speed = 1.0, Scale = 3.0 },
    Cyber = { Style = 4, Brightness = 1.15, Contrast = 1.1, Bloom = 0.4, BloomSpread = 3.0, Speed = 0.8, Scale = 2.2 },
    Aurora = { Style = 5, Brightness = 1.1, Contrast = 1.05, Bloom = 0.45, BloomSpread = 3.0, Speed = 1.0, Scale = 2.8 },
    Plasma = { Style = 6, Brightness = 1.1, Contrast = 1.0, Bloom = 0.4, BloomSpread = 3.0, Speed = 1.2, Scale = 2.6 },
    Galaxy = { Style = 7, Brightness = 1.15, Contrast = 1.1, Bloom = 0.4, BloomSpread = 3.0, Speed = 0.7, Scale = 3.0 },
    Pulse = { Style = 8, Brightness = 1.1, Contrast = 1.0, Bloom = 0.5, BloomSpread = 3.0, Speed = 1.0, Scale = 2.0 },
    Ripple = { Style = 9, Brightness = 1.1, Contrast = 1.05, Bloom = 0.4, BloomSpread = 3.0, Speed = 1.0, Scale = 2.4 },
    Stripes = { Style = 10, Brightness = 1.1, Contrast = 1.0, Bloom = 0.35, BloomSpread = 3.0, Speed = 0.9, Scale = 3.0 },
    Gradient = { Style = 11, Brightness = 1.05, Contrast = 1.0, Bloom = 0.35, BloomSpread = 3.0, Speed = 0.8, Scale = 2.0 },
    Waves = { Style = 12, Brightness = 1.1, Contrast = 1.05, Bloom = 0.4, BloomSpread = 3.0, Speed = 1.0, Scale = 2.6 },
    Solid = { Style = 13, Brightness = 1.05, Contrast = 1.0, Bloom = 0.3, BloomSpread = 2.5, Speed = 0.6, Scale = 2.0 },
}

local CHAMS_DESIGN_NAMES = {"Neon", "Matrix", "Frost", "Lava", "Cyber", "Aurora", "Plasma", "Galaxy", "Pulse", "Ripple", "Stripes", "Gradient", "Waves", "Solid"}

local function chamsFromDesign(name, into)
    local d = CHAMS_DESIGNS[name] or CHAMS_DESIGNS.Neon
    into = into or {}
    into.Design = CHAMS_DESIGNS[name] and name or "Neon"
    into.Brightness = d.Brightness
    into.Contrast = d.Contrast
    into.Bloom = d.Bloom
    into.BloomSpread = d.BloomSpread
    into.Speed = d.Speed
    into.Scale = d.Scale
    return into
end

local function entitySettings(p)
    return {
        Enabled = false,
        BoxEnabled = false, BoxType = "Corner", Thickness = 1, LineColor = p.main,
        BoxGlow = false,
        BoxFill = false, BoxFillColor1 = p.fill1, BoxFillColor2 = p.fill2, BoxFillTransparency = 0.7,
        BoxFillRotation = 0, BoxFillSpeed = 2,
        Chams = false, ChamsKey = p.key, ChamsType = "Shader",
        AdornmentTransparency = 0.55, AdornmentGlowTransparency = 0.78,
        ChamsSettings = chamsFromDesign(p.design, {
            Color1 = p.c1 or rgb(12, 120, 110),
            Color2 = p.c2 or rgb(48, 220, 245),
            Color3 = p.c3 or rgb(195, 85, 235),
            ColorCount = 3
        }),
        Names = false, NameType = "Display", NameColor = p.text1, NameColor2 = p.text2, NamePos = "Top",
        Distance = false, DistanceColor = p.text1, DistanceColor2 = p.text2, DistancePos = "Right",
        Tool = false, ToolColor = p.text1, ToolColor2 = p.text2, ToolPos = "Bottom",
        Flags = false, SelectedFlags = {"Walking", "Jumping", "Swimming", "Dih"},
        FlagColor1 = rgb(255, 255, 255), FlagColor2 = rgb(200, 200, 200), FlagsPos = "Right",
        HealthBar = false, HealthText = false, HealthBarPos = "Left",
        HealthHigh = p.health[1], HealthMid = p.health[2], HealthLow = p.health[3],
        ArmorBar = false, ArmorBarPos = "Bottom",
        ArmorHigh = rgb(0, 255, 0), ArmorMid = rgb(255, 255, 0), ArmorLow = rgb(255, 0, 0),
        HeadDot = false, HeadDotColor = rgb(255, 255, 255), HeadDotSize = 20, HeadDotOutlineThickness = 1,
        Skeleton = false, SkeletonThickness = 1, SkeletonMaxDistance = 400, SkeletonColor = p.main, SkeletonColor2 = p.skel2,
        Tracers = false, TracerThickness = 1, TracerOrigin = "Bottom", TracerColor = p.main,
        TextSize = 12,
    }
end

espModule.Settings = {
    RefreshRate = 144,
    MaxDistance = 1200,
    BoxMode = "Dynamic",
    BoxSmoothing = 0,
    TextFont = "Tahoma Modern Bold",
    FlagsFont = "Tahoma Modern Bold",
    HealthFont = "Tahoma Modern Bold",
    TextGradientAnimated = true,
    Enemy = entitySettings({
        key = 0, design = "Neon",
        c1 = rgb(255, 80, 80), c2 = rgb(255, 40, 40), c3 = rgb(200, 0, 0),
        main = rgb(255, 80, 80), fill1 = rgb(255, 80, 80), fill2 = rgb(255, 40, 40), skel2 = rgb(200, 200, 200),
        text1 = rgb(255, 255, 255), text2 = rgb(200, 200, 200),
        health = {rgb(0, 255, 100), rgb(255, 255, 0), rgb(255, 40, 40)},
    }),
    Teammate = entitySettings({
        key = 1, design = "Frost",
        c1 = rgb(0, 180, 255), c2 = rgb(0, 100, 200), c3 = rgb(0, 50, 100),
        main = rgb(0, 180, 255), fill1 = rgb(0, 180, 255), fill2 = rgb(0, 100, 200), skel2 = rgb(100, 150, 200),
        text1 = rgb(180, 230, 255), text2 = rgb(100, 150, 200),
        health = {rgb(0, 200, 255), rgb(100, 200, 255), rgb(30, 80, 140)},
    }),
    AI = entitySettings({
        key = 2, design = "Lava",
        c1 = rgb(255, 200, 50), c2 = rgb(255, 150, 0), c3 = rgb(255, 100, 0),
        main = rgb(255, 200, 50), fill1 = rgb(255, 200, 50), fill2 = rgb(255, 150, 0), skel2 = rgb(200, 150, 50),
        text1 = rgb(255, 255, 255), text2 = rgb(200, 200, 200),
        health = {rgb(0, 255, 100), rgb(255, 255, 0), rgb(255, 40, 40)},
    }),
    Items = {
        Enabled = false, MaxDistance = 200, TextSize = 12,
        ShowNames = false, ShowDistance = false, ShowContents = false,
        Chams = false, ChamsFillTransparency = 0.3,
    },
}

espModule.Fonts = {}
espModule.FontNames = {}
espModule.FontsReady = false
espModule.CustomFlags = {}
espModule.CustomAIs = {}
espModule.CustomEntities = espModule.CustomAIs
espModule.CustomItems = {}
espModule.ChamsDesigns = CHAMS_DESIGNS
espModule.ChamsDesignNames = CHAMS_DESIGN_NAMES
espModule.ChamsPresetNames = CHAMS_DESIGN_NAMES
espModule.ChamsPresets = CHAMS_DESIGNS
espModule.KeyColors = KEY_COLORS

local registryListeners = {}
local fontListeners = {}

local function fireRegistry()
    for _, fn in ipairs(registryListeners) do task.spawn(fn) end
end

function espModule.OnRegistryChanged(fn)
    registryListeners[#registryListeners + 1] = fn
end

function espModule.OnFontsReady(fn)
    if espModule.FontsReady then
        task.spawn(fn)
    else
        fontListeners[#fontListeners + 1] = fn
    end
end

local function sortedKeys(tbl)
    local out = {}
    for key in pairs(tbl) do out[#out + 1] = key end
    table.sort(out)
    return out
end

function espModule.GetAINames() return sortedKeys(espModule.CustomAIs) end
function espModule.GetItemNames() return sortedKeys(espModule.CustomItems) end

function espModule.GetFlagNames()
    local out = {"Walking", "Jumping", "Swimming"}
    for _, name in ipairs(sortedKeys(espModule.CustomFlags)) do out[#out + 1] = name end
    return out
end

function espModule.GetChamsDesignNames() return CHAMS_DESIGN_NAMES end
function espModule.GetChamsPresetNames() return CHAMS_DESIGN_NAMES end

function espModule:SetChamsDesign(name, target)
    if not CHAMS_DESIGNS[name] then return false end
    local s = self.Settings
    local groups = {s.Enemy, s.Teammate, s.AI}
    if type(target) == "string" then
        groups = {s[target]}
    elseif type(target) == "table" then
        groups = {target}
    end
    for _, g in ipairs(groups) do
        if g and g.ChamsSettings then chamsFromDesign(name, g.ChamsSettings) end
    end
    return true
end

function espModule:SetChamsPreset(name, target)
    return self:SetChamsDesign(name, target)
end

function espModule:AddFlag(name, func)
    self.CustomFlags[name] = { Func = func }
    fireRegistry()
end

function espModule:RemoveFlag(name)
    self.CustomFlags[name] = nil
    fireRegistry()
end

function espModule:AddAI(name, source, options)
    if type(name) ~= "string" or name == "" or source == nil then return nil end
    self.CustomAIs[name] = { Source = source, Options = options or {}, Cache = nil, CacheAt = 0 }
    fireRegistry()
    return name
end

function espModule:AddEntity(name, source, options)
    return self:AddAI(name, source, options)
end

function espModule:AddItem(name, source, options)
    local items = self.Settings.Items
    if type(name) ~= "string" or name == "" or source == nil then return nil end
    if name == "Enabled" or name == "MaxDistance" or name == "TextSize" or name == "ShowNames"
        or name == "ShowDistance" or name == "ShowContents" or name == "Chams" or name == "ChamsFillTransparency" then
        return nil
    end
    options = options or {}
    if type(items[name]) ~= "table" then
        items[name] = { Enabled = options.Enabled == true, Color = options.Color or rgb(255, 255, 255) }
    elseif options.Color then
        items[name].Color = options.Color
    end
    self.CustomItems[name] = { Source = source, Options = options, Cache = nil, CacheAt = 0 }
    fireRegistry()
    return name
end

local fontFiles = {
    {"Tahoma", "Tahoma.ttf"}, {"Tahoma Bold", "tahoma_bold.ttf"},
    {"Tahoma Modern Bold", "Tahoma-Modern-Bold.ttf"}, {"Tahoma Modern", "Tahoma-Modern.ttf"},
    {"Comfortaa", "Comfortaa-Regular.ttf"}, {"HankenGrotesk", "HankenGrotesk-SemiBold.ttf"},
    {"Inter Medium", "Inter_28pt-Medium.ttf"}, {"Inter SemiBold", "Inter_28pt-SemiBold.ttf"},
    {"Light Modern", "Light Modern.ttf"}, {"Minecraftia", "Minecraftia-Regular.ttf"},
    {"ProggyClean", "ProggyClean.ttf"}, {"ProggyTiny", "ProggyTiny.ttf"},
    {"Rubik", "Rubik-Regular.ttf"}, {"Verdana", "Verdana-Font.ttf"},
    {"Tahoma 8px", "fs-tahoma-8px.ttf"}, {"Open Sans PX", "open-sans-px.ttf"},
    {"Smallest Pixel-7", "smallest_pixel-7.ttf"},
    {"Gojiberry Quibble", "GojiberryQuibbleFreeRegular-7OldK.ttf"},
}

for _, entry in ipairs(fontFiles) do
    espModule.FontNames[#espModule.FontNames + 1] = entry[1]
end

local fallbackFont = Font.new("rbxasset://fonts/families/GothamSSm.json")

local fontFileMap = {}
for _, entry in ipairs(fontFiles) do fontFileMap[entry[1]] = entry[2] end

local fontPending, fontFailAt = {}, {}

local function fsReady()
    return typeof(writefile) == "function"
        and typeof(isfile) == "function"
        and typeof(getcustomasset) == "function"
end

local function loadOneFont(name)
    if espModule.Fonts[name] then return true end
    local file = fontFileMap[name]
    if not file or fontPending[name] or not fsReady() then return false end
    fontPending[name] = true
    local ok, font = pcall(function()
        local path = "catware_fonts/" .. file
        if not isfile(path) then
            local url = "https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/fonts/" .. (file:gsub(" ", "%%20"))
            local data = game:HttpGet(url)
            if type(data) ~= "string" or #data < 100 then
                error("font download failed")
            end
            writefile(path, data)
        end
        local jsonPath = "catware_fonts/" .. (name:gsub("%s", "_")) .. ".json"
        writefile(jsonPath, HttpService:JSONEncode({
            name = name,
            faces = {{
                name = "Regular",
                weight = 400,
                style = "normal",
                assetId = getcustomasset(path),
            }},
        }))
        return Font.new(getcustomasset(jsonPath), Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    end)
    fontPending[name] = nil
    if ok and font then
        espModule.Fonts[name] = font
        return true
    end
    fontFailAt[name] = clock()
    return false
end

local function requestFont(name)
    if espModule.Fonts[name] or fontPending[name] or not fontFileMap[name] then return end
    local failed = fontFailAt[name]
    if failed and clock() - failed < 20 then return end
    if not fsReady() then return end
    task.spawn(loadOneFont, name)
end

local function getFont(name)
    local fonts = espModule.Fonts
    local f = fonts[name]
    if f then return f end
    requestFont(name)
    return fonts["Tahoma"] or fonts["Tahoma Modern"] or fonts["Tahoma 8px"] or fallbackFont
end

local function finishFonts()
    if not next(espModule.Fonts) then
        pcall(function()
            espModule.Fonts["Tahoma"] = Font.fromEnum(Enum.Font.Code)
            espModule.Fonts["Gojiberry Quibble"] = Font.fromEnum(Enum.Font.Code)
        end)
    end
    espModule.FontsReady = true
    for _, fn in ipairs(fontListeners) do task.spawn(fn) end
    tclear(fontListeners)
end

local function loadFonts()
    if not fsReady() then
        finishFonts()
        return
    end
    pcall(function()
        if typeof(makefolder) == "function" then
            if not (typeof(isfolder) == "function" and isfolder("catware_fonts")) then
                makefolder("catware_fonts")
            end
        end
    end)
    local s = espModule.Settings
    local order, seen = {}, {}
    local function push(n)
        if n and not seen[n] and fontFileMap[n] then
            seen[n] = true
            order[#order + 1] = n
        end
    end
    push(s.TextFont)
    push(s.FlagsFont)
    push(s.HealthFont)
    push("Tahoma")
    push("Gojiberry Quibble")
    for _, entry in ipairs(fontFiles) do push(entry[1]) end
    local left = #order
    for _, n in ipairs(order) do
        task.spawn(function()
            loadOneFont(n)
            left -= 1
            if left == 0 then finishFonts() end
        end)
    end
end

local function getTeamValue(plr)
    if not plr then return nil end
    local t = plr:GetAttribute("Team")
    if t ~= nil then return t end
    local char = plr.Character
    if char then
        t = char:GetAttribute("Team")
        if t ~= nil then return t end
    end
    if plr.Team then return plr.Team.Name end
    return nil
end

local SPECIAL_PLACE = 72920620366355

espModule.IsTeam = function(plr)
    if not plr or plr == LocalPlayer then return false end
    if game.PlaceId == SPECIAL_PLACE then
        local myTeam = getTeamValue(LocalPlayer)
        local theirTeam = getTeamValue(plr)
        if myTeam == nil or theirTeam == nil then return false end
        return myTeam == theirTeam
    end
    if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then return true end
    local character = plr.Character
    return character ~= nil and character:FindFirstChild("SquadBillboard") ~= nil
end

function espModule:SetTeamCheck(fn)
    if type(fn) == "function" then self.IsTeam = fn end
end

task.spawn(function()
    local ok, fn = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/personalvalor/Catware/refs/heads/main/TeamCheck.lua"))()
    end)
    if ok and type(fn) == "function" then
        local original = fn
        espModule.IsTeam = function(plr)
            if not plr or plr == LocalPlayer then return false end
            if game.PlaceId == SPECIAL_PLACE then
                local myTeam = getTeamValue(LocalPlayer)
                local theirTeam = getTeamValue(plr)
                if myTeam == nil or theirTeam == nil then return false end
                return myTeam == theirTeam
            end
            return original(plr)
        end
    end
end)

function espModule.HealthColor(t, high, mid, low)
    t = clamp(t, 0, 1)
    if t >= 0.5 then return mid:Lerp(high, (t - 0.5) * 2) end
    return low:Lerp(mid, t * 2)
end

local LAY = { flagLines = {} }
local LPOOL = {}
local FPOOL = {}
local LOFF = { Top = 0, Bottom = 0, Left = 0, Right = 0 }
local LROWS = { Left = 0, Right = 0 }
local LITEMS = {}
for i = 1, 5 do LITEMS[i] = { key = "", kind = "", side = "", slot = 0, n = 0 } end
local SIDE_OK = { Top = true, Bottom = true, Left = true, Right = true }
local LPAD = 2
local lstep = 12

local function pickSide(v, d)
    if SIDE_OK[v] then return v end
    return d
end

local function poolGet(key)
    local t = LPOOL[key]
    if not t then
        t = {}
        LPOOL[key] = t
    end
    return t
end

local function layBar(key, side, x, y, w, h)
    local gap = key == "health" and 3 or 4
    local r = poolGet(key)
    if side == "Left" then
        r.x, r.y, r.w, r.h, r.vertical = x - gap - 1 - LOFF.Left, y, 1, h, true
        LOFF.Left += gap + 1
    elseif side == "Right" then
        r.x, r.y, r.w, r.h, r.vertical = x + w + gap + LOFF.Right, y, 1, h, true
        LOFF.Right += gap + 1
    elseif side == "Top" then
        r.x, r.y, r.w, r.h, r.vertical = x, y - gap - 1 - LOFF.Top, w, 1, false
        LOFF.Top += gap + 1
    else
        r.x, r.y, r.w, r.h, r.vertical = x, y + h + gap + LOFF.Bottom, w, 1, false
        LOFF.Bottom += gap + 1
    end
    r.side = side
    LAY[key] = r
    return r.x, r.y
end

local function layText(r, side, x, y, w, h)
    if side == "Top" then
        r.x, r.y, r.ax, r.ay = x + w * 0.5, y - LPAD - LOFF.Top, 0.5, 1
        LOFF.Top += lstep
    elseif side == "Bottom" then
        r.x, r.y, r.ax, r.ay = x + w * 0.5, y + h + LPAD + LOFF.Bottom, 0.5, 0
        LOFF.Bottom += lstep
    elseif side == "Left" then
        r.x, r.y, r.ax, r.ay = x - LPAD - LOFF.Left, y - 1 + LROWS.Left * lstep, 1, 0
        LROWS.Left += 1
    else
        r.x, r.y, r.ax, r.ay = x + w + LPAD + LOFF.Right, y - 1 + LROWS.Right * lstep, 0, 0
        LROWS.Right += 1
    end
    return r
end

local function layHealth(side, cfg, x, y, w, h, size, ratio)
    local rx, ry = layBar("health", side, x, y, w, h)
    if cfg.HealthText then
        local r = poolGet("healthText")
        local ty = clamp(y + h - h * ratio - 5, y - 2, y + h - 10)
        local tx = clamp(x + w * ratio, x, x + w)
        if side == "Left" then
            r.x, r.y, r.ax, r.ay = rx - LPAD, ty, 1, 0
            LOFF.Left += 16
        elseif side == "Right" then
            r.x, r.y, r.ax, r.ay = rx + LPAD, ty, 0, 0
            LOFF.Right += 16
        elseif side == "Top" then
            r.x, r.y, r.ax, r.ay = tx, ry - LPAD, 0.5, 1
            LOFF.Top += size + 2
        else
            r.x, r.y, r.ax, r.ay = tx, ry + LPAD, 0.5, 0
            LOFF.Bottom += size + 2
        end
        LAY.healthText = r
    end
end

local function setItem(i, key, kind, side, slot, n)
    local it = LITEMS[i]
    it.key, it.kind, it.side, it.slot, it.n = key, kind, side, slot, n
end

function espModule.Layout(cfg, x, y, w, h, o)
    local size = o.size or 12
    local ratio = o.ratio or 1
    lstep = size

    LAY.health, LAY.armor, LAY.name, LAY.distance, LAY.tool, LAY.healthText = nil, nil, nil, nil, nil, nil
    LOFF.Top, LOFF.Bottom, LOFF.Left, LOFF.Right = 0, 0, 0, 0
    LROWS.Left, LROWS.Right = 0, 0

    local n = 0
    if o.health then
        n += 1
        setItem(n, "health", "healthbar", pickSide(cfg.HealthBarPos, "Left"), cfg.HealthBarSlot or 1, 1)
    end
    if o.armor then
        n += 1
        setItem(n, "armor", "bar", pickSide(cfg.ArmorBarPos, "Bottom"), cfg.ArmorBarSlot or 2, 2)
    end
    if cfg.Names then
        n += 1
        setItem(n, "name", "text", pickSide(cfg.NamePos, "Top"), cfg.NameSlot or 3, 3)
    end
    if cfg.Distance and not (cfg.Names and cfg.DistancePos == "Name") then
        n += 1
        setItem(n, "distance", "text", pickSide(cfg.DistancePos, "Right"), cfg.DistanceSlot or 4, 4)
    end
    if cfg.Tool then
        n += 1
        setItem(n, "tool", "text", pickSide(cfg.ToolPos, "Bottom"), cfg.ToolSlot or 5, 5)
    end

    for i = 2, n do
        local it = LITEMS[i]
        local j = i - 1
        while j >= 1 and (LITEMS[j].slot > it.slot or (LITEMS[j].slot == it.slot and LITEMS[j].n > it.n)) do
            LITEMS[j + 1] = LITEMS[j]
            j -= 1
        end
        LITEMS[j + 1] = it
    end

    for i = 1, n do
        local it = LITEMS[i]
        if it.kind == "healthbar" then
            layHealth(it.side, cfg, x, y, w, h, size, ratio)
        elseif it.kind == "bar" then
            layBar(it.key, it.side, x, y, w, h)
        elseif it.side ~= "Left" and it.side ~= "Right" then
            LAY[it.key] = layText(poolGet(it.key), it.side, x, y, w, h)
        end
    end
    for i = 1, n do
        local it = LITEMS[i]
        if it.kind == "text" and (it.side == "Left" or it.side == "Right") then
            LAY[it.key] = layText(poolGet(it.key), it.side, x, y, w, h)
        end
    end

    local fc = o.flagCount or 0
    local count = (cfg.Flags and fc > 0) and fc or 0
    local lines = LAY.flagLines
    for i = #lines, count + 1, -1 do lines[i] = nil end
    if count > 0 then
        local side = pickSide(cfg.FlagsPos, "Right")
        for i = 1, count do
            local r = FPOOL[i]
            if not r then
                r = {}
                FPOOL[i] = r
            end
            lines[i] = layText(r, side, x, y, w, h)
        end
    end

    return LAY
end

local SHADER_VERTEX = [[
struct VSOut {
	float4 pos : SV_POSITION;
	float2 uv  : TEXCOORD0;
};

VSOut main(uint id : SV_VertexID) {
	VSOut o;
	o.uv  = float2((id << 1) & 2, id & 2);
	o.pos = float4(o.uv * float2(2.0, -2.0) + float2(-1.0, 1.0), 0.0, 1.0);
	return o;
}
]]

local SHADER_PIXEL = [[
Texture2D    Scene  : register(t0);
SamplerState Linear : register(s0);

cbuffer Params : register(b0) {
	float  time;
	float2 resolution;
	float2 mouse;
};

cbuffer User : register(b1) {
	float3 g0_color1;
	float3 g0_color2;
	float3 g0_color3;
	float  g0_colorCount;
	float  g0_brightness;
	float  g0_contrast;
	float  g0_glowIntensity;
	float  g0_glowSpread;
	float  g0_speed;
	float  g0_scale;
	float  g0_style;
	float  g0_enabled;

	float3 g1_color1;
	float3 g1_color2;
	float3 g1_color3;
	float  g1_colorCount;
	float  g1_brightness;
	float  g1_contrast;
	float  g1_glowIntensity;
	float  g1_glowSpread;
	float  g1_speed;
	float  g1_scale;
	float  g1_style;
	float  g1_enabled;

	float3 g2_color1;
	float3 g2_color2;
	float3 g2_color3;
	float  g2_colorCount;
	float  g2_brightness;
	float  g2_contrast;
	float  g2_glowIntensity;
	float  g2_glowSpread;
	float  g2_speed;
	float  g2_scale;
	float  g2_style;
	float  g2_enabled;

	float  ui_x;
	float  ui_y;
	float  ui_w;
	float  ui_h;
	float  ui_on;
};

struct Grp {
	float3 c1;
	float3 c2;
	float3 c3;
	float cc;
	float br;
	float ct;
	float gi;
	float gs;
	float sp;
	float sc;
	float st;
	float en;
};

Grp getGrp(int i) {
	Grp g;
	if (i == 0) {
		g.c1 = g0_color1; g.c2 = g0_color2; g.c3 = g0_color3; g.cc = g0_colorCount;
		g.br = g0_brightness; g.ct = g0_contrast; g.gi = g0_glowIntensity; g.gs = g0_glowSpread;
		g.sp = g0_speed; g.sc = g0_scale; g.st = g0_style; g.en = g0_enabled;
	} else if (i == 1) {
		g.c1 = g1_color1; g.c2 = g1_color2; g.c3 = g1_color3; g.cc = g1_colorCount;
		g.br = g1_brightness; g.ct = g1_contrast; g.gi = g1_glowIntensity; g.gs = g1_glowSpread;
		g.sp = g1_speed; g.sc = g1_scale; g.st = g1_style; g.en = g1_enabled;
	} else {
		g.c1 = g2_color1; g.c2 = g2_color2; g.c3 = g2_color3; g.cc = g2_colorCount;
		g.br = g2_brightness; g.ct = g2_contrast; g.gi = g2_glowIntensity; g.gs = g2_glowSpread;
		g.sp = g2_speed; g.sc = g2_scale; g.st = g2_style; g.en = g2_enabled;
	}
	return g;
}

float hash21(float2 p) {
	p = frac(p * float2(127.1, 311.7));
	p += dot(p, p + 34.23);
	return frac(p.x * p.y);
}

float noise2D(float2 p) {
	float2 i = floor(p);
	float2 f = frac(p);
	f = f * f * (3.0 - 2.0 * f);
	float a = hash21(i);
	float b = hash21(i + float2(1.0, 0.0));
	float c = hash21(i + float2(0.0, 1.0));
	float d = hash21(i + float2(1.0, 1.0));
	return lerp(lerp(a, b, f.x), lerp(c, d, f.x), f.y);
}

float3 palette(float x, Grp g) {
	x = saturate(x);
	if (g.cc < 1.5) {
		return g.c1 * lerp(0.15, 1.0, x);
	}
	if (g.cc < 2.5) {
		return lerp(g.c1, g.c2, x);
	}
	float3 a = lerp(g.c1, g.c2, saturate(x * 2.0));
	return lerp(a, g.c3, saturate((x - 0.5) * 2.0));
}

float3 glowCol(Grp g) {
	if (g.cc > 2.5) return g.c3;
	if (g.cc > 1.5) return g.c2;
	return g.c1;
}

float keyAmount(float3 c, int k) {
	float3 key;
	if (k == 0) key = float3(1.0, 0.0, 1.0);
	else if (k == 1) key = float3(0.0, 1.0, 1.0);
	else key = float3(0.0, 0.0, 1.0);
	float3 d = abs(c - key);
	float err = max(d.x, max(d.y, d.z));
	return 1.0 - smoothstep(0.04, 0.12, err);
}

float3 cleanKey(float3 c, int k, float remove) {
	if (k == 2) {
		float e2 = max(c.b - max(c.r, c.g), 0.0);
		c.b -= e2 * remove;
		return c;
	}
	if (k == 0) {
		float e0 = max(min(c.r, c.b) - c.g, 0.0);
		c.r -= e0 * remove;
		c.b -= e0 * remove;
		return c;
	}
	float e1 = max(min(c.g, c.b) - c.r, 0.0);
	c.g -= e1 * remove;
	c.b -= e1 * remove;
	return c;
}

float2 patNeon(float2 p, float t) {
	float w = sin(p.x * 1.3 + p.y * 0.9 + t) * 0.5 + sin(p.y * 2.1 - p.x * 0.7 - t * 1.3) * 0.5;
	float v = 0.5 + 0.5 * sin((p.x * 0.8 + p.y * 1.2) * 2.0 + w * 1.6 - t * 0.8);
	return float2(smoothstep(0.0, 1.0, v), smoothstep(0.88, 1.0, v) * 0.3);
}

float2 patMatrix(float2 p, float t) {
	float2 q = float2(p.x * 2.0, p.y);
	float h = hash21(float2(floor(q.x), 7.0));
	float y = frac(q.y * 0.35 - t * (0.18 + h * 0.3) + h * 9.0);
	float fx = frac(q.x);
	float mask = smoothstep(0.0, 0.15, fx) * smoothstep(1.0, 0.85, fx);
	float v = saturate(pow(y, 2.2) * lerp(0.5, 1.0, mask) + 0.08);
	return float2(v, smoothstep(0.9, 1.0, y) * mask * 0.35);
}

float2 patFrost(float2 p, float t) {
	float a = noise2D(p * 0.9 + float2(t * 0.15, -t * 0.1));
	float b = noise2D(p * 2.1 - float2(t * 0.2, t * 0.12) + a * 1.5);
	float v = smoothstep(0.15, 0.85, a * 0.6 + b * 0.4);
	return float2(v, smoothstep(0.82, 0.98, b) * 0.25);
}

float2 patLava(float2 p, float t) {
	float n = noise2D(float2(p.x * 1.1, p.y * 1.4 - t * 0.9));
	float n2 = noise2D(p * 2.0 + float2(0.0, -t * 1.3) + n);
	float v = saturate(n * 0.65 + n2 * 0.45 + sin(p.y * 1.4 - t * 1.2) * 0.12 + 0.05);
	v = smoothstep(0.1, 0.9, v);
	return float2(v, smoothstep(0.8, 1.0, v) * 0.25);
}

float2 patCyber(float2 uv, float2 p, float t) {
	float sweep = smoothstep(0.0, 1.0, 0.5 + 0.5 * sin(p.y * 2.4 - t * 2.0));
	float lines = 0.5 + 0.5 * sin(uv.y * resolution.y * 0.9);
	float gx = smoothstep(0.93, 0.98, frac(p.x * 3.0));
	float gy = smoothstep(0.93, 0.98, frac(p.y * 3.0));
	float v = saturate(0.25 + sweep * 0.55 + lines * 0.1);
	return float2(v, max(gx, gy) * 0.2 + smoothstep(0.9, 1.0, sweep) * 0.2);
}

float2 patAurora(float2 p, float t) {
	float w = noise2D(p * 0.7 + float2(t * 0.2, -t * 0.1));
	float c = p.x * 1.2 + p.y * 0.7 + w * 2.0;
	float k1 = pow(saturate(1.0 - abs(sin(c * 3.14159 + t * 0.4))), 2.0);
	float k2 = pow(saturate(1.0 - abs(sin(c * 5.5 - t * 0.6))), 3.0);
	float v = saturate(k1 * 0.7 + k2 * 0.4 + w * 0.25);
	return float2(v, smoothstep(0.7, 1.0, k1 * k2) * 0.3);
}

float2 patPlasma(float2 p, float t) {
	float v = sin(p.x * 1.7 + t) + sin(p.y * 2.1 - t * 1.2) + sin((p.x + p.y) * 1.3 + t * 0.7);
	v += sin(length(p + float2(sin(t * 0.5), cos(t * 0.4)) * 2.0) * 2.5);
	return float2(smoothstep(0.0, 1.0, v * 0.125 + 0.5), 0.0);
}

float2 patGalaxy(float2 p, float t) {
	float a = noise2D(p * 0.8 + t * 0.05);
	float b = noise2D(p * 1.7 - t * 0.08 + a);
	float v = smoothstep(0.1, 0.9, a * 0.55 + b * 0.55);
	float s = hash21(floor(p * 14.0));
	float star = step(0.985, s) * (0.6 + 0.4 * sin(t * 3.0 + s * 50.0));
	return float2(v, star);
}

float2 patPulse(float2 p, float t) {
	float v = 0.5 + 0.5 * sin(t * 2.0 + p.y * 0.8);
	v = lerp(0.2, 1.0, smoothstep(0.0, 1.0, v));
	return float2(v, smoothstep(0.9, 1.0, v) * 0.2);
}

float2 patRipple(float2 p, float t) {
	float d = length(p - float2(2.5, 1.5));
	float v = 0.5 + 0.5 * sin(d * 3.0 - t * 2.5);
	return float2(smoothstep(0.0, 1.0, v), smoothstep(0.92, 1.0, v) * 0.25);
}

float2 patStripes(float2 p, float t) {
	float f = frac((p.x + p.y) * 0.9 - t * 0.35);
	float tri = 1.0 - abs(f * 2.0 - 1.0);
	return float2(smoothstep(0.0, 1.0, tri), smoothstep(0.92, 1.0, tri) * 0.2);
}

float2 patGradient(float2 p, float t) {
	float v = 0.5 + 0.5 * sin(p.y * 0.9 + p.x * 0.25 - t * 0.6);
	return float2(v, 0.0);
}

float2 patWaves(float2 p, float t) {
	float y = p.y + sin(p.x * 1.6 + t) * 0.35 + sin(p.x * 3.1 - t * 1.4) * 0.12;
	float v = 0.5 + 0.5 * sin(y * 3.2 - t * 0.9);
	return float2(smoothstep(0.0, 1.0, v), smoothstep(0.9, 1.0, v) * 0.25);
}

float2 patSolid(float2 p, float t) {
	return float2(0.7 + 0.2 * sin(p.y * 1.5 - t), 0.0);
}

float3 evalPattern(float2 uv, Grp g) {
	float t = time * g.sp;
	float aspect = resolution.x / max(resolution.y, 1.0);
	float2 p = uv * float2(aspect, 1.0) * g.sc;
	int st = (int)(g.st + 0.5);
	float2 r;
	if (st == 0) r = patNeon(p, t);
	else if (st == 1) r = patMatrix(p, t);
	else if (st == 2) r = patFrost(p, t);
	else if (st == 3) r = patLava(p, t);
	else if (st == 4) r = patCyber(uv, p, t);
	else if (st == 5) r = patAurora(p, t);
	else if (st == 6) r = patPlasma(p, t);
	else if (st == 7) r = patGalaxy(p, t);
	else if (st == 8) r = patPulse(p, t);
	else if (st == 9) r = patRipple(p, t);
	else if (st == 10) r = patStripes(p, t);
	else if (st == 11) r = patGradient(p, t);
	else if (st == 12) r = patWaves(p, t);
	else r = patSolid(p, t);
	float3 col = palette(r.x, g) + glowCol(g) * r.y;
	return pow(max(col, 0.0), g.ct) * g.br;
}

float4 main(float4 pos : SV_Position, float2 uv : TEXCOORD0) : SV_TARGET {
	float3 src = Scene.Sample(Linear, uv).rgb;
	if (ui_on > 0.5) {
		float px = uv.x * resolution.x;
		float py = uv.y * resolution.y;
		if (px >= ui_x && px <= ui_x + ui_w && py >= ui_y && py <= ui_y + ui_h) {
			return float4(src, 1.0);
		}
	}
	float3 outc = src;
	float2 texelBase = 1.0 / max(resolution, float2(1.0, 1.0));

	for (int k = 0; k < 3; k++) {
		Grp g = getGrp(k);
		if (g.en > 0.5) {
			float mk = keyAmount(src, k);
			float bl = 0.0;
			if (mk < 0.98 && g.gi > 0.001 && g.gs > 0.01) {
				float2 texel = g.gs * texelBase;
				[unroll]
				for (int i = 0; i < 8; i++) {
					float ang = float(i) * 0.7853982;
					float2 dir = float2(cos(ang), sin(ang));
					bl += keyAmount(Scene.SampleLevel(Linear, uv + dir * texel, 0).rgb, k);
				}
				bl *= 0.125;
			}
			outc = cleanKey(outc, k, saturate(mk));
			if (mk > 0.001) {
				outc = lerp(outc, evalPattern(uv, g), mk);
			}
			float edge = bl * (1.0 - mk) * smoothstep(0.15, 0.75, bl);
			outc += glowCol(g) * edge * (g.gi * 1.1);
		}
	}

	return float4(outc, 1.0);
}
]]

local view = {
    frame = 0, time = 0, dt = 0, fade = 1, angle = 0,
    x = 0, y = 0, z = 0, w = 0, h = 0, f = 0,
    r00 = 1, r01 = 0, r02 = 0, r10 = 0, r11 = 1, r12 = 0, r20 = 0, r21 = 0, r22 = 1,
}

local camX, camY, camZ = 0, 0, 0
local c00, c01, c02, c10, c11, c12, c20, c21, c22 = 1, 0, 0, 0, 1, 0, 0, 0, 1
local viewW, viewH, viewF = 0, 0, 0
local tan, rad = math.tan, math.rad

local function updateView(cam)
    local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = cam.CFrame:GetComponents()
    local size = cam.ViewportSize
    camX, camY, camZ = x, y, z
    c00, c01, c02, c10, c11, c12, c20, c21, c22 = r00, r01, r02, r10, r11, r12, r20, r21, r22
    viewW, viewH = size.X, size.Y
    viewF = size.Y * 0.5 / tan(rad(cam.FieldOfView) * 0.5)
    view.x, view.y, view.z = x, y, z
    view.r00, view.r01, view.r02 = r00, r01, r02
    view.r10, view.r11, view.r12 = r10, r11, r12
    view.r20, view.r21, view.r22 = r20, r21, r22
    view.w, view.h, view.f = viewW, viewH, viewF
end

local function project(px, py, pz)
    local cam = workspace.CurrentCamera
    if not cam then return nil end

    local pos, onScreen = cam:WorldToViewportPoint(Vector3.new(px, py, pz))
    if not onScreen or pos.Z < 0.05 then
        return nil
    end

    return pos.X, pos.Y, pos.Z
end

local Renderer = {}
Renderer.__index = Renderer

local textX = {
    [0] = Enum.TextXAlignment.Left, [0.5] = Enum.TextXAlignment.Center, [1] = Enum.TextXAlignment.Right,
}
local textY = {
    [0] = Enum.TextYAlignment.Top, [0.5] = Enum.TextYAlignment.Center, [1] = Enum.TextYAlignment.Bottom,
}

local BLACK = Color3.new(0, 0, 0)
local WHITE = Color3.new(1, 1, 1)
local CORNER_SIGNS = { {0, 0}, {1, 0}, {0, 1}, {1, 1} }
local ANCHOR_CENTER = v2(0.5, 0.5)
local ANCHOR_ORIGIN = v2(0, 0)
local ANCHOR_BL = v2(0, 1)
local UD_ZERO = UDim2.new()
local UD_BL = fromScale(0, 1)
local UD_FULL = fromScale(1, 1)
local ROUND = UDim.new(1, 0)
local cseq = ColorSequence.new
local cskp = ColorSequenceKeypoint.new

local function addStroke(parent, thickness)
    local stroke = newInstance("UIStroke")
    stroke.Color = BLACK
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.LineJoinMode = Enum.LineJoinMode.Miter
    stroke.Parent = parent
    return stroke
end

local function buildLine(root)
    local frame = newInstance("Frame")
    frame.AnchorPoint = ANCHOR_CENTER
    frame.BorderSizePixel = 0
    frame.ZIndex = 3
    frame.Visible = false
    frame.Parent = root
    local gradient = newInstance("UIGradient")
    gradient.Parent = frame
    return { f = frame, s = addStroke(frame), g = gradient, shown = false }
end

local function buildText(root)
    local label = newInstance("TextLabel")
    label.BackgroundTransparency = 1
    label.BorderSizePixel = 0
    label.AutomaticSize = Enum.AutomaticSize.XY
    label.Size = UD_ZERO
    label.TextColor3 = WHITE
    label.TextStrokeTransparency = 1
    label.ZIndex = 5
    label.Visible = false
    label.Parent = root
    local stroke = newInstance("UIStroke")
    stroke.Color = BLACK
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    stroke.Parent = label
    local gradient = newInstance("UIGradient")
    gradient.Parent = label
    return { root = label, grad = gradient, stroke = stroke }
end

local BAR_BG = rgb(15, 15, 15)

local function buildBar(root)
    local container = newInstance("Frame")
    container.BackgroundColor3 = BAR_BG
    container.BorderSizePixel = 0
    container.ZIndex = 3
    container.Visible = false
    container.Parent = root
    local stroke = addStroke(container)
    local fill = newInstance("Frame")
    fill.BackgroundColor3 = WHITE
    fill.BorderSizePixel = 0
    fill.ZIndex = 4
    fill.Parent = container
    local gradient = newInstance("UIGradient")
    gradient.Parent = fill
    return { root = container, stroke = stroke, fill = fill, grad = gradient }
end

local function buildFill(root)
    local frame = newInstance("Frame")
    frame.BackgroundColor3 = WHITE
    frame.BorderSizePixel = 0
    frame.ZIndex = 1
    frame.Visible = false
    frame.Parent = root
    local gradient = newInstance("UIGradient")
    gradient.Parent = frame
    return { root = frame, grad = gradient }
end

local GLOW_SLICE = Rect.new(21, 21, 79, 79)

local function buildGlow(root)
    local image = newInstance("ImageLabel")
    image.Image = "rbxassetid://110204605000367"
    image.ScaleType = Enum.ScaleType.Slice
    image.SliceCenter = GLOW_SLICE
    image.BackgroundTransparency = 1
    image.BorderSizePixel = 0
    image.ZIndex = 0
    image.Visible = false
    image.Parent = root
    return { root = image }
end

local function buildDot(root)
    local frame = newInstance("Frame")
    frame.AnchorPoint = ANCHOR_CENTER
    frame.BorderSizePixel = 0
    frame.ZIndex = 6
    frame.Visible = false
    frame.Parent = root
    local corner = newInstance("UICorner")
    corner.CornerRadius = ROUND
    corner.Parent = frame
    local stroke = newInstance("UIStroke")
    stroke.Color = BLACK
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Enabled = false
    stroke.Parent = frame
    return { root = frame, stroke = stroke }
end

local ONE_PX = fromOffset(1, 1)

local function createBar(parent, color, anchor, pos, z)
    local bar = newInstance("Frame")
    bar.Size = ONE_PX
    bar.Position = pos
    bar.AnchorPoint = anchor
    bar.BackgroundColor3 = color
    bar.BorderSizePixel = 0
    bar.ZIndex = z
    bar.Parent = parent
    return bar
end

local function ensureCorner(self)
    if self.cornerBox then return end
    local box = newInstance("Frame")
    box.Name = "CornerBox"
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false
    box.ZIndex = 2
    box.Parent = self.root
    local bars = {}
    for i = 1, 4 do
        local xs, ys = CORNER_SIGNS[i][1], CORNER_SIGNS[i][2]
        local anchor = v2(xs, ys)
        local pos = fromScale(xs, ys)
        bars[i] = {
            outlineH = createBar(box, BLACK, anchor, pos, 1),
            outlineV = createBar(box, BLACK, anchor, pos, 1),
            colorH = createBar(box, WHITE, anchor, pos, 2),
            colorV = createBar(box, WHITE, anchor, pos, 2),
            xs = xs, ys = ys,
        }
    end
    self.cornerBox, self.cornerBars = box, bars
end

local function ensureFull(self)
    if self.fullBox then return end
    local box = newInstance("Frame")
    box.Name = "FullBox"
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false
    box.ZIndex = 2
    box.Parent = self.root
    local bars = {}
    local layout = { {true, true}, {true, false}, {false, true}, {false, false} }
    for i = 1, 4 do
        bars[i] = {
            outline = createBar(box, BLACK, ANCHOR_ORIGIN, UD_ZERO, 1),
            color = createBar(box, WHITE, ANCHOR_ORIGIN, UD_ZERO, 2),
            isHorizontal = layout[i][1], isStart = layout[i][2],
        }
    end
    self.fullBox, self.fullBars = box, bars
end

function Renderer.new(parent)
    local root = newInstance("Frame")
    root.Name = "R"
    root.BackgroundTransparency = 1
    root.BorderSizePixel = 0
    root.Size = UD_FULL
    root.Parent = parent
    return setmetatable({
        root = root, lines = {}, keyed = {}, keyList = {},
        nLine = 0, hiLine = 0, frame = 0,
        cornerShown = false, fullShown = false, cornerFrame = -1, fullFrame = -1,
    }, Renderer)
end

function Renderer:Begin()
    self.frame += 1
    self.nLine = 0
end

function Renderer:End()
    local lines = self.lines
    for i = self.nLine + 1, self.hiLine do
        local l = lines[i]
        if l.shown then
            l.f.Visible = false
            l.shown = false
        end
    end
    self.hiLine = self.nLine

    local frame = self.frame
    if self.cornerShown and self.cornerFrame ~= frame then
        self.cornerBox.Visible = false
        self.cornerShown = false
    end
    if self.fullShown and self.fullFrame ~= frame then
        self.fullBox.Visible = false
        self.fullShown = false
    end

    local list = self.keyList
    for i = 1, #list do
        local k = list[i]
        if k.touched ~= frame and k.shown then
            k.root.Visible = false
            k.shown = false
        end
    end

    if frame % 600 == 0 then
        local keep = {}
        for i = 1, #list do
            local k = list[i]
            if frame - k.touched > 900 then
                self.keyed[k.key] = nil
                k.root:Destroy()
            else
                keep[#keep + 1] = k
            end
        end
        self.keyList = keep
    end
end

function Renderer:Clear()
    self:Begin()
    self:End()
end

function Renderer:Destroy()
    self.root:Destroy()
end

function Renderer:Keyed(key, build)
    local k = self.keyed[key]
    if not k then
        k = build(self.root)
        k.key = key
        k.shown = false
        self.keyed[key] = k
        self.keyList[#self.keyList + 1] = k
    end
    k.touched = self.frame
    if not k.shown then
        k.root.Visible = true
        k.shown = true
    end
    return k
end

function Renderer:Width(key)
    local t = self.keyed[key]
    if not t or not t.shown then return 0 end
    return t.root.TextBounds.X
end

function Renderer:Corner(x, y, w, h, thick, color, tr)
    ensureCorner(self)
    local box = self.cornerBox
    self.cornerFrame = self.frame
    if not self.cornerShown then
        box.Visible = true
        self.cornerShown = true
    end
    if self.cx ~= x or self.cy ~= y then
        self.cx, self.cy = x, y
        box.Position = fromOffset(x, y)
    end
    if self.cw ~= w or self.ch ~= h then
        self.cw, self.ch = w, h
        box.Size = fromOffset(w, h)
    end
    local maxAllowed = mmin(50, floor(mmin(w, h) * 0.42))
    local len = clamp(floor(mmin(w, h) * 0.3), 4, mmax(4, maxAllowed))
    if self.cLen == len and self.cThick == thick and self.cColor == color and self.cTr == tr then return end
    self.cLen, self.cThick, self.cColor, self.cTr = len, thick, color, tr
    for i = 1, 4 do
        local c = self.cornerBars[i]
        local sx, sy = c.xs, c.ys
        local ox = sx == 0 and -1 or 1
        local oy = sy == 0 and -1 or 1
        local base = fromScale(sx, sy)
        local obase = base + fromOffset(ox, oy)

        c.colorH.Size = fromOffset(len, thick)
        c.colorH.Position = base
        c.colorH.BackgroundColor3 = color
        c.colorH.BackgroundTransparency = tr

        c.outlineH.Size = fromOffset(len + 2, thick + 2)
        c.outlineH.Position = obase
        c.outlineH.BackgroundTransparency = tr

        c.colorV.Size = fromOffset(thick, len)
        c.colorV.Position = base
        c.colorV.BackgroundColor3 = color
        c.colorV.BackgroundTransparency = tr

        c.outlineV.Size = fromOffset(thick + 2, len + 2)
        c.outlineV.Position = obase
        c.outlineV.BackgroundTransparency = tr
    end
end

function Renderer:Full(x, y, w, h, thick, color, tr)
    ensureFull(self)
    local box = self.fullBox
    self.fullFrame = self.frame
    if not self.fullShown then
        box.Visible = true
        self.fullShown = true
    end
    if self.fx ~= x or self.fy ~= y then
        self.fx, self.fy = x, y
        box.Position = fromOffset(x, y)
    end
    if self.fw == w and self.fh == h and self.fThick == thick and self.fColor == color and self.fTr == tr then return end
    self.fw, self.fh, self.fThick, self.fColor, self.fTr = w, h, thick, color, tr
    box.Size = fromOffset(w, h)
    for i = 1, 4 do
        local b = self.fullBars[i]
        if b.isHorizontal then
            b.color.Size = fromOffset(w, thick)
            b.color.Position = fromOffset(0, b.isStart and 0 or (h - thick))
            b.outline.Size = fromOffset(w + 2, thick + 2)
            b.outline.Position = fromOffset(-1, b.isStart and -1 or (h - thick - 1))
        else
            b.color.Size = fromOffset(thick, h)
            b.color.Position = fromOffset(b.isStart and 0 or (w - thick), 0)
            b.outline.Size = fromOffset(thick + 2, h + 2)
            b.outline.Position = fromOffset(b.isStart and -1 or (w - thick - 1), -1)
        end
        b.color.BackgroundColor3 = color
        b.color.BackgroundTransparency = tr
        b.outline.BackgroundTransparency = tr
    end
end

function Renderer:Line(ax, ay, bx, by, thickness, c1, c2, tr, outline)
    local n = self.nLine + 1
    self.nLine = n
    local l = self.lines[n]
    if not l then
        l = buildLine(self.root)
        self.lines[n] = l
    end
    local dx, dy = bx - ax, by - ay
    local len = mmax(sqrt(dx * dx + dy * dy), 1)
    local cx, cy = (ax + bx) * 0.5, (ay + by) * 0.5
    local rot = deg(atan2(dy, dx))
    local f = l.f
    if l.cx ~= cx or l.cy ~= cy then
        l.cx, l.cy = cx, cy
        f.Position = fromOffset(cx, cy)
    end
    if l.len ~= len or l.th ~= thickness then
        l.len, l.th = len, thickness
        f.Size = fromOffset(len, thickness)
    end
    if l.rot ~= rot then
        l.rot = rot
        f.Rotation = rot
    end
    if l.c1 ~= c1 or l.c2 ~= c2 then
        l.c1, l.c2 = c1, c2
        if c1 == c2 then
            f.BackgroundColor3 = c1
            l.g.Enabled = false
        else
            f.BackgroundColor3 = WHITE
            l.g.Color = cseq(c1, c2)
            l.g.Enabled = true
        end
    end
    if l.tr ~= tr then
        l.tr = tr
        f.BackgroundTransparency = tr
        l.s.Transparency = tr
    end
    local want = outline ~= false
    if l.outlineOn ~= want then
        l.outlineOn = want
        l.s.Enabled = want
    end
    if not l.shown then
        l.shown = true
        f.Visible = true
    end
end

function Renderer:Text(key, text, x, y, ax, ay, font, size, c1, c2, tr, animated)
    local t = self:Keyed(key, buildText)
    local label = t.root
    if t.text ~= text then
        t.text = text
        label.Text = text
    end
    if t.x ~= x or t.y ~= y or t.ax ~= ax or t.ay ~= ay then
        if t.ax ~= ax or t.ay ~= ay then
            label.AnchorPoint = v2(ax, ay)
            label.TextXAlignment = textX[ax] or Enum.TextXAlignment.Center
            label.TextYAlignment = textY[ay] or Enum.TextYAlignment.Center
        end
        t.x, t.y, t.ax, t.ay = x, y, ax, ay
        label.Position = fromOffset(x, y)
    end
    if t.font ~= font or t.size ~= size then
        t.font, t.size = font, size
        label.FontFace = font
        label.TextSize = size
    end
    if t.c1 ~= c1 or t.c2 ~= c2 then
        t.c1, t.c2 = c1, c2
        if c1 == c2 then
            label.TextColor3 = c1
            t.grad.Enabled = false
        else
            label.TextColor3 = WHITE
            t.grad.Color = cseq(c1, c2)
            t.grad.Enabled = true
        end
    end
    if t.grad.Enabled then
        local rot = animated and view.angle or 0
        if t.rot ~= rot then
            t.rot = rot
            t.grad.Rotation = rot
        end
    end
    if t.tr ~= tr then
        t.tr = tr
        label.TextTransparency = tr
        if t.stroke then t.stroke.Transparency = tr end
    end
end

function Renderer:Bar(key, x, y, w, h, fillRatio, vertical, high, mid, low, tr)
    local b = self:Keyed(key, buildBar)
    local root, fill = b.root, b.fill
    if b.x ~= x or b.y ~= y then
        b.x, b.y = x, y
        root.Position = fromOffset(x, y)
    end
    if b.w ~= w or b.h ~= h then
        b.w, b.h = w, h
        root.Size = fromOffset(w, h)
    end
    fillRatio = clamp(fillRatio, 0, 1)
    if b.vertical ~= vertical then
        b.vertical = vertical
        b.ratio = nil
        if vertical then
            fill.AnchorPoint = ANCHOR_BL
            fill.Position = UD_BL
            b.grad.Rotation = 90
        else
            fill.AnchorPoint = ANCHOR_ORIGIN
            fill.Position = UD_ZERO
            b.grad.Rotation = 0
        end
    end
    if b.ratio ~= fillRatio then
        b.ratio = fillRatio
        fill.Size = vertical and fromScale(1, fillRatio) or fromScale(fillRatio, 1)
    end
    if b.high ~= high or b.mid ~= mid or b.low ~= low then
        b.high, b.mid, b.low = high, mid, low
        b.grad.Color = cseq({
            cskp(0, high),
            cskp(0.5, mid),
            cskp(1, low),
        })
    end
    if b.tr ~= tr then
        b.tr = tr
        root.BackgroundTransparency = tr
        fill.BackgroundTransparency = tr
        b.stroke.Transparency = tr
    end
end

function Renderer:Fill(key, x, y, w, h, c1, c2, rot, tr)
    local f = self:Keyed(key, buildFill)
    local root = f.root
    if f.x ~= x or f.y ~= y then
        f.x, f.y = x, y
        root.Position = fromOffset(x, y)
    end
    if f.w ~= w or f.h ~= h then
        f.w, f.h = w, h
        root.Size = fromOffset(w, h)
    end
    if f.c1 ~= c1 or f.c2 ~= c2 then
        f.c1, f.c2 = c1, c2
        f.grad.Color = cseq(c1, c2)
    end
    rot = rot or 0
    if f.rot ~= rot then
        f.rot = rot
        f.grad.Rotation = rot
    end
    if f.tr ~= tr then
        f.tr = tr
        root.BackgroundTransparency = tr
    end
end

function Renderer:Glow(key, x, y, w, h, color, tr)
    local g = self:Keyed(key, buildGlow)
    local root = g.root
    if g.x ~= x or g.y ~= y then
        g.x, g.y = x, y
        root.Position = fromOffset(x - 21, y - 21)
    end
    if g.w ~= w or g.h ~= h then
        g.w, g.h = w, h
        root.Size = fromOffset(w + 42, h + 41)
    end
    if g.color ~= color then
        g.color = color
        root.ImageColor3 = color
    end
    if g.tr ~= tr then
        g.tr = tr
        root.ImageTransparency = tr
    end
end

function Renderer:Dot(key, x, y, size, color, outlineTh, tr)
    local d = self:Keyed(key, buildDot)
    local root = d.root
    if d.x ~= x or d.y ~= y then
        d.x, d.y = x, y
        root.Position = fromOffset(x, y)
    end
    if d.size ~= size then
        d.size = size
        root.Size = fromOffset(size, size)
    end
    if d.color ~= color then
        d.color = color
        root.BackgroundColor3 = color
    end
    if outlineTh and outlineTh > 0 then
        if not d.strokeOn then
            d.strokeOn = true
            d.stroke.Enabled = true
        end
        if d.outline ~= outlineTh then
            d.outline = outlineTh
            d.stroke.Thickness = outlineTh
        end
        if d.strokeTr ~= tr then
            d.strokeTr = tr
            d.stroke.Transparency = tr
        end
    elseif d.strokeOn then
        d.strokeOn = false
        d.stroke.Enabled = false
    end
    if d.tr ~= tr then
        d.tr = tr
        root.BackgroundTransparency = tr
    end
end

local state = {
    running = false,
    gui = nil,
    connections = {},
    players = {},
    records = {},
    itemMeta = {},
    itemRenderer = nil,
    vms = {},
    vmAt = -1,
    last = 0,
    hadEntities = false,
    hadItems = false,
    dead = false,
    shader = nil,
    shaderParams = {},
    shaderRetry = 0,
    pushAt = 0,
    useSig = -1,
    teamVal = {},
    teamAt = {},
    use = { [0] = false, [1] = false, [2] = false },
}

local PN = {}
for k = 0, 2 do
    local p = "g" .. k .. "_"
    PN[k] = {
        c1 = p .. "color1", c2 = p .. "color2", c3 = p .. "color3", cc = p .. "colorCount",
        br = p .. "brightness", ct = p .. "contrast", gi = p .. "glowIntensity", gs = p .. "glowSpread",
        sp = p .. "speed", sc = p .. "scale", st = p .. "style", en = p .. "enabled",
    }
end

local function put(name, v)
    local cache = state.shaderParams
    if cache[name] ~= v then
        cache[name] = v
        local sh = state.shader
        if sh then pcall(sh.Set, sh, name, v) end
    end
end

local function getMenuBounds()
    local st = envTable.Stardust
    if type(st) == "table" and st.win and st.win.root then
        local root = st.win.root
        if root.Visible then
            local pos = root.AbsolutePosition
            local size = root.AbsoluteSize
            return pos.X, pos.Y, size.X, size.Y
        end
    end
    return nil
end

local function pushSettings()
    if not state.shader then return end
    local s = espModule.Settings
    for k = 0, 2 do
        local g = (k == 0 and s.Enemy) or (k == 1 and s.Teammate) or s.AI
        local c = g.ChamsSettings
        local design = CHAMS_DESIGNS[c.Design] or CHAMS_DESIGNS.Neon
        local n = PN[k]
        put(n.c1, c.Color1)
        put(n.c2, c.Color2)
        put(n.c3, c.Color3)
        put(n.cc, clamp(floor((c.ColorCount or 3) + 0.5), 1, 3))
        put(n.br, c.Brightness)
        put(n.ct, c.Contrast)
        put(n.gi, c.Bloom)
        put(n.gs, c.BloomSpread)
        put(n.sp, c.Speed)
        put(n.sc, c.Scale)
        put(n.st, design.Style)
        put(n.en, state.use[k] and 1 or 0)
    end
end

local function pushBounds()
    if not state.shader then return end
    local mx, my, mw, mh = getMenuBounds()
    if mx then
        put("ui_on", 1)
        put("ui_x", mx)
        put("ui_y", my)
        put("ui_w", mw)
        put("ui_h", mh)
    else
        put("ui_on", 0)
    end
end

local function ensureShader()
    if state.shader then return end
    if clock() < state.shaderRetry then return end
    if typeof(Drawing) ~= "table" and typeof(Drawing) ~= "userdata" then
        state.shaderRetry = clock() + 3
        return
    end
    local ok, shader = pcall(function()
        return Drawing.new("Shader")
    end)
    if not ok or not shader then
        state.shaderRetry = clock() + 3
        return
    end
    local built = pcall(function()
        shader.Vertex = SHADER_VERTEX
        shader.Pixel = SHADER_PIXEL
        shader:Create()
    end)
    if not built then
        pcall(function() shader:Remove() end)
        state.shaderRetry = clock() + 3
        return
    end
    state.shader = shader
    state.shaderParams = {}
    pushSettings()
    pushBounds()
end

local function destroyShader()
    if state.shader then
        pcall(function() state.shader:Remove() end)
        state.shader = nil
        state.shaderParams = {}
    end
end

local function restoreTransparency(rec)
    if rec.origTrans then
        for obj, val in pairs(rec.origTrans) do
            if obj and obj.Parent then
                if obj:IsA("BasePart") then
                    obj.LocalTransparencyModifier = val
                else
                    obj.Transparency = val
                end
            end
        end
        rec.origTrans = nil
    end
    rec.trList = nil
end

local function offGlow(rec)
    if rec.glowHl and rec.ghOn then
        rec.glowHl.Enabled = false
        rec.ghOn = false
    end
end

local function clearAdornments(rec)
    offGlow(rec)
    if rec.adornments then
        for _, entry in pairs(rec.adornments) do
            if entry.fill then entry.fill:Destroy() end
            if entry.glow then
                for _, g in ipairs(entry.glow) do g:Destroy() end
            end
        end
        rec.adornments = nil
        rec.adornChar = nil
    end
    restoreTransparency(rec)
end

local function offHl(rec)
    if rec.hl and rec.hlOn then
        rec.hl.Enabled = false
        rec.hlOn = false
    end
end

local function offFill(rec)
    if rec.fillHl and rec.fillOn then
        rec.fillHl.Enabled = false
        rec.fillOn = false
    end
end

local function hideRecord(rec)
    if rec.hidden then return end
    rec.hidden = true
    if rec.renderer then rec.renderer:Clear() end
    offHl(rec)
    offFill(rec)
    offGlow(rec)
    if rec.adornments then
        for _, entry in pairs(rec.adornments) do
            if entry.fill then entry.fill.Visible = false end
            if entry.glow then
                for _, g in ipairs(entry.glow) do g.Visible = false end
            end
        end
        rec.adDirty = true
    end
    restoreTransparency(rec)
end

local function dropRecord(entity)
    local rec = state.records[entity]
    if not rec then return end
    if rec.renderer then rec.renderer:Destroy() end
    if rec.hl then rec.hl:Destroy() end
    if rec.fillHl then rec.fillHl:Destroy() end
    if rec.glowHl then rec.glowHl:Destroy() end
    clearAdornments(rec)
    state.records[entity] = nil
end

local function newRecord(entity)
    return {
        entity = entity,
        renderer = Renderer.new(state.gui),
        character = nil,
        humanoid = nil,
        root = nil,
        parts = nil,
        adParts = nil,
        bones = nil,
        headPart = nil,
        isR15 = false,
        scanned = -1,
        owner = nil,
        ownerChar = nil,
        ownerHum = nil,
        lastPos = nil,
        verdict = nil,
        verdictAt = 0,
        searchAt = -1,
        born = 0,
        touched = 0,
        seen = 0,
        hidden = true,
        lastName = nil,
        deathTime = 0,
        infoAt = -10,
        raidAt = -10,
        raidSkip = false,
        humAt = -10,
        trAt = -10,
        trApply = -10,
        adDirty = true,
        mVal = -1,
        mStr = "",
        d = {},
        box = { x = 0, y = 0, w = 0, h = 0 },
        hl = nil,
        fillHl = nil,
    }
end

local R15 = {"HumanoidRootPart","Head","UpperTorso","LowerTorso","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot","LeftUpperArm","LeftLowerArm","LeftHand","RightUpperArm","RightLowerArm","RightHand"}
local R6 = {"HumanoidRootPart","Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg"}
local VM_PARTS = {"head","torso","arm1","arm2","leg1","leg2","shoulder1","shoulder2","hip1","hip2"}

local R15_BONES = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"LowerTorso", "LeftUpperLeg"}, {"LowerTorso", "RightUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"UpperTorso", "LeftUpperArm"}, {"UpperTorso", "RightUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"}, {"RightUpperArm", "RightLowerArm"},
}
local R6_BONES = {
    {"Head", "Torso"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
}

local function collectParts(character, names, out)
    for i = 1, #names do
        local p = character:FindFirstChild(names[i])
        if p then
            if p:IsA("BasePart") and p.Transparency < 0.95 then
                out[#out + 1] = p
            else
                for _, d in ipairs(p:GetDescendants()) do
                    if d:IsA("BasePart") and d.Transparency < 0.95 and d.Name ~= "Base" then
                        out[#out + 1] = d
                    end
                end
            end
        end
    end
end

local function collectAnyParts(character, out)
    for _, d in ipairs(character:GetDescendants()) do
        if d:IsA("BasePart") and d.Transparency < 0.95 and d.Name ~= "Base" and not d:FindFirstAncestorOfClass("Accessory") then
            out[#out + 1] = d
            if #out >= 40 then break end
        end
    end
end

local function buildBones(rec, list)
    if #list == 0 then
        rec.boneParts, rec.boneIdx = nil, nil
        return
    end
    local parts, idx, map = {}, {}, {}
    for i = 1, #list do
        local a, b = list[i][1], list[i][2]
        if not map[a] then
            parts[#parts + 1] = a
            map[a] = #parts
        end
        if not map[b] then
            parts[#parts + 1] = b
            map[b] = #parts
        end
        idx[#idx + 1] = map[a]
        idx[#idx + 1] = map[b]
    end
    rec.boneParts, rec.boneIdx = parts, idx
end

local function bindCharacter(rec, character, humanoid, isVM)
    rec.character = character
    rec.humanoid = humanoid
    rec.parts = {}
    rec.boneParts, rec.boneIdx = nil, nil
    rec.isR15 = false
    local pl = {}
    if isVM then
        collectParts(character, VM_PARTS, rec.parts)
        if #rec.parts == 0 then
            collectAnyParts(character, rec.parts)
        end
        local torso = character:FindFirstChild("torso")
        if torso then
            rec.root = torso:IsA("BasePart") and torso or torso:FindFirstChildWhichIsA("BasePart", true)
        end
        if not rec.root then
            rec.root = character:FindFirstChildWhichIsA("BasePart", true)
        end
        local function vmPart(name)
            local p = character:FindFirstChild(name)
            if not p then return nil end
            if p:IsA("BasePart") then return p end
            return p:FindFirstChildWhichIsA("BasePart", true)
        end
        local head, torsoPart = vmPart("head"), vmPart("torso")
        if torsoPart then
            local others = { head, vmPart("arm1"), vmPart("arm2"), vmPart("leg1"), vmPart("leg2") }
            for i = 1, 5 do
                if others[i] then pl[#pl + 1] = { torsoPart, others[i] } end
            end
        end
    else
        rec.isR15 = character:FindFirstChild("UpperTorso") ~= nil
        local names = rec.isR15 and R15 or R6
        for i = 1, #names do
            local p = character:FindFirstChild(names[i])
            if p and p:IsA("BasePart") then rec.parts[#rec.parts + 1] = p end
        end
        if #rec.parts == 0 then
            collectAnyParts(character, rec.parts)
        end
        rec.root = character:FindFirstChild("HumanoidRootPart")
            or character:FindFirstChild("Torso")
            or character:FindFirstChild("UpperTorso")
            or character.PrimaryPart
            or character:FindFirstChildWhichIsA("BasePart", true)
        local list = rec.isR15 and R15_BONES or R6_BONES
        for i = 1, #list do
            local a = character:FindFirstChild(list[i][1])
            local b = character:FindFirstChild(list[i][2])
            if a and b and a:IsA("BasePart") and b:IsA("BasePart") then
                pl[#pl + 1] = { a, b }
            end
        end
    end
    buildBones(rec, pl)

    rec.adParts = {}
    for i = 1, #rec.parts do
        local p = rec.parts[i]
        if p.Name ~= "HumanoidRootPart" then rec.adParts[#rec.adParts + 1] = p end
    end

    local head = character:FindFirstChild("Head") or character:FindFirstChild("head")
    if head then
        rec.headPart = head:IsA("BasePart") and head or head:FindFirstChildWhichIsA("BasePart", true)
    else
        rec.headPart = nil
    end
    rec.scanned = view.time
end

local function rescan(rec, humanoid, isVM)
    bindCharacter(rec, rec.character, humanoid or rec.humanoid, isVM)
end

local function playerName(rec, player, nameType)
    if nameType == "Username" then return player.Name end
    if nameType == "Both" then return player.DisplayName .. " (@" .. player.Name .. ")" end
    return player.DisplayName
end

local function currentArmor(rec, character, options)
    if options and type(options.Armor) == "function" then
        local ok, v = pcall(options.Armor, character)
        if ok and type(v) == "number" then return v end
    end
    local armor = character:FindFirstChild("Armor")
    if armor and armor:IsA("NumberValue") and armor.Value > 0 then return armor.Value end
    return 100
end

local function currentTool(rec, character, options)
    if options and type(options.Tool) == "function" then
        local ok, v = pcall(options.Tool, character)
        if ok and v then return tostring(v) end
    end
    local tool = character:FindFirstChildOfClass("Tool")
    return tool and tool.Name or "None"
end

local function updateFlags(rec, entity, character, humanoid, cfg)
    local d = rec.d
    local flags = d.flags
    if not flags then
        flags = {}
        d.flags = flags
    else
        tclear(flags)
    end
    if not cfg.Flags then return end
    local selected = cfg.SelectedFlags
    if humanoid then
        if tfind(selected, "Walking") and humanoid.MoveDirection.Magnitude > 0 then
            flags[#flags + 1] = "Walking"
        end
        local ok, hs = pcall(humanoid.GetState, humanoid)
        if ok then
            if tfind(selected, "Jumping") and (hs == Enum.HumanoidStateType.Freefall or hs == Enum.HumanoidStateType.Jumping) then
                flags[#flags + 1] = "Jumping"
            end
            if tfind(selected, "Swimming") and hs == Enum.HumanoidStateType.Swimming then
                flags[#flags + 1] = "Swimming"
            end
        end
    end
    for name, custom in pairs(espModule.CustomFlags) do
        if tfind(selected, name) then
            local ok, res = pcall(custom.Func, entity, character, humanoid)
            if ok and res then flags[#flags + 1] = name end
        end
    end
end

local SX = {-1, 1, -1, 1, -1, 1, -1, 1}
local SY = {-1, -1, 1, 1, -1, -1, 1, 1}
local SZ = {-1, -1, -1, -1, 1, 1, 1, 1}
local EDGES = {{1,2},{2,4},{4,3},{3,1},{5,6},{6,8},{8,7},{7,5},{1,5},{2,6},{3,7},{4,8}}
local BX, BY, BOK = {}, {}, {}
local BPX, BPY, BPOK = {}, {}, {}
local FLAGK = {}

local function dynamicBounds(parts)
    local x1, y1, x2, y2 = huge, huge, -huge, -huge
    local any = false
    local hw, hh, f = viewW * 0.5, viewH * 0.5, viewF
    local cc00, cc01, cc02, cc10, cc11, cc12, cc20, cc21, cc22 = c00, c01, c02, c10, c11, c12, c20, c21, c22
    local cx0, cy0, cz0 = camX, camY, camZ
    for i = 1, #parts do
        local p = parts[i]
        if p.Parent then
            local px, py, pz, r00, r01, r02, r10, r11, r12, r20, r21, r22 = p.CFrame:GetComponents()
            local size = p.Size
            local hx, hy, hz = size.X * 0.5, size.Y * 0.5, size.Z * 0.5
            local ox, oy, oz = px - cx0, py - cy0, pz - cz0
            local cx = ox * cc00 + oy * cc10 + oz * cc20
            local cy = ox * cc01 + oy * cc11 + oz * cc21
            local cd = -(ox * cc02 + oy * cc12 + oz * cc22)

            local ax1 = (r00 * cc00 + r10 * cc10 + r20 * cc20) * hx
            local ay1 = (r00 * cc01 + r10 * cc11 + r20 * cc21) * hx
            local ad1 = -(r00 * cc02 + r10 * cc12 + r20 * cc22) * hx
            local ax2 = (r01 * cc00 + r11 * cc10 + r21 * cc20) * hy
            local ay2 = (r01 * cc01 + r11 * cc11 + r21 * cc21) * hy
            local ad2 = -(r01 * cc02 + r11 * cc12 + r21 * cc22) * hy
            local ax3 = (r02 * cc00 + r12 * cc10 + r22 * cc20) * hz
            local ay3 = (r02 * cc01 + r12 * cc11 + r22 * cc21) * hz
            local ad3 = -(r02 * cc02 + r12 * cc12 + r22 * cc22) * hz

            for s = 1, 8 do
                local s1, s2, s3 = SX[s], SY[s], SZ[s]
                local depth = cd + s1 * ad1 + s2 * ad2 + s3 * ad3
                if depth >= 0.05 then
                    local scale = f / depth
                    local sx = hw + (cx + s1 * ax1 + s2 * ax2 + s3 * ax3) * scale
                    local sy = hh - (cy + s1 * ay1 + s2 * ay2 + s3 * ay3) * scale
                    any = true
                    if sx < x1 then x1 = sx end
                    if sy < y1 then y1 = sy end
                    if sx > x2 then x2 = sx end
                    if sy > y2 then y2 = sy end
                end
            end
        end
    end
    if not any then return nil end
    return x1, y1, x2, y2
end

local function staticBounds(rec, parts)
    local root = rec.root
    if not root or not root.Parent then return nil end
    local minY, maxY = huge, -huge
    for i = 1, #parts do
        local p = parts[i]
        if p.Parent then
            local cf, size = p.CFrame, p.Size
            local ext = abs(cf.RightVector.Y) * size.X * 0.5
                + abs(cf.UpVector.Y) * size.Y * 0.5
                + abs(cf.LookVector.Y) * size.Z * 0.5
            local py = cf.Position.Y
            if py - ext < minY then minY = py - ext end
            if py + ext > maxY then maxY = py + ext end
        end
    end
    if minY == huge then return nil end
    local rp = root.Position
    local tx, ty = project(rp.X, maxY, rp.Z)
    local bx, by = project(rp.X, minY, rp.Z)
    if not tx or not bx then return nil end
    local h = by - ty
    if h < 2 then return nil end
    local w = h * 0.55
    local cx = (tx + bx) * 0.5
    return cx - w * 0.5, ty, cx + w * 0.5, by
end

local function box3D(rec, now)
    local character, root = rec.character, rec.root
    if not character or not root or not root.Parent then return false end
    if not rec.bbOff or rec.bbChar ~= character or now - rec.bbAt > 1 then
        local ok, cf, size = pcall(function() return character:GetBoundingBox() end)
        if not ok or not cf then return false end
        rec.bbSize = size
        rec.bbOff = root.CFrame:ToObjectSpace(cf)
        rec.bbAt = now
        rec.bbChar = character
    end
    local cf = root.CFrame * rec.bbOff
    local size = rec.bbSize
    local hx, hy, hz = size.X * 0.5, size.Y * 0.5, size.Z * 0.5
    for s = 1, 8 do
        local w = cf * v3(hx * SX[s], hy * SY[s], hz * SZ[s])
        local sx, sy = project(w.X, w.Y, w.Z)
        if sx then
            BX[s], BY[s], BOK[s] = sx, sy, true
        else
            BOK[s] = false
        end
    end
    return true
end

local HIDE_TR = 1
local GLOW_LAYERS = 4
local ROT_X = CFrame.Angles(math.rad(90), 0, 0)

local function makeAdornEntry(part)
    local lname = part.Name:lower()
    local isHead = lname == "head" or (part.Parent and part.Parent.Name:lower() == "head")
    local className = isHead and "CylinderHandleAdornment" or "BoxHandleAdornment"

    local glow = {}
    for i = 1, GLOW_LAYERS do
        local g = newInstance(className)
        g.Adornee = part
        g.AlwaysOnTop = true
        g.ZIndex = GLOW_LAYERS - i + 1
        if isHead then g.CFrame = ROT_X end
        g.Parent = state.gui
        glow[i] = g
    end

    local fill = newInstance(className)
    fill.Adornee = part
    fill.AlwaysOnTop = true
    fill.ZIndex = GLOW_LAYERS + 1
    if isHead then fill.CFrame = ROT_X end
    fill.Parent = state.gui

    return { fill = fill, glow = glow, isHead = isHead, sz = nil, seen = 0 }
end

local function updateAdornEntry(entry, part, c1, c2, adTr, glowOpacity, tr)
    local fill = entry.fill
    local sz = part.Size
    entry.sz = sz
    local vis = 1 - tr
    if entry.isHead then
        local rad = mmax(sz.X, sz.Z) * 0.52
        local h = sz.Y * 1.05
        fill.Radius = rad
        fill.InnerRadius = 0
        fill.Height = h
        for i = 1, GLOW_LAYERS do
            local g = entry.glow[i]
            local pad = i * 0.055
            local layerScale = (GLOW_LAYERS - i + 1) / GLOW_LAYERS
            g.Radius = rad + pad
            g.InnerRadius = 0
            g.Height = h + pad * 2
            g.Color3 = c2
            g.Transparency = 1 - (glowOpacity * layerScale * vis)
            g.Visible = true
        end
    else
        fill.Size = sz
        for i = 1, GLOW_LAYERS do
            local g = entry.glow[i]
            local pad = i * 0.11
            local layerScale = (GLOW_LAYERS - i + 1) / GLOW_LAYERS
            g.Size = sz + v3(pad, pad, pad)
            g.Color3 = c2
            g.Transparency = 1 - (glowOpacity * layerScale * vis)
            g.Visible = true
        end
    end
    fill.Color3 = c1
    fill.Transparency = adTr
    fill.Visible = true
end

local function refreshTrList(rec)
    local parts, decals = {}, {}
    local char = rec.character
    if char then
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("BasePart") then
                parts[#parts + 1] = obj
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                decals[#decals + 1] = obj
            end
        end
    end
    rec.trList = { parts = parts, decals = decals }
    rec.trAt = view.time
    rec.trApply = -10
end

local function applyTransparency(rec)
    rec.trApply = view.time
    local list = rec.trList
    if not list then return end
    local orig = rec.origTrans
    if not orig then
        orig = {}
        rec.origTrans = orig
    end
    local parts, decals = list.parts, list.decals
    for i = 1, #parts do
        local obj = parts[i]
        local cur = obj.LocalTransparencyModifier
        if cur < 0.98 then
            if orig[obj] == nil then orig[obj] = cur end
            obj.LocalTransparencyModifier = HIDE_TR
        end
    end
    for i = 1, #decals do
        local obj = decals[i]
        local cur = obj.Transparency
        if cur ~= 1 then
            if orig[obj] == nil then orig[obj] = cur end
            obj.Transparency = 1
        end
    end
end

local function drawAdornments(rec, cfg, tr)
    local now = view.time
    local cs = cfg.ChamsSettings
    local c1, c2 = cs.Color1, cs.Color2
    local fillOpacity = 1 - (cfg.AdornmentTransparency or 0.55)
    local glowOpacity = 1 - (cfg.AdornmentGlowTransparency or 0.78)
    local adTr = 1 - (fillOpacity * (1 - tr))

    if rec.adornChar ~= rec.character or not rec.adornments then
        clearAdornments(rec)
        rec.adornChar = rec.character
        rec.adornments = {}
        rec.adDirty = true
        rec.adScan = nil
    end

    if not rec.trList or now - rec.trAt > 1 then refreshTrList(rec) end
    if now - rec.trApply > 0.25 then applyTransparency(rec) end

    local dirty = rec.adDirty or rec.adC1 ~= c1 or rec.adC2 ~= c2 or rec.adFill ~= adTr or rec.adGlow ~= glowOpacity or rec.adFade ~= tr
    local scanChanged = rec.adScan ~= rec.scanned
    local stamp = rec.adStamp or 0
    if scanChanged then
        stamp += 1
        rec.adStamp = stamp
        rec.adScan = rec.scanned
    end

    local adorn = rec.adornments
    local parts = rec.adParts
    if parts then
        for i = 1, #parts do
            local part = parts[i]
            if part.Parent then
                local entry = adorn[part]
                if not entry then
                    entry = makeAdornEntry(part)
                    adorn[part] = entry
                end
                entry.seen = stamp
                if dirty or entry.sz ~= part.Size then
                    updateAdornEntry(entry, part, c1, c2, adTr, glowOpacity, tr)
                end
            end
        end
    end

    if scanChanged then
        for part, entry in pairs(adorn) do
            if entry.seen ~= stamp then
                entry.fill:Destroy()
                for _, g in ipairs(entry.glow) do g:Destroy() end
                adorn[part] = nil
            end
        end
    end

    rec.adDirty = false
    rec.adC1, rec.adC2, rec.adFill, rec.adGlow, rec.adFade = c1, c2, adTr, glowOpacity, tr
end

local function drawShaderHl(rec, cfg)
    local keyCol = KEY_COLORS[cfg.ChamsKey or 0]
    local hl = rec.hl
    if not hl then
        hl = newInstance("Highlight")
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.FillTransparency = 0
        hl.OutlineTransparency = 1
        hl.Parent = state.gui
        rec.hl = hl
        rec.hlKey = nil
    end
    if rec.hlKey ~= keyCol then
        rec.hlKey = keyCol
        hl.FillColor = keyCol
        hl.OutlineColor = keyCol
    end
    if hl.Adornee ~= rec.character then hl.Adornee = rec.character end
    if not rec.hlOn then
        hl.Enabled = true
        rec.hlOn = true
    end
end

local function drawFillHl(rec, cfg, tr)
    local hl = rec.fillHl
    if not hl then
        hl = newInstance("Highlight")
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.OutlineTransparency = 1
        hl.Parent = state.gui
        rec.fillHl = hl
        rec.fhFill, rec.fhLine, rec.fhTr = nil, nil, nil
    end
    if hl.Adornee ~= rec.character then hl.Adornee = rec.character end
    if rec.fhFill ~= cfg.BoxFillColor1 then
        rec.fhFill = cfg.BoxFillColor1
        hl.FillColor = rec.fhFill
    end
    if rec.fhLine ~= cfg.LineColor then
        rec.fhLine = cfg.LineColor
        hl.OutlineColor = rec.fhLine
    end
    local ft = 1 - ((1 - cfg.BoxFillTransparency) * (1 - tr))
    if rec.fhTr ~= ft then
        rec.fhTr = ft
        hl.FillTransparency = ft
    end
    if not rec.fillOn then
        hl.Enabled = true
        rec.fillOn = true
    end
end

local LAYOUT_OPTS = { size = 12, flagCount = 0, health = false, armor = false, ratio = 1 }

local function render(rec, cfg, dist)
    local parts = rec.parts
    if not parts or #parts == 0 then
        hideRecord(rec)
        return
    end

    local settings = espModule.Settings

    local sx1, sy1, sx2, sy2
    if settings.BoxMode == "Static" then
        sx1, sy1, sx2, sy2 = staticBounds(rec, parts)
    else
        sx1, sy1, sx2, sy2 = dynamicBounds(parts)
    end
    if not sx1 then
        hideRecord(rec)
        return
    end

    local pad = 2
    local x = floor(sx1 - pad + 0.5)
    local y = floor(sy1 - pad + 0.5)
    local w = mmax(floor(sx2 - sx1 + pad * 2 + 0.5), 8)
    local h = mmax(floor(sy2 - sy1 + pad * 2 + 0.5), 8)

    local box = rec.box
    local smooth = settings.BoxSmoothing or 0
    if box.w == 0 or smooth <= 0 or rec.hidden then
        box.x, box.y, box.w, box.h = x, y, w, h
    else
        local k = 1 - clamp(smooth, 0, 0.95)
        box.x = box.x + (x - box.x) * k
        box.y = box.y + (y - box.y) * k
        box.w = box.w + (w - box.w) * k
        box.h = box.h + (h - box.h) * k
    end
    x, y, w, h = floor(box.x + 0.5), floor(box.y + 0.5), floor(box.w + 0.5), floor(box.h + 0.5)

    rec.hidden = false
    rec.seen = view.time
    local tr = 1 - view.fade
    if rec.deathTime > 0 then
        local age = view.time - rec.deathTime
        if age > 1.2 then
            hideRecord(rec)
            return
        end
        tr = mmin(tr, age / 1.2)
    end

    local renderer = rec.renderer
    renderer:Begin()

    local textFont = getFont(settings.TextFont)
    local flagsFont = getFont(settings.FlagsFont)
    local healthFont = getFont(settings.HealthFont)
    local meters = floor(dist + 0.5)
    if rec.mVal ~= meters then
        rec.mVal = meters
        rec.mStr = meters .. "st"
    end
    local d = rec.d
    local chamsOn = cfg.Chams and state.shader ~= nil
    local chamsType = cfg.ChamsType or "Shader"
    local gradAnimated = settings.TextGradientAnimated
    local textSize = cfg.TextSize

    if cfg.BoxFill and cfg.BoxEnabled then
        if cfg.BoxType == "3D" then
            if chamsOn and chamsType == "Shader" then
                offFill(rec)
            else
                drawFillHl(rec, cfg, tr)
            end
        else
            offFill(rec)
            local ang = cfg.BoxFillRotation or 0
            if cfg.BoxFillSpeed and cfg.BoxFillSpeed ~= 0 then
                ang = (view.angle * (cfg.BoxFillSpeed / 100) + ang) % 360
            end
            renderer:Fill("boxfill", x, y, w, h, cfg.BoxFillColor1, cfg.BoxFillColor2, ang, 1 - ((1 - cfg.BoxFillTransparency) * (1 - tr)))
        end
    else
        offFill(rec)
    end

    if cfg.Chams then
        if chamsType == "Adornment" then
            offHl(rec)
            drawAdornments(rec, cfg, tr)
        elseif chamsType == "Shader" and state.shader then
            clearAdornments(rec)
            drawShaderHl(rec, cfg)
        else
            clearAdornments(rec)
            offHl(rec)
        end
    else
        clearAdornments(rec)
        offHl(rec)
    end

    if cfg.BoxEnabled then
        if cfg.BoxGlow then
            renderer:Glow("boxglow", x, y, w, h, cfg.LineColor, 1 - (0.65 * (1 - tr)))
        end

        local thick = mmax(1, cfg.Thickness or 1)
        if cfg.BoxType == "Full" then
            renderer:Full(x, y, w, h, thick, cfg.LineColor, tr)
        elseif cfg.BoxType == "3D" then
            if box3D(rec, view.time) then
                local lineColor = cfg.LineColor
                for i = 1, 12 do
                    local e = EDGES[i]
                    local a, b = e[1], e[2]
                    if BOK[a] and BOK[b] then
                        renderer:Line(BX[a], BY[a], BX[b], BY[b], thick, lineColor, lineColor, tr)
                    end
                end
            end
        else
            renderer:Corner(x, y, w, h, thick, cfg.LineColor, tr)
        end
    end

    if cfg.HeadDot then
        local hp = rec.headPart
        if hp and hp.Parent then
            local pos = hp.Position
            local hx, hy = project(pos.X, pos.Y, pos.Z)
            if hx then
                renderer:Dot("headdot", hx, hy, cfg.HeadDotSize, cfg.HeadDotColor, cfg.HeadDotOutlineThickness, tr)
            end
        end
    end

    local lo = LAYOUT_OPTS
    lo.size = textSize
    lo.flagCount = (cfg.Flags and d.flags) and #d.flags or 0
    lo.health = cfg.HealthBar and d.health ~= nil
    lo.armor = cfg.ArmorBar and d.armor ~= nil
    lo.ratio = d.health or 1
    local lay = espModule.Layout(cfg, x, y, w, h, lo)

    if lay.health then
        local r = lay.health
        renderer:Bar("health", r.x, r.y, r.w, r.h, d.health, r.vertical, cfg.HealthHigh, cfg.HealthMid, cfg.HealthLow, tr)
        if lay.healthText then
            local p = lay.healthText
            local hCol = espModule.HealthColor(d.health, cfg.HealthHigh, cfg.HealthMid, cfg.HealthLow)
            renderer:Text("hp", tostring(d.healthValue or 0), p.x, p.y, p.ax, p.ay, healthFont, textSize, hCol, hCol, tr, false)
        end
    end

    if lay.armor then
        local r = lay.armor
        local armRatio = clamp(d.armor / 100, 0, 1)
        renderer:Bar("armor", r.x, r.y, r.w, r.h, armRatio, r.vertical, cfg.ArmorHigh, cfg.ArmorMid, cfg.ArmorLow, tr)
    end

    if lay.name and d.name then
        local p = lay.name
        if cfg.Distance and cfg.Names and cfg.DistancePos == "Name" then
            local nw = renderer:Width("name")
            local dw = renderer:Width("dist")
            local gap = 4
            local nx, dxp, nax, dax
            if p.ax == 0.5 then
                nx = p.x - (dw + gap) * 0.5
                dxp = nx + nw * 0.5 + gap
                nax, dax = 0.5, 0
            elseif p.ax == 0 then
                nx = p.x
                dxp = p.x + nw + gap
                nax, dax = 0, 0
            else
                nx = p.x - dw - gap
                dxp = p.x
                nax, dax = 1, 1
            end
            renderer:Text("name", d.name, nx, p.y, nax, p.ay, textFont, textSize, cfg.NameColor, cfg.NameColor2, tr, gradAnimated)
            renderer:Text("dist", rec.mStr, dxp, p.y, dax, p.ay, flagsFont, textSize, cfg.DistanceColor, cfg.DistanceColor2, tr, gradAnimated)
        else
            renderer:Text("name", d.name, p.x, p.y, p.ax, p.ay, textFont, textSize, cfg.NameColor, cfg.NameColor2, tr, gradAnimated)
        end
    end

    if lay.distance then
        local p = lay.distance
        renderer:Text("dist", rec.mStr, p.x, p.y, p.ax, p.ay, flagsFont, textSize, cfg.DistanceColor, cfg.DistanceColor2, tr, gradAnimated)
    end

    if lay.tool and d.tool then
        local p = lay.tool
        renderer:Text("tool", d.tool, p.x, p.y, p.ax, p.ay, textFont, textSize, cfg.ToolColor, cfg.ToolColor2, tr, gradAnimated)
    end

    local flagLines = lay.flagLines
    for i = 1, #flagLines do
        local p = flagLines[i]
        local fk = FLAGK[i]
        if not fk then
            fk = "flag" .. i
            FLAGK[i] = fk
        end
        renderer:Text(fk, d.flags[i], p.x, p.y, p.ax, p.ay, flagsFont, textSize, cfg.FlagColor1, cfg.FlagColor2, tr, gradAnimated)
    end

    if cfg.Tracers then
        local fromX, fromY
        local origin = cfg.TracerOrigin
        if origin == "Bottom" then
            fromX, fromY = viewW * 0.5, viewH
        elseif origin == "Top" then
            fromX, fromY = viewW * 0.5, 0
        elseif origin == "Mouse" then
            local m = UserInputService:GetMouseLocation()
            fromX, fromY = m.X, m.Y
        else
            fromX, fromY = viewW * 0.5, viewH * 0.5
        end
        renderer:Line(fromX, fromY, x + w * 0.5, y + h, cfg.TracerThickness or 1, cfg.TracerColor, cfg.TracerColor, tr)
    end

    if cfg.Skeleton and rec.boneParts and dist <= (cfg.SkeletonMaxDistance or 400) and h >= 24 then
        local bp, bi = rec.boneParts, rec.boneIdx
        for i = 1, #bp do
            local part = bp[i]
            if part.Parent then
                local pos = part.Position
                local sx, sy = project(pos.X, pos.Y, pos.Z)
                if sx then
                    BPX[i], BPY[i], BPOK[i] = sx, sy, true
                else
                    BPOK[i] = false
                end
            else
                BPOK[i] = false
            end
        end
        local th = cfg.SkeletonThickness or 1
        local ol = h >= 70
        local sc1, sc2 = cfg.SkeletonColor, cfg.SkeletonColor2
        for i = 1, #bi, 2 do
            local a, b = bi[i], bi[i + 1]
            if BPOK[a] and BPOK[b] then
                renderer:Line(BPX[a], BPY[a], BPX[b], BPY[b], th, sc1, sc2, tr, ol)
            end
        end
    end

    renderer:End()
end

local function processEntity(entity, isPlayer, options, ownerKey)
    local settings = espModule.Settings
    local now = view.time
    local rec = state.records[entity]

    local character
    if isPlayer then
        character = entity.Character
    else
        character = entity
    end
    if not character or not character:IsA("Model") then
        if rec then hideRecord(rec) end
        return
    end

    local cfg
    if isPlayer then
        local isTeam = state.teamVal[entity]
        local at = state.teamAt[entity]
        if at == nil or now - at > 0.5 then
            isTeam = espModule.IsTeam(entity) and true or false
            state.teamVal[entity] = isTeam
            state.teamAt[entity] = now
        end
        cfg = isTeam and settings.Teammate or settings.Enemy
    else
        cfg = settings.AI
    end
    if options and options.UseEnemy == true then cfg = settings.Enemy end
    if options and options.UseTeammate == true then cfg = settings.Teammate end
    if not cfg.Enabled then
        if rec then hideRecord(rec) end
        return
    end

    if not rec then
        rec = newRecord(entity)
        if ownerKey then rec.owner = ownerKey end
        state.records[entity] = rec
    end
    rec.touched = view.frame

    if isPlayer then
        if now - rec.raidAt > 1 then
            rec.raidAt = now
            local inRaid = entity:FindFirstChild("InRaid")
            rec.raidSkip = inRaid ~= nil and inRaid:IsA("BoolValue") and not inRaid.Value
        end
        if rec.raidSkip then
            hideRecord(rec)
            return
        end
    end

    local humanoid = rec.humanoid
    if rec.character ~= character then
        humanoid = character:FindFirstChildOfClass("Humanoid")
        rec.humAt = now
        bindCharacter(rec, character, humanoid, false)
    else
        if now - rec.scanned > 1.5 then
            humanoid = character:FindFirstChildOfClass("Humanoid")
            rec.humAt = now
            rescan(rec, humanoid, false)
        elseif (not humanoid or humanoid.Parent ~= character) and now - rec.humAt > 0.5 then
            humanoid = character:FindFirstChildOfClass("Humanoid")
            rec.humAt = now
            rec.humanoid = humanoid
        end
    end

    if humanoid and humanoid.Health <= 0 then
        if rec.deathTime == 0 then
            rec.deathTime = now
        end
        if now - rec.deathTime > 1.2 then
            hideRecord(rec)
            return
        end
    else
        rec.deathTime = 0
    end

    if options and type(options.Alive) == "function" then
        local ok, alive = pcall(options.Alive, character)
        if ok and not alive then
            hideRecord(rec)
            return
        end
    end

    local root = rec.root
    if not root then
        hideRecord(rec)
        return
    end

    local rp = root.Position
    local dx, dy, dz = rp.X - camX, rp.Y - camY, rp.Z - camZ
    local dist = sqrt(dx * dx + dy * dy + dz * dz)
    if dist > settings.MaxDistance or -(dx * c02 + dy * c12 + dz * c22) < 0.05 then
        hideRecord(rec)
        return
    end

    local d = rec.d
    if humanoid then
        d.health = clamp(humanoid.Health / mmax(humanoid.MaxHealth, 1), 0, 1)
        d.healthValue = floor(humanoid.Health + 0.5)
    elseif options and type(options.Health) == "function" then
        local ok, hp, maxHp = pcall(options.Health, character)
        if ok and type(hp) == "number" then
            d.health = clamp(hp / mmax(maxHp or 100, 1), 0, 1)
            d.healthValue = floor(hp + 0.5)
        else
            d.health = nil
        end
    else
        d.health = nil
    end

    if now - rec.infoAt > 0.2 then
        rec.infoAt = now
        d.armor = cfg.ArmorBar and currentArmor(rec, character, options) or nil
        d.tool = cfg.Tool and currentTool(rec, character, options) or nil
        d.name = nil
        if cfg.Names then
            if options and options.Name ~= nil then
                local value = options.Name
                if type(value) == "function" then
                    local ok, res = pcall(value, character)
                    value = ok and res or character.Name
                end
                d.name = tostring(value)
            elseif isPlayer then
                d.name = playerName(rec, entity, cfg.NameType)
            else
                d.name = character.Name
            end
        end
        updateFlags(rec, entity, character, humanoid, cfg)
    end

    render(rec, cfg, dist)
end

local function resolveOwner(rec, pos)
    local now = view.time
    if rec.lastPos and (pos - rec.lastPos).Magnitude > 15 then
        rec.owner, rec.verdict, rec.verdictAt = nil, nil, 0
    end
    rec.lastPos = pos

    local owner = rec.owner
    if owner and owner.Parent then
        local char = owner.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and (hrp.Position - pos).Magnitude < 12 then return owner end
    end
    if now - rec.searchAt < 0.2 then return nil end
    rec.searchAt = now

    local best, bestDist = nil, 10
    for _, plr in ipairs(state.players) do
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local dd = (hrp.Position - pos).Magnitude
            if dd < bestDist then
                bestDist, best = dd, plr
            end
        end
    end
    rec.owner = best
    return best
end

local function viewmodelIsTeam(rec, owner)
    local now = view.time
    if owner then
        local mine, theirs = getTeamValue(LocalPlayer), getTeamValue(owner)
        if mine ~= nil and theirs ~= nil then
            rec.verdict = theirs == mine and "team" or "enemy"
            rec.verdictAt = now
            return theirs == mine
        end
    end
    if rec.verdict and now - rec.verdictAt < 2.5 then
        return rec.verdict == "team"
    end
    return false
end

local function viewmodelWeapon(vm)
    local fallback
    for _, c in ipairs(vm:GetChildren()) do
        if c:IsA("Model") then
            if c:FindFirstChild("Gun") or c:FindFirstChild("StateObject") then return c.Name end
            fallback = fallback or c.Name
        end
    end
    return fallback
end

local function processViewmodel(vm)
    local settings = espModule.Settings
    local now = view.time
    local rec = state.records[vm]
    if rec then rec.touched = view.frame end

    if not (settings.Enemy.Enabled or settings.Teammate.Enabled) then
        if rec then hideRecord(rec) end
        return
    end

    if not rec then
        rec = newRecord(vm)
        rec.born = now
        rec.touched = view.frame
        state.records[vm] = rec
    end

    if rec.character ~= vm or not rec.root or not rec.root.Parent then
        bindCharacter(rec, vm, nil, true)
    elseif now - rec.scanned > 1.5 then
        rescan(rec, nil, true)
    end

    local root = rec.root
    if not root or now - rec.born < 0.05 then
        hideRecord(rec)
        return
    end

    local tp = root.Position
    local owner = resolveOwner(rec, tp)

    if owner then
        local ownerChar = owner.Character
        local ownerHum = ownerChar and ownerChar:FindFirstChildOfClass("Humanoid")
        if ownerHum and ownerHum.Health <= 0 then
            if rec.deathTime == 0 then
                rec.deathTime = now
            end
            if now - rec.deathTime > 1.2 then
                hideRecord(rec)
                return
            end
        else
            rec.deathTime = 0
        end
    end

    local isTeam = viewmodelIsTeam(rec, owner)
    local cfg = isTeam and settings.Teammate or settings.Enemy
    if not cfg.Enabled then
        hideRecord(rec)
        return
    end

    local dx, dy, dz = tp.X - camX, tp.Y - camY, tp.Z - camZ
    local dist = sqrt(dx * dx + dy * dy + dz * dz)
    if dist <= 1 or dist > settings.MaxDistance or -(dx * c02 + dy * c12 + dz * c22) < 0.05 then
        hideRecord(rec)
        return
    end

    local ownerChar = owner and owner.Character
    if rec.ownerChar ~= ownerChar then
        rec.ownerChar = ownerChar
        rec.ownerHum = ownerChar and ownerChar:FindFirstChildOfClass("Humanoid")
    end
    local ownerHum = rec.ownerHum

    local d = rec.d
    if ownerHum and ownerHum.Health > 0 then
        d.health = clamp(ownerHum.Health / mmax(ownerHum.MaxHealth, 1), 0, 1)
        d.healthValue = floor(ownerHum.Health + 0.5)
    else
        d.health = nil
        d.healthValue = nil
    end

    if now - rec.infoAt > 0.2 then
        rec.infoAt = now
        d.armor = (cfg.ArmorBar and ownerChar) and currentArmor(rec, ownerChar) or nil
        d.tool = cfg.Tool and (viewmodelWeapon(vm) or "None") or nil
        d.name = nil
        if cfg.Names then
            if owner then
                d.name = playerName(rec, owner, cfg.NameType)
                rec.lastName = d.name
            elseif rec.lastName then
                d.name = rec.lastName
            else
                d.name = "Player"
            end
        end
        updateFlags(rec, owner or vm, ownerChar or vm, ownerHum, cfg)
    end

    render(rec, cfg, dist)
end

local EMPTY = {}

local function resolveList(entry)
    local source = entry.Source
    local kind = typeof(source)
    local function children(inst)
        if entry.Cache and entry.CacheInst == inst and view.time - entry.CacheAt < 0.5 then return entry.Cache end
        entry.Cache = inst:GetChildren()
        entry.CacheInst = inst
        entry.CacheAt = view.time
        return entry.Cache
    end
    if kind == "function" then
        local ok, res = pcall(source)
        if not ok then return EMPTY end
        if typeof(res) == "Instance" then return children(res) end
        if type(res) == "table" then return res end
        return EMPTY
    elseif kind == "Instance" then
        return children(source)
    elseif kind == "table" then
        return source
    end
    return EMPTY
end

function espModule:RemoveAI(name)
    if not self.CustomAIs[name] then return end
    self.CustomAIs[name] = nil
    for entity, rec in pairs(state.records) do
        if rec.owner == name then dropRecord(entity) end
    end
    fireRegistry()
end

function espModule:RemoveEntity(name)
    self:RemoveAI(name)
end

local function dropItemMeta(item)
    local meta = state.itemMeta[item]
    if not meta then return end
    if meta.hl then meta.hl:Destroy() end
    state.itemMeta[item] = nil
end

function espModule:RemoveItem(name)
    if not self.CustomItems[name] then return end
    self.CustomItems[name] = nil
    self.Settings.Items[name] = nil
    for item, meta in pairs(state.itemMeta) do
        if meta.owner == name then dropItemMeta(item) end
    end
    fireRegistry()
end

local function setChamHighlight(meta, key, adornee)
    local hl = meta[key]
    if not hl then
        hl = newInstance("Highlight")
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.FillColor = KEY_COLORS[2]
        hl.FillTransparency = 0
        hl.OutlineColor = KEY_COLORS[2]
        hl.OutlineTransparency = 1
        hl.Parent = state.gui
        meta[key] = hl
    end
    if hl.Adornee ~= adornee then
        hl.Adornee = adornee
    end
    if not hl.Enabled then hl.Enabled = true end
end

local function clearHighlight(meta, key)
    local hl = meta[key]
    if hl and hl.Enabled then hl.Enabled = false end
end

local function drawItem(item, name, entry, itemCfg, cfg, limit)
    local meta = state.itemMeta[item]
    if not meta then
        meta = { ckey = {}, posAt = -1, labelAt = -1, contentsAt = -1, label = item.Name }
        state.itemMeta[item] = meta
    end
    meta.touched = view.frame
    meta.owner = name

    local now = view.time
    if now - meta.posAt > 0.5 then
        meta.posAt = now
        if item:IsA("BasePart") then
            meta.pos = item.Position
        elseif item:IsA("Model") then
            meta.pos = item:GetPivot().Position
        else
            local part = item:FindFirstChildWhichIsA("BasePart", true)
            meta.pos = part and part.Position
        end
    end

    local pos = meta.pos
    if not pos then
        clearHighlight(meta, "hl")
        return
    end

    local dx, dy, dz = pos.X - camX, pos.Y - camY, pos.Z - camZ
    local dist = sqrt(dx * dx + dy * dy + dz * dz)
    local sx, sy
    if dist <= limit then sx, sy = project(pos.X, pos.Y, pos.Z) end
    if not sx then
        clearHighlight(meta, "hl")
        return
    end

    local settings = espModule.Settings
    local renderer = state.itemRenderer
    local color = itemCfg.Color
    local tr = 1 - view.fade
    local size = cfg.TextSize
    local meters = floor(dist + 0.5)

    if cfg.ShowNames or cfg.ShowDistance then
        if cfg.ShowNames and now - meta.labelAt > 1 then
            meta.labelAt = now
            local label = item.Name
            local custom = entry.Options.Label
            if type(custom) == "function" then
                local ok, res = pcall(custom, item)
                if ok and res then label = tostring(res) end
            elseif custom ~= nil then
                label = tostring(custom)
            end
            meta.label = label
            meta.text = nil
        end
        if meta.text == nil or meta.meters ~= meters or meta.showNames ~= cfg.ShowNames or meta.showDistance ~= cfg.ShowDistance then
            meta.meters, meta.showNames, meta.showDistance = meters, cfg.ShowNames, cfg.ShowDistance
            if cfg.ShowNames and cfg.ShowDistance then
                meta.text = meta.label .. " " .. meters .. "st"
            elseif cfg.ShowNames then
                meta.text = meta.label
            else
                meta.text = meters .. "st"
            end
        end
        renderer:Text(item, meta.text, sx, sy - 12, 0.5, 0.5, getFont(cfg.ShowDistance and settings.FlagsFont or settings.TextFont), size, color, color, tr, false)
    end

    if cfg.ShowContents and type(entry.Options.Contents) == "function" then
        if now - meta.contentsAt > 0.5 then
            meta.contentsAt = now
            local ok, res = pcall(entry.Options.Contents, item)
            local text = ok and res and tostring(res) or nil
            if text and #text > 60 then text = text:sub(1, 57) .. "..." end
            meta.contents = text
        end
        if meta.contents and meta.contents ~= "" then
            renderer:Text(meta.ckey, meta.contents, sx, sy + 16, 0.5, 0.5, getFont(settings.TextFont), size - 1, color, color, tr, false)
        end
    end

    if cfg.Chams and state.shader then
        setChamHighlight(meta, "hl", item)
    else
        clearHighlight(meta, "hl")
    end
end

local function processItems()
    local cfg = espModule.Settings.Items
    local limit = cfg.MaxDistance * 2.81
    state.itemRenderer:Begin()
    for name, entry in pairs(espModule.CustomItems) do
        local itemCfg = cfg[name]
        if type(itemCfg) == "table" and itemCfg.Enabled then
            local list = resolveList(entry)
            for i = 1, #list do
                local item = list[i]
                if typeof(item) == "Instance" and item.Parent then
                    drawItem(item, name, entry, itemCfg, cfg, limit)
                end
            end
        end
    end
    state.itemRenderer:End()

    if view.frame % 30 == 0 then
        for item, meta in pairs(state.itemMeta) do
            if meta.touched < view.frame - 30 or not item.Parent then dropItemMeta(item) end
        end
    end
end

local function clearItems()
    if state.itemRenderer then state.itemRenderer:Clear() end
    for item in pairs(state.itemMeta) do dropItemMeta(item) end
end

local function step()
    local settings = espModule.Settings
    local now = clock()

    view.fade = state.dead and mmax(0, view.fade - 0.05) or mmin(1, view.fade + 0.05)

    local anyEntity = settings.Enemy.Enabled or settings.Teammate.Enabled or settings.AI.Enabled
    local anyItem = settings.Items.Enabled

    if not anyEntity and state.hadEntities then
        state.hadEntities = false
        for entity in pairs(state.records) do dropRecord(entity) end
    end
    if not anyItem and state.hadItems then
        state.hadItems = false
        clearItems()
    end

    local use = state.use
    use[0] = settings.Enemy.Enabled and settings.Enemy.Chams and settings.Enemy.ChamsType == "Shader"
    use[1] = settings.Teammate.Enabled and settings.Teammate.Chams and settings.Teammate.ChamsType == "Shader"
    use[2] = (settings.AI.Enabled and settings.AI.Chams and settings.AI.ChamsType == "Shader") or (settings.Items.Enabled and settings.Items.Chams)
    local sig = (use[0] and 1 or 0) + (use[1] and 2 or 0) + (use[2] and 4 or 0)
    if sig ~= 0 then
        ensureShader()
        if state.shader then
            if sig ~= state.useSig or now - state.pushAt > 0.1 then
                state.useSig = sig
                state.pushAt = now
                pushSettings()
            end
            pushBounds()
        end
    elseif state.shader then
        destroyShader()
        state.useSig = -1
    end

    if not anyEntity and not anyItem then return end

    if now - state.last < 0.9 / clamp(settings.RefreshRate, 30, 360) then return end
    view.dt = mmin(now - state.last, 0.1)
    state.last = now

    local cam = workspace.CurrentCamera
    if not cam then return end

    updateView(cam)
    view.time = now
    view.frame += 1
    view.angle = (floor(now * 50) * 2) % 360

    if anyEntity then
        state.hadEntities = true

        if game.PlaceId == SPECIAL_PLACE then
            if now - state.vmAt > 0.25 then
                state.vmAt = now
                local folder = workspace:FindFirstChild("Viewmodels")
                state.vms = folder and folder:GetChildren() or {}
            end
            local vms = state.vms
            for i = 1, #vms do
                local vm = vms[i]
                if vm.Parent and vm.Name:sub(1, 5) ~= "Local" and vm:IsA("Model") then processViewmodel(vm) end
            end
        else
            local list = state.players
            for i = 1, #list do processEntity(list[i], true) end
        end

        if settings.AI.Enabled then
            for name, entry in pairs(espModule.CustomAIs) do
                local list = resolveList(entry)
                for i = 1, #list do
                    local ent = list[i]
                    if typeof(ent) == "Instance" and ent.Parent and ent:IsA("Model") then
                        processEntity(ent, false, entry.Options, name)
                    end
                end
            end
        end

        if view.frame % 30 == 0 then
            for entity, rec in pairs(state.records) do
                if rec.touched < view.frame - 30 or (now - rec.seen > 30 and rec.hidden) then dropRecord(entity) end
            end
        end
    end

    if anyItem then
        state.hadItems = true
        processItems()
    end
end

function espModule:Start()
    if state.running then return end
    state.running = true

    local gui = newInstance("ScreenGui")
    gui.Name = HttpService:GenerateGUID(false)
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 900
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local parent
    if typeof(gethui) == "function" then
        local ok, ui = pcall(gethui)
        if ok and ui then parent = cloneref(ui) end
    end
    gui.Parent = parent or cloneref(game:GetService("CoreGui"))
    state.gui = gui
    state.itemRenderer = Renderer.new(gui)

    task.spawn(loadFonts)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then state.players[#state.players + 1] = plr end
    end

    local function onCharacter(char)
        local hum = char:WaitForChild("Humanoid", 10)
        state.dead = false
        view.fade = 1
        if hum then
            hum.Died:Connect(function() state.dead = true end)
        end
    end
    if LocalPlayer.Character then task.spawn(onCharacter, LocalPlayer.Character) end

    state.connections[#state.connections + 1] = LocalPlayer.CharacterAdded:Connect(onCharacter)
    state.connections[#state.connections + 1] = Players.PlayerAdded:Connect(function(plr)
        if plr ~= LocalPlayer then state.players[#state.players + 1] = plr end
    end)
    state.connections[#state.connections + 1] = Players.PlayerRemoving:Connect(function(plr)
        local idx = tfind(state.players, plr)
        if idx then table.remove(state.players, idx) end
        state.teamVal[plr] = nil
        state.teamAt[plr] = nil
        dropRecord(plr)
    end)

    RunService:BindToRenderStep("CatwareESP", Enum.RenderPriority.Camera.Value + 1, step)
end

function espModule:Stop()
    if not state.running then return end
    state.running = false
    pcall(function() RunService:UnbindFromRenderStep("CatwareESP") end)
    for _, conn in ipairs(state.connections) do conn:Disconnect() end
    tclear(state.connections)
    tclear(state.players)
    tclear(state.records)
    tclear(state.itemMeta)
    tclear(state.teamVal)
    tclear(state.teamAt)
    state.vms, state.vmAt = {}, -1
    state.hadEntities, state.hadItems, state.dead = false, false, false
    state.useSig = -1
    view.fade = 1
    destroyShader()
    if state.gui then
        state.gui:Destroy()
        state.gui = nil
    end
    state.itemRenderer = nil
end

function espModule:Restart()
    self:Stop()
    self:Start()
end

function espModule:Destroy()
    self:Stop()
end

function espModule:Toggle()
    if state.running then self:Stop() else self:Start() end
end

function espModule:IsRunning()
    return state.running
end

function espModule:UpdateSettings(new)
    local function merge(dst, src)
        for k, v in pairs(src) do
            if type(v) == "table" and type(dst[k]) == "table" then
                merge(dst[k], v)
            else
                dst[k] = v
            end
        end
    end
    merge(self.Settings, new)
end

function espModule:GetSettings()
    return self.Settings
end

return espModule
