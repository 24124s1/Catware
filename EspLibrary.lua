local espModule = {}

espModule.Settings = {
    RefreshRate = 144,
    TextFont = "Gojiberry Quibble",
    FlagsFont = "Gojiberry Quibble",
    HealthFont = "Gojiberry Quibble",
    TextGradientAnimated = true,
    Enemy = {
        Enabled = false,
        BoxEnabled = false,
        BoxType = "Corner",
        Thickness = 1,
        BoxGlow = false,
        BoxFill = false,
        BoxFillColor1 = Color3.fromRGB(255, 80, 80),
        BoxFillColor2 = Color3.fromRGB(255, 40, 40),
        BoxFillTransparency = 0.7,
        BoxFillRotation = 0,
        BoxFillSpeed = 2,
        Names = false,
        Distance = false,
        Tool = false,
        Flags = false,
        FlagWalking = Color3.fromRGB(255, 255, 255),
        FlagJumping = Color3.fromRGB(0, 255, 0),
        FlagSwimming = Color3.fromRGB(0, 255, 255),
        HealthBar = false,
        HealthText = false,
        ArmorBar = false,
        ArmorHigh = Color3.fromRGB(0, 255, 0),
        ArmorMid = Color3.fromRGB(255, 255, 0),
        ArmorLow = Color3.fromRGB(255, 0, 0),
        HeadDot = false,
        HeadDotColor = Color3.fromRGB(255, 255, 255),
        HeadDotSize = 20,
        HeadDotOutlineThickness = 1,
        TextSize = 12,
        Skeleton = false,
        SkeletonThickness = 1,
        Tracers = false,
        TracerThickness = 1,
        TracerOrigin = "Bottom",
        LineColor = Color3.fromRGB(255, 80, 80),
        NameColor = Color3.fromRGB(255, 255, 255),
        NameColor2 = Color3.fromRGB(200, 200, 200),
        DistanceColor = Color3.fromRGB(255, 255, 255),
        DistanceColor2 = Color3.fromRGB(200, 200, 200),
        ToolColor = Color3.fromRGB(255, 255, 255),
        ToolColor2 = Color3.fromRGB(200, 200, 200),
        HealthHigh = Color3.fromRGB(0, 255, 100),
        HealthMid = Color3.fromRGB(255, 255, 0),
        HealthLow = Color3.fromRGB(255, 40, 40),
        SkeletonColor = Color3.fromRGB(255, 80, 80),
        TracerColor = Color3.fromRGB(255, 80, 80),
    },
    Teammate = {
        Enabled = false,
        BoxEnabled = false,
        BoxType = "Corner",
        Thickness = 1,
        BoxGlow = false,
        BoxFill = false,
        BoxFillColor1 = Color3.fromRGB(0, 180, 255),
        BoxFillColor2 = Color3.fromRGB(0, 100, 200),
        BoxFillTransparency = 0.7,
        BoxFillRotation = 0,
        BoxFillSpeed = 2,
        Names = false,
        Distance = false,
        Tool = false,
        Flags = false,
        FlagWalking = Color3.fromRGB(255, 255, 255),
        FlagJumping = Color3.fromRGB(0, 255, 0),
        FlagSwimming = Color3.fromRGB(0, 255, 255),
        HealthBar = false,
        HealthText = false,
        ArmorBar = false,
        ArmorHigh = Color3.fromRGB(0, 255, 0),
        ArmorMid = Color3.fromRGB(255, 255, 0),
        ArmorLow = Color3.fromRGB(255, 0, 0),
        HeadDot = false,
        HeadDotColor = Color3.fromRGB(255, 255, 255),
        HeadDotSize = 20,
        HeadDotOutlineThickness = 1,
        TextSize = 12,
        Skeleton = false,
        SkeletonThickness = 1,
        Tracers = false,
        TracerThickness = 1,
        TracerOrigin = "Bottom",
        LineColor = Color3.fromRGB(0, 180, 255),
        NameColor = Color3.fromRGB(180, 230, 255),
        NameColor2 = Color3.fromRGB(100, 150, 200),
        DistanceColor = Color3.fromRGB(180, 230, 255),
        DistanceColor2 = Color3.fromRGB(100, 150, 200),
        ToolColor = Color3.fromRGB(180, 230, 255),
        ToolColor2 = Color3.fromRGB(100, 150, 200),
        HealthHigh = Color3.fromRGB(0, 200, 255),
        HealthMid = Color3.fromRGB(100, 200, 255),
        HealthLow = Color3.fromRGB(30, 80, 140),
        SkeletonColor = Color3.fromRGB(0, 180, 255),
        TracerColor = Color3.fromRGB(0, 180, 255),
    },
    AI = {
        Enabled = false,
        BoxEnabled = false,
        BoxType = "Corner",
        Thickness = 1,
        BoxGlow = false,
        BoxFill = false,
        BoxFillColor1 = Color3.fromRGB(255, 200, 50),
        BoxFillColor2 = Color3.fromRGB(255, 150, 0),
        BoxFillTransparency = 0.7,
        BoxFillRotation = 0,
        BoxFillSpeed = 2,
        Names = false,
        Distance = false,
        Tool = false,
        Flags = false,
        FlagWalking = Color3.fromRGB(255, 255, 255),
        FlagJumping = Color3.fromRGB(0, 255, 0),
        FlagSwimming = Color3.fromRGB(0, 255, 255),
        HealthBar = false,
        HealthText = false,
        ArmorBar = false,
        ArmorHigh = Color3.fromRGB(0, 255, 0),
        ArmorMid = Color3.fromRGB(255, 255, 0),
        ArmorLow = Color3.fromRGB(255, 0, 0),
        HeadDot = false,
        HeadDotColor = Color3.fromRGB(255, 255, 255),
        HeadDotSize = 20,
        HeadDotOutlineThickness = 1,
        TextSize = 12,
        Skeleton = false,
        SkeletonThickness = 1,
        Tracers = false,
        TracerThickness = 1,
        TracerOrigin = "Bottom",
        LineColor = Color3.fromRGB(255, 200, 50),
        NameColor = Color3.fromRGB(255, 255, 255),
        NameColor2 = Color3.fromRGB(200, 200, 200),
        DistanceColor = Color3.fromRGB(255, 255, 255),
        DistanceColor2 = Color3.fromRGB(200, 200, 200),
        ToolColor = Color3.fromRGB(255, 255, 255),
        ToolColor2 = Color3.fromRGB(200, 200, 200),
        HealthHigh = Color3.fromRGB(0, 255, 100),
        HealthMid = Color3.fromRGB(255, 255, 0),
        HealthLow = Color3.fromRGB(255, 40, 40),
        SkeletonColor = Color3.fromRGB(255, 200, 50),
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

espModule._drawings = {}
espModule._itemDrawings = {}
espModule._itemHighlights = {}
espModule._isRunning = false
espModule._connections = {}
espModule._bots = {}
espModule._containers = {}
espModule.Fonts = {}
espModule._boxFillAngles = {}

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
local HAS_BOTS_ITEMS = PLACE_ID == 79783567666809
local HAS_CUSTOM_CHARS = PLACE_ID == 138485390344924

local BOX_3D_EDGES = {
    {1,2}, {2,3}, {3,4}, {4,1},
    {5,6}, {6,7}, {7,8}, {8,5},
    {1,5}, {2,6}, {3,7}, {4,8}
}

local function loadFont()
    if next(espModule.Fonts) then return end
    
    local function FontsRegister(Name, Weight, Style, Asset)
        local success, result = pcall(function()
            if not isfile(Asset.Id) then
                writefile(Asset.Id, Asset.Font)
            end
            if isfile(Name .. ".font") then
                delfile(Name .. ".font")
            end
            local Info = {
                name = Name,
                faces = {
                    {
                        name = "Normal",
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(Asset.Id),
                    },
                },
            }
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
            if f then
                espModule.Fonts[Name] = f
            end
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
    if fontName and espModule.Fonts[fontName] then
        return espModule.Fonts[fontName]
    end
    return Font.new("rbxasset://fonts/families/GothamSSm.json")
end

local function GetHealthColor(t, high, mid, low)
    t = math.clamp(t, 0, 1)
    if t >= 0.5 then
        return mid:Lerp(high, (t - 0.5) * 2)
    else
        return low:Lerp(mid, t * 2)
    end
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

    local obj = {
        Frame = frame,
        Stroke = stroke,
        Thickness = props.Thickness or 1,
        OutlineThickness = props.OutlineThickness or 1,
        Color = props.Color or Color3.new(1, 1, 1),
    }

    function obj:Set(from, to)
        if not from or not to then
            frame.Visible = false
            return
        end
        local dist = (to - from).Magnitude
        local center = from:Lerp(to, 0.5)
        local angle = math.deg(math.atan2(to.Y - from.Y, to.X - from.X))
        frame.Position = UDim2.fromOffset(center.X, center.Y)
        frame.Size = UDim2.fromOffset(math.max(dist, 1), self.Thickness)
        frame.Rotation = angle
        frame.Visible = true
    end

    function obj:SetColor(color)
        self.Color = color
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
    return CreateLine({Thickness = 1, OutlineThickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2})
end

local function getCharacterParts(character)
    local isR15 = character:FindFirstChild("UpperTorso") ~= nil
    local parts
    if isR15 then
        parts = {"HumanoidRootPart", "Head", "UpperTorso", "LowerTorso", "LeftHand", "RightHand", "LeftFoot", "RightFoot"}
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
    boxGlowGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
    })
    boxGlowGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 0)
    })
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

    local function createFlag(name, font)
        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.Text = name
        lbl.TextSize = 10
        lbl.TextColor3 = Color3.new(1, 1, 1)
        lbl.TextStrokeTransparency = 0
        lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        lbl.FontFace = font
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextYAlignment = Enum.TextYAlignment.Top
        lbl.AutomaticSize = Enum.AutomaticSize.XY
        lbl.Size = UDim2.fromOffset(0, 0)
        lbl.Visible = false
        lbl.ZIndex = 5
        lbl.Parent = flagsFrame

        local uiGradient = Instance.new("UIGradient")
        uiGradient.Name = "TextGradient"
        uiGradient.Parent = lbl
        return { Frame = lbl }
    end

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
        BoxFillGradient = boxFillGradient,
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
        WalkFlag = createFlag("Walking", getEspFont(espModule.Settings.FlagsFont)),
        JumpFlag = createFlag("Jumping", getEspFont(espModule.Settings.FlagsFont)),
        SwimFlag = createFlag("Swimming", getEspFont(espModule.Settings.FlagsFont)),
        HealthText = CreateText({Center = false, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = getEspFont(espModule.Settings.HealthFont), Visible = false, ZIndex = 5}),
        NameText = CreateText({Center = true, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = getEspFont(espModule.Settings.TextFont), Visible = false, ZIndex = 5}),
        DistanceText = CreateText({Center = false, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = getEspFont(espModule.Settings.FlagsFont), Visible = false, ZIndex = 5}),
        ToolText = CreateText({Center = true, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = getEspFont(espModule.Settings.TextFont), Visible = false, ZIndex = 5}),
        Tracer = CreateLine({Thickness = 1, OutlineThickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
        Skeleton = {
            HeadTorso = MakeBone(),
            TorsoHip = MakeBone(),
            HipL = MakeBone(),
            HipR = MakeBone(),
            LLeg = MakeBone(),
            RLeg = MakeBone(),
            LArm = MakeBone(),
            RArm = MakeBone(),
            LFore = MakeBone(),
            RFore = MakeBone(),
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
    data.BoxGlow.Visible = false
    data.HeadDot.Visible = false
    data.HealthContainer.Visible = false
    data.HealthFill.Visible = false
    data.ArmorContainer.Visible = false
    data.ArmorFill.Visible = false
    data.FlagsFrame.Visible = false
    data.HealthText:Hide()
    data.NameText:Hide()
    data.DistanceText:Hide()
    data.ToolText:Hide()
    data.Tracer:Hide()
    local sk = data.Skeleton
    for _, bone in pairs(sk) do
        bone:Hide()
    end
end

local function RemoveESP(entity)
    local data = espModule._drawings[entity]
    if not data then return end
    for _, v in pairs(data.Full) do v:Destroy() end
    for _, v in pairs(data.Corner) do v:Destroy() end
    for _, v in pairs(data.Entity3DBox) do v:Destroy() end
    data.BoxFill:Destroy()
    data.BoxGlow:Destroy()
    data.HeadDot:Destroy()
    data.HealthContainer:Destroy()
    data.ArmorContainer:Destroy()
    data.FlagsFrame:Destroy()
    data.HealthText:Destroy()
    data.NameText:Destroy()
    data.DistanceText:Destroy()
    data.ToolText:Destroy()
    data.Tracer:Destroy()
    for _, bone in pairs(data.Skeleton) do
        bone:Destroy()
    end
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

local itemTypeMap = {
    ["Safe"] = "Safe", ["Civilian Airdrop"] = "CivilianAirdrop", ["Abandoned Car"] = "AbandonedCar", ["Duffel Bag"] = "DuffelBag",
    ["Food Crate"] = "FoodCrate", ["Leather Pouch"] = "LeatherPouch", ["Supply Crate"] = "SupplyCrate", ["Medical Pouch"] = "MedicalPouch",
    ["DroppedItemContainer"] = "DroppedItemContainer", ["T.C.R Supply Crate"] = "TCRCrate", ["Metal Crate"] = "MetalCrate",
    ["Specops Supply Crate"] = "SpecopsCrate", ["Tall Metal Crate"] = "TallMetalCrate", ["Wooden Crate"] = "WoodenCrate", ["Ammo Box"] = "AmmoBox", ["Dead"] = "Dead",
}

local typeList = {
    "Safe", "Civilian Airdrop", "Abandoned Car", "Duffel Bag", "Food Crate", "Leather Pouch", "Supply Crate", "Medical Pouch",
    "DroppedItemContainer", "T.C.R Supply Crate", "Metal Crate", "Specops Supply Crate", "Tall Metal Crate", "Wooden Crate", "Ammo Box"
}

local function ProcessItem(item)
    if not HAS_BOTS_ITEMS then return end
    if not item:IsA("Model") then return end
    local cfg = espModule.Settings.Items
    if not cfg.Enabled then
        RemoveItemESP(item)
        return
    end

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

    for i = 1, #typeList do
        if string.find(itemName, typeList[i], 1, true) then
            itemType = typeList[i]
            break
        end
    end

    if string.find(itemName, "Dead", 1, true) then
        isDead = true
        if not itemType then itemType = "Dead" end
    end

    if not itemType then
        RemoveItemESP(item)
        return
    end

    local settingsKey = itemTypeMap[itemType]
    if not settingsKey then
        RemoveItemESP(item)
        return
    end

    if isDead then
        if not cfg.Dead.Enabled then
            RemoveItemESP(item)
            return
        end
        settingsKey = "Dead"
    end

    local itemCfg = cfg[settingsKey]
    if not itemCfg or not itemCfg.Enabled then
        RemoveItemESP(item)
        return
    end

    CreateItemESP(item)
    local data = espModule._itemDrawings[item]
    local color = itemCfg.Color or Color3.fromRGB(255, 255, 255)
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
        if showNames then
            nameDistStr = nameDistStr .. " [" .. distM .. "m]"
        else
            nameDistStr = "[" .. distM .. "m]"
        end
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
        hl.FillTransparency = cfg.ChamsFillTransparency
        hl.OutlineTransparency = 1
        hl.Enabled = true
    else
        if espModule._itemHighlights[item] then
            espModule._itemHighlights[item].Enabled = false
        end
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
    if not cfg.Enabled then
        RemoveESP(entity)
        return
    end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not (hrp and humanoid and humanoid.Health > 0) then
        HideESP(espModule._drawings[entity])
        return
    end

    local Camera = Services.CurrentCamera
    if not Camera then return end
    local rawStuds = (Camera.CFrame.Position - hrp.Position).Magnitude
    if rawStuds > MAX_ENTITY_DIST then
        HideESP(espModule._drawings[entity])
        return
    end

    local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
    if not onScreen or hrpPos.Z <= 0 then
        HideESP(espModule._drawings[entity])
        return
    end

    CreateEntityESP(entity)
    local data = espModule._drawings[entity]
    if not data then return end

    local parts, isR15 = getCharacterParts(character)

    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge
    local validParts = 0
    local p = {}
    local vis = {}

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency < 1 then
            local sp, visPt = Camera:WorldToViewportPoint(part.Position)
            if visPt and sp.Z > 0 then
                validParts = validParts + 1
                local cf = part.CFrame
                local size = part.Size
                local corners = {
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
                    local pos, on = Camera:WorldToViewportPoint(corners[i])
                    if on and pos.Z > 0 then
                        if pos.X < minX then minX = pos.X end
                        if pos.Y < minY then minY = pos.Y end
                        if pos.X > maxX then maxX = pos.X end
                        if pos.Y > maxY then maxY = pos.Y end
                    end
                end
            end
        end
    end

    if validParts == 0 then
        HideESP(data)
        return
    end

    local pad = 4
    local x = math.floor(minX - pad + 0.5)
    local y = math.floor(minY - pad + 0.5)
    local sx = math.max(math.floor(maxX - minX + pad * 2 + 0.5), 8)
    local sy = math.max(math.floor(maxY - minY + pad * 2 + 0.5), 8)
    local meters = math.floor(rawStuds / 2.81 + 0.5)
    local textFont = getEspFont(espModule.Settings.TextFont)
    local flagsFont = getEspFont(espModule.Settings.FlagsFont)
    local healthFont = getEspFont(espModule.Settings.HealthFont)

    if cfg.BoxFill and cfg.BoxEnabled then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                if not part:GetAttribute("OriginalColor") then
                    part:SetAttribute("OriginalColor", part.Color)
                    part:SetAttribute("OriginalMaterial", part.Material)
                    part:SetAttribute("OriginalTransparency", part.Transparency)
                end
                part.Color = cfg.BoxFillColor1
                part.Material = Enum.Material.Neon
                part.Transparency = cfg.BoxFillTransparency
            end
        end
    else
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part:GetAttribute("OriginalColor") then
                part.Color = part:GetAttribute("OriginalColor")
                part.Material = part:GetAttribute("OriginalMaterial")
                part.Transparency = part:GetAttribute("OriginalTransparency")
                part:SetAttribute("OriginalColor", nil)
                part:SetAttribute("OriginalMaterial", nil)
                part:SetAttribute("OriginalTransparency", nil)
            end
        end
    end

    if cfg.BoxEnabled then
        if cfg.BoxGlow then
            data.BoxGlow.Position = UDim2.fromOffset(x - 21, y - 21)
            data.BoxGlow.Size = UDim2.fromOffset(sx + 42, sy + 41)
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
                data.HeadDot.BackgroundTransparency = 0

                local stroke = data.HeadDot:FindFirstChild("DotStroke")
                if stroke then
                    stroke.Thickness = cfg.HeadDotOutlineThickness
                    stroke.Color = Color3.new(0, 0, 0)
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

        local hp = math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)

        data.HealthFill.Size = UDim2.fromScale(1, hp)
        data.HealthFill.Visible = true

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
            if grad then
                grad.Color = ColorSequence.new(hCol, hCol)
            end
            data.HealthText.Frame.Visible = true
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
        if armorObj and armorObj:IsA("NumberValue") and armorObj.Value > 0 then
            armor = armorObj.Value
        end

        local barY = y + sy + 2
        local barH = 2

        data.ArmorContainer.Position = UDim2.fromOffset(x, barY)
        data.ArmorContainer.Size = UDim2.fromOffset(sx, barH)
        data.ArmorContainer.Visible = true

        local armRatio = math.clamp(armor / 100, 0, 1)
        data.ArmorFill.Size = UDim2.fromScale(armRatio, 1)
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
        local name = isPlayer and entity.DisplayName or character.Name
        if data.LastNameStr ~= name then
            data.NameText.Frame.Text = name
            data.LastNameStr = name
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
    else
        data.ToolText:Hide()
    end

    if cfg.Flags then
        local walking = humanoid.MoveDirection.Magnitude > 0
        local jumping = false
        local swimming = false
        pcall(function()
            local state = humanoid:GetState()
            jumping = state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping
            swimming = state == Enum.HumanoidStateType.Swimming
        end)

        local activeCount = 0

        if swimming then
            data.SwimFlag.Frame.Visible = true
            ApplyGradient(data.SwimFlag, cfg.FlagSwimming, cfg.FlagSwimming)
            data.SwimFlag.Frame.LayoutOrder = activeCount
            activeCount = activeCount + 1
        else
            data.SwimFlag.Frame.Visible = false
        end

        if jumping then
            data.JumpFlag.Frame.Visible = true
            ApplyGradient(data.JumpFlag, cfg.FlagJumping, cfg.FlagJumping)
            data.JumpFlag.Frame.LayoutOrder = activeCount
            activeCount = activeCount + 1
        else
            data.JumpFlag.Frame.Visible = false
        end

        if walking and not jumping and not swimming then
            data.WalkFlag.Frame.Visible = true
            ApplyGradient(data.WalkFlag, cfg.FlagWalking, cfg.FlagWalking)
            data.WalkFlag.Frame.LayoutOrder = activeCount
            activeCount = activeCount + 1
        else
            data.WalkFlag.Frame.Visible = false
        end

        if activeCount > 0 then
            data.FlagsFrame.Position = UDim2.fromOffset(x + sx + 4, y + 12)
            data.FlagsFrame.Size = UDim2.fromOffset(0, 0)
            data.FlagsFrame.AutomaticSize = Enum.AutomaticSize.XY
            data.FlagsFrame.Visible = true
        else
            data.FlagsFrame.Visible = false
        end
    else
        data.FlagsFrame.Visible = false
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
        local to = Vector2.new(x + sx * 0.5, y + sy)

        data.Tracer:SetColor(cfg.TracerColor)
        data.Tracer:SetThickness(cfg.TracerThickness)
        data.Tracer:SetOutlineThickness(1)
        data.Tracer:Set(from, to)
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
                    bone:SetColor(cfg.SkeletonColor)
                    bone:SetThickness(cfg.SkeletonThickness)
                    bone:SetOutlineThickness(1)
                    bone:Set(a, b)
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
        local sk = data.Skeleton
        for _, bone in pairs(sk) do
            bone:Hide()
        end
    end
end

local _lastUpdate = 0
local _cameraCache = nil
local _cameraCacheTime = 0
local function espLoop()
    local s = espModule.Settings
    local anyEntity = s.Enemy.Enabled or s.Teammate.Enabled or s.AI.Enabled
    local anyItem = s.Items.Enabled and HAS_BOTS_ITEMS
    if not anyEntity and not anyItem then
        for entity in pairs(espModule._drawings) do
            RemoveESP(entity)
        end
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
                if bot and bot.Parent then
                    ProcessEntity(bot)
                end
            end
        else
            local players = Services.Players:GetPlayers()
            for i = 1, #players do
                local player = players[i]
                if player ~= Services.LocalPlayer then
                    ProcessEntity(player)
                end
            end
            if HAS_BOTS_ITEMS then
                local bots = espModule._bots
                for i = 1, #bots do
                    local bot = bots[i]
                    if bot and bot.Parent then
                        ProcessEntity(bot)
                    end
                end
            end
        end
    end

    if anyItem then
        local containers = espModule._containers
        for i = 1, #containers do
            local item = containers[i]
            if item and item.Parent and item:IsA("Model") then
                ProcessItem(item)
            end
        end
    end
end

function espModule:Start()
    if self._isRunning then return end
    self._isRunning = true
    loadFont()

    table.clear(self._bots)
    table.clear(self._containers)

    if HAS_BOTS_ITEMS then
        local botsFolder = Services.WorkSpace:FindFirstChild("IngameBots")
        if botsFolder then
            for _, bot in ipairs(botsFolder:GetChildren()) do
                if bot:IsA("Model") then
                    self._bots[#self._bots + 1] = bot
                end
            end
            self._connections.BotAdded = botsFolder.ChildAdded:Connect(function(child)
                if child:IsA("Model") then
                    self._bots[#self._bots + 1] = child
                end
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
                if item:IsA("Model") then
                    self._containers[#self._containers + 1] = item
                end
            end
            self._connections.ContainerAdded = containers.ChildAdded:Connect(function(child)
                if child:IsA("Model") then
                    self._containers[#self._containers + 1] = child
                end
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
                    if child:IsA("Model") then
                        self._bots[#self._bots + 1] = child
                    end
                end
                self._connections.CharAdded = chars.ChildAdded:Connect(function(child)
                    if child:IsA("Model") then
                        self._bots[#self._bots + 1] = child
                    end
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
    for _, conn in pairs(self._connections) do
        conn:Disconnect()
    end
    self._connections = {}
    for entity in pairs(self._drawings) do
        RemoveESP(entity)
    end
    self._drawings = {}
    for item in pairs(self._itemDrawings) do
        RemoveItemESP(item)
    end
    self._itemDrawings = {}
    self._itemHighlights = {}
    table.clear(self._bots)
    table.clear(self._containers)
end

function espModule:Restart()
    self:Stop()
    self:Start()
end

function espModule:UpdateSettings(newSettings)
    local function merge(t1, t2)
        for k, v in pairs(t2) do
            if type(v) == "table" and type(t1[k]) == "table" then
                merge(t1[k], v)
            else
                t1[k] = v
            end
        end
    end
    merge(self.Settings, newSettings)
end

function espModule:GetSettings()
    return self.Settings
end

function espModule:Toggle()
    if self._isRunning then
        self:Stop()
    else
        self:Start()
    end
end

return espModule
