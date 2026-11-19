print('2')

local espModule = {}

local cloneref = cloneref or function(...) return ... end
local GetService = setmetatable({}, {
    __index = function(_, key)
        return cloneref(game:GetService(key))
    end
})

local Services = {
    RunService = GetService.RunService,
    Players = GetService.Players,
    CoreGui = GetService.CoreGui,
    WorkSpace = GetService.Workspace,
    HttpService = GetService.HttpService,
    UserInputService = GetService.UserInputService,
}
Services.CurrentCamera = Services.WorkSpace.CurrentCamera
Services.LocalPlayer = Services.Players.LocalPlayer

local WHITE = Color3.new(1, 1, 1)
local BLACK = Color3.new(0, 0, 0)
local GRAY = Color3.fromRGB(200, 200, 200)
local rgb = Color3.fromRGB
local abs, floor, max, min, clamp, huge = math.abs, math.floor, math.max, math.min, math.clamp, math.huge

local OPERATION_ONE = 72920620366355
local STEP_NAME = "CatwareESP"
local IS_OPERATION_ONE = game.PlaceId == OPERATION_ONE

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
        Flags = false, SelectedFlags = {"Walking", "Jumping", "Swimming", "Dih"}, FlagColor1 = WHITE, FlagColor2 = GRAY,
        HealthBar = false, HealthText = false,
        HealthHigh = p.health[1], HealthMid = p.health[2], HealthLow = p.health[3],
        ArmorBar = false, ArmorHigh = rgb(0, 255, 0), ArmorMid = rgb(255, 255, 0), ArmorLow = rgb(255, 0, 0),
        HeadDot = false, HeadDotColor = WHITE, HeadDotSize = 20, HeadDotOutlineThickness = 1,
        Skeleton = false, SkeletonThickness = 1, SkeletonColor = p.main, SkeletonColor2 = p.skel2,
        Tracers = false, TracerThickness = 1, TracerOrigin = "Bottom", TracerColor = p.main,
        TextSize = 12,
    }
end

espModule.Settings = {
    RefreshRate = 144,
    MaxDistance = 1200,
    TextFont = "Gojiberry Quibble",
    FlagsFont = "Gojiberry Quibble",
    HealthFont = "Gojiberry Quibble",
    TextGradientAnimated = true,
    Enemy = entitySettings({
        main = rgb(255, 80, 80), fill1 = rgb(255, 80, 80), fill2 = rgb(255, 40, 40), skel2 = GRAY,
        text1 = WHITE, text2 = GRAY,
        health = {rgb(0, 255, 100), rgb(255, 255, 0), rgb(255, 40, 40)},
    }),
    Teammate = entitySettings({
        main = rgb(0, 180, 255), fill1 = rgb(0, 180, 255), fill2 = rgb(0, 100, 200), skel2 = rgb(100, 150, 200),
        text1 = rgb(180, 230, 255), text2 = rgb(100, 150, 200),
        health = {rgb(0, 200, 255), rgb(100, 200, 255), rgb(30, 80, 140)},
    }),
    AI = entitySettings({
        main = rgb(255, 200, 50), fill1 = rgb(255, 200, 50), fill2 = rgb(255, 150, 0), skel2 = rgb(200, 150, 50),
        text1 = WHITE, text2 = GRAY,
        health = {rgb(0, 255, 100), rgb(255, 255, 0), rgb(255, 40, 40)},
    }),
    Items = {
        Enabled = false, MaxDistance = 200, TextSize = 12,
        ShowNames = false, ShowDistance = false, ShowContents = false,
        Chams = false, ChamsFillTransparency = 0.3,
    },
}

local RESERVED_ITEM_KEYS = {
    Enabled = true, MaxDistance = true, TextSize = true, ShowNames = true, ShowDistance = true,
    ShowContents = true, Chams = true, ChamsFillTransparency = true,
}

espModule._drawings = {}
espModule._itemDrawings = {}
espModule._itemHighlights = {}
espModule._isRunning = false
espModule._connections = {}
espModule._boxFillAngles = {}
espModule._fadeAlpha = 1
espModule._isDead = false
espModule._frame = 0
espModule.Fonts = {}
espModule.CustomFlags = {}
espModule.CustomAIs = {}
espModule.CustomEntities = espModule.CustomAIs
espModule.CustomItems = {}
espModule.RegistryListeners = {}

local function fireRegistry()
    for _, fn in ipairs(espModule.RegistryListeners) do task.spawn(fn) end
end

function espModule.OnRegistryChanged(fn)
    espModule.RegistryListeners[#espModule.RegistryListeners + 1] = fn
end

function espModule.GetAINames()
    local out = {}
    for name in pairs(espModule.CustomAIs) do out[#out + 1] = name end
    table.sort(out)
    return out
end

function espModule.GetItemNames()
    local out = {}
    for name in pairs(espModule.CustomItems) do out[#out + 1] = name end
    table.sort(out)
    return out
end

function espModule.GetFlagNames()
    local out = {"Walking", "Jumping", "Swimming"}
    local custom = {}
    for name in pairs(espModule.CustomFlags) do custom[#custom + 1] = name end
    table.sort(custom)
    for _, name in ipairs(custom) do out[#out + 1] = name end
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
    if type(name) ~= "string" or name == "" or source == nil or RESERVED_ITEM_KEYS[name] then return nil end
    options = options or {}
    local items = self.Settings.Items
    if type(items[name]) ~= "table" then
        items[name] = { Enabled = options.Enabled == true, Color = options.Color or WHITE }
    elseif options.Color then
        items[name].Color = options.Color
    end
    self.CustomItems[name] = { Source = source, Options = options, Cache = nil, CacheAt = 0 }
    fireRegistry()
    return name
end

local gethui = gethui or function() return Services.CoreGui end
local espGui = Instance.new("ScreenGui")
espGui.Name = "ESPModuleGui"
espGui.IgnoreGuiInset = true
espGui.ResetOnSpawn = false
espGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() espGui.Parent = gethui() end)
if not espGui.Parent then espGui.Parent = Services.CoreGui end

local BOX_3D_EDGES = {
    {1, 2}, {2, 3}, {3, 4}, {4, 1},
    {5, 6}, {6, 7}, {7, 8}, {8, 5},
    {1, 5}, {2, 6}, {3, 7}, {4, 8},
}
local XS = {1, 0, 0, 1, 1, 0, 0, 1}
local YS = {1, 1, 0, 0, 1, 1, 0, 0}
local ZS = {1, 1, 1, 1, 0, 0, 0, 0}

local VM_PARTS = {"head", "torso", "arm1", "arm2", "leg1", "leg2", "shoulder1", "shoulder2", "hip1", "hip2"}
local SKELETON_KEYS = {"HeadTorso", "TorsoHip", "HipL", "HipR", "LLeg", "RLeg", "LArm", "RArm", "LFore", "RFore"}

local R15_PARTS = {"HumanoidRootPart", "Head", "UpperTorso", "LowerTorso", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand"}
local R6_PARTS = {"HumanoidRootPart", "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}

local R15_BONE_MAP = {
    HeadTorso = {"Head", "UpperTorso"}, TorsoHip = {"UpperTorso", "LowerTorso"},
    HipL = {"LowerTorso", "LeftUpperLeg"}, HipR = {"LowerTorso", "RightUpperLeg"},
    LLeg = {"LeftUpperLeg", "LeftLowerLeg"}, RLeg = {"RightUpperLeg", "RightLowerLeg"},
    LArm = {"UpperTorso", "LeftUpperArm"}, RArm = {"UpperTorso", "RightUpperArm"},
    LFore = {"LeftUpperArm", "LeftLowerArm"}, RFore = {"RightUpperArm", "RightLowerArm"},
}
local R6_BONE_MAP = {
    HeadTorso = {"Head", "Torso"}, HipL = {"Torso", "Left Leg"}, HipR = {"Torso", "Right Leg"},
    LArm = {"Torso", "Left Arm"}, RArm = {"Torso", "Right Arm"},
}
local VM_BONE_MAP = {
    HeadTorso = {"head", "torso"},
    LArm = {"torso", "shoulder1"}, LFore = {"shoulder1", "arm1"},
    RArm = {"torso", "shoulder2"}, RFore = {"shoulder2", "arm2"},
    HipL = {"torso", "hip1"}, LLeg = {"hip1", "leg1"},
    HipR = {"torso", "hip2"}, RLeg = {"hip2", "leg2"},
}

local function loadFont()
    if next(espModule.Fonts) then return end

    local function register(name, weight, style, asset)
        local ok, result = pcall(function()
            if not isfile(asset.Id) then writefile(asset.Id, asset.Font) end
            if isfile(name .. ".font") then delfile(name .. ".font") end
            writefile(name .. ".font", Services.HttpService:JSONEncode({
                name = name,
                faces = {{ name = "Normal", weight = weight, style = style, assetId = getcustomasset(asset.Id) }},
            }))
            return getcustomasset(name .. ".font")
        end)
        if ok and result then return Font.new(result, Enum.FontWeight.Regular, Enum.FontStyle.Normal) end
        return nil
    end

    local base = "https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/fonts/"
    local list = {
        {"Tahoma", "Tahoma.ttf", "Tahoma.ttf"},
        {"Tahoma Bold", "tahoma_bold.ttf", "tahoma_bold.ttf"},
        {"Tahoma Modern Bold", "Tahoma-Modern-Bold.ttf", "Tahoma-Modern-Bold.ttf"},
        {"Tahoma Modern", "Tahoma-Modern.ttf", "Tahoma-Modern.ttf"},
        {"Comfortaa", "Comfortaa-Regular.ttf", "Comfortaa-Regular.ttf"},
        {"HankenGrotesk", "HankenGrotesk-SemiBold.ttf", "HankenGrotesk-SemiBold.ttf"},
        {"Inter Medium", "Inter_28pt-Medium.ttf", "Inter_28pt-Medium.ttf"},
        {"Inter SemiBold", "Inter_28pt-SemiBold.ttf", "Inter_28pt-SemiBold.ttf"},
        {"Light Modern", "Light Modern.ttf", "Light%20Modern.ttf"},
        {"Minecraftia", "Minecraftia-Regular.ttf", "Minecraftia-Regular.ttf"},
        {"ProggyClean", "ProggyClean.ttf", "ProggyClean.ttf"},
        {"ProggyTiny", "ProggyTiny.ttf", "ProggyTiny.ttf"},
        {"Rubik", "Rubik-Regular.ttf", "Rubik-Regular.ttf"},
        {"Verdana", "Verdana-Font.ttf", "Verdana-Font.ttf"},
        {"Tahoma 8px", "fs-tahoma-8px.ttf", "fs-tahoma-8px.ttf"},
        {"Open Sans PX", "open-sans-px.ttf", "open-sans-px.ttf"},
        {"Smallest Pixel-7", "smallest_pixel-7.ttf", "smallest_pixel-7.ttf"},
        {"Gojiberry Quibble", "GojiberryQuibbleFreeRegular-7OldK.ttf", "GojiberryQuibbleFreeRegular-7OldK.ttf"},
    }

    for _, entry in ipairs(list) do
        local name, id, url = entry[1], entry[2], base .. entry[3]
        local content
        pcall(function()
            if isfile(id) then content = readfile(id) end
        end)
        if not content or #content < 100 then
            pcall(function()
                local fetched = game:HttpGet(url)
                if fetched and #fetched > 100 then
                    writefile(id, fetched)
                    content = fetched
                end
            end)
        end
        if content then
            local font = register(name, 400, "Normal", { Id = id, Font = content })
            if font then espModule.Fonts[name] = font end
        end
    end

    if not espModule.Fonts["Tahoma"] then
        espModule.Fonts["Tahoma"] = espModule.Fonts["Tahoma Modern"] or espModule.Fonts["Tahoma 8px"]
    end
    if not espModule.Fonts["Consolas Bold"] then
        espModule.Fonts["Consolas Bold"] = espModule.Fonts["ProggyClean"] or espModule.Fonts["Smallest Pixel-7"]
    end
end

local IsTeam
pcall(function()
    IsTeam = loadstring(game:HttpGet("https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/TeamCheck.lua"))()
end)
if type(IsTeam) ~= "function" then
    IsTeam = function(plr)
        if not plr or plr == Services.LocalPlayer then return false end
        if plr.Team and Services.LocalPlayer.Team and plr.Team == Services.LocalPlayer.Team then return true end
        local character = plr.Character
        return character ~= nil and character:FindFirstChild("SquadBillboard") ~= nil
    end
end

local function getEspFont(fontName)
    if fontName and espModule.Fonts[fontName] then return espModule.Fonts[fontName] end
    return Font.new("rbxasset://fonts/families/GothamSSm.json")
end

local function getHealthColor(t, high, mid, low)
    t = clamp(t, 0, 1)
    if t >= 0.5 then return mid:Lerp(high, (t - 0.5) * 2) end
    return low:Lerp(mid, t * 2)
end

local function CreateLine(props)
    local frame = Instance.new("Frame")
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BorderSizePixel = 0
    frame.BackgroundColor3 = props.Color or WHITE
    frame.Visible = false
    frame.ZIndex = props.ZIndex or 2
    frame.Parent = espGui

    local stroke = Instance.new("UIStroke")
    stroke.Name = "LineOutline"
    stroke.Color = BLACK
    stroke.Thickness = props.OutlineThickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = frame

    local gradient = Instance.new("UIGradient")
    gradient.Parent = frame

    local obj = {
        Frame = frame, Stroke = stroke, Gradient = gradient,
        Thickness = props.Thickness or 1, OutlineThickness = props.OutlineThickness or 1,
    }

    function obj:Set(from, to)
        if not from or not to then
            frame.Visible = false
            return
        end
        local dist = (to - from).Magnitude
        local center = from:Lerp(to, 0.5)
        frame.Position = UDim2.fromOffset(center.X, center.Y)
        frame.Size = UDim2.fromOffset(max(dist, 1), self.Thickness)
        frame.Rotation = math.deg(math.atan2(to.Y - from.Y, to.X - from.X))
        frame.Visible = true
    end

    function obj:SetColor(color)
        frame.BackgroundColor3 = color
    end

    function obj:SetThickness(t)
        self.Thickness = t
    end

    function obj:SetOutlineThickness(t)
        self.OutlineThickness = t
        stroke.Thickness = t
    end

    function obj:Hide()
        frame.Visible = false
    end

    function obj:Destroy()
        frame:Destroy()
    end

    return obj
end

local function CreateText(props)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = ""
    label.TextSize = props.Size or 10
    label.TextColor3 = WHITE
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = BLACK
    label.FontFace = props.Font or Font.new("rbxasset://fonts/families/GothamSSm.json")
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.AnchorPoint = Vector2.new(0.5, 0.5)
    label.AutomaticSize = Enum.AutomaticSize.XY
    label.Size = UDim2.fromOffset(0, 0)
    label.Visible = false
    label.ZIndex = props.ZIndex or 5
    label.Parent = espGui

    local gradient = Instance.new("UIGradient")
    gradient.Name = "TextGradient"
    gradient.Parent = label

    local obj = { Frame = label }

    function obj:Hide()
        label.Visible = false
    end

    function obj:Destroy()
        label:Destroy()
    end

    return obj
end

local function MakeBone()
    local line = CreateLine({ Thickness = 1, OutlineThickness = 1, ZIndex = 2 })
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = line.Frame
    return line
end

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

local function applyGradient(textObj, color1, color2)
    local grad = textObj.Frame:FindFirstChild("TextGradient")
    if not grad then return end
    if grad:GetAttribute("C1") ~= color1 or grad:GetAttribute("C2") ~= color2 then
        grad.Color = ColorSequence.new(color1, color2)
        grad:SetAttribute("C1", color1)
        grad:SetAttribute("C2", color2)
    end
    grad.Rotation = espModule.Settings.TextGradientAnimated and (os.clock() * 100) % 360 or 0
end

local function partPosition(inst)
    if not inst then return nil end
    if inst:IsA("BasePart") then return inst.Position end
    if inst:IsA("Model") then return inst:GetPivot().Position end
    local part = inst:FindFirstChildWhichIsA("BasePart", true)
    return part and part.Position or nil
end

local function collectBaseParts(container, out)
    if not container then return end
    if container:IsA("BasePart") then
        if container.Name ~= "Base" then out[#out + 1] = container end
        return
    end
    for _, d in ipairs(container:GetDescendants()) do
        if d:IsA("BasePart") and d.Name ~= "Base" then out[#out + 1] = d end
    end
end

local function computeBounds(parts, n)
    local mnx, mny, mnz, mxx, mxy, mxz = huge, huge, huge, -huge, -huge, -huge
    for i = 1, n do
        local part = parts[i]
        if part.Parent then
            local s = part.Size
            local hx, hy, hz = s.X * 0.5, s.Y * 0.5, s.Z * 0.5
            local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = part.CFrame:GetComponents()
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
    if mnx == huge then return nil end
    return mnx, mny, mnz, mxx, mxy, mxz
end

local function projectBounds(Camera, data, mnx, mny, mnz, mxx, mxy, mxz)
    local p, vis = data._p, data._vis
    local minX, minY, maxX, maxY, seen = huge, huge, -huge, -huge, 0
    for i = 1, 8 do
        local pos = Camera:WorldToViewportPoint(Vector3.new(
            XS[i] == 1 and mxx or mnx, YS[i] == 1 and mxy or mny, ZS[i] == 1 and mxz or mnz
        ))
        local ok = pos.Z > 0 and abs(pos.X) < 50000 and abs(pos.Y) < 50000
        p[i] = Vector2.new(pos.X, pos.Y)
        vis[i] = ok
        if ok then
            seen += 1
            if pos.X < minX then minX = pos.X end
            if pos.Y < minY then minY = pos.Y end
            if pos.X > maxX then maxX = pos.X end
            if pos.Y > maxY then maxY = pos.Y end
        end
    end
    if seen == 0 then return nil end
    local x = floor(minX - 4 + 0.5)
    local y = floor(minY - 4 + 0.5)
    local sx = max(floor(maxX - minX + 8 + 0.5), 8)
    local sy = max(floor(maxY - minY + 8 + 0.5), 8)
    if sx > 8000 or sy > 8000 then return nil end
    return x, y, sx, sy
end

local function CreateEntityESP(entity)
    if espModule._drawings[entity] then return end

    local boxFill = Instance.new("Frame")
    boxFill.BackgroundColor3 = WHITE
    boxFill.BorderSizePixel = 0
    boxFill.Visible = false
    boxFill.ZIndex = 1
    boxFill.Parent = espGui

    local boxFillGradient = Instance.new("UIGradient")
    boxFillGradient.Parent = boxFill

    local boxFillHighlight = Instance.new("Highlight")
    boxFillHighlight.Name = "BoxFillHighlight"
    boxFillHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    boxFillHighlight.Enabled = false
    boxFillHighlight.Parent = espGui

    local playerChams = Instance.new("Highlight")
    playerChams.Name = "PlayerChams"
    playerChams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    playerChams.Enabled = false
    playerChams.Parent = espGui

    local boxGlow = Instance.new("ImageLabel")
    boxGlow.Name = "BoxGlow"
    boxGlow.Image = "rbxassetid://110204605000367"
    boxGlow.ScaleType = Enum.ScaleType.Slice
    boxGlow.SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
    boxGlow.ImageTransparency = 0.65
    boxGlow.ResampleMode = Enum.ResamplerMode.Pixelated
    boxGlow.Visible = false
    boxGlow.BackgroundTransparency = 1
    boxGlow.BorderSizePixel = 0
    boxGlow.ZIndex = 0
    boxGlow.Parent = espGui

    local boxGlowGradient = Instance.new("UIGradient")
    boxGlowGradient.Rotation = 90
    boxGlowGradient.Parent = boxGlow

    local headDot = Instance.new("Frame")
    headDot.BackgroundColor3 = WHITE
    headDot.BorderSizePixel = 0
    headDot.AnchorPoint = Vector2.new(0.5, 0.5)
    headDot.Visible = false
    headDot.ZIndex = 6
    headDot.Parent = espGui

    local headCorner = Instance.new("UICorner")
    headCorner.CornerRadius = UDim.new(1, 0)
    headCorner.Parent = headDot

    local dotStroke = Instance.new("UIStroke")
    dotStroke.Name = "DotStroke"
    dotStroke.Color = BLACK
    dotStroke.Thickness = 1
    dotStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    dotStroke.Parent = headDot

    local box3dLines = {}
    for i = 1, 12 do
        local line = CreateLine({ Thickness = 1, OutlineThickness = 1, ZIndex = 2 })
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = line.Frame
        box3dLines["L" .. i] = line
    end

    local healthContainer = Instance.new("Frame")
    healthContainer.BackgroundColor3 = rgb(15, 15, 15)
    healthContainer.BorderSizePixel = 0
    healthContainer.Visible = false
    healthContainer.ZIndex = 2
    healthContainer.Parent = espGui

    local healthStroke = Instance.new("UIStroke")
    healthStroke.Color = BLACK
    healthStroke.Thickness = 1
    healthStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    healthStroke.Parent = healthContainer

    local healthFill = Instance.new("Frame")
    healthFill.BackgroundColor3 = WHITE
    healthFill.BorderSizePixel = 0
    healthFill.AnchorPoint = Vector2.new(0, 1)
    healthFill.Position = UDim2.fromScale(0, 1)
    healthFill.Size = UDim2.fromScale(1, 1)
    healthFill.Visible = false
    healthFill.ZIndex = 3
    healthFill.Parent = healthContainer

    local healthGradient = Instance.new("UIGradient")
    healthGradient.Rotation = 90
    healthGradient.Parent = healthFill

    local armorContainer = Instance.new("Frame")
    armorContainer.BackgroundColor3 = rgb(15, 15, 15)
    armorContainer.BorderSizePixel = 0
    armorContainer.Visible = false
    armorContainer.ZIndex = 2
    armorContainer.Parent = espGui

    local armorStroke = Instance.new("UIStroke")
    armorStroke.Color = BLACK
    armorStroke.Thickness = 1
    armorStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    armorStroke.Parent = armorContainer

    local armorFill = Instance.new("Frame")
    armorFill.BackgroundColor3 = WHITE
    armorFill.BorderSizePixel = 0
    armorFill.Size = UDim2.fromScale(1, 1)
    armorFill.Visible = false
    armorFill.ZIndex = 3
    armorFill.Parent = armorContainer

    local armorGradient = Instance.new("UIGradient")
    armorGradient.Parent = armorFill

    local flagsFrame = Instance.new("Frame")
    flagsFrame.BackgroundTransparency = 1
    flagsFrame.Visible = false
    flagsFrame.ZIndex = 5
    flagsFrame.Parent = espGui

    local flagsLayout = Instance.new("UIListLayout")
    flagsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    flagsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    flagsLayout.Parent = flagsFrame

    local cornerBox = Instance.new("Frame")
    cornerBox.Name = "CornerBox"
    cornerBox.BackgroundTransparency = 1
    cornerBox.Visible = false
    cornerBox.ZIndex = 2
    cornerBox.Parent = espGui

    local cornerBars = {}
    local function createCorner(xSign, ySign)
        local anchor = Vector2.new(xSign, ySign)
        local pos = UDim2.fromScale(xSign, ySign)
        local one = UDim2.fromOffset(1, 1)
        cornerBars[#cornerBars + 1] = {
            outlineH = createBar(cornerBox, one, pos, anchor, BLACK, UDim.new(0, 3), 1),
            outlineV = createBar(cornerBox, one, pos, anchor, BLACK, UDim.new(0, 3), 1),
            colorH = createBar(cornerBox, one, pos, anchor, WHITE, UDim.new(0, 3), 2),
            colorV = createBar(cornerBox, one, pos, anchor, WHITE, UDim.new(0, 3), 2),
            xSign = xSign, ySign = ySign,
        }
    end
    createCorner(0, 0)
    createCorner(1, 0)
    createCorner(0, 1)
    createCorner(1, 1)

    local fullBox = Instance.new("Frame")
    fullBox.Name = "FullBox"
    fullBox.BackgroundTransparency = 1
    fullBox.Visible = false
    fullBox.ZIndex = 2
    fullBox.Parent = espGui

    local fullBars = {}
    local function createFullSide(isHorizontal, isStart)
        local one = UDim2.fromOffset(1, 1)
        local zero = UDim2.fromScale(0, 0)
        fullBars[#fullBars + 1] = {
            outline = createBar(fullBox, one, zero, Vector2.new(0, 0), BLACK, UDim.new(0, 3), 1),
            color = createBar(fullBox, one, zero, Vector2.new(0, 0), WHITE, UDim.new(0, 3), 2),
            isHorizontal = isHorizontal, isStart = isStart,
        }
    end
    createFullSide(true, true)
    createFullSide(true, false)
    createFullSide(false, true)
    createFullSide(false, false)

    local skeleton = {}
    for _, key in ipairs(SKELETON_KEYS) do skeleton[key] = MakeBone() end

    espModule._drawings[entity] = {
        Cache = {},
        Full = { Box = fullBox, Bars = fullBars },
        Corner = { Box = cornerBox, Bars = cornerBars },
        Entity3DBox = box3dLines,
        BoxFill = boxFill,
        BoxFillHighlight = boxFillHighlight,
        BoxFillGradient = boxFillGradient,
        PlayerChams = playerChams,
        BoxGlow = boxGlow,
        BoxGlowGradient = boxGlowGradient,
        HeadDot = headDot,
        HealthContainer = healthContainer,
        HealthFill = healthFill,
        HealthGradient = healthGradient,
        ArmorContainer = armorContainer,
        ArmorFill = armorFill,
        ArmorGradient = armorGradient,
        FlagsFrame = flagsFrame,
        FlagLabels = {},
        HealthText = CreateText({ Size = 10, Font = getEspFont(espModule.Settings.HealthFont) }),
        NameText = CreateText({ Size = 10, Font = getEspFont(espModule.Settings.TextFont) }),
        DistanceText = CreateText({ Size = 10, Font = getEspFont(espModule.Settings.FlagsFont) }),
        ToolText = CreateText({ Size = 10, Font = getEspFont(espModule.Settings.TextFont) }),
        Tracer = (function()
            local line = CreateLine({ Thickness = 1, OutlineThickness = 1, ZIndex = 2 })
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = line.Frame
            return line
        end)(),
        Skeleton = skeleton,
        _p = {}, _vis = {}, _ctx = {}, _flags = {},
        Touched = espModule._frame,
        Owner = nil,
        LastSeen = 0,
        ResolvedOwner = nil,
        LastVMPos = nil,
        LastTeamVerdict = nil,
        LastTeamTime = 0,
        FirstSeen = os.clock(),
    }
end

local function HideESP(data)
    if not data then return end
    if data.Full and data.Full.Box then data.Full.Box.Visible = false end
    if data.Corner and data.Corner.Box then data.Corner.Box.Visible = false end
    for _, line in pairs(data.Entity3DBox) do line:Hide() end
    data.BoxFill.Visible = false
    data.BoxFillHighlight.Enabled = false
    data.PlayerChams.Enabled = false
    data.BoxGlow.Visible = false
    data.HeadDot.Visible = false
    data.HealthContainer.Visible = false
    data.HealthFill.Visible = false
    data.ArmorContainer.Visible = false
    data.ArmorFill.Visible = false
    data.FlagsFrame.Visible = false
    for _, lbl in pairs(data.FlagLabels) do lbl.Frame.Visible = false end
    data.HealthText:Hide()
    data.NameText:Hide()
    data.DistanceText:Hide()
    data.ToolText:Hide()
    data.Tracer:Hide()
    for _, bone in pairs(data.Skeleton) do bone:Hide() end
end

local function RemoveESP(entity)
    local data = espModule._drawings[entity]
    if not data then return end
    if data.Full and data.Full.Box then data.Full.Box:Destroy() end
    if data.Corner and data.Corner.Box then data.Corner.Box:Destroy() end
    for _, v in pairs(data.Entity3DBox) do v:Destroy() end
    data.BoxFill:Destroy()
    data.BoxFillHighlight:Destroy()
    data.PlayerChams:Destroy()
    data.BoxGlow:Destroy()
    data.HeadDot:Destroy()
    data.HealthContainer:Destroy()
    data.ArmorContainer:Destroy()
    data.FlagsFrame:Destroy()
    for _, lbl in pairs(data.FlagLabels) do lbl.Frame:Destroy() end
    data.HealthText:Destroy()
    data.NameText:Destroy()
    data.DistanceText:Destroy()
    data.ToolText:Destroy()
    data.Tracer:Destroy()
    for _, bone in pairs(data.Skeleton) do bone:Destroy() end
    espModule._drawings[entity] = nil
    espModule._boxFillAngles[entity] = nil
end

local function collectFlags(data, entity, character, humanoid, cfg)
    local out = data._flags
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
    return out
end

local function RenderESP(entity, data, cfg, ctx)
    local Camera = ctx.Camera
    local fade = espModule._fadeAlpha
    local trans = 1 - fade
    local x, y, sx, sy = ctx.x, ctx.y, ctx.sx, ctx.sy
    local p, vis = data._p, data._vis
    local settings = espModule.Settings
    local textFont = getEspFont(settings.TextFont)
    local flagsFont = getEspFont(settings.FlagsFont)
    local healthFont = getEspFont(settings.HealthFont)
    local adornee = ctx.adornee

    if cfg.BoxFill and cfg.BoxEnabled then
        if cfg.BoxType == "3D" then
            data.BoxFill.Visible = false
            data.BoxFillHighlight.Adornee = adornee
            data.BoxFillHighlight.FillColor = cfg.BoxFillColor1
            data.BoxFillHighlight.OutlineColor = cfg.LineColor
            data.BoxFillHighlight.FillTransparency = 1 - ((1 - cfg.BoxFillTransparency) * fade)
            data.BoxFillHighlight.OutlineTransparency = 1
            data.BoxFillHighlight.Enabled = true
        else
            data.BoxFillHighlight.Enabled = false
            local angle = espModule._boxFillAngles[entity] or cfg.BoxFillRotation or 0
            if cfg.BoxFillSpeed and cfg.BoxFillSpeed ~= 0 then
                angle = (angle + cfg.BoxFillSpeed) % 360
            end
            espModule._boxFillAngles[entity] = angle
            data.BoxFill.Position = UDim2.fromOffset(x, y)
            data.BoxFill.Size = UDim2.fromOffset(sx, sy)
            data.BoxFill.BackgroundTransparency = 1 - ((1 - cfg.BoxFillTransparency) * fade)
            data.BoxFillGradient.Color = ColorSequence.new(cfg.BoxFillColor1, cfg.BoxFillColor2)
            data.BoxFillGradient.Rotation = angle
            data.BoxFill.Visible = true
        end
    else
        data.BoxFill.Visible = false
        data.BoxFillHighlight.Enabled = false
    end

    if cfg.Chams then
        data.PlayerChams.Adornee = adornee
        data.PlayerChams.FillColor = cfg.ChamsColor
        data.PlayerChams.FillTransparency = 1 - ((1 - cfg.ChamsFillTransparency) * fade)
        if cfg.ChamsGlow then
            data.PlayerChams.OutlineColor = cfg.ChamsColor
            data.PlayerChams.OutlineTransparency = trans
        else
            data.PlayerChams.OutlineColor = BLACK
            data.PlayerChams.OutlineTransparency = 1
        end
        data.PlayerChams.Enabled = true
    else
        data.PlayerChams.Enabled = false
    end

    if cfg.BoxEnabled then
        if cfg.BoxGlow then
            data.BoxGlow.Position = UDim2.fromOffset(x - 21, y - 21)
            data.BoxGlow.Size = UDim2.fromOffset(sx + 42, sy + 42)
            data.BoxGlow.ImageTransparency = 1 - (0.65 * fade)
            data.BoxGlowGradient.Color = ColorSequence.new(cfg.LineColor, cfg.LineColor)
            data.BoxGlow.Visible = true
        else
            data.BoxGlow.Visible = false
        end

        local thick = max(1, cfg.Thickness or 1)

        if cfg.BoxType == "Full" then
            if data.Corner.Box then data.Corner.Box.Visible = false end
            for _, line in pairs(data.Entity3DBox) do line:Hide() end

            local box = data.Full.Box
            box.Position = UDim2.fromOffset(x, y)
            box.Size = UDim2.fromOffset(sx, sy)
            box.Visible = true

            local outerThick = thick + 2
            for _, group in ipairs(data.Full.Bars) do
                local start = group.isStart
                if group.isHorizontal then
                    group.outline.Size = UDim2.new(1, 2, 0, outerThick)
                    group.outline.Position = UDim2.new(0, -1, start and 0 or 1, start and -1 or 1)
                    group.outline.AnchorPoint = Vector2.new(0, start and 0 or 1)
                    group.color.Size = UDim2.new(1, 0, 0, thick)
                    group.color.Position = UDim2.new(0, 0, start and 0 or 1, 0)
                    group.color.AnchorPoint = Vector2.new(0, start and 0 or 1)
                else
                    group.outline.Size = UDim2.new(0, outerThick, 1, 2)
                    group.outline.Position = UDim2.new(start and 0 or 1, start and -1 or 1, 0, -1)
                    group.outline.AnchorPoint = Vector2.new(start and 0 or 1, 0)
                    group.color.Size = UDim2.new(0, thick, 1, 0)
                    group.color.Position = UDim2.new(start and 0 or 1, 0, 0, 0)
                    group.color.AnchorPoint = Vector2.new(start and 0 or 1, 0)
                end
                group.outline.BackgroundColor3 = BLACK
                group.outline.BackgroundTransparency = trans
                group.color.BackgroundColor3 = cfg.LineColor
                group.color.BackgroundTransparency = trans
            end

        elseif cfg.BoxType == "3D" then
            if data.Corner.Box then data.Corner.Box.Visible = false end
            if data.Full.Box then data.Full.Box.Visible = false end
            for i = 1, 12 do
                local e = BOX_3D_EDGES[i]
                local line = data.Entity3DBox["L" .. i]
                if vis[e[1]] and vis[e[2]] then
                    line:SetColor(cfg.LineColor)
                    line:SetThickness(thick)
                    line:SetOutlineThickness(1)
                    line:Set(p[e[1]], p[e[2]])
                    line.Frame.BackgroundTransparency = trans
                else
                    line:Hide()
                end
            end

        else
            if data.Full.Box then data.Full.Box.Visible = false end
            for _, line in pairs(data.Entity3DBox) do line:Hide() end

            local box = data.Corner.Box
            box.Position = UDim2.fromOffset(x, y)
            box.Size = UDim2.fromOffset(sx, sy)
            box.Visible = true

            local maxAllowed = min(50, floor(min(sx, sy) * 0.42))
            local lineLen = clamp(40, 6, max(6, maxAllowed))
            local outerThick = thick + 2
            local outerLen = lineLen + 2

            for _, group in ipairs(data.Corner.Bars) do
                local xSign, ySign = group.xSign, group.ySign
                local xDir = (xSign == 0) and 1 or -1
                local yDir = (ySign == 0) and 1 or -1

                group.outlineH.Size = UDim2.fromOffset(outerLen, outerThick)
                group.outlineH.Position = UDim2.new(xSign, -xDir, ySign, -yDir)
                group.outlineH.BackgroundTransparency = trans
                group.outlineV.Size = UDim2.fromOffset(outerThick, outerLen)
                group.outlineV.Position = UDim2.new(xSign, -xDir, ySign, -yDir)
                group.outlineV.BackgroundTransparency = trans

                group.colorH.Size = UDim2.fromOffset(lineLen, thick)
                group.colorH.Position = UDim2.fromScale(xSign, ySign)
                group.colorH.BackgroundColor3 = cfg.LineColor
                group.colorH.BackgroundTransparency = trans
                group.colorV.Size = UDim2.fromOffset(thick, lineLen)
                group.colorV.Position = UDim2.fromScale(xSign, ySign)
                group.colorV.BackgroundColor3 = cfg.LineColor
                group.colorV.BackgroundTransparency = trans
            end
        end
    else
        data.BoxGlow.Visible = false
        if data.Corner.Box then data.Corner.Box.Visible = false end
        if data.Full.Box then data.Full.Box.Visible = false end
        for _, line in pairs(data.Entity3DBox) do line:Hide() end
    end

    if cfg.HeadDot and ctx.headPos then
        local hp = Camera:WorldToViewportPoint(ctx.headPos)
        if hp.Z > 0 then
            data.HeadDot.Size = UDim2.fromOffset(cfg.HeadDotSize, cfg.HeadDotSize)
            data.HeadDot.Position = UDim2.fromOffset(hp.X, hp.Y)
            data.HeadDot.BackgroundColor3 = cfg.HeadDotColor
            data.HeadDot.BackgroundTransparency = trans
            local stroke = data.HeadDot:FindFirstChild("DotStroke")
            if stroke then
                stroke.Enabled = (cfg.HeadDotOutlineThickness or 0) > 0
                stroke.Thickness = max(cfg.HeadDotOutlineThickness or 0, 0)
                stroke.Transparency = trans
            end
            data.HeadDot.Visible = true
        else
            data.HeadDot.Visible = false
        end
    else
        data.HeadDot.Visible = false
    end

    local healthBarX = x - 4
    local hp = ctx.health

    if cfg.HealthBar and hp then
        data.HealthContainer.Position = UDim2.fromOffset(healthBarX, y)
        data.HealthContainer.Size = UDim2.fromOffset(1, sy)
        data.HealthContainer.Visible = true
        data.HealthContainer.BackgroundTransparency = trans
        data.HealthFill.Size = UDim2.fromScale(1, hp)
        data.HealthFill.Visible = true
        data.HealthFill.BackgroundTransparency = trans
        data.HealthGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, cfg.HealthHigh),
            ColorSequenceKeypoint.new(0.5, cfg.HealthMid),
            ColorSequenceKeypoint.new(1, cfg.HealthLow),
        })
    else
        data.HealthContainer.Visible = false
        data.HealthFill.Visible = false
    end

    if cfg.HealthText and hp then
        local text = tostring(ctx.healthValue)
        local label = data.HealthText.Frame
        if data.LastHealthStr ~= text then
            label.Text = text
            data.LastHealthStr = text
        end
        if data.LastHealthFont ~= healthFont or data.LastHealthSize ~= cfg.TextSize then
            label.TextSize = cfg.TextSize
            label.FontFace = healthFont
            data.LastHealthFont = healthFont
            data.LastHealthSize = cfg.TextSize
        end
        if cfg.HealthBar then
            local ty = clamp(y + sy - sy * hp - 5, y - 2, y + sy - 10)
            label.Position = UDim2.fromOffset(healthBarX - 3, ty)
        else
            label.Position = UDim2.fromOffset(x - 3, y)
        end
        label.AnchorPoint = Vector2.new(1, 0)
        label.TextXAlignment = Enum.TextXAlignment.Right
        label.TextYAlignment = Enum.TextYAlignment.Top
        local hc = getHealthColor(hp, cfg.HealthHigh, cfg.HealthMid, cfg.HealthLow)
        local grad = label:FindFirstChild("TextGradient")
        if grad then grad.Color = ColorSequence.new(hc, hc) end
        label.Visible = true
        label.TextTransparency = trans
        label.TextStrokeTransparency = trans
    else
        data.HealthText:Hide()
    end

    if cfg.ArmorBar and ctx.armor then
        data.ArmorContainer.Position = UDim2.fromOffset(x, y + sy + 4)
        data.ArmorContainer.Size = UDim2.fromOffset(sx, 1)
        data.ArmorContainer.Visible = true
        data.ArmorContainer.BackgroundTransparency = trans
        data.ArmorFill.Size = UDim2.fromScale(ctx.armor, 1)
        data.ArmorFill.BackgroundTransparency = trans
        data.ArmorGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, cfg.ArmorHigh),
            ColorSequenceKeypoint.new(0.5, cfg.ArmorMid),
            ColorSequenceKeypoint.new(1, cfg.ArmorLow),
        })
        data.ArmorFill.Visible = true
    else
        data.ArmorContainer.Visible = false
        data.ArmorFill.Visible = false
    end

    if cfg.Names and ctx.name then
        local label = data.NameText.Frame
        if data.LastNameStr ~= ctx.name then
            label.Text = ctx.name
            data.LastNameStr = ctx.name
        end
        if data.LastNameFont ~= textFont or data.LastNameSize ~= cfg.TextSize then
            label.TextSize = cfg.TextSize
            label.FontFace = textFont
            data.LastNameFont = textFont
            data.LastNameSize = cfg.TextSize
        end
        applyGradient(data.NameText, cfg.NameColor, cfg.NameColor2)
        label.Position = UDim2.fromOffset(x + sx * 0.5, y - 4)
        label.AnchorPoint = Vector2.new(0.5, 1)
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextYAlignment = Enum.TextYAlignment.Bottom
        label.Visible = true
        label.TextTransparency = trans
        label.TextStrokeTransparency = trans
    else
        data.NameText:Hide()
    end

    if cfg.Distance then
        local text = "[" .. tostring(ctx.meters) .. "m]"
        local label = data.DistanceText.Frame
        if data.LastDistStr ~= text then
            label.Text = text
            data.LastDistStr = text
        end
        if data.LastDistFont ~= flagsFont or data.LastDistSize ~= cfg.TextSize then
            label.TextSize = cfg.TextSize
            label.FontFace = flagsFont
            data.LastDistFont = flagsFont
            data.LastDistSize = cfg.TextSize
        end
        applyGradient(data.DistanceText, cfg.DistanceColor, cfg.DistanceColor2)
        label.Position = UDim2.fromOffset(x + sx + 4, y - 1)
        label.AnchorPoint = Vector2.new(0, 0)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Top
        label.Visible = true
        label.TextTransparency = trans
        label.TextStrokeTransparency = trans
    else
        data.DistanceText:Hide()
    end

    if cfg.Tool and ctx.tool then
        local label = data.ToolText.Frame
        if data.LastToolStr ~= ctx.tool then
            label.Text = ctx.tool
            data.LastToolStr = ctx.tool
        end
        if data.LastToolFont ~= textFont or data.LastToolSize ~= cfg.TextSize then
            label.TextSize = cfg.TextSize
            label.FontFace = textFont
            data.LastToolFont = textFont
            data.LastToolSize = cfg.TextSize
        end
        applyGradient(data.ToolText, cfg.ToolColor, cfg.ToolColor2)
        label.Position = UDim2.fromOffset(x + sx * 0.5, y + sy + (cfg.ArmorBar and 8 or 2))
        label.AnchorPoint = Vector2.new(0.5, 0)
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextYAlignment = Enum.TextYAlignment.Top
        label.Visible = true
        label.TextTransparency = trans
        label.TextStrokeTransparency = trans
    else
        data.ToolText:Hide()
    end

    if cfg.Flags and ctx.flags then
        local active = ctx.flags
        local count = 0
        for _, name in ipairs(active) do
            local entry = data.FlagLabels[name]
            if not entry then
                local lbl = Instance.new("TextLabel")
                lbl.BackgroundTransparency = 1
                lbl.Text = name
                lbl.TextSize = 10
                lbl.TextColor3 = WHITE
                lbl.TextStrokeTransparency = 0
                lbl.TextStrokeColor3 = BLACK
                lbl.FontFace = flagsFont
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.TextYAlignment = Enum.TextYAlignment.Top
                lbl.AutomaticSize = Enum.AutomaticSize.XY
                lbl.Size = UDim2.fromOffset(0, 0)
                lbl.Visible = false
                lbl.ZIndex = 5
                lbl.Parent = data.FlagsFrame
                local grad = Instance.new("UIGradient")
                grad.Name = "TextGradient"
                grad.Parent = lbl
                entry = { Frame = lbl, LastFont = flagsFont, LastSize = 10 }
                data.FlagLabels[name] = entry
            end
            entry.Frame.Visible = true
            entry.Frame.LayoutOrder = count
            if entry.LastFont ~= flagsFont or entry.LastSize ~= cfg.TextSize then
                entry.Frame.FontFace = flagsFont
                entry.Frame.TextSize = cfg.TextSize
                entry.LastFont = flagsFont
                entry.LastSize = cfg.TextSize
            end
            applyGradient(entry, cfg.FlagColor1, cfg.FlagColor2)
            entry.Frame.TextTransparency = trans
            entry.Frame.TextStrokeTransparency = trans
            count += 1
        end
        for name, entry in pairs(data.FlagLabels) do
            if not table.find(active, name) then entry.Frame.Visible = false end
        end
        if count > 0 then
            data.FlagsFrame.Position = UDim2.fromOffset(x + sx + 4, cfg.Distance and (y + 12) or (y - 1))
            data.FlagsFrame.Size = UDim2.fromOffset(0, 0)
            data.FlagsFrame.AutomaticSize = Enum.AutomaticSize.XY
            data.FlagsFrame.Visible = true
        else
            data.FlagsFrame.Visible = false
        end
    else
        data.FlagsFrame.Visible = false
        for _, lbl in pairs(data.FlagLabels) do lbl.Frame.Visible = false end
    end

    if cfg.Tracers then
        local viewport = Camera.ViewportSize
        local from
        if cfg.TracerOrigin == "Bottom" then
            from = Vector2.new(viewport.X * 0.5, viewport.Y)
        elseif cfg.TracerOrigin == "Top" then
            from = Vector2.new(viewport.X * 0.5, 0)
        elseif cfg.TracerOrigin == "Mouse" then
            from = Services.UserInputService:GetMouseLocation()
        else
            from = Vector2.new(viewport.X * 0.5, viewport.Y * 0.5)
        end
        data.Tracer:SetColor(cfg.TracerColor)
        data.Tracer:SetThickness(cfg.TracerThickness)
        data.Tracer:SetOutlineThickness(1)
        data.Tracer:Set(from, Vector2.new(x + sx * 0.5, y + sy))
        data.Tracer.Frame.BackgroundTransparency = trans
    else
        data.Tracer:Hide()
    end

    if cfg.Skeleton and ctx.boneMap and ctx.lookup then
        for _, key in ipairs(SKELETON_KEYS) do
            local bone = data.Skeleton[key]
            local pair = ctx.boneMap[key]
            local drawn = false
            if pair then
                local a, b = ctx.lookup(pair[1]), ctx.lookup(pair[2])
                if a and b then
                    local s1, s2 = Camera:WorldToViewportPoint(a), Camera:WorldToViewportPoint(b)
                    if s1.Z > 0 and s2.Z > 0 then
                        bone:SetColor(WHITE)
                        bone.Gradient.Color = ColorSequence.new(cfg.SkeletonColor, cfg.SkeletonColor2)
                        bone.Gradient.Rotation = 0
                        bone:SetThickness(cfg.SkeletonThickness)
                        bone:SetOutlineThickness(1)
                        bone:Set(Vector2.new(s1.X, s1.Y), Vector2.new(s2.X, s2.Y))
                        bone.Frame.BackgroundTransparency = trans
                        drawn = true
                    end
                end
            end
            if not drawn then bone:Hide() end
        end
    else
        for _, bone in pairs(data.Skeleton) do bone:Hide() end
    end
end

local function resolveList(entry, now)
    local source = entry.Source
    local kind = typeof(source)
    local function children(inst)
        if entry.Cache and entry.CacheInst == inst and now - entry.CacheAt < 0.5 then return entry.Cache end
        entry.Cache = inst:GetChildren()
        entry.CacheInst = inst
        entry.CacheAt = now
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

local function buildPartList(cache, character, options)
    cache.List = cache.List or {}
    local list = cache.List
    table.clear(list)
    local hitboxes = options and options.Hitboxes
    if type(hitboxes) == "function" then
        local ok, res = pcall(hitboxes, character)
        if ok and type(res) == "table" then
            for _, inst in ipairs(res) do collectBaseParts(inst, list) end
        end
    elseif type(hitboxes) == "table" then
        for _, name in ipairs(hitboxes) do collectBaseParts(character:FindFirstChild(name), list) end
    elseif cache.IsRig then
        for _, name in ipairs(cache.IsR15 and R15_PARTS or R6_PARTS) do
            local part = character:FindFirstChild(name)
            if part and part:IsA("BasePart") then list[#list + 1] = part end
        end
        for _, child in ipairs(character:GetChildren()) do
            if child:IsA("Accessory") then
                local handle = child:FindFirstChild("Handle")
                if handle and handle:IsA("BasePart") then list[#list + 1] = handle end
            end
        end
    else
        collectBaseParts(character, list)
    end
    cache.N = #list
    cache.ListAt = os.clock()
end

local function ProcessEntity(entity, options, ownerName)
    if entity == Services.LocalPlayer then return end
    local frame = espModule._frame
    local existing = espModule._drawings[entity]
    if existing then existing.Touched = frame end

    local isPlayer = typeof(entity) == "Instance" and entity:IsA("Player")
    local character = isPlayer and entity.Character or entity
    if not character or not character:IsA("Model") or not character.Parent then
        HideESP(existing)
        return
    end

    if isPlayer then
        local inRaid = entity:FindFirstChild("InRaid")
        if inRaid and inRaid:IsA("BoolValue") and not inRaid.Value then
            HideESP(existing)
            return
        end
    end

    local settings = espModule.Settings
    local cfg = isPlayer and (IsTeam(entity) and settings.Teammate or settings.Enemy) or settings.AI
    if not cfg.Enabled then
        RemoveESP(entity)
        return
    end

    CreateEntityESP(entity)
    local data = espModule._drawings[entity]
    if not data then return end
    data.Touched = frame
    data.Owner = ownerName

    local now = os.clock()
    local cache = data.Cache
    if cache.Character ~= character or (not cache.Humanoid and now - (cache.BoundAt or 0) > 1) or (cache.Root and not cache.Root.Parent) then
        cache.Character = character
        cache.BoundAt = now
        cache.Humanoid = character:FindFirstChildOfClass("Humanoid")
        local root
        if options and type(options.Root) == "function" then
            local ok, res = pcall(options.Root, character)
            if ok then root = res end
        end
        cache.Root = root or character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart or character:FindFirstChildWhichIsA("BasePart", true)
        cache.IsR15 = character:FindFirstChild("UpperTorso") ~= nil
        cache.IsRig = cache.IsR15 or character:FindFirstChild("Torso") ~= nil
        cache.BoneMap = cache.IsRig and (cache.IsR15 and R15_BONE_MAP or R6_BONE_MAP) or nil
        cache.Lookup = function(name)
            return partPosition(character:FindFirstChild(name))
        end
        cache.ListAt = 0
    end

    local humanoid, root = cache.Humanoid, cache.Root
    if not root then
        HideESP(data)
        return
    end
    if humanoid and humanoid.Health <= 0 then
        HideESP(data)
        return
    end
    if options and type(options.Alive) == "function" then
        local ok, alive = pcall(options.Alive, character)
        if ok and not alive then
            HideESP(data)
            return
        end
    end

    local Camera = Services.CurrentCamera
    if not Camera then return end

    local rootPos = root.Position
    local studs = (Camera.CFrame.Position - rootPos).Magnitude
    if studs > settings.MaxDistance then
        HideESP(data)
        return
    end
    if Camera:WorldToViewportPoint(rootPos).Z <= 0 then
        HideESP(data)
        return
    end

    if now - cache.ListAt > 1.5 then buildPartList(cache, character, options) end
    local mnx, mny, mnz, mxx, mxy, mxz = computeBounds(cache.List, cache.N)
    if not mnx then
        HideESP(data)
        return
    end
    local x, y, sx, sy = projectBounds(Camera, data, mnx, mny, mnz, mxx, mxy, mxz)
    if not x then
        HideESP(data)
        return
    end

    local ctx = data._ctx
    ctx.Camera = Camera
    ctx.x, ctx.y, ctx.sx, ctx.sy = x, y, sx, sy
    ctx.adornee = character
    ctx.meters = floor(studs)

    ctx.health, ctx.healthValue = nil, nil
    if humanoid then
        ctx.health = clamp(humanoid.Health / max(humanoid.MaxHealth, 1), 0, 1)
        ctx.healthValue = floor(humanoid.Health + 0.5)
    elseif options and type(options.Health) == "function" then
        local ok, hp, maxHp = pcall(options.Health, character)
        if ok and type(hp) == "number" then
            ctx.health = clamp(hp / max(maxHp or 100, 1), 0, 1)
            ctx.healthValue = floor(hp + 0.5)
        end
    end

    ctx.armor = nil
    if cfg.ArmorBar then
        if options and type(options.Armor) == "function" then
            local ok, value, maxValue = pcall(options.Armor, character)
            if ok and type(value) == "number" then ctx.armor = clamp(value / max(maxValue or 100, 1), 0, 1) end
        else
            local armor = character:FindFirstChild("Armor")
            ctx.armor = (armor and armor:IsA("NumberValue") and armor.Value > 0) and clamp(armor.Value / 100, 0, 1) or 1
        end
    end

    ctx.name = nil
    if cfg.Names then
        if options and options.Name ~= nil then
            local value = options.Name
            if type(value) == "function" then
                local ok, res = pcall(value, character)
                value = ok and res or character.Name
            end
            ctx.name = tostring(value)
        elseif isPlayer then
            local nt = cfg.NameType
            if data.NameType ~= nt then
                data.NameType = nt
                if nt == "Display" then
                    data.NameStr = entity.DisplayName
                elseif nt == "Username" then
                    data.NameStr = entity.Name
                else
                    data.NameStr = entity.DisplayName .. " (@" .. entity.Name .. ")"
                end
            end
            ctx.name = data.NameStr
        else
            ctx.name = character.Name
        end
    end

    ctx.tool = nil
    if cfg.Tool then
        if options and type(options.Tool) == "function" then
            local ok, res = pcall(options.Tool, character)
            ctx.tool = ok and res and tostring(res) or "None"
        else
            local tool = character:FindFirstChildOfClass("Tool")
            ctx.tool = tool and tool.Name or "None"
        end
    end

    ctx.flags = cfg.Flags and collectFlags(data, entity, character, humanoid, cfg) or nil

    ctx.headPos = nil
    if cfg.HeadDot then
        ctx.headPos = partPosition(character:FindFirstChild("Head"))
    end

    ctx.boneMap = cfg.Skeleton and cache.BoneMap or nil
    ctx.lookup = cache.Lookup

    RenderESP(entity, data, cfg, ctx)
end

local function getVMParts(vm, data)
    local cache = data.VMCache
    local now = os.clock()
    if cache and now - cache.t < 1 then return cache.parts, cache.n end
    local parts = {}
    for _, name in ipairs(VM_PARTS) do
        collectBaseParts(vm:FindFirstChild(name), parts)
    end
    collectBaseParts(vm:FindFirstChild("Hitboxes"), parts)
    if #parts == 0 then collectBaseParts(vm, parts) end
    data.VMCache = { parts = parts, n = #parts, t = now }
    return parts, #parts
end

local function updateOwner(data, vmPos)
    if not vmPos then
        data.ResolvedOwner = nil
        return nil
    end
    if data.LastVMPos and (vmPos - data.LastVMPos).Magnitude > 15 then
        data.ResolvedOwner = nil
        data.LastTeamVerdict = nil
        data.LastTeamTime = 0
    end
    data.LastVMPos = vmPos
    local current = data.ResolvedOwner
    if current and current.Parent then
        local char = current.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        if rootPart and (rootPart.Position - vmPos).Magnitude < 10 then return current end
    end
    local best, bestDist = nil, 8
    for _, plr in ipairs(Services.Players:GetPlayers()) do
        if plr ~= Services.LocalPlayer then
            local char = plr.Character
            local rootPart = char and char:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local d = (rootPart.Position - vmPos).Magnitude
                if d < bestDist then
                    bestDist = d
                    best = plr
                end
            end
        end
    end
    data.ResolvedOwner = best
    return best
end

local function teamOf(plr)
    return plr:GetAttribute("Team") or (plr.Character and plr.Character:GetAttribute("Team")) or (plr.Team and plr.Team.Name)
end

local function checkTeam(data, owner, now)
    if owner then
        local mine, theirs = teamOf(Services.LocalPlayer), teamOf(owner)
        if mine and theirs then
            data.LastTeamVerdict = theirs == mine and "team" or "enemy"
            data.LastTeamTime = now
            return theirs == mine
        end
    end
    if data.LastTeamVerdict and (now - data.LastTeamTime) < 3 then
        return data.LastTeamVerdict == "team"
    end
    return true
end

local function ProcessOperationOneVM(vm)
    if not vm or not vm:IsA("Model") or vm.Name:sub(1, 5) == "Local" then return end
    local frame = espModule._frame
    local existing = espModule._drawings[vm]
    if existing then existing.Touched = frame end

    local settings = espModule.Settings
    if not (settings.Enemy.Enabled or settings.Teammate.Enabled) then
        if existing then RemoveESP(vm) end
        return
    end

    CreateEntityESP(vm)
    local data = espModule._drawings[vm]
    if not data then return end
    data.Touched = frame

    local now = os.clock()
    local torsoPos = partPosition(vm:FindFirstChild("torso"))
    local owner = updateOwner(data, torsoPos)
    if not torsoPos or (now - data.FirstSeen) < 0.05 then
        HideESP(data)
        return
    end

    local isTeam = checkTeam(data, owner, now)
    local cfg = isTeam and settings.Teammate or settings.Enemy
    if not cfg.Enabled then
        HideESP(data)
        return
    end

    local Camera = Services.CurrentCamera
    if not Camera then return end

    local parts, n = getVMParts(vm, data)
    if n == 0 then
        HideESP(data)
        return
    end
    local mnx, mny, mnz, mxx, mxy, mxz = computeBounds(parts, n)
    if not mnx then
        HideESP(data)
        return
    end

    local center = Vector3.new((mnx + mxx) * 0.5, (mny + mxy) * 0.5, (mnz + mxz) * 0.5)
    local distance = (center - Camera.CFrame.Position).Magnitude
    if distance <= 1 or distance > settings.MaxDistance then
        HideESP(data)
        return
    end

    local x, y, sx, sy = projectBounds(Camera, data, mnx, mny, mnz, mxx, mxy, mxz)
    if not x then
        HideESP(data)
        return
    end

    if not data.VMLookup then
        data.VMLookup = function(name)
            return partPosition(vm:FindFirstChild(name))
        end
    end

    local ownerChar = owner and owner.Character
    local ownerHum = ownerChar and ownerChar:FindFirstChildOfClass("Humanoid")

    local ctx = data._ctx
    ctx.Camera = Camera
    ctx.x, ctx.y, ctx.sx, ctx.sy = x, y, sx, sy
    ctx.adornee = vm
    ctx.meters = floor(distance + 0.5)

    ctx.health, ctx.healthValue = nil, nil
    if ownerHum then
        ctx.health = clamp(ownerHum.Health / max(ownerHum.MaxHealth, 1), 0, 1)
        ctx.healthValue = floor(ownerHum.Health + 0.5)
    end

    ctx.armor = nil
    if cfg.ArmorBar then
        local armor = ownerChar and ownerChar:FindFirstChild("Armor")
        ctx.armor = (armor and armor:IsA("NumberValue") and armor.Value > 0) and clamp(armor.Value / 100, 0, 1) or 1
    end

    ctx.name = nil
    if cfg.Names and owner then
        local nt = cfg.NameType
        if nt == "Username" then
            ctx.name = owner.Name
        elseif nt == "Both" then
            ctx.name = owner.DisplayName .. " (@" .. owner.Name .. ")"
        else
            ctx.name = owner.DisplayName
        end
        data.LastOwnerName = ctx.name
    elseif cfg.Names then
        ctx.name = data.LastOwnerName
    end

    ctx.tool = nil
    if cfg.Tool then
        local tool = ownerChar and ownerChar:FindFirstChildOfClass("Tool")
        ctx.tool = tool and tool.Name or "None"
    end

    ctx.flags = cfg.Flags and collectFlags(data, owner or vm, ownerChar or vm, ownerHum, cfg) or nil

    ctx.headPos = nil
    if cfg.HeadDot then
        ctx.headPos = partPosition(vm:FindFirstChild("head"))
    end

    ctx.boneMap = cfg.Skeleton and VM_BONE_MAP or nil
    ctx.lookup = data.VMLookup

    RenderESP(vm, data, cfg, ctx)
end

local function CreateItemESP(item)
    if espModule._itemDrawings[item] then return end
    espModule._itemDrawings[item] = {
        NameDistText = CreateText({ Size = 10, Font = getEspFont(espModule.Settings.TextFont) }),
        ContentsText = CreateText({ Size = 10, Font = getEspFont(espModule.Settings.TextFont) }),
        Touched = espModule._frame, Owner = nil, ContentsAt = 0,
    }
end

local function HideItemESP(item)
    local data = espModule._itemDrawings[item]
    if not data then return end
    data.NameDistText:Hide()
    data.ContentsText:Hide()
    local hl = espModule._itemHighlights[item]
    if hl then hl.Enabled = false end
end

local function RemoveItemESP(item)
    local data = espModule._itemDrawings[item]
    if not data then return end
    data.NameDistText:Destroy()
    data.ContentsText:Destroy()
    espModule._itemDrawings[item] = nil
    local hl = espModule._itemHighlights[item]
    if hl then
        hl:Destroy()
        espModule._itemHighlights[item] = nil
    end
end

function espModule:RemoveAI(name)
    if not self.CustomAIs[name] then return end
    self.CustomAIs[name] = nil
    for entity, data in pairs(self._drawings) do
        if data.Owner == name then RemoveESP(entity) end
    end
    fireRegistry()
end

function espModule:RemoveEntity(name)
    self:RemoveAI(name)
end

function espModule:RemoveItem(name)
    if not self.CustomItems[name] then return end
    self.CustomItems[name] = nil
    self.Settings.Items[name] = nil
    for item, data in pairs(self._itemDrawings) do
        if data.Owner == name then RemoveItemESP(item) end
    end
    fireRegistry()
end

local function DrawItem(item, name, entry, itemCfg, cfg, Camera, camPos, limit, now)
    CreateItemESP(item)
    local data = espModule._itemDrawings[item]
    data.Touched = espModule._frame
    data.Owner = name

    local pos = partPosition(item)
    if not pos then
        HideItemESP(item)
        return
    end
    local dist = (pos - camPos).Magnitude
    if dist > limit then
        HideItemESP(item)
        return
    end
    local sp = Camera:WorldToViewportPoint(pos)
    if sp.Z <= 0 then
        HideItemESP(item)
        return
    end

    local options = entry.Options
    local fade = espModule._fadeAlpha
    local trans = 1 - fade
    local color = itemCfg.Color or WHITE
    local size = cfg.TextSize
    local textFont = getEspFont(espModule.Settings.TextFont)
    local flagsFont = getEspFont(espModule.Settings.FlagsFont)

    local text
    if cfg.ShowNames or cfg.ShowDistance then
        local label = item.Name
        if cfg.ShowNames then
            local custom = options.Label
            if type(custom) == "function" then
                local ok, res = pcall(custom, item)
                if ok and res then label = tostring(res) end
            elseif custom ~= nil then
                label = tostring(custom)
            end
        end
        local meters = floor(dist)
        if cfg.ShowNames and cfg.ShowDistance then
            text = label .. " [" .. meters .. "m]"
        elseif cfg.ShowNames then
            text = label
        else
            text = "[" .. meters .. "m]"
        end
    end

    local nameLabel = data.NameDistText.Frame
    if text then
        if data.LastText ~= text then
            nameLabel.Text = text
            data.LastText = text
        end
        local font = cfg.ShowDistance and flagsFont or textFont
        if data.LastFont ~= font or data.LastSize ~= size then
            nameLabel.TextSize = size
            nameLabel.FontFace = font
            data.LastFont = font
            data.LastSize = size
        end
        nameLabel.TextColor3 = color
        nameLabel.Position = UDim2.fromOffset(sp.X, sp.Y - 12)
        nameLabel.Visible = true
        nameLabel.TextTransparency = trans
        nameLabel.TextStrokeTransparency = trans
    else
        data.NameDistText:Hide()
    end

    local contentsLabel = data.ContentsText.Frame
    local contents
    if cfg.ShowContents and type(options.Contents) == "function" then
        if now - data.ContentsAt > 0.5 then
            data.ContentsAt = now
            local ok, res = pcall(options.Contents, item)
            data.ContentsValue = ok and res and tostring(res) or nil
        end
        contents = data.ContentsValue
    end
    if contents and contents ~= "" then
        if #contents > 60 then contents = string.sub(contents, 1, 57) .. "..." end
        if data.LastContents ~= contents then
            contentsLabel.Text = contents
            data.LastContents = contents
        end
        if data.LastContentsSize ~= size then
            contentsLabel.TextSize = size - 1
            contentsLabel.FontFace = textFont
            data.LastContentsSize = size
        end
        contentsLabel.TextColor3 = color
        contentsLabel.Position = UDim2.fromOffset(sp.X, sp.Y + 16)
        contentsLabel.Visible = true
        contentsLabel.TextTransparency = trans
        contentsLabel.TextStrokeTransparency = trans
    else
        data.ContentsText:Hide()
    end

    if cfg.Chams then
        local hl = espModule._itemHighlights[item]
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name = "ItemHighlight"
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.OutlineTransparency = 1
            hl.Parent = espGui
            espModule._itemHighlights[item] = hl
        end
        hl.Adornee = item
        hl.FillColor = color
        hl.FillTransparency = 1 - ((1 - cfg.ChamsFillTransparency) * fade)
        hl.Enabled = true
    else
        local hl = espModule._itemHighlights[item]
        if hl then hl.Enabled = false end
    end
end

local function ProcessItems(Camera, now)
    local cfg = espModule.Settings.Items
    local camPos = Camera.CFrame.Position
    local limit = cfg.MaxDistance
    for name, entry in pairs(espModule.CustomItems) do
        local itemCfg = cfg[name]
        if type(itemCfg) == "table" and itemCfg.Enabled then
            local list = resolveList(entry, now)
            for i = 1, #list do
                local item = list[i]
                if typeof(item) == "Instance" and item.Parent then
                    DrawItem(item, name, entry, itemCfg, cfg, Camera, camPos, limit, now)
                end
            end
        end
    end
    local frame = espModule._frame
    for item, data in pairs(espModule._itemDrawings) do
        if data.Touched ~= frame or not item.Parent then RemoveItemESP(item) end
    end
end

local function espLoop()
    local s = espModule.Settings
    local anyEntity = s.Enemy.Enabled or s.Teammate.Enabled or s.AI.Enabled
    local anyItem = s.Items.Enabled

    if espModule._isDead then
        espModule._fadeAlpha = max(0, espModule._fadeAlpha - 0.05)
    else
        espModule._fadeAlpha = min(1, espModule._fadeAlpha + 0.05)
    end

    if not anyEntity then
        for entity in pairs(espModule._drawings) do RemoveESP(entity) end
    end
    if not anyItem then
        for item in pairs(espModule._itemDrawings) do RemoveItemESP(item) end
    end
    if not anyEntity and not anyItem then return end

    local now = os.clock()
    if now - (espModule._lastUpdate or 0) < 1 / clamp(s.RefreshRate or 144, 60, 240) then return end
    espModule._lastUpdate = now

    local camera = Services.WorkSpace.CurrentCamera
    Services.CurrentCamera = camera
    if not camera then return end

    espModule._frame += 1

    if anyEntity then
        if IS_OPERATION_ONE then
            local folder = Services.WorkSpace:FindFirstChild("Viewmodels")
            if folder then
                for _, vm in ipairs(folder:GetChildren()) do ProcessOperationOneVM(vm) end
            end
        else
            local players = Services.Players:GetPlayers()
            for i = 1, #players do
                local player = players[i]
                if player ~= Services.LocalPlayer then ProcessEntity(player) end
            end
        end

        for name, entry in pairs(espModule.CustomAIs) do
            local list = resolveList(entry, now)
            for i = 1, #list do
                local ent = list[i]
                if typeof(ent) == "Instance" and ent:IsA("Model") and ent.Parent then
                    ProcessEntity(ent, entry.Options, name)
                end
            end
        end

        local frame = espModule._frame
        for entity, data in pairs(espModule._drawings) do
            if data.Touched ~= frame then RemoveESP(entity) end
        end
    end

    if anyItem then ProcessItems(camera, now) end
end

function espModule:Start()
    if self._isRunning then return end
    self._isRunning = true
    loadFont()

    local function onCharacterAdded(char)
        local hum = char:WaitForChild("Humanoid", 10)
        espModule._isDead = false
        espModule._fadeAlpha = 1
        if hum then
            hum.Died:Connect(function() espModule._isDead = true end)
        end
    end
    if Services.LocalPlayer.Character then task.spawn(onCharacterAdded, Services.LocalPlayer.Character) end
    self._connections.CharacterAdded = Services.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
    self._connections.PlayerRemoving = Services.Players.PlayerRemoving:Connect(RemoveESP)

    Services.RunService:BindToRenderStep(STEP_NAME, Enum.RenderPriority.Camera.Value + 1, espLoop)
end

function espModule:Stop()
    if not self._isRunning then return end
    self._isRunning = false
    pcall(function() Services.RunService:UnbindFromRenderStep(STEP_NAME) end)
    for _, conn in pairs(self._connections) do conn:Disconnect() end
    self._connections = {}
    for entity in pairs(self._drawings) do RemoveESP(entity) end
    for item in pairs(self._itemDrawings) do RemoveItemESP(item) end
end

function espModule:Restart()
    self:Stop()
    self:Start()
end

function espModule:Destroy()
    self:Stop()
    espGui:Destroy()
end

function espModule:Toggle()
    if self._isRunning then self:Stop() else self:Start() end
end

function espModule:UpdateSettings(newSettings)
    local function merge(dst, src)
        for k, v in pairs(src) do
            if type(v) == "table" and type(dst[k]) == "table" then
                merge(dst[k], v)
            else
                dst[k] = v
            end
        end
    end
    merge(self.Settings, newSettings)
end

function espModule:GetSettings()
    return self.Settings
end

return espModule
