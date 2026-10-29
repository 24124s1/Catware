print("1")

local espModule = {}

espModule.Settings = {
    RefreshRate = 144,
    TextFont = "Tahoma Modern Bold",
    FlagsFont = "Tahoma Modern Bold",
    HealthFont = "Tahoma Modern Bold",
    Enemy = {
        Enabled = false,
        BoxEnabled = false,
        BoxType = "Corner",
        Thickness = 1,
        BoxFill = false,
        BoxFillColor1 = Color3.fromRGB(255, 80, 80),
        BoxFillColor2 = Color3.fromRGB(255, 40, 40),
        BoxFillTransparency = 0.7,
        BoxFillRotation = 0,
        BoxFillSpeed = 2,
        Names = false,
        Distance = false,
        Tool = false,
        HealthBar = false,
        HealthText = false,
        HeadDot = false,
        HeadDotColor = Color3.fromRGB(255, 255, 255),
        HeadDotSize = 18,
        TextSize = 12,
        Skeleton = false,
        Tracers = false,
        TracerOrigin = "Bottom",
        LineColor = Color3.fromRGB(255, 80, 80),
        NameColor = Color3.fromRGB(255, 255, 255),
        DistanceColor = Color3.fromRGB(255, 255, 255),
        ToolColor = Color3.fromRGB(255, 255, 255),
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
        BoxFill = false,
        BoxFillColor1 = Color3.fromRGB(0, 180, 255),
        BoxFillColor2 = Color3.fromRGB(0, 100, 200),
        BoxFillTransparency = 0.7,
        BoxFillRotation = 0,
        BoxFillSpeed = 2,
        Names = false,
        Distance = false,
        Tool = false,
        HealthBar = false,
        HealthText = false,
        HeadDot = false,
        HeadDotColor = Color3.fromRGB(255, 255, 255),
        HeadDotSize = 18,
        TextSize = 12,
        Skeleton = false,
        Tracers = false,
        TracerOrigin = "Bottom",
        LineColor = Color3.fromRGB(0, 180, 255),
        NameColor = Color3.fromRGB(180, 230, 255),
        DistanceColor = Color3.fromRGB(180, 230, 255),
        ToolColor = Color3.fromRGB(180, 230, 255),
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
        BoxFill = false,
        BoxFillColor1 = Color3.fromRGB(255, 200, 50),
        BoxFillColor2 = Color3.fromRGB(255, 150, 0),
        BoxFillTransparency = 0.7,
        BoxFillRotation = 0,
        BoxFillSpeed = 2,
        Names = false,
        Distance = false,
        Tool = false,
        HealthBar = false,
        HealthText = false,
        HeadDot = false,
        HeadDotColor = Color3.fromRGB(255, 255, 255),
        HeadDotSize = 18,
        TextSize = 12,
        Skeleton = false,
        Tracers = false,
        TracerOrigin = "Bottom",
        LineColor = Color3.fromRGB(255, 200, 50),
        NameColor = Color3.fromRGB(255, 255, 255),
        DistanceColor = Color3.fromRGB(255, 255, 255),
        ToolColor = Color3.fromRGB(255, 255, 255),
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

local FontMap = {
    ["Comfortaa"] = Enum.Font.Gotham,
    ["HankenGrotesk"] = Enum.Font.GothamMedium,
    ["Inter Medium"] = Enum.Font.GothamMedium,
    ["Inter SemiBold"] = Enum.Font.GothamSemibold,
    ["Light Modern"] = Enum.Font.Gotham,
    ["Minecraftia"] = Enum.Font.Code,
    ["ProggyClean"] = Enum.Font.Code,
    ["ProggyTiny"] = Enum.Font.Code,
    ["Rubik"] = Enum.Font.Gotham,
    ["Tahoma Modern Bold"] = Enum.Font.GothamBold,
    ["Tahoma Modern"] = Enum.Font.Gotham,
    ["Verdana"] = Enum.Font.Legacy,
    ["Tahoma 8px"] = Enum.Font.Code,
    ["Open Sans PX"] = Enum.Font.Gotham,
    ["Smallest Pixel-7"] = Enum.Font.Code,
    ["Tahoma Bold"] = Enum.Font.GothamBold,
}

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
    return FontMap[fontName] or Enum.Font.Gotham
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
    frame.ZIndex = props.ZIndex or 1
    frame.Parent = espGui
    
    local obj = { Frame = frame, Thickness = props.Thickness or 1 }
    
    function obj:Set(from, to)
        if not from or not to then
            frame.Visible = false
            return
        end
        local dist = (to - from).Magnitude
        local center = from:Lerp(to, 0.5)
        local angle = math.deg(math.atan2(to.Y - from.Y, to.X - from.X))
        frame.Position = UDim2.fromOffset(center.X, center.Y)
        frame.Size = UDim2.fromOffset(dist, self.Thickness)
        frame.Rotation = angle
        frame.Visible = true
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
    label.Font = props.Font or Enum.Font.Gotham
    label.TextXAlignment = props.Center and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.Visible = props.Visible or false
    label.ZIndex = props.ZIndex or 1
    label.Parent = espGui
    
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
    return {
        Outline = CreateLine({Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
        Line = CreateLine({Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
    }
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
    boxFill.ZIndex = 0
    boxFill.Parent = espGui

    local boxFillGradient = Instance.new("UIGradient")
    boxFillGradient.Parent = boxFill

    local headDot = Instance.new("Frame")
    headDot.BackgroundTransparency = 1
    headDot.BorderSizePixel = 0
    headDot.AnchorPoint = Vector2.new(0.5, 0.5)
    headDot.Visible = false
    headDot.ZIndex = 6
    headDot.Parent = espGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(1, 0)
    uiCorner.Parent = headDot

    local dotStroke = Instance.new("UIStroke")
    dotStroke.Color = Color3.new(1, 1, 1)
    dotStroke.Thickness = 1
    dotStroke.Parent = headDot

    local box3dOutline = {}
    local box3dInner = {}
    for i = 1, 12 do
        box3dOutline["L"..i] = CreateLine({Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1})
        box3dInner["L"..i] = CreateLine({Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2})
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

    espModule._drawings[entity] = {
        FullOutline = {
            Top = CreateLine({Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            Bottom = CreateLine({Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            Left = CreateLine({Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            Right = CreateLine({Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
        },
        Full = {
            Top = CreateLine({Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            Bottom = CreateLine({Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            Left = CreateLine({Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            Right = CreateLine({Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
        },
        CornerOutline = {
            TL1 = CreateLine({Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            TL2 = CreateLine({Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            TR1 = CreateLine({Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            TR2 = CreateLine({Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            BL1 = CreateLine({Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            BL2 = CreateLine({Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            BR1 = CreateLine({Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            BR2 = CreateLine({Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
        },
        Corner = {
            TL1 = CreateLine({Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            TL2 = CreateLine({Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            TR1 = CreateLine({Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            TR2 = CreateLine({Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            BL1 = CreateLine({Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            BL2 = CreateLine({Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            BR1 = CreateLine({Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            BR2 = CreateLine({Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
        },
        Entity3DBoxOutline = box3dOutline,
        Entity3DBox = box3dInner,
        BoxFill = boxFill,
        BoxFillGradient = boxFillGradient,
        HeadDot = headDot,
        HealthContainer = healthContainer,
        HealthFill = healthFill,
        HealthGradient = healthGradient,
        HealthText = CreateText({Center = false, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = Enum.Font.Code, Visible = false, ZIndex = 5}),
        NameText = CreateText({Center = true, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = Enum.Font.Code, Visible = false, ZIndex = 5}),
        DistanceText = CreateText({Center = false, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = Enum.Font.Code, Visible = false, ZIndex = 5}),
        ToolText = CreateText({Center = true, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = Enum.Font.Code, Visible = false, ZIndex = 5}),
        TracerOutline = CreateLine({Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
        Tracer = CreateLine({Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
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
    local fo = data.FullOutline
    fo.Top:Hide() fo.Bottom:Hide() fo.Left:Hide() fo.Right:Hide()
    local f = data.Full
    f.Top:Hide() f.Bottom:Hide() f.Left:Hide() f.Right:Hide()
    
    local co = data.CornerOutline
    co.TL1:Hide() co.TL2:Hide() co.TR1:Hide() co.TR2:Hide()
    co.BL1:Hide() co.BL2:Hide() co.BR1:Hide() co.BR2:Hide()
    
    local c = data.Corner
    c.TL1:Hide() c.TL2:Hide() c.TR1:Hide() c.TR2:Hide()
    c.BL1:Hide() c.BL2:Hide() c.BR1:Hide() c.BR2:Hide()
    
    for _, line in pairs(data.Entity3DBoxOutline) do line:Hide() end
    for _, line in pairs(data.Entity3DBox) do line:Hide() end
    
    data.BoxFill.Visible = false
    data.HeadDot.Visible = false
    data.HealthContainer.Visible = false
    data.HealthFill.Visible = false
    data.HealthText:Hide()
    data.NameText:Hide()
    data.DistanceText:Hide()
    data.ToolText:Hide()
    data.TracerOutline:Hide()
    data.Tracer:Hide()
    local sk = data.Skeleton
    for _, bone in pairs(sk) do
        bone.Outline:Hide()
        bone.Line:Hide()
    end
end

local function RemoveESP(entity)
    local data = espModule._drawings[entity]
    if not data then return end
    for _, v in pairs(data.FullOutline) do v:Destroy() end
    for _, v in pairs(data.Full) do v:Destroy() end
    for _, v in pairs(data.CornerOutline) do v:Destroy() end
    for _, v in pairs(data.Corner) do v:Destroy() end
    for _, v in pairs(data.Entity3DBoxOutline) do v:Destroy() end
    for _, v in pairs(data.Entity3DBox) do v:Destroy() end
    data.BoxFill:Destroy()
    data.HeadDot:Destroy()
    data.HealthContainer:Destroy()
    data.HealthText:Destroy()
    data.NameText:Destroy()
    data.DistanceText:Destroy()
    data.ToolText:Destroy()
    data.TracerOutline:Destroy()
    data.Tracer:Destroy()
    for _, bone in pairs(data.Skeleton) do
        bone.Outline:Destroy()
        bone.Line:Destroy()
    end
    espModule._drawings[entity] = nil
    espModule._boxFillAngles[entity] = nil
end

local function CreateItemESP(item)
    if espModule._itemDrawings[item] then return end
    espModule._itemDrawings[item] = {
        NameDistText = CreateText({Center = true, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = Enum.Font.Code, Visible = false, ZIndex = 5}),
        ContentsText = CreateText({Center = true, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = Enum.Font.Code, Visible = false, ZIndex = 5}),
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
        local textBounds = Services.TextService:GetTextSize(nameDistStr, textSize, showDist and flagsFont or textFont, Vector2.new(1000, 1000))
        data.NameDistText.Frame.Text = nameDistStr
        data.NameDistText.Frame.TextSize = textSize
        data.NameDistText.Frame.Font = showDist and flagsFont or textFont
        data.NameDistText.Frame.TextColor3 = color
        data.NameDistText.Frame.Position = UDim2.fromOffset(pos.X - textBounds.X / 2, pos.Y - 12)
        data.NameDistText.Frame.Size = UDim2.fromOffset(textBounds.X, textBounds.Y)
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
            local textBounds = Services.TextService:GetTextSize(contentStr, textSize - 1, textFont, Vector2.new(1000, 1000))
            data.ContentsText.Frame.Text = contentStr
            data.ContentsText.Frame.TextSize = textSize - 1
            data.ContentsText.Frame.Font = textFont
            data.ContentsText.Frame.TextColor3 = color
            data.ContentsText.Frame.Position = UDim2.fromOffset(pos.X - textBounds.X / 2, pos.Y + 16)
            data.ContentsText.Frame.Size = UDim2.fromOffset(textBounds.X, textBounds.Y)
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

local function ProcessEntity(entity)
    if entity == Services.LocalPlayer then return end
    local character, isPlayer
    if typeof(entity) == "Instance" and entity:IsA("Player") then
        isPlayer = true
        character = entity.Character
    else
        character = entity
    end
    if not character then
        RemoveESP(entity)
        return
    end
    if isPlayer then
        local inRaid = entity:FindFirstChild("InRaid")
        if inRaid and inRaid:IsA("BoolValue") and not inRaid.Value then
            RemoveESP(entity)
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
        RemoveESP(entity)
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

    local is3D = cfg.BoxEnabled and cfg.BoxType == "3D"
    local p = {}
    local vis = {}

    if is3D then
        local bboxCf, bboxSize = character:GetBoundingBox()
        local center = bboxCf.Position
        local hrpCf = hrp.CFrame
        local rot = hrpCf - hrpCf.Position
        local orientedCf = CFrame.new(center) * rot
        local sX, sY, sZ = bboxSize.X/2, bboxSize.Y/2, bboxSize.Z/2

        local v = {
            orientedCf * Vector3.new(sX, sY, sZ),
            orientedCf * Vector3.new(-sX, sY, sZ),
            orientedCf * Vector3.new(-sX, sY, -sZ),
            orientedCf * Vector3.new(sX, sY, -sZ),
            orientedCf * Vector3.new(sX, -sY, sZ),
            orientedCf * Vector3.new(-sX, -sY, sZ),
            orientedCf * Vector3.new(-sX, -sY, -sZ),
            orientedCf * Vector3.new(sX, -sY, -sZ)
        }

        for i = 1, 8 do
            local pos, on = Camera:WorldToViewportPoint(v[i])
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
    else
        for i = 1, #parts do
            local part = character:FindFirstChild(parts[i])
            if part and part:IsA("BasePart") then
                local sp, visPt = Camera:WorldToViewportPoint(part.Position)
                if visPt and sp.Z > 0 then
                    validParts = validParts + 1
                    if sp.X < minX then minX = sp.X end
                    if sp.Y < minY then minY = sp.Y end
                    if sp.X > maxX then maxX = sp.X end
                    if sp.Y > maxY then maxY = sp.Y end
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
        if not espModule._boxFillAngles[entity] then
            espModule._boxFillAngles[entity] = cfg.BoxFillRotation or 0
        end
        if cfg.BoxFillSpeed and cfg.BoxFillSpeed ~= 0 then
            espModule._boxFillAngles[entity] = (espModule._boxFillAngles[entity] + cfg.BoxFillSpeed) % 360
        end

        data.BoxFill.Position = UDim2.fromOffset(x, y)
        data.BoxFill.Size = UDim2.fromOffset(sx, sy)
        data.BoxFillGradient.Color = ColorSequence.new(cfg.BoxFillColor1, cfg.BoxFillColor2)
        data.BoxFillGradient.Transparency = NumberSequence.new(math.clamp(cfg.BoxFillTransparency, 0, 1))
        data.BoxFillGradient.Rotation = espModule._boxFillAngles[entity]
        data.BoxFill.Visible = true
    else
        data.BoxFill.Visible = false
    end

    if cfg.BoxEnabled then
        if cfg.BoxType == "Full" then
            for _, line in pairs(data.Entity3DBoxOutline) do line:Hide() end
            for _, line in pairs(data.Entity3DBox) do line:Hide() end
            local co = data.CornerOutline
            co.TL1:Hide() co.TL2:Hide() co.TR1:Hide() co.TR2:Hide()
            co.BL1:Hide() co.BL2:Hide() co.BR1:Hide() co.BR2:Hide()
            local c = data.Corner
            c.TL1:Hide() c.TL2:Hide() c.TR1:Hide() c.TR2:Hide()
            c.BL1:Hide() c.BL2:Hide() c.BR1:Hide() c.BR2:Hide()

            local fo = data.FullOutline
            fo.Top:Set(Vector2.new(x - 1, y), Vector2.new(x + sx + 1, y))
            fo.Bottom:Set(Vector2.new(x - 1, y + sy), Vector2.new(x + sx + 1, y + sy))
            fo.Left:Set(Vector2.new(x, y - 1), Vector2.new(x, y + sy + 1))
            fo.Right:Set(Vector2.new(x + sx, y - 1), Vector2.new(x + sx, y + sy + 1))

            local f = data.Full
            f.Top.Frame.BackgroundColor3 = cfg.LineColor
            f.Top.Thickness = cfg.Thickness
            f.Top:Set(Vector2.new(x, y), Vector2.new(x + sx, y))
            
            f.Bottom.Frame.BackgroundColor3 = cfg.LineColor
            f.Bottom.Thickness = cfg.Thickness
            f.Bottom:Set(Vector2.new(x, y + sy), Vector2.new(x + sx, y + sy))
            
            f.Left.Frame.BackgroundColor3 = cfg.LineColor
            f.Left.Thickness = cfg.Thickness
            f.Left:Set(Vector2.new(x, y), Vector2.new(x, y + sy))
            
            f.Right.Frame.BackgroundColor3 = cfg.LineColor
            f.Right.Thickness = cfg.Thickness
            f.Right:Set(Vector2.new(x + sx, y), Vector2.new(x + sx, y + sy))
            
        elseif cfg.BoxType == "3D" then
            local co = data.CornerOutline
            co.TL1:Hide() co.TL2:Hide() co.TR1:Hide() co.TR2:Hide()
            co.BL1:Hide() co.BL2:Hide() co.BR1:Hide() co.BR2:Hide()
            local c = data.Corner
            c.TL1:Hide() c.TL2:Hide() c.TR1:Hide() c.TR2:Hide()
            c.BL1:Hide() c.BL2:Hide() c.BR1:Hide() c.BR2:Hide()

            local fo = data.FullOutline
            fo.Top:Hide() fo.Bottom:Hide() fo.Left:Hide() fo.Right:Hide()
            local f = data.Full
            f.Top:Hide() f.Bottom:Hide() f.Left:Hide() f.Right:Hide()

            for i = 1, 12 do
                local e = BOX_3D_EDGES[i]
                local lineO = data.Entity3DBoxOutline["L"..i]
                local line = data.Entity3DBox["L"..i]
                
                if vis[e[1]] and vis[e[2]] then
                    lineO:Set(p[e[1]], p[e[2]])
                    line.Frame.BackgroundColor3 = cfg.LineColor
                    line.Thickness = cfg.Thickness
                    line:Set(p[e[1]], p[e[2]])
                else
                    lineO:Hide()
                    line:Hide()
                end
            end
            
        else
            for _, line in pairs(data.Entity3DBoxOutline) do line:Hide() end
            for _, line in pairs(data.Entity3DBox) do line:Hide() end
            local fo = data.FullOutline
            fo.Top:Hide() fo.Bottom:Hide() fo.Left:Hide() fo.Right:Hide()
            local f = data.Full
            f.Top:Hide() f.Bottom:Hide() f.Left:Hide() f.Right:Hide()

            local len = math.clamp(0.22 + (rawStuds / 400) * 0.18, 0.22, 0.38)
            local cw = math.max(2, math.floor(sx * len + 0.5))
            local ch = math.max(2, math.floor(sy * len + 0.5))

            local co = data.CornerOutline
            co.TL1:Set(Vector2.new(x - 1, y), Vector2.new(x + cw + 1, y))
            co.TL2:Set(Vector2.new(x, y - 1), Vector2.new(x, y + ch + 1))
            co.TR1:Set(Vector2.new(x + sx + 1, y), Vector2.new(x + sx - cw - 1, y))
            co.TR2:Set(Vector2.new(x + sx, y - 1), Vector2.new(x + sx, y + ch + 1))
            co.BL1:Set(Vector2.new(x - 1, y + sy), Vector2.new(x + cw + 1, y + sy))
            co.BL2:Set(Vector2.new(x, y + sy), Vector2.new(x, y + sy - ch))
            co.BR1:Set(Vector2.new(x + sx + 1, y + sy), Vector2.new(x + sx - cw - 1, y + sy))
            co.BR2:Set(Vector2.new(x + sx, y + sy), Vector2.new(x + sx, y + sy - ch))

            local c = data.Corner
            c.TL1.Frame.BackgroundColor3 = cfg.LineColor c.TL1.Thickness = cfg.Thickness
            c.TL1:Set(Vector2.new(x, y), Vector2.new(x + cw, y))
            c.TL2.Frame.BackgroundColor3 = cfg.LineColor c.TL2.Thickness = cfg.Thickness
            c.TL2:Set(Vector2.new(x, y), Vector2.new(x, y + ch))
            c.TR1.Frame.BackgroundColor3 = cfg.LineColor c.TR1.Thickness = cfg.Thickness
            c.TR1:Set(Vector2.new(x + sx, y), Vector2.new(x + sx - cw, y))
            c.TR2.Frame.BackgroundColor3 = cfg.LineColor c.TR2.Thickness = cfg.Thickness
            c.TR2:Set(Vector2.new(x + sx, y), Vector2.new(x + sx, y + ch))
            c.BL1.Frame.BackgroundColor3 = cfg.LineColor c.BL1.Thickness = cfg.Thickness
            c.BL1:Set(Vector2.new(x, y + sy), Vector2.new(x + cw, y + sy))
            c.BL2.Frame.BackgroundColor3 = cfg.LineColor c.BL2.Thickness = cfg.Thickness
            c.BL2:Set(Vector2.new(x, y + sy), Vector2.new(x, y + sy - ch))
            c.BR1.Frame.BackgroundColor3 = cfg.LineColor c.BR1.Thickness = cfg.Thickness
            c.BR1:Set(Vector2.new(x + sx, y + sy), Vector2.new(x + sx - cw, y + sy))
            c.BR2.Frame.BackgroundColor3 = cfg.LineColor c.BR2.Thickness = cfg.Thickness
            c.BR2:Set(Vector2.new(x + sx, y + sy), Vector2.new(x + sx, y + sy - ch))
        end
    else
        for _, line in pairs(data.Entity3DBoxOutline) do line:Hide() end
        for _, line in pairs(data.Entity3DBox) do line:Hide() end
        local fo = data.FullOutline
        fo.Top:Hide() fo.Bottom:Hide() fo.Left:Hide() fo.Right:Hide()
        local f = data.Full
        f.Top:Hide() f.Bottom:Hide() f.Left:Hide() f.Right:Hide()
        local co = data.CornerOutline
        co.TL1:Hide() co.TL2:Hide() co.TR1:Hide() co.TR2:Hide()
        co.BL1:Hide() co.BL2:Hide() co.BR1:Hide() co.BR2:Hide()
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
                local stroke = data.HeadDot:FindFirstChildOfClass("UIStroke")
                if stroke then
                    stroke.Color = cfg.HeadDotColor
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
            local textBounds = Services.TextService:GetTextSize(textStr, cfg.TextSize, healthFont, Vector2.new(1000, 1000))
            data.HealthText.Frame.Text = textStr
            data.HealthText.Frame.TextSize = cfg.TextSize
            data.HealthText.Frame.Font = healthFont
            local tw = textBounds.X
            local fillH = sy * hp
            local ty = math.clamp(y + sy - fillH - 5, y - 2, y + sy - 10)
            data.HealthText.Frame.Position = UDim2.fromOffset(barX - 3 - tw, ty)
            data.HealthText.Frame.Size = UDim2.fromOffset(tw, textBounds.Y)
            data.HealthText.Frame.TextColor3 = GetHealthColor(hp, cfg.HealthHigh, cfg.HealthMid, cfg.HealthLow)
            data.HealthText.Frame.Visible = true
        else
            data.HealthText:Hide()
        end
    else
        data.HealthContainer.Visible = false
        data.HealthFill.Visible = false
        data.HealthText:Hide()
    end

    if cfg.Names then
        local name = isPlayer and entity.DisplayName or character.Name
        local textBounds = Services.TextService:GetTextSize(name, cfg.TextSize, textFont, Vector2.new(1000, 1000))
        data.NameText.Frame.Text = name
        data.NameText.Frame.TextSize = cfg.TextSize
        data.NameText.Frame.Font = textFont
        data.NameText.Frame.TextColor3 = cfg.NameColor
        data.NameText.Frame.Position = UDim2.fromOffset((x + sx * 0.5) - (textBounds.X / 2), y - 14)
        data.NameText.Frame.Size = UDim2.fromOffset(textBounds.X, textBounds.Y)
        data.NameText.Frame.Visible = true
    else
        data.NameText:Hide()
    end

    if cfg.Distance then
        local textStr = "[" .. tostring(meters) .. "m]"
        local textBounds = Services.TextService:GetTextSize(textStr, cfg.TextSize, flagsFont, Vector2.new(1000, 1000))
        data.DistanceText.Frame.Text = textStr
        data.DistanceText.Frame.TextSize = cfg.TextSize
        data.DistanceText.Frame.Font = flagsFont
        data.DistanceText.Frame.TextColor3 = cfg.DistanceColor
        data.DistanceText.Frame.Position = UDim2.fromOffset(x + sx + 4, y - 1)
        data.DistanceText.Frame.Size = UDim2.fromOffset(textBounds.X, textBounds.Y)
        data.DistanceText.Frame.Visible = true
    else
        data.DistanceText:Hide()
    end

    if cfg.Tool then
        local tool = character:FindFirstChildOfClass("Tool")
        local textStr = tool and tool.Name or "None"
        local textBounds = Services.TextService:GetTextSize(textStr, cfg.TextSize, textFont, Vector2.new(1000, 1000))
        data.ToolText.Frame.Text = textStr
        data.ToolText.Frame.TextSize = cfg.TextSize
        data.ToolText.Frame.Font = textFont
        data.ToolText.Frame.TextColor3 = cfg.ToolColor
        data.ToolText.Frame.Position = UDim2.fromOffset((x + sx * 0.5) - (textBounds.X / 2), y + sy + 2)
        data.ToolText.Frame.Size = UDim2.fromOffset(textBounds.X, textBounds.Y)
        data.ToolText.Frame.Visible = true
    else
        data.ToolText:Hide()
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
        
        data.TracerOutline.Frame.BackgroundColor3 = Color3.new(0, 0, 0)
        data.TracerOutline.Thickness = 3
        data.TracerOutline:Set(from, to)

        data.Tracer.Frame.BackgroundColor3 = cfg.TracerColor
        data.Tracer.Thickness = 1
        data.Tracer:Set(from, to)
    else
        data.TracerOutline:Hide()
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
                    bone.Outline.Thickness = 3
                    bone.Outline:Set(a, b)
                    bone.Line.Frame.BackgroundColor3 = cfg.SkeletonColor
                    bone.Line.Thickness = 1
                    bone.Line:Set(a, b)
                    return
                end
            end
            bone.Outline:Hide()
            bone.Line:Hide()
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
            bone.Outline:Hide()
            bone.Line:Hide()
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
