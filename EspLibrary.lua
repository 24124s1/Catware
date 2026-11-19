print('2')

local cloneref = cloneref or function(o) return o end

local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local HttpService = cloneref(game:GetService("HttpService"))
local LocalPlayer = Players.LocalPlayer

local rgb = Color3.fromRGB

local espModule = {}

local function entitySettings(p)
    return {
        Enabled = false,
        BoxEnabled = false, BoxType = "Corner", Thickness = 1, LineColor = p.main,
        BoxGlow = false,
        BoxFill = false, BoxFillColor1 = p.fill1, BoxFillColor2 = p.fill2, BoxFillTransparency = 0.7,
        BoxFillRotation = 0, BoxFillSpeed = 2,
        Chams = false, ChamsColor = p.main, ChamsGlow = false, ChamsFillTransparency = 0.3,
        Names = false, NameType = "Display", NameColor = p.text1, NameColor2 = p.text2,
        Distance = false, DistanceColor = p.text1, DistanceColor2 = p.text2,
        Tool = false, ToolColor = p.text1, ToolColor2 = p.text2,
        Flags = false, SelectedFlags = {"Walking", "Jumping", "Swimming", "Dih"},
        FlagColor1 = rgb(255, 255, 255), FlagColor2 = rgb(200, 200, 200),
        HealthBar = false, HealthText = false,
        HealthHigh = p.health[1], HealthMid = p.health[2], HealthLow = p.health[3],
        ArmorBar = false, ArmorHigh = rgb(0, 255, 0), ArmorMid = rgb(255, 255, 0), ArmorLow = rgb(255, 0, 0),
        HeadDot = false, HeadDotColor = rgb(255, 255, 255), HeadDotSize = 20, HeadDotOutlineThickness = 1,
        Skeleton = false, SkeletonThickness = 1, SkeletonColor = p.main, SkeletonColor2 = p.skel2,
        Tracers = false, TracerThickness = 1, TracerOrigin = "Bottom", TracerColor = p.main,
        TextSize = 12,
    }
end

espModule.Settings = {
    RefreshRate = 144,
    MaxDistance = 1200,
    BoxMode = "Dynamic",
    BoxSmoothing = 0.35,
    TextFont = "Gojiberry Quibble",
    FlagsFont = "Gojiberry Quibble",
    HealthFont = "Gojiberry Quibble",
    TextGradientAnimated = true,
    Enemy = entitySettings({
        main = rgb(255, 80, 80), fill1 = rgb(255, 80, 80), fill2 = rgb(255, 40, 40), skel2 = rgb(200, 200, 200),
        text1 = rgb(255, 255, 255), text2 = rgb(200, 200, 200),
        health = {rgb(0, 255, 100), rgb(255, 255, 0), rgb(255, 40, 40)},
    }),
    Teammate = entitySettings({
        main = rgb(0, 180, 255), fill1 = rgb(0, 180, 255), fill2 = rgb(0, 100, 200), skel2 = rgb(100, 150, 200),
        text1 = rgb(180, 230, 255), text2 = rgb(100, 150, 200),
        health = {rgb(0, 200, 255), rgb(100, 200, 255), rgb(30, 80, 140)},
    }),
    AI = entitySettings({
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

function espModule.GetAINames()
    return sortedKeys(espModule.CustomAIs)
end

function espModule.GetItemNames()
    return sortedKeys(espModule.CustomItems)
end

function espModule.GetFlagNames()
    local out = {"Walking", "Jumping", "Swimming"}
    for _, name in ipairs(sortedKeys(espModule.CustomFlags)) do out[#out + 1] = name end
    return out
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

local function getFont(name)
    return espModule.Fonts[name] or fallbackFont
end

local function loadFonts()
    local canLoad = typeof(writefile) == "function" and typeof(readfile) == "function"
        and typeof(isfile) == "function" and typeof(getcustomasset) == "function"

    if canLoad then
        if typeof(makefolder) == "function" and not (typeof(isfolder) == "function" and isfolder("catware_fonts")) then
            pcall(makefolder, "catware_fonts")
        end
        for _, entry in ipairs(fontFiles) do
            local name, file = entry[1], entry[2]
            if not espModule.Fonts[name] then
                local ok, font = pcall(function()
                    local path = "catware_fonts/" .. file
                    if not isfile(path) then
                        writefile(path, game:HttpGet("https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/fonts/" .. (file:gsub(" ", "%%20"))))
                        task.wait()
                    end
                    local jsonPath = "catware_fonts/" .. (name:gsub("%s", "_")) .. ".json"
                    writefile(jsonPath, HttpService:JSONEncode({
                        name = name,
                        faces = {{ name = "Regular", weight = 400, style = "normal", assetId = getcustomasset(path) }},
                    }))
                    return Font.new(getcustomasset(jsonPath), Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                end)
                if ok and font then espModule.Fonts[name] = font end
            end
        end
        if not espModule.Fonts["Tahoma"] then
            espModule.Fonts["Tahoma"] = espModule.Fonts["Tahoma Modern"] or espModule.Fonts["Tahoma 8px"]
        end
    end

    espModule.FontsReady = true
    for _, fn in ipairs(fontListeners) do task.spawn(fn) end
    table.clear(fontListeners)
end

espModule.IsTeam = function(plr)
    if not plr or plr == LocalPlayer then return false end
    if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then return true end
    local character = plr.Character
    return character ~= nil and character:FindFirstChild("SquadBillboard") ~= nil
end

function espModule:SetTeamCheck(fn)
    if type(fn) == "function" then self.IsTeam = fn end
end

task.spawn(function()
    local ok, fn = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/TeamCheck.lua"))()
    end)
    if ok and type(fn) == "function" then espModule.IsTeam = fn end
end)

function espModule.HealthColor(t, high, mid, low)
    t = math.clamp(t, 0, 1)
    if t >= 0.5 then return mid:Lerp(high, (t - 0.5) * 2) end
    return low:Lerp(mid, t * 2)
end

local view = {
    frame = 0, time = 0, dt = 0, fade = 1, angle = 0,
    x = 0, y = 0, z = 0, w = 0, h = 0, f = 0,
    r00 = 1, r01 = 0, r02 = 0, r10 = 0, r11 = 1, r12 = 0, r20 = 0, r21 = 0, r22 = 1,
}

local function updateView(cam)
    local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = cam.CFrame:GetComponents()
    local size = cam.ViewportSize
    view.x, view.y, view.z = x, y, z
    view.r00, view.r01, view.r02 = r00, r01, r02
    view.r10, view.r11, view.r12 = r10, r11, r12
    view.r20, view.r21, view.r22 = r20, r21, r22
    view.w, view.h = size.X, size.Y
    view.f = size.Y * 0.5 / math.tan(math.rad(cam.FieldOfView) * 0.5)
end

local function project(px, py, pz)
    local dx, dy, dz = px - view.x, py - view.y, pz - view.z
    local depth = -(dx * view.r02 + dy * view.r12 + dz * view.r22)
    if depth < 0.05 then return nil end
    local scale = view.f / depth
    return view.w * 0.5 + (dx * view.r00 + dy * view.r10 + dz * view.r20) * scale,
        view.h * 0.5 - (dx * view.r01 + dy * view.r11 + dz * view.r21) * scale,
        depth
end

local Renderer = {}
Renderer.__index = Renderer

local textX = {
    [0] = Enum.TextXAlignment.Left, [0.5] = Enum.TextXAlignment.Center, [1] = Enum.TextXAlignment.Right,
}
local textY = {
    [0] = Enum.TextYAlignment.Top, [0.5] = Enum.TextYAlignment.Center, [1] = Enum.TextYAlignment.Bottom,
}

local flagKeys = {}
for i = 1, 24 do flagKeys[i] = "flag" .. i end

local function addStroke(parent)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.new(0, 0, 0)
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.LineJoinMode = Enum.LineJoinMode.Miter
    stroke.Parent = parent
    return stroke
end

local function buildRect(root)
    local frame = Instance.new("Frame")
    frame.BorderSizePixel = 0
    frame.ZIndex = 3
    frame.Visible = false
    frame.Parent = root
    return { f = frame, s = addStroke(frame), shown = false }
end

local function buildLine(root)
    local frame = Instance.new("Frame")
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BorderSizePixel = 0
    frame.ZIndex = 3
    frame.Visible = false
    frame.Parent = root
    local gradient = Instance.new("UIGradient")
    gradient.Parent = frame
    return { f = frame, s = addStroke(frame), g = gradient, shown = false }
end

local function buildText(root)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.BorderSizePixel = 0
    label.AutomaticSize = Enum.AutomaticSize.XY
    label.Size = UDim2.new()
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.ZIndex = 5
    label.Visible = false
    label.Parent = root
    local gradient = Instance.new("UIGradient")
    gradient.Parent = label
    return { root = label, grad = gradient }
end

local function buildBar(root)
    local container = Instance.new("Frame")
    container.BackgroundColor3 = rgb(15, 15, 15)
    container.BorderSizePixel = 0
    container.ZIndex = 3
    container.Visible = false
    container.Parent = root
    local stroke = addStroke(container)
    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Color3.new(1, 1, 1)
    fill.BorderSizePixel = 0
    fill.ZIndex = 4
    fill.Parent = container
    local gradient = Instance.new("UIGradient")
    gradient.Parent = fill
    return { root = container, stroke = stroke, fill = fill, grad = gradient }
end

local function buildFill(root)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.new(1, 1, 1)
    frame.BorderSizePixel = 0
    frame.ZIndex = 1
    frame.Visible = false
    frame.Parent = root
    local gradient = Instance.new("UIGradient")
    gradient.Parent = frame
    return { root = frame, grad = gradient }
end

local function buildGlow(root)
    local image = Instance.new("ImageLabel")
    image.Image = "rbxassetid://110204605000367"
    image.ScaleType = Enum.ScaleType.Slice
    image.SliceCenter = Rect.new(21, 21, 79, 79)
    image.BackgroundTransparency = 1
    image.BorderSizePixel = 0
    image.ZIndex = 0
    image.Visible = false
    image.Parent = root
    return { root = image }
end

local function buildDot(root)
    local frame = Instance.new("Frame")
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BorderSizePixel = 0
    frame.ZIndex = 6
    frame.Visible = false
    frame.Parent = root
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = frame
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.new(0, 0, 0)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Enabled = false
    stroke.Parent = frame
    return { root = frame, stroke = stroke }
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
        nRect = 0, nLine = 0, hiRect = 0, hiLine = 0, frame = 0,
    }, Renderer)
end

function Renderer:Begin()
    self.frame += 1
    self.nRect, self.nLine = 0, 0
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

    local frame, list = self.frame, self.keyList
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
    if r.x ~= x or r.y ~= y then
        r.x, r.y = x, y
        f.Position = UDim2.fromOffset(x, y)
    end
    if r.w ~= w or r.h ~= h then
        r.w, r.h = w, h
        f.Size = UDim2.fromOffset(w, h)
    end
    if r.color ~= color then
        r.color = color
        f.BackgroundColor3 = color
    end
    if r.tr ~= tr then
        r.tr = tr
        f.BackgroundTransparency = tr
        r.s.Transparency = tr
    end
    if not r.shown then
        r.shown = true
        f.Visible = true
    end
end

function Renderer:Line(ax, ay, bx, by, thickness, c1, c2, tr)
    local n = self.nLine + 1
    self.nLine = n
    local l = self.lines[n]
    if not l then
        l = buildLine(self.root)
        self.lines[n] = l
    end
    local dx, dy = bx - ax, by - ay
    local len = math.max(math.sqrt(dx * dx + dy * dy), 1)
    local cx, cy = (ax + bx) * 0.5, (ay + by) * 0.5
    local rot = math.deg(math.atan2(dy, dx))
    local f = l.f
    if l.cx ~= cx or l.cy ~= cy then
        l.cx, l.cy = cx, cy
        f.Position = UDim2.fromOffset(cx, cy)
    end
    if l.len ~= len or l.th ~= thickness then
        l.len, l.th = len, thickness
        f.Size = UDim2.fromOffset(len, thickness)
    end
    if l.rot ~= rot then
        l.rot = rot
        f.Rotation = rot
    end
    if l.tr ~= tr then
        l.tr = tr
        f.BackgroundTransparency = tr
        l.s.Transparency = tr
    end
    if l.c1 ~= c1 or l.c2 ~= c2 then
        l.c1, l.c2 = c1, c2
        if c2 then
            f.BackgroundColor3 = Color3.new(1, 1, 1)
            l.g.Color = ColorSequence.new(c1, c2)
        else
            f.BackgroundColor3 = c1
            l.g.Color = ColorSequence.new(Color3.new(1, 1, 1))
        end
    end
    if not l.shown then
        l.shown = true
        f.Visible = true
    end
end

function Renderer:Fill(x, y, w, h, c1, c2, rotation, tr)
    local k = self:Keyed("fill", buildFill)
    local f = k.root
    if k.x ~= x or k.y ~= y then
        k.x, k.y = x, y
        f.Position = UDim2.fromOffset(x, y)
    end
    if k.w ~= w or k.h ~= h then
        k.w, k.h = w, h
        f.Size = UDim2.fromOffset(w, h)
    end
    if k.tr ~= tr then
        k.tr = tr
        f.BackgroundTransparency = tr
    end
    if k.c1 ~= c1 or k.c2 ~= c2 then
        k.c1, k.c2 = c1, c2
        k.grad.Color = ColorSequence.new(c1, c2)
    end
    k.grad.Rotation = rotation
end

function Renderer:Glow(x, y, w, h, color, tr)
    local k = self:Keyed("glow", buildGlow)
    local i = k.root
    if k.x ~= x or k.y ~= y then
        k.x, k.y = x, y
        i.Position = UDim2.fromOffset(x - 21, y - 21)
    end
    if k.w ~= w or k.h ~= h then
        k.w, k.h = w, h
        i.Size = UDim2.fromOffset(w + 42, h + 42)
    end
    if k.color ~= color then
        k.color = color
        i.ImageColor3 = color
    end
    if k.tr ~= tr then
        k.tr = tr
        i.ImageTransparency = 0.35 + 0.65 * tr
    end
end

function Renderer:Dot(x, y, size, color, tr, outline)
    local k = self:Keyed("head", buildDot)
    local f = k.root
    if k.x ~= x or k.y ~= y then
        k.x, k.y = x, y
        f.Position = UDim2.fromOffset(x, y)
    end
    if k.size ~= size then
        k.size = size
        f.Size = UDim2.fromOffset(size, size)
    end
    if k.color ~= color then
        k.color = color
        f.BackgroundColor3 = color
    end
    if k.tr ~= tr then
        k.tr = tr
        f.BackgroundTransparency = tr
        k.stroke.Transparency = tr
    end
    if k.outline ~= outline then
        k.outline = outline
        k.stroke.Enabled = outline > 0
        if outline > 0 then k.stroke.Thickness = outline end
    end
end

function Renderer:Bar(key, x, y, w, h, ratio, vertical, high, mid, low, tr)
    local k = self:Keyed(key, buildBar)
    local c = k.root
    if k.x ~= x or k.y ~= y then
        k.x, k.y = x, y
        c.Position = UDim2.fromOffset(x, y)
    end
    if k.w ~= w or k.h ~= h then
        k.w, k.h = w, h
        c.Size = UDim2.fromOffset(w, h)
    end
    if k.tr ~= tr then
        k.tr = tr
        c.BackgroundTransparency = tr
        k.stroke.Transparency = tr
        k.fill.BackgroundTransparency = tr
    end
    if k.vertical ~= vertical then
        k.vertical = vertical
        if vertical then
            k.fill.AnchorPoint = Vector2.new(0, 1)
            k.fill.Position = UDim2.fromScale(0, 1)
            k.grad.Rotation = 90
        else
            k.fill.AnchorPoint = Vector2.new(0, 0)
            k.fill.Position = UDim2.fromScale(0, 0)
            k.grad.Rotation = 0
        end
        k.ratio = nil
    end
    if k.ratio ~= ratio then
        k.ratio = ratio
        k.fill.Size = vertical and UDim2.fromScale(1, ratio) or UDim2.fromScale(ratio, 1)
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
        k.text = str
        l.Text = str
    end
    if k.font ~= font then
        k.font = font
        l.FontFace = font
    end
    if k.size ~= size then
        k.size = size
        l.TextSize = size
    end
    if k.ax ~= ax or k.ay ~= ay then
        k.ax, k.ay = ax, ay
        l.AnchorPoint = Vector2.new(ax, ay)
        l.TextXAlignment = textX[ax]
        l.TextYAlignment = textY[ay]
    end
    if k.x ~= x or k.y ~= y then
        k.x, k.y = x, y
        l.Position = UDim2.fromOffset(x, y)
    end
    if k.c1 ~= c1 or k.c2 ~= c2 then
        k.c1, k.c2 = c1, c2
        k.grad.Color = ColorSequence.new(c1, c2 or c1)
    end
    local rotation = (animated and c1 ~= c2) and view.angle or 0
    if k.rotation ~= rotation then
        k.rotation = rotation
        k.grad.Rotation = rotation
    end
    if k.tr ~= tr then
        k.tr = tr
        l.TextTransparency = tr
        l.TextStrokeTransparency = tr
    end
end

local edges = {{1, 2}, {2, 3}, {3, 4}, {4, 1}, {5, 6}, {6, 7}, {7, 8}, {8, 5}, {1, 5}, {2, 6}, {3, 7}, {4, 8}}

function Renderer:Draw(d, cfg, g)
    self:Begin()

    local fade = d.fade
    local tr = 1 - fade
    local x, y, w, h = d.x, d.y, d.w, d.h
    local size = cfg.TextSize
    local animated = g.TextGradientAnimated

    if cfg.BoxEnabled then
        local t = math.max(1, cfg.Thickness)
        local color = cfg.LineColor
        local boxType = cfg.BoxType

        if cfg.BoxFill and boxType ~= "3D" then
            self:Fill(
                x, y, w, h, cfg.BoxFillColor1, cfg.BoxFillColor2,
                (cfg.BoxFillRotation + view.time * cfg.BoxFillSpeed * 60) % 360,
                1 - (1 - cfg.BoxFillTransparency) * fade
            )
        end
        if cfg.BoxGlow then self:Glow(x, y, w, h, color, tr) end

        if boxType == "Full" then
            self:Rect(x, y, w, t, color, tr)
            self:Rect(x, y + h - t, w, t, color, tr)
            self:Rect(x, y + t, t, h - 2 * t, color, tr)
            self:Rect(x + w - t, y + t, t, h - 2 * t, color, tr)
        elseif boxType == "3D" then
            local px, py, vis = d.px, d.py, d.vis
            for i = 1, 12 do
                local a, b = edges[i][1], edges[i][2]
                if vis[a] and vis[b] then self:Line(px[a], py[a], px[b], py[b], t, color, nil, tr) end
            end
        else
            local cw = math.max(2, math.floor(w * 0.28 + 0.5))
            local ch = math.max(2, math.floor(h * 0.22 + 0.5))
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
    local hasBar = cfg.HealthBar and health ~= nil
    if hasBar then
        self:Bar("health", x - 5, y, 2, h, health, true, cfg.HealthHigh, cfg.HealthMid, cfg.HealthLow, tr)
    end
    if cfg.HealthText and health then
        local value = d.healthValue
        if self.hpValue ~= value or self.hpHigh ~= cfg.HealthHigh or self.hpMid ~= cfg.HealthMid or self.hpLow ~= cfg.HealthLow then
            self.hpValue, self.hpHigh, self.hpMid, self.hpLow = value, cfg.HealthHigh, cfg.HealthMid, cfg.HealthLow
            self.hpText = tostring(value)
            self.hpColor = espModule.HealthColor(health, cfg.HealthHigh, cfg.HealthMid, cfg.HealthLow)
        end
        local font = getFont(g.HealthFont)
        if hasBar then
            local ty = math.clamp(y + h - h * health - 5, y - 2, y + h - 10)
            self:Text("hptext", self.hpText, x - 8, ty, 1, 0, font, size, self.hpColor, self.hpColor, tr, false)
        else
            self:Text("hptext", self.hpText, x - 4, y, 1, 0, font, size, self.hpColor, self.hpColor, tr, false)
        end
    end

    if cfg.ArmorBar and d.armor then
        self:Bar("armor", x, y + h + 2, w, 2, d.armor, false, cfg.ArmorHigh, cfg.ArmorMid, cfg.ArmorLow, tr)
    end

    if cfg.Names and d.name then
        self:Text("name", d.name, x + w * 0.5, y - 4, 0.5, 1, getFont(g.TextFont), size, cfg.NameColor, cfg.NameColor2, tr, animated)
    end

    local flagFont = getFont(g.FlagsFont)
    if cfg.Distance then
        if self.distValue ~= d.dist then
            self.distValue = d.dist
            self.distText = "[" .. d.dist .. "m]"
        end
        self:Text("dist", self.distText, x + w + 4, y - 1, 0, 0, flagFont, size, cfg.DistanceColor, cfg.DistanceColor2, tr, animated)
    end

    if cfg.Flags and d.nFlags > 0 then
        local baseY = y + (cfg.Distance and (size + 1) or -1)
        for i = 1, d.nFlags do
            self:Text(flagKeys[i] or ("flag" .. i), d.flags[i], x + w + 4, baseY + (i - 1) * size, 0, 0, flagFont, size, cfg.FlagColor1, cfg.FlagColor2, tr, animated)
        end
    end

    if cfg.Tool and d.tool then
        self:Text("tool", d.tool, x + w * 0.5, y + h + (cfg.ArmorBar and 6 or 2), 0.5, 0, getFont(g.TextFont), size, cfg.ToolColor, cfg.ToolColor2, tr, animated)
    end

    if cfg.HeadDot and d.headX then
        self:Dot(d.headX, d.headY, cfg.HeadDotSize, cfg.HeadDotColor, tr, cfg.HeadDotOutlineThickness)
    end

    if cfg.Skeleton and d.nBones > 0 then
        local bones, t = d.bones, cfg.SkeletonThickness
        for i = 0, d.nBones - 1 do
            local k = i * 4
            self:Line(bones[k + 1], bones[k + 2], bones[k + 3], bones[k + 4], t, cfg.SkeletonColor, cfg.SkeletonColor2, tr)
        end
    end

    if cfg.Tracers and d.tracerX then
        self:Line(d.tracerX, d.tracerY, x + w * 0.5, y + h, cfg.TracerThickness, cfg.TracerColor, nil, tr)
    end

    self:End()
end

local state = {
    running = false, gui = nil, records = {}, players = {}, itemRenderer = nil, itemMeta = {},
    connections = {}, dead = false, last = 0, hadEntities = false, hadItems = false,
    vms = {}, vmAt = -1,
}

local xs = {1, 0, 0, 1, 1, 0, 0, 1}
local ys = {1, 1, 0, 0, 1, 1, 0, 0}
local zs = {1, 1, 1, 1, 0, 0, 0, 0}

local r15Parts = {"HumanoidRootPart", "Head", "UpperTorso", "LowerTorso", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand"}
local r6Parts = {"HumanoidRootPart", "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
local vmParts = {"head", "torso", "arm1", "arm2", "leg1", "leg2", "shoulder1", "shoulder2", "hip1", "hip2"}

local r15Bones = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"LowerTorso", "LeftUpperLeg"}, {"LowerTorso", "RightUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"UpperTorso", "LeftUpperArm"},
    {"UpperTorso", "RightUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"RightUpperArm", "RightLowerArm"},
}
local r6Bones = {
    {"Head", "Torso"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
}
local vmBones = {
    {"head", "torso"}, {"torso", "shoulder1"}, {"shoulder1", "arm1"}, {"torso", "shoulder2"}, {"shoulder2", "arm2"},
    {"torso", "hip1"}, {"hip1", "leg1"}, {"torso", "hip2"}, {"hip2", "leg2"},
}

local function resolvePart(inst)
    if not inst then return nil end
    if inst:IsA("BasePart") then return inst end
    if inst:IsA("Model") and inst.PrimaryPart then return inst.PrimaryPart end
    return inst:FindFirstChildWhichIsA("BasePart", true)
end

local function collectParts(container, out)
    if not container then return end
    if container:IsA("BasePart") then
        if container.Name ~= "Base" then out[#out + 1] = container end
        return
    end
    for _, d in ipairs(container:GetDescendants()) do
        if d:IsA("BasePart") and d.Name ~= "Base" then out[#out + 1] = d end
    end
end

local function setHighlight(owner, field, adornee, fill, fillTr, outline, outlineTr)
    local h = owner[field]
    if not h then
        local hl = Instance.new("Highlight")
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Enabled = false
        hl.Parent = state.gui
        h = { hl = hl, on = false }
        owner[field] = h
    end
    local hl = h.hl
    if h.adornee ~= adornee then
        h.adornee = adornee
        hl.Adornee = adornee
    end
    if h.fill ~= fill then
        h.fill = fill
        hl.FillColor = fill
    end
    if h.fillTr ~= fillTr then
        h.fillTr = fillTr
        hl.FillTransparency = fillTr
    end
    if h.outline ~= outline then
        h.outline = outline
        hl.OutlineColor = outline
    end
    if h.outlineTr ~= outlineTr then
        h.outlineTr = outlineTr
        hl.OutlineTransparency = outlineTr
    end
    if not h.on then
        h.on = true
        hl.Enabled = true
    end
end

local function clearHighlight(owner, field)
    local h = owner[field]
    if h and h.on then
        h.on = false
        h.hl.Enabled = false
    end
end

local function newRecord(entity)
    return {
        entity = entity, renderer = Renderer.new(state.gui),
        d = { px = {}, py = {}, vis = {}, bones = {}, flags = {}, nFlags = 0, nBones = 0 },
        parts = {}, sizes = {}, n = 0, boneParts = {}, nBones = 0,
        touched = 0, seen = 0, hidden = true, scanned = 0, boundAt = 0, humanoidAt = 0,
        teamAt = -1, team = false, raidAt = -1, raid = false,
        flagsAt = -1, toolAt = -1, toolName = "None", armorAt = -1, armorRatio = 1,
        searchAt = -1, verdictAt = 0, unit = 2.81,
    }
end

local function hideRecord(rec)
    if rec.hidden then return end
    rec.hidden = true
    rec.sw = nil
    rec.renderer:Clear()
    clearHighlight(rec, "chams")
    clearHighlight(rec, "fillHl")
end

local function dropRecord(entity)
    local rec = state.records[entity]
    if not rec then return end
    rec.renderer:Destroy()
    if rec.chams then rec.chams.hl:Destroy() end
    if rec.fillHl then rec.fillHl.hl:Destroy() end
    state.records[entity] = nil
end

local function rescan(rec, options, viewmodel)
    local character = rec.character
    rec.scanned = view.time

    local parts = rec.parts
    table.clear(parts)
    local hitboxes = options and options.Hitboxes
    if viewmodel then
        for _, name in ipairs(vmParts) do collectParts(character:FindFirstChild(name), parts) end
        collectParts(character:FindFirstChild("Hitboxes"), parts)
        if #parts == 0 then collectParts(character, parts) end
    elseif type(hitboxes) == "function" then
        local ok, res = pcall(hitboxes, character)
        if ok and type(res) == "table" then
            for _, inst in ipairs(res) do collectParts(inst, parts) end
        end
    elseif type(hitboxes) == "table" then
        for _, name in ipairs(hitboxes) do collectParts(character:FindFirstChild(name), parts) end
    elseif rec.isRig then
        for _, name in ipairs(rec.isR15 and r15Parts or r6Parts) do
            local part = character:FindFirstChild(name)
            if part and part:IsA("BasePart") then parts[#parts + 1] = part end
        end
        for _, child in ipairs(character:GetChildren()) do
            if child:IsA("Accessory") then
                local handle = child:FindFirstChild("Handle")
                if handle and handle:IsA("BasePart") then parts[#parts + 1] = handle end
            end
        end
    else
        collectParts(character, parts)
    end

    local sizes = rec.sizes
    for i = 1, #parts do
        local s = parts[i].Size
        local k = i * 3
        sizes[k - 2], sizes[k - 1], sizes[k] = s.X * 0.5, s.Y * 0.5, s.Z * 0.5
    end
    rec.n = #parts

    local bones, count = rec.boneParts, 0
    table.clear(bones)
    local pairsList = viewmodel and vmBones or (rec.isRig and (rec.isR15 and r15Bones or r6Bones) or nil)
    if pairsList then
        for _, pair in ipairs(pairsList) do
            local a, b = resolvePart(character:FindFirstChild(pair[1])), resolvePart(character:FindFirstChild(pair[2]))
            if a and b then
                count += 1
                bones[count * 2 - 1], bones[count * 2] = a, b
            end
        end
    end
    rec.nBones = count

    rec.head = resolvePart(character:FindFirstChild(viewmodel and "head" or "Head"))
end

local function bindCharacter(rec, character, options, viewmodel)
    rec.character = character
    rec.boundAt = view.time
    rec.halfW, rec.halfH, rec.offY, rec.boundsAt = nil, nil, nil, -1
    if viewmodel then
        rec.humanoid = nil
        rec.root = resolvePart(character:FindFirstChild("torso"))
        rec.isRig, rec.isR15 = false, false
        rec.unit = 1
    else
        rec.humanoid = character:FindFirstChildOfClass("Humanoid")
        local root
        if options and type(options.Root) == "function" then
            local ok, res = pcall(options.Root, character)
            if ok then root = resolvePart(res) end
        end
        rec.root = root or resolvePart(character:FindFirstChild("HumanoidRootPart")) or character.PrimaryPart
            or character:FindFirstChildWhichIsA("BasePart", true)
        rec.isR15 = character:FindFirstChild("UpperTorso") ~= nil
        rec.isRig = rec.isR15 or character:FindFirstChild("Torso") ~= nil
        rec.unit = 2.81
    end
    rescan(rec, options, viewmodel)
end

local function liveBounds(rec)
    local parts, sizes = rec.parts, rec.sizes
    local mnx, mny, mnz, mxx, mxy, mxz = math.huge, math.huge, math.huge, -math.huge, -math.huge, -math.huge
    for i = 1, rec.n do
        local part = parts[i]
        if part.Parent then
            local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = part.CFrame:GetComponents()
            local k = i * 3
            local hx, hy, hz = sizes[k - 2], sizes[k - 1], sizes[k]
            local ex = math.abs(r00) * hx + math.abs(r01) * hy + math.abs(r02) * hz
            local ey = math.abs(r10) * hx + math.abs(r11) * hy + math.abs(r12) * hz
            local ez = math.abs(r20) * hx + math.abs(r21) * hy + math.abs(r22) * hz
            if x - ex < mnx then mnx = x - ex end
            if y - ey < mny then mny = y - ey end
            if z - ez < mnz then mnz = z - ez end
            if x + ex > mxx then mxx = x + ex end
            if y + ey > mxy then mxy = y + ey end
            if z + ez > mxz then mxz = z + ez end
        end
    end
    if mnx == math.huge then return nil end
    return mnx, mny, mnz, mxx, mxy, mxz
end

local function learnBounding(rec, rx, ry, rz)
    local parts, sizes = rec.parts, rec.sizes
    local lowest, highest, reachMax = math.huge, -math.huge, 0
    for i = 1, rec.n do
        local part = parts[i]
        if part.Parent then
            local x, y, z, _, _, _, r10, r11, r12 = part.CFrame:GetComponents()
            local k = i * 3
            local hx, hy, hz = sizes[k - 2], sizes[k - 1], sizes[k]
            local ey = math.abs(r10) * hx + math.abs(r11) * hy + math.abs(r12) * hz
            if y - ey < lowest then lowest = y - ey end
            if y + ey > highest then highest = y + ey end
            local ox, oz = x - rx, z - rz
            local reach = math.sqrt(ox * ox + oz * oz) + math.max(hx, hz)
            if reach > reachMax then reachMax = reach end
        end
    end
    if lowest == math.huge then return end
    local halfH = (highest - lowest) * 0.5
    local offY = (lowest + highest) * 0.5 - ry
    if not rec.halfW then
        rec.halfW, rec.halfH, rec.offY = reachMax, halfH, offY
        return
    end
    rec.halfW = reachMax > rec.halfW and reachMax or rec.halfW + (reachMax - rec.halfW) * 0.05
    rec.halfH = halfH > rec.halfH and halfH or rec.halfH + (halfH - rec.halfH) * 0.05
    rec.offY = rec.offY + (offY - rec.offY) * 0.2
end

local function modelBounds(rec, mode, rx, ry, rz)
    if mode == "Bounding" then
        if view.time - rec.boundsAt > 0.4 then
            rec.boundsAt = view.time
            learnBounding(rec, rx, ry, rz)
        end
        if not rec.halfW then return nil end
        local cy = ry + rec.offY
        return rx - rec.halfW, cy - rec.halfH, rz - rec.halfW, rx + rec.halfW, cy + rec.halfH, rz + rec.halfW
    end
    return liveBounds(rec)
end

local function projectBox(rec, d, mnx, mny, mnz, mxx, mxy, mxz, smoothing)
    local px, py, vis = d.px, d.py, d.vis
    local minX, minY, maxX, maxY, seen = math.huge, math.huge, -math.huge, -math.huge, 0
    for i = 1, 8 do
        local sx, sy = project(xs[i] == 1 and mxx or mnx, ys[i] == 1 and mxy or mny, zs[i] == 1 and mxz or mnz)
        if sx and math.abs(sx) < 50000 and math.abs(sy) < 50000 then
            px[i], py[i], vis[i] = sx, sy, true
            seen += 1
            if sx < minX then minX = sx end
            if sy < minY then minY = sy end
            if sx > maxX then maxX = sx end
            if sy > maxY then maxY = sy end
        else
            vis[i] = false
        end
    end
    if seen == 0 then return false end

    local pad = math.clamp((maxY - minY) * 0.02, 2, 6)
    minX, minY, maxX, maxY = minX - pad, minY - pad, maxX + pad, maxY + pad
    local w, h = maxX - minX, maxY - minY
    if w > 8000 or h > 8000 then return false end

    local cx, cy = (minX + maxX) * 0.5, (minY + maxY) * 0.5
    if smoothing > 0 and rec.sw and math.abs(w - rec.sw) < rec.sw * 0.6 and math.abs(h - rec.sh) < rec.sh * 0.6 then
        local a = 1 - smoothing ^ (view.dt * 60)
        rec.sw = rec.sw + (w - rec.sw) * a
        rec.sh = rec.sh + (h - rec.sh) * a
    else
        rec.sw, rec.sh = w, h
    end

    d.w = math.max(math.floor(rec.sw + 0.5), 8)
    d.h = math.max(math.floor(rec.sh + 0.5), 8)
    d.x = math.floor(cx - d.w * 0.5 + 0.5)
    d.y = math.floor(cy - d.h * 0.5 + 0.5)
    return true
end

local function render(rec, cfg, rx, ry, rz, dist)
    local settings = espModule.Settings
    local d = rec.d

    local mnx, mny, mnz, mxx, mxy, mxz = modelBounds(rec, settings.BoxMode, rx, ry, rz)
    if not mnx or not projectBox(rec, d, mnx, mny, mnz, mxx, mxy, mxz, settings.BoxSmoothing) then
        hideRecord(rec)
        return
    end

    d.fade = view.fade
    d.dist = math.floor(dist / rec.unit + 0.5)

    if cfg.HeadDot and rec.head and rec.head.Parent then
        local p = rec.head.Position
        d.headX, d.headY = project(p.X, p.Y, p.Z)
    else
        d.headX, d.headY = nil, nil
    end

    local count = 0
    if cfg.Skeleton then
        local bones, boneParts = d.bones, rec.boneParts
        for i = 1, rec.nBones do
            local a, b = boneParts[i * 2 - 1], boneParts[i * 2]
            if a.Parent and b.Parent then
                local pa, pb = a.Position, b.Position
                local ax, ay = project(pa.X, pa.Y, pa.Z)
                if ax then
                    local bx, by = project(pb.X, pb.Y, pb.Z)
                    if bx then
                        local k = count * 4
                        bones[k + 1], bones[k + 2], bones[k + 3], bones[k + 4] = ax, ay, bx, by
                        count += 1
                    end
                end
            end
        end
    end
    d.nBones = count

    if cfg.Tracers then
        local origin = cfg.TracerOrigin
        if origin == "Top" then
            d.tracerX, d.tracerY = view.w * 0.5, 0
        elseif origin == "Center" then
            d.tracerX, d.tracerY = view.w * 0.5, view.h * 0.5
        elseif origin == "Mouse" then
            local m = UserInputService:GetMouseLocation()
            d.tracerX, d.tracerY = m.X, m.Y
        else
            d.tracerX, d.tracerY = view.w * 0.5, view.h
        end
    else
        d.tracerX = nil
    end

    rec.hidden = false
    rec.seen = view.time
    rec.renderer:Draw(d, cfg, settings)

    if cfg.Chams then
        local glow = cfg.ChamsGlow
        setHighlight(
            rec, "chams", rec.character, cfg.ChamsColor, 1 - (1 - cfg.ChamsFillTransparency) * view.fade,
            glow and cfg.ChamsColor or Color3.new(0, 0, 0), glow and (1 - view.fade) or 1
        )
    else
        clearHighlight(rec, "chams")
    end

    if cfg.BoxEnabled and cfg.BoxFill and cfg.BoxType == "3D" then
        setHighlight(
            rec, "fillHl", rec.character, cfg.BoxFillColor1, 1 - (1 - cfg.BoxFillTransparency) * view.fade,
            cfg.LineColor, 1
        )
    else
        clearHighlight(rec, "fillHl")
    end
end

local function updateFlags(rec, entity, character, humanoid, cfg)
    local d = rec.d
    if not cfg.Flags then
        d.nFlags = 0
        return
    end
    if view.time - rec.flagsAt < 0.1 then return end
    rec.flagsAt = view.time

    local out = d.flags
    table.clear(out)
    local selected = cfg.SelectedFlags
    if humanoid then
        if table.find(selected, "Walking") and humanoid.MoveDirection.Magnitude > 0 then
            out[#out + 1] = "Walking"
        end
        local wantJump, wantSwim = table.find(selected, "Jumping"), table.find(selected, "Swimming")
        if wantJump or wantSwim then
            local ok, st = pcall(humanoid.GetState, humanoid)
            if ok then
                if wantJump and (st == Enum.HumanoidStateType.Freefall or st == Enum.HumanoidStateType.Jumping) then
                    out[#out + 1] = "Jumping"
                end
                if wantSwim and st == Enum.HumanoidStateType.Swimming then
                    out[#out + 1] = "Swimming"
                end
            end
        end
    end
    for name, flag in pairs(espModule.CustomFlags) do
        if table.find(selected, name) then
            local ok, res = pcall(flag.Func, entity, character, humanoid)
            if ok and res then out[#out + 1] = name end
        end
    end
    d.nFlags = #out
end

local function currentTool(rec, character, options)
    if view.time - rec.toolAt > 0.25 then
        rec.toolAt = view.time
        local name
        if options and type(options.Tool) == "function" then
            local ok, res = pcall(options.Tool, character)
            if ok and res then name = tostring(res) end
        else
            local tool = character:FindFirstChildOfClass("Tool")
            name = tool and tool.Name
        end
        rec.toolName = name or "None"
    end
    return rec.toolName
end

local function currentArmor(rec, character, options)
    if view.time - rec.armorAt > 0.5 then
        rec.armorAt = view.time
        local ratio = 1
        if options and type(options.Armor) == "function" then
            local ok, value, maxValue = pcall(options.Armor, character)
            if ok and type(value) == "number" then ratio = math.clamp(value / math.max(maxValue or 100, 1), 0, 1) end
        else
            local armor = character:FindFirstChild("Armor")
            if armor and armor:IsA("NumberValue") and armor.Value > 0 then
                ratio = math.clamp(armor.Value / 100, 0, 1)
            end
        end
        rec.armorRatio = ratio
    end
    return rec.armorRatio
end

local function playerName(rec, plr, nameType)
    if rec.nameType ~= nameType or rec.nameFor ~= plr then
        rec.nameType, rec.nameFor = nameType, plr
        if nameType == "Username" then
            rec.nameText = plr.Name
        elseif nameType == "Both" then
            rec.nameText = plr.DisplayName .. " (@" .. plr.Name .. ")"
        else
            rec.nameText = plr.DisplayName
        end
    end
    return rec.nameText
end

local function processEntity(entity, isPlayer, options, ownerName)
    local settings = espModule.Settings
    local now = view.time
    local rec = state.records[entity]

    local cfg
    if isPlayer then
        local team
        if rec and now - rec.teamAt < 0.5 then
            team = rec.team
        else
            team = espModule.IsTeam(entity) and true or false
            if rec then
                rec.team, rec.teamAt = team, now
            end
        end
        cfg = team and settings.Teammate or settings.Enemy
    else
        cfg = settings.AI
    end

    if rec then rec.touched = view.frame end
    if not cfg.Enabled then
        if rec then hideRecord(rec) end
        return
    end

    local character = isPlayer and entity.Character or entity
    if not character or not character.Parent then
        if rec then hideRecord(rec) end
        return
    end

    if not rec then
        rec = newRecord(entity)
        rec.team, rec.teamAt = cfg == settings.Teammate, now
        rec.owner = ownerName
        rec.touched = view.frame
        state.records[entity] = rec
    end

    if isPlayer then
        if now - rec.raidAt > 1 then
            rec.raidAt = now
            local value = entity:FindFirstChild("InRaid")
            rec.raid = (value and value:IsA("BoolValue")) and value or false
        end
        if rec.raid and not rec.raid.Value then
            hideRecord(rec)
            return
        end
    end

    if rec.character ~= character or not rec.root or not rec.root.Parent then
        bindCharacter(rec, character, options, false)
    elseif now - rec.scanned > 1.5 then
        rescan(rec, options, false)
    end

    local humanoid = rec.humanoid
    if not humanoid and now - rec.humanoidAt > 1 then
        rec.humanoidAt = now
        humanoid = character:FindFirstChildOfClass("Humanoid")
        rec.humanoid = humanoid
    end
    if humanoid and humanoid.Health <= 0 then
        hideRecord(rec)
        return
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
    local rx, ry, rz = rp.X, rp.Y, rp.Z
    local dx, dy, dz = rx - view.x, ry - view.y, rz - view.z
    local dist = math.sqrt(dx * dx + dy * dy + dz * dz)
    if dist > settings.MaxDistance or -(dx * view.r02 + dy * view.r12 + dz * view.r22) < 0.05 then
        hideRecord(rec)
        return
    end

    local d = rec.d
    if humanoid then
        d.health = math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)
        d.healthValue = math.floor(humanoid.Health + 0.5)
    elseif options and type(options.Health) == "function" then
        local ok, hp, maxHp = pcall(options.Health, character)
        if ok and type(hp) == "number" then
            d.health = math.clamp(hp / math.max(maxHp or 100, 1), 0, 1)
            d.healthValue = math.floor(hp + 0.5)
        else
            d.health = nil
        end
    else
        d.health = nil
    end

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
    render(rec, cfg, rx, ry, rz, dist)
end

local function teamOf(plr)
    return plr:GetAttribute("Team") or (plr.Character and plr.Character:GetAttribute("Team")) or (plr.Team and plr.Team.Name)
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
        if hrp and (hrp.Position - pos).Magnitude < 10 then return owner end
    end
    if now - rec.searchAt < 0.25 then return nil end
    rec.searchAt = now

    local best, bestDist = nil, 8
    for _, plr in ipairs(state.players) do
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local d = (hrp.Position - pos).Magnitude
            if d < bestDist then
                bestDist, best = d, plr
            end
        end
    end
    rec.owner = best
    return best
end

local function viewmodelIsTeam(rec, owner)
    local now = view.time
    if owner then
        local mine, theirs = teamOf(LocalPlayer), teamOf(owner)
        if mine and theirs then
            rec.verdict = theirs == mine and "team" or "enemy"
            rec.verdictAt = now
            return theirs == mine
        end
    end
    if rec.verdict and now - rec.verdictAt < 3 then return rec.verdict == "team" end
    return true
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
    local cfg = viewmodelIsTeam(rec, owner) and settings.Teammate or settings.Enemy
    if not cfg.Enabled then
        hideRecord(rec)
        return
    end

    local dx, dy, dz = tp.X - view.x, tp.Y - view.y, tp.Z - view.z
    local dist = math.sqrt(dx * dx + dy * dy + dz * dz)
    if dist <= 1 or dist > settings.MaxDistance or -(dx * view.r02 + dy * view.r12 + dz * view.r22) < 0.05 then
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
    if ownerHum then
        d.health = math.clamp(ownerHum.Health / math.max(ownerHum.MaxHealth, 1), 0, 1)
        d.healthValue = math.floor(ownerHum.Health + 0.5)
    else
        d.health = nil
    end

    d.armor = (cfg.ArmorBar and ownerChar) and currentArmor(rec, ownerChar) or nil
    d.tool = (cfg.Tool and ownerChar) and currentTool(rec, ownerChar) or nil

    d.name = nil
    if cfg.Names then
        if owner then
            d.name = playerName(rec, owner, cfg.NameType)
            rec.lastName = d.name
        else
            d.name = rec.lastName
        end
    end

    updateFlags(rec, owner or vm, ownerChar or vm, ownerHum, cfg)
    render(rec, cfg, tp.X, tp.Y, tp.Z, dist)
end

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
        if not ok then return {} end
        if typeof(res) == "Instance" then return children(res) end
        if type(res) == "table" then return res end
        return {}
    elseif kind == "Instance" then
        return children(source)
    elseif kind == "table" then
        return source
    end
    return {}
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
    if meta.hl then meta.hl.hl:Destroy() end
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

    local dx, dy, dz = pos.X - view.x, pos.Y - view.y, pos.Z - view.z
    local dist = math.sqrt(dx * dx + dy * dy + dz * dz)
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
    local meters = math.floor(dist / 2.81 + 0.5)

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
                meta.text = meta.label .. " [" .. meters .. "m]"
            elseif cfg.ShowNames then
                meta.text = meta.label
            else
                meta.text = "[" .. meters .. "m]"
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

    if cfg.Chams then
        setHighlight(meta, "hl", item, color, 1 - (1 - cfg.ChamsFillTransparency) * view.fade, Color3.new(0, 0, 0), 1)
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
    local now = os.clock()

    view.fade = state.dead and math.max(0, view.fade - 0.05) or math.min(1, view.fade + 0.05)

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
    if not anyEntity and not anyItem then return end

    if now - state.last < 1 / math.clamp(settings.RefreshRate, 30, 360) then return end
    view.dt = math.min(now - state.last, 0.1)
    state.last = now

    local cam = workspace.CurrentCamera
    if not cam then return end

    updateView(cam)
    view.time = now
    view.frame += 1
    view.angle = (now * 100) % 360

    if anyEntity then
        state.hadEntities = true

        if game.PlaceId == 72920620366355 then
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

        for name, entry in pairs(espModule.CustomAIs) do
            local list = resolveList(entry)
            for i = 1, #list do
                local ent = list[i]
                if typeof(ent) == "Instance" and ent.Parent and ent:IsA("Model") then
                    processEntity(ent, false, entry.Options, name)
                end
            end
        end

        if view.frame % 30 == 0 then
            for entity, rec in pairs(state.records) do
                if rec.touched < view.frame - 30 or now - rec.seen > 30 and rec.hidden then dropRecord(entity) end
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

    local gui = Instance.new("ScreenGui")
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
        local idx = table.find(state.players, plr)
        if idx then table.remove(state.players, idx) end
        dropRecord(plr)
    end)

    RunService:BindToRenderStep("CatwareESP", Enum.RenderPriority.Camera.Value + 1, step)
end

function espModule:Stop()
    if not state.running then return end
    state.running = false
    pcall(function() RunService:UnbindFromRenderStep("CatwareESP") end)
    for _, conn in ipairs(state.connections) do conn:Disconnect() end
    table.clear(state.connections)
    table.clear(state.players)
    table.clear(state.records)
    table.clear(state.itemMeta)
    state.vms, state.vmAt = {}, -1
    state.hadEntities, state.hadItems, state.dead = false, false, false
    view.fade = 1
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
