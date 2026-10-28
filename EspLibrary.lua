print('8')

local espModule = {}

espModule.Settings = {
    RefreshRate = 144,
    TextFont = "ProggyTiny",
    FlagsFont = "ProggyTiny",
    HealthFont = "ProggyTiny",
    Enemy = {
        Enabled = false,
        BoxEnabled = false,
        BoxType = "Corner",
        Thickness = 1,
        BoxFill = false,
        BoxFillColor1 = Color3.fromRGB(255, 80, 80),
        BoxFillColor2 = Color3.fromRGB(255, 40, 40),
        BoxFillTransparency = 0.7,
        BoxFillRotation = 90,
        BoxFillSpeed = 0,
        Names = false,
        Distance = false,
        Tool = false,
        HealthBar = false,
        HealthText = false,
        TextSize = 12,
        Skeleton = false,
        SkeletonThickness = 1,
        Chams = false,
        ChamsFill = {0, 255, 100, 0.35},
        ChamsOutline = {0, 255, 100, 0},
        ChamsGlow = true,
        ChamsGlowFill = {0, 255, 100, 0.6},
        Tracers = false,
        TracerThickness = 1,
        TracerOrigin = "Bottom",
        LineColor = Color3.fromRGB(0, 255, 100),
        TextColor = Color3.fromRGB(255, 255, 255),
        HealthHigh = Color3.fromRGB(0, 255, 100),
        HealthMid = Color3.fromRGB(255, 255, 0),
        HealthLow = Color3.fromRGB(255, 40, 40),
        SkeletonColor = Color3.fromRGB(0, 0, 0),
        TracerColor = Color3.fromRGB(0, 255, 100),
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
        BoxFillRotation = 90,
        BoxFillSpeed = 0,
        Names = false,
        Distance = false,
        Tool = false,
        HealthBar = false,
        HealthText = false,
        TextSize = 12,
        Skeleton = false,
        SkeletonThickness = 1,
        Chams = false,
        ChamsFill = {0, 180, 255, 0.25},
        ChamsOutline = {0, 180, 255, 0},
        ChamsGlow = true,
        ChamsGlowFill = {0, 180, 255, 0.55},
        Tracers = false,
        TracerThickness = 1,
        TracerOrigin = "Bottom",
        LineColor = Color3.fromRGB(0, 180, 255),
        TextColor = Color3.fromRGB(180, 230, 255),
        HealthHigh = Color3.fromRGB(0, 200, 255),
        HealthMid = Color3.fromRGB(100, 200, 255),
        HealthLow = Color3.fromRGB(30, 80, 140),
        SkeletonColor = Color3.fromRGB(0, 0, 0),
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
        BoxFillRotation = 90,
        BoxFillSpeed = 0,
        Names = false,
        Distance = false,
        Tool = false,
        HealthBar = false,
        HealthText = false,
        TextSize = 12,
        Skeleton = false,
        SkeletonThickness = 1,
        Chams = false,
        ChamsFill = {255, 200, 50, 0.35},
        ChamsOutline = {255, 200, 50, 0},
        ChamsGlow = true,
        ChamsGlowFill = {255, 200, 50, 0.6},
        Tracers = false,
        TracerThickness = 1,
        TracerOrigin = "Bottom",
        LineColor = Color3.fromRGB(255, 200, 50),
        TextColor = Color3.fromRGB(255, 255, 255),
        HealthHigh = Color3.fromRGB(0, 255, 100),
        HealthMid = Color3.fromRGB(255, 255, 0),
        HealthLow = Color3.fromRGB(255, 40, 40),
        SkeletonColor = Color3.fromRGB(0, 0, 0),
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
espModule._highlights = {}
espModule._glowHighlights = {}
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
}
Services.CurrentCamera = Services.WorkSpace.CurrentCamera
Services.LocalPlayer = Services.Players.LocalPlayer

local PixelFont = nil
local MAX_ENTITY_DIST = 1200
local MAX_ITEM_DIST_MULT = 2.81
local PLACE_ID = game.PlaceId
local HAS_BOTS_ITEMS = PLACE_ID == 79783567666809
local HAS_CUSTOM_CHARS = PLACE_ID == 138485390344924

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
    if PixelFont then return PixelFont end
    return Drawing.Fonts.UI or Drawing.Fonts.System or Drawing.Fonts.Monospace
end

local function loadFont()
    if next(espModule.Fonts) then return end
    local FontFolder = "esp_fonts"
    if not isfolder(FontFolder) then pcall(makefolder, FontFolder) end

    local fontList = {
        {"Comfortaa", "Comfortaa-Regular.ttf"},
        {"HankenGrotesk", "HankenGrotesk-SemiBold.ttf"},
        {"Inter Medium", "Inter_28pt-Medium.ttf"},
        {"Inter SemiBold", "Inter_28pt-SemiBold.ttf"},
        {"Light Modern", "Light Modern.ttf"},
        {"Minecraftia", "Minecraftia-Regular.ttf"},
        {"ProggyClean", "ProggyClean.ttf"},
        {"ProggyTiny", "ProggyTiny.ttf"},
        {"Rubik", "Rubik-Regular.ttf"},
        {"Tahoma Modern Bold", "Tahoma-Modern-Bold.ttf"},
        {"Tahoma Modern", "Tahoma-Modern.ttf"},
        {"Verdana", "Verdana-Font.ttf"},
        {"Tahoma 8px", "fs-tahoma-8px.ttf"},
        {"Open Sans PX", "open-sans-px.ttf"},
        {"Smallest Pixel-7", "smallest_pixel-7.ttf"},
        {"Tahoma Bold", "tahoma_bold.ttf"},
        {"XPTahoma", "Tahoma8PTBOLD.ttf"},
    }

    local baseUrl = "https://raw.githubusercontent.com/i77lhm/storage/main/fonts/"
    local altUrls = {
        ["Tahoma8PTBOLD.ttf"] = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/TAHOMA-8PT-BOLD-WINDOWS-XP.TTF",
        ["smallest_pixel-7.ttf"] = "https://raw.githubusercontent.com/sametexe001/luas/main/smallest_pixel-7.ttf",
    }

    for _, entry in ipairs(fontList) do
        local Name, FileName = entry[1], entry[2]
        local Path = FontFolder .. "/" .. FileName
        local data = nil
        pcall(function()
            if isfile and isfile(Path) then data = readfile(Path) end
        end)
        if not data or #data < 100 then
            local url = altUrls[FileName] or (baseUrl .. FileName:gsub(" ", "%%20"))
            local success, content = pcall(function() return game:HttpGet(url) end)
            if success and content and #content > 100 then
                data = content
                pcall(function() if writefile then writefile(Path, content) end end)
            end
        end
        if data and #data > 100 then
            local success, font = pcall(function()
                local f = Drawing.new("Font")
                f.Data = data
                return f
            end)
            if success and font then espModule.Fonts[Name] = font end
        end
    end

    if not espModule.Fonts["Tahoma"] then
        espModule.Fonts["Tahoma"] = espModule.Fonts["Tahoma Modern"] or espModule.Fonts["Tahoma 8px"] or espModule.Fonts["XPTahoma"]
    end
    if not espModule.Fonts["Consolas Bold"] then
        espModule.Fonts["Consolas Bold"] = espModule.Fonts["ProggyClean"] or espModule.Fonts["Smallest Pixel-7"]
    end
    if not espModule.Fonts["SmallestPixel"] then
        espModule.Fonts["SmallestPixel"] = espModule.Fonts["Smallest Pixel-7"]
    end

    PixelFont = espModule.Fonts["ProggyTiny"] or espModule.Fonts["Smallest Pixel-7"] or espModule.Fonts["ProggyClean"]
    if not PixelFont then pcall(function() PixelFont = Drawing.Fonts.UI end) end
    if not PixelFont then pcall(function() PixelFont = Drawing.Fonts.System end) end
    if not PixelFont then PixelFont = Drawing.Fonts.Monospace end
end

local function Create(type, props)
    local obj = Drawing.new(type)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

local function MakeBone()
    return {
        Outline = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
        Line = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
    }
end

local function Color4ToColor3(c4)
    if typeof(c4) == "Color3" then return c4, 0 end
    if type(c4) == "table" then
        return Color3.fromRGB(c4[1] or 255, c4[2] or 255, c4[3] or 255), c4[4] or 0
    end
    return Color3.new(1, 1, 1), 0
end

local function GetHealthColor(hp, high, mid, low)
    hp = math.clamp(hp, 0, 1)
    if hp >= 0.5 then
        return mid:Lerp(high, (hp - 0.5) * 2)
    else
        return low:Lerp(mid, hp * 2)
    end
end

local function CreateEntityESP(entity)
    if espModule._drawings[entity] then return end
    espModule._drawings[entity] = {
        FullOutline = {
            Top = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            Bottom = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            Left = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            Right = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
        },
        Full = {
            Top = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            Bottom = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            Left = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            Right = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
        },
        CornerOutline = {
            TL1 = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            TL2 = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            TR1 = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            TR2 = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            BL1 = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            BL2 = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            BR1 = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            BR2 = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
        },
        Corner = {
            TL1 = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            TL2 = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            TR1 = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            TR2 = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            BL1 = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            BL2 = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            BR1 = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            BR2 = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
        },
        BoxFill = Create("Square", {Filled = true, Visible = false, ZIndex = 0}),
        HealthBGOutline = Create("Square", {Filled = false, Thickness = 1, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 2}),
        HealthBG = Create("Square", {Filled = true, Color = Color3.fromRGB(15, 15, 15), Visible = false, ZIndex = 3}),
        HealthFill = Create("Square", {Filled = true, Color = Color3.fromRGB(0, 255, 100), Visible = false, ZIndex = 4}),
        HealthText = Create("Text", {Center = false, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = Drawing.Fonts.Monospace, Visible = false, ZIndex = 5}),
        NameText = Create("Text", {Center = true, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = Drawing.Fonts.Monospace, Visible = false, ZIndex = 5}),
        DistanceText = Create("Text", {Center = false, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = Drawing.Fonts.Monospace, Visible = false, ZIndex = 5}),
        ToolText = Create("Text", {Center = true, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = Drawing.Fonts.Monospace, Visible = false, ZIndex = 5}),
        Tracer = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
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
    fo.Top.Visible = false
    fo.Bottom.Visible = false
    fo.Left.Visible = false
    fo.Right.Visible = false
    local f = data.Full
    f.Top.Visible = false
    f.Bottom.Visible = false
    f.Left.Visible = false
    f.Right.Visible = false
    local co = data.CornerOutline
    co.TL1.Visible = false
    co.TL2.Visible = false
    co.TR1.Visible = false
    co.TR2.Visible = false
    co.BL1.Visible = false
    co.BL2.Visible = false
    co.BR1.Visible = false
    co.BR2.Visible = false
    local c = data.Corner
    c.TL1.Visible = false
    c.TL2.Visible = false
    c.TR1.Visible = false
    c.TR2.Visible = false
    c.BL1.Visible = false
    c.BL2.Visible = false
    c.BR1.Visible = false
    c.BR2.Visible = false
    data.BoxFill.Visible = false
    data.HealthBG.Visible = false
    data.HealthBGOutline.Visible = false
    data.HealthFill.Visible = false
    data.HealthText.Visible = false
    data.NameText.Visible = false
    data.DistanceText.Visible = false
    data.ToolText.Visible = false
    data.Tracer.Visible = false
    local sk = data.Skeleton
    for _, bone in pairs(sk) do
        bone.Outline.Visible = false
        bone.Line.Visible = false
    end
end

local function RemoveESP(entity)
    local data = espModule._drawings[entity]
    if not data then return end
    for _, v in pairs(data.FullOutline) do v:Remove() end
    for _, v in pairs(data.Full) do v:Remove() end
    for _, v in pairs(data.CornerOutline) do v:Remove() end
    for _, v in pairs(data.Corner) do v:Remove() end
    data.BoxFill:Remove()
    data.HealthBG:Remove()
    data.HealthBGOutline:Remove()
    data.HealthFill:Remove()
    data.HealthText:Remove()
    data.NameText:Remove()
    data.DistanceText:Remove()
    data.ToolText:Remove()
    data.Tracer:Remove()
    for _, bone in pairs(data.Skeleton) do
        bone.Outline:Remove()
        bone.Line:Remove()
    end
    espModule._drawings[entity] = nil
    espModule._boxFillAngles[entity] = nil
    if espModule._highlights[entity] then
        espModule._highlights[entity]:Destroy()
        espModule._highlights[entity] = nil
    end
    if espModule._glowHighlights[entity] then
        espModule._glowHighlights[entity]:Destroy()
        espModule._glowHighlights[entity] = nil
    end
end

local function CreateItemESP(item)
    if espModule._itemDrawings[item] then return end
    espModule._itemDrawings[item] = {
        NameDistText = Create("Text", {Center = true, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = Drawing.Fonts.Monospace, Visible = false, ZIndex = 5}),
        ContentsText = Create("Text", {Center = true, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = Drawing.Fonts.Monospace, Visible = false, ZIndex = 5}),
    }
end

local function RemoveItemESP(item)
    local data = espModule._itemDrawings[item]
    if not data then return end
    data.NameDistText:Remove()
    data.ContentsText:Remove()
    espModule._itemDrawings[item] = nil
    if espModule._itemHighlights[item] then
        espModule._itemHighlights[item]:Destroy()
        espModule._itemHighlights[item] = nil
    end
end

local itemTypeMap = {
    ["Safe"] = "Safe",
    ["Civilian Airdrop"] = "CivilianAirdrop",
    ["Abandoned Car"] = "AbandonedCar",
    ["Duffel Bag"] = "DuffelBag",
    ["Food Crate"] = "FoodCrate",
    ["Leather Pouch"] = "LeatherPouch",
    ["Supply Crate"] = "SupplyCrate",
    ["Medical Pouch"] = "MedicalPouch",
    ["DroppedItemContainer"] = "DroppedItemContainer",
    ["T.C.R Supply Crate"] = "TCRCrate",
    ["Metal Crate"] = "MetalCrate",
    ["Specops Supply Crate"] = "SpecopsCrate",
    ["Tall Metal Crate"] = "TallMetalCrate",
    ["Wooden Crate"] = "WoodenCrate",
    ["Ammo Box"] = "AmmoBox",
    ["Dead"] = "Dead",
}

local typeList = {
    "Safe", "Civilian Airdrop", "Abandoned Car", "Duffel Bag",
    "Food Crate", "Leather Pouch", "Supply Crate", "Medical Pouch",
    "DroppedItemContainer", "T.C.R Supply Crate", "Metal Crate",
    "Specops Supply Crate", "Tall Metal Crate", "Wooden Crate", "Ammo Box"
}

local bodyParts = {"HumanoidRootPart", "Head", "LeftFoot", "RightFoot", "LeftHand", "RightHand"}

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
            data.NameDistText.Visible = false
            data.ContentsText.Visible = false
            if espModule._itemHighlights[item] then espModule._itemHighlights[item].Enabled = false end
        end
        return
    end

    local dist = (camera.CFrame.Position - pivot.Position).Magnitude
    if dist > cfg.MaxDistance * MAX_ITEM_DIST_MULT then
        local data = espModule._itemDrawings[item]
        if data then
            data.NameDistText.Visible = false
            data.ContentsText.Visible = false
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
        data.NameDistText.Text = nameDistStr
        data.NameDistText.Size = textSize
        data.NameDistText.Font = showDist and flagsFont or textFont
        data.NameDistText.Color = color
        data.NameDistText.Position = Vector2.new(pos.X, pos.Y - 12)
        data.NameDistText.Visible = true
    else
        data.NameDistText.Visible = false
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
            data.ContentsText.Text = contentStr
            data.ContentsText.Size = textSize - 1
            data.ContentsText.Font = textFont
            data.ContentsText.Color = color
            data.ContentsText.Position = Vector2.new(pos.X, pos.Y + 16)
            data.ContentsText.Visible = true
        else
            data.ContentsText.Visible = false
        end
    else
        data.ContentsText.Visible = false
    end

    if cfg.Chams then
        local hl = espModule._itemHighlights[item]
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name = "ItemHighlight"
            hl.Parent = Services.CoreGui
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
        if espModule._highlights[entity] then espModule._highlights[entity].Enabled = false end
        if espModule._glowHighlights[entity] then espModule._glowHighlights[entity].Enabled = false end
        return
    end

    local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
    if not onScreen or hrpPos.Z <= 0 then
        HideESP(espModule._drawings[entity])
        if espModule._highlights[entity] then espModule._highlights[entity].Enabled = false end
        if espModule._glowHighlights[entity] then espModule._glowHighlights[entity].Enabled = false end
        return
    end

    CreateEntityESP(entity)
    local data = espModule._drawings[entity]
    if not data then return end

    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge
    local validParts = 0

    for i = 1, #bodyParts do
        local part = character:FindFirstChild(bodyParts[i])
        if part and part:IsA("BasePart") then
            local sp, vis = Camera:WorldToViewportPoint(part.Position)
            if vis and sp.Z > 0 then
                validParts = validParts + 1
                if sp.X < minX then minX = sp.X end
                if sp.Y < minY then minY = sp.Y end
                if sp.X > maxX then maxX = sp.X end
                if sp.Y > maxY then maxY = sp.Y end
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

    if cfg.BoxFill then
        if not espModule._boxFillAngles[entity] then
            espModule._boxFillAngles[entity] = cfg.BoxFillRotation or 90
        end
        if cfg.BoxFillSpeed and cfg.BoxFillSpeed ~= 0 then
            espModule._boxFillAngles[entity] = (espModule._boxFillAngles[entity] + cfg.BoxFillSpeed) % 360
        end
        local t = (math.sin(math.rad(espModule._boxFillAngles[entity])) + 1) / 2
        local fillCol = cfg.BoxFillColor1:Lerp(cfg.BoxFillColor2, t)
        data.BoxFill.Size = Vector2.new(sx, sy)
        data.BoxFill.Position = Vector2.new(x, y)
        data.BoxFill.Color = fillCol
        data.BoxFill.Transparency = cfg.BoxFillTransparency or 0.7
        data.BoxFill.Visible = true
    else
        data.BoxFill.Visible = false
    end

    if cfg.BoxEnabled then
        if cfg.BoxType == "Full" then
            local co = data.CornerOutline
            co.TL1.Visible = false co.TL2.Visible = false
            co.TR1.Visible = false co.TR2.Visible = false
            co.BL1.Visible = false co.BL2.Visible = false
            co.BR1.Visible = false co.BR2.Visible = false
            local c = data.Corner
            c.TL1.Visible = false c.TL2.Visible = false
            c.TR1.Visible = false c.TR2.Visible = false
            c.BL1.Visible = false c.BL2.Visible = false
            c.BR1.Visible = false c.BR2.Visible = false

            local fo = data.FullOutline
            fo.Top.From = Vector2.new(x - 1, y)
            fo.Top.To = Vector2.new(x + sx + 1, y)
            fo.Top.Visible = true
            fo.Bottom.From = Vector2.new(x - 1, y + sy)
            fo.Bottom.To = Vector2.new(x + sx + 1, y + sy)
            fo.Bottom.Visible = true
            fo.Left.From = Vector2.new(x, y - 1)
            fo.Left.To = Vector2.new(x, y + sy + 1)
            fo.Left.Visible = true
            fo.Right.From = Vector2.new(x + sx, y - 1)
            fo.Right.To = Vector2.new(x + sx, y + sy + 1)
            fo.Right.Visible = true

            local f = data.Full
            f.Top.From = Vector2.new(x, y)
            f.Top.To = Vector2.new(x + sx, y)
            f.Top.Color = cfg.LineColor
            f.Top.Thickness = cfg.Thickness
            f.Top.Visible = true
            f.Bottom.From = Vector2.new(x, y + sy)
            f.Bottom.To = Vector2.new(x + sx, y + sy)
            f.Bottom.Color = cfg.LineColor
            f.Bottom.Thickness = cfg.Thickness
            f.Bottom.Visible = true
            f.Left.From = Vector2.new(x, y)
            f.Left.To = Vector2.new(x, y + sy)
            f.Left.Color = cfg.LineColor
            f.Left.Thickness = cfg.Thickness
            f.Left.Visible = true
            f.Right.From = Vector2.new(x + sx, y)
            f.Right.To = Vector2.new(x + sx, y + sy)
            f.Right.Color = cfg.LineColor
            f.Right.Thickness = cfg.Thickness
            f.Right.Visible = true
        else
            local fo = data.FullOutline
            fo.Top.Visible = false
            fo.Bottom.Visible = false
            fo.Left.Visible = false
            fo.Right.Visible = false
            local f = data.Full
            f.Top.Visible = false
            f.Bottom.Visible = false
            f.Left.Visible = false
            f.Right.Visible = false

            local len = math.clamp(0.22 + (rawStuds / 400) * 0.18, 0.22, 0.38)
            local cw = math.max(2, math.floor(sx * len + 0.5))
            local ch = math.max(2, math.floor(sy * len + 0.5))

            local co = data.CornerOutline
            co.TL1.From = Vector2.new(x - 1, y) co.TL1.To = Vector2.new(x + cw + 1, y) co.TL1.Visible = true
            co.TL2.From = Vector2.new(x, y - 1) co.TL2.To = Vector2.new(x, y + ch + 1) co.TL2.Visible = true
            co.TR1.From = Vector2.new(x + sx + 1, y) co.TR1.To = Vector2.new(x + sx - cw - 1, y) co.TR1.Visible = true
            co.TR2.From = Vector2.new(x + sx, y - 1) co.TR2.To = Vector2.new(x + sx, y + ch + 1) co.TR2.Visible = true
            co.BL1.From = Vector2.new(x - 1, y + sy) co.BL1.To = Vector2.new(x + cw + 1, y + sy) co.BL1.Visible = true
            co.BL2.From = Vector2.new(x, y + sy + 1) co.BL2.To = Vector2.new(x, y + sy - ch) co.BL2.Visible = true
            co.BR1.From = Vector2.new(x + sx + 1, y + sy) co.BR1.To = Vector2.new(x + sx - cw - 1, y + sy) co.BR1.Visible = true
            co.BR2.From = Vector2.new(x + sx, y + sy + 1) co.BR2.To = Vector2.new(x + sx, y + sy - ch) co.BR2.Visible = true

            local c = data.Corner
            c.TL1.From = Vector2.new(x, y) c.TL1.To = Vector2.new(x + cw, y) c.TL1.Color = cfg.LineColor c.TL1.Thickness = cfg.Thickness c.TL1.Visible = true
            c.TL2.From = Vector2.new(x, y) c.TL2.To = Vector2.new(x, y + ch) c.TL2.Color = cfg.LineColor c.TL2.Thickness = cfg.Thickness c.TL2.Visible = true
            c.TR1.From = Vector2.new(x + sx, y) c.TR1.To = Vector2.new(x + sx - cw, y) c.TR1.Color = cfg.LineColor c.TR1.Thickness = cfg.Thickness c.TR1.Visible = true
            c.TR2.From = Vector2.new(x + sx, y) c.TR2.To = Vector2.new(x + sx, y + ch) c.TR2.Color = cfg.LineColor c.TR2.Thickness = cfg.Thickness c.TR2.Visible = true
            c.BL1.From = Vector2.new(x, y + sy) c.BL1.To = Vector2.new(x + cw, y + sy) c.BL1.Color = cfg.LineColor c.BL1.Thickness = cfg.Thickness c.BL1.Visible = true
            c.BL2.From = Vector2.new(x, y + sy) c.BL2.To = Vector2.new(x, y + sy - ch) c.BL2.Color = cfg.LineColor c.BL2.Thickness = cfg.Thickness c.BL2.Visible = true
            c.BR1.From = Vector2.new(x + sx, y + sy) c.BR1.To = Vector2.new(x + sx - cw, y + sy) c.BR1.Color = cfg.LineColor c.BR1.Thickness = cfg.Thickness c.BR1.Visible = true
            c.BR2.From = Vector2.new(x + sx, y + sy) c.BR2.To = Vector2.new(x + sx, y + sy - ch) c.BR2.Color = cfg.LineColor c.BR2.Thickness = cfg.Thickness c.BR2.Visible = true
        end
    else
        local fo = data.FullOutline
        fo.Top.Visible = false fo.Bottom.Visible = false fo.Left.Visible = false fo.Right.Visible = false
        local f = data.Full
        f.Top.Visible = false f.Bottom.Visible = false f.Left.Visible = false f.Right.Visible = false
        local co = data.CornerOutline
        co.TL1.Visible = false co.TL2.Visible = false co.TR1.Visible = false co.TR2.Visible = false
        co.BL1.Visible = false co.BL2.Visible = false co.BR1.Visible = false co.BR2.Visible = false
        local c = data.Corner
        c.TL1.Visible = false c.TL2.Visible = false c.TR1.Visible = false c.TR2.Visible = false
        c.BL1.Visible = false c.BL2.Visible = false c.BR1.Visible = false c.BR2.Visible = false
    end

    if cfg.HealthBar then
        local barX = x - 5
        local barW = 2
        local hp = math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)
        local fillH = math.floor(sy * hp + 0.5)
        local healthCol = GetHealthColor(hp, cfg.HealthHigh, cfg.HealthMid, cfg.HealthLow)

        data.HealthBGOutline.Size = Vector2.new(barW + 2, sy + 2)
        data.HealthBGOutline.Position = Vector2.new(barX - 1, y - 1)
        data.HealthBGOutline.Visible = true
        data.HealthBG.Size = Vector2.new(barW, sy)
        data.HealthBG.Position = Vector2.new(barX, y)
        data.HealthBG.Visible = true

        data.HealthFill.Size = Vector2.new(barW, fillH)
        data.HealthFill.Position = Vector2.new(barX, y + sy - fillH)
        data.HealthFill.Color = healthCol
        data.HealthFill.Visible = true

        if cfg.HealthText then
            local hpVal = math.floor(humanoid.Health + 0.5)
            data.HealthText.Text = tostring(hpVal)
            data.HealthText.Size = cfg.TextSize
            data.HealthText.Font = healthFont
            local tw = data.HealthText.TextBounds.X
            local ty = math.clamp(y + sy - fillH - 5, y - 2, y + sy - 10)
            data.HealthText.Position = Vector2.new(barX - 3 - tw, ty)
            data.HealthText.Color = Color3.new(1, 1, 1)
            data.HealthText.Visible = true
        else
            data.HealthText.Visible = false
        end
    else
        data.HealthBG.Visible = false
        data.HealthBGOutline.Visible = false
        data.HealthFill.Visible = false
        data.HealthText.Visible = false
    end

    if cfg.Names then
        local name = isPlayer and entity.DisplayName or character.Name
        data.NameText.Text = name
        data.NameText.Size = cfg.TextSize
        data.NameText.Font = textFont
        data.NameText.Color = cfg.TextColor
        data.NameText.Position = Vector2.new(x + sx * 0.5, y - 14)
        data.NameText.Visible = true
    else
        data.NameText.Visible = false
    end

    if cfg.Distance then
        data.DistanceText.Text = "[" .. tostring(meters) .. "m]"
        data.DistanceText.Size = cfg.TextSize
        data.DistanceText.Font = flagsFont
        data.DistanceText.Color = cfg.TextColor
        data.DistanceText.Position = Vector2.new(x + sx + 4, y - 1)
        data.DistanceText.Visible = true
    else
        data.DistanceText.Visible = false
    end

    if cfg.Tool then
        local tool = character:FindFirstChildOfClass("Tool")
        data.ToolText.Text = tool and tool.Name or "None"
        data.ToolText.Size = cfg.TextSize
        data.ToolText.Font = textFont
        data.ToolText.Color = cfg.TextColor
        data.ToolText.Position = Vector2.new(x + sx * 0.5, y + sy + 2)
        data.ToolText.Visible = true
    else
        data.ToolText.Visible = false
    end

    if cfg.Tracers then
        local viewport = Camera.ViewportSize
        local from
        if cfg.TracerOrigin == "Bottom" then
            from = Vector2.new(viewport.X * 0.5, viewport.Y)
        elseif cfg.TracerOrigin == "Top" then
            from = Vector2.new(viewport.X * 0.5, 0)
        else
            from = Vector2.new(viewport.X * 0.5, viewport.Y * 0.5)
        end
        data.Tracer.From = from
        data.Tracer.To = Vector2.new(x + sx * 0.5, y + sy)
        data.Tracer.Color = cfg.TracerColor
        data.Tracer.Thickness = cfg.TracerThickness
        data.Tracer.Visible = true
    else
        data.Tracer.Visible = false
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
                    bone.Outline.From = a
                    bone.Outline.To = b
                    bone.Outline.Thickness = cfg.SkeletonThickness + 2
                    bone.Outline.Visible = true
                    bone.Line.From = a
                    bone.Line.To = b
                    bone.Line.Color = cfg.SkeletonColor
                    bone.Line.Thickness = cfg.SkeletonThickness
                    bone.Line.Visible = true
                    return
                end
            end
            bone.Outline.Visible = false
            bone.Line.Visible = false
        end
        local sk = data.Skeleton
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
        local sk = data.Skeleton
        for _, bone in pairs(sk) do
            bone.Outline.Visible = false
            bone.Line.Visible = false
        end
    end

    if cfg.Chams then
        local fillCol, fillTrans = Color4ToColor3(cfg.ChamsFill)
        local outlineCol, outlineTrans = Color4ToColor3(cfg.ChamsOutline)

        local hl = espModule._highlights[entity]
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name = "ESPHighlight"
            hl.Parent = Services.CoreGui
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            espModule._highlights[entity] = hl
        end
        hl.Adornee = character
        hl.FillColor = fillCol
        hl.OutlineColor = outlineCol
        hl.FillTransparency = fillTrans
        hl.OutlineTransparency = outlineTrans
        hl.Enabled = true

        if cfg.ChamsGlow then
            local glowCol, glowTrans = Color4ToColor3(cfg.ChamsGlowFill)
            local glow = espModule._glowHighlights[entity]
            if not glow then
                glow = Instance.new("Highlight")
                glow.Name = "ESPGlow"
                glow.Parent = Services.CoreGui
                glow.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                espModule._glowHighlights[entity] = glow
            end
            glow.Adornee = character
            glow.FillColor = glowCol
            glow.OutlineColor = glowCol
            glow.FillTransparency = glowTrans
            glow.OutlineTransparency = 1
            glow.Enabled = true
        else
            if espModule._glowHighlights[entity] then
                espModule._glowHighlights[entity].Enabled = false
            end
        end
    else
        if espModule._highlights[entity] then
            espModule._highlights[entity].Enabled = false
        end
        if espModule._glowHighlights[entity] then
            espModule._glowHighlights[entity].Enabled = false
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
    self._highlights = {}
    self._glowHighlights = {}
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

function espModule:GetFonts()
    local list = {}
    for name in pairs(self.Fonts) do
        list[#list + 1] = name
    end
    table.sort(list)
    return list
end

return espModule
