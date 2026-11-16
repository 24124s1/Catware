local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local lp = Players.LocalPlayer
local rgb = Color3.fromRGB
local clamp = math.clamp
local floor = math.floor

local function getParent()
    if typeof(gethui) == "function" then
        local ok, ui = pcall(gethui)
        if ok and ui then return ui end
    end
    if not RunService:IsStudio() then
        local ok, cg = pcall(function() return game:GetService("CoreGui") end)
        if ok and cg then
            local ok2 = pcall(function() return #cg:GetChildren() end)
            if ok2 then return cg end
        end
    end
    return lp:WaitForChild("PlayerGui")
end

local espModule = {}

espModule.Settings = {
    RefreshRate = 144,
    TextFont = "Gojiberry Quibble",
    FlagsFont = "Gojiberry Quibble",
    HealthFont = "Gojiberry Quibble",
    TextGradientAnimated = true,
    Enemy = {
        Enabled = false, BoxEnabled = false, BoxType = "Corner", Thickness = 1,
        BoxGlow = false, BoxFill = false, BoxFillColor1 = rgb(255, 80, 80),
        BoxFillColor2 = rgb(255, 40, 40), BoxFillTransparency = 0.7,
        BoxFillRotation = 0, BoxFillSpeed = 2, Chams = false,
        ChamsColor = rgb(255, 80, 80), ChamsGlow = false, ChamsFillTransparency = 0.3,
        Names = false, NameType = "Display", Distance = false, Tool = false,
        Flags = false, SelectedFlags = {"Walking", "Jumping", "Swimming", "Dih"},
        FlagColor1 = rgb(255, 255, 255), FlagColor2 = rgb(200, 200, 200),
        HealthBar = false, HealthText = false, ArmorBar = false,
        ArmorHigh = rgb(0, 255, 0), ArmorMid = rgb(255, 255, 0), ArmorLow = rgb(255, 0, 0),
        HeadDot = false, HeadDotColor = rgb(255, 255, 255), HeadDotSize = 20,
        HeadDotOutlineThickness = 1, TextSize = 12, Skeleton = false,
        SkeletonThickness = 1, SkeletonColor = rgb(255, 80, 80),
        SkeletonColor2 = rgb(200, 200, 200), Tracers = false, TracerThickness = 1,
        TracerOrigin = "Bottom", LineColor = rgb(255, 80, 80),
        NameColor = rgb(255, 255, 255), NameColor2 = rgb(200, 200, 200),
        DistanceColor = rgb(255, 255, 255), DistanceColor2 = rgb(200, 200, 200),
        ToolColor = rgb(255, 255, 255), ToolColor2 = rgb(200, 200, 200),
        HealthHigh = rgb(0, 255, 100), HealthMid = rgb(255, 255, 0),
        HealthLow = rgb(255, 40, 40), TracerColor = rgb(255, 80, 80),
    },
    Teammate = {
        Enabled = false, BoxEnabled = false, BoxType = "Corner", Thickness = 1,
        BoxGlow = false, BoxFill = false, BoxFillColor1 = rgb(0, 180, 255),
        BoxFillColor2 = rgb(0, 100, 200), BoxFillTransparency = 0.7,
        BoxFillRotation = 0, BoxFillSpeed = 2, Chams = false,
        ChamsColor = rgb(0, 180, 255), ChamsGlow = false, ChamsFillTransparency = 0.3,
        Names = false, NameType = "Display", Distance = false, Tool = false,
        Flags = false, SelectedFlags = {"Walking", "Jumping", "Swimming", "Dih"},
        FlagColor1 = rgb(255, 255, 255), FlagColor2 = rgb(200, 200, 200),
        HealthBar = false, HealthText = false, ArmorBar = false,
        ArmorHigh = rgb(0, 255, 0), ArmorMid = rgb(255, 255, 0), ArmorLow = rgb(255, 0, 0),
        HeadDot = false, HeadDotColor = rgb(255, 255, 255), HeadDotSize = 20,
        HeadDotOutlineThickness = 1, TextSize = 12, Skeleton = false,
        SkeletonThickness = 1, SkeletonColor = rgb(0, 180, 255),
        SkeletonColor2 = rgb(100, 150, 200), Tracers = false, TracerThickness = 1,
        TracerOrigin = "Bottom", LineColor = rgb(0, 180, 255),
        NameColor = rgb(180, 230, 255), NameColor2 = rgb(100, 150, 200),
        DistanceColor = rgb(180, 230, 255), DistanceColor2 = rgb(100, 150, 200),
        ToolColor = rgb(180, 230, 255), ToolColor2 = rgb(100, 150, 200),
        HealthHigh = rgb(0, 200, 255), HealthMid = rgb(100, 200, 255),
        HealthLow = rgb(30, 80, 140), TracerColor = rgb(0, 180, 255),
    },
    AI = {
        Enabled = false, BoxEnabled = false, BoxType = "Corner", Thickness = 1,
        BoxGlow = false, BoxFill = false, BoxFillColor1 = rgb(255, 200, 50),
        BoxFillColor2 = rgb(255, 150, 0), BoxFillTransparency = 0.7,
        BoxFillRotation = 0, BoxFillSpeed = 2, Chams = false,
        ChamsColor = rgb(255, 200, 50), ChamsGlow = false, ChamsFillTransparency = 0.3,
        Names = false, NameType = "Display", Distance = false, Tool = false,
        Flags = false, SelectedFlags = {"Walking", "Jumping", "Swimming", "Dih"},
        FlagColor1 = rgb(255, 255, 255), FlagColor2 = rgb(200, 200, 200),
        HealthBar = false, HealthText = false, ArmorBar = false,
        ArmorHigh = rgb(0, 255, 0), ArmorMid = rgb(255, 255, 0), ArmorLow = rgb(255, 0, 0),
        HeadDot = false, HeadDotColor = rgb(255, 255, 255), HeadDotSize = 20,
        HeadDotOutlineThickness = 1, TextSize = 12, Skeleton = false,
        SkeletonThickness = 1, SkeletonColor = rgb(255, 200, 50),
        SkeletonColor2 = rgb(200, 150, 50), Tracers = false, TracerThickness = 1,
        TracerOrigin = "Bottom", LineColor = rgb(255, 200, 50),
        NameColor = rgb(255, 255, 255), NameColor2 = rgb(200, 200, 200),
        DistanceColor = rgb(255, 255, 255), DistanceColor2 = rgb(200, 200, 200),
        ToolColor = rgb(255, 255, 255), ToolColor2 = rgb(200, 200, 200),
        HealthHigh = rgb(0, 255, 100), HealthMid = rgb(255, 255, 0),
        HealthLow = rgb(255, 40, 40), TracerColor = rgb(255, 200, 50),
    },
    Items = {
        Enabled = false, MaxDistance = 200, TextSize = 12,
        ShowNames = false, ShowDistance = false, ShowContents = false,
        Chams = false, ChamsFillTransparency = 0.3,
        Safe = {Enabled = false, Color = rgb(192, 192, 192)},
        CivilianAirdrop = {Enabled = false, Color = rgb(255, 140, 0)},
        AbandonedCar = {Enabled = false, Color = rgb(169, 169, 169)},
        DuffelBag = {Enabled = false, Color = rgb(139, 69, 19)},
        FoodCrate = {Enabled = false, Color = rgb(0, 255, 0)},
        LeatherPouch = {Enabled = false, Color = rgb(160, 82, 45)},
        SupplyCrate = {Enabled = false, Color = rgb(0, 191, 255)},
        MedicalPouch = {Enabled = false, Color = rgb(255, 20, 20)},
        TCRCrate = {Enabled = false, Color = rgb(192, 192, 192)},
        MetalCrate = {Enabled = false, Color = rgb(255, 140, 0)},
        TallMetalCrate = {Enabled = false, Color = rgb(169, 169, 169)},
        SpecopsCrate = {Enabled = false, Color = rgb(139, 69, 19)},
        AmmoBox = {Enabled = false, Color = rgb(0, 255, 0)},
        WoodenCrate = {Enabled = false, Color = rgb(160, 82, 45)},
        DroppedItemContainer = {Enabled = false, Color = rgb(255, 105, 180)},
        Dead = {Enabled = false, Color = rgb(255, 0, 0)},
    }
}

espModule._drawings = {}
espModule._itemDrawings = {}
espModule._itemHighlights = {}
espModule._isRunning = false
espModule._connections = {}
espModule._bots = {}
espModule._containers = {}
espModule.Fonts = {}
espModule._boxFillAngles = {}
espModule._fadeAlpha = 1
espModule._isDead = false
espModule.CustomFlags = {}

function espModule:AddFlag(name, func)
    self.CustomFlags[name] = {Func = func}
end

local cloneref = cloneref or function(...) return ... end
local GetService = setmetatable({}, {
    __index = function(self, key)
        return cloneref(game:GetService(key))
    end
})

local Services = {
    RunService = GetService.RunService,
    Players = GetService.Players,
    CoreGui = GetService.CoreGui,
    WorkSpace = GetService.Workspace,
    HttpService = GetService.HttpService,
    TextService = GetService.TextService,
    UserInputService = GetService.UserInputService,
    TweenService = GetService.TweenService,
}
Services.CurrentCamera = Services.WorkSpace.CurrentCamera
Services.LocalPlayer = Services.Players.LocalPlayer

local gethui = gethui or function() return Services.CoreGui end
local espGui = Instance.new("ScreenGui")
espGui.Name = "ESPModuleGui"
espGui.IgnoreGuiInset = true
espGui.ResetOnSpawn = false
espGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() espGui.Parent = gethui() end)
if not espGui.Parent then espGui.Parent = Services.CoreGui end

local MAX_ENTITY_DIST = 1200
local MAX_ITEM_DIST_MULT = 2.81
local PLACE_ID = game.PlaceId

local GamePlaces = {[79783567666809] = true, [138485390344924] = true}
local HAS_BOTS_ITEMS = GamePlaces[PLACE_ID] or false
local HAS_CUSTOM_CHARS = PLACE_ID == 138485390344924

local BOX_3D_EDGES = {
    {1,2}, {2,3}, {3,4}, {4,1},
    {5,6}, {6,7}, {7,8}, {8,5},
    {1,5}, {2,6}, {3,7}, {4,8}
}

local ItemConfigs = {
    ["Safe"] = "Safe", ["Civilian Airdrop"] = "CivilianAirdrop", ["Abandoned Car"] = "AbandonedCar",
    ["Duffel Bag"] = "DuffelBag", ["Food Crate"] = "FoodCrate", ["Leather Pouch"] = "LeatherPouch",
    ["Supply Crate"] = "SupplyCrate", ["Medical Pouch"] = "MedicalPouch", ["DroppedItemContainer"] = "DroppedItemContainer",
    ["T.C.R Supply Crate"] = "TCRCrate", ["Metal Crate"] = "MetalCrate", ["Specops Supply Crate"] = "SpecopsCrate",
    ["Tall Metal Crate"] = "TallMetalCrate", ["Wooden Crate"] = "WoodenCrate", ["Ammo Box"] = "AmmoBox", ["Dead"] = "Dead"
}

local ItemKeywords = {
    "Safe", "Civilian Airdrop", "Abandoned Car", "Duffel Bag", "Food Crate", "Leather Pouch", "Supply Crate", "Medical Pouch",
    "DroppedItemContainer", "T.C.R Supply Crate", "Metal Crate", "Specops Supply Crate", "Tall Metal Crate", "Wooden Crate", "Ammo Box"
}

local function loadFont()
    if next(espModule.Fonts) then return end
    local function FontsRegister(Name, Weight, Style, Asset)
        local success, result = pcall(function()
            if not isfile(Asset.Id) then writefile(Asset.Id, Asset.Font) end
            if isfile(Name .. ".font") then delfile(Name .. ".font") end
            local Info = {name = Name, faces = {{name = "Normal", weight = Weight, style = Style, assetId = getcustomasset(Asset.Id)}}}
            writefile(Name .. ".font", Services.HttpService:JSONEncode(Info))
            return getcustomasset(Name .. ".font")
        end)
        if success and result then
            return Font.new(result, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        end
        return nil
    end

    local fontList = {
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

    for _, entry in ipairs(fontList) do
        local Name, Id, Url = entry[1], entry[2], entry[3]
        local fontContent = nil
        pcall(function()
            if isfile(Id) then fontContent = readfile(Id) end
        end)
        if not fontContent or #fontContent < 100 then
            pcall(function()
                local content = game:HttpGet(Url)
                if content and #content > 100 then
                    writefile(Id, content)
                    fontContent = content
                end
            end)
        end
        if fontContent then
            local f = FontsRegister(Name, 400, "Normal", {Id = Id, Font = fontContent})
            if f then espModule.Fonts[Name] = f end
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
        if character and character:FindFirstChild("SquadBillboard") then return true end
        return false
    end
end

local function getEspFont(fontName)
    if fontName and espModule.Fonts[fontName] then return espModule.Fonts[fontName] end
    return Font.new("rbxasset://fonts/families/GothamSSm.json")
end

local function GetHealthColor(t, high, mid, low)
    t = math.clamp(t, 0, 1)
    if t >= 0.5 then return mid:Lerp(high, (t - 0.5) * 2)
    else return low:Lerp(mid, t * 2) end
end

local function CreateLine(props)
    local frame = Instance.new("Frame")
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BorderSizePixel = 0
    frame.BackgroundColor3 = props.Color or Color3.new(1, 1, 1)
    frame.Visible = props.Visible or false
    frame.ZIndex = props.ZIndex or 2
    frame.Parent = espGui

    local stroke = Instance.new("UIStroke")
    stroke.Name = "LineOutline"
    stroke.Color = props.OutlineColor or Color3.new(0, 0, 0)
    stroke.Thickness = props.OutlineThickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = frame

    local gradient = Instance.new("UIGradient")
    gradient.Parent = frame

    local obj = {Frame = frame, Stroke = stroke, Gradient = gradient, Thickness = props.Thickness or 1, OutlineThickness = props.OutlineThickness or 1, Color = props.Color or Color3.new(1, 1, 1)}

    function obj:Set(from, to)
        if not from or not to then frame.Visible = false return end
        local dist = (to - from).Magnitude
        local center = from:Lerp(to, 0.5)
        local angle = math.deg(math.atan2(to.Y - from.Y, to.X - from.X))
        frame.Position = UDim2.fromOffset(center.X, center.Y)
        frame.Size = UDim2.fromOffset(math.max(dist, 1), self.Thickness)
        frame.Rotation = angle
        frame.Visible = true
    end
    function obj:SetColor(color) self.Color = color frame.BackgroundColor3 = color end
    function obj:SetThickness(t) self.Thickness = t end
    function obj:SetOutlineThickness(t) self.OutlineThickness = t stroke.Thickness = t end
    function obj:Hide() frame.Visible = false end
    function obj:Destroy() frame:Destroy() end
    return obj
end

local function CreateText(props)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = props.Text or ""
    label.TextSize = props.Size or 10
    label.TextColor3 = props.Color or Color3.new(1, 1, 1)
    label.TextStrokeTransparency = props.Outline and 0 or 1
    label.TextStrokeColor3 = props.OutlineColor or Color3.new(0, 0, 0)
    label.FontFace = props.Font or Font.new("rbxasset://fonts/families/GothamSSm.json")
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.AnchorPoint = Vector2.new(0.5, 0.5)
    label.AutomaticSize = Enum.AutomaticSize.XY
    label.Size = UDim2.fromOffset(0, 0)
    label.Visible = props.Visible or false
    label.ZIndex = props.ZIndex or 1
    label.Parent = espGui

    local uiGradient = Instance.new("UIGradient")
    uiGradient.Name = "TextGradient"
    uiGradient.Parent = label

    local obj = {Frame = label}
    function obj:Hide() label.Visible = false end
    function obj:Destroy() label:Destroy() end
    return obj
end

local function MakeBone()
    return CreateLine({Thickness = 1, OutlineThickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2})
end

local function getCharacterParts(character)
    local isR15 = character:FindFirstChild("UpperTorso") ~= nil
    local parts
    if isR15 then
        parts = {"HumanoidRootPart", "Head", "UpperTorso", "LowerTorso", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand"}
    else
        parts = {"HumanoidRootPart", "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
    end
    return parts, isR15
end

local function CreateEntityESP(entity)
    if espModule._drawings[entity] then return end

    local boxFill = Instance.new("Frame")
    boxFill.BackgroundColor3 = Color3.new(1, 1, 1)
    boxFill.BorderSizePixel = 0
    boxFill.Visible = false
    boxFill.ZIndex = 1
    boxFill.Parent = espGui

    local boxFillGradient = Instance.new("UIGradient")
    boxFillGradient.Parent = boxFill

    local boxFillHighlight = Instance.new("Highlight")
    boxFillHighlight.Name = "BoxFillHighlight"
    boxFillHighlight.Parent = espGui
    boxFillHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    boxFillHighlight.Enabled = false

    local playerChams = Instance.new("Highlight")
    playerChams.Name = "PlayerChams"
    playerChams.Parent = espGui
    playerChams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    playerChams.Enabled = false

    local boxGlow = Instance.new("ImageLabel")
    boxGlow.Name = "BoxGlow"
    boxGlow.Image = "rbxassetid://110204605000367"
    boxGlow.ScaleType = Enum.ScaleType.Slice
    boxGlow.SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
    boxGlow.AutomaticSize = Enum.AutomaticSize.XY
    boxGlow.ImageTransparency = 0.65
    boxGlow.ResampleMode = Enum.ResamplerMode.Pixelated
    boxGlow.Visible = false
    boxGlow.BackgroundTransparency = 1
    boxGlow.Position = UDim2.fromOffset(-21, -21)
    boxGlow.Size = UDim2.fromOffset(0, 0)
    boxGlow.BorderSizePixel = 0
    boxGlow.BorderColor3 = Color3.fromRGB(0, 0, 0)
    boxGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    boxGlow.ZIndex = 0
    boxGlow.Parent = espGui

    local boxGlowGradient = Instance.new("UIGradient")
    boxGlowGradient.Rotation = 90
    boxGlowGradient.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0))
    boxGlowGradient.Transparency = NumberSequence.new(0, 0)
    boxGlowGradient.Parent = boxGlow

    local boxGlowPadding = Instance.new("UIPadding")
    boxGlowPadding.PaddingTop = UDim.new(0, 21)
    boxGlowPadding.PaddingBottom = UDim.new(0, 20)
    boxGlowPadding.PaddingLeft = UDim.new(0, 21)
    boxGlowPadding.PaddingRight = UDim.new(0, 20)
    boxGlowPadding.Parent = boxGlow

    local headDot = Instance.new("Frame")
    headDot.BackgroundColor3 = Color3.new(1, 1, 1)
    headDot.BackgroundTransparency = 0
    headDot.BorderSizePixel = 0
    headDot.AnchorPoint = Vector2.new(0.5, 0.5)
    headDot.Visible = false
    headDot.ZIndex = 6
    headDot.Parent = espGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(1, 0)
    uiCorner.Parent = headDot

    local dotStroke = Instance.new("UIStroke")
    dotStroke.Name = "DotStroke"
    dotStroke.Color = Color3.new(0, 0, 0)
    dotStroke.Thickness = 1
    dotStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    dotStroke.Parent = headDot

    local box3dLines = {}
    for i = 1, 12 do
        box3dLines["L"..i] = CreateLine({Thickness = 1, OutlineThickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2})
    end

    local healthContainer = Instance.new("Frame")
    healthContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    healthContainer.BorderSizePixel = 0
    healthContainer.Visible = false
    healthContainer.ZIndex = 2
    healthContainer.Parent = espGui

    local healthStroke = Instance.new("UIStroke")
    healthStroke.Color = Color3.new(0, 0, 0)
    healthStroke.Thickness = 1
    healthStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    healthStroke.Parent = healthContainer

    local healthFill = Instance.new("Frame")
    healthFill.BackgroundColor3 = Color3.new(1, 1, 1)
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
    armorContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    armorContainer.BorderSizePixel = 0
    armorContainer.Visible = false
    armorContainer.ZIndex = 2
    armorContainer.Parent = espGui

    local armorStroke = Instance.new("UIStroke")
    armorStroke.Color = Color3.new(0, 0, 0)
    armorStroke.Thickness = 1
    armorStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    armorStroke.Parent = armorContainer

    local armorFill = Instance.new("Frame")
    armorFill.BackgroundColor3 = Color3.new(1, 1, 1)
    armorFill.BorderSizePixel = 0
    armorFill.AnchorPoint = Vector2.new(0, 0)
    armorFill.Position = UDim2.fromScale(0, 0)
    armorFill.Size = UDim2.fromScale(1, 1)
    armorFill.Visible = false
    armorFill.ZIndex = 3
    armorFill.Parent = armorContainer

    local armorGradient = Instance.new("UIGradient")
    armorGradient.Rotation = 0
    armorGradient.Parent = armorFill

    local flagsFrame = Instance.new("Frame")
    flagsFrame.BackgroundTransparency = 1
    flagsFrame.Visible = false
    flagsFrame.ZIndex = 5
    flagsFrame.Parent = espGui

    local flagsLayout = Instance.new("UIListLayout")
    flagsLayout.Parent = flagsFrame
    flagsLayout.Padding = UDim.new(0, 0)
    flagsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    flagsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left

    espModule._drawings[entity] = {
        Full = {
            Top = CreateLine({Thickness = 1, OutlineThickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            Bottom = CreateLine({Thickness = 1, OutlineThickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            Left = CreateLine({Thickness = 1, OutlineThickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            Right = CreateLine({Thickness = 1, OutlineThickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
        },
        Corner = {
            TL1 = CreateLine({Thickness = 1, OutlineThickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            TL2 = CreateLine({Thickness = 1, OutlineThickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            TR1 = CreateLine({Thickness = 1, OutlineThickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            TR2 = CreateLine({Thickness = 1, OutlineThickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            BL1 = CreateLine({Thickness = 1, OutlineThickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            BL2 = CreateLine({Thickness = 1, OutlineThickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            BR1 = CreateLine({Thickness = 1, OutlineThickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            BR2 = CreateLine({Thickness = 1, OutlineThickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
        },
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
        HealthText = CreateText({Center = false, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = getEspFont(espModule.Settings.HealthFont), Visible = false, ZIndex = 5}),
        NameText = CreateText({Center = true, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = getEspFont(espModule.Settings.TextFont), Visible = false, ZIndex = 5}),
        DistanceText = CreateText({Center = false, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = getEspFont(espModule.Settings.FlagsFont), Visible = false, ZIndex = 5}),
        ToolText = CreateText({Center = true, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = getEspFont(espModule.Settings.TextFont), Visible = false, ZIndex = 5}),
        Tracer = CreateLine({Thickness = 1, OutlineThickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
        Skeleton = {
            HeadTorso = MakeBone(), TorsoHip = MakeBone(), HipL = MakeBone(),
            HipR = MakeBone(), LLeg = MakeBone(), RLeg = MakeBone(),
            LArm = MakeBone(), RArm = MakeBone(), LFore = MakeBone(), RFore = MakeBone(),
        }
    }
end

local function HideESP(data)
    if not data then return end
    local f = data.Full
    f.Top:Hide() f.Bottom:Hide() f.Left:Hide() f.Right:Hide()
    local c = data.Corner
    c.TL1:Hide() c.TL2:Hide() c.TR1:Hide() c.TR2:Hide()
    c.BL1:Hide() c.BL2:Hide() c.BR1:Hide() c.BR2:Hide()
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
    for _, v in pairs(data.Full) do v:Destroy() end
    for _, v in pairs(data.Corner) do v:Destroy() end
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

local function CreateItemESP(item)
    if espModule._itemDrawings[item] then return end
    espModule._itemDrawings[item] = {
        NameDistText = CreateText({Center = true, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = getEspFont(espModule.Settings.TextFont), Visible = false, ZIndex = 5}),
        ContentsText = CreateText({Center = true, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = getEspFont(espModule.Settings.TextFont), Visible = false, ZIndex = 5}),
    }
end

local function RemoveItemESP(item)
    local data = espModule._itemDrawings[item]
    if not data then return end
    data.NameDistText:Destroy()
    data.ContentsText:Destroy()
    espModule._itemDrawings[item] = nil
    if espModule._itemHighlights[item] then
        espModule._itemHighlights[item]:Destroy()
        espModule._itemHighlights[item] = nil
    end
end

local function ProcessItem(item)
    if not HAS_BOTS_ITEMS then return end
    if not item:IsA("Model") then return end
    local cfg = espModule.Settings.Items
    if not cfg.Enabled then RemoveItemESP(item) return end

    local camera = Services.CurrentCamera
    if not camera then return end
    local pivot = item:GetPivot()
    if not pivot then return end

    local pos, onScreen = camera:WorldToViewportPoint(pivot.Position)
    if not onScreen or pos.Z <= 0 then
        local data = espModule._itemDrawings[item]
        if data then
            data.NameDistText:Hide()
            data.ContentsText:Hide()
            if espModule._itemHighlights[item] then espModule._itemHighlights[item].Enabled = false end
        end
        return
    end

    local dist = (camera.CFrame.Position - pivot.Position).Magnitude
    if dist > cfg.MaxDistance * MAX_ITEM_DIST_MULT then
        local data = espModule._itemDrawings[item]
        if data then
            data.NameDistText:Hide()
            data.ContentsText:Hide()
            if espModule._itemHighlights[item] then espModule._itemHighlights[item].Enabled = false end
        end
        return
    end

    local itemName = item.Name
    local itemType = nil
    local isDead = false

    for i = 1, #ItemKeywords do
        if string.find(itemName, ItemKeywords[i], 1, true) then
            itemType = ItemKeywords[i]
            break
        end
    end

    if string.find(itemName, "Dead", 1, true) then
        isDead = true
        if not itemType then itemType = "Dead" end
    end

    if not itemType then RemoveItemESP(item) return end
    local settingsKey = ItemConfigs[itemType]
    if not settingsKey then RemoveItemESP(item) return end

    if isDead then
        if not cfg.Dead.Enabled then RemoveItemESP(item) return end
        settingsKey = "Dead"
    end

    local itemCfg = cfg[settingsKey]
    if not itemCfg or not itemCfg.Enabled then RemoveItemESP(item) return end

    CreateItemESP(item)
    local data = espModule._itemDrawings[item]
    local color = itemCfg.Color or rgb(255, 255, 255)
    local textSize = cfg.TextSize
    local showNames = cfg.ShowNames
    local showDist = cfg.ShowDistance
    local showContents = cfg.ShowContents
    local textFont = getEspFont(espModule.Settings.TextFont)
    local flagsFont = getEspFont(espModule.Settings.FlagsFont)

    local nameDistStr = ""
    if showNames then nameDistStr = itemName end
    if showDist then
        local distM = math.floor(dist / 2.81 + 0.5)
        if showNames then nameDistStr = nameDistStr .. " [" .. distM .. "m]"
        else nameDistStr = "[" .. distM .. "m]" end
    end

    if nameDistStr ~= "" then
        if data.LastNameDistStr ~= nameDistStr then
            data.NameDistText.Frame.Text = nameDistStr
            data.LastNameDistStr = nameDistStr
        end
        if data.LastNameDistFont ~= (showDist and flagsFont or textFont) or data.LastNameDistSize ~= textSize then
            data.NameDistText.Frame.TextSize = textSize
            data.NameDistText.Frame.FontFace = showDist and flagsFont or textFont
            data.LastNameDistFont = showDist and flagsFont or textFont
            data.LastNameDistSize = textSize
        end
        data.NameDistText.Frame.TextColor3 = color
        data.NameDistText.Frame.Position = UDim2.fromOffset(pos.X, pos.Y - 12)
        data.NameDistText.Frame.Visible = true
        data.NameDistText.Frame.TextTransparency = 1 - espModule._fadeAlpha
        data.NameDistText.Frame.TextStrokeTransparency = 1 - espModule._fadeAlpha
    else
        data.NameDistText:Hide()
    end

    if showContents then
        local slots = item:FindFirstChild("Slots")
        local contents = {}
        if slots then
            for _, slot in ipairs(slots:GetChildren()) do
                if string.match(slot.Name, "^Slot%d+$") then
                    local itemNameVal = slot:FindFirstChild("ItemName")
                    local stackVal = slot:FindFirstChild("Stack")
                    if itemNameVal and stackVal and stackVal:IsA("IntValue") and stackVal.Value > 0 then
                        local name = itemNameVal:IsA("StringValue") and itemNameVal.Value or tostring(itemNameVal)
                        contents[#contents + 1] = name .. " (" .. stackVal.Value .. ")"
                    end
                end
            end
        end
        if #contents > 0 then
            local contentStr = table.concat(contents, " | ")
            if #contentStr > 60 then contentStr = string.sub(contentStr, 1, 57) .. "..." end
            if data.LastContentStr ~= contentStr then
                data.ContentsText.Frame.Text = contentStr
                data.LastContentStr = contentStr
            end
            if data.LastContentFont ~= textFont or data.LastContentSize ~= (textSize - 1) then
                data.ContentsText.Frame.TextSize = textSize - 1
                data.ContentsText.Frame.FontFace = textFont
                data.LastContentFont = textFont
                data.LastContentSize = textSize - 1
            end
            data.ContentsText.Frame.TextColor3 = color
            data.ContentsText.Frame.Position = UDim2.fromOffset(pos.X, pos.Y + 16)
            data.ContentsText.Frame.Visible = true
            data.ContentsText.Frame.TextTransparency = 1 - espModule._fadeAlpha
            data.ContentsText.Frame.TextStrokeTransparency = 1 - espModule._fadeAlpha
        else
            data.ContentsText:Hide()
        end
    else
        data.ContentsText:Hide()
    end

    if cfg.Chams then
        local hl = espModule._itemHighlights[item]
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name = "ItemHighlight"
            hl.Parent = espGui
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            espModule._itemHighlights[item] = hl
        end
        hl.Adornee = item
        hl.FillColor = color
        hl.OutlineColor = Color3.new(0, 0, 0)
        hl.FillTransparency = 1 - ((1 - cfg.ChamsFillTransparency) * espModule._fadeAlpha)
        hl.OutlineTransparency = 1
        hl.Enabled = true
    else
        if espModule._itemHighlights[item] then espModule._itemHighlights[item].Enabled = false end
    end
end

local function ApplyGradient(textObj, color1, color2)
    local grad = textObj.Frame:FindFirstChild("TextGradient")
    if grad then
        if grad:GetAttribute("C1") ~= color1 or grad:GetAttribute("C2") ~= color2 then
            grad.Color = ColorSequence.new(color1, color2)
            grad:SetAttribute("C1", color1)
            grad:SetAttribute("C2", color2)
        end
        if espModule.Settings.TextGradientAnimated then
            grad.Rotation = (tick() * 100) % 360
        else
            grad.Rotation = 0
        end
    end
end

local function ProcessEntity(entity)
    if entity == Services.LocalPlayer then return end
    local character, isPlayer
    if typeof(entity) == "Instance" and entity:IsA("Player") then
        isPlayer = true
        character = entity.Character
    else
        character = entity
    end

    if not character or not character:IsA("Model") then
        HideESP(espModule._drawings[entity])
        return
    end

    if isPlayer then
        local inRaid = entity:FindFirstChild("InRaid")
        if inRaid and inRaid:IsA("BoolValue") and not inRaid.Value then
            HideESP(espModule._drawings[entity])
            return
        end
    end

    local cfg = isPlayer and (IsTeam(entity) and espModule.Settings.Teammate or espModule.Settings.Enemy) or espModule.Settings.AI
    if not cfg.Enabled then RemoveESP(entity) return end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not (hrp and humanoid and humanoid.Health > 0) then HideESP(espModule._drawings[entity]) return end

    local Camera = Services.CurrentCamera
    if not Camera then return end
    local rawStuds = (Camera.CFrame.Position - hrp.Position).Magnitude
    if rawStuds > MAX_ENTITY_DIST then HideESP(espModule._drawings[entity]) return end

    local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
    if hrpPos.Z <= 0 then HideESP(espModule._drawings[entity]) return end

    CreateEntityESP(entity)
    local data = espModule._drawings[entity]
    if not data then return end

    local parts, isR15 = getCharacterParts(character)
    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge
    local validParts = 0
    local p = {}
    local vis = {}
    local minVec = Vector3.new(math.huge, math.huge, math.huge)
    local maxVec = Vector3.new(-math.huge, -math.huge, -math.huge)

    local function expandBounds(part)
        if not part or not part:IsA("BasePart") then return end
        local cf = part.CFrame
        local size = part.Size
        local corners3D = {
            cf * Vector3.new(size.X/2, size.Y/2, size.Z/2),
            cf * Vector3.new(-size.X/2, size.Y/2, size.Z/2),
            cf * Vector3.new(-size.X/2, -size.Y/2, size.Z/2),
            cf * Vector3.new(size.X/2, -size.Y/2, size.Z/2),
            cf * Vector3.new(size.X/2, size.Y/2, -size.Z/2),
            cf * Vector3.new(-size.X/2, size.Y/2, -size.Z/2),
            cf * Vector3.new(-size.X/2, -size.Y/2, -size.Z/2),
            cf * Vector3.new(size.X/2, -size.Y/2, -size.Z/2)
        }
        for i = 1, 8 do
            local c = corners3D[i]
            if c.X < minVec.X then minVec = Vector3.new(c.X, minVec.Y, minVec.Z) end
            if c.Y < minVec.Y then minVec = Vector3.new(minVec.X, c.Y, minVec.Z) end
            if c.Z < minVec.Z then minVec = Vector3.new(minVec.X, minVec.Y, c.Z) end
            if c.X > maxVec.X then maxVec = Vector3.new(c.X, maxVec.Y, maxVec.Z) end
            if c.Y > maxVec.Y then maxVec = Vector3.new(maxVec.X, c.Y, maxVec.Z) end
            if c.Z > maxVec.Z then maxVec = Vector3.new(maxVec.X, maxVec.Y, c.Z) end
        end
    end

    for _, partName in ipairs(parts) do
        expandBounds(character:FindFirstChild(partName))
    end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Accessory") then expandBounds(child:FindFirstChild("Handle")) end
    end

    if minVec.X < math.huge then
        local globalCorners = {
            Vector3.new(maxVec.X, maxVec.Y, maxVec.Z),
            Vector3.new(minVec.X, maxVec.Y, maxVec.Z),
            Vector3.new(minVec.X, minVec.Y, maxVec.Z),
            Vector3.new(maxVec.X, minVec.Y, maxVec.Z),
            Vector3.new(maxVec.X, maxVec.Y, minVec.Z),
            Vector3.new(minVec.X, maxVec.Y, minVec.Z),
            Vector3.new(minVec.X, minVec.Y, minVec.Z),
            Vector3.new(maxVec.X, minVec.Y, minVec.Z)
        }
        for i = 1, 8 do
            local pos, on = Camera:WorldToViewportPoint(globalCorners[i])
            p[i] = Vector2.new(pos.X, pos.Y)
            vis[i] = on and pos.Z > 0
            if vis[i] then
                validParts = validParts + 1
                if pos.X < minX then minX = pos.X end
                if pos.Y < minY then minY = pos.Y end
                if pos.X > maxX then maxX = pos.X end
                if pos.Y > maxY then maxY = pos.Y end
            end
        end
    end

    local shouldDrawBox = validParts > 0 and onScreen
    local pad = 4

    if shouldDrawBox then
        local x = math.floor(minX - pad + 0.5)
        local y = math.floor(minY - pad + 0.5)
        local sx = math.max(math.floor(maxX - minX + pad * 2 + 0.5), 8)
        local sy = math.max(math.floor(maxY - minY + pad * 2 + 0.5), 8)
        local meters = math.floor(rawStuds / 2.81 + 0.5)
        local textFont = getEspFont(espModule.Settings.TextFont)
        local flagsFont = getEspFont(espModule.Settings.FlagsFont)
        local healthFont = getEspFont(espModule.Settings.HealthFont)

        if cfg.BoxFill and cfg.BoxEnabled then
            if cfg.BoxType == "3D" then
                data.BoxFill.Visible = false
                data.BoxFillHighlight.Adornee = character
                data.BoxFillHighlight.FillColor = cfg.BoxFillColor1
                data.BoxFillHighlight.OutlineColor = cfg.LineColor
                data.BoxFillHighlight.FillTransparency = 1 - ((1 - cfg.BoxFillTransparency) * espModule._fadeAlpha)
                data.BoxFillHighlight.OutlineTransparency = 1
                data.BoxFillHighlight.Enabled = true
            else
                data.BoxFillHighlight.Enabled = false
                if not espModule._boxFillAngles[entity] then espModule._boxFillAngles[entity] = cfg.BoxFillRotation or 0 end
                if cfg.BoxFillSpeed and cfg.BoxFillSpeed ~= 0 then
                    espModule._boxFillAngles[entity] = (espModule._boxFillAngles[entity] + cfg.BoxFillSpeed) % 360
                end
                data.BoxFill.Position = UDim2.fromOffset(x, y)
                data.BoxFill.Size = UDim2.fromOffset(sx, sy)
                data.BoxFill.BackgroundTransparency = 1 - ((1 - cfg.BoxFillTransparency) * espModule._fadeAlpha)
                data.BoxFillGradient.Color = ColorSequence.new(cfg.BoxFillColor1, cfg.BoxFillColor2)
                data.BoxFillGradient.Rotation = espModule._boxFillAngles[entity]
                data.BoxFill.Visible = true
            end
        else
            data.BoxFill.Visible = false
            data.BoxFillHighlight.Enabled = false
        end

        if cfg.Chams then
            data.PlayerChams.Adornee = character
            data.PlayerChams.FillColor = cfg.ChamsColor
            data.PlayerChams.FillTransparency = 1 - ((1 - cfg.ChamsFillTransparency) * espModule._fadeAlpha)
            if cfg.ChamsGlow then
                data.PlayerChams.OutlineColor = cfg.ChamsColor
                data.PlayerChams.OutlineTransparency = 1 - espModule._fadeAlpha
            else
                data.PlayerChams.OutlineColor = Color3.new(0, 0, 0)
                data.PlayerChams.OutlineTransparency = 1
            end
            data.PlayerChams.Enabled = true
        else
            data.PlayerChams.Enabled = false
        end

        if cfg.BoxEnabled then
            if cfg.BoxGlow then
                data.BoxGlow.Position = UDim2.fromOffset(x - 21, y - 21)
                data.BoxGlow.Size = UDim2.fromOffset(sx + 42, sy + 41)
                data.BoxGlow.ImageTransparency = 1 - (0.65 * espModule._fadeAlpha)
                data.BoxGlowGradient.Color = ColorSequence.new(cfg.LineColor, cfg.LineColor)
                data.BoxGlow.Visible = true
            else
                data.BoxGlow.Visible = false
            end

            if cfg.BoxType == "Full" then
                for _, line in pairs(data.Entity3DBox) do line:Hide() end
                local c = data.Corner
                c.TL1:Hide() c.TL2:Hide() c.TR1:Hide() c.TR2:Hide()
                c.BL1:Hide() c.BL2:Hide() c.BR1:Hide() c.BR2:Hide()
                local f = data.Full
                f.Top:Set(Vector2.new(x, y), Vector2.new(x + sx, y))
                f.Bottom:Set(Vector2.new(x, y + sy), Vector2.new(x + sx, y + sy))
                f.Left:Set(Vector2.new(x, y), Vector2.new(x, y + sy))
                f.Right:Set(Vector2.new(x + sx, y), Vector2.new(x + sx, y + sy))
                f.Top:SetColor(cfg.LineColor) f.Top:SetThickness(cfg.Thickness) f.Top:SetOutlineThickness(1)
                f.Bottom:SetColor(cfg.LineColor) f.Bottom:SetThickness(cfg.Thickness) f.Bottom:SetOutlineThickness(1)
                f.Left:SetColor(cfg.LineColor) f.Left:SetThickness(cfg.Thickness) f.Left:SetOutlineThickness(1)
                f.Right:SetColor(cfg.LineColor) f.Right:SetThickness(cfg.Thickness) f.Right:SetOutlineThickness(1)
                f.Top.Frame.BackgroundTransparency = 1 - espModule._fadeAlpha
                f.Bottom.Frame.BackgroundTransparency = 1 - espModule._fadeAlpha
                f.Left.Frame.BackgroundTransparency = 1 - espModule._fadeAlpha
                f.Right.Frame.BackgroundTransparency = 1 - espModule._fadeAlpha
            elseif cfg.BoxType == "3D" then
                local c = data.Corner
                c.TL1:Hide() c.TL2:Hide() c.TR1:Hide() c.TR2:Hide()
                c.BL1:Hide() c.BL2:Hide() c.BR1:Hide() c.BR2:Hide()
                local f = data.Full
                f.Top:Hide() f.Bottom:Hide() f.Left:Hide() f.Right:Hide()
                for i = 1, 12 do
                    local e = BOX_3D_EDGES[i]
                    local line = data.Entity3DBox["L"..i]
                    if vis[e[1]] and vis[e[2]] then
                        line:Set(p[e[1]], p[e[2]])
                        line:SetColor(cfg.LineColor)
                        line:SetThickness(cfg.Thickness)
                        line:SetOutlineThickness(1)
                        line.Frame.BackgroundTransparency = 1 - espModule._fadeAlpha
                    else
                        line:Hide()
                    end
                end
            else
                for _, line in pairs(data.Entity3DBox) do line:Hide() end
                local f = data.Full
                f.Top:Hide() f.Bottom:Hide() f.Left:Hide() f.Right:Hide()
                local len = math.clamp(0.22 + (rawStuds / 400) * 0.18, 0.22, 0.38)
                local cw = math.clamp(math.floor(sx * len + 0.5), 2, math.floor(sx / 2))
                local ch = math.clamp(math.floor(sy * len + 0.5), 2, math.floor(sy / 2))
                local c = data.Corner
                c.TL1:Set(Vector2.new(x, y), Vector2.new(x + cw + 1, y))
                c.TL2:Set(Vector2.new(x, y), Vector2.new(x, y + ch + 1))
                c.TR1:Set(Vector2.new(x + sx, y), Vector2.new(x + sx - cw - 1, y))
                c.TR2:Set(Vector2.new(x + sx, y), Vector2.new(x + sx, y + ch + 1))
                c.BL1:Set(Vector2.new(x, y + sy), Vector2.new(x + cw + 1, y + sy))
                c.BL2:Set(Vector2.new(x, y + sy), Vector2.new(x, y + sy - ch - 1))
                c.BR1:Set(Vector2.new(x + sx, y + sy), Vector2.new(x + sx - cw - 1, y + sy))
                c.BR2:Set(Vector2.new(x + sx, y + sy), Vector2.new(x + sx, y + sy - ch - 1))
                c.TL1:SetColor(cfg.LineColor) c.TL1:SetThickness(cfg.Thickness) c.TL1:SetOutlineThickness(1)
                c.TL2:SetColor(cfg.LineColor) c.TL2:SetThickness(cfg.Thickness) c.TL2:SetOutlineThickness(1)
                c.TR1:SetColor(cfg.LineColor) c.TR1:SetThickness(cfg.Thickness) c.TR1:SetOutlineThickness(1)
                c.TR2:SetColor(cfg.LineColor) c.TR2:SetThickness(cfg.Thickness) c.TR2:SetOutlineThickness(1)
                c.BL1:SetColor(cfg.LineColor) c.BL1:SetThickness(cfg.Thickness) c.BL1:SetOutlineThickness(1)
                c.BL2:SetColor(cfg.LineColor) c.BL2:SetThickness(cfg.Thickness) c.BL2:SetOutlineThickness(1)
                c.BR1:SetColor(cfg.LineColor) c.BR1:SetThickness(cfg.Thickness) c.BR1:SetOutlineThickness(1)
                c.BR2:SetColor(cfg.LineColor) c.BR2:SetThickness(cfg.Thickness) c.BR2:SetOutlineThickness(1)
                c.TL1.Frame.BackgroundTransparency = 1 - espModule._fadeAlpha
                c.TL2.Frame.BackgroundTransparency = 1 - espModule._fadeAlpha
                c.TR1.Frame.BackgroundTransparency = 1 - espModule._fadeAlpha
                c.TR2.Frame.BackgroundTransparency = 1 - espModule._fadeAlpha
                c.BL1.Frame.BackgroundTransparency = 1 - espModule._fadeAlpha
                c.BL2.Frame.BackgroundTransparency = 1 - espModule._fadeAlpha
                c.BR1.Frame.BackgroundTransparency = 1 - espModule._fadeAlpha
                c.BR2.Frame.BackgroundTransparency = 1 - espModule._fadeAlpha
            end
        else
            data.BoxGlow.Visible = false
            for _, line in pairs(data.Entity3DBox) do line:Hide() end
            local f = data.Full
            f.Top:Hide() f.Bottom:Hide() f.Left:Hide() f.Right:Hide()
            local c = data.Corner
            c.TL1:Hide() c.TL2:Hide() c.TR1:Hide() c.TR2:Hide()
            c.BL1:Hide() c.BL2:Hide() c.BR1:Hide() c.BR2:Hide()
        end

        if cfg.HeadDot then
            local headPart = character:FindFirstChild("Head")
            if headPart then
                local hpPos, hpOn = Camera:WorldToViewportPoint(headPart.Position)
                if hpOn and hpPos.Z > 0 then
                    data.HeadDot.Size = UDim2.fromOffset(cfg.HeadDotSize, cfg.HeadDotSize)
                    data.HeadDot.Position = UDim2.fromOffset(hpPos.X, hpPos.Y)
                    data.HeadDot.BackgroundColor3 = cfg.HeadDotColor
                    data.HeadDot.BackgroundTransparency = 1 - espModule._fadeAlpha
                    local stroke = data.HeadDot:FindFirstChild("DotStroke")
                    if stroke then
                        stroke.Thickness = cfg.HeadDotOutlineThickness
                        stroke.Color = Color3.new(0, 0, 0)
                        stroke.Transparency = 1 - espModule._fadeAlpha
                    end
                    data.HeadDot.Visible = true
                else
                    data.HeadDot.Visible = false
                end
            else
                data.HeadDot.Visible = false
            end
        else
            data.HeadDot.Visible = false
        end

        if cfg.HealthBar then
            local barX = x - 5
            local barW = 2
            data.HealthContainer.Position = UDim2.fromOffset(barX, y)
            data.HealthContainer.Size = UDim2.fromOffset(barW, sy)
            data.HealthContainer.Visible = true
            data.HealthContainer.BackgroundTransparency = 1 - espModule._fadeAlpha
            local hp = math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)
            data.HealthFill.Size = UDim2.fromScale(1, hp)
            data.HealthFill.Visible = true
            data.HealthFill.BackgroundTransparency = 1 - espModule._fadeAlpha
            data.HealthGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, cfg.HealthHigh),
                ColorSequenceKeypoint.new(0.5, cfg.HealthMid),
                ColorSequenceKeypoint.new(1, cfg.HealthLow)
            })
            if cfg.HealthText then
                local hpVal = math.floor(humanoid.Health + 0.5)
                local textStr = tostring(hpVal)
                if data.LastHealthStr ~= textStr then
                    data.HealthText.Frame.Text = textStr
                    data.LastHealthStr = textStr
                end
                if data.LastHealthFont ~= healthFont or data.LastHealthSize ~= cfg.TextSize then
                    data.HealthText.Frame.TextSize = cfg.TextSize
                    data.HealthText.Frame.FontFace = healthFont
                    data.LastHealthFont = healthFont
                    data.LastHealthSize = cfg.TextSize
                end
                local fillH = sy * hp
                local ty = math.clamp(y + sy - fillH - 5, y - 2, y + sy - 10)
                data.HealthText.Frame.Position = UDim2.fromOffset(barX - 3, ty)
                data.HealthText.Frame.AnchorPoint = Vector2.new(1, 0)
                data.HealthText.Frame.TextXAlignment = Enum.TextXAlignment.Right
                data.HealthText.Frame.TextYAlignment = Enum.TextYAlignment.Top
                local hCol = GetHealthColor(hp, cfg.HealthHigh, cfg.HealthMid, cfg.HealthLow)
                local grad = data.HealthText.Frame:FindFirstChild("TextGradient")
                if grad then grad.Color = ColorSequence.new(hCol, hCol) end
                data.HealthText.Frame.Visible = true
                data.HealthText.Frame.TextTransparency = 1 - espModule._fadeAlpha
                data.HealthText.Frame.TextStrokeTransparency = 1 - espModule._fadeAlpha
            else
                data.HealthText:Hide()
            end
        else
            data.HealthContainer.Visible = false
            data.HealthFill.Visible = false
            data.HealthText:Hide()
        end

        if cfg.ArmorBar then
            local armor = 100
            local armorObj = character:FindFirstChild("Armor")
            if armorObj and armorObj:IsA("NumberValue") and armorObj.Value > 0 then armor = armorObj.Value end
            local barY = y + sy + 2
            local barH = 2
            data.ArmorContainer.Position = UDim2.fromOffset(x, barY)
            data.ArmorContainer.Size = UDim2.fromOffset(sx, barH)
            data.ArmorContainer.Visible = true
            data.ArmorContainer.BackgroundTransparency = 1 - espModule._fadeAlpha
            local armRatio = math.clamp(armor / 100, 0, 1)
            data.ArmorFill.Size = UDim2.fromScale(armRatio, 1)
            data.ArmorFill.BackgroundTransparency = 1 - espModule._fadeAlpha
            data.ArmorGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, cfg.ArmorHigh),
                ColorSequenceKeypoint.new(0.5, cfg.ArmorMid),
                ColorSequenceKeypoint.new(1, cfg.ArmorLow)
            })
            data.ArmorFill.Visible = true
        else
            data.ArmorContainer.Visible = false
            data.ArmorFill.Visible = false
        end

        if cfg.Names then
            local nameStr
            if isPlayer then
                if cfg.NameType == "Display" then nameStr = entity.DisplayName
                elseif cfg.NameType == "Username" then nameStr = entity.Name
                else nameStr = entity.DisplayName .. " (@" .. entity.Name .. ")" end
            else
                nameStr = character.Name
            end
            if data.LastNameStr ~= nameStr then
                data.NameText.Frame.Text = nameStr
                data.LastNameStr = nameStr
            end
            if data.LastNameFont ~= textFont or data.LastNameSize ~= cfg.TextSize then
                data.NameText.Frame.TextSize = cfg.TextSize
                data.NameText.Frame.FontFace = textFont
                data.LastNameFont = textFont
                data.LastNameSize = cfg.TextSize
            end
            ApplyGradient(data.NameText, cfg.NameColor, cfg.NameColor2)
            data.NameText.Frame.Position = UDim2.fromOffset(x + sx * 0.5, y - 4)
            data.NameText.Frame.AnchorPoint = Vector2.new(0.5, 1)
            data.NameText.Frame.TextXAlignment = Enum.TextXAlignment.Center
            data.NameText.Frame.TextYAlignment = Enum.TextYAlignment.Bottom
            data.NameText.Frame.Visible = true
            data.NameText.Frame.TextTransparency = 1 - espModule._fadeAlpha
            data.NameText.Frame.TextStrokeTransparency = 1 - espModule._fadeAlpha
        else
            data.NameText:Hide()
        end

        if cfg.Distance then
            local textStr = "[" .. tostring(meters) .. "m]"
            if data.LastDistStr ~= textStr then
                data.DistanceText.Frame.Text = textStr
                data.LastDistStr = textStr
            end
            if data.LastDistFont ~= flagsFont or data.LastDistSize ~= cfg.TextSize then
                data.DistanceText.Frame.TextSize = cfg.TextSize
                data.DistanceText.Frame.FontFace = flagsFont
                data.LastDistFont = flagsFont
                data.LastDistSize = cfg.TextSize
            end
            ApplyGradient(data.DistanceText, cfg.DistanceColor, cfg.DistanceColor2)
            data.DistanceText.Frame.Position = UDim2.fromOffset(x + sx + 4, y - 1)
            data.DistanceText.Frame.AnchorPoint = Vector2.new(0, 0)
            data.DistanceText.Frame.TextXAlignment = Enum.TextXAlignment.Left
            data.DistanceText.Frame.TextYAlignment = Enum.TextYAlignment.Top
            data.DistanceText.Frame.Visible = true
            data.DistanceText.Frame.TextTransparency = 1 - espModule._fadeAlpha
            data.DistanceText.Frame.TextStrokeTransparency = 1 - espModule._fadeAlpha
        else
            data.DistanceText:Hide()
        end

        if cfg.Tool then
            local tool = character:FindFirstChildOfClass("Tool")
            local textStr = tool and tool.Name or "None"
            if data.LastToolStr ~= textStr then
                data.ToolText.Frame.Text = textStr
                data.LastToolStr = textStr
            end
            if data.LastToolFont ~= textFont or data.LastToolSize ~= cfg.TextSize then
                data.ToolText.Frame.TextSize = cfg.TextSize
                data.ToolText.Frame.FontFace = textFont
                data.LastToolFont = textFont
                data.LastToolSize = cfg.TextSize
            end
            ApplyGradient(data.ToolText, cfg.ToolColor, cfg.ToolColor2)
            local toolOffset = cfg.ArmorBar and 6 or 2
            data.ToolText.Frame.Position = UDim2.fromOffset(x + sx * 0.5, y + sy + toolOffset)
            data.ToolText.Frame.AnchorPoint = Vector2.new(0.5, 0)
            data.ToolText.Frame.TextXAlignment = Enum.TextXAlignment.Center
            data.ToolText.Frame.TextYAlignment = Enum.TextYAlignment.Top
            data.ToolText.Frame.Visible = true
            data.ToolText.Frame.TextTransparency = 1 - espModule._fadeAlpha
            data.ToolText.Frame.TextStrokeTransparency = 1 - espModule._fadeAlpha
        else
            data.ToolText:Hide()
        end

        if cfg.Flags then
            local walking = humanoid.MoveDirection.Magnitude > 0
            local jumping, swimming = false, false
            pcall(function()
                local state = humanoid:GetState()
                jumping = state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping
                swimming = state == Enum.HumanoidStateType.Swimming
            end)
            local activeFlags = {}
            if table.find(cfg.SelectedFlags, "Walking") and walking then table.insert(activeFlags, "Walking") end
            if table.find(cfg.SelectedFlags, "Jumping") and jumping then table.insert(activeFlags, "Jumping") end
            if table.find(cfg.SelectedFlags, "Swimming") and swimming then table.insert(activeFlags, "Swimming") end
            for name, customFlag in pairs(espModule.CustomFlags) do
                if table.find(cfg.SelectedFlags, name) then
                    local success, res = pcall(customFlag.Func, entity, character, humanoid)
                    if success and res then table.insert(activeFlags, name) end
                end
            end
            local activeCount = 0
            for _, name in ipairs(activeFlags) do
                local lblData = data.FlagLabels[name]
                if not lblData then
                    local lbl = Instance.new("TextLabel")
                    lbl.BackgroundTransparency = 1
                    lbl.Text = name
                    lbl.TextSize = 10
                    lbl.TextColor3 = Color3.new(1, 1, 1)
                    lbl.TextStrokeTransparency = 0
                    lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
                    lbl.FontFace = flagsFont
                    lbl.TextXAlignment = Enum.TextXAlignment.Left
                    lbl.TextYAlignment = Enum.TextYAlignment.Top
                    lbl.AutomaticSize = Enum.AutomaticSize.XY
                    lbl.Size = UDim2.fromOffset(0, 0)
                    lbl.Visible = false
                    lbl.ZIndex = 5
                    lbl.Parent = data.FlagsFrame
                    local uiGradient = Instance.new("UIGradient")
                    uiGradient.Name = "TextGradient"
                    uiGradient.Parent = lbl
                    lblData = {Frame = lbl, LastFont = flagsFont, LastSize = 10}
                    data.FlagLabels[name] = lblData
                end
                lblData.Frame.Visible = true
                lblData.Frame.LayoutOrder = activeCount
                if lblData.LastFont ~= flagsFont or lblData.LastSize ~= cfg.TextSize then
                    lblData.Frame.FontFace = flagsFont
                    lblData.Frame.TextSize = cfg.TextSize
                    lblData.LastFont = flagsFont
                    lblData.LastSize = cfg.TextSize
                end
                ApplyGradient(lblData, cfg.FlagColor1, cfg.FlagColor2)
                lblData.Frame.TextTransparency = 1 - espModule._fadeAlpha
                lblData.Frame.TextStrokeTransparency = 1 - espModule._fadeAlpha
                activeCount = activeCount + 1
            end
            for name, lblData in pairs(data.FlagLabels) do
                if not table.find(activeFlags, name) then lblData.Frame.Visible = false end
            end
            if activeCount > 0 then
                local flagsY = cfg.Distance and (y + 12) or (y - 1)
                data.FlagsFrame.Position = UDim2.fromOffset(x + sx + 4, flagsY)
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
            if cfg.TracerOrigin == "Bottom" then from = Vector2.new(viewport.X * 0.5, viewport.Y)
            elseif cfg.TracerOrigin == "Top" then from = Vector2.new(viewport.X * 0.5, 0)
            elseif cfg.TracerOrigin == "Mouse" then from = Services.UserInputService:GetMouseLocation()
            else from = Vector2.new(viewport.X * 0.5, viewport.Y * 0.5) end
            local to = Vector2.new(x + sx * 0.5, y + sy)
            data.Tracer:SetColor(cfg.TracerColor)
            data.Tracer:SetThickness(cfg.TracerThickness)
            data.Tracer:SetOutlineThickness(1)
            data.Tracer:Set(from, to)
            data.Tracer.Frame.BackgroundTransparency = 1 - espModule._fadeAlpha
        else
            data.Tracer:Hide()
        end

        if cfg.Skeleton then
            local function DrawBone(bone, p1n, p2n)
                local p1 = character:FindFirstChild(p1n)
                local p2 = character:FindFirstChild(p2n)
                if p1 and p2 then
                    local s1, v1 = Camera:WorldToViewportPoint(p1.Position)
                    local s2, v2 = Camera:WorldToViewportPoint(p2.Position)
                    if v1 and v2 and s1.Z > 0 and s2.Z > 0 then
                        local a = Vector2.new(s1.X, s1.Y)
                        local b = Vector2.new(s2.X, s2.Y)
                        bone:SetColor(Color3.new(1, 1, 1))
                        bone.Gradient.Color = ColorSequence.new(cfg.SkeletonColor, cfg.SkeletonColor2)
                        bone.Gradient.Rotation = 0
                        bone:SetThickness(cfg.SkeletonThickness)
                        bone:SetOutlineThickness(1)
                        bone:Set(a, b)
                        bone.Frame.BackgroundTransparency = 1 - espModule._fadeAlpha
                        return
                    end
                end
                bone:Hide()
            end
            local sk = data.Skeleton
            if isR15 then
                DrawBone(sk.HeadTorso, "Head", "UpperTorso")
                DrawBone(sk.TorsoHip, "UpperTorso", "LowerTorso")
                DrawBone(sk.HipL, "LowerTorso", "LeftUpperLeg")
                DrawBone(sk.HipR, "LowerTorso", "RightUpperLeg")
                DrawBone(sk.LLeg, "LeftUpperLeg", "LeftLowerLeg")
                DrawBone(sk.RLeg, "RightUpperLeg", "RightLowerLeg")
                DrawBone(sk.LArm, "UpperTorso", "LeftUpperArm")
                DrawBone(sk.RArm, "UpperTorso", "RightUpperArm")
                DrawBone(sk.LFore, "LeftUpperArm", "LeftLowerArm")
                DrawBone(sk.RFore, "RightUpperArm", "RightLowerArm")
            else
                DrawBone(sk.HeadTorso, "Head", "Torso")
                DrawBone(sk.TorsoHip, "Torso", "Torso")
                DrawBone(sk.HipL, "Torso", "Left Leg")
                DrawBone(sk.HipR, "Torso", "Right Leg")
                DrawBone(sk.LLeg, "Left Leg", "Left Leg")
                DrawBone(sk.RLeg, "Right Leg", "Right Leg")
                DrawBone(sk.LArm, "Torso", "Left Arm")
                DrawBone(sk.RArm, "Torso", "Right Arm")
                DrawBone(sk.LFore, "Left Arm", "Left Arm")
                DrawBone(sk.RFore, "Right Arm", "Right Arm")
            end
        else
            for _, bone in pairs(data.Skeleton) do bone:Hide() end
        end
    else
        HideESP(data)
    end
end

local _lastUpdate = 0
local _cameraCache = nil
local _cameraCacheTime = 0
local function espLoop()
    local s = espModule.Settings
    local anyEntity = s.Enemy.Enabled or s.Teammate.Enabled or s.AI.Enabled
    local anyItem = s.Items.Enabled and HAS_BOTS_ITEMS

    if espModule._isDead then
        espModule._fadeAlpha = math.max(0, espModule._fadeAlpha - 0.05)
    else
        espModule._fadeAlpha = math.min(1, espModule._fadeAlpha + 0.05)
    end

    if not anyEntity and not anyItem then
        for entity in pairs(espModule._drawings) do RemoveESP(entity) end
        return
    end

    local rate = math.clamp(s.RefreshRate or 144, 60, 240)
    local interval = 1 / rate
    local now = tick()
    if now - _lastUpdate < interval then return end
    _lastUpdate = now

    if now - _cameraCacheTime > 0.1 then
        _cameraCache = Services.WorkSpace.CurrentCamera
        _cameraCacheTime = now
    end
    Services.CurrentCamera = _cameraCache
    if not Services.CurrentCamera then return end

    if anyEntity then
        if HAS_CUSTOM_CHARS then
            local bots = espModule._bots
            for i = 1, #bots do
                local bot = bots[i]
                if bot and bot.Parent then ProcessEntity(bot) end
            end
        else
            local players = Services.Players:GetPlayers()
            for i = 1, #players do
                local player = players[i]
                if player ~= Services.LocalPlayer then ProcessEntity(player) end
            end
            if HAS_BOTS_ITEMS then
                local bots = espModule._bots
                for i = 1, #bots do
                    local bot = bots[i]
                    if bot and bot.Parent then ProcessEntity(bot) end
                end
            end
        end
    end

    if anyItem then
        local containers = espModule._containers
        for i = 1, #containers do
            local item = containers[i]
            if item and item.Parent and item:IsA("Model") then ProcessItem(item) end
        end
    end
end

function espModule:Start()
    if self._isRunning then return end
    self._isRunning = true
    loadFont()
    table.clear(self._bots)
    table.clear(self._containers)

    local function onCharacterAdded(char)
        local hum = char:WaitForChild("Humanoid")
        espModule._isDead = false
        espModule._fadeAlpha = 1
        hum.Died:Connect(function() espModule._isDead = true end)
    end

    if Services.LocalPlayer.Character then onCharacterAdded(Services.LocalPlayer.Character) end
    self._connections.CharacterAdded = Services.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

    if HAS_BOTS_ITEMS then
        local botsFolder = Services.WorkSpace:FindFirstChild("IngameBots")
        if botsFolder then
            for _, bot in ipairs(botsFolder:GetChildren()) do
                if bot:IsA("Model") then self._bots[#self._bots + 1] = bot end
            end
            self._connections.BotAdded = botsFolder.ChildAdded:Connect(function(child)
                if child:IsA("Model") then self._bots[#self._bots + 1] = child end
            end)
            self._connections.BotRemoving = botsFolder.ChildRemoved:Connect(function(child)
                local idx = table.find(self._bots, child)
                if idx then table.remove(self._bots, idx) end
                RemoveESP(child)
            end)
        end
        local containers = Services.WorkSpace:FindFirstChild("Containers")
        if containers then
            for _, item in ipairs(containers:GetChildren()) do
                if item:IsA("Model") then self._containers[#self._containers + 1] = item end
            end
            self._connections.ContainerAdded = containers.ChildAdded:Connect(function(child)
                if child:IsA("Model") then self._containers[#self._containers + 1] = child end
            end)
            self._connections.ContainerRemoving = containers.ChildRemoved:Connect(function(child)
                local idx = table.find(self._containers, child)
                if idx then table.remove(self._containers, idx) end
                RemoveItemESP(child)
            end)
        end
    end

    if HAS_CUSTOM_CHARS then
        local gameLogic = Services.WorkSpace:FindFirstChild("GameLogic")
        if gameLogic then
            local chars = gameLogic:FindFirstChild("Characters")
            if chars then
                for _, child in ipairs(chars:GetChildren()) do
                    if child:IsA("Model") then self._bots[#self._bots + 1] = child end
                end
                self._connections.CharAdded = chars.ChildAdded:Connect(function(child)
                    if child:IsA("Model") then self._bots[#self._bots + 1] = child end
                end)
                self._connections.CharRemoving = chars.ChildRemoved:Connect(function(child)
                    local idx = table.find(self._bots, child)
                    if idx then table.remove(self._bots, idx) end
                    RemoveESP(child)
                end)
            end
        end
    end

    self._connections.PlayerRemoving = Services.Players.PlayerRemoving:Connect(RemoveESP)
    self._connections.RenderStepped = Services.RunService.Heartbeat:Connect(espLoop)
end

function espModule:Stop()
    if not self._isRunning then return end
    self._isRunning = false
    for _, conn in pairs(self._connections) do conn:Disconnect() end
    self._connections = {}
    for entity in pairs(self._drawings) do RemoveESP(entity) end
    self._drawings = {}
    for item in pairs(self._itemDrawings) do RemoveItemESP(item) end
    self._itemDrawings = {}
    self._itemHighlights = {}
    table.clear(self._bots)
    table.clear(self._containers)
end

function espModule:Restart() self:Stop() self:Start() end
function espModule:UpdateSettings(newSettings)
    local function merge(t1, t2)
        for k, v in pairs(t2) do
            if type(v) == "table" and type(t1[k]) == "table" then merge(t1[k], v)
            else t1[k] = v end
        end
    end
    merge(self.Settings, newSettings)
end
function espModule:GetSettings() return self.Settings end
function espModule:Toggle() if self._isRunning then self:Stop() else self:Start() end end

-- ============================================================
-- UI + LIVE PREVIEW
-- ============================================================

local C = {
    outline = rgb(0, 0, 0), inline = rgb(40, 40, 40), body = rgb(14, 14, 14),
    text = rgb(205, 205, 205), dim = rgb(112, 112, 112), accent = rgb(204, 112, 148),
}

local function new(class, props)
    local o = Instance.new(class)
    if o:IsA("GuiObject") then o.BorderSizePixel = 0 end
    if class == "TextLabel" or class == "TextButton" then
        o.Font = Enum.Font.Code
        o.TextSize = 12
        o.TextColor3 = C.text
        o.BackgroundTransparency = 1
        o.TextXAlignment = Enum.TextXAlignment.Left
        o.Text = ""
    end
    if class == "TextButton" then o.AutoButtonColor = false end
    for k, v in pairs(props) do
        if k ~= "Parent" then o[k] = v end
    end
    o.Parent = props.Parent
    return o
end

local function stroke(parent, color)
    return new("UIStroke", {Parent = parent, Color = color or C.inline, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
end

local function label(parent, text, color, pos, size)
    return new("TextLabel", {Parent = parent, Text = text, TextColor3 = color or C.text, Position = pos or UDim2.new(), Size = size or UDim2.new(1, 0, 1, 0)})
end

local function tween(o, props, t)
    TweenService:Create(o, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad), props):Play()
end

local function framed(parent, size, pos)
    local o = new("Frame", {Parent = parent, Size = size, Position = pos or UDim2.new(), BackgroundColor3 = C.outline})
    local i = new("Frame", {Parent = o, Size = UDim2.new(1, -2, 1, -2), Position = UDim2.fromOffset(1, 1), BackgroundColor3 = C.inline})
    local b = new("Frame", {Parent = i, Size = UDim2.new(1, -2, 1, -2), Position = UDim2.fromOffset(1, 1), BackgroundColor3 = C.body})
    return b, o
end

local uiParent = getParent()
local uiGui = new("ScreenGui", {Name = HttpService:GenerateGUID(false), IgnoreGuiInset = true, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 1000, Parent = uiParent})

local vp = Workspace.CurrentCamera.ViewportSize
local root = new("Frame", {Parent = uiGui, BackgroundTransparency = 1, Size = UDim2.fromOffset(630, 440), Position = UDim2.fromOffset(floor(vp.X / 2 - 315), floor(vp.Y / 2 - 220))})

local side = framed(root, UDim2.fromOffset(148, 440))
new("Frame", {Parent = side, Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = C.accent, ZIndex = 2})

local sideHeader = new("Frame", {Parent = side, Position = UDim2.fromOffset(0, 2), Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1})
new("Frame", {Parent = sideHeader, Position = UDim2.fromOffset(10, 15), Size = UDim2.fromOffset(10, 10), BackgroundColor3 = rgb(22, 22, 22)})
new("Frame", {Parent = sideHeader, Position = UDim2.fromOffset(14, 19), Size = UDim2.fromOffset(7, 7), BackgroundColor3 = C.accent})
label(sideHeader, "esp", rgb(240, 240, 240), UDim2.fromOffset(34, 11), UDim2.new(1, -34, 0, 12))
label(sideHeader, "preview", rgb(85, 85, 85), UDim2.fromOffset(34, 23), UDim2.new(1, -34, 0, 12))
new("Frame", {Parent = side, Position = UDim2.fromOffset(0, 44), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = rgb(30, 30, 30)})

local sideList = new("Frame", {Parent = side, Position = UDim2.fromOffset(0, 50), Size = UDim2.new(1, 0, 1, -50), BackgroundTransparency = 1})
new("UIListLayout", {Parent = sideList, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder})

local content = framed(root, UDim2.fromOffset(474, 440), UDim2.fromOffset(156, 0))
new("Frame", {Parent = content, Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = C.accent, ZIndex = 2})
local header = new("Frame", {Parent = content, Position = UDim2.fromOffset(0, 2), Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1})
local crumb = label(header, "Enemy", rgb(240, 240, 240), UDim2.fromOffset(8, 0), UDim2.new(1, -16, 1, 0))
new("Frame", {Parent = content, Position = UDim2.fromOffset(0, 31), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = rgb(30, 30, 30)})

local pageHolder = new("Frame", {Parent = content, Position = UDim2.fromOffset(0, 32), Size = UDim2.new(1, 0, 1, -32), BackgroundTransparency = 1})

local function makeDraggable(handle, target)
    local dragging, startInput, startPos = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging, startInput, startPos = true, i.Position, target.Position
        end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - startInput
            target.Position = UDim2.fromOffset(startPos.X.Offset + d.X, startPos.Y.Offset + d.Y)
        end
    end)
end

makeDraggable(sideHeader, root)
makeDraggable(header, root)

local function makeToggle(parent, name, getVal, setVal)
    local row = new("TextButton", {Parent = parent, Size = UDim2.new(1, 0, 0, 20), BackgroundColor3 = rgb(20, 20, 20)})
    stroke(row, rgb(36, 36, 36))
    local box = new("Frame", {Parent = row, Size = UDim2.fromOffset(10, 10), Position = UDim2.fromOffset(6, 5), BackgroundColor3 = getVal() and C.accent or rgb(30, 30, 30)})
    stroke(box, rgb(50, 50, 50))
    label(row, name, C.text, UDim2.fromOffset(24, 0), UDim2.new(1, -24, 1, 0))
    row.MouseButton1Click:Connect(function()
        local nv = not getVal()
        setVal(nv)
        box.BackgroundColor3 = nv and C.accent or rgb(30, 30, 30)
        tween(box, {BackgroundColor3 = box.BackgroundColor3})
    end)
    return row
end

local function page(name)
    local p = new("Frame", {Parent = pageHolder, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false})
    new("UIPadding", {Parent = p, PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)})
    new("UIListLayout", {Parent = p, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder})
    return p
end

local pages = {}
local sideButtons = {}

local function addTab(name, builder)
    local btn = new("TextButton", {Parent = sideList, Size = UDim2.new(1, 0, 0, 20), BackgroundColor3 = rgb(24, 24, 24), BackgroundTransparency = 1})
    local bar = new("Frame", {Parent = btn, Size = UDim2.new(0, 2, 1, 0), BackgroundColor3 = C.accent, Visible = false})
    local bullet = new("Frame", {Parent = btn, Position = UDim2.fromOffset(11, 9), Size = UDim2.fromOffset(3, 3), BackgroundColor3 = rgb(70, 70, 70)})
    local txt = label(btn, name, rgb(160, 160, 160), UDim2.fromOffset(22, 0), UDim2.new(1, -22, 1, 0))
    local pg = page(name)
    pages[name] = pg
    sideButtons[name] = {btn = btn, bar = bar, bullet = bullet, text = txt}
    btn.MouseButton1Click:Connect(function()
        for n, p in pairs(pages) do p.Visible = false end
        for n, b in pairs(sideButtons) do
            b.bar.Visible = false
            b.btn.BackgroundTransparency = 1
            b.text.TextColor3 = rgb(160, 160, 160)
            b.bullet.BackgroundColor3 = rgb(70, 70, 70)
        end
        pg.Visible = true
        bar.Visible = true
        btn.BackgroundTransparency = 0
        txt.TextColor3 = rgb(245, 245, 245)
        bullet.BackgroundColor3 = C.accent
        crumb.Text = name
        builder(pg)
    end)
    return btn
end

local function section(parent, title)
    local container = new("Frame", {Parent = parent, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1})
    new("UIPadding", {Parent = container, PaddingTop = UDim.new(0, 7)})
    local body = new("Frame", {Parent = container, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = C.body, ZIndex = 1})
    stroke(body, C.inline)
    new("UIPadding", {Parent = body, PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)})
    new("UIListLayout", {Parent = body, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder})
    local t = label(container, title, C.text, UDim2.fromOffset(6, -7), UDim2.new())
    t.AutomaticSize = Enum.AutomaticSize.XY
    t.BackgroundTransparency = 0
    t.BackgroundColor3 = C.body
    t.ZIndex = 3
    stroke(t, C.inline)
    new("UIPadding", {Parent = t, PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4)})
    return body
end

local currentPreview = nil

local function buildPreview(parent)
    local vpFrame = new("Frame", {Parent = parent, Size = UDim2.new(1, 0, 0, 250), BackgroundColor3 = rgb(10, 10, 10)})
    stroke(vpFrame, C.inline)
    local viewport = new("ViewportFrame", {Parent = vpFrame, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = rgb(18, 18, 22), BackgroundTransparency = 0})
    viewport.Ambient = rgb(140, 140, 140)
    viewport.LightColor = rgb(255, 255, 255)

    local world = Instance.new("WorldModel")
    world.Parent = viewport

    local cam = Instance.new("Camera")
    cam.Parent = viewport
    viewport.CurrentCamera = cam
    cam.CFrame = CFrame.lookAt(Vector3.new(5, 2.5, 11), Vector3.new(0, 1, 0))
    cam.FieldOfView = 50

    local floor = Instance.new("Part")
    floor.Size = Vector3.new(20, 0.2, 20)
    floor.Anchored = true
    floor.CanCollide = false
    floor.Color = rgb(22, 22, 26)
    floor.Material = Enum.Material.SmoothPlastic
    floor.Position = Vector3.new(0, -3.4, 0)
    floor.Parent = world

    local rig = Instance.new("Model")
    rig.Name = "PreviewRig"
    rig.Parent = world

    local parts = {}
    local function p(name, size, color, pos)
        local pt = Instance.new("Part")
        pt.Name = name
        pt.Size = size
        pt.Color = color
        pt.Anchored = true
        pt.CanCollide = false
        pt.Material = Enum.Material.SmoothPlastic
        pt.CFrame = CFrame.new(pos)
        pt.Parent = rig
        parts[name] = pt
        return pt
    end
    p("Head", Vector3.new(1.5, 1.5, 1.5), rgb(220, 190, 140), Vector3.new(0, 2.75, 0))
    p("Torso", Vector3.new(2, 2, 1), rgb(40, 90, 180), Vector3.new(0, 1, 0))
    p("Left Arm", Vector3.new(1, 2, 1), rgb(220, 190, 140), Vector3.new(-1.5, 1, 0))
    p("Right Arm", Vector3.new(1, 2, 1), rgb(220, 190, 140), Vector3.new(1.5, 1, 0))
    p("Left Leg", Vector3.new(1, 2, 1), rgb(40, 70, 40), Vector3.new(-0.5, -1, 0))
    p("Right Leg", Vector3.new(1, 2, 1), rgb(40, 70, 40), Vector3.new(0.5, -1, 0))

    local chams = {}
    for name, orig in pairs(parts) do
        local ch = Instance.new("Part")
        ch.Name = "Chams_" .. name
        ch.Size = orig.Size
        ch.Anchored = true
        ch.CanCollide = false
        ch.Material = Enum.Material.ForceField
        ch.Color = rgb(255, 80, 80)
        ch.Transparency = 0.7
        ch.CFrame = orig.CFrame
        ch.Parent = world
        chams[name] = ch
    end

    local skeleton = {}
    local boneNames = {"HeadTorso", "TorsoHip", "HipL", "HipR", "LLeg", "RLeg", "LArm", "RArm", "LFore", "RFore"}
    for _, n in ipairs(boneNames) do
        local seg = Instance.new("Part")
        seg.Name = "Bone_" .. n
        seg.Size = Vector3.new(0.08, 0.08, 0.08)
        seg.Anchored = true
        seg.CanCollide = false
        seg.Material = Enum.Material.Neon
        seg.Color = rgb(255, 80, 80)
        seg.Transparency = 1
        seg.Parent = world
        skeleton[n] = seg
    end

    local box = {}
    for i = 1, 12 do
        local seg = Instance.new("Part")
        seg.Name = "Box_" .. i
        seg.Size = Vector3.new(0.06, 0.06, 0.06)
        seg.Anchored = true
        seg.CanCollide = false
        seg.Material = Enum.Material.Neon
        seg.Color = rgb(255, 80, 80)
        seg.Transparency = 1
        seg.Parent = world
        box[i] = seg
    end

    local function setSeg(part, a, b, color, thickness)
        local dist = (b - a).Magnitude
        if dist < 0.001 then part.Transparency = 1 return end
        part.Size = Vector3.new(thickness, thickness, dist)
        part.CFrame = CFrame.lookAt((a + b) / 2, b)
        part.Color = color
        part.Transparency = 0
    end

    local function update()
        local s = espModule.Settings.Enemy
        local rot = CFrame.Angles(0, tick() * 0.6, 0)
        rig:PivotTo(CFrame.new(0, 0, 0) * rot)

        if s.Chams then
            for name, orig in pairs(parts) do
                local ch = chams[name]
                ch.CFrame = orig.CFrame
                ch.Color = s.ChamsColor
                ch.Transparency = 1 - s.ChamsFillTransparency
                ch.Size = orig.Size * 1.04
                ch.Material = s.ChamsGlow and Enum.Material.Neon or Enum.Material.ForceField
            end
        else
            for _, ch in pairs(chams) do ch.Transparency = 1 end
        end

        if s.Skeleton then
            local function draw(key, a, b)
                local pa, pb = parts[a], parts[b]
                if not pa or not pb then return end
                setSeg(skeleton[key], pa.Position, pb.Position, s.SkeletonColor:Lerp(s.SkeletonColor2, 0.5), s.SkeletonThickness * 0.12 + 0.04)
            end
            draw("HeadTorso", "Head", "Torso")
            draw("HipL", "Torso", "Left Leg")
            draw("HipR", "Torso", "Right Leg")
            draw("LArm", "Torso", "Left Arm")
            draw("RArm", "Torso", "Right Arm")
            local function drawLimb(key, center, bottomOffset)
                local pc = parts[center]
                if not pc then return end
                local bottom = (pc.CFrame * CFrame.new(0, -pc.Size.Y/2, 0)).Position
                setSeg(skeleton[key], pc.Position, bottom, s.SkeletonColor2, s.SkeletonThickness * 0.1 + 0.03)
            end
            drawLimb("LLeg", "Left Leg")
            drawLimb("RLeg", "Right Leg")
            drawLimb("LFore", "Left Arm")
            drawLimb("RFore", "Right Arm")
            skeleton.TorsoHip.Transparency = 1
        else
            for _, seg in pairs(skeleton) do seg.Transparency = 1 end
        end

        if s.BoxEnabled then
            local min, max = nil, nil
            for _, pt in pairs(parts) do
                local c = pt.CFrame
                local h = pt.Size / 2
                for _, off in ipairs({
                    Vector3.new(h.X, h.Y, h.Z), Vector3.new(-h.X, h.Y, h.Z),
                    Vector3.new(-h.X, -h.Y, h.Z), Vector3.new(h.X, -h.Y, h.Z),
                    Vector3.new(h.X, h.Y, -h.Z), Vector3.new(-h.X, h.Y, -h.Z),
                    Vector3.new(-h.X, -h.Y, -h.Z), Vector3.new(h.X, -h.Y, -h.Z)
                }) do
                    local w = (c * CFrame.new(off)).Position
                    if not min then min, max = w, w end
                    min = Vector3.new(math.min(min.X, w.X), math.min(min.Y, w.Y), math.min(min.Z, w.Z))
                    max = Vector3.new(math.max(max.X, w.X), math.max(max.Y, w.Y), math.max(max.Z, w.Z))
                end
            end
            local corners = {
                Vector3.new(min.X, min.Y, min.Z), Vector3.new(max.X, min.Y, min.Z),
                Vector3.new(max.X, max.Y, min.Z), Vector3.new(min.X, max.Y, min.Z),
                Vector3.new(min.X, min.Y, max.Z), Vector3.new(max.X, min.Y, max.Z),
                Vector3.new(max.X, max.Y, max.Z), Vector3.new(min.X, max.Y, max.Z),
            }
            local edges = {{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}}
            for i, e in ipairs(edges) do
                setSeg(box[i], corners[e[1]], corners[e[2]], s.LineColor, s.Thickness * 0.04 + 0.03)
            end
        else
            for _, seg in pairs(box) do seg.Transparency = 1 end
        end
    end

    currentPreview = update
    return update
end

local previewUpdater = nil

addTab("Enemy", function(pg)
    local s = espModule.Settings.Enemy
    local sec = section(pg, "enemy esp")
    makeToggle(sec, "enabled", function() return s.Enabled end, function(v) s.Enabled = v end)
    makeToggle(sec, "box", function() return s.BoxEnabled end, function(v) s.BoxEnabled = v end)
    makeToggle(sec, "chams", function() return s.Chams end, function(v) s.Chams = v end)
    makeToggle(sec, "skeleton", function() return s.Skeleton end, function(v) s.Skeleton = v end)
    makeToggle(sec, "names", function() return s.Names end, function(v) s.Names = v end)
    makeToggle(sec, "health bar", function() return s.HealthBar end, function(v) s.HealthBar = v end)
    makeToggle(sec, "distance", function() return s.Distance end, function(v) s.Distance = v end)
    makeToggle(sec, "tracers", function() return s.Tracers end, function(v) s.Tracers = v end)
end)

addTab("Teammate", function(pg)
    local s = espModule.Settings.Teammate
    local sec = section(pg, "teammate esp")
    makeToggle(sec, "enabled", function() return s.Enabled end, function(v) s.Enabled = v end)
    makeToggle(sec, "box", function() return s.BoxEnabled end, function(v) s.BoxEnabled = v end)
    makeToggle(sec, "chams", function() return s.Chams end, function(v) s.Chams = v end)
    makeToggle(sec, "skeleton", function() return s.Skeleton end, function(v) s.Skeleton = v end)
    makeToggle(sec, "names", function() return s.Names end, function(v) s.Names = v end)
    makeToggle(sec, "health bar", function() return s.HealthBar end, function(v) s.HealthBar = v end)
    makeToggle(sec, "distance", function() return s.Distance end, function(v) s.Distance = v end)
    makeToggle(sec, "tracers", function() return s.Tracers end, function(v) s.Tracers = v end)
end)

addTab("AI", function(pg)
    local s = espModule.Settings.AI
    local sec = section(pg, "ai esp")
    makeToggle(sec, "enabled", function() return s.Enabled end, function(v) s.Enabled = v end)
    makeToggle(sec, "box", function() return s.BoxEnabled end, function(v) s.BoxEnabled = v end)
    makeToggle(sec, "chams", function() return s.Chams end, function(v) s.Chams = v end)
    makeToggle(sec, "skeleton", function() return s.Skeleton end, function(v) s.Skeleton = v end)
    makeToggle(sec, "names", function() return s.Names end, function(v) s.Names = v end)
    makeToggle(sec, "health bar", function() return s.HealthBar end, function(v) s.HealthBar = v end)
end)

addTab("Items", function(pg)
    local s = espModule.Settings.Items
    local sec = section(pg, "items")
    makeToggle(sec, "enabled", function() return s.Enabled end, function(v) s.Enabled = v end)
    makeToggle(sec, "show names", function() return s.ShowNames end, function(v) s.ShowNames = v end)
    makeToggle(sec, "show distance", function() return s.ShowDistance end, function(v) s.ShowDistance = v end)
    makeToggle(sec, "chams", function() return s.Chams end, function(v) s.Chams = v end)
end)

addTab("Preview", function(pg)
    local sec = section(pg, "live preview (enemy settings)")
    local holder = new("Frame", {Parent = sec, Size = UDim2.new(1, 0, 0, 250), BackgroundTransparency = 1})
    if not previewUpdater then previewUpdater = buildPreview(holder) end
    if previewUpdater and currentPreview then currentPreview = previewUpdater end
    if holder:FindFirstChildOfClass("Frame") and currentPreview then
        holder:FindFirstChildOfClass("Frame").Parent = holder
    end
end)

sideButtons["Enemy"].btn:GetPropertyChangedSignal("Parent"):Connect(function() end)

RunService.RenderStepped:Connect(function()
    if currentPreview then currentPreview() end
end)

RunService.RenderStepped:Connect(function()
    espModule._previewTick = (espModule._previewTick or 0) + 1
end)

for _, name in ipairs({"Enemy", "Teammate", "AI", "Items", "Preview"}) do
    sideButtons[name].btn.MouseButton1Click:Connect(function()
        if name == "Preview" and not currentPreview then
            local pg = pages["Preview"]
            local sec = pg:FindFirstChildOfClass("Frame")
            if sec then
                local holder = new("Frame", {Parent = sec, Size = UDim2.new(1, 0, 0, 250), BackgroundTransparency = 1})
                previewUpdater = buildPreview(holder)
            end
        end
    end)
end

sideButtons["Enemy"].btn.MouseButton1Click:Fire
sideButtons["Enemy"].bar.Visible = true
sideButtons["Enemy"].btn.BackgroundTransparency = 0
sideButtons["Enemy"].text.TextColor3 = rgb(245, 245, 245)
sideButtons["Enemy"].bullet.BackgroundColor3 = C.accent
pages["Enemy"].Visible = true
local enemyPg = pages["Enemy"]
local s0 = espModule.Settings.Enemy
local sec0 = section(enemyPg, "enemy esp")
makeToggle(sec0, "enabled", function() return s0.Enabled end, function(v) s0.Enabled = v end)
makeToggle(sec0, "box", function() return s0.BoxEnabled end, function(v) s0.BoxEnabled = v end)
makeToggle(sec0, "chams", function() return s0.Chams end, function(v) s0.Chams = v end)
makeToggle(sec0, "skeleton", function() return s0.Skeleton end, function(v) s0.Skeleton = v end)
makeToggle(sec0, "names", function() return s0.Names end, function(v) s0.Names = v end)
makeToggle(sec0, "health bar", function() return s0.HealthBar end, function(v) s0.HealthBar = v end)
makeToggle(sec0, "distance", function() return s0.Distance end, function(v) s0.Distance = v end)
makeToggle(sec0, "tracers", function() return s0.Tracers end, function(v) s0.Tracers = v end)

local wmOuter = new("Frame", {Parent = uiGui, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 8), Size = UDim2.new(0, 0, 0, 20), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = C.outline})
new("UIPadding", {Parent = wmOuter, PaddingTop = UDim.new(0, 1), PaddingBottom = UDim.new(0, 1), PaddingLeft = UDim.new(0, 1), PaddingRight = UDim.new(0, 1)})
local wmInner = new("Frame", {Parent = wmOuter, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = C.inline})
new("UIPadding", {Parent = wmInner, PaddingTop = UDim.new(0, 1), PaddingBottom = UDim.new(0, 1), PaddingLeft = UDim.new(0, 1), PaddingRight = UDim.new(0, 1)})
local wmBody = new("Frame", {Parent = wmInner, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = C.body})
new("Frame", {Parent = wmBody, Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = C.accent, ZIndex = 2})
local wmText = new("TextLabel", {Parent = wmBody, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, RichText = true, TextYAlignment = Enum.TextYAlignment.Center})
new("UIPadding", {Parent = wmText, PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)})

local fps, frames, acc = 60, 0, 0
RunService.RenderStepped:Connect(function(dt)
    frames += 1
    acc += dt
    if acc >= 0.5 then
        fps = floor(frames / acc + 0.5)
        frames, acc = 0, 0
        wmText.Text = string.format('<font color="rgb(204,112,148)">esp</font> | %s | %d fps | %s', lp.Name, fps, os.date("%H:%M"))
    end
end)

espModule:Start()

return espModule
