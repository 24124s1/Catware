local cloneref = cloneref or function(o) return o end
local function svc(n) return cloneref(game:GetService(n)) end

local Players       = svc("Players")
local UIS           = svc("UserInputService")
local TweenService  = svc("TweenService")
local RunService    = svc("RunService")
local HttpService   = svc("HttpService")
local Workspace     = svc("Workspace")
local GuiService    = svc("GuiService")
local InsertService = svc("InsertService")
local Stats         = svc("Stats")

local lp    = Players.LocalPlayer
local rgb   = Color3.fromRGB
local clamp = math.clamp
local floor = math.floor
local lower = string.lower
local v2    = Vector2.new
local dim2  = UDim2.new
local off   = UDim2.fromOffset
local dim   = UDim.new

local Enum_X  = Enum.AutomaticSize.X
local Enum_Y  = Enum.AutomaticSize.Y
local Enum_XY = Enum.AutomaticSize.XY
local ALeft   = Enum.TextXAlignment.Left
local ARight  = Enum.TextXAlignment.Right
local ACenter = Enum.TextXAlignment.Center
local YTop    = Enum.TextYAlignment.Top
local YMid    = Enum.TextYAlignment.Center
local YBot    = Enum.TextYAlignment.Bottom

local WHITE = rgb(255, 255, 255)
local RISKY_TAG = ' <font color="rgb(230,80,80)">[Risky]</font>'

local function nameText(name, risky)
    if risky then return name .. RISKY_TAG end
    return name
end

local ICON_NAMES = {
    Legit = "crosshair", Rage = "flame", Players = "users", World = "globe",
    Misc = "shapes", ["UI Settings"] = "sliders-horizontal",
    Combat = "swords", Visuals = "eye", Other = "layers", Settings = "settings",
}

local MODEL_REGISTRY = {
    ["Tung Tung"] = 83138270236341,
    ["Patrick"] = 111307113439135,
    ["Spongebob"] = 4759134675,
    ["Furry"] = 16222492664,
    ["Cat In The Hat"] = 104234111421514,
}

local KEYS = {
    [Enum.KeyCode.LeftShift] = "LShift", [Enum.KeyCode.RightShift] = "RShift",
    [Enum.KeyCode.LeftControl] = "LCtrl", [Enum.KeyCode.RightControl] = "RCtrl",
    [Enum.KeyCode.LeftAlt] = "LAlt", [Enum.KeyCode.RightAlt] = "RAlt",
    [Enum.KeyCode.Insert] = "Ins", [Enum.KeyCode.Backspace] = "Bksp",
    [Enum.KeyCode.Return] = "Enter", [Enum.KeyCode.CapsLock] = "Caps",
    [Enum.KeyCode.Space] = "Space", [Enum.KeyCode.Escape] = "Esc",
    [Enum.KeyCode.One] = "1", [Enum.KeyCode.Two] = "2", [Enum.KeyCode.Three] = "3",
    [Enum.KeyCode.Four] = "4", [Enum.KeyCode.Five] = "5", [Enum.KeyCode.Six] = "6",
    [Enum.KeyCode.Seven] = "7", [Enum.KeyCode.Eight] = "8", [Enum.KeyCode.Nine] = "9",
    [Enum.KeyCode.Zero] = "0",
    [Enum.UserInputType.MouseButton1] = "MB1", [Enum.UserInputType.MouseButton2] = "MB2",
    [Enum.UserInputType.MouseButton3] = "MB3",
}

local BASE_GRAYS = {
    outline = 0, inline = 38, panel = 11, body = 14, field_top = 34, field_bot = 23,
    tab_active = 22, preview = 9, line = 30, text = 205, text_active = 240,
    item = 160, dim = 112, mute = 85,
}

local function makePreset(accent, t)
    local out = { accent = accent }
    for k, g in pairs(BASE_GRAYS) do
        local f = math.min(g, 60) / 60
        out[k] = rgb(
            clamp(floor(g + t[1] * f), 0, 255),
            clamp(floor(g + t[2] * f), 0, 255),
            clamp(floor(g + t[3] * f), 0, 255)
        )
    end
    return out
end

local PRESET_NAMES = { "Default", "Midnight", "Emerald", "Crimson", "Violet", "Amber", "Mono", "Ocean", "Rose", "Mint", "Sunset", "Ghost" }
local PRESETS = {
    default  = makePreset(rgb(204, 112, 148), { 0, 0, 0 }),
    midnight = makePreset(rgb(100, 140, 255), { -2, 0, 10 }),
    emerald  = makePreset(rgb(80, 200, 140), { -2, 6, 2 }),
    crimson  = makePreset(rgb(230, 70, 80), { 8, -2, -2 }),
    violet   = makePreset(rgb(161, 113, 255), { 4, 0, 10 }),
    amber    = makePreset(rgb(240, 170, 60), { 6, 3, -4 }),
    mono     = makePreset(rgb(220, 220, 220), { 0, 0, 0 }),
    ocean    = makePreset(rgb(60, 190, 230), { -3, 3, 9 }),
    rose     = makePreset(rgb(245, 130, 170), { 6, -1, 2 }),
    mint     = makePreset(rgb(120, 230, 190), { -2, 6, 4 }),
    sunset   = makePreset(rgb(255, 120, 80), { 7, 1, -3 }),
    ghost    = makePreset(rgb(200, 200, 225), { 1, 1, 4 }),
}

local THEME_KEYS = {
    { "accent", "Accent" }, { "outline", "Outline" }, { "inline", "Border" }, { "panel", "Window" },
    { "body", "Section" }, { "field_top", "Field Top" }, { "field_bot", "Field Bottom" },
    { "tab_active", "Tab Highlight" }, { "preview", "Preview Background" },
    { "line", "Lines" }, { "text", "Text" }, { "text_active", "Text Bright" },
    { "item", "Text Idle" }, { "dim", "Text Dim" }, { "mute", "Text Muted" },
}

local Theme = { v = {}, hooks = {} }
for k, c in pairs(PRESETS.default) do Theme.v[k] = c end

function Theme.on(keys, fn)
    if type(keys) == "string" then keys = { keys } end
    for _, k in ipairs(keys) do
        local l = Theme.hooks[k]
        if not l then
            l = {}
            Theme.hooks[k] = l
        end
        l[#l + 1] = fn
    end
    fn()
end

function Theme.set(key, c)
    if typeof(c) ~= "Color3" or Theme.v[key] == nil then return end
    Theme.v[key] = c
    local l = Theme.hooks[key]
    if l then
        for i = 1, #l do pcall(l[i]) end
    end
end

local function T(k) return { __theme = k } end

local function bindProp(o, k, key)
    Theme.on(key, function() o[k] = Theme.v[key] end)
end

local function getParent()
    if typeof(gethui) == "function" then
        local ok, ui = pcall(gethui)
        if ok and ui then return cloneref(ui) end
    end
    if not RunService:IsStudio() then
        local ok, cg = pcall(function() return svc("CoreGui") end)
        if ok and cg and pcall(function() return #cg:GetChildren() end) then return cg end
    end
    return lp:WaitForChild("PlayerGui")
end

local Icons = { mod = nil, ready = false, queue = {} }

function Icons.get(name)
    if not Icons.mod or not name then return nil end
    local ok, ic = pcall(Icons.mod.GetAsset, name)
    if ok and type(ic) == "table" then return ic end
    return nil
end

function Icons.bind(fn)
    if Icons.ready then
        pcall(fn)
    else
        Icons.queue[#Icons.queue + 1] = fn
    end
end

function Icons.apply(img, glyph, ic, fallback)
    if ic and ic.FontFace then
        img.Visible = false
        glyph.FontFace = ic.FontFace
        glyph.RichText = false
        glyph.TextScaled = true
        glyph.Text = ic.Text or ""
        glyph.Visible = true
    elseif ic and ic.Url then
        glyph.Visible = false
        img.Image = ic.Url
        img.ImageRectOffset = ic.ImageRectOffset or Vector2.zero
        img.ImageRectSize = ic.ImageRectSize or Vector2.zero
        img.Visible = true
    else
        img.Visible = false
        glyph.TextScaled = false
        glyph.Text = fallback or ""
        glyph.Visible = true
    end
end

task.spawn(function()
    local ok, mod = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/notpoiu/Molto/refs/heads/main/source.lua"))()
    end)
    if ok and type(mod) == "table" then
        pcall(function() mod.SetProvider("lucide") end)
    else
        ok, mod = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/notpoiu/lucide-roblox-direct/refs/heads/main/source.lua"))()
        end)
    end
    if ok and type(mod) == "table" then Icons.mod = mod end
    Icons.ready = true
    for _, fn in ipairs(Icons.queue) do pcall(fn) end
    table.clear(Icons.queue)
end)

local FONT_LIST = {
    {"Tahoma", "Tahoma.ttf", "https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/fonts/Tahoma.ttf"},
    {"Tahoma Bold", "tahoma_bold.ttf", "https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/fonts/tahoma_bold.ttf"},
    {"Tahoma Modern Bold", "Tahoma-Modern-Bold.ttf", "https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/fonts/Tahoma-Modern-Bold.ttf"},
    {"Tahoma Modern", "Tahoma-Modern.ttf", "https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/fonts/Tahoma-Modern.ttf"},
    {"Comfortaa", "Comfortaa-Regular.ttf", "https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/fonts/Comfortaa-Regular.ttf"},
    {"HankenGrotesk", "HankenGrotesk-SemiBold.ttf", "https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/fonts/HankenGrotesk-SemiBold.ttf"},
    {"Inter Medium", "Inter_28pt-Medium.ttf", "https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/fonts/Inter_28pt-Medium.ttf"},
    {"Inter SemiBold", "Inter_28pt-SemiBold.ttf", "https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/fonts/Inter_28pt-SemiBold.ttf"},
    {"Light Modern", "Light Modern.ttf", "https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/fonts/Light%20Modern.ttf"},
    {"Minecraftia", "Minecraftia-Regular.ttf", "https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/fonts/Minecraftia-Regular.ttf"},
    {"ProggyClean", "ProggyClean.ttf", "https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/fonts/ProggyClean.ttf"},
    {"ProggyTiny", "ProggyTiny.ttf", "https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/fonts/ProggyTiny.ttf"},
    {"Rubik", "Rubik-Regular.ttf", "https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/fonts/Rubik-Regular.ttf"},
    {"Verdana", "Verdana-Font.ttf", "https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/fonts/Verdana-Font.ttf"},
    {"Tahoma 8px", "fs-tahoma-8px.ttf", "https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/fonts/fs-tahoma-8px.ttf"},
    {"Open Sans PX", "open-sans-px.ttf", "https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/fonts/open-sans-px.ttf"},
    {"Smallest Pixel-7", "smallest_pixel-7.ttf", "https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/fonts/smallest_pixel-7.ttf"},
    {"Gojiberry Quibble", "GojiberryQuibbleFreeRegular-7OldK.ttf", "https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/fonts/GojiberryQuibbleFreeRegular-7OldK.ttf"},
}

local FontBank = { map = {}, done = false, waiting = {} }

function FontBank.list()
    local out = {}
    for n in pairs(FontBank.map) do out[#out + 1] = n end
    table.sort(out)
    return out
end

local function loadCustomFont(entry)
    local name, file, url = entry[1], entry[2], entry[3]
    local ok, font = pcall(function()
        if not (writefile and getcustomasset and isfile) then error("no filesystem") end
        local path = "catware_fonts/" .. file
        if not isfile(path) then writefile(path, game:HttpGet(url)) end
        local jpath = "catware_fonts/" .. (name:gsub("%s", "_")) .. ".json"
        writefile(jpath, HttpService:JSONEncode({
            name = name,
            faces = {{ name = "Regular", weight = 400, style = "normal", assetId = getcustomasset(path) }},
        }))
        return Font.new(getcustomasset(jpath), Enum.FontWeight.Regular)
    end)
    if ok and font then FontBank.map[name] = font end
end

pcall(function()
    if typeof(makefolder) == "function" and not (typeof(isfolder) == "function" and isfolder("catware_fonts")) then
        makefolder("catware_fonts")
    end
end)

for _, n in ipairs({ "Code", "RobotoMono", "Inconsolata", "SourceSans", "Gotham", "GothamMedium", "Ubuntu", "Roboto", "Arial", "Montserrat", "Nunito" }) do
    pcall(function() FontBank.map[n] = Font.fromEnum(Enum.Font[n]) end)
end

for _, e in ipairs(FONT_LIST) do
    if e[1] == "Tahoma 8px" then loadCustomFont(e) end
end

do
    local pending = 0
    for _, e in ipairs(FONT_LIST) do
        if not FontBank.map[e[1]] then
            pending += 1
            task.spawn(function()
                loadCustomFont(e)
                pending -= 1
                if pending == 0 then
                    FontBank.done = true
                    for _, fn in ipairs(FontBank.waiting) do pcall(fn) end
                    table.clear(FontBank.waiting)
                end
            end)
        end
    end
    if pending == 0 then FontBank.done = true end
end

local UI = { size = 12, objs = setmetatable({}, { __mode = "k" }) }
UI.font = FontBank.map["Tahoma 8px"] or FontBank.map["Tahoma"] or Font.fromEnum(Enum.Font.Code)

local function applyFont()
    for o in pairs(UI.objs) do
        pcall(function()
            o.FontFace = UI.font
            o.TextSize = UI.size
        end)
    end
end

local TEXT_CLASSES = { TextLabel = true, TextButton = true, TextBox = true }

local function new(class, props)
    local o = Instance.new(class)
    if o:IsA("GuiObject") then o.BorderSizePixel = 0 end
    if TEXT_CLASSES[class] then
        o.FontFace = UI.font
        o.TextSize = UI.size
        o.BackgroundTransparency = 1
        o.TextXAlignment = ALeft
        o.Text = ""
        if not props.NoSkin then UI.objs[o] = true end
        if props.TextColor3 == nil then bindProp(o, "TextColor3", "text") end
    end
    if class == "TextButton" then o.AutoButtonColor = false end
    if class == "ScrollingFrame" then
        o.ScrollBarThickness = 0
        o.CanvasSize = UDim2.new()
        o.ElasticBehavior = Enum.ElasticBehavior.Never
        o.ScrollingDirection = Enum.ScrollingDirection.Y
        o.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
        o.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
        o.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
        if props.ScrollBarImageColor3 == nil then bindProp(o, "ScrollBarImageColor3", "accent") end
    end
    for k, val in pairs(props) do
        if k ~= "Parent" and k ~= "NoSkin" then
            if type(val) == "table" and val.__theme then
                bindProp(o, k, val.__theme)
            else
                o[k] = val
            end
        end
    end
    o.Parent = props.Parent
    return o
end

local function label(parent, str, color, pos, size, xa)
    local p = {
        Parent = parent, Text = str, Position = pos or UDim2.new(),
        Size = size or dim2(1, 0, 1, 0), TextXAlignment = xa or ALeft,
    }
    if type(color) == "string" then
        p.TextColor3 = T(color)
    elseif color ~= nil then
        p.TextColor3 = color
    end
    return new("TextLabel", p)
end

local function stroke(parent, color, thickness)
    local c = color
    if c == nil then
        c = T("inline")
    elseif type(c) == "string" then
        c = T(c)
    end
    return new("UIStroke", {
        Parent = parent, Color = c, Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, LineJoinMode = Enum.LineJoinMode.Miter,
    })
end

local TI = {}
local function tween(o, props, t)
    t = t or 0.15
    local ti = TI[t]
    if not ti then
        ti = TweenInfo.new(t, Enum.EasingStyle.Quad)
        TI[t] = ti
    end
    TweenService:Create(o, ti, props):Play()
end

local function hotFrame(parent, size, pos)
    local o = new("Frame", { Parent = parent, Size = size, Position = pos or UDim2.new(), BackgroundColor3 = Theme.v.outline })
    Theme.on({ "outline", "accent" }, function()
        o.BackgroundColor3 = o:GetAttribute("hot") and Theme.v.accent or Theme.v.outline
    end)
    return o
end

local function hot(o, on, t)
    o:SetAttribute("hot", on and true or false)
    tween(o, { BackgroundColor3 = on and Theme.v.accent or Theme.v.outline }, t or 0.1)
end

local function framed(parent, size, pos, fill)
    local o = new("Frame", { Parent = parent, Size = size, Position = pos or UDim2.new(), BackgroundColor3 = T("outline") })
    local i = new("Frame", { Parent = o, Size = dim2(1, -2, 1, -2), Position = off(1, 1), BackgroundColor3 = T("inline") })
    local b = new("Frame", { Parent = i, Size = dim2(1, -2, 1, -2), Position = off(1, 1), BackgroundColor3 = T(fill or "panel"), ClipsDescendants = true })
    return b, o
end

local function fieldBox(parent, size, pos, k1, k2)
    local o = hotFrame(parent, size, pos)
    local i = new("Frame", { Parent = o, Size = dim2(1, -2, 1, -2), Position = off(1, 1), BackgroundColor3 = T("inline") })
    local b = new("Frame", { Parent = i, Size = dim2(1, -2, 1, -2), Position = off(1, 1), BackgroundColor3 = WHITE, ClipsDescendants = true })
    local g = new("UIGradient", { Parent = b, Rotation = 90 })
    if k1 == nil then
        Theme.on({ "field_top", "field_bot" }, function()
            g.Color = ColorSequence.new(Theme.v.field_top, Theme.v.field_bot)
        end)
    elseif type(k1) == "string" then
        k2 = k2 or k1
        Theme.on({ k1, k2 }, function()
            g.Color = ColorSequence.new(Theme.v[k1], Theme.v[k2])
        end)
    else
        g.Color = ColorSequence.new(k1, k2 or k1)
    end
    return b, o, g
end

local function slimBar(parent, pos, size)
    local o = new("Frame", { Parent = parent, Position = pos, Size = size, BackgroundColor3 = T("outline") })
    local i = new("Frame", { Parent = o, Position = off(1, 1), Size = dim2(1, -2, 1, -2), BackgroundColor3 = WHITE })
    return i, o
end

local function accentLine(parent)
    local line = new("Frame", { Parent = parent, Size = dim2(1, 0, 0, 2), BackgroundColor3 = T("accent"), ZIndex = 3 })
    new("UIGradient", { Parent = line, Rotation = 90, Color = ColorSequence.new(WHITE, rgb(150, 150, 150)) })
    return line
end

local function topGlow(parent)
    local g = new("Frame", { Parent = parent, Position = off(0, 2), Size = dim2(1, 0, 0, 46), BackgroundColor3 = T("accent") })
    new("UIGradient", { Parent = g, Rotation = 90, Transparency = NumberSequence.new(0.9, 1) })
    return g
end

local function makeRight(row)
    local r = new("Frame", {
        Parent = row, AnchorPoint = v2(1, 0), Position = dim2(1, 0, 0, 0),
        Size = dim2(0, 0, 1, 0), AutomaticSize = Enum_X, BackgroundTransparency = 1,
    })
    new("UIListLayout", {
        Parent = r, FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = dim(0, 4), SortOrder = Enum.SortOrder.LayoutOrder,
    })
    return r
end

local function rc(c)
    return string.format("rgb(%d,%d,%d)", floor(c.R * 255 + 0.5), floor(c.G * 255 + 0.5), floor(c.B * 255 + 0.5))
end

local function toHex(c)
    return string.format("%02X%02X%02X", floor(c.R * 255 + 0.5), floor(c.G * 255 + 0.5), floor(c.B * 255 + 0.5))
end

local function parseHex(s)
    s = tostring(s):gsub("[^%x]", "")
    if #s == 3 then
        s = s:sub(1, 1):rep(2) .. s:sub(2, 2):rep(2) .. s:sub(3, 3):rep(2)
    end
    if #s ~= 6 and #s ~= 8 then return nil end
    local r, g, b = tonumber(s:sub(1, 2), 16), tonumber(s:sub(3, 4), 16), tonumber(s:sub(5, 6), 16)
    local a = #s == 8 and tonumber(s:sub(7, 8), 16) / 255 or nil
    return rgb(r, g, b), a
end

local function parseKey(v)
    if typeof(v) == "EnumItem" then return v end
    if type(v) == "string" then
        local p = string.split(v, ".")
        if #p == 3 and p[1] == "Enum" then
            local ok, e = pcall(function() return Enum[p[2]][p[3]] end)
            if ok then return e end
        end
    end
    return nil
end

local function keyText(k)
    if not k then return "None" end
    return KEYS[k] or k.Name
end

local function encode(v)
    local t = typeof(v)
    if t == "Color3" then
        return { __t = "c", r = v.R, g = v.G, b = v.B }
    elseif t == "EnumItem" then
        return { __t = "e", v = tostring(v) }
    elseif t == "table" then
        if #v > 0 then
            local l = {}
            for i, x in ipairs(v) do l[i] = encode(x) end
            return { __t = "a", v = l }
        end
        local d = {}
        for k, x in pairs(v) do d[tostring(k)] = encode(x) end
        return { __t = "d", v = d }
    end
    return v
end

local function decode(v)
    if type(v) ~= "table" then return v end
    if v.__t == "c" then
        return Color3.new(v.r, v.g, v.b)
    elseif v.__t == "e" then
        return parseKey(v.v)
    elseif v.__t == "a" then
        local l = {}
        for i, x in ipairs(v.v) do l[i] = decode(x) end
        return l
    elseif v.__t == "d" then
        local d = {}
        for k, x in pairs(v.v) do d[k] = decode(x) end
        return d
    end
    return v
end

local function isUiFlag(k)
    return string.sub(k, 1, 2) == "__"
end

local function newLine(parent, z)
    local frame = new("Frame", {
        Parent = parent, AnchorPoint = v2(0.5, 0.5), BackgroundColor3 = WHITE,
        Visible = false, ZIndex = z, Size = off(1, 1),
    })
    new("UIStroke", {
        Parent = frame, Color = rgb(0, 0, 0), Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, LineJoinMode = Enum.LineJoinMode.Miter,
    })
    local grad = new("UIGradient", { Parent = frame })
    local obj = { frame = frame, thickness = 1 }
    function obj.color(c1, c2)
        if obj.k1 == c1 and obj.k2 == c2 then return end
        obj.k1, obj.k2 = c1, c2
        if c2 then
            frame.BackgroundColor3 = WHITE
            grad.Color = ColorSequence.new(c1, c2)
        else
            frame.BackgroundColor3 = c1
            grad.Color = ColorSequence.new(WHITE)
        end
    end
    function obj.set(a, b)
        local d = b - a
        local c = a:Lerp(b, 0.5)
        frame.Position = off(c.X, c.Y)
        frame.Size = off(math.max(d.Magnitude, 1), obj.thickness)
        frame.Rotation = math.deg(math.atan2(d.Y, d.X))
        frame.Visible = true
    end
    function obj.hide()
        frame.Visible = false
    end
    return obj
end

local function newText(parent, ax, ay, z)
    local xa = ax == 0 and ALeft or (ax == 1 and ARight or ACenter)
    local ya = ay == 0 and YTop or (ay == 1 and YBot or YMid)
    local lbl = new("TextLabel", {
        Parent = parent, AutomaticSize = Enum_XY, Size = off(0, 0), AnchorPoint = v2(ax, ay),
        TextColor3 = WHITE, TextStrokeTransparency = 0, TextStrokeColor3 = rgb(0, 0, 0),
        Visible = false, ZIndex = z, TextXAlignment = xa, TextYAlignment = ya, NoSkin = true,
    })
    local grad = new("UIGradient", { Parent = lbl })
    return { label = lbl, grad = grad }
end

local function hideGroup(g)
    for i = 1, #g do g[i].hide() end
end

local function projectPoint(pt, camCF, tanHalf, w, h)
    local rel = camCF:PointToObjectSpace(pt)
    local depth = -rel.Z
    if depth < 0.1 then return nil end
    local nx = rel.X / (depth * tanHalf * (w / h))
    local ny = rel.Y / (depth * tanHalf)
    return v2((nx * 0.5 + 0.5) * w, (0.5 - ny * 0.5) * h)
end

local R15_PARTS = {"HumanoidRootPart", "Head", "UpperTorso", "LowerTorso", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand"}
local R6_PARTS  = {"HumanoidRootPart", "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}

local R15_BONES = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"LowerTorso", "LeftUpperLeg"}, {"LowerTorso", "RightUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"UpperTorso", "LeftUpperArm"}, {"UpperTorso", "RightUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"}, {"RightUpperArm", "RightLowerArm"},
}
local R6_BONES = {
    {"Head", "Torso"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
}

local EDGES_3D = {
    {1, 2}, {2, 3}, {3, 4}, {4, 1}, {5, 6}, {6, 7}, {7, 8}, {8, 5}, {1, 5}, {2, 6}, {3, 7}, {4, 8},
}

local function isRig(m)
    return m:FindFirstChild("UpperTorso") ~= nil or m:FindFirstChild("Torso") ~= nil
end

local function gatherParts(m)
    local out = {}
    if isRig(m) then
        local names = m:FindFirstChild("UpperTorso") and R15_PARTS or R6_PARTS
        for _, n in ipairs(names) do
            local p = m:FindFirstChild(n)
            if p and p:IsA("BasePart") then out[#out + 1] = p end
        end
        for _, c in ipairs(m:GetChildren()) do
            if c:IsA("Accessory") then
                local hd = c:FindFirstChild("Handle")
                if hd and hd:IsA("BasePart") then out[#out + 1] = hd end
            end
        end
    else
        for _, d in ipairs(m:GetDescendants()) do
            if d:IsA("BasePart") then out[#out + 1] = d end
        end
    end
    return out
end

local function aabb(parts)
    local mnX, mnY, mnZ = math.huge, math.huge, math.huge
    local mxX, mxY, mxZ = -math.huge, -math.huge, -math.huge
    for _, part in ipairs(parts) do
        local cf, hs = part.CFrame, part.Size * 0.5
        for ix = -1, 1, 2 do
            for iy = -1, 1, 2 do
                for iz = -1, 1, 2 do
                    local pt = cf * Vector3.new(ix * hs.X, iy * hs.Y, iz * hs.Z)
                    if pt.X < mnX then mnX = pt.X end
                    if pt.Y < mnY then mnY = pt.Y end
                    if pt.Z < mnZ then mnZ = pt.Z end
                    if pt.X > mxX then mxX = pt.X end
                    if pt.Y > mxY then mxY = pt.Y end
                    if pt.Z > mxZ then mxZ = pt.Z end
                end
            end
        end
    end
    if mnX == math.huge then return nil end
    return Vector3.new(mnX, mnY, mnZ), Vector3.new(mxX, mxY, mxZ)
end

local function cornersFrom(mn, mx)
    return {
        Vector3.new(mx.X, mx.Y, mx.Z), Vector3.new(mn.X, mx.Y, mx.Z), Vector3.new(mn.X, mn.Y, mx.Z), Vector3.new(mx.X, mn.Y, mx.Z),
        Vector3.new(mx.X, mx.Y, mn.Z), Vector3.new(mn.X, mx.Y, mn.Z), Vector3.new(mn.X, mn.Y, mn.Z), Vector3.new(mx.X, mn.Y, mn.Z),
    }
end

local function prepareModel(m)
    for _, d in ipairs(m:GetDescendants()) do
        if d:IsA("BaseScript") or d:IsA("Sound") then
            d:Destroy()
        elseif d:IsA("Humanoid") then
            d.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            d.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
        end
    end

    local tint = {}
    for _, d in ipairs(m:GetDescendants()) do
        if d:IsA("BasePart") then
            d.Anchored = true
            d.CanCollide = false
            local entry = { c = d.Color, m = d.Material }
            if d:IsA("MeshPart") then entry.tex = d.TextureID end
            local sm = d:FindFirstChildOfClass("SpecialMesh")
            if sm then
                entry.sm = sm
                entry.smtex = sm.TextureId
            end
            tint[d] = entry
        end
    end

    local rig = isRig(m)
    local hrp = m:FindFirstChild("HumanoidRootPart")
    if hrp and hrp:IsA("BasePart") then pcall(function() m.PrimaryPart = hrp end) end
    pcall(function() m:PivotTo(CFrame.new(0, 0, 0)) end)

    local mn0, mx0 = aabb(gatherParts(m))
    if not mn0 then return nil end
    local h = mx0.Y - mn0.Y
    if h > 0.05 then
        local f = 5.5 / h
        if math.abs(f - 1) > 0.01 then
            pcall(function() m:ScaleTo(f) end)
        end
    end

    local parts = gatherParts(m)
    local mn, mx = aabb(parts)
    if not mn then return nil end
    local center = (mn + mx) * 0.5
    pcall(function() m:PivotTo(m:GetPivot() - center) end)
    mn, mx = aabb(parts)
    if not mn then return nil end
    local pivot0 = m:GetPivot()

    local bones, headFn = {}, nil
    if rig then
        local list = m:FindFirstChild("UpperTorso") and R15_BONES or R6_BONES
        for _, pr in ipairs(list) do
            local pa, pc = m:FindFirstChild(pr[1]), m:FindFirstChild(pr[2])
            if pa and pc and pa:IsA("BasePart") and pc:IsA("BasePart") then
                bones[#bones + 1] = function() return pa.Position, pc.Position end
            end
        end
        local head = m:FindFirstChild("Head")
        if head and head:IsA("BasePart") then
            headFn = function() return head.Position end
        end
    end

    if #bones == 0 or not headFn then
        local H, W = mx.Y - mn.Y, mx.X - mn.X
        local function loc(x, y) return pivot0:PointToObjectSpace(Vector3.new(x, y, 0)) end
        local p = {
            head = loc(0, mx.Y - 0.08 * H), neck = loc(0, mx.Y - 0.2 * H), hip = loc(0, mn.Y + 0.48 * H),
            ls = loc(-0.28 * W, mx.Y - 0.25 * H), rs = loc(0.28 * W, mx.Y - 0.25 * H),
            lh = loc(-0.34 * W, mx.Y - 0.55 * H), rh = loc(0.34 * W, mx.Y - 0.55 * H),
            lk = loc(-0.12 * W, mn.Y + 0.25 * H), rk = loc(0.12 * W, mn.Y + 0.25 * H),
            lf = loc(-0.12 * W, mn.Y + 0.02 * H), rf = loc(0.12 * W, mn.Y + 0.02 * H),
        }
        local function bone(a, b)
            return function()
                local cf = m:GetPivot()
                return cf:PointToWorldSpace(a), cf:PointToWorldSpace(b)
            end
        end
        if #bones == 0 then
            bones = {
                bone(p.head, p.neck), bone(p.neck, p.hip), bone(p.neck, p.ls), bone(p.neck, p.rs),
                bone(p.ls, p.lh), bone(p.rs, p.rh), bone(p.hip, p.lk), bone(p.hip, p.rk),
                bone(p.lk, p.lf), bone(p.rk, p.rf),
            }
        end
        if not headFn then
            headFn = function() return m:GetPivot():PointToWorldSpace(p.head) end
        end
    end

    local sz = mx - mn
    local radius = math.sqrt(sz.X * sz.X + sz.Z * sz.Z) * 0.5

    return {
        model = m, tint = tint, pivot0 = pivot0, corners = cornersFrom(mn, mx), bones = bones, head = headFn,
        height = math.max(sz.Y, 0.1), radius = math.max(radius, 0.05),
    }
end

local function loadModelById(assetId)
    local root
    local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(assetId)) end)
    if ok and type(res) == "table" and res[1] then root = res[1] end
    if not root then
        local ok2, res2 = pcall(function() return InsertService:LoadAsset(assetId) end)
        if ok2 and res2 then root = res2 end
    end
    if not root then return nil, "asset not found" end

    local m
    if root:IsA("Model") then
        m = root
    else
        m = root:FindFirstChildOfClass("Model")
        if not m then
            m = Instance.new("Model")
            for _, k in ipairs(root:GetChildren()) do k.Parent = m end
        else
            m.Parent = nil
        end
    end

    if not m:FindFirstChildOfClass("Humanoid") then
        local hum = Instance.new("Humanoid")
        hum.Parent = m
        hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
    end
    if not m.PrimaryPart then
        local hrp = m:FindFirstChild("HumanoidRootPart") or m:FindFirstChild("Torso") or m:FindFirstChild("UpperTorso") or m:FindFirstChildWhichIsA("BasePart")
        if hrp then pcall(function() m.PrimaryPart = hrp end) end
    end
    m.Name = "PreviewModel"
    return m, nil
end

local function buildLocal()
    local char = lp.Character
    if not char then
        local ok = pcall(function() char = lp.CharacterAdded:Wait() end)
        if not ok or not char then return nil end
    end
    if not char:FindFirstChild("HumanoidRootPart") then char:WaitForChild("HumanoidRootPart", 5) end
    char.Archivable = true
    local ok, c = pcall(function() return char:Clone() end)
    if not ok or not c then return nil end
    return c
end

local Library  = {}; Library.__index  = Library
local Category = {}; Category.__index = Category
local Tab      = {}; Tab.__index      = Tab
local Column   = {}; Column.__index   = Column
local Section  = {}; Section.__index  = Section
local Element  = {}; Element.__index  = Element

local function nxt(lib) lib.order += 1 return lib.order end

local function miniButton(parent, text, pos, size)
    local body, outer = fieldBox(parent, size, pos)
    local lbl = label(body, text, "text", off(0, 0), dim2(1, 0, 1, 0), ACenter)
    local hit = new("TextButton", { Parent = outer, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 5 })
    hit.MouseEnter:Connect(function() hot(outer, true) end)
    hit.MouseLeave:Connect(function() hot(outer, false) end)
    return outer, lbl, hit
end

local NOTIFY_KINDS = {
    info = { title = "Info" },
    success = { title = "Success", color = rgb(90, 200, 120) },
    error = { title = "Error", color = rgb(230, 80, 80) },
    warn = { title = "Warning", color = rgb(240, 170, 60) },
}

function Library.new(opts)
    opts = opts or {}
    local self = setmetatable({}, Library)

    self.name = opts.name or "Stardust"
    self.version = opts.version or "v1"
    self.folder = opts.folder or "catware"
    self.toggleKey = opts.toggleKey or Enum.KeyCode.Insert
    self.espFonts = opts.fonts or {}
    self.flags, self.setters = {}, {}
    self.connections = {}
    self.notifs = {}
    self.keybinds = {}
    self.sideLabels = {}
    self.sideBgLabels = {}
    self.stack = {}
    self.order = 0
    self.cpCount = 0
    self.currentTab = nil
    self.clipboard = nil
    self.onUnload = nil
    self.learnedY = nil
    self.binding = false
    self.notifyEnabled = true
    self.sideExpanded = false
    self.searchIndex = {}
    self.allTabs = {}
    self.searchQuery = ""
    self.searchAll = false
    self._searching = false
    self.accent = Theme.v.accent
    Theme.on("accent", function() self.accent = Theme.v.accent end)
    if typeof(opts.accent) == "Color3" then Theme.set("accent", opts.accent) end

    self.gui = new("ScreenGui", {
        Name = HttpService:GenerateGUID(false), IgnoreGuiInset = true, ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 1000, Parent = getParent(),
    })
    pcall(function() self.gui.ScreenInsets = Enum.ScreenInsets.None end)

    local sideCollapsed, sideOpen = 52, 150
    local extra = sideOpen - sideCollapsed
    local minW, minH = 560, 420
    self.size = opts.size or Vector2.new(680, 520)
    local vp = Workspace.CurrentCamera.ViewportSize

    self.root = new("Frame", {
        Parent = self.gui, BackgroundTransparency = 1, Size = off(self.size.X, self.size.Y),
        Position = off(floor(vp.X / 2 - self.size.X / 2), floor(vp.Y / 2 - self.size.Y / 2)),
    })

    for i = 1, 3 do
        new("Frame", {
            Parent = self.root,
            Size = dim2(1, i * 10, 1, i * 10),
            Position = off(-i * 5, -i * 5),
            BackgroundColor3 = T("accent"),
            BackgroundTransparency = 0.80 + i * 0.04,
            ZIndex = 1,
        })
    end

    function self:applySize()
        local extraNow = self.sideExpanded and extra or 0
        self.root.Size = off(self.size.X + extraNow, self.size.Y)
    end

    self.catcher = new("TextButton", {
        Parent = self.gui, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1,
        Visible = false, ZIndex = 150, Active = true,
    })
    self.catcher.MouseButton1Down:Connect(function() self:closePopups() end)
    self.catcher.MouseButton2Down:Connect(function() self:closePopups() end)

    self.catcher2 = new("TextButton", {
        Parent = self.gui, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1,
        Visible = false, ZIndex = 250, Active = true,
    })
    self.catcher2.MouseButton1Down:Connect(function() self:closeLevel(2) end)
    self.catcher2.MouseButton2Down:Connect(function() self:closeLevel(2) end)

    local win, winOuter = framed(self.root, dim2(1, 0, 1, 0))
    winOuter.ZIndex = 2
    win.ZIndex = 2
    topGlow(win).ZIndex = 15
    accentLine(win).ZIndex = 30

    local content = new("Frame", {
        Parent = win, Position = off(sideCollapsed, 0), Size = dim2(1, -sideCollapsed, 1, 0),
        BackgroundTransparency = 1, ClipsDescendants = true,
    })

    local side = new("Frame", {
        Parent = win, Size = dim2(0, sideCollapsed, 1, 0), BackgroundColor3 = T("panel"),
        ZIndex = 10, ClipsDescendants = true, Active = true,
    })
    self.side = side
    local sideGrad = new("UIGradient", { Parent = side, Rotation = 90 })
    Theme.on({ "accent", "panel" }, function()
        sideGrad.Color = ColorSequence.new(Theme.v.accent:Lerp(rgb(0, 0, 0), 0.6), Theme.v.panel)
    end)
    new("Frame", {
        Parent = side, AnchorPoint = v2(1, 0), Position = dim2(1, 0, 0, 0), Size = dim2(0, 1, 1, 0),
        BackgroundColor3 = T("inline"), ZIndex = 12,
    })

    local sideHeader = new("Frame", { Parent = side, Position = off(0, 2), Size = dim2(1, 0, 0, 42), BackgroundTransparency = 1, Active = true, ClipsDescendants = true })
    local logoHolder = new("Frame", { Parent = sideHeader, Position = off(15, 11), Size = off(22, 22), BackgroundTransparency = 1 })
    local logoImg = new("ImageLabel", {
        Parent = logoHolder, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1,
        ScaleType = Enum.ScaleType.Fit, ImageColor3 = T("accent"), Visible = false,
    })
    local logoGlyph = new("TextLabel", {
        Parent = logoHolder, Size = dim2(1, 0, 1, 0), TextXAlignment = ACenter, TextYAlignment = YMid,
        TextColor3 = T("accent"), Visible = false, NoSkin = true,
    })
    if opts.logo then
        logoImg.Image = opts.logo
        logoImg.Visible = true
    else
        Icons.bind(function()
            Icons.apply(logoImg, logoGlyph, Icons.get(opts.logoIcon or "sparkles"), "*")
        end)
    end
    local headerName = label(sideHeader, self.name, "text_active", off(46, 10), dim2(1, -50, 0, 12))
    headerName.TextTransparency = 1
    local headerVer = label(sideHeader, self.version, "mute", off(46, 22), dim2(1, -50, 0, 12))
    headerVer.TextTransparency = 1
    self.sideLabels[#self.sideLabels + 1] = headerName
    self.sideLabels[#self.sideLabels + 1] = headerVer
    new("Frame", { Parent = side, Position = off(0, 44), Size = dim2(1, 0, 0, 1), BackgroundColor3 = T("line") })

    self.sideList = new("ScrollingFrame", {
        Parent = side, Position = off(0, 50), Size = dim2(1, 0, 1, -100), BackgroundTransparency = 1,
        AutomaticCanvasSize = Enum_Y, ClipsDescendants = true,
    })
    new("UIListLayout", {
        Parent = self.sideList, Padding = dim(0, 4), SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
    })
    new("UIPadding", { Parent = self.sideList, PaddingTop = dim(0, 2), PaddingBottom = dim(0, 4) })

    local footer = new("Frame", { Parent = side, AnchorPoint = v2(0, 1), Position = dim2(0, 0, 1, 0), Size = dim2(1, 0, 0, 46), BackgroundTransparency = 1, ClipsDescendants = true })
    new("Frame", { Parent = footer, Size = dim2(1, 0, 0, 1), BackgroundColor3 = T("line") })
    local avatar = new("Frame", { Parent = footer, Position = off(13, 10), Size = off(26, 26), BackgroundColor3 = T("preview"), ClipsDescendants = true })
    stroke(avatar, "inline")
    local initial = new("TextLabel", {
        Parent = avatar, Size = dim2(1, 0, 1, 0), Text = lp.Name:sub(1, 1):upper(),
        TextXAlignment = ACenter, TextColor3 = T("text_active"),
    })
    local headImg = new("ImageLabel", {
        Parent = avatar, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, Image = "",
        ScaleType = Enum.ScaleType.Crop, Visible = false, ZIndex = 2,
    })
    task.spawn(function()
        local ok, img = pcall(function()
            return Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
        if ok and img and img ~= "" then
            headImg.Image = img
            headImg.Visible = true
            initial.Visible = false
        end
    end)
    local footName = label(footer, lp.Name, "text", off(46, 10), dim2(1, -50, 0, 12))
    footName.TextTruncate = Enum.TextTruncate.AtEnd
    footName.TextTransparency = 1
    local footUid = label(footer, "uid " .. tostring(lp.UserId), "mute", off(46, 22), dim2(1, -50, 0, 12))
    footUid.TextTruncate = Enum.TextTruncate.AtEnd
    footUid.TextTransparency = 1
    self.sideLabels[#self.sideLabels + 1] = footName
    self.sideLabels[#self.sideLabels + 1] = footUid

    function self:setSideExpanded(on)
        if self.sideExpanded == on then return end
        self.sideExpanded = on
        local sw = on and sideOpen or sideCollapsed
        tween(side, { Size = dim2(0, sw, 1, 0) }, 0.18)
        tween(content, { Position = off(sw, 0), Size = dim2(1, -sw, 1, 0) }, 0.18)
        tween(self.root, { Size = off(self.size.X + (on and extra or 0), self.size.Y) }, 0.18)
        local trans = on and 0 or 1
        for _, lbl in ipairs(self.sideLabels) do
            if lbl.Parent then tween(lbl, { TextTransparency = trans }, 0.12) end
        end
        for _, lbl in ipairs(self.sideBgLabels) do
            if lbl.Parent then tween(lbl, { BackgroundTransparency = trans }, 0.12) end
        end
    end

    side.MouseEnter:Connect(function() self:setSideExpanded(true) end)
    side.MouseLeave:Connect(function() self:setSideExpanded(false) end)

    local header = new("Frame", { Parent = content, Position = off(0, 2), Size = dim2(1, 0, 0, 28), BackgroundTransparency = 1, Active = true })
    local crumbs = new("Frame", { Parent = header, Position = off(8, 0), Size = dim2(0.5, 0, 1, 0), BackgroundTransparency = 1 })
    new("UIListLayout", {
        Parent = crumbs, FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center, Padding = dim(0, 4),
    })
    self.crumbCat = label(crumbs, "", "mute", nil, dim2(0, 0, 1, 0)); self.crumbCat.AutomaticSize = Enum_X
    self.crumbTab = label(crumbs, "", "text_active", nil, dim2(0, 0, 1, 0)); self.crumbTab.AutomaticSize = Enum_X

    local filterBody, filterOuter = fieldBox(header, off(58, 18), nil, "panel")
    filterOuter.AnchorPoint = v2(1, 0.5)
    filterOuter.Position = dim2(1, -8, 0.5, 0)
    filterOuter.ZIndex = 6
    local filterLbl = label(filterBody, "This Tab", "text", off(0, 0), dim2(1, 0, 1, 0), ACenter)
    local filterHit = new("TextButton", { Parent = filterOuter, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 7 })

    local searchBody, searchOuter = fieldBox(header, off(130, 18), nil, "panel")
    searchOuter.AnchorPoint = v2(1, 0.5)
    searchOuter.Position = dim2(1, -70, 0.5, 0)
    searchOuter.ZIndex = 6
    local searchInput = new("TextBox", {
        Parent = searchBody, Size = dim2(1, -10, 1, 0), Position = off(5, 0),
        PlaceholderText = "Search...", PlaceholderColor3 = T("mute"),
        ClearTextOnFocus = false, ZIndex = 7,
    })

    filterHit.MouseButton1Click:Connect(function()
        self.searchAll = not self.searchAll
        filterLbl.Text = self.searchAll and "All Tabs" or "This Tab"
        self:applySearch()
    end)
    searchInput:GetPropertyChangedSignal("Text"):Connect(function()
        self.searchQuery = searchInput.Text
        self:applySearch()
    end)

    new("Frame", { Parent = content, Position = off(0, 31), Size = dim2(1, 0, 0, 1), BackgroundColor3 = T("line") })

    self.pageHolder = new("Frame", { Parent = content, Position = off(0, 32), Size = dim2(1, 0, 1, -32), BackgroundTransparency = 1 })

    local grip = new("TextButton", {
        Parent = win, AnchorPoint = v2(1, 1), Position = dim2(1, 0, 1, 0), Size = off(16, 16),
        BackgroundTransparency = 1, ZIndex = 40, Text = "",
    })
    local gripDots = {}
    for _, p in ipairs({ {12, 12}, {8, 12}, {12, 8}, {4, 12}, {8, 8}, {12, 4} }) do
        gripDots[#gripDots + 1] = new("Frame", {
            Parent = grip, Position = off(p[1], p[2]), Size = off(2, 2), BackgroundColor3 = Theme.v.mute, ZIndex = 41,
        })
    end
    local gripHot, resizing, rStart, rSize = false, false, nil, nil
    local function paintGrip()
        local c = (gripHot or resizing) and Theme.v.accent or Theme.v.mute
        for _, d in ipairs(gripDots) do d.BackgroundColor3 = c end
    end
    Theme.on({ "accent", "mute" }, paintGrip)
    grip.MouseEnter:Connect(function() gripHot = true; paintGrip() end)
    grip.MouseLeave:Connect(function() gripHot = false; paintGrip() end)
    grip.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            rStart = i.Position
            rSize = self.size
            self:closePopups()
            paintGrip()
        end
    end)
    grip.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing = false
            paintGrip()
        end
    end)
    self:connect(UIS.InputChanged, function(i)
        if resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - rStart
            local gs = self:guiSize()
            local p = self.root.AbsolutePosition - self.gui.AbsolutePosition
            local extraNow = self.sideExpanded and extra or 0
            local maxW = math.max(minW, gs.X - p.X - extraNow - 4)
            local maxH = math.max(minH, gs.Y - p.Y - 4)
            self.size = v2(clamp(rSize.X + d.X, minW, maxW), clamp(rSize.Y + d.Y, minH, maxH))
            self:applySize()
        end
    end)

    self.notifPos = "Bottom Left"
    self.notifHolder = new("Frame", {
        Parent = self.gui, AnchorPoint = v2(0, 1), Position = dim2(0, 14, 1, -14),
        Size = off(240, 0), AutomaticSize = Enum_Y, BackgroundTransparency = 1, ZIndex = 400,
    })
    local notifLayout = new("UIListLayout", { Parent = self.notifHolder, Padding = dim(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom })

    function self:setNotifPos(pos)
        self.notifPos = pos
        local h = self.notifHolder
        if pos == "Top Left" then
            h.AnchorPoint = v2(0, 0); h.Position = dim2(0, 14, 0, 48)
            notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        elseif pos == "Top Right" then
            h.AnchorPoint = v2(1, 0); h.Position = dim2(1, -14, 0, 48)
            notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        elseif pos == "Bottom Right" then
            h.AnchorPoint = v2(1, 1); h.Position = dim2(1, -14, 1, -14)
            notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        else
            h.AnchorPoint = v2(0, 1); h.Position = dim2(0, 14, 1, -14)
            notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        end
    end

    self:drag(sideHeader, self.root)
    self:drag(header, self.root)
    self:watermark()
    self:keybindList()

    self:connect(UIS.InputBegan, function(input, gp)
        if not gp and not self.binding and input.KeyCode == self.toggleKey then
            self.root.Visible = not self.root.Visible
            self:closePopups()
        end
    end)

    self.cfgLabel = label(header, "default.cfg", "mute", nil, dim2(0, 0, 1, 0))
    self.cfgLabel.AutomaticSize = Enum_X
    self.cfgLabel.LayoutOrder = 99

    return self
end

function Library:registerElement(name, tab, row, section)
    self.searchIndex[#self.searchIndex + 1] = { name = tostring(name or ""), tab = tab, row = row, section = section }
end

function Library:applySearch()
    if self._searching then return end
    self._searching = true
    local q = lower(self.searchQuery or "")
    local cur = self.currentTab
    local all = self.searchAll
    local matchingTabs = {}
    for _, e in ipairs(self.searchIndex) do
        local match = q == "" or string.find(lower(e.name), q, 1, true) ~= nil
        e.match = match
        if match and q ~= "" and e.tab then matchingTabs[e.tab] = true end
    end
    if q ~= "" and all and cur and not matchingTabs[cur] then
        for _, t in ipairs(self.allTabs) do
            if matchingTabs[t] then t:open() break end
        end
    end
    cur = self.currentTab
    local vis = {}
    for _, e in ipairs(self.searchIndex) do
        if e.tab == cur then
            local show = q == "" or e.match
            e.row.Visible = show
            if show and e.section then vis[e.section] = true end
        end
    end
    for _, e in ipairs(self.searchIndex) do
        if e.tab == cur and e.section and e.section.container then
            e.section.container.Visible = (q == "") or vis[e.section] or false
        end
    end
    self._searching = false
end

function Library:connect(signal, fn)
    local c = signal:Connect(fn)
    table.insert(self.connections, c)
    return c
end

function Library:offsetY()
    if self.learnedY then return self.learnedY end
    local ok, abs = pcall(function() return self.gui.AbsoluteSize end)
    local vp = Workspace.CurrentCamera.ViewportSize
    if ok and abs and abs.Y > 10 then return clamp(vp.Y - abs.Y, 0, 100) end
    return 0
end

function Library:mouse()
    local m = UIS:GetMouseLocation()
    return v2(m.X, m.Y - self:offsetY())
end

function Library:calibrate(obj)
    local m = UIS:GetMouseLocation()
    local p, s = obj.AbsolutePosition, obj.AbsoluteSize
    local seen, cands = {}, {}
    local function add(c)
        if c and not seen[c] then
            seen[c] = true
            cands[#cands + 1] = c
        end
    end
    add(0)
    local ok, inset = pcall(function() return GuiService:GetGuiInset() end)
    if ok and inset then add(inset.Y) end
    local ok2, abs = pcall(function() return self.gui.AbsoluteSize end)
    if ok2 and abs and abs.Y > 10 then add(clamp(Workspace.CurrentCamera.ViewportSize.Y - abs.Y, 0, 100)) end
    local hits = {}
    for _, c in ipairs(cands) do
        local y = m.Y - c
        if m.X >= p.X and m.X <= p.X + s.X and y >= p.Y and y <= p.Y + s.Y then
            hits[#hits + 1] = c
        end
    end
    if #hits == 1 then self.learnedY = hits[1] end
end

function Library:guiSize()
    local ok, s = pcall(function() return self.gui.AbsoluteSize end)
    if not ok or not s or s.X < 10 or s.Y < 10 then
        s = Workspace.CurrentCamera.ViewportSize
    end
    return s
end

function Library:place(anchor, w, h, alignRight)
    local gs = self:guiSize()
    local guiPos = self.gui.AbsolutePosition
    local p, sz = anchor.AbsolutePosition, anchor.AbsoluteSize
    local lx = p.X - guiPos.X
    local ly = p.Y - guiPos.Y
    local x = alignRight and (lx + sz.X - w) or lx
    x = clamp(x, 2, math.max(2, gs.X - w - 2))
    local y = ly + sz.Y + 2
    if y + h > gs.Y - 2 then
        y = clamp(gs.Y - h - 2, 2, math.max(2, gs.Y - h - 2))
    end
    return off(x, y)
end

function Library:drag(handle, target)
    local dragging, startInput, startPos = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging, startInput, startPos = true, i.Position, target.Position
            self:closePopups()
        end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    self:connect(UIS.InputChanged, function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - startInput
            local vp = self:guiSize()
            local x = clamp(startPos.X.Offset + d.X, 0, math.max(0, vp.X - target.AbsoluteSize.X))
            local y = clamp(startPos.Y.Offset + d.Y, 0, math.max(0, vp.Y - target.AbsoluteSize.Y))
            target.Position = off(x, y)
        end
    end)
end

function Library:guard(sf)
    sf:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        self:closePopups()
    end)
end

function Library:setAccent(c)
    Theme.set("accent", c)
end

function Library:setFlag(flag, value)
    self.flags[flag] = value
end

function Library:syncCatchers()
    local any, two = #self.stack > 0, false
    for _, p in ipairs(self.stack) do
        if (p.level or 1) >= 2 then two = true end
    end
    self.catcher.Visible = any
    self.catcher2.Visible = two
end

function Library:openPopup(p)
    local lvl = p.level or 1
    while #self.stack > 0 and (self.stack[#self.stack].level or 1) >= lvl do
        local old = table.remove(self.stack)
        old.close()
    end
    self.stack[#self.stack + 1] = p
    self:syncCatchers()
end

function Library:closePopup(p)
    local idx
    for i, q in ipairs(self.stack) do
        if q == p then idx = i break end
    end
    if not idx then return end
    while #self.stack >= idx do
        local q = table.remove(self.stack)
        q.close()
    end
    self:syncCatchers()
end

function Library:closeLevel(level)
    while #self.stack > 0 and (self.stack[#self.stack].level or 1) >= level do
        local q = table.remove(self.stack)
        q.close()
    end
    self:syncCatchers()
end

function Library:closePopups()
    while #self.stack > 0 do
        local q = table.remove(self.stack)
        q.close()
    end
    self:syncCatchers()
end

function Library:unload()
    if self.onUnload then pcall(self.onUnload) end
    for _, c in ipairs(self.connections) do c:Disconnect() end
    self.gui:Destroy()
end

function Library:notify(a, duration, kind)
    if self.notifyEnabled == false then return end
    local text, title
    if type(a) == "table" then
        text = tostring(a.text or a.message or "")
        title = a.title
        duration = a.duration or duration
        kind = a.kind or kind
    else
        text = tostring(a)
    end
    if not kind then
        local l = lower(text)
        if l:find("fail") or l:find("unavailable") or l:find("error") then
            kind = "error"
        elseif l:find("saved") or l:find("loaded") or l:find("deleted") or l:find("copied") or l:find("reset") or l:find("default") then
            kind = "success"
        else
            kind = "info"
        end
    end
    local def = NOTIFY_KINDS[kind] or NOTIFY_KINDS.info
    title = title or def.title
    duration = duration or 3.5
    local tone = def.color or T("accent")

    while #self.notifs >= 6 do
        local old = table.remove(self.notifs, 1)
        pcall(old)
    end

    local wrap = new("Frame", {
        Parent = self.notifHolder, Size = dim2(1, 0, 0, 0), AutomaticSize = Enum_Y,
        BackgroundTransparency = 1, LayoutOrder = nxt(self),
    })
    local card = new("Frame", {
        Parent = wrap, Position = off(-260, 0), Size = dim2(1, 0, 0, 0), AutomaticSize = Enum_Y,
        BackgroundColor3 = T("outline"),
    })
    new("UIPadding", { Parent = card, PaddingTop = dim(0, 1), PaddingBottom = dim(0, 1), PaddingLeft = dim(0, 1), PaddingRight = dim(0, 1) })
    local inner = new("Frame", { Parent = card, Size = dim2(1, 0, 0, 0), AutomaticSize = Enum_Y, BackgroundColor3 = T("inline") })
    new("UIPadding", { Parent = inner, PaddingTop = dim(0, 1), PaddingBottom = dim(0, 1), PaddingLeft = dim(0, 1), PaddingRight = dim(0, 1) })
    local body = new("Frame", { Parent = inner, Size = dim2(1, 0, 0, 0), AutomaticSize = Enum_Y, BackgroundColor3 = T("body") })
    new("UIListLayout", { Parent = body, SortOrder = Enum.SortOrder.LayoutOrder })

    local topLine = new("Frame", { Parent = body, Size = dim2(1, 0, 0, 2), BackgroundColor3 = tone, LayoutOrder = 1 })
    new("UIGradient", { Parent = topLine, Rotation = 90, Color = ColorSequence.new(WHITE, rgb(150, 150, 150)) })

    local content = new("Frame", { Parent = body, Size = dim2(1, 0, 0, 0), AutomaticSize = Enum_Y, BackgroundTransparency = 1, LayoutOrder = 2 })
    new("UIPadding", { Parent = content, PaddingTop = dim(0, 6), PaddingBottom = dim(0, 7), PaddingLeft = dim(0, 10), PaddingRight = dim(0, 10) })
    new("UIListLayout", { Parent = content, Padding = dim(0, 3), SortOrder = Enum.SortOrder.LayoutOrder })

    local head = new("Frame", { Parent = content, Size = dim2(1, 0, 0, 13), BackgroundTransparency = 1, LayoutOrder = 1 })
    new("TextLabel", { Parent = head, Size = dim2(0.7, 0, 1, 0), Text = title, TextColor3 = tone })
    new("TextLabel", {
        Parent = head, AnchorPoint = v2(1, 0), Position = dim2(1, 0, 0, 0), Size = dim2(0.3, 0, 1, 0),
        Text = os.date("%H:%M"), TextColor3 = T("mute"), TextXAlignment = ARight,
    })
    new("TextLabel", {
        Parent = content, Size = dim2(1, 0, 0, 0), AutomaticSize = Enum_Y, TextWrapped = true,
        TextYAlignment = YTop, TextColor3 = T("text"), Text = text, LayoutOrder = 2,
    })

    local barBack = new("Frame", { Parent = body, Size = dim2(1, 0, 0, 2), BackgroundColor3 = T("line"), LayoutOrder = 3 })
    local bar = new("Frame", { Parent = barBack, Size = dim2(1, 0, 1, 0), BackgroundColor3 = tone })

    local hit = new("TextButton", { Parent = card, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 10 })

    local dead = false
    local function dismiss()
        if dead then return end
        dead = true
        for i, fn in ipairs(self.notifs) do
            if fn == dismiss then
                table.remove(self.notifs, i)
                break
            end
        end
        TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = off(-320, 0) }):Play()
        task.delay(0.3, function()
            if wrap.Parent then wrap:Destroy() end
        end)
    end
    self.notifs[#self.notifs + 1] = dismiss
    hit.MouseButton1Click:Connect(dismiss)

    TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = off(0, 0) }):Play()
    TweenService:Create(bar, TweenInfo.new(duration, Enum.EasingStyle.Linear), { Size = dim2(0, 0, 1, 0) }):Play()
    task.delay(duration, dismiss)
end

function Library:watermark()
    self.wmOpts = {
        showName = true, showUser = true, showFps = true, showTime = true, showPing = false, custom = "",
    }
    local outer = new("Frame", {
        Parent = self.gui, AnchorPoint = v2(1, 0), Position = dim2(1, -10, 0, 10),
        Size = dim2(0, 0, 0, 22), AutomaticSize = Enum_X, BackgroundColor3 = T("outline"),
    })
    self.watermarkFrame = outer
    new("UIPadding", { Parent = outer, PaddingTop = dim(0, 1), PaddingBottom = dim(0, 1), PaddingLeft = dim(0, 1), PaddingRight = dim(0, 1) })
    local inner = new("Frame", { Parent = outer, Size = dim2(0, 0, 1, 0), AutomaticSize = Enum_X, BackgroundColor3 = T("inline") })
    new("UIPadding", { Parent = inner, PaddingTop = dim(0, 1), PaddingBottom = dim(0, 1), PaddingLeft = dim(0, 1), PaddingRight = dim(0, 1) })
    local body = new("Frame", { Parent = inner, Size = dim2(0, 0, 1, 0), AutomaticSize = Enum_X, BackgroundColor3 = T("body") })
    local line = new("Frame", { Parent = body, Size = dim2(1, 0, 0, 2), BackgroundColor3 = T("accent"), ZIndex = 2 })
    new("UIGradient", { Parent = line, Rotation = 90, Color = ColorSequence.new(WHITE, rgb(150, 150, 150)) })

    local text = new("TextLabel", {
        Parent = body, Size = dim2(0, 0, 1, 0), AutomaticSize = Enum_X, RichText = true, TextYAlignment = YMid,
    })
    new("UIPadding", { Parent = text, PaddingLeft = dim(0, 6), PaddingRight = dim(0, 6), PaddingTop = dim(0, 1) })

    local lastFps = 60
    local function render(fps)
        lastFps = fps
        local o = self.wmOpts
        local sep = '<font color="' .. rc(Theme.v.mute) .. '"> | </font>'
        local parts = {}
        if o.showName then
            parts[#parts + 1] = '<font color="' .. rc(Theme.v.accent) .. '">' .. self.name .. '</font>'
        end
        if o.custom and o.custom ~= "" then parts[#parts + 1] = o.custom end
        if o.showUser then parts[#parts + 1] = lp.Name end
        if o.showFps then parts[#parts + 1] = tostring(fps) .. " fps" end
        if o.showPing then
            local ping = 0
            pcall(function() ping = floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
            parts[#parts + 1] = tostring(ping) .. " ms"
        end
        if o.showTime then parts[#parts + 1] = os.date("%H:%M") end
        text.Text = table.concat(parts, sep)
        outer.Visible = #parts > 0
    end
    self.wmRender = render
    Theme.on({ "accent", "mute" }, function() render(lastFps) end)

    local frames, acc = 0, 0
    self:connect(RunService.RenderStepped, function(dt)
        frames += 1
        acc += dt
        if acc >= 0.5 then
            render(floor(frames / acc + 0.5))
            frames, acc = 0, 0
        end
    end)
end

function Library:keybindList()
    local outer = new("Frame", {
        Parent = self.gui, AnchorPoint = v2(0, 0.5), Position = dim2(0, 10, 0.5, 0),
        Size = off(160, 0), AutomaticSize = Enum_Y, BackgroundColor3 = T("outline"), Visible = false,
    })
    self.kbListFrame = outer
    new("UIPadding", { Parent = outer, PaddingTop = dim(0, 1), PaddingBottom = dim(0, 1), PaddingLeft = dim(0, 1), PaddingRight = dim(0, 1) })
    local inner = new("Frame", { Parent = outer, Size = dim2(1, 0, 0, 0), AutomaticSize = Enum_Y, BackgroundColor3 = T("inline") })
    new("UIPadding", { Parent = inner, PaddingTop = dim(0, 1), PaddingBottom = dim(0, 1), PaddingLeft = dim(0, 1), PaddingRight = dim(0, 1) })
    local body = new("Frame", { Parent = inner, Size = dim2(1, 0, 0, 0), AutomaticSize = Enum_Y, BackgroundColor3 = T("body") })
    new("UIListLayout", { Parent = body, SortOrder = Enum.SortOrder.LayoutOrder, Padding = dim(0, 0) })
    local line = new("Frame", { Parent = body, Size = dim2(1, 0, 0, 2), BackgroundColor3 = T("accent"), ZIndex = 2, LayoutOrder = 0 })
    new("UIGradient", { Parent = line, Rotation = 90, Color = ColorSequence.new(WHITE, rgb(150, 150, 150)) })
    new("TextLabel", {
        Parent = body, Size = dim2(1, 0, 0, 16), Text = "Keybinds", TextColor3 = T("text"),
        TextXAlignment = ACenter, LayoutOrder = 1,
    })
    local list = new("Frame", { Parent = body, Size = dim2(1, 0, 0, 0), AutomaticSize = Enum_Y, BackgroundTransparency = 1, LayoutOrder = 2 })
    new("UIListLayout", { Parent = list, SortOrder = Enum.SortOrder.LayoutOrder, Padding = dim(0, 1) })
    new("UIPadding", { Parent = list, PaddingLeft = dim(0, 6), PaddingRight = dim(0, 6), PaddingBottom = dim(0, 4), PaddingTop = dim(0, 2) })

    function self.refreshKeybindList()
        for _, c in ipairs(list:GetChildren()) do
            if c:IsA("TextLabel") then c:Destroy() end
        end
        local order = {}
        for _, kb in pairs(self.keybinds) do order[#order + 1] = kb end
        table.sort(order, function(a, b) return tostring(a.name or "") < tostring(b.name or "") end)
        local any = false
        for i, kb in ipairs(order) do
            if kb.key then
                any = true
                local state = (kb.active or kb.mode == "Always") and "on" or "off"
                local kname = tostring(kb.name or "")
                if kname == "" or kname:match("^keybind_") or kname == "key" then kname = keyText(kb.key) end
                new("TextLabel", {
                    Parent = list, Size = dim2(1, 0, 0, 14), LayoutOrder = i,
                    Text = string.format("%s: %s (%s)", kname, state, tostring(kb.mode)),
                    TextColor3 = state == "on" and T("accent") or T("item"),
                    TextTruncate = Enum.TextTruncate.AtEnd,
                })
            end
        end
        if not any then
            new("TextLabel", { Parent = list, Size = dim2(1, 0, 0, 14), Text = "None", TextColor3 = T("mute") })
        end
    end
    Theme.on({ "accent", "item", "mute", "text" }, function()
        if self.refreshKeybindList then self.refreshKeybindList() end
    end)
end

function Library:popupList(anchor, items, o)
    local lib = self
    local level = o.level or 1
    local rowH = 18
    local maxRows = o.maxRows or 8
    local searchable = #items > 8
    local rows = math.min(math.max(#items, 1), maxRows)
    local top = searchable and 26 or 0
    local listH = rows * rowH + 6 + top + 4

    local body, outer = fieldBox(lib.gui, off(120, listH))
    outer.Visible = false
    outer.ZIndex = level >= 2 and 300 or 200
    outer.Active = true

    local P = { frame = outer, anchor = anchor, buttons = {}, open = false, level = level }

    local search
    if searchable then
        local sb = fieldBox(body, dim2(1, -8, 0, 18), off(4, 4), "panel")
        search = new("TextBox", {
            Parent = sb, Size = dim2(1, -8, 1, 0), Position = off(5, 0),
            PlaceholderText = "Search", PlaceholderColor3 = T("mute"), ClearTextOnFocus = false,
            TextTruncate = Enum.TextTruncate.AtEnd,
        })
    end

    local scrolls = #items > maxRows
    local scroller = new("ScrollingFrame", {
        Parent = body, Position = off(0, top), Size = dim2(1, 0, 1, -top), BackgroundTransparency = 1,
        AutomaticCanvasSize = Enum_Y, ScrollBarThickness = scrolls and 2 or 0,
    })
    new("UIListLayout", { Parent = scroller, SortOrder = Enum.SortOrder.LayoutOrder })
    new("UIPadding", { Parent = scroller, PaddingTop = dim(0, 3), PaddingBottom = dim(0, 3), PaddingRight = dim(0, scrolls and 3 or 0) })

    function P.refresh()
        for item, d in pairs(P.buttons) do
            local sel = o.selected(item)
            d.button.TextColor3 = sel and Theme.v.accent or Theme.v.item
            d.tick.Visible = sel
        end
    end

    for i, item in ipairs(items) do
        local row = new("Frame", { Parent = scroller, Size = dim2(1, 0, 0, rowH), BackgroundTransparency = 1, LayoutOrder = i })
        local b = new("TextButton", { Parent = row, Size = dim2(1, 0, 1, 0), Text = tostring(item), TextColor3 = Theme.v.item })
        new("UIPadding", { Parent = b, PaddingLeft = dim(0, 9) })
        local tick = new("Frame", { Parent = row, Position = off(2, 4), Size = off(2, 10), BackgroundColor3 = T("accent"), Visible = false })
        P.buttons[item] = { row = row, button = b, tick = tick }

        b.MouseEnter:Connect(function()
            if not o.selected(item) then b.TextColor3 = Theme.v.item:Lerp(WHITE, 0.4) end
        end)
        b.MouseLeave:Connect(function()
            b.TextColor3 = o.selected(item) and Theme.v.accent or Theme.v.item
        end)
        b.MouseButton1Click:Connect(function()
            o.pick(item)
            P.refresh()
            if not o.multi then lib:closePopup(P) end
        end)
    end

    Theme.on({ "accent", "item" }, P.refresh)

    if search then
        search:GetPropertyChangedSignal("Text"):Connect(function()
            local q = lower(search.Text)
            for item, d in pairs(P.buttons) do
                d.row.Visible = q == "" or string.find(lower(tostring(item)), q, 1, true) ~= nil
            end
        end)
    end

    function P.show()
        local w = math.max(anchor.AbsoluteSize.X, 90)
        if search then search.Text = "" end
        outer.Size = off(w, listH)
        outer.Position = lib:place(anchor, w, listH, o.alignRight)
        outer.Visible = true
        P.open = true
        P.refresh()
        lib:openPopup(P)
        if o.onOpen then o.onOpen() end
    end

    function P.close()
        outer.Visible = false
        P.open = false
        if o.onClose then o.onClose() end
    end

    function P.toggle()
        if P.open then
            lib:closePopup(P)
        else
            P.show()
        end
    end

    function P.destroy()
        lib:closePopup(P)
        outer:Destroy()
    end

    return P
end

function Library:category(name)
    local cat = setmetatable({ lib = self, name = name }, Category)
    local row = new("Frame", {
        Parent = self.sideList, Size = dim2(1, -12, 0, 16), BackgroundTransparency = 1, LayoutOrder = nxt(self),
    })
    new("Frame", {
        Parent = row, AnchorPoint = v2(0, 0.5), Position = dim2(0, 0, 0.5, 0),
        Size = dim2(1, 0, 0, 1), BackgroundColor3 = T("line"),
    })
    local t = new("TextLabel", {
        Parent = row, Position = off(4, 0), Size = dim2(0, 0, 1, 0), AutomaticSize = Enum_X, Text = name,
        TextColor3 = T("mute"), BackgroundColor3 = T("panel"), BackgroundTransparency = 1,
        TextTransparency = 1, ZIndex = 2,
    })
    new("UIPadding", { Parent = t, PaddingLeft = dim(0, 4), PaddingRight = dim(0, 4) })
    self.sideLabels[#self.sideLabels + 1] = t
    self.sideBgLabels[#self.sideBgLabels + 1] = t
    return cat
end

function Category:tab(name, iconName)
    local lib = self.lib
    local tab = setmetatable({ lib = lib, name = name, category = self }, Tab)
    iconName = iconName or ICON_NAMES[name] or ICON_NAMES[self.name]
    lib.allTabs[#lib.allTabs + 1] = tab

    local body, outer = fieldBox(lib.sideList, dim2(1, -12, 0, 32))
    outer.LayoutOrder = nxt(lib)
    tab.box = outer

    tab.glow = new("Frame", { Parent = body, Size = dim2(1, 0, 1, 0), BackgroundColor3 = T("accent"), Visible = false })
    new("UIGradient", { Parent = tab.glow, Transparency = NumberSequence.new(0.8, 1) })
    tab.bar = new("Frame", { Parent = body, Size = dim2(0, 2, 1, 0), BackgroundColor3 = T("accent"), Visible = false, ZIndex = 3 })

    tab.icon = new("ImageLabel", {
        Parent = body, Position = off(10, 5), Size = off(16, 16), BackgroundTransparency = 1,
        ScaleType = Enum.ScaleType.Fit, ImageColor3 = Theme.v.item, Visible = false, ZIndex = 2,
    })
    tab.glyph = new("TextLabel", {
        Parent = body, Position = off(10, 5), Size = off(16, 16), TextXAlignment = ACenter, TextYAlignment = YMid,
        TextColor3 = Theme.v.item, Visible = false, ZIndex = 2, NoSkin = true,
    })
    tab.text = label(body, name, Theme.v.item, off(34, 0), dim2(1, -34, 1, 0))
    tab.text.ZIndex = 2
    tab.text.TextTransparency = 1
    lib.sideLabels[#lib.sideLabels + 1] = tab.text

    function tab.paint()
        local on = lib.currentTab == tab
        tab.glow.Visible = on
        tab.bar.Visible = on
        outer:SetAttribute("hot", on)
        outer.BackgroundColor3 = on and Theme.v.accent or Theme.v.outline
        local ic = on and Theme.v.accent or Theme.v.item
        tab.icon.ImageColor3 = ic
        tab.glyph.TextColor3 = ic
        tab.text.TextColor3 = on and Theme.v.text_active or Theme.v.item
    end
    Theme.on({ "text_active", "item", "accent", "outline" }, tab.paint)

    Icons.bind(function()
        Icons.apply(tab.icon, tab.glyph, iconName and Icons.get(iconName), name:sub(1, 1):upper())
    end)

    tab.page = new("Frame", { Parent = lib.pageHolder, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false })
    new("UIPadding", { Parent = tab.page, PaddingTop = dim(0, 8), PaddingBottom = dim(0, 8), PaddingLeft = dim(0, 8), PaddingRight = dim(0, 8) })
    new("UIListLayout", { Parent = tab.page, FillDirection = Enum.FillDirection.Horizontal, Padding = dim(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })

    for i, sideName in ipairs({ "left", "right" }) do
        local col = new("ScrollingFrame", {
            Parent = tab.page, Size = dim2(0.5, -4, 1, 0), BackgroundTransparency = 1, LayoutOrder = i,
            AutomaticCanvasSize = Enum_Y, ScrollBarThickness = 2,
        })
        new("UIListLayout", { Parent = col, Padding = dim(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })
        new("UIPadding", {
            Parent = col, PaddingLeft = dim(0, 2), PaddingTop = dim(0, 2),
            PaddingRight = dim(0, 4), PaddingBottom = dim(0, 8),
        })
        tab[sideName] = col
    end

    local hit = new("TextButton", { Parent = outer, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 6 })
    hit.MouseButton1Click:Connect(function() tab:open() end)
    hit.MouseEnter:Connect(function()
        hot(outer, true)
        if lib.currentTab ~= tab then
            tween(tab.text, { TextColor3 = Theme.v.text_active }, 0.1)
            tween(tab.icon, { ImageColor3 = Theme.v.accent }, 0.1)
            tween(tab.glyph, { TextColor3 = Theme.v.accent }, 0.1)
        end
    end)
    hit.MouseLeave:Connect(function()
        hot(outer, lib.currentTab == tab)
        if lib.currentTab ~= tab then
            tween(tab.text, { TextColor3 = Theme.v.item }, 0.1)
            tween(tab.icon, { ImageColor3 = Theme.v.item }, 0.1)
            tween(tab.glyph, { TextColor3 = Theme.v.item }, 0.1)
        end
    end)
    return tab
end

function Tab:open()
    local lib = self.lib
    lib:closePopups()
    local prev = lib.currentTab
    lib.currentTab = self
    if prev and prev ~= self then
        prev.page.Visible = false
        prev.paint()
    end
    self.page.Visible = true
    self.paint()
    lib.crumbCat.Text = self.category.name .. " /"
    lib.crumbTab.Text = self.name
    lib:applySearch()
end

function Tab:column(side)
    local holder = (side == "right") and self.right or self.left
    return setmetatable({ lib = self.lib, tab = self, holder = holder }, Column)
end

function Tab:section(o)
    o = o or {}
    return self:column(o.side):section(o)
end

function Column:section(o)
    o = o or {}
    local lib = self.lib

    local container = new("Frame", {
        Parent = self.holder, Size = dim2(1, 0, 0, 0), AutomaticSize = Enum_Y,
        BackgroundColor3 = T("body"), LayoutOrder = nxt(lib),
    })
    stroke(container, "inline")
    new("UIListLayout", { Parent = container, SortOrder = Enum.SortOrder.LayoutOrder })

    local header = new("Frame", { Parent = container, Size = dim2(1, 0, 0, 24), BackgroundTransparency = 1, LayoutOrder = 1 })
    local glow = new("Frame", { Parent = header, Size = dim2(1, 0, 1, 0), BackgroundColor3 = T("accent") })
    new("UIGradient", { Parent = glow, Rotation = 90, Transparency = NumberSequence.new(0.88, 1) })
    accentLine(header)
    label(header, o.name or "Section", "text_active", off(8, 2), dim2(1, -16, 1, -2))
    new("Frame", { Parent = header, AnchorPoint = v2(0, 1), Position = dim2(0, 0, 1, 0), Size = dim2(1, 0, 0, 1), BackgroundColor3 = T("line") })

    local body = new("Frame", { Parent = container, Size = dim2(1, 0, 0, 0), AutomaticSize = Enum_Y, BackgroundTransparency = 1, LayoutOrder = 2 })
    new("UIPadding", { Parent = body, PaddingTop = dim(0, 8), PaddingBottom = dim(0, 8), PaddingLeft = dim(0, 8), PaddingRight = dim(0, 8) })
    new("UIListLayout", { Parent = body, Padding = dim(0, 5), SortOrder = Enum.SortOrder.LayoutOrder })

    return setmetatable({ lib = lib, body = body, container = container, tab = self.tab }, Section)
end

function Column:multi_section(o)
    o = o or {}
    local lib = self.lib
    local tab = self.tab
    local names = o.names or { "Section" }
    local fills = o.fills ~= false
    local colFrame = self.holder

    local container = new("Frame", {
        Parent = colFrame,
        Size = fills and dim2(1, 0, 0, 300) or dim2(1, 0, 0, 0),
        AutomaticSize = fills and Enum.AutomaticSize.None or Enum_Y,
        BackgroundColor3 = T("inline"),
        LayoutOrder = nxt(lib),
    })
    new("UIPadding", {
        Parent = container, PaddingTop = dim(0, 1), PaddingBottom = dim(0, 1),
        PaddingLeft = dim(0, 1), PaddingRight = dim(0, 1),
    })
    local inner = new("Frame", {
        Parent = container,
        Size = fills and dim2(1, 0, 1, 0) or dim2(1, 0, 0, 0),
        AutomaticSize = fills and Enum.AutomaticSize.None or Enum_Y,
        BackgroundColor3 = T("body"), ClipsDescendants = true,
    })
    if not fills then
        new("UIListLayout", { Parent = inner, SortOrder = Enum.SortOrder.LayoutOrder })
    end

    local header = new("Frame", {
        Parent = inner, Size = dim2(1, 0, 0, 24), BackgroundTransparency = 1, LayoutOrder = 1,
        Position = fills and off(0, 0) or UDim2.new(),
    })
    local glow = new("Frame", { Parent = header, Size = dim2(1, 0, 1, 0), BackgroundColor3 = T("accent") })
    new("UIGradient", { Parent = glow, Rotation = 90, Transparency = NumberSequence.new(0.88, 1) })
    accentLine(header)
    local bar = new("Frame", {
        Parent = header, Position = off(0, 2), Size = dim2(1, 0, 1, -3), BackgroundTransparency = 1, ZIndex = 2,
    })
    new("UIListLayout", { Parent = bar, FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder })
    new("Frame", {
        Parent = header, AnchorPoint = v2(0, 1), Position = dim2(0, 0, 1, 0),
        Size = dim2(1, 0, 0, 1), BackgroundColor3 = T("line"), ZIndex = 2,
    })

    local holder = new("Frame", {
        Parent = inner,
        Position = fills and off(0, 24) or UDim2.new(),
        Size = fills and dim2(1, 0, 1, -24) or dim2(1, 0, 0, 0),
        AutomaticSize = fills and Enum.AutomaticSize.None or Enum_Y,
        BackgroundTransparency = 1, LayoutOrder = 2,
    })

    local sections = {}
    local current = nil

    local function paint(sec)
        local on = current == sec
        sec.btn.BackgroundTransparency = on and 0 or 1
        sec.lbl.TextColor3 = on and Theme.v.text_active or Theme.v.dim
        sec.mark.Visible = on
    end

    local function select(sec)
        local old = current
        current = sec
        if old then
            old.page.Visible = false
            paint(old)
        end
        sec.page.Visible = true
        paint(sec)
        tab.activeMulti = sec
        lib:closePopups()
    end

    for i, name in ipairs(names) do
        local btn = new("TextButton", {
            Parent = bar, Size = dim2(0, 0, 1, 0), AutomaticSize = Enum_X,
            BackgroundColor3 = T("tab_active"), BackgroundTransparency = 1, LayoutOrder = i,
        })
        local lbl = new("TextLabel", {
            Parent = btn, Size = dim2(0, 0, 1, 0), AutomaticSize = Enum_X, Text = name,
            TextXAlignment = ACenter, TextColor3 = Theme.v.dim,
        })
        new("UIPadding", { Parent = lbl, PaddingLeft = dim(0, 8), PaddingRight = dim(0, 8) })
        local mark = new("Frame", {
            Parent = btn, AnchorPoint = v2(0, 1), Position = dim2(0, 0, 1, 0), Size = dim2(1, 0, 0, 2),
            BackgroundColor3 = T("accent"), Visible = false, ZIndex = 3,
        })

        local page
        if fills then
            page = new("ScrollingFrame", {
                Parent = holder, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false,
                AutomaticCanvasSize = Enum_Y, ScrollBarThickness = 2,
            })
            lib:guard(page)
        else
            page = new("Frame", {
                Parent = holder, Size = dim2(1, 0, 0, 0), AutomaticSize = Enum_Y,
                BackgroundTransparency = 1, Visible = false,
            })
        end
        new("UIPadding", { Parent = page, PaddingTop = dim(0, 9), PaddingBottom = dim(0, 9), PaddingLeft = dim(0, 8), PaddingRight = dim(0, 10) })
        new("UIListLayout", { Parent = page, Padding = dim(0, 5), SortOrder = Enum.SortOrder.LayoutOrder })

        local sec = setmetatable({ lib = lib, body = page, page = page, name = name, btn = btn, lbl = lbl, mark = mark, tab = tab }, Section)
        sections[i] = sec

        Theme.on({ "tab_active", "text_active", "dim" }, function() paint(sec) end)

        btn.MouseButton1Click:Connect(function() select(sec) end)
        btn.MouseEnter:Connect(function()
            if current ~= sec then tween(lbl, { TextColor3 = Theme.v.dim:Lerp(Theme.v.text_active, 0.5) }, 0.1) end
        end)
        btn.MouseLeave:Connect(function()
            if current ~= sec then tween(lbl, { TextColor3 = Theme.v.dim }, 0.1) end
        end)
    end

    if sections[1] then select(sections[1]) end
    return table.unpack(sections)
end

function Section:label(text)
    local lib = self.lib
    if type(text) == "table" then text = text.name or text.text end
    local row = new("Frame", { Parent = self.body, Size = dim2(1, 0, 0, 14), BackgroundTransparency = 1, LayoutOrder = nxt(lib) })
    local lbl = label(row, tostring(text or "Label"), "text", off(0, 0), dim2(1, -30, 1, 0))
    local e = setmetatable({
        lib = lib, right = makeRight(row), lbl = lbl, level = self.level,
        _labelText = tostring(text or "Label"), name = tostring(text or "Label"), row = row, section = self,
    }, Element)
    function e.set(t) lbl.Text = tostring(t) end
    lib:registerElement(tostring(text or "Label"), self.tab, row, self)
    return e
end

function Section:divider()
    local lib = self.lib
    local row = new("Frame", { Parent = self.body, Size = dim2(1, 0, 0, 5), BackgroundTransparency = 1, LayoutOrder = nxt(lib) })
    new("Frame", { Parent = row, AnchorPoint = v2(0, 0.5), Position = dim2(0, 0, 0.5, 0), Size = dim2(1, 0, 0, 1), BackgroundColor3 = T("line") })
    return row
end

function Section:button(o)
    local lib = self.lib
    local outer, lbl, hit = miniButton(self.body, nameText(o.name or "Button", o.risky), UDim2.new(), dim2(1, 0, 0, 20))
    if o.risky then lbl.RichText = true end
    outer.LayoutOrder = nxt(lib)
    hit.MouseButton1Click:Connect(function()
        lbl.TextColor3 = Theme.v.accent
        tween(lbl, { TextColor3 = Theme.v.text }, 0.3)
        if o.callback then o.callback() end
    end)
    lib:registerElement(o.name or "Button", self.tab, outer, self)
    return outer
end

function Section:toggle(o)
    local lib = self.lib
    local cfg = {
        lib = lib, name = o.name or "Toggle", flag = o.flag or o.name or "toggle",
        callback = o.callback or function() end, value = false, level = self.level,
    }

    local row = new("TextButton", { Parent = self.body, Size = dim2(1, 0, 0, 14), LayoutOrder = nxt(lib) })
    local box = hotFrame(row, off(10, 10), off(0, 2))
    local inner = new("Frame", { Parent = box, Position = off(1, 1), Size = dim2(1, -2, 1, -2), BackgroundColor3 = WHITE })
    local ig = new("UIGradient", { Parent = inner, Rotation = 90 })
    Theme.on({ "field_top", "field_bot" }, function()
        ig.Color = ColorSequence.new(Theme.v.field_top, Theme.v.field_bot)
    end)
    local fill = new("Frame", { Parent = inner, Size = dim2(1, 0, 1, 0), BackgroundColor3 = T("accent"), BackgroundTransparency = 1 })
    new("UIGradient", { Parent = fill, Rotation = 90, Color = ColorSequence.new(WHITE, rgb(150, 150, 150)) })
    local lbl = label(row, nameText(cfg.name, o.risky), Theme.v.item, off(18, 0), dim2(1, -18, 1, 0))
    if o.risky then lbl.RichText = true end
    cfg.right = makeRight(row)

    Theme.on({ "text", "item" }, function()
        lbl.TextColor3 = cfg.value and Theme.v.text or Theme.v.item
    end)

    function cfg.set(v, instant)
        cfg.value = v and true or false
        lib:setFlag(cfg.flag, cfg.value)
        local ft = cfg.value and 0 or 1
        local tc = cfg.value and Theme.v.text or Theme.v.item
        if instant == true then
            fill.BackgroundTransparency = ft
            lbl.TextColor3 = tc
        else
            tween(fill, { BackgroundTransparency = ft })
            tween(lbl, { TextColor3 = tc })
        end
        cfg.callback(cfg.value)
    end

    row.MouseButton1Click:Connect(function() cfg.set(not cfg.value) end)
    row.MouseEnter:Connect(function()
        if not cfg.value then tween(lbl, { TextColor3 = Theme.v.item:Lerp(Theme.v.text, 0.5) }, 0.1) end
        hot(box, true)
    end)
    row.MouseLeave:Connect(function()
        if not cfg.value then tween(lbl, { TextColor3 = Theme.v.item }, 0.1) end
        hot(box, false)
    end)

    lib.setters[cfg.flag] = cfg.set
    cfg.set(o.default or false, true)
    lib:registerElement(cfg.name, self.tab, row, self)
    cfg.row = row
    cfg.section = self

    return setmetatable(cfg, Element)
end

function Section:textbox(o)
    local lib = self.lib
    o = o or {}
    local cfg = {
        lib = lib, name = o.name or "Textbox", flag = o.flag or o.name or "textbox",
        callback = o.callback or function() end, value = tostring(o.default or ""),
        level = self.level,
    }

    local row = new("Frame", { Parent = self.body, Size = dim2(1, 0, 0, 34), BackgroundTransparency = 1, LayoutOrder = nxt(lib) })
    local lbl = label(row, nameText(cfg.name, o.risky), "item", off(0, 0), dim2(1, 0, 0, 14))
    if o.risky then lbl.RichText = true end

    local body, outer = fieldBox(row, dim2(1, 0, 0, 18), off(0, 16))
    local box = new("TextBox", {
        Parent = body, Size = dim2(1, -10, 1, 0), Position = off(5, 0),
        Text = cfg.value, PlaceholderText = o.placeholder or "", PlaceholderColor3 = T("mute"),
        ClearTextOnFocus = false, TextXAlignment = ALeft, ZIndex = 3,
    })

    function cfg.set(v)
        cfg.value = tostring(v or "")
        if not box:IsFocused() then box.Text = cfg.value end
        lib:setFlag(cfg.flag, cfg.value)
        cfg.callback(cfg.value)
    end

    box.FocusLost:Connect(function()
        cfg.set(box.Text)
    end)
    box:GetPropertyChangedSignal("Text"):Connect(function()
        if box:IsFocused() then
            cfg.value = box.Text
            lib:setFlag(cfg.flag, cfg.value)
        end
    end)

    lib.setters[cfg.flag] = cfg.set
    lib:setFlag(cfg.flag, cfg.value)
    lib:registerElement(cfg.name, self.tab, row, self)
    cfg.row = row
    cfg.section = self
    cfg.right = makeRight(row)
    return setmetatable(cfg, Element)
end

function Section:dropdown(o)
    local lib = self.lib
    o = o or {}
    local items = o.items or {}
    local multi = o.multi == true
    local cfg = {
        lib = lib, name = o.name or "Dropdown", flag = o.flag or o.name or "dropdown",
        callback = o.callback or function() end, multi = multi, level = self.level,
        items = items,
    }

    if multi then
        local def = o.default
        if type(def) ~= "table" then def = {} end
        cfg.value = {}
        for _, v in ipairs(def) do cfg.value[v] = true end
        cfg.list = {}
        for _, v in ipairs(def) do cfg.list[#cfg.list + 1] = v end
    else
        cfg.value = o.default or (items[1] or "None")
    end

    local row = new("Frame", { Parent = self.body, Size = dim2(1, 0, 0, 34), BackgroundTransparency = 1, LayoutOrder = nxt(lib) })
    local lbl = label(row, nameText(cfg.name, o.risky), "item", off(0, 0), dim2(1, 0, 0, 14))
    if o.risky then lbl.RichText = true end

    local body, outer = fieldBox(row, dim2(1, 0, 0, 18), off(0, 16))
    local valLbl = label(body, "", "text", off(6, 0), dim2(1, -20, 1, 0), ALeft)
    valLbl.TextTruncate = Enum.TextTruncate.AtEnd
    local arrow = label(body, "v", "mute", nil, dim2(0, 14, 1, 0), ACenter)
    arrow.AnchorPoint = v2(1, 0)
    arrow.Position = dim2(1, -2, 0, 0)

    local function display()
        if multi then
            local parts = {}
            for _, v in ipairs(cfg.list or {}) do
                if cfg.value[v] then parts[#parts + 1] = tostring(v) end
            end
            valLbl.Text = #parts > 0 and table.concat(parts, ", ") or "None"
        else
            valLbl.Text = tostring(cfg.value or "None")
        end
    end
    display()

    local hit = new("TextButton", { Parent = outer, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 5 })
    hit.MouseEnter:Connect(function() hot(outer, true) end)
    hit.MouseLeave:Connect(function() if not (cfg._popup and cfg._popup.open) then hot(outer, false) end end)

    local function selected(item)
        if multi then
            return cfg.value[item] == true
        end
        return cfg.value == item
    end

    local function pick(item)
        if multi then
            if cfg.value[item] then
                cfg.value[item] = nil
                for i, v in ipairs(cfg.list) do
                    if v == item then table.remove(cfg.list, i) break end
                end
            else
                cfg.value[item] = true
                cfg.list[#cfg.list + 1] = item
            end
            local out = {}
            for _, v in ipairs(cfg.list) do if cfg.value[v] then out[#out + 1] = v end end
            lib:setFlag(cfg.flag, out)
            cfg.callback(out)
        else
            cfg.value = item
            lib:setFlag(cfg.flag, item)
            cfg.callback(item)
        end
        display()
    end

    local P
    hit.MouseButton1Click:Connect(function()
        if P and P.open then
            lib:closePopup(P)
            return
        end
        P = lib:popupList(outer, cfg.items, {
            multi = multi,
            selected = selected,
            pick = pick,
            alignRight = false,
            onClose = function() hot(outer, false) end,
        })
        cfg._popup = P
        P.show()
        hot(outer, true)
    end)

    function cfg.set(v)
        if multi then
            cfg.value = {}
            cfg.list = {}
            if type(v) == "table" then
                for _, x in ipairs(v) do
                    cfg.value[x] = true
                    cfg.list[#cfg.list + 1] = x
                end
            end
            local out = {}
            for _, x in ipairs(cfg.list) do out[#out + 1] = x end
            lib:setFlag(cfg.flag, out)
            cfg.callback(out)
        else
            cfg.value = v
            lib:setFlag(cfg.flag, v)
            cfg.callback(v)
        end
        display()
    end

    function cfg.setItems(list)
        cfg.items = list or {}
        if not multi then
            local found = false
            for _, it in ipairs(cfg.items) do
                if it == cfg.value then found = true break end
            end
            if not found and cfg.items[1] then
                cfg.set(cfg.items[1])
            end
        end
        display()
    end

    if multi then
        local out = {}
        for _, v in ipairs(cfg.list) do out[#out + 1] = v end
        lib:setFlag(cfg.flag, out)
    else
        lib:setFlag(cfg.flag, cfg.value)
    end
    lib.setters[cfg.flag] = cfg.set
    lib:registerElement(cfg.name, self.tab, row, self)
    cfg.row = row
    cfg.section = self
    cfg.right = makeRight(row)
    return setmetatable(cfg, Element)
end

function Section:slider(o)
    local lib = self.lib
    o = o or {}
    local min = o.min or 0
    local max = o.max or 100
    local interval = o.interval or 1
    local cfg = {
        lib = lib, name = o.name or "Slider", flag = o.flag or o.name or "slider",
        callback = o.callback or function() end, min = min, max = max, interval = interval,
        value = o.default ~= nil and o.default or min, level = self.level,
    }

    local row = new("Frame", { Parent = self.body, Size = dim2(1, 0, 0, 28), BackgroundTransparency = 1, LayoutOrder = nxt(lib) })
    local top = new("Frame", { Parent = row, Size = dim2(1, 0, 0, 14), BackgroundTransparency = 1 })
    local lbl = label(top, nameText(cfg.name, o.risky), "item", off(0, 0), dim2(1, -40, 1, 0))
    if o.risky then lbl.RichText = true end
    local valLbl = label(top, "", "text", nil, dim2(0, 40, 1, 0), ARight)
    valLbl.AnchorPoint = v2(1, 0)
    valLbl.Position = dim2(1, 0, 0, 0)

    local trackOuter = hotFrame(row, dim2(1, 0, 0, 8), off(0, 16))
    local trackInner = new("Frame", { Parent = trackOuter, Position = off(1, 1), Size = dim2(1, -2, 1, -2), BackgroundColor3 = T("field_bot") })
    local fill = new("Frame", { Parent = trackInner, Size = dim2(0, 0, 1, 0), BackgroundColor3 = T("accent") })
    new("UIGradient", { Parent = fill, Rotation = 90, Color = ColorSequence.new(WHITE, rgb(150, 150, 150)) })

    local function round(v)
        if interval <= 0 then return v end
        return math.floor(v / interval + 0.5) * interval
    end

    local function render()
        local t = (cfg.value - min) / math.max(max - min, 1e-9)
        fill.Size = dim2(clamp(t, 0, 1), 0, 1, 0)
        local s
        if interval >= 1 then
            s = tostring(floor(cfg.value + 0.5))
        else
            local decimals = 0
            local x = interval
            while x < 1 and decimals < 4 do
                x = x * 10
                decimals += 1
            end
            s = string.format("%." .. decimals .. "f", cfg.value)
        end
        valLbl.Text = s
    end

    function cfg.set(v, silent)
        cfg.value = clamp(round(v), min, max)
        lib:setFlag(cfg.flag, cfg.value)
        render()
        if not silent then cfg.callback(cfg.value) end
    end

    local dragging = false
    local function updateFromMouse()
        local m = lib:mouse()
        local p = trackInner.AbsolutePosition
        local s = trackInner.AbsoluteSize
        local t = clamp((m.X - p.X) / math.max(s.X, 1), 0, 1)
        cfg.set(min + t * (max - min))
    end

    local hit = new("TextButton", { Parent = trackOuter, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 5 })
    hit.MouseButton1Down:Connect(function()
        lib:calibrate(trackInner)
        dragging = true
        hot(trackOuter, true)
        updateFromMouse()
    end)
    hit.MouseEnter:Connect(function() hot(trackOuter, true) end)
    hit.MouseLeave:Connect(function() if not dragging then hot(trackOuter, false) end end)

    lib:connect(UIS.InputEnded, function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            hot(trackOuter, false)
        end
    end)
    lib:connect(UIS.InputChanged, function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            updateFromMouse()
        end
    end)

    lib.setters[cfg.flag] = cfg.set
    cfg.set(cfg.value, true)
    lib:registerElement(cfg.name, self.tab, row, self)
    cfg.row = row
    cfg.section = self
    cfg.right = makeRight(row)
    return setmetatable(cfg, Element)
end

function Column:preview(o)
    o = o or {}
    local lib = self.lib
    local name = o.name or "Preview"

    local container = new("Frame", {
        Parent = self.holder, Size = dim2(1, 0, 0, 220),
        BackgroundColor3 = T("body"), LayoutOrder = nxt(lib),
    })
    stroke(container, "inline")
    new("UIListLayout", { Parent = container, SortOrder = Enum.SortOrder.LayoutOrder })

    local header = new("Frame", { Parent = container, Size = dim2(1, 0, 0, 24), BackgroundTransparency = 1, LayoutOrder = 1 })
    local glow = new("Frame", { Parent = header, Size = dim2(1, 0, 1, 0), BackgroundColor3 = T("accent") })
    new("UIGradient", { Parent = glow, Rotation = 90, Transparency = NumberSequence.new(0.88, 1) })
    accentLine(header)
    label(header, name, "text_active", off(8, 2), dim2(1, -16, 1, -2))
    new("Frame", { Parent = header, AnchorPoint = v2(0, 1), Position = dim2(0, 0, 1, 0), Size = dim2(1, 0, 0, 1), BackgroundColor3 = T("line") })

    local body = new("Frame", {
        Parent = container, Size = dim2(1, 0, 1, -24), BackgroundColor3 = T("preview"),
        LayoutOrder = 2, ClipsDescendants = true,
    })

    local viewport = new("Frame", {
        Parent = body, Size = dim2(1, -16, 1, -16), Position = off(8, 8),
        BackgroundTransparency = 1, ClipsDescendants = true,
    })

    local lines = {}
    for i = 1, 16 do
        lines[i] = newLine(viewport, 5)
    end

    local angle = 0
    local running = true
    local conn
    conn = RunService.RenderStepped:Connect(function(dt)
        if not running or not viewport.Parent then
            if conn then conn:Disconnect() end
            return
        end
        angle = (angle + dt * 0.6) % (math.pi * 2)
        local w, h = viewport.AbsoluteSize.X, viewport.AbsoluteSize.Y
        if w < 10 or h < 10 then return end
        local cx, cy = w * 0.5, h * 0.55
        local scale = math.min(w, h) * 0.28
        local cos, sin = math.cos(angle), math.sin(angle)

        local function pt(x, y, z)
            local rx = x * cos - z * sin
            local rz = x * sin + z * cos
            local persp = 1 / (1 + rz * 0.35)
            return v2(cx + rx * scale * persp, cy - y * scale * persp)
        end

        local head = pt(0, 1.1, 0)
        local neck = pt(0, 0.85, 0)
        local hip  = pt(0, 0.15, 0)
        local ls   = pt(-0.35, 0.7, 0)
        local rs   = pt(0.35, 0.7, 0)
        local lh   = pt(-0.45, 0.35, 0.1)
        local rh   = pt(0.45, 0.35, -0.1)
        local lk   = pt(-0.15, -0.35, 0.05)
        local rk   = pt(0.15, -0.35, -0.05)
        local lf   = pt(-0.18, -0.85, 0.1)
        local rf   = pt(0.18, -0.85, -0.1)

        local segs = {
            {head, neck}, {neck, hip}, {neck, ls}, {neck, rs},
            {ls, lh}, {rs, rh}, {hip, lk}, {hip, rk},
            {lk, lf}, {rk, rf},
        }
        local accent = Theme.v.accent
        for i = 1, #lines do
            if segs[i] then
                lines[i].color(accent)
                lines[i].set(segs[i][1], segs[i][2])
            else
                lines[i].hide()
            end
        end
    end)

    lib:connect(container.AncestryChanged, function()
        if not container.Parent then
            running = false
            if conn then conn:Disconnect() end
        end
    end)

    return container
end

function Element:gear(o)
    o = o or {}
    local lib = self.lib
    local W = o.width or 226

    local btn = new("TextButton", {
        Parent = self.right, Size = off(14, 14), BackgroundTransparency = 1,
        LayoutOrder = 2000, Text = "", ZIndex = 3,
    })
    local img = new("ImageLabel", {
        Parent = btn, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1,
        ScaleType = Enum.ScaleType.Fit, ImageColor3 = Theme.v.dim, Visible = false, ZIndex = 4,
    })
    local glyph = new("TextLabel", {
        Parent = btn, Size = dim2(1, 0, 1, 0), TextXAlignment = ACenter, TextYAlignment = YMid,
        TextColor3 = Theme.v.dim, Visible = false, ZIndex = 4, NoSkin = true,
    })
    Icons.bind(function()
        Icons.apply(img, glyph, Icons.get("settings"), "*")
    end)

    local hovering = false
    local P = { level = 1, open = false }

    local function paint()
        local c = (P.open or hovering) and Theme.v.accent or Theme.v.dim
        img.ImageColor3 = c
        glyph.TextColor3 = c
    end
    Theme.on({ "accent", "dim" }, paint)

    local outer = new("Frame", {
        Parent = lib.gui, Size = off(W, 0), AutomaticSize = Enum_Y, BackgroundColor3 = T("outline"),
        Visible = false, ZIndex = 200, Active = true,
    })
    new("UIPadding", { Parent = outer, PaddingTop = dim(0, 1), PaddingBottom = dim(0, 1), PaddingLeft = dim(0, 1), PaddingRight = dim(0, 1) })
    local mid = new("Frame", { Parent = outer, Size = dim2(1, 0, 0, 0), AutomaticSize = Enum_Y, BackgroundColor3 = T("inline") })
    new("UIPadding", { Parent = mid, PaddingTop = dim(0, 1), PaddingBottom = dim(0, 1), PaddingLeft = dim(0, 1), PaddingRight = dim(0, 1) })
    local bg = new("Frame", { Parent = mid, Size = dim2(1, 0, 0, 0), AutomaticSize = Enum_Y, BackgroundColor3 = T("body") })
    new("UIListLayout", { Parent = bg, SortOrder = Enum.SortOrder.LayoutOrder })

    local header = new("Frame", { Parent = bg, Size = dim2(1, 0, 0, 8), BackgroundTransparency = 1, LayoutOrder = 1 })
    local hglow = new("Frame", { Parent = header, Size = dim2(1, 0, 1, 0), BackgroundColor3 = T("accent") })
    new("UIGradient", { Parent = hglow, Rotation = 90, Transparency = NumberSequence.new(0.88, 1) })
    accentLine(header)
    new("Frame", { Parent = header, AnchorPoint = v2(0, 1), Position = dim2(0, 0, 1, 0), Size = dim2(1, 0, 0, 1), BackgroundColor3 = T("line") })

    local content = new("Frame", { Parent = bg, Size = dim2(1, 0, 0, 0), AutomaticSize = Enum_Y, BackgroundTransparency = 1, LayoutOrder = 2 })
    new("UIPadding", { Parent = content, PaddingTop = dim(0, 8), PaddingBottom = dim(0, 8), PaddingLeft = dim(0, 8), PaddingRight = dim(0, 8) })
    new("UIListLayout", { Parent = content, Padding = dim(0, 5), SortOrder = Enum.SortOrder.LayoutOrder })

    P.frame = outer
    P.anchor = btn

    function P.show()
        local h = outer.AbsoluteSize.Y
        if h < 10 then h = 160 end
        outer.Position = lib:place(btn, W, h, true)
        outer.Visible = true
        P.open = true
        paint()
        lib:openPopup(P)
        task.defer(function()
            if P.open and outer.AbsoluteSize.Y > 10 then
                outer.Position = lib:place(btn, W, outer.AbsoluteSize.Y, true)
            end
        end)
    end

    function P.close()
        outer.Visible = false
        P.open = false
        paint()
    end

    btn.MouseEnter:Connect(function() hovering = true; paint() end)
    btn.MouseLeave:Connect(function() hovering = false; paint() end)
    btn.MouseButton1Click:Connect(function()
        if P.open then
            lib:closePopup(P)
        else
            P.show()
        end
    end)

    return setmetatable({ lib = lib, body = content, container = outer, level = 2 }, Section)
end

function Element:colorpicker(o)
    o = o or {}
    local lib = self.lib
    local lvl = self.level or 1
    lib.cpCount += 1

    local cp = { flag = o.flag or ("color_" .. lib.cpCount), callback = o.callback or function() end, open = false }
    local start = typeof(o.color) == "Color3" and o.color or WHITE
    local h, s, v = start:ToHSV()
    local a = type(o.alpha) == "number" and clamp(o.alpha, 0, 1) or 1

    local swBody, swOuter = fieldBox(self.right, off(24, 11), nil, WHITE, rgb(170, 170, 170))
    swOuter.LayoutOrder = lib.cpCount
    swBody.BackgroundColor3 = start
    local swHit = new("TextButton", { Parent = swOuter, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 5 })
    swHit.MouseEnter:Connect(function() hot(swOuter, true) end)
    swHit.MouseLeave:Connect(function() if not cp.open then hot(swOuter, false) end end)

    local PW, PH = 196, 176
    local pb, pop = framed(lib.gui, off(PW, PH), nil, "body")
    pop.Visible = false
    pop.ZIndex = lvl >= 2 and 300 or 200
    pop.Active = true

    local hueInner = slimBar(pb, off(6, 6), off(18, 108))
    new("UIGradient", {
        Parent = hueInner, Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, rgb(255, 0, 0)), ColorSequenceKeypoint.new(0.17, rgb(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, rgb(0, 255, 0)), ColorSequenceKeypoint.new(0.5, rgb(0, 255, 255)),
            ColorSequenceKeypoint.new(0.67, rgb(0, 0, 255)), ColorSequenceKeypoint.new(0.83, rgb(255, 0, 255)),
            ColorSequenceKeypoint.new(1, rgb(255, 0, 0)),
        }),
    })
    local hueBtn = new("TextButton", { Parent = hueInner, Size = dim2(1, 0, 1, 0), ZIndex = 3 })
    local hueCursor = new("Frame", { Parent = hueInner, AnchorPoint = v2(0.5, 0.5), Size = dim2(1, 4, 0, 3), BackgroundColor3 = WHITE, ZIndex = 4 })
    stroke(hueCursor, "outline")

    local sv = slimBar(pb, off(30, 6), off(160, 108))
    sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
    sv.ClipsDescendants = true
    local whiteL = new("Frame", { Parent = sv, Size = dim2(1, 0, 1, 0), BackgroundColor3 = WHITE })
    new("UIGradient", { Parent = whiteL, Transparency = NumberSequence.new(0, 1) })
    local blackL = new("Frame", { Parent = sv, Size = dim2(1, 0, 1, 0), BackgroundColor3 = rgb(0, 0, 0) })
    new("UIGradient", { Parent = blackL, Rotation = 90, Transparency = NumberSequence.new(1, 0) })
    local svBtn = new("TextButton", { Parent = sv, Size = dim2(1, 0, 1, 0), ZIndex = 3 })
    local svCursor = new("Frame", { Parent = sv, AnchorPoint = v2(0.5, 0.5), Size = off(6, 6), BackgroundColor3 = WHITE, ZIndex = 4 })
    new("UICorner", { Parent = svCursor, CornerRadius = dim(1, 0) })

    local alphaInner = slimBar(pb, off(6, 120), off(96, 20))
    alphaInner.ClipsDescendants = true
    new("ImageLabel", {
        Parent = alphaInner, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1,
        Image = "rbxassetid://18274452449", ScaleType = Enum.ScaleType.Tile, TileSize = off(6, 6),
    })
    local alphaTint = new("Frame", { Parent = alphaInner, Size = dim2(1, 0, 1, 0), BackgroundColor3 = start, ZIndex = 2 })
    new("UIGradient", { Parent = alphaTint, Transparency = NumberSequence.new(1, 0) })
    local alphaBtn = new("TextButton", { Parent = alphaInner, Size = dim2(1, 0, 1, 0), ZIndex = 3 })
    local alphaCursor = new("Frame", { Parent = alphaInner, AnchorPoint = v2(0.5, 0.5), Size = dim2(0, 3, 1, 4), BackgroundColor3 = WHITE, ZIndex = 4 })
    stroke(alphaCursor, "outline")

    local copyOuter, copyLbl, copyHit = miniButton(pb, "Copy", off(106, 120), off(38, 20))
    local pasteOuter, pasteLbl, pasteHit = miniButton(pb, "Paste", off(148, 120), off(36, 20))

    local hexBody = fieldBox(pb, off(178, 22), off(6, 144))
    local hexBox = new("TextBox", {
        Parent = hexBody, Size = dim2(1, -8, 1, 0), Position = off(5, 0), ClearTextOnFocus = false,
        TextXAlignment = ACenter, PlaceholderText = "#Hex", PlaceholderColor3 = T("mute"),
    })

    local function apply()
        local c = Color3.fromHSV(h, s, v)
        swBody.BackgroundColor3 = c
        sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        svCursor.Position = dim2(s, 0, 1 - v, 0)
        hueCursor.Position = dim2(0.5, 0, h, 0)
        alphaCursor.Position = dim2(a, 0, 0.5, 0)
        alphaTint.BackgroundColor3 = c
        if not hexBox:IsFocused() then hexBox.Text = "#" .. toHex(c) end
        lib:setFlag(cp.flag, c)
        lib:setFlag(cp.flag .. "_alpha", a)
        cp.callback(c, a)
    end

    local mode
    local function update()
        local m = lib:mouse()
        if mode == "sv" then
            s = clamp((m.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
            v = 1 - clamp((m.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
        elseif mode == "hue" then
            h = clamp((m.Y - hueInner.AbsolutePosition.Y) / hueInner.AbsoluteSize.Y, 0, 0.999)
        elseif mode == "alpha" then
            a = clamp((m.X - alphaInner.AbsolutePosition.X) / alphaInner.AbsoluteSize.X, 0, 1)
        end
        apply()
    end

    svBtn.MouseButton1Down:Connect(function() lib:calibrate(sv); mode = "sv"; update() end)
    hueBtn.MouseButton1Down:Connect(function() lib:calibrate(hueInner); mode = "hue"; update() end)
    alphaBtn.MouseButton1Down:Connect(function() lib:calibrate(alphaInner); mode = "alpha"; update() end)
    lib:connect(UIS.InputEnded, function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then mode = nil end
    end)
    lib:connect(UIS.InputChanged, function(i)
        if mode and i.UserInputType == Enum.UserInputType.MouseMovement then update() end
    end)

    hexBox.FocusLost:Connect(function()
        local c, al = parseHex(hexBox.Text)
        if c then
            h, s, v = c:ToHSV()
            if al then a = al end
        end
        apply()
    end)

    local flashToken = 0
    local function flash(lbl, text, original)
        flashToken += 1
        local token = flashToken
        lbl.Text = text
        lbl.TextColor3 = Theme.v.accent
        task.delay(0.8, function()
            if token == flashToken then
                lbl.Text = original
                lbl.TextColor3 = Theme.v.text
            end
        end)
    end

    copyHit.MouseButton1Click:Connect(function()
        local c = Color3.fromHSV(h, s, v)
        lib.clipboard = { color = c, alpha = a }
        if typeof(setclipboard) == "function" then pcall(setclipboard, "#" .. toHex(c)) end
        flash(copyLbl, "Copied", "Copy")
    end)

    pasteHit.MouseButton1Click:Connect(function()
        if lib.clipboard then
            h, s, v = lib.clipboard.color:ToHSV()
            a = lib.clipboard.alpha
            apply()
            flash(pasteLbl, "Pasted", "Paste")
        else
            flash(pasteLbl, "Empty", "Paste")
        end
    end)

    local popup = { frame = pop, anchor = swOuter, level = lvl }
    function popup.close()
        pop.Visible = false
        cp.open = false
        hot(swOuter, false)
    end

    swHit.MouseButton1Click:Connect(function()
        if cp.open then
            lib:closePopup(popup)
            return
        end
        cp.open = true
        pop.Position = lib:place(swOuter, PW, PH, true)
        pop.Visible = true
        hot(swOuter, true)
        lib:openPopup(popup)
    end)

    function cp.set(c, al)
        if typeof(c) == "Color3" then h, s, v = c:ToHSV() end
        if type(al) == "number" then a = clamp(al, 0, 1) end
        apply()
    end

    lib.setters[cp.flag] = cp.set
    apply()

    return self
end

function Element:keybind(o)
    o = o or {}
    local lib = self.lib
    lib.cpCount += 1

    local kb = {
        flag = o.flag or ("keybind_" .. lib.cpCount),
        mode = o.mode or "Toggle",
        key = parseKey(o.key),
        active = false, binding = false,
        callback = o.callback or function() end,
        onBind = o.onBind or function() end,
        name = o.name or self.name,
    }

    local body, outer = fieldBox(self.right, off(54, 13))
    outer.LayoutOrder = 1000 + lib.cpCount
    local keyLbl = label(body, "None", "item", off(0, 0), dim2(1, 0, 1, 0), ACenter)
    keyLbl.TextTruncate = Enum.TextTruncate.AtEnd

    local hit = new("TextButton", { Parent = outer, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 3 })

    local function render()
        keyLbl.Text = kb.binding and "..." or keyText(kb.key)
        keyLbl.TextColor3 = (kb.binding or kb.active) and Theme.v.accent or Theme.v.item
    end
    Theme.on({ "accent", "item" }, render)

    local function refresh()
        if lib.refreshKeybindList then lib.refreshKeybindList() end
    end

    function kb.set(k)
        kb.key = parseKey(k)
        render()
        lib:setFlag(kb.flag, kb.key)
        refresh()
    end

    local bindConn
    local bindPopup = { level = 3, close = function()
        if bindConn then bindConn:Disconnect() bindConn = nil end
        kb.binding = false
        lib.binding = false
        render()
    end }

    hit.MouseButton1Click:Connect(function()
        if kb.binding then return end
        kb.binding = true
        lib.binding = true
        render()
        lib:openPopup(bindPopup)
        bindConn = UIS.InputBegan:Connect(function(input, gp)
            if gp then return end
            local k = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode or input.UserInputType
            if k then
                kb.key = parseKey(k)
                if kb.onBind then kb.onBind(k) end
                lib:setFlag(kb.flag, kb.key)
            end
            bindPopup.close()
            refresh()
        end)
    end)

    local function fire(state)
        if kb.mode == "Always" then
            kb.active = true
        else
            kb.active = state and true or false
        end
        render()
        refresh()
        kb.callback(kb.active)
    end

    lib:connect(UIS.InputBegan, function(input, gp)
        if gp or not kb.key or kb.binding then return end
        if input.KeyCode == kb.key or input.UserInputType == kb.key then
            if kb.mode == "Toggle" then
                fire(not kb.active)
            else
                fire(true)
            end
        end
    end)

    lib:connect(UIS.InputEnded, function(input)
        if not kb.key or kb.binding then return end
        if input.KeyCode == kb.key or input.UserInputType == kb.key then
            if kb.mode == "Hold" then fire(false) end
        end
    end)

    lib.keybinds[kb.flag] = kb
    lib.setters[kb.flag] = kb.set
    render()
    refresh()

    return self
end

function Library:exportConfig()
    local out = {}
    for k, v in pairs(self.flags) do
        if not isUiFlag(k) or k:match("^__theme_") or k:match("^__ui_") or k:match("^__cfg_") or k:match("^__wm_") or k:match("^__notif") or k:match("^__menu") or k:match("^__kb") or k:match("^__watermark") or k:match("^__notifs") then
            out[k] = encode(v)
        end
    end
    for k, c in pairs(Theme.v) do
        out["__theme_" .. k] = encode(c)
    end
    out["__ui_font"] = self.flags["__ui_font"] or "Tahoma 8px"
    out["__ui_size"] = self.flags["__ui_size"] or UI.size
    return HttpService:JSONEncode(out)
end

function Library:importConfig(data)
    if type(data) ~= "string" or data == "" then return false end
    local ok, decoded = pcall(function() return HttpService:JSONDecode(data) end)
    if not ok or type(decoded) ~= "table" then return false end
    for k, v in pairs(decoded) do
        local val = decode(v)
        local setter = self.setters[k]
        if setter then
            pcall(setter, val)
        else
            self.flags[k] = val
            if k:match("^__theme_") then
                local key = k:sub(9)
                if Theme.v[key] ~= nil and typeof(val) == "Color3" then
                    Theme.set(key, val)
                end
            end
        end
    end
    return true
end

function Library:configTab(tab)
    local lib = self
    local base = (lower(lib.folder):gsub("%W", ""))
    local cfgFolder = base .. "_configs"
    local themeFolder = base .. "_themes"
    local canFs = typeof(writefile) == "function" and typeof(readfile) == "function" and typeof(listfiles) == "function"

    if canFs and typeof(makefolder) == "function" then
        for _, f in ipairs({ cfgFolder, themeFolder }) do
            local exists = typeof(isfolder) == "function" and isfolder(f)
            if not exists then pcall(makefolder, f) end
        end
    end

    local function listFiles(folder, ext)
        local out = {}
        if not canFs then return out end
        local ok, files = pcall(listfiles, folder)
        if not ok then return out end
        for _, f in ipairs(files) do
            local n = tostring(f):match("([^/\\]+)%." .. ext .. "$")
            if n then table.insert(out, n) end
        end
        table.sort(out)
        return out
    end

    local function cfgItems()
        local out = listFiles(cfgFolder, "cfg")
        if #out == 0 then out[1] = "default" end
        return out
    end

    local function readTxt(path, fallback)
        if not canFs then return fallback end
        local ok, data = pcall(readfile, path)
        if not ok or not data then return fallback end
        data = (tostring(data):gsub("^%s+", ""):gsub("%s+$", ""))
        if data == "" then return fallback end
        return data
    end
    local function writeTxt(path, value)
        if not canFs then return end
        pcall(writefile, path, tostring(value or ""))
    end

    local left = tab:column("left")
    local right = tab:column("right")
    local cfgSec = left:section({ name = "Config" })
    local autoSec = left:section({ name = "Auto Config" })
    local menuSec = right:section({ name = "Menu" })
    local themeSec, colorSec, fontSec = right:multi_section({ names = { "Theme", "Colors", "Font" }, fills = false })

    local nameBox = cfgSec:textbox({ name = "Config Name", flag = "__cfg_name", placeholder = "Name" })
    local picker = cfgSec:dropdown({ name = "Saved Configs", flag = "__cfg_list", items = cfgItems() })

    local function cfgTarget()
        local n = nameBox.value
        if n == nil or n == "" then n = picker.value end
        return tostring(n or "default")
    end

    local savedAutoLoad = readTxt(cfgFolder .. "/autoload_name.txt", "default")
    local savedAutoSave = readTxt(cfgFolder .. "/autosave_name.txt", "default")
    local savedAutoLoadOn = readTxt(cfgFolder .. "/autoload_enabled.txt", "true") ~= "false"
    local savedAutoSaveOn = readTxt(cfgFolder .. "/autosave_enabled.txt", "true") ~= "false"

    local autoLoadDrop, autoSaveDrop

    local function cfgRefresh()
        local items = cfgItems()
        picker.setItems(items)
        if autoLoadDrop then autoLoadDrop.setItems(items) end
        if autoSaveDrop then autoSaveDrop.setItems(items) end
    end

    cfgSec:button({ name = "Save", callback = function()
        if not canFs then lib:notify("Filesystem unavailable") return end
        local n = cfgTarget()
        local ok = pcall(writefile, cfgFolder .. "/" .. n .. ".cfg", lib:exportConfig())
        lib:notify(ok and ("Saved " .. n) or "Save failed")
        cfgRefresh()
        if lib.cfgLabel then lib.cfgLabel.Text = n .. ".cfg" end
    end })
    cfgSec:button({ name = "Load", callback = function()
        if not canFs then lib:notify("Filesystem unavailable") return end
        local n = cfgTarget()
        local ok, data = pcall(readfile, cfgFolder .. "/" .. n .. ".cfg")
        if ok and lib:importConfig(data) then
            lib:notify("Loaded " .. n)
            if lib.cfgLabel then lib.cfgLabel.Text = n .. ".cfg" end
        else
            lib:notify("Load failed")
        end
    end })
    cfgSec:button({ name = "Delete", callback = function()
        if not (canFs and typeof(delfile) == "function") then lib:notify("Filesystem unavailable") return end
        local n = cfgTarget()
        local ok = pcall(delfile, cfgFolder .. "/" .. n .. ".cfg")
        lib:notify(ok and ("Deleted " .. n) or "Delete failed")
        cfgRefresh()
    end })
    cfgSec:button({ name = "Refresh", callback = cfgRefresh })

    autoSec:toggle({ name = "Auto Load", flag = "__cfg_autoload", default = savedAutoLoadOn, callback = function(v)
        writeTxt(cfgFolder .. "/autoload_enabled.txt", v and "true" or "false")
    end })
    autoLoadDrop = autoSec:dropdown({
        name = "Auto Load Config", flag = "__cfg_autoload_name",
        items = cfgItems(), default = savedAutoLoad,
        callback = function(v) writeTxt(cfgFolder .. "/autoload_name.txt", v) end,
    })
    autoSec:toggle({ name = "Auto Save", flag = "__cfg_autosave", default = savedAutoSaveOn, callback = function(v)
        writeTxt(cfgFolder .. "/autosave_enabled.txt", v and "true" or "false")
    end })
    autoSaveDrop = autoSec:dropdown({
        name = "Auto Save Config", flag = "__cfg_autosave_name",
        items = cfgItems(), default = savedAutoSave,
        callback = function(v) writeTxt(cfgFolder .. "/autosave_name.txt", v) end,
    })

    local ready = false

    local function applyTheme(t)
        for k, c in pairs(t) do
            if k ~= "__ui_font" and k ~= "__ui_size" then
                local fn = lib.setters["__theme_" .. k]
                if fn then fn(c) else Theme.set(k, c) end
            end
        end
        if t.__ui_font then
            local fn = lib.setters["__ui_font"]
            if fn then fn(t.__ui_font) end
        end
        if t.__ui_size then
            local fn = lib.setters["__ui_size"]
            if fn then fn(tonumber(t.__ui_size) or UI.size) end
        end
    end

    local function themeJson()
        local out = {}
        for k, c in pairs(Theme.v) do out[k] = toHex(c) end
        out.__ui_font = lib.flags["__ui_font"] or "Tahoma 8px"
        out.__ui_size = lib.flags["__ui_size"] or UI.size
        return HttpService:JSONEncode(out)
    end

    local function themeFromJson(s)
        local ok, d = pcall(function() return HttpService:JSONDecode(s) end)
        if not ok or type(d) ~= "table" then return nil end
        local out = {}
        for k, hx in pairs(d) do
            if Theme.v[k] ~= nil and type(hx) == "string" then
                local c = parseHex(hx)
                if c then out[k] = c end
            end
        end
        out.__ui_font = d.__ui_font
        out.__ui_size = d.__ui_size
        return out
    end

    themeSec:dropdown({
        name = "Preset", flag = "__theme_preset", items = PRESET_NAMES, default = "Default",
        callback = function(v)
            local p = PRESETS[lower(tostring(v))]
            if ready and p then applyTheme(p) end
        end,
    })
    local themeName = themeSec:textbox({ name = "Theme Name", flag = "__theme_name", placeholder = "Name" })
    local themePicker = themeSec:dropdown({ name = "Saved Themes", flag = "__theme_list", items = listFiles(themeFolder, "theme") })

    local function themeTarget()
        local n = themeName.value
        if n == nil or n == "" then n = themePicker.value end
        if n == nil or n == "" or n == "None" then return nil end
        return tostring(n)
    end

    local function themeRefresh()
        themePicker.setItems(listFiles(themeFolder, "theme"))
    end

    themeSec:button({ name = "Save Theme", callback = function()
        if not canFs then lib:notify("Filesystem unavailable") return end
        local n = themeTarget()
        if not n then lib:notify("Enter a theme name") return end
        local ok = pcall(writefile, themeFolder .. "/" .. n .. ".theme", themeJson())
        lib:notify(ok and ("Saved theme " .. n) or "Save failed")
        themeRefresh()
    end })
    themeSec:button({ name = "Load Theme", callback = function()
        if not canFs then lib:notify("Filesystem unavailable") return end
        local n = themeTarget()
        if not n then lib:notify("Pick a theme") return end
        local ok, data = pcall(readfile, themeFolder .. "/" .. n .. ".theme")
        local t = ok and themeFromJson(data)
        if t then
            applyTheme(t)
            lib:notify("Loaded theme " .. n)
        else
            lib:notify("Load failed")
        end
    end })
    themeSec:button({ name = "Delete Theme", callback = function()
        if not (canFs and typeof(delfile) == "function") then lib:notify("Filesystem unavailable") return end
        local n = themeTarget()
        if not n then return end
        local ok = pcall(delfile, themeFolder .. "/" .. n .. ".theme")
        lib:notify(ok and ("Deleted theme " .. n) or "Delete failed")
        themeRefresh()
    end })
    themeSec:button({ name = "Set As Default", callback = function()
        if not canFs then lib:notify("Filesystem unavailable") return end
        local n = themeTarget()
        if not n then lib:notify("Pick a theme") return end
        local ok = pcall(writefile, themeFolder .. "/autoload.txt", n)
        lib:notify(ok and ("Default theme set to " .. n) or "Failed to set default")
    end })
    themeSec:button({ name = "Refresh Themes", callback = themeRefresh })
    themeSec:button({ name = "Reset To Default", callback = function()
        applyTheme(PRESETS.default)
        if canFs and typeof(delfile) == "function" then pcall(delfile, themeFolder .. "/autoload.txt") end
        lib:notify("Theme reset")
    end })

    for _, e in ipairs(THEME_KEYS) do
        local key = e[1]
        colorSec:label(e[2]):colorpicker({
            flag = "__theme_" .. key, color = Theme.v[key],
            callback = function(c) Theme.set(key, c) end,
        })
    end

    menuSec:label("Menu Key"):keybind({
        flag = "__menu_key", key = lib.toggleKey, mode = "Always",
        onBind = function(k)
            if k and k.EnumType == Enum.KeyCode then lib.toggleKey = k end
        end,
    })

    local wmToggle = menuSec:toggle({ name = "Watermark", flag = "__watermark", default = true, callback = function(v)
        if lib.watermarkFrame then lib.watermarkFrame.Visible = v end
    end })
    local wmPop = wmToggle:gear({ title = "Watermark Options" })
    wmPop:dropdown({
        name = "Watermark Parts", flag = "__wm_parts", multi = true,
        items = { "Name", "User", "FPS", "Time", "Ping" },
        default = { "Name", "User", "FPS", "Time" },
        callback = function(sel)
            if not lib.wmOpts then return end
            local set = {}
            for _, x in ipairs(sel or {}) do set[x] = true end
            lib.wmOpts.showName = set["Name"] == true
            lib.wmOpts.showUser = set["User"] == true
            lib.wmOpts.showFps = set["FPS"] == true
            lib.wmOpts.showTime = set["Time"] == true
            lib.wmOpts.showPing = set["Ping"] == true
            if lib.wmRender then lib.wmRender(60) end
        end,
    })
    wmPop:textbox({ name = "WM Custom", flag = "__wm_custom", placeholder = "Extra text", callback = function(t)
        if lib.wmOpts then lib.wmOpts.custom = t or "" end
        if lib.wmRender then lib.wmRender(60) end
    end })

    menuSec:toggle({ name = "Keybind List", flag = "__kb_list", default = false, callback = function(v)
        if lib.kbListFrame then lib.kbListFrame.Visible = v end
        if v and lib.refreshKeybindList then lib.refreshKeybindList() end
    end })

    local notifToggle = menuSec:toggle({ name = "Notifications", flag = "__notifs", default = true, callback = function(v)
        lib.notifyEnabled = v
    end })
    local notifPop = notifToggle:gear({ title = "Notification Options" })
    notifPop:dropdown({
        name = "Notif Position", flag = "__notif_pos",
        items = { "Bottom Left", "Bottom Right", "Top Left", "Top Right" },
        default = "Bottom Left",
        callback = function(v)
            if lib.setNotifPos then lib:setNotifPos(v) end
        end,
    })
    notifPop:button({ name = "Test Notification", callback = function()
        lib:notify({ title = "Notification", text = "This is a test notification.", kind = "info" })
    end })

    menuSec:button({ name = "Unload", callback = function() lib:unload() end })

    local fontDrop = fontSec:dropdown({
        name = "UI Font", flag = "__ui_font", items = FontBank.list(), default = "Tahoma 8px",
        callback = function(v)
            local f = FontBank.map[v]
            if f then
                UI.font = f
                applyFont()
            end
        end,
    })
    if not FontBank.done then
        FontBank.waiting[#FontBank.waiting + 1] = function()
            fontDrop.setItems(FontBank.list())
        end
    end
    fontSec:slider({
        name = "Text Size", flag = "__ui_size", min = 10, max = 15, default = UI.size, interval = 1,
        callback = function(v)
            UI.size = v
            applyFont()
        end,
    })

    ready = true
    if canFs then
        local ok, name = pcall(readfile, themeFolder .. "/autoload.txt")
        if ok and name then
            name = (tostring(name):gsub("^%s+", ""):gsub("%s+$", ""))
            if name ~= "" then
                local ok2, data = pcall(readfile, themeFolder .. "/" .. name .. ".theme")
                local t = ok2 and themeFromJson(data)
                if t then applyTheme(t) end
            end
        end
        if readTxt(cfgFolder .. "/autoload_enabled.txt", "true") ~= "false" then
            local cn = readTxt(cfgFolder .. "/autoload_name.txt", "default")
            if cn == "" or cn == "None" then cn = "default" end
            local okC, data = pcall(readfile, cfgFolder .. "/" .. cn .. ".cfg")
            if okC and data then
                pcall(function() lib:importConfig(data) end)
                lib:notify({ title = "Config", text = "Auto loaded " .. cn, kind = "success" })
            end
        end
    end

    local lastSave = 0
    lib:connect(RunService.Heartbeat, function()
        if not canFs then return end
        if tick() - lastSave < 8 then return end
        lastSave = tick()
        local saveOn = lib.flags["__cfg_autosave"]
        if saveOn == nil then
            saveOn = readTxt(cfgFolder .. "/autosave_enabled.txt", "true") ~= "false"
        end
        if saveOn == false then return end
        local n = tostring(lib.flags["__cfg_autosave_name"] or readTxt(cfgFolder .. "/autosave_name.txt", "default"))
        if n == "" or n == "None" then n = "default" end
        pcall(writefile, cfgFolder .. "/" .. n .. ".cfg", lib:exportConfig())
    end)
end

return Library
