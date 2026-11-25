print('-1111')

local cloneref = cloneref or function(o) return o end
local function svc(n) return cloneref(game:GetService(n)) end

local env = (typeof(getgenv) == "function" and getgenv()) or _G
if type(env.Stardust) == "table" and type(env.Stardust.unload) == "function" then
    pcall(env.Stardust.unload)
end

local Stardust = {}

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
    ["Squidward"] = 4991325603,
    ["Obama"] = 11412932396,
    ["Peter Griffin"] = 11757639639,
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
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
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
        TextColor3 = WHITE, TextStrokeTransparency = 1,
        Visible = false, ZIndex = z, TextXAlignment = xa, TextYAlignment = ya, NoSkin = true,
    })
    new("UIStroke", {
        Parent = lbl, Color = rgb(0, 0, 0), Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual, LineJoinMode = Enum.LineJoinMode.Round,
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
    self.flags = {}
    self.pending = {}
    self.setters = setmetatable({}, {
        __newindex = function(t, k, fn)
            rawset(t, k, fn)
            if self.pending[k] == nil then return end
            task.defer(function()
                local cur = self.pending[k]
                if cur == nil then return end
                self.pending[k] = nil
                local alpha = self.pending[k .. "_alpha"]
                self.pending[k .. "_alpha"] = nil
                if typeof(cur) == "Color3" then
                    pcall(fn, cur, alpha)
                else
                    pcall(fn, cur)
                end
            end)
        end,
    })
    self.connections = {}
    self.notifs = {}
    self.keybinds = {}
    self.sideLabels = {}
    self.sideBgLabels = {}
    self.stack = {}
    self.index = {}
    self.boxes = {}
    self.query = ""
    self.searchMode = "Tab"
    self.order = 0
    self.cpCount = 0
    self.currentTab = nil
    self.clipboard = nil
    self.onUnload = nil
    self.learnedY = nil
    self.binding = false
    self.notifyEnabled = true
    self.sideExpanded = false
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

    self.glow = new("ImageLabel", {
        Parent = self.root, Position = off(-21, -21), Size = dim2(1, 42, 1, 42),
        BackgroundTransparency = 1, Image = "rbxassetid://110204605000367",
        ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(v2(21, 21), v2(79, 79)),
        ImageColor3 = T("accent"), ImageTransparency = 0.55, ZIndex = 0,
    })

    local win = framed(self.root, dim2(1, 0, 1, 0))
    topGlow(win).ZIndex = 15
    local topBar = new("Frame", { Parent = win, Size = dim2(1, 0, 0, 2), BackgroundColor3 = WHITE, ZIndex = 30 })
    local topBarGrad = new("UIGradient", { Parent = topBar })
    local barSteps = 12
    self:connect(RunService.RenderStepped, function()
        if not self.root.Visible then return end
        local t = (tick() * 0.35) % 1
        local a, b = Theme.v.accent, Theme.v.panel
        local keys = {}
        for i = 0, barSteps do
            local p = i / barSteps
            local mix = 0.5 - 0.5 * math.cos(2 * math.pi * (p - t))
            keys[#keys + 1] = ColorSequenceKeypoint.new(p, a:Lerp(b, mix))
        end
        topBarGrad.Color = ColorSequence.new(keys)
    end)

    local content = new("Frame", {
        Parent = win, Position = off(sideCollapsed, 0), Size = dim2(1, -sideCollapsed, 1, 0),
        BackgroundTransparency = 1, ClipsDescendants = true,
    })

    local side = new("Frame", {
        Parent = win, Size = dim2(0, sideCollapsed, 1, 0), BackgroundColor3 = T("panel"),
        ZIndex = 10, ClipsDescendants = true, Active = true,
    })
    self.side = side
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
    local dragArea = new("Frame", { Parent = header, Size = dim2(1, -210, 1, 0), BackgroundTransparency = 1, Active = true })
    local crumbs = new("Frame", { Parent = header, Position = off(8, 0), Size = dim2(1, -218, 1, 0), BackgroundTransparency = 1 })
    new("UIListLayout", {
        Parent = crumbs, FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center, Padding = dim(0, 4),
    })
    self.crumbCat = label(crumbs, "", "mute", nil, dim2(0, 0, 1, 0)); self.crumbCat.AutomaticSize = Enum_X
    self.crumbTab = label(crumbs, "", "text_active", nil, dim2(0, 0, 1, 0)); self.crumbTab.AutomaticSize = Enum_X
    new("Frame", { Parent = content, Position = off(0, 31), Size = dim2(1, 0, 0, 1), BackgroundColor3 = T("line") })

    local modeOuter, modeLbl, modeHit = miniButton(header, "This Tab", UDim2.new(), off(56, 18))
    modeOuter.AnchorPoint = v2(1, 0.5)
    modeOuter.Position = dim2(1, -6, 0.5, 0)

    local searchBody, searchOuter = fieldBox(header, off(140, 18))
    searchOuter.AnchorPoint = v2(1, 0.5)
    searchOuter.Position = dim2(1, -66, 0.5, 0)
    local searchBox = new("TextBox", {
        Parent = searchBody, Size = dim2(1, -10, 1, 0), Position = off(5, 0),
        PlaceholderText = "Search features", PlaceholderColor3 = T("mute"), ClearTextOnFocus = false,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })

    local RW, RH = 232, 30
    local resBody, resOuter = fieldBox(self.gui, off(RW, 40))
    resOuter.Visible = false
    resOuter.ZIndex = 200
    resOuter.Active = true
    local resScroll = new("ScrollingFrame", {
        Parent = resBody, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1,
        AutomaticCanvasSize = Enum_Y, ScrollBarThickness = 2,
    })
    new("UIListLayout", { Parent = resScroll, SortOrder = Enum.SortOrder.LayoutOrder })
    new("UIPadding", { Parent = resScroll, PaddingTop = dim(0, 3), PaddingBottom = dim(0, 3) })
    local resP = { frame = resOuter, level = 1, open = false }
    function resP.close()
        resOuter.Visible = false
        resP.open = false
    end

    local function goTo(e)
        self:closePopup(resP)
        e.tab:open()
        if e.sec.select then e.sec.select() end
        task.delay(0.06, function()
            if not e.row.Parent then return end
            local sf = e.row:FindFirstAncestorWhichIsA("ScrollingFrame")
            if sf then
                local y = e.row.AbsolutePosition.Y - sf.AbsolutePosition.Y + sf.CanvasPosition.Y - 30
                sf.CanvasPosition = v2(0, math.max(0, y))
            end
            local fl = new("Frame", {
                Parent = e.row, Size = dim2(1, 6, 1, 4), Position = off(-3, -2),
                BackgroundColor3 = Theme.v.accent, BackgroundTransparency = 0.55, ZIndex = 0,
            })
            TweenService:Create(fl, TweenInfo.new(1.2), { BackgroundTransparency = 1 }):Play()
            task.delay(1.3, function() fl:Destroy() end)
        end)
    end

    local function rebuildResults()
        for _, c in ipairs(resScroll:GetChildren()) do
            if c:IsA("GuiObject") then c:Destroy() end
        end
        local q = self.query
        local first, rest = {}, {}
        for _, e in ipairs(self.index) do
            local at = string.find(e.key, q, 1, true)
            if at == 1 then
                first[#first + 1] = e
            elseif at then
                rest[#rest + 1] = e
            end
        end
        local list = {}
        for _, e in ipairs(first) do
            if #list < 40 then list[#list + 1] = e end
        end
        for _, e in ipairs(rest) do
            if #list < 40 then list[#list + 1] = e end
        end
        if #list == 0 then
            new("TextLabel", {
                Parent = resScroll, Size = dim2(1, 0, 0, RH), Text = "No results",
                TextColor3 = T("mute"), TextXAlignment = ACenter,
            })
        end
        for i, e in ipairs(list) do
            local b = new("TextButton", {
                Parent = resScroll, Size = dim2(1, 0, 0, RH), LayoutOrder = i,
                BackgroundColor3 = T("tab_active"), BackgroundTransparency = 1,
            })
            new("TextLabel", {
                Parent = b, Position = off(8, 3), Size = dim2(1, -12, 0, 12), Text = e.name,
                TextColor3 = T("text"), TextTruncate = Enum.TextTruncate.AtEnd,
            })
            new("TextLabel", {
                Parent = b, Position = off(8, 16), Size = dim2(1, -12, 0, 11),
                Text = e.tab.name .. " / " .. tostring(e.sec.name or ""),
                TextColor3 = T("mute"), TextTruncate = Enum.TextTruncate.AtEnd,
            })
            b.MouseEnter:Connect(function() tween(b, { BackgroundTransparency = 0.3 }, 0.08) end)
            b.MouseLeave:Connect(function() tween(b, { BackgroundTransparency = 1 }, 0.08) end)
            b.MouseButton1Click:Connect(function() goTo(e) end)
        end
        local h = math.min(math.max(#list, 1), 8) * RH + 6
        resScroll.CanvasPosition = Vector2.zero
        resOuter.Size = off(RW, h)
        resOuter.Position = self:place(searchOuter, RW, h, true)
    end

    local function showResults()
        rebuildResults()
        if not resP.open then
            resOuter.Visible = true
            resP.open = true
            self:openPopup(resP)
        end
    end

    local function refreshSearch()
        self:applySearch()
        if self.searchMode == "All" and self.query ~= "" then
            showResults()
        else
            self:closePopup(resP)
        end
    end

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        self.query = lower((searchBox.Text:gsub("^%s+", ""):gsub("%s+$", "")))
        refreshSearch()
    end)
    searchBox.Focused:Connect(function()
        hot(searchOuter, true)
        if self.searchMode == "All" and self.query ~= "" then showResults() end
    end)
    searchBox.FocusLost:Connect(function() hot(searchOuter, false) end)

    modeHit.MouseButton1Click:Connect(function()
        if self.searchMode == "Tab" then
            self.searchMode = "All"
            modeLbl.Text = "All Tabs"
        else
            self.searchMode = "Tab"
            modeLbl.Text = "This Tab"
        end
        refreshSearch()
    end)

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
    self:drag(dragArea, self.root)
    self:watermark()
    self:keybindList()

    self:connect(UIS.InputBegan, function(input, gp)
        if not gp and not self.binding and input.KeyCode == self.toggleKey then
            self.root.Visible = not self.root.Visible
            self:closePopups()
        end
    end)

    return self
end

function Library:connect(signal, fn)
    local c = signal:Connect(fn)
    table.insert(self.connections, c)
    return c
end

function Library:register(sec, name, row)
    if sec.level == 2 or not sec.box then return end
    self.index[#self.index + 1] = {
        name = tostring(name), key = lower(tostring(name)), row = row, sec = sec, tab = sec.tab,
    }
    sec.box.total = (sec.box.total or 0) + 1
end

function Library:applySearch()
    local q = self.query or ""
    local cur = self.currentTab
    local filtering = q ~= "" and self.searchMode == "Tab" and cur ~= nil
    local secCount, boxCount = {}, {}
    for _, e in ipairs(self.index) do
        local show = true
        if filtering and e.tab == cur then
            show = string.find(e.key, q, 1, true) ~= nil
        end
        if e.row.Visible ~= show then e.row.Visible = show end
        if show then
            secCount[e.sec] = (secCount[e.sec] or 0) + 1
            boxCount[e.sec.box] = (boxCount[e.sec.box] or 0) + 1
        end
    end
    for _, b in ipairs(self.boxes) do
        local vis = true
        if filtering and b.tab == cur and (b.total or 0) > 0 then
            vis = (boxCount[b] or 0) > 0
        end
        if b.frame.Visible ~= vis then b.frame.Visible = vis end
        if filtering and b.sections and b.tab == cur and b.current and (secCount[b.current] or 0) == 0 then
            for _, s in ipairs(b.sections) do
                if (secCount[s] or 0) > 0 then
                    s.select()
                    break
                end
            end
        end
    end
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
    local cat = setmetatable({ lib = self, name = name, count = 0, base = nxt(self) * 1000 }, Category)
    local row = new("Frame", {
        Parent = self.sideList, Size = dim2(1, -12, 0, 16), BackgroundTransparency = 1, LayoutOrder = cat.base,
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

    local body, outer = fieldBox(lib.sideList, dim2(1, -12, 0, 32))
    self.count += 1
    outer.LayoutOrder = self.base + self.count
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
        lib:guard(col)
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

    local box = { frame = container, tab = self.tab }
    lib.boxes[#lib.boxes + 1] = box

    return setmetatable({
        lib = lib, body = body, container = container, tab = self.tab, box = box, name = o.name or "Section",
    }, Section)
end

function Column:multi_section(o)
    o = o or {}
    local lib = self.lib
    local tab = self.tab
    local names = o.names or { "Section" }
    local fills = o.fills ~= false
    local fixedH = o.height
    local colFrame = self.holder

    local container = new("Frame", {
        Parent = colFrame,
        Size = fills and dim2(1, 0, 0, fixedH or 300) or dim2(1, 0, 0, 0),
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
    elseif not fixedH then
        local function fit()
            container.Size = dim2(1, 0, 0, math.max(120, colFrame.AbsoluteSize.Y - 12))
        end
        colFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
        fit()
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

    local box = { frame = container, tab = tab, sections = {} }
    lib.boxes[#lib.boxes + 1] = box

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
        box.current = sec
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

        local sec = setmetatable({
            lib = lib, body = page, page = page, name = name, btn = btn, lbl = lbl, mark = mark,
            tab = tab, box = box,
        }, Section)
        sec.select = function() select(sec) end
        sections[i] = sec
        box.sections[i] = sec

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
        _labelText = tostring(text or "Label"), name = tostring(text or "Label"),
    }, Element)
    function e.set(t) lbl.Text = tostring(t) end
    lib:register(self, e.name, row)
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
    lib:register(self, o.name or "Button", outer)
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

    lib:register(self, cfg.name, row)

    return setmetatable(cfg, Element)
end

function Element:gear(o)
    o = o or {}
    local lib = self.lib
    local W = o.width or 226

    local btn = new("TextButton", {
        Parent = self.right, Size = off(14, 14), BackgroundTransparency = 1,
        LayoutOrder = -1, Text = "", ZIndex = 3,
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

    local header = new("Frame", { Parent = bg, Size = dim2(1, 0, 0, 24), BackgroundTransparency = 1, LayoutOrder = 1 })
    local hglow = new("Frame", { Parent = header, Size = dim2(1, 0, 1, 0), BackgroundColor3 = T("accent") })
    new("UIGradient", { Parent = hglow, Rotation = 90, Transparency = NumberSequence.new(0.88, 1) })
    accentLine(header)
    label(header, o.title or ((self.name or "Settings") .. " Options"), "text_active", off(8, 2), dim2(1, -16, 1, -2))
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

    local sv = slimBar(pb, off(6, 6), off(154, 108))
    sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
    sv.ClipsDescendants = true
    local whiteL = new("Frame", { Parent = sv, Size = dim2(1, 0, 1, 0), BackgroundColor3 = WHITE })
    new("UIGradient", { Parent = whiteL, Transparency = NumberSequence.new(0, 1) })
    local blackL = new("Frame", { Parent = sv, Size = dim2(1, 0, 1, 0), BackgroundColor3 = rgb(0, 0, 0) })
    new("UIGradient", { Parent = blackL, Rotation = 90, Transparency = NumberSequence.new(1, 0) })
    local svBtn = new("TextButton", { Parent = sv, Size = dim2(1, 0, 1, 0), ZIndex = 3 })
    local svCursor = new("Frame", { Parent = sv, AnchorPoint = v2(0.5, 0.5), Size = off(6, 6), BackgroundColor3 = WHITE, ZIndex = 4 })
    new("UICorner", { Parent = svCursor, CornerRadius = dim(1, 0) })

    local hueInner = slimBar(pb, off(166, 6), off(18, 108))
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
    local lvl = self.level or 1
    lib.cpCount += 1

    local kb = {
        flag = o.flag or ("keybind_" .. lib.cpCount), mode = o.mode or "Toggle",
        key = parseKey(o.key), active = false, binding = false,
        callback = o.callback or function() end, onBind = o.onBind or function() end,
    }

    local body, outer = fieldBox(self.right, off(50, 13))
    outer.LayoutOrder = 1000 + lib.cpCount
    local keyLbl = label(body, "None", Theme.v.item, off(0, 0), dim2(1, 0, 1, 0), ACenter)
    keyLbl.TextTruncate = Enum.TextTruncate.AtEnd
    local hit = new("TextButton", { Parent = outer, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 5 })

    local function paintKey()
        keyLbl.Text = kb.binding and "..." or keyText(kb.key)
        keyLbl.TextColor3 = kb.binding and Theme.v.accent or Theme.v.item
    end
    Theme.on({ "accent", "item" }, paintKey)

    local displayName = o.name
    if not displayName and self and self._labelText then displayName = self._labelText end
    if not displayName then
        displayName = tostring(kb.flag):gsub("^__", ""):gsub("_", " ")
    end
    kb.name = displayName
    lib.keybinds[kb.flag] = kb

    local function refresh()
        paintKey()
        lib.flags[kb.flag] = { key = kb.key, mode = kb.mode, active = kb.active }
        if lib.refreshKeybindList then lib.refreshKeybindList() end
    end

    local P = lib:popupList(outer, { "Hold", "Toggle", "Always" }, {
        alignRight = true, level = lvl,
        selected = function(item) return kb.mode == item end,
        pick = function(item)
            kb.mode = item
            if item == "Always" then
                kb.active = true
            elseif item == "Hold" then
                kb.active = false
            end
            refresh()
            kb.callback(kb.active)
        end,
        onClose = function() hot(outer, false) end,
    })

    hit.MouseEnter:Connect(function() hot(outer, true) end)
    hit.MouseLeave:Connect(function() if not kb.binding and not P.open then hot(outer, false) end end)

    hit.MouseButton1Click:Connect(function()
        lib:closeLevel(lvl)
        kb.binding = true
        lib.binding = true
        hot(outer, true)
        refresh()
    end)
    hit.MouseButton2Click:Connect(function()
        kb.binding = false
        lib.binding = false
        refresh()
        P.toggle()
    end)

    lib:connect(UIS.InputBegan, function(input, gp)
        if kb.binding then
            local k
            if input.UserInputType == Enum.UserInputType.Keyboard then
                k = input.KeyCode
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then
                k = input.UserInputType
            else
                return
            end
            kb.binding = false
            lib.binding = false
            if k == Enum.KeyCode.Escape then k = nil end
            kb.key = k
            hot(outer, false)
            refresh()
            kb.onBind(k)
            return
        end
        if gp or not kb.key then return end
        local pressed = (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == kb.key) or input.UserInputType == kb.key
        if not pressed then return end
        if kb.mode == "Toggle" then
            kb.active = not kb.active
        elseif kb.mode == "Hold" then
            kb.active = true
        else
            return
        end
        refresh()
        kb.callback(kb.active)
    end)

    lib:connect(UIS.InputEnded, function(input)
        if kb.mode ~= "Hold" or not kb.key or not kb.active then return end
        local released = (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == kb.key) or input.UserInputType == kb.key
        if released then
            kb.active = false
            refresh()
            kb.callback(false)
        end
    end)

    function kb.set(val)
        if type(val) == "table" then
            kb.key = parseKey(val.key)
            kb.mode = val.mode or kb.mode
            kb.active = kb.mode == "Always" and true or (val.active and true or false)
        end
        refresh()
        kb.callback(kb.active)
    end

    if kb.mode == "Always" then kb.active = true end
    lib.setters[kb.flag] = kb.set
    refresh()

    return self
end

function Section:dropdown(o)
    local lib = self.lib
    local lvl = self.level or 1
    local cfg = {
        lib = lib, name = o.name or "Dropdown", flag = o.flag or o.name or "dropdown",
        items = o.items or {}, multi = o.multi or false,
        callback = o.callback or function() end,
    }
    local default = o.default
    if default == nil then default = cfg.multi and {} or cfg.items[1] end

    local holder = new("Frame", { Parent = self.body, Size = dim2(1, 0, 0, 38), BackgroundTransparency = 1, LayoutOrder = nxt(lib) })
    local nl = label(holder, nameText(cfg.name, o.risky), "text", off(1, 0), dim2(1, -2, 0, 14))
    if o.risky then nl.RichText = true end
    local body, outer = fieldBox(holder, dim2(1, 0, 0, 20), off(0, 17))
    local valLbl = label(body, "", "text", off(6, 0), dim2(1, -24, 1, 0))
    valLbl.TextTruncate = Enum.TextTruncate.AtEnd

    local arrow = new("Frame", { Parent = body, AnchorPoint = v2(1, 0.5), Position = dim2(1, -6, 0.5, 0), Size = off(7, 4), BackgroundTransparency = 1 })
    local arrowParts = {}
    for i = 1, 4 do
        local w = 9 - 2 * i
        arrowParts[i] = new("Frame", { Parent = arrow, Position = off((7 - w) / 2, i - 1), Size = off(w, 1), BackgroundColor3 = Theme.v.dim })
    end

    local P
    local function setArrow(open)
        for i, p in ipairs(arrowParts) do
            local w = 9 - 2 * i
            p.Position = off((7 - w) / 2, open and (4 - i) or (i - 1))
            p.BackgroundColor3 = open and Theme.v.accent or Theme.v.dim
        end
    end
    Theme.on({ "accent", "dim" }, function() setArrow(P ~= nil and P.open) end)

    local hit = new("TextButton", { Parent = outer, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 5 })

    local function isSelected(item)
        if cfg.multi then
            for _, x in ipairs(cfg.value or {}) do
                if x == item then return true end
            end
            return false
        end
        return cfg.value == item
    end

    local function build()
        P = lib:popupList(outer, cfg.items, {
            multi = cfg.multi, level = lvl,
            selected = isSelected,
            pick = function(item)
                if cfg.multi then
                    local newSel, found = {}, false
                    for _, x in ipairs(cfg.value) do
                        if x == item then found = true else table.insert(newSel, x) end
                    end
                    if not found then table.insert(newSel, item) end
                    cfg.set(newSel)
                else
                    cfg.set(item)
                end
            end,
            onOpen = function()
                setArrow(true)
                hot(outer, true)
            end,
            onClose = function()
                setArrow(false)
                hot(outer, false)
            end,
        })
    end

    function cfg.set(val)
        if cfg.multi then
            local lookup, sel = {}, {}
            for _, x in ipairs(type(val) == "table" and val or {}) do lookup[x] = true end
            for _, item in ipairs(cfg.items) do
                if lookup[item] then table.insert(sel, item) end
            end
            cfg.value = sel
            local shown = {}
            for _, x in ipairs(sel) do table.insert(shown, tostring(x)) end
            valLbl.Text = #shown > 0 and table.concat(shown, ", ") or "None"
        else
            cfg.value = val
            valLbl.Text = tostring(val or "None")
        end
        if P then P.refresh() end
        lib:setFlag(cfg.flag, cfg.value)
        cfg.callback(cfg.value)
    end

    function cfg.setItems(items)
        if P then P.destroy() end
        cfg.items = items
        build()
        if cfg.multi then
            cfg.set(cfg.value or {})
        else
            local keep = false
            for _, x in ipairs(items) do
                if x == cfg.value then keep = true end
            end
            cfg.set(keep and cfg.value or items[1])
        end
    end

    hit.MouseEnter:Connect(function() hot(outer, true) end)
    hit.MouseLeave:Connect(function()
        if not (P and P.open) then hot(outer, false) end
    end)
    hit.MouseButton1Click:Connect(function()
        if P then P.toggle() end
    end)

    build()
    lib.setters[cfg.flag] = cfg.set
    cfg.set(default)
    lib:register(self, cfg.name, holder)
    return cfg
end

function Section:slider(o)
    local lib = self.lib
    local lvl = self.level or 1
    local cfg = {
        lib = lib, name = o.name or "Slider", flag = o.flag or o.name or "slider",
        min = o.min or 0, max = o.max or 100, interval = o.interval or 1,
        suffix = o.suffix or "", callback = o.callback or function() end, dragging = false, token = 0,
    }
    local decimals = 0
    if cfg.interval < 1 then
        decimals = #(tostring(cfg.interval):match("%.(%d+)") or "")
    end

    local row = new("Frame", { Parent = self.body, Size = dim2(1, 0, 0, 28), BackgroundTransparency = 1, LayoutOrder = nxt(lib) })
    local nl = label(row, nameText(cfg.name, o.risky), "text", off(1, 0), dim2(1, -36, 0, 13))
    if o.risky then nl.RichText = true end

    local minus = new("TextButton", {
        Parent = row, AnchorPoint = v2(1, 0), Position = dim2(1, -18, 0, 0), Size = off(14, 13),
        Text = "-", TextXAlignment = ACenter, TextColor3 = T("dim"), ZIndex = 3,
    })
    local plus = new("TextButton", {
        Parent = row, AnchorPoint = v2(1, 0), Position = dim2(1, -2, 0, 0), Size = off(14, 13),
        Text = "+", TextXAlignment = ACenter, TextColor3 = T("dim"), ZIndex = 3,
    })

    local outer = hotFrame(row, dim2(1, 0, 0, 12), off(0, 15))
    local inner = new("Frame", { Parent = outer, Position = off(1, 1), Size = dim2(1, -2, 1, -2), BackgroundColor3 = WHITE, ClipsDescendants = true })
    local ig = new("UIGradient", { Parent = inner, Rotation = 90 })
    Theme.on({ "field_top", "field_bot" }, function()
        ig.Color = ColorSequence.new(Theme.v.field_top, Theme.v.field_bot)
    end)

    local track = new("Frame", { Parent = inner, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, ClipsDescendants = true })
    local fill = new("Frame", { Parent = track, Size = dim2(0, 0, 1, 0), BackgroundColor3 = T("accent"), BackgroundTransparency = 0.1 })
    new("UIGradient", { Parent = fill, Rotation = 90, Color = ColorSequence.new(WHITE, rgb(150, 150, 150)) })
    local valLbl = label(track, "", "text_active", off(0, 0), dim2(1, 0, 1, 0), ACenter)
    valLbl.ZIndex = 3
    valLbl.TextSize = 11
    local hit = new("TextButton", { Parent = track, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 4 })

    function cfg.set(val)
        val = clamp(floor(val / cfg.interval + 0.5) * cfg.interval, cfg.min, cfg.max)
        val = tonumber(string.format("%." .. decimals .. "f", val))
        cfg.value = val
        local frac = (val - cfg.min) / (cfg.max - cfg.min)
        fill.Size = dim2(frac, 0, 1, 0)
        valLbl.Text = string.format("%." .. decimals .. "f", val) .. cfg.suffix
        lib:setFlag(cfg.flag, val)
        cfg.callback(val)
    end

    local function stepper(btn, dir)
        btn.MouseEnter:Connect(function()
            btn.TextColor3 = Theme.v.accent
            hot(outer, true)
        end)
        btn.MouseLeave:Connect(function()
            btn.TextColor3 = Theme.v.dim
            if not cfg.dragging then hot(outer, false) end
        end)
        btn.MouseButton1Down:Connect(function()
            lib:closeLevel(lvl)
            cfg.token += 1
            local my = cfg.token
            cfg.set(cfg.value + dir * cfg.interval)
            task.spawn(function()
                task.wait(0.35)
                while cfg.token == my do
                    local nv = clamp(cfg.value + dir * cfg.interval, cfg.min, cfg.max)
                    if nv == cfg.value then break end
                    cfg.set(nv)
                    task.wait(0.05)
                end
            end)
        end)
    end
    stepper(minus, -1)
    stepper(plus, 1)

    local function fromMouse()
        local m = lib:mouse()
        local frac = clamp((m.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        cfg.set(cfg.min + (cfg.max - cfg.min) * frac)
    end

    hit.MouseEnter:Connect(function() hot(outer, true) end)
    hit.MouseLeave:Connect(function()
        if not cfg.dragging then hot(outer, false) end
    end)
    hit.MouseButton1Down:Connect(function()
        lib:closeLevel(lvl)
        lib:calibrate(track)
        cfg.dragging = true
        fromMouse()
    end)
    lib:connect(UIS.InputChanged, function(i)
        if cfg.dragging and i.UserInputType == Enum.UserInputType.MouseMovement then fromMouse() end
    end)
    lib:connect(UIS.InputEnded, function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            cfg.token += 1
            if cfg.dragging then
                cfg.dragging = false
                hot(outer, false)
            end
        end
    end)

    lib.setters[cfg.flag] = cfg.set
    cfg.set(o.default or cfg.min)
    lib:register(self, cfg.name, row)
    return cfg
end

function Section:textbox(o)
    local lib = self.lib
    local cfg = {
        lib = lib, name = o.name or "Textbox", flag = o.flag or o.name or "textbox",
        callback = o.callback or function() end,
    }

    local holder = new("Frame", { Parent = self.body, Size = dim2(1, 0, 0, 38), BackgroundTransparency = 1, LayoutOrder = nxt(lib) })
    label(holder, cfg.name, "text", off(1, 0), dim2(1, -2, 0, 14))
    local body, outer = fieldBox(holder, dim2(1, 0, 0, 20), off(0, 17))
    local box = new("TextBox", {
        Parent = body, Size = dim2(1, -12, 1, 0), Position = off(6, 0), ClearTextOnFocus = false,
        PlaceholderText = o.placeholder or "Type here", PlaceholderColor3 = T("mute"),
        TextTruncate = Enum.TextTruncate.AtEnd,
    })

    box.Focused:Connect(function() hot(outer, true) end)
    box.FocusLost:Connect(function()
        hot(outer, false)
        cfg.set(box.Text)
    end)

    function cfg.set(text)
        text = tostring(text or "")
        box.Text = text
        cfg.value = text
        lib:setFlag(cfg.flag, text)
        cfg.callback(text)
    end

    lib.setters[cfg.flag] = cfg.set
    cfg.set(o.default or "")
    lib:register(self, cfg.name, holder)
    return cfg
end

function Column:preview(o)
    o = o or {}
    local lib = self.lib
    local tab = self.tab
    local sec = self:section({ name = o.name or "Preview" })

    local area = new("Frame", { Parent = sec.body, Size = dim2(1, 0, 0, 250), BackgroundColor3 = T("preview"), LayoutOrder = nxt(lib), ClipsDescendants = true })
    stroke(area, "line")

    local viewport = new("ViewportFrame", {
        Parent = area, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1,
        Ambient = rgb(190, 190, 190), LightColor = WHITE, ZIndex = 1,
    })
    local cam = Instance.new("Camera")
    cam.FieldOfView = 40
    cam.CFrame = CFrame.lookAt(Vector3.new(0, 0, 14), Vector3.new(0, 0, 0))
    cam.Parent = viewport
    viewport.CurrentCamera = cam
    local worldModel = Instance.new("WorldModel")
    worldModel.Parent = viewport

    local ov = new("Frame", { Parent = area, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 2 })

    local glow = new("ImageLabel", {
        Parent = ov, Image = "rbxassetid://110204605000367", ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(v2(21, 21), v2(79, 79)), BackgroundTransparency = 1,
        ImageTransparency = 0.35, Visible = false, ZIndex = 0,
    })
    local boxFill = new("Frame", { Parent = ov, BackgroundColor3 = WHITE, Visible = false, ZIndex = 1 })
    local boxFillGrad = new("UIGradient", { Parent = boxFill })

    local BLACK = rgb(0, 0, 0)
    local function createBar(parent, sz, pos, anchor, color, z)
        local bar = new("Frame", { Parent = parent, Size = sz, Position = pos, AnchorPoint = anchor, BackgroundColor3 = color, ZIndex = z })
        new("UICorner", { Parent = bar, CornerRadius = dim(0, 3) })
        return bar
    end

    local cornerBox = new("Frame", { Parent = ov, BackgroundTransparency = 1, Visible = false, ZIndex = 2 })
    local cornerBars = {}
    for _, sg in ipairs({ {0, 0}, {1, 0}, {0, 1}, {1, 1} }) do
        local xs, ys = sg[1], sg[2]
        local anchor = v2(xs, ys)
        local pos = dim2(xs, 0, ys, 0)
        local one = off(1, 1)
        cornerBars[#cornerBars + 1] = {
            outlineH = createBar(cornerBox, one, pos, anchor, BLACK, 1),
            outlineV = createBar(cornerBox, one, pos, anchor, BLACK, 1),
            colorH = createBar(cornerBox, one, pos, anchor, WHITE, 2),
            colorV = createBar(cornerBox, one, pos, anchor, WHITE, 2),
            xs = xs, ys = ys,
        }
    end

    local fullBox = new("Frame", { Parent = ov, BackgroundTransparency = 1, Visible = false, ZIndex = 2 })
    local fullBars = {}
    for _, sd in ipairs({ {true, true}, {true, false}, {false, true}, {false, false} }) do
        fullBars[#fullBars + 1] = {
            outline = createBar(fullBox, off(1, 1), dim2(0, 0, 0, 0), v2(0, 0), BLACK, 1),
            color = createBar(fullBox, off(1, 1), dim2(0, 0, 0, 0), v2(0, 0), WHITE, 2),
            isHorizontal = sd[1], isStart = sd[2],
        }
    end

    local box3d, bones = {}, {}
    for i = 1, 12 do box3d[i] = newLine(ov, 3) end
    for i = 1, 10 do bones[i] = newLine(ov, 3) end
    local tracer = newLine(ov, 3)

    local hpBack = new("Frame", { Parent = ov, BackgroundColor3 = rgb(15, 15, 15), Visible = false, ZIndex = 3 })
    stroke(hpBack, rgb(0, 0, 0))
    local hpFill = new("Frame", { Parent = hpBack, BackgroundColor3 = WHITE, AnchorPoint = v2(0, 1), Position = dim2(0, 0, 1, 0), Size = dim2(1, 0, 1, 0), ZIndex = 4 })
    local hpGrad = new("UIGradient", { Parent = hpFill, Rotation = 90 })

    local arBack = new("Frame", { Parent = ov, BackgroundColor3 = rgb(15, 15, 15), Visible = false, ZIndex = 3 })
    stroke(arBack, rgb(0, 0, 0))
    local arFill = new("Frame", { Parent = arBack, BackgroundColor3 = WHITE, Size = dim2(1, 0, 1, 0), ZIndex = 4 })
    local arGrad = new("UIGradient", { Parent = arFill })

    local headDot = new("Frame", { Parent = ov, BackgroundColor3 = WHITE, AnchorPoint = v2(0.5, 0.5), Visible = false, ZIndex = 6 })
    new("UICorner", { Parent = headDot, CornerRadius = dim(1, 0) })
    new("UIStroke", {
        Parent = headDot, Color = rgb(0, 0, 0), Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })

    local nameT = newText(ov, 0.5, 1, 5)
    local distT = newText(ov, 0, 0, 5)
    local toolT = newText(ov, 0.5, 0, 5)
    local hpT   = newText(ov, 1, 0, 5)

    local hoverGlow = new("ImageLabel", {
        Parent = ov, Image = "rbxassetid://110204605000367", ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(v2(21, 21), v2(79, 79)), SliceScale = 0.3, BackgroundTransparency = 1,
        ImageColor3 = T("accent"), ImageTransparency = 0.6, Visible = false, ZIndex = 8,
    })
    local hoverBox = new("Frame", { Parent = ov, BackgroundTransparency = 1, Visible = false, ZIndex = 9 })
    stroke(hoverBox, "accent")

    local statusLbl = label(ov, "Loading", "mute", dim2(0, 6, 0.5, -6), dim2(1, -12, 0, 12), ACenter)
    statusLbl.ZIndex = 5
    local errLbl = new("TextLabel", {
        Parent = ov, AnchorPoint = v2(0, 1), Position = dim2(0, 5, 1, -4), Size = dim2(1, -10, 0, 0),
        AutomaticSize = Enum_Y, TextWrapped = true, TextYAlignment = YBot, TextColor3 = rgb(230, 90, 90),
        Visible = false, ZIndex = 5, Text = "",
    })

    local rotBtn = new("TextButton", { Parent = area, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 20 })

    local last = "enemy"
    local records = {}
    local failMsg = {}
    local current, currentName = nil, nil
    local loading = false
    local tintedRec, tintedColor, tintedTr = nil, nil, nil
    local rot = math.pi
    local dragging, lastX, lastDrag = false, 0, 0
    local hpKey, arKey = nil, nil

    local HOVER_ORDER = { "name", "distance", "tool", "health", "armor" }
    local KEY_N = { health = 1, armor = 2, name = 3, distance = 4, tool = 5 }
    local KEY_LIST = { "health", "armor", "name", "distance", "tool" }
    local POS_FLAG = {
        name = "name_pos", distance = "distance_pos", tool = "tool_pos",
        health = "healthbar_pos", armor = "armorbar_pos",
    }
    local POS_DEFAULT = {
        name_pos = "Top", distance_pos = "Right", tool_pos = "Bottom",
        healthbar_pos = "Left", armorbar_pos = "Bottom",
    }
    local SLOT_FLAG = {
        name = "name_slot", distance = "distance_slot", tool = "tool_slot",
        health = "healthbar_slot", armor = "armorbar_slot",
    }
    local SLOT_DEFAULT = {
        name_slot = 3, distance_slot = 4, tool_slot = 5,
        healthbar_slot = 1, armorbar_slot = 2,
    }
    local SIDE_OK = { Top = true, Bottom = true, Left = true, Right = true }
    local TEXT_KEYS = { name = true, distance = true, tool = true }

    local function sideOf(prefix, key)
        local f = POS_FLAG[key]
        local v = lib.flags[prefix .. "_" .. f]
        if type(v) == "string" and SIDE_OK[v] then return v end
        return POS_DEFAULT[f]
    end

    local function slotOf(prefix, key)
        local f = SLOT_FLAG[key]
        local v = lib.flags[prefix .. "_" .. f]
        if type(v) == "number" then return v end
        return SLOT_DEFAULT[f]
    end

    local elems = {}
    local hoverKey = nil
    local dragEl, dragPrefix = nil, nil
    local dragStartMouse, dragStartCenter = nil, nil
    local hits, hitCenter = {}, {}

    local function resetLayout()
        for flag, side in pairs(POS_DEFAULT) do
            local fn = lib.setters[last .. "_" .. flag]
            if fn then pcall(fn, side) end
        end
        for flag, slot in pairs(SLOT_DEFAULT) do
            local fn = lib.setters[last .. "_" .. flag]
            if fn then pcall(fn, slot) end
        end
    end

    for _, key in ipairs(HOVER_ORDER) do
        local b = new("TextButton", {
            Parent = area, Size = off(0, 0), BackgroundTransparency = 1, Visible = false, ZIndex = 21,
        })
        hits[key] = b
        b.MouseEnter:Connect(function() hoverKey = key end)
        b.MouseLeave:Connect(function()
            if hoverKey == key then hoverKey = nil end
        end)
        b.MouseButton1Down:Connect(function()
            if not hitCenter[key] then return end
            dragEl = key
            dragPrefix = last
            dragStartMouse = UIS:GetMouseLocation()
            dragStartCenter = hitCenter[key]
        end)
        b.MouseButton2Click:Connect(resetLayout)
    end

    rotBtn.MouseButton1Down:Connect(function()
        dragging = true
        lastX = UIS:GetMouseLocation().X
        lastDrag = tick()
    end)
    rotBtn.MouseButton2Click:Connect(resetLayout)
    lib:connect(UIS.InputEnded, function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            dragEl = nil
        end
    end)

    local function on(k) return lib.flags[last .. "_" .. k] == true end
    local function num(k, fb)
        local val = lib.flags[last .. "_" .. k]
        if type(val) == "number" then return val end
        return fb
    end
    local function col(k, fb)
        local val = lib.flags[last .. "_" .. k]
        if typeof(val) == "Color3" then return val end
        return fb
    end
    local function str(k, fb)
        local val = lib.flags[last .. "_" .. k]
        if type(val) == "string" then return val end
        return fb
    end

    local function espFont(name)
        local f = (lib.espFonts and lib.espFonts[name]) or FontBank.map[name]
        return f or UI.font, f ~= nil
    end

    local function putText(t, text, fontName, size, c1, c2, rotation, p)
        local lbl = t.label
        if t.text ~= text then lbl.Text = text; t.text = text end
        local f, loaded = espFont(fontName)
        local key = fontName .. (loaded and "1" or "0")
        if t.fontKey ~= key then lbl.FontFace = f; t.fontKey = key end
        if lbl.TextSize ~= size then lbl.TextSize = size end
        if t.c1 ~= c1 or t.c2 ~= c2 then
            t.grad.Color = ColorSequence.new(c1, c2)
            t.c1, t.c2 = c1, c2
        end
        t.grad.Rotation = rotation
        if t.ax ~= p.ax or t.ay ~= p.ay then
            t.ax, t.ay = p.ax, p.ay
            lbl.AnchorPoint = v2(p.ax, p.ay)
            lbl.TextXAlignment = p.ax == 0 and ALeft or (p.ax == 1 and ARight or ACenter)
            lbl.TextYAlignment = p.ay == 0 and YTop or (p.ay == 1 and YBot or YMid)
        end
        lbl.Position = off(p.x, p.y)
        lbl.Visible = true
    end

    local function textRect(t, p, size)
        local bw, bh = t.label.TextBounds.X, t.label.TextBounds.Y
        if bw < 1 or bh < 1 then
            bw, bh = t.label.AbsoluteSize.X, t.label.AbsoluteSize.Y
        end
        if bw < 1 or bh < 1 then
            bw, bh = #(t.text or "") * size * 0.55, size + 2
        end
        return p.x - p.ax * bw, p.y - p.ay * bh, bw, bh
    end

    local function layoutPreview(cfg, x, y, w, h, opt)
        local size = opt.size or 12
        local step = size + 1
        local ratio = opt.ratio or 1
        local out = {}
        local offs = { Top = 0, Bottom = 0, Left = 0, Right = 0 }
        local rows = { Left = 0, Right = 0 }

        local function placeBar(key, side)
            local rx, ry, rw, rh, vertical
            if side == "Left" then
                rx, ry, rw, rh, vertical = x - 4 - offs.Left, y, 1, h, true
            elseif side == "Right" then
                rx, ry, rw, rh, vertical = x + w + 3 + offs.Right, y, 1, h, true
            elseif side == "Top" then
                rx, ry, rw, rh, vertical = x, y - 4 - offs.Top, w, 1, false
            else
                rx, ry, rw, rh, vertical = x, y + h + 3 + offs.Bottom, w, 1, false
            end
            out[key] = { x = rx, y = ry, w = rw, h = rh, vertical = vertical, side = side }
            offs[side] += 4
            return rx, ry
        end

        local function placeText(side)
            local p
            if side == "Top" then
                p = { x = x + w * 0.5, y = y - 3 - offs.Top, ax = 0.5, ay = 1 }
                offs.Top += step
            elseif side == "Bottom" then
                p = { x = x + w * 0.5, y = y + h + 3 + offs.Bottom, ax = 0.5, ay = 0 }
                offs.Bottom += step
            elseif side == "Left" then
                p = { x = x - 4 - offs.Left, y = y - 1 + rows.Left * step, ax = 1, ay = 0 }
                rows.Left += 1
            else
                p = { x = x + w + 4 + offs.Right, y = y - 1 + rows.Right * step, ax = 0, ay = 0 }
                rows.Right += 1
            end
            return p
        end

        local function doHealth(side)
            local rx, ry = placeBar("health", side)
            if cfg.HealthText then
                local ty = math.clamp(y + h - h * ratio - 5, y - 2, y + h - 10)
                local tx = math.clamp(x + w * ratio, x, x + w)
                if side == "Left" then
                    out.healthText = { x = rx - 3, y = ty, ax = 1, ay = 0 }
                    offs.Left += 16
                elseif side == "Right" then
                    out.healthText = { x = rx + 4, y = ty, ax = 0, ay = 0 }
                    offs.Right += 16
                elseif side == "Top" then
                    out.healthText = { x = tx, y = ry - 2, ax = 0.5, ay = 1 }
                    offs.Top += size + 2
                else
                    out.healthText = { x = tx, y = ry + 4, ax = 0.5, ay = 0 }
                    offs.Bottom += size + 2
                end
            end
        end

        local items = {}
        local function add(key, kind, enabled)
            if enabled then
                items[#items + 1] = {
                    key = key, kind = kind, side = cfg.sides[key], slot = cfg.slots[key], n = KEY_N[key],
                }
            end
        end
        add("health", "healthbar", opt.health)
        add("armor", "bar", opt.armor)
        add("name", "text", cfg.Names)
        add("distance", "text", cfg.Distance)
        add("tool", "text", cfg.Tool)

        table.sort(items, function(a, b)
            if a.slot ~= b.slot then return a.slot < b.slot end
            return a.n < b.n
        end)

        local deferred = {}
        for _, it in ipairs(items) do
            if it.kind == "healthbar" then
                doHealth(it.side)
            elseif it.kind == "bar" then
                placeBar(it.key, it.side)
            elseif it.side == "Left" or it.side == "Right" then
                deferred[#deferred + 1] = it
            else
                out[it.key] = placeText(it.side)
            end
        end
        for _, it in ipairs(deferred) do
            out[it.key] = placeText(it.side)
        end

        return out
    end

    local function applyTint(want, fillTr)
        if not current then return end
        if tintedRec == current and tintedColor == want and tintedTr == fillTr then return end
        tintedRec, tintedColor, tintedTr = current, want, fillTr
        for part, orig in pairs(current.tint) do
            if part and part.Parent then
                if want then
                    part.Color = orig.c:Lerp(want, clamp(1 - (fillTr or 0.3), 0, 1))
                    part.Material = Enum.Material.Neon
                    if part:IsA("MeshPart") then part.TextureID = "" end
                    if orig.sm and orig.sm.Parent then orig.sm.TextureId = "" end
                else
                    part.Color = orig.c
                    part.Material = orig.m
                    if part:IsA("MeshPart") and orig.tex ~= nil then part.TextureID = orig.tex end
                    if orig.sm and orig.sm.Parent and orig.smtex ~= nil then orig.sm.TextureId = orig.smtex end
                end
            end
        end
    end

    local function hideAll()
        glow.Visible = false
        boxFill.Visible = false
        cornerBox.Visible = false
        fullBox.Visible = false
        hideGroup(box3d)
        hideGroup(bones)
        tracer.hide()
        hpBack.Visible = false
        arBack.Visible = false
        headDot.Visible = false
        nameT.label.Visible = false
        distT.label.Visible = false
        toolT.label.Visible = false
        hpT.label.Visible = false
        hoverGlow.Visible = false
        hoverBox.Visible = false
        for _, b in pairs(hits) do b.Visible = false end
        hoverKey = nil
        table.clear(elems)
    end

    local ensure
    function ensure(name)
        if records[name] then return records[name] end
        local m
        local assetId = MODEL_REGISTRY[name]
        if assetId then
            local info
            m, info = loadModelById(assetId)
            if not m then
                failMsg[name] = info or "load failed"
                lib:notify({ title = "Preview", text = name .. " failed to load", kind = "error" })
                records[name] = ensure("Local Player")
                return records[name]
            end
            failMsg[name] = nil
        else
            m = buildLocal()
        end
        if not m then return nil end
        local rec = prepareModel(m)
        if not rec then
            if assetId then
                failMsg[name] = "prepare failed"
                pcall(function() m:Destroy() end)
                records[name] = ensure("Local Player")
                return records[name]
            end
            return nil
        end
        records[name] = rec
        return rec
    end

    local function switchTo(name)
        if loading then return end
        loading = true
        task.spawn(function()
            local ok, rec = pcall(ensure, name)
            if not ok then
                failMsg[name] = tostring(rec)
                rec = records["Local Player"]
            end
            if current and current.model then current.model.Parent = nil end
            current = rec
            currentName = name
            tintedRec = nil
            if rec then rec.model.Parent = worldModel end
            loading = false
        end)
    end

    local function render(dt)
        if not (lib.root.Visible and tab.page.Visible) then return end

        local want = lib.flags.preview_model or "Local Player"
        if want ~= currentName and not loading then switchTo(want) end

        local fail = failMsg[want]
        if fail and want ~= "Local Player" then
            local msg = want .. " failed, showing Local Player. " .. fail
            if errLbl.Text ~= msg then errLbl.Text = msg end
            errLbl.Visible = true
        else
            errLbl.Visible = false
        end

        statusLbl.Visible = current == nil
        statusLbl.Text = loading and "Loading" or "No model"
        if not current then
            hideAll()
            return
        end

        if dragging then
            local mx = UIS:GetMouseLocation().X
            rot = rot + (mx - lastX) * 0.012
            lastX = mx
            lastDrag = tick()
        elseif tick() - lastDrag > 2 then
            rot = rot + dt * 0.9
        end
        current.model:PivotTo(CFrame.Angles(0, rot, 0) * current.pivot0)

        local w, h = area.AbsoluteSize.X, area.AbsoluteSize.Y
        if w < 20 or h < 20 then return end

        local tanHalf = math.tan(math.rad(cam.FieldOfView) / 2)
        local distV = (current.height * 0.5) / (0.8 * tanHalf)
        local distH = current.radius / (0.85 * tanHalf * (w / h))
        local dist = math.max(distV, distH) + current.radius
        cam.CFrame = CFrame.lookAt(Vector3.new(0, 0, dist), Vector3.new(0, 0, 0))
        local camCF = cam.CFrame

        local mm = tab.activeMulti
        local nm = mm and lower(mm.name) or "enemy"
        if nm == "enemy" or nm == "team" or nm == "ai" then
            if not dragEl then last = nm end
        end

        if not on("enabled") then
            hideAll()
            applyTint(nil)
            return
        end

        local pc = {}
        local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
        for i = 1, 8 do
            local pt = projectPoint(current.corners[i], camCF, tanHalf, w, h)
            pc[i] = pt
            if pt then
                if pt.X < minX then minX = pt.X end
                if pt.Y < minY then minY = pt.Y end
                if pt.X > maxX then maxX = pt.X end
                if pt.Y > maxY then maxY = pt.Y end
            end
        end
        if minX == math.huge then hideAll() return end

        local pad = 4
        local x = floor(minX - pad + 0.5)
        local y = floor(minY - pad + 0.5)
        local sx = math.max(floor(maxX - minX + pad * 2 + 0.5), 8)
        local sy = math.max(floor(maxY - minY + pad * 2 + 0.5), 8)

        local showBox = on("box")
        local boxType = str("box_type", "Corner")
        local thick = math.max(1, num("box_thickness", 1))
        local lineCol = col("box_color", WHITE)
        local fillOn = showBox and on("boxfill")
        local fillC1 = col("boxfill_c1", rgb(255, 80, 80))
        local fillC2 = col("boxfill_c2", rgb(255, 40, 40))
        local fillTrans = num("boxfill_trans", 0.7)

        if fillOn and boxType ~= "3D" then
            boxFill.Position = off(x, y)
            boxFill.Size = off(sx, sy)
            boxFill.BackgroundTransparency = fillTrans
            boxFillGrad.Color = ColorSequence.new(fillC1, fillC2)
            boxFillGrad.Rotation = (((tick() * 100) % 360) * 0.02) % 360
            boxFill.Visible = true
        else
            boxFill.Visible = false
        end

        if showBox and on("box_glow") then
            glow.Position = off(x - 21, y - 21)
            glow.Size = off(sx + 42, sy + 41)
            glow.ImageColor3 = lineCol
            glow.Visible = true
        else
            glow.Visible = false
        end

        if showBox then
            if boxType == "Full" then
                cornerBox.Visible = false
                hideGroup(box3d)
                fullBox.Visible = true
                fullBox.Position = off(x, y)
                fullBox.Size = off(sx, sy)
                for _, b in ipairs(fullBars) do
                    if b.isHorizontal then
                        b.color.Size = off(sx, thick)
                        b.color.Position = off(0, b.isStart and 0 or (sy - thick))
                        b.outline.Size = off(sx + 2, thick + 2)
                        b.outline.Position = off(-1, b.isStart and -1 or (sy - thick - 1))
                    else
                        b.color.Size = off(thick, sy)
                        b.color.Position = off(b.isStart and 0 or (sx - thick), 0)
                        b.outline.Size = off(thick + 2, sy + 2)
                        b.outline.Position = off(b.isStart and -1 or (sx - thick - 1), -1)
                    end
                    b.color.BackgroundColor3 = lineCol
                end
            elseif boxType == "3D" then
                cornerBox.Visible = false
                fullBox.Visible = false
                for i = 1, 12 do
                    local e = EDGES_3D[i]
                    local pa, pb = pc[e[1]], pc[e[2]]
                    if pa and pb then
                        box3d[i].thickness = thick
                        box3d[i].color(lineCol)
                        box3d[i].set(pa, pb)
                    else
                        box3d[i].hide()
                    end
                end
            else
                fullBox.Visible = false
                hideGroup(box3d)
                cornerBox.Visible = true
                cornerBox.Position = off(x, y)
                cornerBox.Size = off(sx, sy)
                local maxAllowed = math.min(50, math.floor(math.min(sx, sy) * 0.42))
                local lineLen = math.clamp(40, 6, math.max(6, maxAllowed))
                for _, c in ipairs(cornerBars) do
                    local ox = c.xs == 0 and -1 or 1
                    local oy = c.ys == 0 and -1 or 1
                    local base = dim2(c.xs, 0, c.ys, 0)
                    c.colorH.Size = off(lineLen, thick)
                    c.colorH.Position = base
                    c.colorH.BackgroundColor3 = lineCol
                    c.outlineH.Size = off(lineLen + 2, thick + 2)
                    c.outlineH.Position = base + off(ox, oy)
                    c.colorV.Size = off(thick, lineLen)
                    c.colorV.Position = base
                    c.colorV.BackgroundColor3 = lineCol
                    c.outlineV.Size = off(thick + 2, lineLen + 2)
                    c.outlineV.Position = base + off(ox, oy)
                end
            end
        else
            cornerBox.Visible = false
            fullBox.Visible = false
            hideGroup(box3d)
        end

        local tintWant, tintTr = nil, 0.3
        if on("chams") then
            tintWant = col("chams_color", Theme.v.accent)
            tintTr = num("chams_fill", 0.3)
        elseif fillOn and boxType == "3D" then
            tintWant = fillC1
            tintTr = fillTrans
        end
        applyTint(tintWant, tintTr)

        local size = floor(num("textsize", 12))
        local animated = lib.flags.esp_text_gradient == "Animated"
        local rotG = animated and (tick() * 100) % 360 or 0
        local textFont = lib.flags.esp_text_font or "Gojiberry Quibble"
        local flagsFont = lib.flags.esp_flags_font or "Gojiberry Quibble"
        local healthFont = lib.flags.esp_health_font or "Gojiberry Quibble"

        local hpRatio = 0.55 + 0.45 * math.sin(tick() * 1.2)
        local hi = col("health_high", rgb(0, 255, 100))
        local mid = col("health_mid", rgb(255, 255, 0))
        local lo = col("health_low", rgb(255, 40, 40))
        local healthOn = on("healthbar")
        local armorOn = on("armorbar")

        local sides, slots = {}, {}
        for _, k in ipairs(KEY_LIST) do
            sides[k] = sideOf(last, k)
            slots[k] = slotOf(last, k)
        end

        local lay = layoutPreview({
            HealthText = on("healthtext"),
            Names = on("names"), Distance = on("distance"), Tool = on("tool"),
            sides = sides, slots = slots,
        }, x, y, sx, sy, { size = size, ratio = hpRatio, health = healthOn, armor = armorOn })

        table.clear(elems)
        local function addRect(key, rx, ry, rw, rh)
            local list = elems[key]
            if not list then
                list = {}
                elems[key] = list
            end
            list[#list + 1] = { x = rx, y = ry, w = rw, h = rh }
        end

        if lay.health then
            local r = lay.health
            hpBack.Position = off(r.x, r.y)
            hpBack.Size = off(r.w, r.h)
            hpBack.Visible = true
            if r.vertical then
                hpFill.AnchorPoint = v2(0, 1)
                hpFill.Position = dim2(0, 0, 1, 0)
                hpFill.Size = dim2(1, 0, hpRatio, 0)
                hpGrad.Rotation = 90
            else
                hpFill.AnchorPoint = v2(0, 0)
                hpFill.Position = dim2(0, 0, 0, 0)
                hpFill.Size = dim2(hpRatio, 0, 1, 0)
                hpGrad.Rotation = 0
            end
            local key = tostring(hi) .. tostring(mid) .. tostring(lo)
            if hpKey ~= key then
                hpGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, hi),
                    ColorSequenceKeypoint.new(0.5, mid),
                    ColorSequenceKeypoint.new(1, lo),
                })
                hpKey = key
            end
            addRect("health", r.x, r.y, r.w, r.h)
        else
            hpBack.Visible = false
        end

        if lay.healthText then
            local t2 = clamp(hpRatio, 0, 1)
            local hc = t2 >= 0.5 and mid:Lerp(hi, (t2 - 0.5) * 2) or lo:Lerp(mid, t2 * 2)
            putText(hpT, tostring(floor(hpRatio * 100 + 0.5)), healthFont, size, hc, hc, 0, lay.healthText)
            local tx, ty, tw, th = textRect(hpT, lay.healthText, size)
            addRect("health", tx, ty, tw, th)
        else
            hpT.label.Visible = false
        end

        if lay.armor then
            local r = lay.armor
            arBack.Position = off(r.x, r.y)
            arBack.Size = off(r.w, r.h)
            arBack.Visible = true
            if r.vertical then
                arFill.AnchorPoint = v2(0, 1)
                arFill.Position = dim2(0, 0, 1, 0)
                arGrad.Rotation = 90
            else
                arFill.AnchorPoint = v2(0, 0)
                arFill.Position = dim2(0, 0, 0, 0)
                arGrad.Rotation = 0
            end
            arFill.Size = dim2(1, 0, 1, 0)
            local ah = col("armor_high", rgb(0, 255, 0))
            local am = col("armor_mid", rgb(255, 255, 0))
            local al = col("armor_low", rgb(255, 0, 0))
            local key = tostring(ah) .. tostring(am) .. tostring(al)
            if arKey ~= key then
                arGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, ah),
                    ColorSequenceKeypoint.new(0.5, am),
                    ColorSequenceKeypoint.new(1, al),
                })
                arKey = key
            end
            addRect("armor", r.x, r.y, r.w, r.h)
        else
            arBack.Visible = false
        end

        if lay.name then
            local nt = str("name_type", "Display")
            local txt = lp.DisplayName
            if nt == "Username" then
                txt = lp.Name
            elseif nt == "Both" then
                txt = lp.DisplayName .. " (@" .. lp.Name .. ")"
            end
            putText(nameT, txt, textFont, size, col("name_color", WHITE), col("name_color2", WHITE), rotG, lay.name)
            local tx, ty, tw, th = textRect(nameT, lay.name, size)
            addRect("name", tx, ty, tw, th)
        else
            nameT.label.Visible = false
        end

        if lay.distance then
            putText(distT, "[45m]", flagsFont, size, col("dist_color", WHITE), col("dist_color2", WHITE), rotG, lay.distance)
            local tx, ty, tw, th = textRect(distT, lay.distance, size)
            addRect("distance", tx, ty, tw, th)
        else
            distT.label.Visible = false
        end

        if lay.tool then
            putText(toolT, "Weapon", textFont, size, col("tool_color", WHITE), col("tool_color2", WHITE), rotG, lay.tool)
            local tx, ty, tw, th = textRect(toolT, lay.tool, size)
            addRect("tool", tx, ty, tw, th)
        else
            toolT.label.Visible = false
        end

        for _, key in ipairs(HOVER_ORDER) do
            local b = hits[key]
            local list = elems[key]
            if list then
                local ux1, uy1, ux2, uy2 = math.huge, math.huge, -math.huge, -math.huge
                for _, r in ipairs(list) do
                    if r.x < ux1 then ux1 = r.x end
                    if r.y < uy1 then uy1 = r.y end
                    if r.x + r.w > ux2 then ux2 = r.x + r.w end
                    if r.y + r.h > uy2 then uy2 = r.y + r.h end
                end
                b.Position = off(floor(ux1 - 4), floor(uy1 - 4))
                b.Size = off(floor(ux2 - ux1 + 8), floor(uy2 - uy1 + 8))
                b.Visible = true
                hitCenter[key] = v2((ux1 + ux2) * 0.5, (uy1 + uy2) * 0.5)
            else
                b.Visible = false
                hitCenter[key] = nil
            end
        end

        if dragEl and elems[dragEl] and dragStartCenter then
            local mp = UIS:GetMouseLocation()
            local vx = dragStartCenter.X + (mp.X - dragStartMouse.X)
            local vy = dragStartCenter.Y + (mp.Y - dragStartMouse.Y)
            local cx, cy = x + sx * 0.5, y + sy * 0.5
            local nx = (vx - cx) / (sx * 0.5)
            local ny = (vy - cy) / (sy * 0.5)
            local side
            if math.abs(nx) > math.abs(ny) then
                side = nx < 0 and "Left" or "Right"
            else
                side = ny < 0 and "Top" or "Bottom"
            end

            local function rankOf(key, s, px, py, pw, ph)
                local rcx, rcy = px + pw * 0.5, py + ph * 0.5
                if (s == "Left" or s == "Right") and TEXT_KEYS[key] then return rcy end
                if s == "Left" then return x - rcx end
                if s == "Right" then return rcx - (x + sx) end
                if s == "Top" then return y - rcy end
                return rcy - (y + sy)
            end

            local mouseRank = rankOf(dragEl, side, vx, vy, 0, 0)

            local others = {}
            for _, k in ipairs(KEY_LIST) do
                if k ~= dragEl and elems[k] and sideOf(dragPrefix, k) == side then
                    others[#others + 1] = k
                end
            end
            table.sort(others, function(a, b)
                local sa, sb = slotOf(dragPrefix, a), slotOf(dragPrefix, b)
                if sa ~= sb then return sa < sb end
                return KEY_N[a] < KEY_N[b]
            end)

            local insertIdx = 1
            for i, k in ipairs(others) do
                local comparable = side == "Top" or side == "Bottom" or (TEXT_KEYS[k] == TEXT_KEYS[dragEl])
                local r = elems[k][1]
                if comparable and rankOf(k, side, r.x, r.y, r.w, r.h) < mouseRank then
                    insertIdx = i + 1
                end
            end
            table.insert(others, insertIdx, dragEl)

            for i, k in ipairs(others) do
                if slotOf(dragPrefix, k) ~= i then
                    local fn = lib.setters[dragPrefix .. "_" .. SLOT_FLAG[k]]
                    if fn then pcall(fn, i) end
                end
            end

            if sideOf(dragPrefix, dragEl) ~= side then
                local fn = lib.setters[dragPrefix .. "_" .. POS_FLAG[dragEl]]
                if fn then pcall(fn, side) end
            end
        end

        local active = dragEl or ((not dragging) and hoverKey) or nil
        if active and not elems[active] then active = nil end

        if active and elems[active] then
            local ux1, uy1, ux2, uy2 = math.huge, math.huge, -math.huge, -math.huge
            for _, r in ipairs(elems[active]) do
                if r.x < ux1 then ux1 = r.x end
                if r.y < uy1 then uy1 = r.y end
                if r.x + r.w > ux2 then ux2 = r.x + r.w end
                if r.y + r.h > uy2 then uy2 = r.y + r.h end
            end
            ux1, uy1, ux2, uy2 = floor(ux1 - 2), floor(uy1 - 2), floor(ux2 + 2), floor(uy2 + 2)
            local bw, bh = ux2 - ux1, uy2 - uy1
            hoverBox.Position = off(ux1, uy1)
            hoverBox.Size = off(bw, bh)
            hoverBox.Visible = true
            hoverGlow.Position = off(ux1 - 6, uy1 - 6)
            hoverGlow.Size = off(bw + 12, bh + 12)
            hoverGlow.ImageTransparency = dragEl and 0.35 or 0.6
            hoverGlow.Visible = true
        else
            hoverBox.Visible = false
            hoverGlow.Visible = false
        end

        if on("headdot") and current.head then
            local hp = projectPoint(current.head(), camCF, tanHalf, w, h)
            if hp then
                local ds = math.max(2, floor(num("headdot_size", 20)))
                headDot.Size = off(ds, ds)
                headDot.Position = off(hp.X, hp.Y)
                headDot.BackgroundColor3 = col("headdot_color", WHITE)
                headDot.Visible = true
            else
                headDot.Visible = false
            end
        else
            headDot.Visible = false
        end

        if on("tracers") then
            local origin = str("tracer_origin", "Bottom")
            local from
            if origin == "Top" then
                from = v2(w * 0.5, 0)
            elseif origin == "Bottom" then
                from = v2(w * 0.5, h)
            else
                from = v2(w * 0.5, h * 0.5)
            end
            tracer.thickness = num("tracer_thickness", 1)
            tracer.color(col("tracer_color", WHITE))
            tracer.set(from, v2(x + sx * 0.5, y + sy))
        else
            tracer.hide()
        end

        if on("skeleton") then
            local c1 = col("skeleton_color", WHITE)
            local c2 = col("skeleton_color2", WHITE)
            local sth = num("skeleton_thickness", 1)
            for i = 1, 10 do
                local fn = current.bones[i]
                if fn then
                    local wa, wb = fn()
                    local pa = projectPoint(wa, camCF, tanHalf, w, h)
                    local pb = projectPoint(wb, camCF, tanHalf, w, h)
                    if pa and pb then
                        bones[i].thickness = sth
                        bones[i].color(c1, c2)
                        bones[i].set(pa, pb)
                    else
                        bones[i].hide()
                    end
                else
                    bones[i].hide()
                end
            end
        else
            hideGroup(bones)
        end
    end

    lib:connect(RunService.RenderStepped, render)

    local modelItems = { "Local Player" }
    for name in pairs(MODEL_REGISTRY) do
        modelItems[#modelItems + 1] = name
    end
    table.sort(modelItems)
    sec:dropdown({
        name = "Model", flag = "preview_model", items = modelItems, default = "Local Player",
    })

    return sec
end

function Library:exportConfig()
    self.pending = self.pending or {}
    local out = {}
    for k, v in pairs(self.pending) do
        if not isUiFlag(k) then out[k] = encode(v) end
    end
    for k, v in pairs(self.flags) do
        if not isUiFlag(k) then out[k] = encode(v) end
    end
    return HttpService:JSONEncode(out)
end

function Library:importConfig(json)
    self.pending = self.pending or {}
    local ok, data = pcall(function() return HttpService:JSONDecode(json) end)
    if not ok or type(data) ~= "table" then return false end
    local decoded = {}
    for k, v in pairs(data) do
        if not isUiFlag(k) then decoded[k] = decode(v) end
    end
    for k, v in pairs(decoded) do
        local fn = self.setters[k]
        if fn then
            self.pending[k] = nil
            if typeof(v) == "Color3" then
                pcall(fn, v, decoded[k .. "_alpha"])
            else
                pcall(fn, v)
            end
        else
            self.pending[k] = v
        end
    end
    return true
end

function Library:configTab(tab)
    local lib = self
    local base = (lower(lib.folder):gsub("%W", ""))
    local rootFolder = base .. "_configs"
    local cfgFolder = rootFolder .. "/" .. tostring(game.PlaceId)
    local themeFolder = base .. "_themes"
    local canFs = typeof(writefile) == "function" and typeof(readfile) == "function" and typeof(listfiles) == "function"
    
    if canFs and typeof(makefolder) == "function" then
        for _, f in ipairs({ rootFolder, cfgFolder, themeFolder }) do
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
    end })
    cfgSec:button({ name = "Load", callback = function()
        if not canFs then lib:notify("Filesystem unavailable") return end
        local n = cfgTarget()
        local ok, data = pcall(readfile, cfgFolder .. "/" .. n .. ".cfg")
        if ok and lib:importConfig(data) then
            lib:notify("Loaded " .. n)
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

    local glowToggle = menuSec:toggle({ name = "UI Glow", flag = "__ui_glow", default = true, callback = function(v)
        if lib.glow then lib.glow.Visible = v end
    end })
    local glowPop = glowToggle:gear({ title = "Glow Options" })
    glowPop:slider({
        name = "Glow Transparency", flag = "__ui_glow_trans", min = 0, max = 1, default = 0.55, interval = 0.05,
        callback = function(v)
            if lib.glow then lib.glow.ImageTransparency = v end
        end,
    })

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

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/personalvalor/Catware/refs/heads/main/EspLibrary.lua"))()

local win = Library.new({
    name = "Stardust", version = "Private", folder = "catware",
    logoIcon = "sparkles", fonts = ESP.Fonts,
})
win.onUnload = function()
    ESP:Stop()
    if env and env.Stardust == Stardust then env.Stardust = nil end
end

local combat = win:category("Combat")
local legit = combat:tab("Legit")
local Rage = combat:tab("Rage")

local visuals = win:category("Visuals")
local playersTab = visuals:tab("Players")
local world = visuals:tab("World")

local other = win:category("Other")
local misc = other:tab("Misc")

local Settings = win:category("Settings")
local config = Settings:tab("UI Settings")

local left = playersTab:column("left")
local right = playersTab:column("right")

local Enemy, Team, Setting = left:multi_section({
    names = {"Enemy", "Team", "Settings"},
    fills = false,
})

local function getPopupRow(el)
    if type(el) ~= "table" then return nil end
    if typeof(el.row) == "Instance" and el.row:IsA("GuiObject") then return el.row end
    if typeof(el.holder) == "Instance" and el.holder:IsA("GuiObject") then return el.holder end
    for _, v in pairs(el) do
        if typeof(v) == "Instance" and v:IsA("GuiObject") and v.Name ~= "Popup" and v.Name ~= "Gear" then
            return v
        end
    end
    return nil
end

local function setPopupElemVisible(el, vis)
    local row = getPopupRow(el)
    if row then
        row.Visible = vis
    end
end

local function addESPSection(sec, tbl, prefix)
    sec:toggle({name = "Enabled", default = tbl.Enabled, flag = prefix.."_enabled", callback = function(v) tbl.Enabled = v end})

    local box = sec:toggle({name = "Box", default = tbl.BoxEnabled, flag = prefix.."_box", callback = function(v) tbl.BoxEnabled = v end})
    box:colorpicker({flag = prefix.."_box_color", color = tbl.LineColor, callback = function(c) tbl.LineColor = c end})
    local boxPop = box:gear({title = "Box Options"})
    boxPop:dropdown({name = "Box Type", items = {"Corner", "Full", "3D"}, default = tbl.BoxType, flag = prefix.."_box_type", callback = function(v) tbl.BoxType = v end})
    boxPop:slider({name = "Box Thickness", min = 1, max = 5, default = tbl.Thickness, interval = 1, flag = prefix.."_box_thickness", callback = function(v) tbl.Thickness = v end})
    boxPop:toggle({name = "Box Glow", default = tbl.BoxGlow, flag = prefix.."_box_glow", callback = function(v) tbl.BoxGlow = v end})

    local fill = sec:toggle({name = "Box Fill", default = tbl.BoxFill, flag = prefix.."_boxfill", callback = function(v) tbl.BoxFill = v end})
    fill:colorpicker({flag = prefix.."_boxfill_c1", color = tbl.BoxFillColor1, callback = function(c) tbl.BoxFillColor1 = c end})
    fill:colorpicker({flag = prefix.."_boxfill_c2", color = tbl.BoxFillColor2, callback = function(c) tbl.BoxFillColor2 = c end})
    local fillPop = fill:gear({title = "Box Fill Options"})
    fillPop:slider({name = "Fill Transparency", min = 0, max = 1, default = tbl.BoxFillTransparency, interval = 0.05, flag = prefix.."_boxfill_trans", callback = function(v) tbl.BoxFillTransparency = v end})

    local cs = tbl.ChamsSettings
    local chams = sec:toggle({name = "Chams", risky = true, default = tbl.Chams, flag = prefix.."_chams", callback = function(v) tbl.Chams = v end})
    chams:colorpicker({flag = prefix.."_chams_c1", color = cs.Color1, callback = function(c) cs.Color1 = c end})
    chams:colorpicker({flag = prefix.."_chams_c2", color = cs.Color2, callback = function(c) cs.Color2 = c end})
    local cp3 = chams:colorpicker({flag = prefix.."_chams_c3", color = cs.Color3, callback = function(c) cs.Color3 = c end})

    local chamsPop = chams:gear({title = "Chams Options"})
    local shaderElems = {}
    local adornElems = {}

    local function syncChamsUI(mode)
        local isShader = (mode == "Shader")
        if type(cp3) == "table" and typeof(cp3.button) == "Instance" and cp3.button:IsA("GuiObject") then
            cp3.button.Visible = isShader
        end
        for _, el in ipairs(shaderElems) do
            setPopupElemVisible(el, isShader)
        end
        for _, el in ipairs(adornElems) do
            setPopupElemVisible(el, not isShader)
        end
    end

    chamsPop:dropdown({
        name = "Chams Type",
        items = {"Shader", "Adornment"},
        default = tbl.ChamsType or "Shader",
        flag = prefix.."_chams_type",
        callback = function(v)
            tbl.ChamsType = v
            syncChamsUI(v)
        end
    })

    adornElems[#adornElems + 1] = chamsPop:slider({
        name = "Chams Transparency",
        min = 0, max = 1,
        default = tbl.AdornmentTransparency or 0.55,
        interval = 0.05,
        flag = prefix.."_adorn_trans",
        callback = function(v) tbl.AdornmentTransparency = v end
    })
    adornElems[#adornElems + 1] = chamsPop:slider({
        name = "Glow Transparency",
        min = 0, max = 1,
        default = tbl.AdornmentGlowTransparency or 0.78,
        interval = 0.05,
        flag = prefix.."_adorn_glow_trans",
        callback = function(v) tbl.AdornmentGlowTransparency = v end
    })

    shaderElems[#shaderElems + 1] = chamsPop:dropdown({name = "Design", items = ESP.GetChamsDesignNames(), default = cs.Design, flag = prefix.."_chams_design", callback = function(v)
        ESP:SetChamsDesign(v, tbl)
        for i = 1, 3 do
            local setter = win.setters[prefix.."_chams_c"..i]
            if setter then pcall(setter, cs["Color" .. i]) end
        end
    end})
    shaderElems[#shaderElems + 1] = chamsPop:slider({name = "Colors", min = 1, max = 3, default = cs.ColorCount, interval = 1, flag = prefix.."_chams_colors", callback = function(v) cs.ColorCount = v end})
    shaderElems[#shaderElems + 1] = chamsPop:slider({name = "Bloom", min = 0, max = 1.5, default = cs.Bloom, interval = 0.05, flag = prefix.."_chams_bloom", callback = function(v) cs.Bloom = v end})
    shaderElems[#shaderElems + 1] = chamsPop:slider({name = "Bloom Spread", min = 0, max = 12, default = cs.BloomSpread, interval = 0.5, flag = prefix.."_chams_spread", callback = function(v) cs.BloomSpread = v end})
    shaderElems[#shaderElems + 1] = chamsPop:slider({name = "Brightness", min = 0.5, max = 2, default = cs.Brightness, interval = 0.05, flag = prefix.."_chams_brightness", callback = function(v) cs.Brightness = v end})
    shaderElems[#shaderElems + 1] = chamsPop:slider({name = "Contrast", min = 0.5, max = 2, default = cs.Contrast, interval = 0.05, flag = prefix.."_chams_contrast", callback = function(v) cs.Contrast = v end})
    shaderElems[#shaderElems + 1] = chamsPop:slider({name = "Speed", min = 0, max = 4, default = cs.Speed, interval = 0.05, flag = prefix.."_chams_speed", callback = function(v) cs.Speed = v end})
    shaderElems[#shaderElems + 1] = chamsPop:slider({name = "Scale", min = 0.5, max = 8, default = cs.Scale, interval = 0.1, flag = prefix.."_chams_scale", callback = function(v) cs.Scale = v end})

    syncChamsUI(tbl.ChamsType or "Shader")

    local names = sec:toggle({name = "Names", default = tbl.Names, flag = prefix.."_names", callback = function(v) tbl.Names = v end})
    names:colorpicker({flag = prefix.."_name_color", color = tbl.NameColor, callback = function(c) tbl.NameColor = c end})
    names:colorpicker({flag = prefix.."_name_color2", color = tbl.NameColor2, callback = function(c) tbl.NameColor2 = c end})
    local namePop = names:gear({title = "Name Options"})
    namePop:dropdown({name = "Name Type", items = {"Display", "Username", "Both"}, default = tbl.NameType, flag = prefix.."_name_type", callback = function(v) tbl.NameType = v end})
    namePop:dropdown({name = "Name Position", items = {"Top", "Bottom", "Left", "Right"}, default = tbl.NamePos, flag = prefix.."_name_pos", callback = function(v) tbl.NamePos = v end})
    namePop:slider({name = "Name Slot", min = 1, max = 10, default = tbl.NameSlot or 3, interval = 1, flag = prefix.."_name_slot", callback = function(v) tbl.NameSlot = v end})

    local dist = sec:toggle({name = "Distance", default = tbl.Distance, flag = prefix.."_distance", callback = function(v) tbl.Distance = v end})
    dist:colorpicker({flag = prefix.."_dist_color", color = tbl.DistanceColor, callback = function(c) tbl.DistanceColor = c end})
    dist:colorpicker({flag = prefix.."_dist_color2", color = tbl.DistanceColor2, callback = function(c) tbl.DistanceColor2 = c end})
    local distPop = dist:gear({title = "Distance Options"})
    distPop:dropdown({name = "Distance Position", items = {"Top", "Bottom", "Left", "Right"}, default = tbl.DistancePos, flag = prefix.."_distance_pos", callback = function(v) tbl.DistancePos = v end})
    distPop:slider({name = "Distance Slot", min = 1, max = 10, default = tbl.DistanceSlot or 4, interval = 1, flag = prefix.."_distance_slot", callback = function(v) tbl.DistanceSlot = v end})

    local tool = sec:toggle({name = "Tool", default = tbl.Tool, flag = prefix.."_tool", callback = function(v) tbl.Tool = v end})
    tool:colorpicker({flag = prefix.."_tool_color", color = tbl.ToolColor, callback = function(c) tbl.ToolColor = c end})
    tool:colorpicker({flag = prefix.."_tool_color2", color = tbl.ToolColor2, callback = function(c) tbl.ToolColor2 = c end})
    local toolPop = tool:gear({title = "Tool Options"})
    toolPop:dropdown({name = "Tool Position", items = {"Top", "Bottom", "Left", "Right"}, default = tbl.ToolPos, flag = prefix.."_tool_pos", callback = function(v) tbl.ToolPos = v end})
    toolPop:slider({name = "Tool Slot", min = 1, max = 10, default = tbl.ToolSlot or 5, interval = 1, flag = prefix.."_tool_slot", callback = function(v) tbl.ToolSlot = v end})

    local hp = sec:toggle({name = "Health Bar", default = tbl.HealthBar, flag = prefix.."_healthbar", callback = function(v) tbl.HealthBar = v end})
    hp:colorpicker({flag = prefix.."_health_high", color = tbl.HealthHigh, callback = function(c) tbl.HealthHigh = c end})
    hp:colorpicker({flag = prefix.."_health_mid", color = tbl.HealthMid, callback = function(c) tbl.HealthMid = c end})
    hp:colorpicker({flag = prefix.."_health_low", color = tbl.HealthLow, callback = function(c) tbl.HealthLow = c end})
    local hpPop = hp:gear({title = "Health Bar Options"})
    hpPop:toggle({name = "Health Text", default = tbl.HealthText, flag = prefix.."_healthtext", callback = function(v) tbl.HealthText = v end})
    hpPop:dropdown({name = "Health Bar Position", items = {"Top", "Bottom", "Left", "Right"}, default = tbl.HealthBarPos, flag = prefix.."_healthbar_pos", callback = function(v) tbl.HealthBarPos = v end})
    hpPop:slider({name = "Health Bar Slot", min = 1, max = 10, default = tbl.HealthBarSlot or 1, interval = 1, flag = prefix.."_healthbar_slot", callback = function(v) tbl.HealthBarSlot = v end})

    local armor = sec:toggle({name = "Armor Bar", default = tbl.ArmorBar, flag = prefix.."_armorbar", callback = function(v) tbl.ArmorBar = v end})
    armor:colorpicker({flag = prefix.."_armor_high", color = tbl.ArmorHigh, callback = function(c) tbl.ArmorHigh = c end})
    armor:colorpicker({flag = prefix.."_armor_mid", color = tbl.ArmorMid, callback = function(c) tbl.ArmorMid = c end})
    armor:colorpicker({flag = prefix.."_armor_low", color = tbl.ArmorLow, callback = function(c) tbl.ArmorLow = c end})
    local armorPop = armor:gear({title = "Armor Bar Options"})
    armorPop:dropdown({name = "Armor Bar Position", items = {"Top", "Bottom", "Left", "Right"}, default = tbl.ArmorBarPos, flag = prefix.."_armorbar_pos", callback = function(v) tbl.ArmorBarPos = v end})
    armorPop:slider({name = "Armor Bar Slot", min = 1, max = 10, default = tbl.ArmorBarSlot or 2, interval = 1, flag = prefix.."_armorbar_slot", callback = function(v) tbl.ArmorBarSlot = v end})

    local skel = sec:toggle({name = "Skeleton", default = tbl.Skeleton, flag = prefix.."_skeleton", callback = function(v) tbl.Skeleton = v end})
    skel:colorpicker({flag = prefix.."_skeleton_color", color = tbl.SkeletonColor, callback = function(c) tbl.SkeletonColor = c end})
    skel:colorpicker({flag = prefix.."_skeleton_color2", color = tbl.SkeletonColor2, callback = function(c) tbl.SkeletonColor2 = c end})
    local skelPop = skel:gear({title = "Skeleton Options"})
    skelPop:slider({name = "Skeleton Thickness", min = 1, max = 5, default = tbl.SkeletonThickness, interval = 1, flag = prefix.."_skeleton_thickness", callback = function(v) tbl.SkeletonThickness = v end})

    local head = sec:toggle({name = "Head Dot", default = tbl.HeadDot, flag = prefix.."_headdot", callback = function(v) tbl.HeadDot = v end})
    head:colorpicker({flag = prefix.."_headdot_color", color = tbl.HeadDotColor, callback = function(c) tbl.HeadDotColor = c end})
    local headPop = head:gear({title = "Head Dot Options"})
    headPop:slider({name = "Head Dot Size", min = 4, max = 40, default = tbl.HeadDotSize, interval = 1, flag = prefix.."_headdot_size", callback = function(v) tbl.HeadDotSize = v end})

    local tr = sec:toggle({name = "Tracers", default = tbl.Tracers, flag = prefix.."_tracers", callback = function(v) tbl.Tracers = v end})
    tr:colorpicker({flag = prefix.."_tracer_color", color = tbl.TracerColor, callback = function(c) tbl.TracerColor = c end})
    local trPop = tr:gear({title = "Tracer Options"})
    trPop:dropdown({name = "Tracer Origin", items = {"Bottom", "Top", "Center", "Mouse"}, default = tbl.TracerOrigin or "Bottom", flag = prefix.."_tracer_origin", callback = function(v) tbl.TracerOrigin = v end})
    trPop:slider({name = "Tracer Thickness", min = 1, max = 5, default = tbl.TracerThickness or 1, interval = 1, flag = prefix.."_tracer_thickness", callback = function(v) tbl.TracerThickness = v end})

    sec:slider({name = "Text Size", min = 8, max = 20, default = tbl.TextSize, interval = 1, flag = prefix.."_textsize", callback = function(v) tbl.TextSize = v end})
end

addESPSection(Enemy, ESP.Settings.Enemy, "enemy")
addESPSection(Team, ESP.Settings.Teammate, "team")

local FONT_LOOKUP = {}
local fontList = {}
local seen = {}

for i = 1, #FONT_LIST do
    local entry = FONT_LIST[i]
    FONT_LOOKUP[entry[1]] = entry
    fontList[#fontList + 1] = entry[1]
    seen[entry[1]] = true
end

for name in pairs(ESP.Fonts or {}) do
    if not seen[name] then
        fontList[#fontList + 1] = name
        seen[name] = true
    end
end

table.sort(fontList)

local function ensureFont(name)
    ESP.Fonts = ESP.Fonts or {}
    if ESP.Fonts[name] then
        return true
    end
    local entry = FONT_LOOKUP[name]
    if not entry then
        return false
    end
    local fileName, url = entry[2], entry[3]
    if isfolder and makefolder and not isfolder("StardustFonts") then
        makefolder("StardustFonts")
    end
    local path = "StardustFonts/" .. fileName
    if isfile and writefile and not isfile(path) then
        local ok, data = pcall(game.HttpGet, game, url)
        if ok and data and #data > 0 then
            writefile(path, data)
        end
    end
    if getcustomasset and isfile and isfile(path) then
        local asset = getcustomasset(path)
        local ok, customFont = pcall(Font.new, asset, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        if ok and customFont then
            ESP.Fonts[name] = customFont
            return true
        end
    end
    return false
end

ensureFont(ESP.Settings.TextFont or "Tahoma")
ensureFont(ESP.Settings.FlagsFont or "Tahoma")
ensureFont(ESP.Settings.HealthFont or "Tahoma")

Setting:dropdown({name = "Box Mode", items = {"Dynamic", "Static"}, default = ESP.Settings.BoxMode or "Dynamic", flag = "esp_box_mode", callback = function(v) ESP.Settings.BoxMode = v end})
Setting:slider({name = "Box Smoothing", min = 0, max = 0.9, default = ESP.Settings.BoxSmoothing or 0, interval = 0.05, flag = "esp_box_smoothing", callback = function(v) ESP.Settings.BoxSmoothing = v end})
Setting:slider({name = "Max Distance", min = 100, max = 3000, default = ESP.Settings.MaxDistance, interval = 50, flag = "esp_max_distance", callback = function(v) ESP.Settings.MaxDistance = v end})
Setting:dropdown({name = "Text Font", items = fontList, default = ESP.Settings.TextFont or "Tahoma", flag = "esp_text_font", callback = function(v) ensureFont(v) ESP.Settings.TextFont = v end})
Setting:dropdown({name = "Flags Font", items = fontList, default = ESP.Settings.FlagsFont or "Tahoma", flag = "esp_flags_font", callback = function(v) ensureFont(v) ESP.Settings.FlagsFont = v end})
Setting:dropdown({name = "Health Font", items = fontList, default = ESP.Settings.HealthFont or "Tahoma", flag = "esp_health_font", callback = function(v) ensureFont(v) ESP.Settings.HealthFont = v end})
Setting:dropdown({name = "Text Gradient", items = {"Static", "Animated"}, default = ESP.Settings.TextGradientAnimated and "Animated" or "Static", flag = "esp_text_gradient", callback = function(v) ESP.Settings.TextGradientAnimated = (v == "Animated") end})
Setting:slider({name = "Refresh Rate", min = 60, max = 240, default = ESP.Settings.RefreshRate, flag = "esp_refresh_rate", callback = function(v) ESP.Settings.RefreshRate = v end})

right:preview({ name = "Preview" })
win:configTab(config)

playersTab:open()
ESP:Start()
win:notify({ title = "Stardust", text = "Loaded successfully.", kind = "success" })

if typeof(setfpscap) == "function" then setfpscap(0) end

Stardust.win = win
Stardust.Library = Library
Stardust.ESP = ESP
Stardust.Theme = Theme
Stardust.tabs = {
    legit = legit, rage = Rage, players = playersTab, world = world, misc = misc, config = config,
}
Stardust.categories = {
    combat = combat, visuals = visuals, other = other, settings = Settings,
}

function Stardust.notify(...)
    return win:notify(...)
end

function Stardust.unload()
    win:unload()
end

if env then env.Stardust = Stardust end
