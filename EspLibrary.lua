print('-2')

local cloneref = cloneref or function(o) return o end

local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local HttpService = cloneref(game:GetService("HttpService"))
local LocalPlayer = Players.LocalPlayer

local rgb = Color3.fromRGB

local espModule = {}

local KEY_COLORS = {
    [0] = rgb(255, 0, 255),
    [1] = rgb(0, 255, 255),
    [2] = rgb(0, 0, 255),
}

local CHAMS_DESIGNS = {
    Borealis = {
        Style = 0, ColorCount = 3,
        Colors = {rgb(12, 120, 110), rgb(48, 220, 245), rgb(195, 85, 235)},
        Brightness = 1.1, Contrast = 1.1, Bloom = 0.4, BloomSpread = 3.0, Speed = 1.35, Scale = 3.0,
    },
    Inferno = {
        Style = 1, ColorCount = 3,
        Colors = {rgb(150, 15, 0), rgb(255, 110, 0), rgb(255, 225, 120)},
        Brightness = 1.15, Contrast = 1.05, Bloom = 0.5, BloomSpread = 3.5, Speed = 1.2, Scale = 2.5,
    },
    Plasma = {
        Style = 2, ColorCount = 3,
        Colors = {rgb(60, 20, 170), rgb(200, 40, 230), rgb(80, 200, 255)},
        Brightness = 1.1, Contrast = 1.1, Bloom = 0.4, BloomSpread = 3.0, Speed = 1.2, Scale = 3.0,
    },
    Hologram = {
        Style = 3, ColorCount = 3,
        Colors = {rgb(0, 70, 120), rgb(0, 200, 255), rgb(200, 245, 255)},
        Brightness = 1.1, Contrast = 1.0, Bloom = 0.55, BloomSpread = 3.0, Speed = 1.0, Scale = 3.0,
    },
    Galaxy = {
        Style = 4, ColorCount = 3,
        Colors = {rgb(25, 15, 80), rgb(110, 40, 170), rgb(240, 120, 220)},
        Brightness = 1.15, Contrast = 1.1, Bloom = 0.4, BloomSpread = 3.0, Speed = 0.8, Scale = 2.2,
    },
}

local CHAMS_DESIGN_NAMES = {"Borealis", "Inferno", "Plasma", "Hologram", "Galaxy"}

local function chamsFromDesign(name, into)
    local d = CHAMS_DESIGNS[name] or CHAMS_DESIGNS.Borealis
    into = into or {}
    into.Design = CHAMS_DESIGNS[name] and name or "Borealis"
    into.ColorCount = d.ColorCount
    into.Color1, into.Color2, into.Color3 = d.Colors[1], d.Colors[2], d.Colors[3]
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
        Chams = false, ChamsKey = p.key, ChamsSettings = chamsFromDesign(p.design),
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
        Skeleton = false, SkeletonThickness = 1, SkeletonColor = p.main, SkeletonColor2 = p.skel2,
        Tracers = false, TracerThickness = 1, TracerOrigin = "Bottom", TracerColor = p.main,
        TextSize = 12,
    }
end

espModule.Settings = {
    RefreshRate = 144,
    MaxDistance = 1200,
    BoxMode = "Dynamic",
    BoxSmoothing = 0,
    TextFont = "Gojiberry Quibble",
    FlagsFont = "Gojiberry Quibble",
    HealthFont = "Gojiberry Quibble",
    TextGradientAnimated = true,
    Enemy = entitySettings({
        key = 0, design = "Borealis",
        main = rgb(255, 80, 80), fill1 = rgb(255, 80, 80), fill2 = rgb(255, 40, 40), skel2 = rgb(200, 200, 200),
        text1 = rgb(255, 255, 255), text2 = rgb(200, 200, 200),
        health = {rgb(0, 255, 100), rgb(255, 255, 0), rgb(255, 40, 40)},
    }),
    Teammate = entitySettings({
        key = 1, design = "Hologram",
        main = rgb(0, 180, 255), fill1 = rgb(0, 180, 255), fill2 = rgb(0, 100, 200), skel2 = rgb(100, 150, 200),
        text1 = rgb(180, 230, 255), text2 = rgb(100, 150, 200),
        health = {rgb(0, 200, 255), rgb(100, 200, 255), rgb(30, 80, 140)},
    }),
    AI = entitySettings({
        key = 2, design = "Inferno",
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

function espModule.GetChamsDesignNames()
    return CHAMS_DESIGN_NAMES
end

function espModule.GetChamsPresetNames()
    return CHAMS_DESIGN_NAMES
end

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

espModule.IsTeam = function(plr)
    if not plr or plr == LocalPlayer then return false end
    if game.PlaceId == 72920620366355 then
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
            if game.PlaceId == 72920620366355 then
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
    t = math.clamp(t, 0, 1)
    if t >= 0.5 then return mid:Lerp(high, (t - 0.5) * 2) end
    return low:Lerp(mid, t * 2)
end

function espModule.Layout(cfg, x, y, w, h, o)
    local size = o.size or 12
    local step = size + 1
    local ratio = o.ratio or 1
    local out = { flagLines = {} }
    local off = { Top = 0, Bottom = 0, Left = 0, Right = 0 }
    local rows = { Left = 0, Right = 0 }

	local SIDE_OK = {
	    Top = true,
	    Bottom = true,
	    Left = true,
	    Right = true,
	}
	
	local function pick(v, d)
	    if SIDE_OK[v] then return v end
	    return d
	end

    local function placeBar(key, side)
        local rx, ry, rw, rh, vertical
        if side == "Left" then
            rx, ry, rw, rh, vertical = x - 4 - off.Left, y, 1, h, true
        elseif side == "Right" then
            rx, ry, rw, rh, vertical = x + w + 3 + off.Right, y, 1, h, true
        elseif side == "Top" then
            rx, ry, rw, rh, vertical = x, y - 4 - off.Top, w, 1, false
        else
            rx, ry, rw, rh, vertical = x, y + h + 3 + off.Bottom, w, 1, false
        end
        out[key] = { x = rx, y = ry, w = rw, h = rh, vertical = vertical, side = side }
        off[side] += 4
        return rx, ry
    end

    local function placeText(side)
        local p
        if side == "Top" then
            p = { x = x + w * 0.5, y = y - 3 - off.Top, ax = 0.5, ay = 1 }
            off.Top += step
        elseif side == "Bottom" then
            p = { x = x + w * 0.5, y = y + h + 3 + off.Bottom, ax = 0.5, ay = 0 }
            off.Bottom += step
        elseif side == "Left" then
            p = { x = x - 4 - off.Left, y = y - 1 + rows.Left * step, ax = 1, ay = 0 }
            rows.Left += 1
        else
            p = { x = x + w + 4 + off.Right, y = y - 1 + rows.Right * step, ax = 0, ay = 0 }
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
                off.Left += 16
            elseif side == "Right" then
                out.healthText = { x = rx + 4, y = ty, ax = 0, ay = 0 }
                off.Right += 16
            elseif side == "Top" then
                out.healthText = { x = tx, y = ry - 2, ax = 0.5, ay = 1 }
                off.Top += size + 2
            else
                out.healthText = { x = tx, y = ry + 4, ax = 0.5, ay = 0 }
                off.Bottom += size + 2
            end
        end
    end

    local items = {}
    local function add(key, kind, enabled, side, slot, n)
        if enabled then
            items[#items + 1] = { key = key, kind = kind, side = side, slot = slot, n = n }
        end
    end
    add("health", "healthbar", o.health, pick(cfg.HealthBarPos, "Left"), cfg.HealthBarSlot or 1, 1)
    add("armor", "bar", o.armor, pick(cfg.ArmorBarPos, "Bottom"), cfg.ArmorBarSlot or 2, 2)
    add("name", "text", cfg.Names, pick(cfg.NamePos, "Top"), cfg.NameSlot or 3, 3)
    add("distance", "text", cfg.Distance, pick(cfg.DistancePos, "Right"), cfg.DistanceSlot or 4, 4)
    add("tool", "text", cfg.Tool, pick(cfg.ToolPos, "Bottom"), cfg.ToolSlot or 5, 5)

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

    local fc = o.flagCount or 0
    if cfg.Flags and fc > 0 then
        local side = pick(cfg.FlagsPos, "Right")
        for i = 1, fc do out.flagLines[i] = placeText(side) end
    end

    return out
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

float fbm(float2 p) {
	float v = 0.0;
	float amp = 0.52;
	float2 shift = float2(37.0, 17.0);
	float2x2 rot = float2x2(0.8775, 0.4794, -0.4794, 0.8775);
	for (int i = 0; i < 4; i++) {
		v += amp * noise2D(p);
		p = mul(rot, p) * 2.05 + shift;
		amp *= 0.5;
	}
	return v;
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
	if (k == 2) {
		float s2 = (c.b - max(c.r, c.g)) / max(c.b, 0.0001);
		float l2 = smoothstep(0.35, 0.6, c.b);
		return smoothstep(0.6, 0.85, s2) * l2;
	}
	float lo = c.g;
	float a = c.r;
	float b = c.b;
	if (k == 1) {
		lo = c.r;
		a = c.g;
	}
	float mx = max(a, b);
	float mn = min(a, b);
	float inv = 1.0 / max(mx, 0.0001);
	float s = (mn - lo) * inv;
	float bal = 1.0 - smoothstep(0.25, 0.5, abs(a - b) * inv);
	float lum = smoothstep(0.25, 0.5, mn);
	return smoothstep(0.45, 0.7, s) * bal * lum;
}

float fringeAmount(float3 c, int k) {
	if (k == 2) {
		float s2 = (c.b - max(c.r, c.g)) / max(c.b, 0.0001);
		float l2 = smoothstep(0.1, 0.3, c.b);
		return smoothstep(0.3, 0.6, s2) * l2;
	}
	float lo = c.g;
	float a = c.r;
	float b = c.b;
	if (k == 1) {
		lo = c.r;
		a = c.g;
	}
	float mx = max(a, b);
	float mn = min(a, b);
	float inv = 1.0 / max(mx, 0.0001);
	float s = (mn - lo) * inv;
	float bal = 1.0 - smoothstep(0.4, 0.8, abs(a - b) * inv);
	float lum = smoothstep(0.08, 0.25, mn);
	return smoothstep(0.1, 0.35, s) * bal * lum;
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

float patAurora(float2 p, float t, out float extra) {
	float w1 = fbm(p * 0.75 + float2(t * 0.28, -t * 0.14));
	float w2 = fbm(p * 1.45 + float2(-t * 0.22, t * 0.19) + w1 * 1.1);

	float coord = p.x * 1.35 + p.y * 0.85 + w1 * 2.35 + sin(p.y * 2.4 - t * 0.9) * 0.35;
	float curtain1 = pow(clamp(1.0 - abs(sin(coord * 3.14159)), 0.0, 1.0), 2.4);
	float curtain2 = pow(clamp(1.0 - abs(sin((coord * 1.85 - w2 * 1.6 + t * 0.35) * 3.14159)), 0.0, 1.0), 3.0);

	float rays = 0.65 + 0.35 * sin((p.x * 9.0 + w2 * 5.5 - t * 1.4) * 3.14159);
	float shimmer = curtain1 * rays;
	float band = clamp(curtain1 * 0.65 + curtain2 * 0.55 + w2 * 0.35, 0.0, 1.0);

	extra = smoothstep(0.72, 1.0, shimmer * curtain2) * 0.35;
	return saturate(shimmer * 0.5 + band * 0.6);
}

float patFlame(float2 p, float t, out float extra) {
	float n = fbm(float2(p.x * 1.2, p.y * 1.6 - t * 1.1));
	float n2 = fbm(p * 2.0 + float2(0.0, -t * 1.8) + n);
	float heat = saturate(n * 0.7 + n2 * 0.55 + sin(p.y * 1.5 - t * 1.5) * 0.2);
	extra = smoothstep(0.85, 1.0, heat) * 0.3;
	return heat;
}

float patPlasma(float2 p, float t, out float extra) {
	float2 q = p + float2(fbm(p + t * 0.2), fbm(p - t * 0.25)) * 1.2;
	float v = sin(q.x * 1.7 + t) + sin(q.y * 2.1 - t * 1.2) + sin((q.x + q.y) * 1.3 + t * 0.7);
	v += sin(length(q + float2(sin(t * 0.5), cos(t * 0.4)) * 2.0) * 2.5);
	extra = 0.0;
	return v * 0.125 + 0.5;
}

float patHologram(float2 uv, float2 p, float t, out float extra) {
	float scan = 0.5 + 0.5 * sin(uv.y * resolution.y * 0.6 - t * 8.0);
	float w = fbm(p * 1.1 + float2(0.0, -t * 0.4));
	float x = saturate(0.3 + 0.25 * sin(p.y * 3.0 - t * 2.0) + w * 0.4 + scan * 0.15);
	float flicker = 0.92 + 0.08 * sin(t * 30.0);
	float grid = saturate(step(0.94, frac(p.x * 4.0)) + step(0.94, frac(p.y * 4.0)));
	extra = (smoothstep(0.92, 1.0, scan) * 0.3 + grid * 0.2) * flicker;
	return x * flicker;
}

float patGalaxy(float2 p, float t, out float extra) {
	float a = fbm(p * 0.8 + t * 0.05);
	float b = fbm(p * 1.6 - t * 0.08 + a);
	float s = hash21(floor(p * 18.0));
	extra = step(0.985, s) * (0.6 + 0.4 * sin(t * 3.0 + s * 50.0));
	return saturate(a * 0.6 + b * 0.6 - 0.1);
}

float3 evalPattern(float2 uv, Grp g) {
	float t = time * g.sp;
	float aspect = resolution.x / max(resolution.y, 1.0);
	float2 p = uv * float2(aspect, 1.0) * g.sc;
	int st = (int)(g.st + 0.5);
	float extra = 0.0;
	float v;
	if (st == 1) {
		v = patFlame(p, t, extra);
	} else if (st == 2) {
		v = patPlasma(p, t, extra);
	} else if (st == 3) {
		v = patHologram(uv, p, t, extra);
	} else if (st == 4) {
		v = patGalaxy(p, t, extra);
	} else {
		v = patAurora(p, t, extra);
	}
	float3 col = palette(v, g) + glowCol(g) * extra;
	return pow(max(col, 0.0), g.ct) * g.br;
}

float4 main(float4 pos : SV_Position, float2 uv : TEXCOORD0) : SV_TARGET {
	float3 src = Scene.Sample(Linear, uv).rgb;
	float3 outc = src;

	for (int k = 0; k < 3; k++) {
		Grp g = getGrp(k);
		if (g.en > 0.5) {
			float mk = keyAmount(src, k);
			float bl = 0.0;
			if (g.gi > 0.001 && g.gs > 0.01) {
				float2 texel = g.gs / max(resolution, float2(1.0, 1.0));
				for (int i = 0; i < 10; i++) {
					float ang = (float(i) / 10.0) * 6.2831853;
					float2 dir = float2(cos(ang), sin(ang));
					bl += keyAmount(Scene.SampleLevel(Linear, uv + dir * texel, 0).rgb, k);
				}
				bl /= 10.0;
			}
			float fr = fringeAmount(src, k) * saturate(bl * 4.0);
			float rem = saturate(max(mk, fr));
			outc = cleanKey(outc, k, rem);
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

local function addStroke(parent, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.new(0, 0, 0)
    stroke.Thickness = thickness or 1
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
    label.TextStrokeTransparency = 1
    label.ZIndex = 5
    label.Visible = false
    label.Parent = root
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.new(0, 0, 0)
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    stroke.Parent = label
    local gradient = Instance.new("UIGradient")
    gradient.Parent = label
    return { root = label, grad = gradient, stroke = stroke }
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

    local self = setmetatable({
        root = root, rects = {}, lines = {}, keyed = {}, keyList = {},
        nRect = 0, nLine = 0, hiRect = 0, hiLine = 0, frame = 0,
        cornerBox = Instance.new("Frame"),
        fullBox = Instance.new("Frame"),
        cornerBars = {},
        fullBars = {}
    }, Renderer)

    local BLACK = Color3.new(0,0,0)
    local WHITE = Color3.new(1,1,1)

    local function createBar(parent, size, pos, anchor, color, radius, zIndex)
        local bar = Instance.new("Frame")
        bar.Size = size
        bar.Position = pos
        bar.AnchorPoint = anchor
        bar.BackgroundColor3 = color
        bar.BorderSizePixel = 0
        bar.ZIndex = zIndex
        bar.Parent = parent
        local corner = Instance.new("UICorner")
        corner.CornerRadius = radius
        corner.Parent = bar
        return bar
    end

    self.cornerBox.Name = "CornerBox"
    self.cornerBox.BackgroundTransparency = 1
    self.cornerBox.Visible = false
    self.cornerBox.ZIndex = 2
    self.cornerBox.Parent = root

    for _, signs in ipairs({ {0,0}, {1,0}, {0,1}, {1,1} }) do
        local xSign, ySign = signs[1], signs[2]
        local anchor = Vector2.new(xSign, ySign)
        local pos = UDim2.fromScale(xSign, ySign)
        local one = UDim2.fromOffset(1, 1)
        table.insert(self.cornerBars, {
            outlineH = createBar(self.cornerBox, one, pos, anchor, BLACK, UDim.new(0, 3), 1),
            outlineV = createBar(self.cornerBox, one, pos, anchor, BLACK, UDim.new(0, 3), 1),
            colorH = createBar(self.cornerBox, one, pos, anchor, WHITE, UDim.new(0, 3), 2),
            colorV = createBar(self.cornerBox, one, pos, anchor, WHITE, UDim.new(0, 3), 2),
            xSign = xSign, ySign = ySign,
        })
    end

    self.fullBox.Name = "FullBox"
    self.fullBox.BackgroundTransparency = 1
    self.fullBox.Visible = false
    self.fullBox.ZIndex = 2
    self.fullBox.Parent = root

    local function createFullSide(isHorizontal, isStart)
        local one = UDim2.fromOffset(1, 1)
        local zero = UDim2.fromScale(0, 0)
        table.insert(self.fullBars, {
            outline = createBar(self.fullBox, one, zero, Vector2.new(0, 0), BLACK, UDim.new(0, 3), 1),
            color = createBar(self.fullBox, one, zero, Vector2.new(0, 0), WHITE, UDim.new(0, 3), 2),
            isHorizontal = isHorizontal, isStart = isStart,
        })
    end
    createFullSide(true, true)
    createFullSide(true, false)
    createFullSide(false, true)
    createFullSide(false, false)

    return self
end

function Renderer:Begin()
    self.frame += 1
    self.nRect, self.nLine = 0, 0
    self.cornerBox.Visible = false
    self.fullBox.Visible = false
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
    if l.c1 ~= c1 or l.c2 ~= c2 then
        l.c1, l.c2 = c1, c2
        if c1 == c2 then
            f.BackgroundColor3 = c1
            l.g.Enabled = false
        else
            f.BackgroundColor3 = Color3.new(1, 1, 1)
            l.g.Color = ColorSequence.new(c1, c2)
            l.g.Enabled = true
        end
    end
    if l.tr ~= tr then
        l.tr = tr
        f.BackgroundTransparency = tr
        l.s.Transparency = tr
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
        t.x, t.y, t.ax, t.ay = x, y, ax, ay
        label.AnchorPoint = Vector2.new(ax, ay)
        label.Position = UDim2.fromOffset(x, y)
        label.TextXAlignment = textX[ax] or Enum.TextXAlignment.Center
        label.TextYAlignment = textY[ay] or Enum.TextYAlignment.Center
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
            label.TextColor3 = Color3.new(1, 1, 1)
            t.grad.Color = ColorSequence.new(c1, c2)
            t.grad.Enabled = true
        end
    end
    if animated and t.grad.Enabled then
        t.grad.Rotation = view.angle
    elseif t.grad.Enabled then
        t.grad.Rotation = 0
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
        root.Position = UDim2.fromOffset(x, y)
    end
    if b.w ~= w or b.h ~= h then
        b.w, b.h = w, h
        root.Size = UDim2.fromOffset(w, h)
    end
    fillRatio = math.clamp(fillRatio, 0, 1)
    if vertical then
        fill.AnchorPoint = Vector2.new(0, 1)
        fill.Position = UDim2.fromScale(0, 1)
        fill.Size = UDim2.fromScale(1, fillRatio)
        b.grad.Rotation = 90
    else
        fill.AnchorPoint = Vector2.new(0, 0)
        fill.Position = UDim2.new()
        fill.Size = UDim2.fromScale(fillRatio, 1)
        b.grad.Rotation = 0
    end
    b.grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, high),
        ColorSequenceKeypoint.new(0.5, mid),
        ColorSequenceKeypoint.new(1, low),
    })
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
        root.Position = UDim2.fromOffset(x, y)
    end
    if f.w ~= w or f.h ~= h then
        f.w, f.h = w, h
        root.Size = UDim2.fromOffset(w, h)
    end
    f.grad.Color = ColorSequence.new(c1, c2)
    f.grad.Rotation = rot or 0
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
        root.Position = UDim2.fromOffset(x - 21, y - 21)
    end
    if g.w ~= w or g.h ~= h then
        g.w, g.h = w, h
        root.Size = UDim2.fromOffset(w + 42, h + 41)
    end
    root.ImageColor3 = color
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
        root.Position = UDim2.fromOffset(x, y)
    end
    if d.size ~= size then
        d.size = size
        root.Size = UDim2.fromOffset(size, size)
    end
    root.BackgroundColor3 = color
    if outlineTh and outlineTh > 0 then
        d.stroke.Enabled = true
        d.stroke.Thickness = outlineTh
        d.stroke.Transparency = tr
    else
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
        if sh then pcall(function() sh:Set(name, v) end) end
    end
end

local function pushShader()
    if not state.shader then return end
    local s = espModule.Settings
    for k = 0, 2 do
        local g = (k == 0 and s.Enemy) or (k == 1 and s.Teammate) or s.AI
        local c = g.ChamsSettings
        local design = CHAMS_DESIGNS[c.Design] or CHAMS_DESIGNS.Borealis
        local n = PN[k]
        put(n.c1, c.Color1)
        put(n.c2, c.Color2)
        put(n.c3, c.Color3)
        put(n.cc, math.clamp(math.floor((c.ColorCount or 3) + 0.5), 1, 3))
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

local function ensureShader()
    if state.shader then return end
    if typeof(Drawing) ~= "table" and typeof(Drawing) ~= "userdata" then return end
    local ok, shader = pcall(function()
        return Drawing.new("Shader")
    end)
    if not ok or not shader then return end
    local built = pcall(function()
        shader.Vertex = SHADER_VERTEX
        shader.Pixel = SHADER_PIXEL
        shader:Create()
    end)
    if not built then
        pcall(function() shader:Remove() end)
        return
    end
    state.shader = shader
    state.shaderParams = {}
    pushShader()
end

local function destroyShader()
    if state.shader then
        pcall(function() state.shader:Remove() end)
        state.shader = nil
        state.shaderParams = {}
    end
end

local function hideRecord(rec)
    if rec.hidden then return end
    rec.hidden = true
    if rec.renderer then rec.renderer:Clear() end
    if rec.hl then
        rec.hl.Enabled = false
    end
    if rec.fillHl then
        rec.fillHl.Enabled = false
    end
end

local function dropRecord(entity)
    local rec = state.records[entity]
    if not rec then return end
    if rec.renderer then rec.renderer:Destroy() end
    if rec.hl then rec.hl:Destroy() end
    if rec.fillHl then rec.fillHl:Destroy() end
    state.records[entity] = nil
end

local function newRecord(entity)
    local renderer = Renderer.new(state.gui)
    return {
        entity = entity,
        renderer = renderer,
        character = nil,
        humanoid = nil,
        root = nil,
        parts = nil,
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
        d = {},
        box = { x = 0, y = 0, w = 0, h = 0 },
        hl = nil,
        fillHl = nil,
    }
end

local R15 = {"HumanoidRootPart","Head","UpperTorso","LowerTorso","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot","LeftUpperArm","LeftLowerArm","LeftHand","RightUpperArm","RightLowerArm","RightHand"}
local R6 = {"HumanoidRootPart","Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg"}
local VM_PARTS = {"head","torso","arm1","arm2","leg1","leg2","shoulder1","shoulder2","hip1","hip2"}

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

local function bindCharacter(rec, character, humanoid, isVM)
    rec.character = character
    rec.humanoid = humanoid
    rec.parts = {}
    rec.isR15 = false
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
    d.flags = d.flags or {}
    table.clear(d.flags)
    if not cfg.Flags then return end
    if humanoid then
        if table.find(cfg.SelectedFlags, "Walking") and humanoid.MoveDirection.Magnitude > 0 then
            d.flags[#d.flags + 1] = "Walking"
        end
        local ok, hs = pcall(function() return humanoid:GetState() end)
        if ok then
            if table.find(cfg.SelectedFlags, "Jumping") and (hs == Enum.HumanoidStateType.Freefall or hs == Enum.HumanoidStateType.Jumping) then
                d.flags[#d.flags + 1] = "Jumping"
            end
            if table.find(cfg.SelectedFlags, "Swimming") and hs == Enum.HumanoidStateType.Swimming then
                d.flags[#d.flags + 1] = "Swimming"
            end
        end
    end
    for name, custom in pairs(espModule.CustomFlags) do
        if table.find(cfg.SelectedFlags, name) then
            local ok, res = pcall(custom.Func, entity, character, humanoid)
            if ok and res then d.flags[#d.flags + 1] = name end
        end
    end
end

local SIGNS = {
    {-1, -1, -1}, {1, -1, -1}, {-1, 1, -1}, {1, 1, -1},
    {-1, -1, 1}, {1, -1, 1}, {-1, 1, 1}, {1, 1, 1},
}

local function dynamicBounds(parts)
    local sx1, sy1, sx2, sy2 = math.huge, math.huge, -math.huge, -math.huge
    local any = false
    for i = 1, #parts do
        local p = parts[i]
        if p and p.Parent then
            local cf, size = p.CFrame, p.Size
            local hx, hy, hz = size.X * 0.5, size.Y * 0.5, size.Z * 0.5
            for s = 1, 8 do
                local sg = SIGNS[s]
                local w = cf * Vector3.new(hx * sg[1], hy * sg[2], hz * sg[3])
                local sx, sy = project(w.X, w.Y, w.Z)
                if sx then
                    any = true
                    if sx < sx1 then sx1 = sx end
                    if sy < sy1 then sy1 = sy end
                    if sx > sx2 then sx2 = sx end
                    if sy > sy2 then sy2 = sy end
                end
            end
        end
    end
    if not any then return nil end
    return sx1, sy1, sx2, sy2
end

local function staticBounds(rec, parts)
    local root = rec.root
    if not root or not root.Parent then return nil end
    local minY, maxY = math.huge, -math.huge
    for i = 1, #parts do
        local p = parts[i]
        if p and p.Parent then
            local cf, size = p.CFrame, p.Size
            local ext = math.abs(cf.RightVector.Y) * size.X * 0.5
                + math.abs(cf.UpVector.Y) * size.Y * 0.5
                + math.abs(cf.LookVector.Y) * size.Z * 0.5
            local py = cf.Position.Y
            if py - ext < minY then minY = py - ext end
            if py + ext > maxY then maxY = py + ext end
        end
    end
    if minY == math.huge then return nil end
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

local function box3D(rec)
    local character = rec.character
    if not character then return nil end
    local ok, cf, size = pcall(function() return character:GetBoundingBox() end)
    if not ok or not cf then return nil end
    local hx, hy, hz = size.X * 0.5, size.Y * 0.5, size.Z * 0.5
    local pts = {}
    for s = 1, 8 do
        local sg = SIGNS[s]
        local w = cf * Vector3.new(hx * sg[1], hy * sg[2], hz * sg[3])
        local sx, sy = project(w.X, w.Y, w.Z)
        if sx then
            pts[s] = {sx, sy, true}
        else
            pts[s] = {0, 0, false}
        end
    end
    return pts
end

local function render(rec, cfg, rx, ry, rz, dist)
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
    local x = math.floor(sx1 - pad + 0.5)
    local y = math.floor(sy1 - pad + 0.5)
    local w = math.max(math.floor(sx2 - sx1 + pad * 2 + 0.5), 8)
    local h = math.max(math.floor(sy2 - sy1 + pad * 2 + 0.5), 8)

    local box = rec.box
    local smooth = settings.BoxSmoothing or 0
    if box.w == 0 or smooth <= 0 or rec.hidden then
        box.x, box.y, box.w, box.h = x, y, w, h
    else
        local k = 1 - math.clamp(smooth, 0, 0.95)
        box.x = box.x + (x - box.x) * k
        box.y = box.y + (y - box.y) * k
        box.w = box.w + (w - box.w) * k
        box.h = box.h + (h - box.h) * k
    end
    x, y, w, h = math.floor(box.x + 0.5), math.floor(box.y + 0.5), math.floor(box.w + 0.5), math.floor(box.h + 0.5)

    rec.hidden = false
    rec.seen = view.time
    local tr = 1 - view.fade
    if rec.deathTime > 0 then
        local age = view.time - rec.deathTime
        if age > 1.2 then
            hideRecord(rec)
            return
        end
        tr = math.min(tr, age / 1.2)
    end
    local renderer = rec.renderer
    renderer:Begin()

    local textFont = getFont(settings.TextFont)
    local flagsFont = getFont(settings.FlagsFont)
    local healthFont = getFont(settings.HealthFont)
    local meters = math.floor(dist / 2.81 + 0.5)
    local d = rec.d
    local chamsOn = cfg.Chams and state.shader ~= nil

    if cfg.BoxFill and cfg.BoxEnabled then
        if cfg.BoxType == "3D" then
            if chamsOn then
                if rec.fillHl then rec.fillHl.Enabled = false end
            else
                if not rec.fillHl then
                    local hl = Instance.new("Highlight")
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = state.gui
                    rec.fillHl = hl
                end
                rec.fillHl.Adornee = rec.character
                rec.fillHl.FillColor = cfg.BoxFillColor1
                rec.fillHl.OutlineColor = cfg.LineColor
                rec.fillHl.FillTransparency = 1 - ((1 - cfg.BoxFillTransparency) * (1 - tr))
                rec.fillHl.OutlineTransparency = 1
                rec.fillHl.Enabled = true
            end
        else
            if rec.fillHl then rec.fillHl.Enabled = false end
            local ang = cfg.BoxFillRotation or 0
            if cfg.BoxFillSpeed and cfg.BoxFillSpeed ~= 0 then
                ang = (view.angle * (cfg.BoxFillSpeed / 100) + ang) % 360
            end
            renderer:Fill("boxfill", x, y, w, h, cfg.BoxFillColor1, cfg.BoxFillColor2, ang, 1 - ((1 - cfg.BoxFillTransparency) * (1 - tr)))
        end
    else
        if rec.fillHl then rec.fillHl.Enabled = false end
    end

    if chamsOn then
        local keyCol = KEY_COLORS[cfg.ChamsKey or 0]
        if not rec.hl then
            local hl = Instance.new("Highlight")
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.FillColor = keyCol
            hl.FillTransparency = 0
            hl.OutlineColor = keyCol
            hl.OutlineTransparency = 1
            hl.Parent = state.gui
            rec.hl = hl
        end
        if rec.hl.FillColor ~= keyCol then
            rec.hl.FillColor = keyCol
            rec.hl.OutlineColor = keyCol
        end
        if rec.hl.Adornee ~= rec.character then
            rec.hl.Adornee = rec.character
        end
        rec.hl.Enabled = true
    else
        if rec.hl then rec.hl.Enabled = false end
    end

    if cfg.BoxEnabled then
        if cfg.BoxGlow then
            renderer:Glow("boxglow", x, y, w, h, cfg.LineColor, 1 - (0.65 * (1 - tr)))
        end

        local thick = math.max(1, cfg.Thickness or 1)
        if cfg.BoxType == "Full" then
            renderer.fullBox.Visible = true
            renderer.fullBox.Position = UDim2.fromOffset(x, y)
            renderer.fullBox.Size = UDim2.fromOffset(w, h)
            for _, b in ipairs(renderer.fullBars) do
                if b.isHorizontal then
                    b.color.Size = UDim2.fromOffset(w, thick)
                    b.color.Position = UDim2.fromOffset(0, b.isStart and 0 or (h - thick))
                    b.outline.Size = UDim2.fromOffset(w + 2, thick + 2)
                    b.outline.Position = UDim2.fromOffset(-1, b.isStart and -1 or (h - thick - 1))
                else
                    b.color.Size = UDim2.fromOffset(thick, h)
                    b.color.Position = UDim2.fromOffset(b.isStart and 0 or (w - thick), 0)
                    b.outline.Size = UDim2.fromOffset(thick + 2, h + 2)
                    b.outline.Position = UDim2.fromOffset(b.isStart and -1 or (w - thick - 1), -1)
                end
                b.color.BackgroundColor3 = cfg.LineColor
                b.color.BackgroundTransparency = tr
                b.outline.BackgroundTransparency = tr
            end
        elseif cfg.BoxType == "3D" then
            local pts = box3D(rec)
            if pts then
                local edges = {{1,2},{2,4},{4,3},{3,1},{5,6},{6,8},{8,7},{7,5},{1,5},{2,6},{3,7},{4,8}}
                for i = 1, 12 do
                    local e = edges[i]
                    local a, b2 = pts[e[1]], pts[e[2]]
                    if a and b2 and a[3] and b2[3] then
                        renderer:Line(a[1], a[2], b2[1], b2[2], thick, cfg.LineColor, cfg.LineColor, tr)
                    end
                end
            end
        else
            renderer.cornerBox.Visible = true
            renderer.cornerBox.Position = UDim2.fromOffset(x, y)
            renderer.cornerBox.Size = UDim2.fromOffset(w, h)
            local maxAllowed = math.min(50, math.floor(math.min(w, h) * 0.42))
            local lineLen = math.clamp(math.floor(math.min(w, h) * 0.3), 4, math.max(4, maxAllowed))

            for _, c in ipairs(renderer.cornerBars) do
                local sx, sy = c.xSign, c.ySign
                local ox = sx == 0 and -1 or 1
                local oy = sy == 0 and -1 or 1

                c.colorH.Size = UDim2.fromOffset(lineLen, thick)
                c.colorH.Position = UDim2.fromScale(sx, sy)
                c.colorH.BackgroundColor3 = cfg.LineColor
                c.colorH.BackgroundTransparency = tr

                c.outlineH.Size = UDim2.fromOffset(lineLen + 2, thick + 2)
                c.outlineH.Position = UDim2.fromScale(sx, sy) + UDim2.fromOffset(ox, oy)
                c.outlineH.BackgroundTransparency = tr

                c.colorV.Size = UDim2.fromOffset(thick, lineLen)
                c.colorV.Position = UDim2.fromScale(sx, sy)
                c.colorV.BackgroundColor3 = cfg.LineColor
                c.colorV.BackgroundTransparency = tr

                c.outlineV.Size = UDim2.fromOffset(thick + 2, lineLen + 2)
                c.outlineV.Position = UDim2.fromScale(sx, sy) + UDim2.fromOffset(ox, oy)
                c.outlineV.BackgroundTransparency = tr
            end
        end
    end

    if cfg.HeadDot then
        local head = rec.character and (rec.character:FindFirstChild("Head") or rec.character:FindFirstChild("head"))
        if head then
            local hp = head:IsA("BasePart") and head.Position or (head:FindFirstChildWhichIsA("BasePart", true) and head:FindFirstChildWhichIsA("BasePart", true).Position)
            if hp then
                local hx, hy = project(hp.X, hp.Y, hp.Z)
                if hx then
                    renderer:Dot("headdot", hx, hy, cfg.HeadDotSize, cfg.HeadDotColor, cfg.HeadDotOutlineThickness, tr)
                end
            end
        end
    end

    local lay = espModule.Layout(cfg, x, y, w, h, {
        size = cfg.TextSize,
        flagCount = (cfg.Flags and d.flags) and #d.flags or 0,
        health = cfg.HealthBar and d.health ~= nil,
        armor = cfg.ArmorBar and d.armor ~= nil,
        ratio = d.health or 1,
    })

    if lay.health then
        local r = lay.health
        renderer:Bar("health", r.x, r.y, r.w, r.h, d.health, r.vertical, cfg.HealthHigh, cfg.HealthMid, cfg.HealthLow, tr)
        if lay.healthText then
            local p = lay.healthText
            local hCol = espModule.HealthColor(d.health, cfg.HealthHigh, cfg.HealthMid, cfg.HealthLow)
            renderer:Text("hp", tostring(d.healthValue or 0), p.x, p.y, p.ax, p.ay, healthFont, cfg.TextSize, hCol, hCol, tr, false)
        end
    end

    if lay.armor then
        local r = lay.armor
        local armRatio = math.clamp(d.armor / 100, 0, 1)
        renderer:Bar("armor", r.x, r.y, r.w, r.h, armRatio, r.vertical, cfg.ArmorHigh, cfg.ArmorMid, cfg.ArmorLow, tr)
    end

    if lay.name and d.name then
        local p = lay.name
        renderer:Text("name", d.name, p.x, p.y, p.ax, p.ay, textFont, cfg.TextSize, cfg.NameColor, cfg.NameColor2, tr, settings.TextGradientAnimated)
    end

    if lay.distance then
        local p = lay.distance
        renderer:Text("dist", "[" .. meters .. "m]", p.x, p.y, p.ax, p.ay, flagsFont, cfg.TextSize, cfg.DistanceColor, cfg.DistanceColor2, tr, settings.TextGradientAnimated)
    end

    if lay.tool and d.tool then
        local p = lay.tool
        renderer:Text("tool", d.tool, p.x, p.y, p.ax, p.ay, textFont, cfg.TextSize, cfg.ToolColor, cfg.ToolColor2, tr, settings.TextGradientAnimated)
    end

    for i = 1, #lay.flagLines do
        local p = lay.flagLines[i]
        renderer:Text("flag" .. i, d.flags[i], p.x, p.y, p.ax, p.ay, flagsFont, cfg.TextSize, cfg.FlagColor1, cfg.FlagColor2, tr, settings.TextGradientAnimated)
    end

    if cfg.Tracers then
        local fromX, fromY
        if cfg.TracerOrigin == "Bottom" then
            fromX, fromY = view.w * 0.5, view.h
        elseif cfg.TracerOrigin == "Top" then
            fromX, fromY = view.w * 0.5, 0
        elseif cfg.TracerOrigin == "Mouse" then
            local m = UserInputService:GetMouseLocation()
            fromX, fromY = m.X, m.Y
        else
            fromX, fromY = view.w * 0.5, view.h * 0.5
        end
        renderer:Line(fromX, fromY, x + w * 0.5, y + h, cfg.TracerThickness or 1, cfg.TracerColor, cfg.TracerColor, tr)
    end

    if cfg.Skeleton and rec.character then
        local function bone(a, b)
            local p1 = rec.character:FindFirstChild(a)
            local p2 = rec.character:FindFirstChild(b)
            if not (p1 and p2) then return end
            local ax, ay = project(p1.Position.X, p1.Position.Y, p1.Position.Z)
            local bx, by = project(p2.Position.X, p2.Position.Y, p2.Position.Z)
            if ax and bx then
                renderer:Line(ax, ay, bx, by, cfg.SkeletonThickness or 1, cfg.SkeletonColor, cfg.SkeletonColor2, tr)
            end
        end
        if rec.isR15 then
            bone("Head", "UpperTorso")
            bone("UpperTorso", "LowerTorso")
            bone("LowerTorso", "LeftUpperLeg")
            bone("LowerTorso", "RightUpperLeg")
            bone("LeftUpperLeg", "LeftLowerLeg")
            bone("RightUpperLeg", "RightLowerLeg")
            bone("UpperTorso", "LeftUpperArm")
            bone("UpperTorso", "RightUpperArm")
            bone("LeftUpperArm", "LeftLowerArm")
            bone("RightUpperArm", "RightLowerArm")
        else
            bone("Head", "Torso")
            bone("Torso", "Left Leg")
            bone("Torso", "Right Leg")
            bone("Torso", "Left Arm")
            bone("Torso", "Right Arm")
        end
    end

    renderer:End()
end

local function processEntity(entity, isPlayer, options, ownerKey)
    local settings = espModule.Settings
    local character
    if isPlayer then
        character = entity.Character
    else
        character = entity
    end
    if not character or not character:IsA("Model") then
        local rec = state.records[entity]
        if rec then hideRecord(rec) end
        return
    end

    if isPlayer then
        local inRaid = entity:FindFirstChild("InRaid")
        if inRaid and inRaid:IsA("BoolValue") and not inRaid.Value then
            local rec = state.records[entity]
            if rec then hideRecord(rec) end
            return
        end
    end

    local cfg
    if isPlayer then
        cfg = espModule.IsTeam(entity) and settings.Teammate or settings.Enemy
    else
        cfg = settings.AI
    end
    if options and options.UseEnemy == true then cfg = settings.Enemy end
    if options and options.UseTeammate == true then cfg = settings.Teammate end
    if not cfg.Enabled then
        local rec = state.records[entity]
        if rec then hideRecord(rec) end
        return
    end

    local rec = state.records[entity]
    if not rec then
        rec = newRecord(entity)
        rec.touched = view.frame
        if ownerKey then rec.owner = ownerKey end
        state.records[entity] = rec
    else
        rec.touched = view.frame
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if rec.character ~= character then
        bindCharacter(rec, character, humanoid, false)
    elseif view.time - rec.scanned > 1.5 then
        rescan(rec, humanoid, false)
    else
        rec.humanoid = humanoid
    end

    if humanoid and humanoid.Health <= 0 then
        if rec.deathTime == 0 then
            rec.deathTime = view.time
        end
        if view.time - rec.deathTime > 1.2 then
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
    return getTeamValue(plr)
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
    if ownerHum and ownerHum.Health > 0 then
        d.health = math.clamp(ownerHum.Health / math.max(ownerHum.MaxHealth, 1), 0, 1)
        d.healthValue = math.floor(ownerHum.Health + 0.5)
    else
        d.health = nil
        d.healthValue = nil
    end

    d.armor = (cfg.ArmorBar and ownerChar) and currentArmor(rec, ownerChar) or nil
    d.tool = (cfg.Tool and ownerChar) and currentTool(rec, ownerChar) or nil

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
        hl = Instance.new("Highlight")
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
    hl.Enabled = true
end

local function clearHighlight(meta, key)
    local hl = meta[key]
    if hl then hl.Enabled = false end
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

    local use = state.use
    use[0] = settings.Enemy.Enabled and settings.Enemy.Chams
    use[1] = settings.Teammate.Enabled and settings.Teammate.Chams
    use[2] = (settings.AI.Enabled and settings.AI.Chams) or (settings.Items.Enabled and settings.Items.Chams)
    if use[0] or use[1] or use[2] then
        ensureShader()
        pushShader()
    elseif state.shader then
        destroyShader()
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
