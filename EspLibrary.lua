local cloneref = cloneref or function(o) return o end
local function svc(name) return cloneref(game:GetService(name)) end

local RunService       = svc("RunService")
local Players          = svc("Players")
local Workspace        = svc("Workspace")
local HttpService      = svc("HttpService")
local UserInputService = svc("UserInputService")

local LocalPlayer = Players.LocalPlayer

local floor, abs, clamp, huge, max, min, sqrt, atan2, deg =
    math.floor, math.abs, math.clamp, math.huge, math.max, math.min, math.sqrt, math.atan2, math.deg
local v2, v3 = Vector2.new, Vector3.new
local px = UDim2.fromOffset
local rgb = Color3.fromRGB
local WHITE, BLACK = Color3.new(1, 1, 1), Color3.new(0, 0, 0)

local STUDS_PER_METER = 2.81
local STEP_NAME = "StardustESP"

local ESP = {
    Version = "2.0.0",
    Fonts = {},
    FontOrder = {},
    FontNames = {},
    FontsReady = false,
    CustomFlags = {},
    FlagListeners = {},
    TeamCheckUrl = "https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/TeamCheck.lua",
}

ESP.Rig = {
    R15Parts = {"HumanoidRootPart", "Head", "UpperTorso", "LowerTorso", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand"},
    R6Parts = {"HumanoidRootPart", "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"},
    R15Bones = {
        {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"LowerTorso", "LeftUpperLeg"}, {"LowerTorso", "RightUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"UpperTorso", "LeftUpperArm"},
        {"UpperTorso", "RightUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"RightUpperArm", "RightLowerArm"},
    },
    R6Bones = {
        {"Head", "Torso"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
    },
}

local R15_PARTS, R6_PARTS = ESP.Rig.R15Parts, ESP.Rig.R6Parts
local R15_BONES, R6_BONES = ESP.Rig.R15Bones, ESP.Rig.R6Bones

local XS = {1, 0, 0, 1, 1, 0, 0, 1}
local YS = {1, 1, 0, 0, 1, 1, 0, 0}
local ZS = {1, 1, 1, 1, 0, 0, 0, 0}
local EDGES = {{1, 2}, {2, 3}, {3, 4}, {4, 1}, {5, 6}, {6, 7}, {7, 8}, {8, 5}, {1, 5}, {2, 6}, {3, 7}, {4, 8}}

local function entitySettings(p)
    return {
        Enabled = false,
        BoxEnabled = false, BoxType = "Corner", Thickness = 1, LineColor = p.main,
        BoxGlow = false,
        BoxFill = false, BoxFillColor1 = p.main, BoxFillColor2 = p.fill2, BoxFillTransparency = 0.7,
        BoxFillRotation = 0, BoxFillSpeed = 2,
        Chams = false, ChamsColor = p.main, ChamsGlow = false, ChamsFillTransparency = 0.3,
        Names = false, NameType = "Display", NameColor = p.text1, NameColor2 = p.text2,
        Distance = false, DistanceColor = p.text1, DistanceColor2 = p.text2,
        Tool = false, ToolColor = p.text1, ToolColor2 = p.text2,
        Flags = false, SelectedFlags = {"Walking", "Jumping", "Swimming"}, FlagColor1 = p.text1, FlagColor2 = p.text2,
        HealthBar = false, HealthText = false,
        HealthHigh = p.health[1], HealthMid = p.health[2], HealthLow = p.health[3],
        ArmorBar = false, ArmorHigh = rgb(0, 255, 0), ArmorMid = rgb(255, 255, 0), ArmorLow = rgb(255, 0, 0),
        HeadDot = false, HeadDotColor = WHITE, HeadDotSize = 20, HeadDotOutlineThickness = 0,
        Skeleton = false, SkeletonThickness = 1, SkeletonColor = p.main, SkeletonColor2 = p.skel2,
        Tracers = false, TracerThickness = 1, TracerOrigin = "Bottom", TracerColor = p.main,
        TextSize = 12,
    }
end

local function itemEntry(r, g, b)
    return { Enabled = false, Color = rgb(r, g, b) }
end

ESP.Settings = {
    RefreshRate = 144,
    MaxDistance = 425,
    TextFont = "Tahoma",
    FlagsFont = "Tahoma",
    HealthFont = "Tahoma",
    TextGradientAnimated = true,
    Enemy = entitySettings({
        main = rgb(255, 80, 80), fill2 = rgb(255, 40, 40), skel2 = rgb(200, 200, 200),
        text1 = rgb(255, 255, 255), text2 = rgb(200, 200, 200),
        health = {rgb(0, 255, 100), rgb(255, 255, 0), rgb(255, 40, 40)},
    }),
    Teammate = entitySettings({
        main = rgb(0, 180, 255), fill2 = rgb(0, 100, 200), skel2 = rgb(100, 150, 200),
        text1 = rgb(180, 230, 255), text2 = rgb(100, 150, 200),
        health = {rgb(0, 200, 255), rgb(100, 200, 255), rgb(30, 80, 140)},
    }),
    AI = entitySettings({
        main = rgb(255, 200, 50), fill2 = rgb(255, 150, 0), skel2 = rgb(200, 150, 50),
        text1 = rgb(255, 255, 255), text2 = rgb(200, 200, 200),
        health = {rgb(0, 255, 100), rgb(255, 255, 0), rgb(255, 40, 40)},
    }),
    Items = {
        Enabled = false, MaxDistance = 200, TextSize = 12,
        ShowNames = false, ShowDistance = false, ShowContents = false,
        Chams = false, ChamsFillTransparency = 0.3,
        Safe = itemEntry(192, 192, 192), CivilianAirdrop = itemEntry(255, 140, 0),
        AbandonedCar = itemEntry(169, 169, 169), DuffelBag = itemEntry(139, 69, 19),
        FoodCrate = itemEntry(0, 255, 0), LeatherPouch = itemEntry(160, 82, 45),
        SupplyCrate = itemEntry(0, 191, 255), MedicalPouch = itemEntry(255, 20, 20),
        TCRCrate = itemEntry(192, 192, 192), MetalCrate = itemEntry(255, 140, 0),
        TallMetalCrate = itemEntry(169, 169, 169), SpecopsCrate = itemEntry(139, 69, 19),
        AmmoBox = itemEntry(0, 255, 0), WoodenCrate = itemEntry(160, 82, 45),
        DroppedItemContainer = itemEntry(255, 105, 180), Dead = itemEntry(255, 0, 0),
    },
}

local FONT_BASE = "https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/fonts/"
local FONT_DIR = "catware_fonts"
local FONT_FILES = {
    {"Tahoma", "Tahoma.ttf"},
    {"Tahoma Bold", "tahoma_bold.ttf"},
    {"Tahoma Modern Bold", "Tahoma-Modern-Bold.ttf"},
    {"Tahoma Modern", "Tahoma-Modern.ttf"},
    {"Comfortaa", "Comfortaa-Regular.ttf"},
    {"HankenGrotesk", "HankenGrotesk-SemiBold.ttf"},
    {"Inter Medium", "Inter_28pt-Medium.ttf"},
    {"Inter SemiBold", "Inter_28pt-SemiBold.ttf"},
    {"Light Modern", "Light Modern.ttf"},
    {"Minecraftia", "Minecraftia-Regular.ttf"},
    {"ProggyClean", "ProggyClean.ttf"},
    {"ProggyTiny", "ProggyTiny.ttf"},
    {"Rubik", "Rubik-Regular.ttf"},
    {"Verdana", "Verdana-Font.ttf"},
    {"Tahoma 8px", "fs-tahoma-8px.ttf"},
    {"Open Sans PX", "open-sans-px.ttf"},
    {"Smallest Pixel-7", "smallest_pixel-7.ttf"},
    {"Gojiberry Quibble", "GojiberryQuibbleFreeRegular-7OldK.ttf"},
}

for _, entry in ipairs(FONT_FILES) do ESP.FontNames[#ESP.FontNames + 1] = entry[1] end

local FALLBACK_FONT = Font.fromEnum(Enum.Font.Code)
local fontListeners = {}

local function fontsAvailable()
    return typeof(writefile) == "function" and typeof(readfile) == "function"
        and typeof(isfile) == "function" and typeof(getcustomasset) == "function"
end

local function loadFontEntry(entry)
    local name, file = entry[1], entry[2]
    if ESP.Fonts[name] then return ESP.Fonts[name] end
    if not fontsAvailable() then return nil end
    local ok, font = pcall(function()
        if typeof(makefolder) == "function" and not (typeof(isfolder) == "function" and isfolder(FONT_DIR)) then
            makefolder(FONT_DIR)
        end
        local path = FONT_DIR .. "/" .. file
        if not isfile(path) then
            writefile(path, game:HttpGet(FONT_BASE .. (file:gsub(" ", "%%20"))))
        end
        local jsonPath = FONT_DIR .. "/" .. (name:gsub("%s", "_")) .. ".json"
        writefile(jsonPath, HttpService:JSONEncode({
            name = name,
            faces = {{ name = "Regular", weight = 400, style = "normal", assetId = getcustomasset(path) }},
        }))
        return Font.new(getcustomasset(jsonPath), Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    end)
    if ok and font then
        ESP.Fonts[name] = font
        ESP.FontOrder[#ESP.FontOrder + 1] = name
    end
    return ESP.Fonts[name]
end

function ESP.LoadFont(name)
    local cached = ESP.Fonts[name]
    if cached then return cached end
    for _, entry in ipairs(FONT_FILES) do
        if entry[1] == name then return loadFontEntry(entry) end
    end
    return nil
end

function ESP.LoadFonts()
    if ESP.FontsReady or ESP._fontsLoading then return end
    ESP._fontsLoading = true
    task.spawn(function()
        local pending = #FONT_FILES
        for _, entry in ipairs(FONT_FILES) do
            task.spawn(function()
                loadFontEntry(entry)
                pending -= 1
            end)
        end
        while pending > 0 do task.wait(0.1) end
        ESP.FontsReady = true
        for _, fn in ipairs(fontListeners) do task.spawn(fn) end
        table.clear(fontListeners)
    end)
end

function ESP.OnFontsReady(fn)
    if ESP.FontsReady then
        task.spawn(fn)
    else
        fontListeners[#fontListeners + 1] = fn
    end
end

function ESP.GetFont(name)
    return ESP.Fonts[name] or FALLBACK_FONT
end

function ESP.HealthColor(t, high, mid, low)
    t = clamp(t, 0, 1)
    if t >= 0.5 then return mid:Lerp(high, (t - 0.5) * 2) end
    return low:Lerp(mid, t * 2)
end

local BUILTIN_FLAGS = {"Walking", "Jumping", "Swimming"}

function ESP.GetFlagNames()
    local out = {}
    for i, n in ipairs(BUILTIN_FLAGS) do out[i] = n end
    local custom = {}
    for n in pairs(ESP.CustomFlags) do custom[#custom + 1] = n end
    table.sort(custom)
    for _, n in ipairs(custom) do out[#out + 1] = n end
    return out
end

function ESP.OnFlagsChanged(fn)
    ESP.FlagListeners[#ESP.FlagListeners + 1] = fn
end

local function fireFlagsChanged()
    for _, fn in ipairs(ESP.FlagListeners) do task.spawn(fn) end
end

function ESP:AddFlag(name, fn)
    self.CustomFlags[name] = fn
    fireFlagsChanged()
end

function ESP:RemoveFlag(name)
    self.CustomFlags[name] = nil
    fireFlagsChanged()
end

local function defaultTeamCheck(plr)
    if not plr or plr == LocalPlayer then return false end
    if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then return true end
    local char = plr.Character
    return char ~= nil and char:FindFirstChild("SquadBillboard") ~= nil
end

ESP.IsTeam = defaultTeamCheck

function ESP:SetTeamCheck(fn)
    if type(fn) == "function" then self.IsTeam = fn end
end

task.spawn(function()
    local ok, fn = pcall(function() return loadstring(game:HttpGet(ESP.TeamCheckUrl))() end)
    if ok and type(fn) == "function" then ESP.IsTeam = fn end
end)

local Renderer = {}
Renderer.__index = Renderer
ESP.Renderer = Renderer

local TEXT_X = {
    [0] = Enum.TextXAlignment.Left, [0.5] = Enum.TextXAlignment.Center, [1] = Enum.TextXAlignment.Right,
}
local TEXT_Y = {
    [0] = Enum.TextYAlignment.Top, [0.5] = Enum.TextYAlignment.Center, [1] = Enum.TextYAlignment.Bottom,
}

local function addStroke(parent)
    local s = Instance.new("UIStroke")
    s.Color = BLACK
    s.Thickness = 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.LineJoinMode = Enum.LineJoinMode.Miter
    s.Parent = parent
    return s
end

local function buildRect(root)
    local f = Instance.new("Frame")
    f.BorderSizePixel = 0
    f.ZIndex = 3
    f.Visible = false
    f.Parent = root
    return { f = f, s = addStroke(f), shown = false }
end

local function buildLine(root)
    local f = Instance.new("Frame")
    f.AnchorPoint = v2(0.5, 0.5)
    f.BorderSizePixel = 0
    f.ZIndex = 3
    f.Visible = false
    f.Parent = root
    local s = addStroke(f)
    local g = Instance.new("UIGradient")
    g.Parent = f
    return { f = f, s = s, g = g, shown = false }
end

local function buildText(root)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.BorderSizePixel = 0
    l.AutomaticSize = Enum.AutomaticSize.XY
    l.Size = UDim2.new()
    l.TextColor3 = WHITE
    l.TextStrokeColor3 = BLACK
    l.ZIndex = 5
    l.Visible = false
    l.Parent = root
    local g = Instance.new("UIGradient")
    g.Parent = l
    return { root = l, grad = g }
end

local function buildBar(root)
    local c = Instance.new("Frame")
    c.BackgroundColor3 = rgb(15, 15, 15)
    c.BorderSizePixel = 0
    c.ZIndex = 3
    c.Visible = false
    c.Parent = root
    local s = addStroke(c)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = WHITE
    f.BorderSizePixel = 0
    f.ZIndex = 4
    f.Parent = c
    local g = Instance.new("UIGradient")
    g.Parent = f
    return { root = c, stroke = s, fill = f, grad = g }
end

local function buildFill(root)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = WHITE
    f.BorderSizePixel = 0
    f.ZIndex = 1
    f.Visible = false
    f.Parent = root
    local g = Instance.new("UIGradient")
    g.Parent = f
    return { root = f, grad = g }
end

local function buildGlow(root)
    local i = Instance.new("ImageLabel")
    i.Image = "rbxassetid://110204605000367"
    i.ScaleType = Enum.ScaleType.Slice
    i.SliceCenter = Rect.new(21, 21, 79, 79)
    i.BackgroundTransparency = 1
    i.BorderSizePixel = 0
    i.ZIndex = 0
    i.Visible = false
    i.Parent = root
    return { root = i }
end

local function buildDot(root)
    local f = Instance.new("Frame")
    f.AnchorPoint = v2(0.5, 0.5)
    f.BorderSizePixel = 0
    f.ZIndex = 6
    f.Visible = false
    f.Parent = root
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = f
    local s = Instance.new("UIStroke")
    s.Color = BLACK
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Enabled = false
    s.Parent = f
    return { root = f, stroke = s }
end

function Renderer.new(parent)
    local root = Instance.new("Frame")
    root.Name = "R"
    root.BackgroundTransparency = 1
    root.BorderSizePixel = 0
    root.Size = UDim2.fromScale(1, 1)
    root.Parent = parent
    return setmetatable({
        root = root, rects = {}, lines = {}, keyed = {}, keyList = {},
        nRect = 0, nLine = 0, hiRect = 0, hiLine = 0, frame = 0, angle = 0,
    }, Renderer)
end

function Renderer:Begin()
    self.frame += 1
    self.nRect, self.nLine = 0, 0
    self.angle = (os.clock() * 100) % 360
end

function Renderer:End()
    local rects, lines = self.rects, self.lines
    for i = self.nRect + 1, self.hiRect do
        local r = rects[i]
        if r.shown then
            r.f.Visible = false
            r.shown = false
        end
    end
    self.hiRect = self.nRect
    for i = self.nLine + 1, self.hiLine do
        local l = lines[i]
        if l.shown then
            l.f.Visible = false
            l.shown = false
        end
    end
    self.hiLine = self.nLine

    local frame = self.frame
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

function Renderer:Rect(x, y, w, h, color, tr)
    local n = self.nRect + 1
    self.nRect = n
    local r = self.rects[n]
    if not r then
        r = buildRect(self.root)
        self.rects[n] = r
    end
    local f = r.f
    f.Position = px(x, y)
    f.Size = px(w, h)
    f.BackgroundColor3 = color
    f.BackgroundTransparency = tr
    r.s.Transparency = tr
    if not r.shown then
        f.Visible = true
        r.shown = true
    end
end

function Renderer:Line(a, b, thickness, c1, c2, tr)
    local n = self.nLine + 1
    self.nLine = n
    local l = self.lines[n]
    if not l then
        l = buildLine(self.root)
        self.lines[n] = l
    end
    local dx, dy = b.X - a.X, b.Y - a.Y
    local f = l.f
    f.Position = px((a.X + b.X) * 0.5, (a.Y + b.Y) * 0.5)
    f.Size = px(max(sqrt(dx * dx + dy * dy), 1), thickness)
    f.Rotation = deg(atan2(dy, dx))
    f.BackgroundTransparency = tr
    l.s.Transparency = tr
    if l.c1 ~= c1 or l.c2 ~= c2 then
        l.c1, l.c2 = c1, c2
        if c2 then
            f.BackgroundColor3 = WHITE
            l.g.Color = ColorSequence.new(c1, c2)
        else
            f.BackgroundColor3 = c1
            l.g.Color = ColorSequence.new(WHITE)
        end
    end
    if not l.shown then
        f.Visible = true
        l.shown = true
    end
end

function Renderer:Fill(x, y, w, h, c1, c2, rotation, tr)
    local k = self:Keyed("fill", buildFill)
    local f = k.root
    f.Position = px(x, y)
    f.Size = px(w, h)
    f.BackgroundTransparency = tr
    if k.c1 ~= c1 or k.c2 ~= c2 then
        k.c1, k.c2 = c1, c2
        k.grad.Color = ColorSequence.new(c1, c2)
    end
    k.grad.Rotation = rotation
end

function Renderer:Glow(x, y, w, h, color, tr)
    local k = self:Keyed("glow", buildGlow)
    local i = k.root
    i.Position = px(x - 21, y - 21)
    i.Size = px(w + 42, h + 42)
    i.ImageColor3 = color
    i.ImageTransparency = 0.35 + 0.65 * tr
end

function Renderer:Dot(key, x, y, size, color, tr, outline)
    local k = self:Keyed(key, buildDot)
    local f = k.root
    f.Position = px(x, y)
    f.Size = px(size, size)
    f.BackgroundColor3 = color
    f.BackgroundTransparency = tr
    local enabled = outline > 0
    if k.outline ~= outline then
        k.outline = outline
        k.stroke.Enabled = enabled
        if enabled then k.stroke.Thickness = outline end
    end
    if enabled then k.stroke.Transparency = tr end
end

function Renderer:Bar(key, x, y, w, h, ratio, vertical, high, mid, low, tr)
    local k = self:Keyed(key, buildBar)
    local c = k.root
    c.Position = px(x, y)
    c.Size = px(w, h)
    c.BackgroundTransparency = tr
    k.stroke.Transparency = tr
    local f = k.fill
    f.BackgroundTransparency = tr
    if vertical then
        if k.v ~= true then
            k.v = true
            f.AnchorPoint = v2(0, 1)
            f.Position = UDim2.fromScale(0, 1)
            k.grad.Rotation = 90
        end
        f.Size = UDim2.fromScale(1, ratio)
    else
        if k.v ~= false then
            k.v = false
            f.AnchorPoint = v2(0, 0)
            f.Position = UDim2.fromScale(0, 0)
            k.grad.Rotation = 0
        end
        f.Size = UDim2.fromScale(ratio, 1)
    end
    if k.high ~= high or k.mid ~= mid or k.low ~= low then
        k.high, k.mid, k.low = high, mid, low
        k.grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, high),
            ColorSequenceKeypoint.new(0.5, mid),
            ColorSequenceKeypoint.new(1, low),
        })
    end
end

function Renderer:Text(key, str, x, y, ax, ay, font, size, c1, c2, tr, animated)
    local k = self:Keyed(key, buildText)
    local l = k.root
    if k.text ~= str then
        l.Text = str
        k.text = str
    end
    if k.font ~= font then
        l.FontFace = font
        k.font = font
    end
    if k.size ~= size then
        l.TextSize = size
        k.size = size
    end
    if k.ax ~= ax or k.ay ~= ay then
        k.ax, k.ay = ax, ay
        l.AnchorPoint = v2(ax, ay)
        l.TextXAlignment = TEXT_X[ax]
        l.TextYAlignment = TEXT_Y[ay]
    end
    l.Position = px(x, y)
    if k.c1 ~= c1 or k.c2 ~= c2 then
        k.c1, k.c2 = c1, c2
        k.grad.Color = ColorSequence.new(c1, c2 or c1)
    end
    local rot = animated and self.angle or 0
    if k.rot ~= rot then
        k.rot = rot
        k.grad.Rotation = rot
    end
    l.TextTransparency = tr
    l.TextStrokeTransparency = tr
end

function Renderer:Draw(d, cfg, g)
    self:Begin()

    local fade = d.fade or 1
    local tr = 1 - fade
    local x, y, w, h = d.x, d.y, d.w, d.h
    local size = cfg.TextSize
    local animated = g.TextGradientAnimated

    if cfg.BoxEnabled then
        local t = max(1, cfg.Thickness)
        local color = cfg.LineColor
        local boxType = cfg.BoxType

        if cfg.BoxFill and boxType ~= "3D" then
            self:Fill(
                x, y, w, h, cfg.BoxFillColor1, cfg.BoxFillColor2,
                (cfg.BoxFillRotation + os.clock() * cfg.BoxFillSpeed * 60) % 360,
                1 - (1 - cfg.BoxFillTransparency) * fade
            )
        end
        if cfg.BoxGlow then self:Glow(x, y, w, h, color, tr) end

        if boxType == "Full" then
            self:Rect(x, y, w, t, color, tr)
            self:Rect(x, y + h - t, w, t, color, tr)
            self:Rect(x, y + t, t, h - 2 * t, color, tr)
            self:Rect(x + w - t, y + t, t, h - 2 * t, color, tr)
        elseif boxType == "3D" and d.pts then
            local pts, vis = d.pts, d.vis
            for i = 1, 12 do
                local e = EDGES[i]
                local a, b = e[1], e[2]
                if vis[a] and vis[b] then self:Line(pts[a], pts[b], t, color, nil, tr) end
            end
        else
            local cw = max(2, floor(w * 0.28 + 0.5))
            local ch = max(2, floor(h * 0.22 + 0.5))
            self:Rect(x, y, cw, t, color, tr)
            self:Rect(x, y, t, ch, color, tr)
            self:Rect(x + w - cw, y, cw, t, color, tr)
            self:Rect(x + w - t, y, t, ch, color, tr)
            self:Rect(x, y + h - t, cw, t, color, tr)
            self:Rect(x, y + h - ch, t, ch, color, tr)
            self:Rect(x + w - cw, y + h - t, cw, t, color, tr)
            self:Rect(x + w - t, y + h - ch, t, ch, color, tr)
        end
    end

    local health = d.health
    local hasBar = false
    if cfg.HealthBar and health then
        hasBar = true
        self:Bar("health", x - 5, y, 2, h, health, true, cfg.HealthHigh, cfg.HealthMid, cfg.HealthLow, tr)
    end
    if cfg.HealthText and health then
        local value = d.healthValue
        if self.hpValue ~= value then
            self.hpValue = value
            self.hpStr = tostring(value)
        end
        local hc = ESP.HealthColor(health, cfg.HealthHigh, cfg.HealthMid, cfg.HealthLow)
        if hasBar then
            local ty = clamp(y + h - h * health - 5, y - 2, y + h - 10)
            self:Text("hptext", self.hpStr, x - 8, ty, 1, 0, ESP.GetFont(g.HealthFont), size, hc, hc, tr, false)
        else
            self:Text("hptext", self.hpStr, x - 4, y, 1, 0, ESP.GetFont(g.HealthFont), size, hc, hc, tr, false)
        end
    end

    if cfg.ArmorBar and d.armor then
        self:Bar("armor", x, y + h + 2, w, 2, d.armor, false, cfg.ArmorHigh, cfg.ArmorMid, cfg.ArmorLow, tr)
    end

    if cfg.Names and d.name then
        self:Text("name", d.name, x + w * 0.5, y - 4, 0.5, 1, ESP.GetFont(g.TextFont), size, cfg.NameColor, cfg.NameColor2, tr, animated)
    end

    local flagFont = ESP.GetFont(g.FlagsFont)
    if cfg.Distance and d.dist then
        if self.distValue ~= d.dist then
            self.distValue = d.dist
            self.distStr = "[" .. d.dist .. "m]"
        end
        self:Text("dist", self.distStr, x + w + 4, y - 1, 0, 0, flagFont, size, cfg.DistanceColor, cfg.DistanceColor2, tr, animated)
    end

    if cfg.Flags and d.nFlags and d.nFlags > 0 then
        local baseY = y + (cfg.Distance and (size + 1) or -1)
        for i = 1, d.nFlags do
            self:Text("flag" .. i, d.flags[i], x + w + 4, baseY + (i - 1) * size, 0, 0, flagFont, size, cfg.FlagColor1, cfg.FlagColor2, tr, animated)
        end
    end

    if cfg.Tool and d.tool then
        self:Text("tool", d.tool, x + w * 0.5, y + h + (cfg.ArmorBar and 6 or 2), 0.5, 0, ESP.GetFont(g.TextFont), size, cfg.ToolColor, cfg.ToolColor2, tr, animated)
    end

    if cfg.HeadDot and d.head then
        self:Dot("head", d.head.X, d.head.Y, cfg.HeadDotSize, cfg.HeadDotColor, tr, cfg.HeadDotOutlineThickness)
    end

    if cfg.Skeleton and d.nBones and d.nBones > 0 then
        local bones = d.bones
        local t = cfg.SkeletonThickness
        for i = 1, d.nBones do
            self:Line(bones[i * 2 - 1], bones[i * 2], t, cfg.SkeletonColor, cfg.SkeletonColor2, tr)
        end
    end

    if cfg.Tracers and d.tracerFrom then
        self:Line(d.tracerFrom, v2(x + w * 0.5, y + h), cfg.TracerThickness, cfg.TracerColor, nil, tr)
    end

    self:End()
end

local Games = {
    [79783567666809] = { bots = "IngameBots", containers = "Containers" },
    [138485390344924] = { bots = "IngameBots", containers = "Containers", characters = {"GameLogic", "Characters"}, skipPlayers = true },
}

local ITEM_KEYS = {
    ["Safe"] = "Safe", ["Civilian Airdrop"] = "CivilianAirdrop", ["Abandoned Car"] = "AbandonedCar",
    ["Duffel Bag"] = "DuffelBag", ["Food Crate"] = "FoodCrate", ["Leather Pouch"] = "LeatherPouch",
    ["Supply Crate"] = "SupplyCrate", ["Medical Pouch"] = "MedicalPouch", ["DroppedItemContainer"] = "DroppedItemContainer",
    ["T.C.R Supply Crate"] = "TCRCrate", ["Metal Crate"] = "MetalCrate", ["Specops Supply Crate"] = "SpecopsCrate",
    ["Tall Metal Crate"] = "TallMetalCrate", ["Wooden Crate"] = "WoodenCrate", ["Ammo Box"] = "AmmoBox",
}
local ITEM_KEYWORDS = {
    "Safe", "Civilian Airdrop", "Abandoned Car", "Duffel Bag", "Food Crate", "Leather Pouch", "Supply Crate",
    "Medical Pouch", "DroppedItemContainer", "T.C.R Supply Crate", "Metal Crate", "Specops Supply Crate",
    "Tall Metal Crate", "Wooden Crate", "Ammo Box",
}

local function classifyItem(name)
    if string.find(name, "Dead", 1, true) then return "Dead" end
    for i = 1, #ITEM_KEYWORDS do
        if string.find(name, ITEM_KEYWORDS[i], 1, true) then return ITEM_KEYS[ITEM_KEYWORDS[i]] end
    end
    return nil
end

local state = {
    running = false, gui = nil, records = {}, players = {}, bots = {}, containers = {},
    itemMeta = {}, itemRenderer = nil, connections = {}, fade = 1, dead = false,
    lastUpdate = 0, lastSweep = 0, anyLast = false, itemsLast = false,
}

local gameInfo = Games[game.PlaceId]

local function guiParent()
    if typeof(gethui) == "function" then
        local ok, ui = pcall(gethui)
        if ok and ui then return cloneref(ui) end
    end
    local ok, cg = pcall(function() return svc("CoreGui") end)
    if ok and cg then return cg end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local function createGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = HttpService:GenerateGUID(false)
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 900
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = guiParent()
    state.gui = gui
    state.itemRenderer = Renderer.new(gui)
end

local function setHighlight(rec, field, adornee, fill, fillTr, outline, outlineTr)
    local hl = rec[field]
    if not hl then
        hl = Instance.new("Highlight")
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Enabled = false
        hl.Parent = state.gui
        rec[field] = hl
    end
    if hl.Adornee ~= adornee then hl.Adornee = adornee end
    hl.FillColor = fill
    hl.FillTransparency = fillTr
    hl.OutlineColor = outline
    hl.OutlineTransparency = outlineTr
    if not hl.Enabled then hl.Enabled = true end
end

local function clearHighlight(rec, field)
    local hl = rec[field]
    if hl and hl.Enabled then hl.Enabled = false end
end

local function newRecord(entity)
    return {
        entity = entity, renderer = Renderer.new(state.gui),
        d = { pts = {}, vis = {}, bones = {}, flags = {}, nFlags = 0, nBones = 0 },
        parts = {}, nParts = 0, boneParts = {}, nBones = 0,
        seen = 0, scanned = 0, teamAt = -1, team = false,
    }
end

local function destroyRecord(rec)
    rec.renderer:Destroy()
    if rec.chams then rec.chams:Destroy() end
    if rec.fill then rec.fill:Destroy() end
end

local function hideRecord(rec)
    rec.renderer:Clear()
    clearHighlight(rec, "chams")
    clearHighlight(rec, "fill")
end

local function rescan(rec, now)
    local character = rec.character
    rec.scanned = now
    local parts, n = rec.parts, 0
    table.clear(parts)
    for _, name in ipairs(rec.isR15 and R15_PARTS or R6_PARTS) do
        local p = character:FindFirstChild(name)
        if p and p:IsA("BasePart") then
            n += 1
            parts[n] = p
        end
    end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Accessory") then
            local handle = child:FindFirstChild("Handle")
            if handle and handle:IsA("BasePart") then
                n += 1
                parts[n] = handle
            end
        end
    end
    rec.nParts = n

    local bones, nb = rec.boneParts, 0
    table.clear(bones)
    for _, pair in ipairs(rec.isR15 and R15_BONES or R6_BONES) do
        local a, b = character:FindFirstChild(pair[1]), character:FindFirstChild(pair[2])
        if a and b and a:IsA("BasePart") and b:IsA("BasePart") then
            nb += 1
            bones[nb * 2 - 1] = a
            bones[nb * 2] = b
        end
    end
    rec.nBones = nb
end

local function bindCharacter(rec, character, now)
    rec.character = character
    rec.humanoid = character:FindFirstChildOfClass("Humanoid")
    rec.hrp = character:FindFirstChild("HumanoidRootPart")
    rec.head = character:FindFirstChild("Head")
    rec.isR15 = character:FindFirstChild("UpperTorso") ~= nil
    rescan(rec, now)
end

local function computeBounds(parts, n)
    local mnx, mny, mnz, mxx, mxy, mxz = huge, huge, huge, -huge, -huge, -huge
    for i = 1, n do
        local p = parts[i]
        if p.Parent then
            local s = p.Size
            local hx, hy, hz = s.X * 0.5, s.Y * 0.5, s.Z * 0.5
            local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = p.CFrame:GetComponents()
            local ex = abs(r00) * hx + abs(r01) * hy + abs(r02) * hz
            local ey = abs(r10) * hx + abs(r11) * hy + abs(r12) * hz
            local ez = abs(r20) * hx + abs(r21) * hy + abs(r22) * hz
            if x - ex < mnx then mnx = x - ex end
            if y - ey < mny then mny = y - ey end
            if z - ez < mnz then mnz = z - ez end
            if x + ex > mxx then mxx = x + ex end
            if y + ey > mxy then mxy = y + ey end
            if z + ez > mxz then mxz = z + ez end
        end
    end
    return mnx, mny, mnz, mxx, mxy, mxz
end

local function tracerOrigin(mode, viewport)
    if mode == "Top" then return v2(viewport.X * 0.5, 0) end
    if mode == "Center" then return v2(viewport.X * 0.5, viewport.Y * 0.5) end
    if mode == "Mouse" then return UserInputService:GetMouseLocation() end
    return v2(viewport.X * 0.5, viewport.Y)
end

local function collectFlags(rec, entity, character, humanoid, cfg)
    local d = rec.d
    local out, n = d.flags, 0
    local selected = cfg.SelectedFlags
    local wantWalk = table.find(selected, "Walking")
    local wantJump = table.find(selected, "Jumping")
    local wantSwim = table.find(selected, "Swimming")
    if wantWalk and humanoid.MoveDirection.Magnitude > 0 then
        n += 1
        out[n] = "Walking"
    end
    if wantJump or wantSwim then
        local ok, st = pcall(humanoid.GetState, humanoid)
        if ok then
            if wantJump and (st == Enum.HumanoidStateType.Freefall or st == Enum.HumanoidStateType.Jumping) then
                n += 1
                out[n] = "Jumping"
            end
            if wantSwim and st == Enum.HumanoidStateType.Swimming then
                n += 1
                out[n] = "Swimming"
            end
        end
    end
    for name, fn in pairs(ESP.CustomFlags) do
        if table.find(selected, name) then
            local ok, res = pcall(fn, entity, character, humanoid)
            if ok and res then
                n += 1
                out[n] = name
            end
        end
    end
    d.nFlags = n
end

local function processEntity(entity, isPlayer, cam, camPos, viewport, now, fade)
    local S = ESP.Settings
    local rec = state.records[entity]

    local isTeam = false
    if isPlayer then
        if rec and now - rec.teamAt < 0.5 then
            isTeam = rec.team
        else
            isTeam = ESP.IsTeam(entity) and true or false
            if rec then
                rec.team, rec.teamAt = isTeam, now
            end
        end
    end

    local cfg = isPlayer and (isTeam and S.Teammate or S.Enemy) or S.AI
    if not cfg.Enabled then
        if rec then hideRecord(rec) end
        return
    end

    local character = isPlayer and entity.Character or entity
    if not character or not character.Parent then
        if rec then hideRecord(rec) end
        return
    end

    if isPlayer then
        local inRaid = entity:FindFirstChild("InRaid")
        if inRaid and inRaid:IsA("BoolValue") and not inRaid.Value then
            if rec then hideRecord(rec) end
            return
        end
    end

    if not rec then
        rec = newRecord(entity)
        rec.team, rec.teamAt = isTeam, now
        state.records[entity] = rec
    end
    rec.seen = now

    if rec.character ~= character or not rec.hrp or not rec.hrp.Parent or not rec.humanoid then
        bindCharacter(rec, character, now)
    elseif now - rec.scanned > 2 then
        rescan(rec, now)
    end

    local humanoid, hrp = rec.humanoid, rec.hrp
    if not (humanoid and hrp) or humanoid.Health <= 0 then
        hideRecord(rec)
        return
    end

    local hrpPos = hrp.Position
    local dist = (hrpPos - camPos).Magnitude
    if dist > S.MaxDistance * STUDS_PER_METER then
        hideRecord(rec)
        return
    end
    if cam:WorldToViewportPoint(hrpPos).Z <= 0 then
        hideRecord(rec)
        return
    end

    local mnx, mny, mnz, mxx, mxy, mxz = computeBounds(rec.parts, rec.nParts)
    if mnx == huge then
        hideRecord(rec)
        return
    end

    local d = rec.d
    local pts, vis = d.pts, d.vis
    local minX, minY, maxX, maxY, seen = huge, huge, -huge, -huge, 0
    for i = 1, 8 do
        local p = cam:WorldToViewportPoint(v3(XS[i] == 1 and mxx or mnx, YS[i] == 1 and mxy or mny, ZS[i] == 1 and mxz or mnz))
        local ok = p.Z > 0
        pts[i] = v2(p.X, p.Y)
        vis[i] = ok
        if ok then
            seen += 1
            if p.X < minX then minX = p.X end
            if p.Y < minY then minY = p.Y end
            if p.X > maxX then maxX = p.X end
            if p.Y > maxY then maxY = p.Y end
        end
    end
    if seen == 0 then
        hideRecord(rec)
        return
    end

    d.x = floor(minX - 4 + 0.5)
    d.y = floor(minY - 4 + 0.5)
    d.w = max(floor(maxX - minX + 8 + 0.5), 8)
    d.h = max(floor(maxY - minY + 8 + 0.5), 8)
    d.fade = fade
    d.dist = floor(dist / STUDS_PER_METER + 0.5)

    d.health = clamp(humanoid.Health / max(humanoid.MaxHealth, 1), 0, 1)
    d.healthValue = floor(humanoid.Health + 0.5)

    if cfg.ArmorBar then
        local armor = character:FindFirstChild("Armor")
        d.armor = (armor and armor:IsA("NumberValue") and armor.Value > 0) and clamp(armor.Value / 100, 0, 1) or 1
    else
        d.armor = nil
    end

    if cfg.Names then
        if isPlayer then
            local nt = cfg.NameType
            if rec.nameType ~= nt then
                rec.nameType = nt
                if nt == "Display" then
                    rec.nameStr = entity.DisplayName
                elseif nt == "Username" then
                    rec.nameStr = entity.Name
                else
                    rec.nameStr = entity.DisplayName .. " (@" .. entity.Name .. ")"
                end
            end
            d.name = rec.nameStr
        else
            d.name = character.Name
        end
    else
        d.name = nil
    end

    if cfg.Tool then
        local tool = character:FindFirstChildOfClass("Tool")
        d.tool = tool and tool.Name or "None"
    else
        d.tool = nil
    end

    if cfg.Flags then
        collectFlags(rec, entity, character, humanoid, cfg)
    else
        d.nFlags = 0
    end

    if cfg.HeadDot and rec.head and rec.head.Parent then
        local hp = cam:WorldToViewportPoint(rec.head.Position)
        d.head = hp.Z > 0 and v2(hp.X, hp.Y) or nil
    else
        d.head = nil
    end

    if cfg.Skeleton then
        local bones, count = d.bones, 0
        local parts = rec.boneParts
        for i = 1, rec.nBones do
            local a, b = parts[i * 2 - 1], parts[i * 2]
            if a.Parent and b.Parent then
                local pa, pb = cam:WorldToViewportPoint(a.Position), cam:WorldToViewportPoint(b.Position)
                if pa.Z > 0 and pb.Z > 0 then
                    count += 1
                    bones[count * 2 - 1] = v2(pa.X, pa.Y)
                    bones[count * 2] = v2(pb.X, pb.Y)
                end
            end
        end
        d.nBones = count
    else
        d.nBones = 0
    end

    d.tracerFrom = cfg.Tracers and tracerOrigin(cfg.TracerOrigin, viewport) or nil

    rec.renderer:Draw(d, cfg, S)

    if cfg.Chams then
        local glow = cfg.ChamsGlow
        setHighlight(
            rec, "chams", character, cfg.ChamsColor, 1 - (1 - cfg.ChamsFillTransparency) * fade,
            glow and cfg.ChamsColor or BLACK, glow and (1 - fade) or 1
        )
    else
        clearHighlight(rec, "chams")
    end

    if cfg.BoxEnabled and cfg.BoxFill and cfg.BoxType == "3D" then
        setHighlight(rec, "fill", character, cfg.BoxFillColor1, 1 - (1 - cfg.BoxFillTransparency) * fade, cfg.LineColor, 1)
    else
        clearHighlight(rec, "fill")
    end
end

local function itemContents(item)
    local slots = item:FindFirstChild("Slots")
    if not slots then return nil end
    local out = {}
    for _, slot in ipairs(slots:GetChildren()) do
        if string.match(slot.Name, "^Slot%d+$") then
            local nameValue = slot:FindFirstChild("ItemName")
            local stack = slot:FindFirstChild("Stack")
            if nameValue and stack and stack:IsA("IntValue") and stack.Value > 0 then
                local label = nameValue:IsA("StringValue") and nameValue.Value or tostring(nameValue)
                out[#out + 1] = label .. " (" .. stack.Value .. ")"
            end
        end
    end
    if #out == 0 then return nil end
    local text = table.concat(out, " | ")
    if #text > 60 then text = string.sub(text, 1, 57) .. "..." end
    return text
end

local function processItems(cam, camPos, now, fade)
    local S = ESP.Settings
    local cfg = S.Items
    local r = state.itemRenderer
    r:Begin()

    if cfg.Enabled and gameInfo then
        local list = state.containers
        local limit = cfg.MaxDistance * STUDS_PER_METER
        local font = ESP.GetFont(S.TextFont)
        local flagFont = ESP.GetFont(S.FlagsFont)
        local size = cfg.TextSize
        local tr = 1 - fade

        for i = 1, #list do
            local item = list[i]
            if item.Parent and item:IsA("Model") then
                local meta = state.itemMeta[item]
                if not meta or meta.name ~= item.Name then
                    meta = meta or {}
                    meta.name = item.Name
                    meta.key = classifyItem(item.Name)
                    state.itemMeta[item] = meta
                end

                local entry = meta.key and cfg[meta.key]
                local drawn = false
                if entry and entry.Enabled then
                    local pivot = item:GetPivot().Position
                    local dist = (pivot - camPos).Magnitude
                    if dist <= limit then
                        local sp = cam:WorldToViewportPoint(pivot)
                        if sp.Z > 0 then
                            drawn = true
                            local color = entry.Color
                            local meters = floor(dist / STUDS_PER_METER + 0.5)
                            local label
                            if cfg.ShowNames and cfg.ShowDistance then
                                label = meta.name .. " [" .. meters .. "m]"
                            elseif cfg.ShowNames then
                                label = meta.name
                            elseif cfg.ShowDistance then
                                label = "[" .. meters .. "m]"
                            end
                            if label then
                                r:Text(item, label, sp.X, sp.Y - 12, 0.5, 0.5, cfg.ShowDistance and flagFont or font, size, color, color, tr, false)
                            end
                            if cfg.ShowContents then
                                if not meta.contentsAt or now - meta.contentsAt > 0.5 then
                                    meta.contentsAt = now
                                    meta.contents = itemContents(item)
                                end
                                if meta.contents then
                                    r:Text(item.Name .. tostring(item:GetDebugId(0)) .. "c", meta.contents, sp.X, sp.Y + 16, 0.5, 0.5, font, size - 1, color, color, tr, false)
                                end
                            end
                            if cfg.Chams then
                                setHighlight(meta, "hl", item, color, 1 - (1 - cfg.ChamsFillTransparency) * fade, BLACK, 1)
                            end
                        end
                    end
                end
                if not drawn or not cfg.Chams then clearHighlight(meta, "hl") end
            end
        end
    else
        if state.itemsLast then
            for _, meta in pairs(state.itemMeta) do clearHighlight(meta, "hl") end
        end
    end

    state.itemsLast = cfg.Enabled and gameInfo ~= nil
    r:End()
end

local function sweep(now)
    for entity, rec in pairs(state.records) do
        local gone = typeof(entity) == "Instance" and entity.Parent == nil
        if gone or now - rec.seen > 10 then
            destroyRecord(rec)
            state.records[entity] = nil
        end
    end
    for item, meta in pairs(state.itemMeta) do
        if not item.Parent then
            if meta.hl then meta.hl:Destroy() end
            state.itemMeta[item] = nil
        end
    end
end

local function step()
    local S = ESP.Settings
    state.fade = state.dead and max(0, state.fade - 0.05) or min(1, state.fade + 0.05)

    local cam = Workspace.CurrentCamera
    if not cam then return end

    local now = os.clock()
    if now - state.lastUpdate < 1 / clamp(S.RefreshRate, 30, 360) then return end
    state.lastUpdate = now

    local camPos = cam.CFrame.Position
    local viewport = cam.ViewportSize
    local fade = state.fade

    local anyEntity = S.Enemy.Enabled or S.Teammate.Enabled or S.AI.Enabled
    if anyEntity then
        state.anyLast = true
        if not (gameInfo and gameInfo.skipPlayers) then
            local players = state.players
            for i = 1, #players do
                processEntity(players[i], true, cam, camPos, viewport, now, fade)
            end
        end
        local bots = state.bots
        for i = 1, #bots do
            local bot = bots[i]
            if bot.Parent then processEntity(bot, false, cam, camPos, viewport, now, fade) end
        end
    elseif state.anyLast then
        state.anyLast = false
        for _, rec in pairs(state.records) do hideRecord(rec) end
    end

    processItems(cam, camPos, now, fade)

    if now - state.lastSweep > 5 then
        state.lastSweep = now
        sweep(now)
    end
end

local function removeFrom(list, value)
    local idx = table.find(list, value)
    if idx then table.remove(list, idx) end
end

local function watchFolder(folder, list, onRemoved)
    for _, child in ipairs(folder:GetChildren()) do
        if child:IsA("Model") then list[#list + 1] = child end
    end
    state.connections[#state.connections + 1] = folder.ChildAdded:Connect(function(child)
        if child:IsA("Model") then list[#list + 1] = child end
    end)
    state.connections[#state.connections + 1] = folder.ChildRemoved:Connect(function(child)
        removeFrom(list, child)
        if onRemoved then onRemoved(child) end
    end)
end

local function dropRecord(entity)
    local rec = state.records[entity]
    if rec then
        destroyRecord(rec)
        state.records[entity] = nil
    end
end

function ESP:Start()
    if state.running then return end
    state.running = true
    createGui()

    local function onCharacter(char)
        local hum = char:WaitForChild("Humanoid", 10)
        state.dead = false
        state.fade = 1
        if hum then
            hum.Died:Connect(function() state.dead = true end)
        end
    end
    if LocalPlayer.Character then task.spawn(onCharacter, LocalPlayer.Character) end
    state.connections[#state.connections + 1] = LocalPlayer.CharacterAdded:Connect(onCharacter)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then state.players[#state.players + 1] = plr end
    end
    state.connections[#state.connections + 1] = Players.PlayerAdded:Connect(function(plr)
        if plr ~= LocalPlayer then state.players[#state.players + 1] = plr end
    end)
    state.connections[#state.connections + 1] = Players.PlayerRemoving:Connect(function(plr)
        removeFrom(state.players, plr)
        dropRecord(plr)
    end)

    if gameInfo then
        if gameInfo.bots then
            local folder = Workspace:FindFirstChild(gameInfo.bots)
            if folder then watchFolder(folder, state.bots, dropRecord) end
        end
        if gameInfo.containers then
            local folder = Workspace:FindFirstChild(gameInfo.containers)
            if folder then watchFolder(folder, state.containers, function(item)
                local meta = state.itemMeta[item]
                if meta and meta.hl then meta.hl:Destroy() end
                state.itemMeta[item] = nil
            end) end
        end
        if gameInfo.characters then
            local node = Workspace
            for _, name in ipairs(gameInfo.characters) do
                node = node and node:FindFirstChild(name)
            end
            if node then watchFolder(node, state.bots, dropRecord) end
        end
    end

    RunService:BindToRenderStep(STEP_NAME, Enum.RenderPriority.Camera.Value + 1, step)
end

function ESP:Stop()
    if not state.running then return end
    state.running = false
    pcall(function() RunService:UnbindFromRenderStep(STEP_NAME) end)
    for _, c in ipairs(state.connections) do c:Disconnect() end
    table.clear(state.connections)
    table.clear(state.players)
    table.clear(state.bots)
    table.clear(state.containers)
    table.clear(state.records)
    table.clear(state.itemMeta)
    state.anyLast, state.itemsLast = false, false
    if state.gui then
        state.gui:Destroy()
        state.gui = nil
    end
    state.itemRenderer = nil
end

function ESP:Restart()
    self:Stop()
    self:Start()
end

function ESP:Toggle()
    if state.running then self:Stop() else self:Start() end
end

function ESP:IsRunning()
    return state.running
end

function ESP:UpdateSettings(new)
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

function ESP:GetSettings()
    return self.Settings
end

return ESP
