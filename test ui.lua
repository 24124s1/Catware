local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService   = game:GetService("RunService")
local HttpService  = game:GetService("HttpService")
local Workspace    = game:GetService("Workspace")

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

local C = {
    outline = rgb(0, 0, 0),
    inline  = rgb(38, 38, 38),
    body    = rgb(14, 14, 14),
    panel   = rgb(11, 11, 11),
    text    = rgb(205, 205, 205),
    item    = rgb(160, 160, 160),
    dim     = rgb(112, 112, 112),
    mute    = rgb(85, 85, 85),
    line    = rgb(30, 30, 30),
    accent  = rgb(204, 112, 148),
}

local function getParent()
    if typeof(gethui) == "function" then
        local ok, ui = pcall(gethui)
        if ok and ui then return ui end
    end
    if not RunService:IsStudio() then
        local ok, cg = pcall(function() return game:GetService("CoreGui") end)
        if ok and cg and pcall(function() return #cg:GetChildren() end) then return cg end
    end
    return lp:WaitForChild("PlayerGui")
end

local FONT_URL = "https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/fs-tahoma-8px.ttf"

local function loadFont()
    local ok, font = pcall(function()
        if not (writefile and getcustomasset and isfile) then error("no filesystem") end
        if not isfile("midnight_font.ttf") then
            writefile("midnight_font.ttf", game:HttpGet(FONT_URL))
        end
        local data = {
            name = "MidnightPixel",
            faces = {{
                name = "Regular", weight = 400, style = "normal",
                assetId = getcustomasset("midnight_font.ttf"),
            }},
        }
        writefile("midnight_font.json", HttpService:JSONEncode(data))
        return Font.new(getcustomasset("midnight_font.json"), Enum.FontWeight.Regular)
    end)
    if ok and font then return font end
    return Font.fromEnum(Enum.Font.Code)
end

local FONT = loadFont()

local function new(class, props)
    local o = Instance.new(class)
    if o:IsA("GuiObject") then o.BorderSizePixel = 0 end
    if class == "TextLabel" or class == "TextButton" or class == "TextBox" then
        o.FontFace = FONT
        o.TextSize = 12
        o.TextColor3 = C.text
        o.BackgroundTransparency = 1
        o.TextXAlignment = ALeft
        o.Text = ""
    end
    if class == "TextButton" then o.AutoButtonColor = false end
    if class == "ScrollingFrame" then
        o.ScrollBarThickness = 0
        o.ScrollBarImageColor3 = C.accent
        o.CanvasSize = UDim2.new()
        o.ElasticBehavior = Enum.ElasticBehavior.Never
        o.ScrollingDirection = Enum.ScrollingDirection.Y
    end
    local parent = props.Parent
    for k, v in pairs(props) do
        if k ~= "Parent" then o[k] = v end
    end
    o.Parent = parent
    return o
end

local function label(parent, str, color, pos, size, xa)
    return new("TextLabel", {
        Parent = parent, Text = str, TextColor3 = color or C.text,
        Position = pos or UDim2.new(), Size = size or dim2(1, 0, 1, 0),
        TextXAlignment = xa or ALeft,
    })
end

local function stroke(parent, color, thickness)
    return new("UIStroke", {
        Parent = parent, Color = color or C.inline, Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        LineJoinMode = Enum.LineJoinMode.Miter,
    })
end

local function tween(o, props, t)
    TweenService:Create(o, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad), props):Play()
end

local function inside(obj, pos)
    local p, s = obj.AbsolutePosition, obj.AbsoluteSize
    return pos.X >= p.X and pos.X <= p.X + s.X and pos.Y >= p.Y and pos.Y <= p.Y + s.Y
end

local function framed(parent, size, pos)
    local o = new("Frame", { Parent = parent, Size = size, Position = pos or UDim2.new(), BackgroundColor3 = C.outline })
    local i = new("Frame", { Parent = o, Size = dim2(1, -2, 1, -2), Position = off(1, 1), BackgroundColor3 = C.inline })
    local b = new("Frame", { Parent = i, Size = dim2(1, -2, 1, -2), Position = off(1, 1), BackgroundColor3 = C.panel, ClipsDescendants = true })
    return b, o
end

local function fieldBox(parent, size, pos, c1, c2)
    local o = new("Frame", { Parent = parent, Size = size, Position = pos or UDim2.new(), BackgroundColor3 = C.outline })
    local i = new("Frame", { Parent = o, Size = dim2(1, -2, 1, -2), Position = off(1, 1), BackgroundColor3 = C.inline })
    local b = new("Frame", { Parent = i, Size = dim2(1, -2, 1, -2), Position = off(1, 1), BackgroundColor3 = WHITE, ClipsDescendants = true })
    local g = new("UIGradient", { Parent = b, Rotation = 90, Color = ColorSequence.new(c1 or rgb(34, 34, 34), c2 or rgb(23, 23, 23)) })
    return b, o, g
end

local function accentLine(parent)
    local line = new("Frame", { Parent = parent, Size = dim2(1, 0, 0, 2), BackgroundColor3 = C.accent, ZIndex = 3 })
    new("UIGradient", { Parent = line, Rotation = 90, Color = ColorSequence.new(rgb(255, 255, 255), rgb(150, 150, 150)) })
    return line
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
        Visible = false, ZIndex = z, TextXAlignment = xa, TextYAlignment = ya,
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

local function computeCorners(model)
    local r15 = model:FindFirstChild("UpperTorso") ~= nil
    local names = r15 and R15_PARTS or R6_PARTS
    local mnX, mnY, mnZ = math.huge, math.huge, math.huge
    local mxX, mxY, mxZ = -math.huge, -math.huge, -math.huge
    local function add(part)
        if not part or not part:IsA("BasePart") then return end
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
    for _, n in ipairs(names) do add(model:FindFirstChild(n)) end
    for _, child in ipairs(model:GetChildren()) do
        if child:IsA("Accessory") then add(child:FindFirstChild("Handle")) end
    end
    if mnX == math.huge then return nil, r15 end
    return {
        Vector3.new(mxX, mxY, mxZ), Vector3.new(mnX, mxY, mxZ), Vector3.new(mnX, mnY, mxZ), Vector3.new(mxX, mnY, mxZ),
        Vector3.new(mxX, mxY, mnZ), Vector3.new(mnX, mxY, mnZ), Vector3.new(mnX, mnY, mnZ), Vector3.new(mxX, mnY, mnZ),
    }, r15
end

local Library  = {}; Library.__index  = Library
local Category = {}; Category.__index = Category
local Tab      = {}; Tab.__index      = Tab
local Column   = {}; Column.__index   = Column
local Section  = {}; Section.__index  = Section
local Element  = {}; Element.__index  = Element

local function nxt(lib) lib.order += 1 return lib.order end

function Library.new(opts)
    opts = opts or {}
    local self = setmetatable({}, Library)

    self.name = opts.name or "Catware"
    self.version = opts.version or "v1"
    self.accent = opts.accent or C.accent
    self.toggleKey = opts.toggleKey or Enum.KeyCode.RightShift
    self.espFonts = opts.fonts or {}
    self.flags, self.setters = {}, {}
    self.connections, self.accentHooks = {}, {}
    self.order = 0
    self.cpCount = 0
    self.popup = nil
    self.currentTab = nil
    self.activeMultiSection = nil

    self.gui = new("ScreenGui", {
        Name = HttpService:GenerateGUID(false), IgnoreGuiInset = true, ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 1000, Parent = getParent(),
    })

    local size = opts.size or Vector2.new(680, 520)
    local sideW = 148
    local vp = Workspace.CurrentCamera.ViewportSize

    self.root = new("Frame", {
        Parent = self.gui, BackgroundTransparency = 1, Size = off(size.X, size.Y),
        Position = off(floor(vp.X / 2 - size.X / 2), floor(vp.Y / 2 - size.Y / 2)),
    })

    local side = framed(self.root, off(sideW, size.Y))
    self:accentOn(accentLine(side), "BackgroundColor3")

    local sideHeader = new("Frame", { Parent = side, Position = off(0, 2), Size = dim2(1, 0, 0, 42), BackgroundTransparency = 1, Active = true })
    local iconOuter = new("Frame", { Parent = sideHeader, Position = off(10, 14), Size = off(10, 10), BackgroundColor3 = rgb(22, 22, 22) })
    stroke(iconOuter, rgb(70, 70, 70))
    local iconInner = new("Frame", { Parent = sideHeader, Position = off(14, 18), Size = off(7, 7), BackgroundColor3 = C.accent })
    self:accentOn(iconInner, "BackgroundColor3")
    label(sideHeader, lower(self.name), rgb(240, 240, 240), off(34, 10), dim2(1, -34, 0, 12))
    label(sideHeader, lower(self.version), C.mute, off(34, 22), dim2(1, -34, 0, 12))
    new("Frame", { Parent = side, Position = off(0, 44), Size = dim2(1, 0, 0, 1), BackgroundColor3 = C.line })

    self.sideList = new("ScrollingFrame", {
        Parent = side, Position = off(0, 50), Size = dim2(1, 0, 1, -104), BackgroundTransparency = 1,
        AutomaticCanvasSize = Enum_Y,
    })
    new("UIListLayout", { Parent = self.sideList, Padding = dim(0, 2), SortOrder = Enum.SortOrder.LayoutOrder })

    local footer = new("Frame", { Parent = side, AnchorPoint = v2(0, 1), Position = dim2(0, 0, 1, 0), Size = dim2(1, 0, 0, 46), BackgroundTransparency = 1 })
    new("Frame", { Parent = footer, Size = dim2(1, 0, 0, 1), BackgroundColor3 = C.line })
    local avatar = new("Frame", { Parent = footer, Position = off(10, 10), Size = off(26, 26), BackgroundColor3 = rgb(10, 10, 10), ClipsDescendants = true })
    stroke(avatar, rgb(48, 48, 48))
    local initial = new("TextLabel", {
        Parent = avatar, Size = dim2(1, 0, 1, 0), Text = lp.Name:sub(1, 1):upper(),
        TextXAlignment = ACenter, TextColor3 = rgb(240, 240, 240),
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
    label(footer, lp.Name, rgb(215, 215, 215), off(44, 10), dim2(1, -48, 0, 12)).TextTruncate = Enum.TextTruncate.AtEnd
    label(footer, "uid " .. tostring(lp.UserId), C.mute, off(44, 22), dim2(1, -48, 0, 12)).TextTruncate = Enum.TextTruncate.AtEnd

    local content = framed(self.root, off(size.X - sideW - 8, size.Y), off(sideW + 8, 0))
    self:accentOn(accentLine(content), "BackgroundColor3")

    local header = new("Frame", { Parent = content, Position = off(0, 2), Size = dim2(1, 0, 0, 28), BackgroundTransparency = 1, Active = true })
    local crumbs = new("Frame", { Parent = header, Position = off(8, 0), Size = dim2(0.7, 0, 1, 0), BackgroundTransparency = 1 })
    new("UIListLayout", {
        Parent = crumbs, FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center, Padding = dim(0, 4),
    })
    self.crumbCat = label(crumbs, "", C.mute, nil, dim2(0, 0, 1, 0)); self.crumbCat.AutomaticSize = Enum_X
    self.crumbTab = label(crumbs, "", rgb(240, 240, 240), nil, dim2(0, 0, 1, 0)); self.crumbTab.AutomaticSize = Enum_X
    local cfgName = label(header, lower(opts.config or "default.cfg"), rgb(70, 70, 70), dim2(1, -8, 0, 0), dim2(0, 0, 1, 0), ARight)
    cfgName.AnchorPoint = v2(1, 0); cfgName.AutomaticSize = Enum_X
    new("Frame", { Parent = content, Position = off(0, 31), Size = dim2(1, 0, 0, 1), BackgroundColor3 = C.line })

    self.pageHolder = new("Frame", { Parent = content, Position = off(0, 32), Size = dim2(1, 0, 1, -32), BackgroundTransparency = 1 })

    self:drag(sideHeader, self.root)
    self:drag(header, self.root)
    self:watermark()

    self:connect(UIS.InputBegan, function(input, gp)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and self.popup then
            local m = UIS:GetMouseLocation()
            if not inside(self.popup.frame, m) and not inside(self.popup.anchor, m) then
                self:closePopups()
            end
        end
        if not gp and input.KeyCode == self.toggleKey then
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
            local vp = Workspace.CurrentCamera.ViewportSize
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

function Library:bindAccent(fn)
    table.insert(self.accentHooks, fn)
    fn(self.accent)
end

function Library:accentOn(inst, prop)
    self:bindAccent(function(c) inst[prop] = c end)
end

function Library:setAccent(c)
    self.accent = c
    for _, fn in ipairs(self.accentHooks) do fn(c) end
end

function Library:setFlag(flag, value)
    self.flags[flag] = value
end

function Library:openPopup(p)
    if self.popup and self.popup ~= p then self.popup.close() end
    self.popup = p
end

function Library:closePopups()
    if self.popup then
        self.popup.close()
        self.popup = nil
    end
end

function Library:unload()
    for _, c in ipairs(self.connections) do c:Disconnect() end
    self.gui:Destroy()
end

function Library:watermark()
    local outer = new("Frame", {
        Parent = self.gui, AnchorPoint = v2(1, 0), Position = dim2(1, -10, 0, 10),
        Size = dim2(0, 0, 0, 22), AutomaticSize = Enum_X, BackgroundColor3 = C.outline,
    })
    new("UIPadding", { Parent = outer, PaddingTop = dim(0, 1), PaddingBottom = dim(0, 1), PaddingLeft = dim(0, 1), PaddingRight = dim(0, 1) })
    local inner = new("Frame", { Parent = outer, Size = dim2(0, 0, 1, 0), AutomaticSize = Enum_X, BackgroundColor3 = C.inline })
    new("UIPadding", { Parent = inner, PaddingTop = dim(0, 1), PaddingBottom = dim(0, 1), PaddingLeft = dim(0, 1), PaddingRight = dim(0, 1) })
    local body = new("Frame", { Parent = inner, Size = dim2(0, 0, 1, 0), AutomaticSize = Enum_X, BackgroundColor3 = C.body })
    local line = new("Frame", { Parent = body, Size = dim2(1, 0, 0, 2), BackgroundColor3 = C.accent, ZIndex = 2 })
    new("UIGradient", { Parent = line, Rotation = 90, Color = ColorSequence.new(rgb(255, 255, 255), rgb(150, 150, 150)) })
    self:accentOn(line, "BackgroundColor3")

    local text = new("TextLabel", {
        Parent = body, Size = dim2(0, 0, 1, 0), AutomaticSize = Enum_X, RichText = true, TextYAlignment = YMid,
    })
    new("UIPadding", { Parent = text, PaddingLeft = dim(0, 6), PaddingRight = dim(0, 6), PaddingTop = dim(0, 1) })

    local frames, acc = 0, 0
    local function render(fps)
        local c = self.accent
        text.Text = string.format(
            '<font color="rgb(%d,%d,%d)">%s</font> <font color="rgb(70,70,70)">|</font> %s <font color="rgb(70,70,70)">|</font> %d fps <font color="rgb(70,70,70)">|</font> %s',
            floor(c.R * 255), floor(c.G * 255), floor(c.B * 255),
            lower(self.name), lp.Name, fps, os.date("%H:%M")
        )
    end
    render(60)
    self:connect(RunService.RenderStepped, function(dt)
        frames += 1
        acc += dt
        if acc >= 0.5 then
            render(floor(frames / acc + 0.5))
            frames, acc = 0, 0
        end
    end)
end

function Library:category(name)
    local cat = setmetatable({ lib = self, name = name }, Category)
    local row = new("Frame", { Parent = self.sideList, Size = dim2(1, 0, 0, 22), BackgroundTransparency = 1, LayoutOrder = nxt(self) })
    new("UIListLayout", {
        Parent = row, FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center, Padding = dim(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    new("UIPadding", { Parent = row, PaddingLeft = dim(0, 8), PaddingRight = dim(0, 10) })
    local t = label(row, lower(name), rgb(95, 95, 95), nil, dim2(0, 0, 1, 0)); t.AutomaticSize = Enum_X
    local ln = new("Frame", { Parent = row, Size = off(10, 1), BackgroundColor3 = rgb(36, 36, 36) })
    new("UIFlexItem", { Parent = ln, FlexMode = Enum.UIFlexMode.Fill })
    return cat
end

function Category:tab(name)
    local lib = self.lib
    local tab = setmetatable({ lib = lib, name = name, category = self }, Tab)
    tab.button = new("TextButton", {
        Parent = lib.sideList, Size = dim2(1, 0, 0, 20), LayoutOrder = nxt(lib),
        BackgroundColor3 = rgb(22, 22, 22), BackgroundTransparency = 1,
    })
    tab.bar = new("Frame", { Parent = tab.button, Size = dim2(0, 2, 1, 0), BackgroundColor3 = C.accent, Visible = false })
    lib:accentOn(tab.bar, "BackgroundColor3")
    tab.bullet = new("Frame", { Parent = tab.button, Position = off(11, 9), Size = off(3, 3), BackgroundColor3 = rgb(70, 70, 70) })
    tab.text = label(tab.button, lower(name), rgb(160, 160, 160), off(22, 0), dim2(1, -22, 1, 0))

    tab.page = new("Frame", { Parent = lib.pageHolder, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false })
    new("UIPadding", { Parent = tab.page, PaddingTop = dim(0, 8), PaddingBottom = dim(0, 8), PaddingLeft = dim(0, 8), PaddingRight = dim(0, 8) })
    new("UIListLayout", { Parent = tab.page, FillDirection = Enum.FillDirection.Horizontal, Padding = dim(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })

    for i, sideName in ipairs({ "left", "right" }) do
        local col = new("Frame", { Parent = tab.page, Size = dim2(0.5, -4, 1, 0), BackgroundTransparency = 1, LayoutOrder = i })
        new("UIListLayout", { Parent = col, Padding = dim(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })
        tab[sideName] = col
    end

    tab.button.MouseButton1Click:Connect(function() tab:open() end)
    tab.button.MouseEnter:Connect(function()
        if lib.currentTab ~= tab then tween(tab.text, { TextColor3 = rgb(215, 215, 215) }, 0.1) end
    end)
    tab.button.MouseLeave:Connect(function()
        if lib.currentTab ~= tab then tween(tab.text, { TextColor3 = rgb(160, 160, 160) }, 0.1) end
    end)
    lib:bindAccent(function(c)
        if lib.currentTab == tab then tab.bullet.BackgroundColor3 = c end
    end)
    return tab
end

function Tab:setActive(on)
    self.page.Visible = on
    self.bar.Visible = on
    self.button.BackgroundTransparency = on and 0 or 1
    self.text.TextColor3 = on and rgb(245, 245, 245) or rgb(160, 160, 160)
    self.bullet.BackgroundColor3 = on and self.lib.accent or rgb(70, 70, 70)
end

function Tab:open()
    local lib = self.lib
    lib:closePopups()
    if lib.currentTab then lib.currentTab:setActive(false) end
    lib.currentTab = self
    self:setActive(true)
    lib.crumbCat.Text = lower(self.category.name) .. " /"
    lib.crumbTab.Text = lower(self.name)
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
        BackgroundTransparency = 1, LayoutOrder = nxt(lib),
    })

    local body = new("Frame", {
        Parent = container, Position = off(0, 13), Size = dim2(1, 0, 0, 0),
        AutomaticSize = Enum_Y, BackgroundColor3 = C.body,
    })
    stroke(body, C.inline)
    new("UIPadding", { Parent = body, PaddingTop = dim(0, 10), PaddingBottom = dim(0, 8), PaddingLeft = dim(0, 8), PaddingRight = dim(0, 8) })
    new("UIListLayout", { Parent = body, Padding = dim(0, 4), SortOrder = Enum.SortOrder.LayoutOrder })

    local title = new("TextLabel", {
        Parent = container, Position = off(2, 0), Size = off(0, 14),
        AutomaticSize = Enum_X, BackgroundTransparency = 0, BackgroundColor3 = C.body,
        Text = lower(o.name or "section"), TextXAlignment = ACenter, ZIndex = 3,
    })
    stroke(title, C.inline)
    new("UIPadding", { Parent = title, PaddingLeft = dim(0, 5), PaddingRight = dim(0, 5) })

    return setmetatable({ lib = lib, body = body, container = container }, Section)
end

function Column:multi_section(o)
    o = o or {}
    local lib = self.lib
    local names = o.names or { "Section" }

    local container = new("Frame", {
        Parent = self.holder, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, LayoutOrder = nxt(lib),
    })

    local bar = new("Frame", { Parent = container, Position = off(2, 0), Size = dim2(1, -2, 0, 16), BackgroundTransparency = 1, ZIndex = 3 })
    new("UIListLayout", {
        Parent = bar, FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder, Padding = dim(0, 2),
    })

    local holder = new("Frame", {
        Parent = container, Position = off(0, 15), Size = dim2(1, 0, 1, -15),
        BackgroundColor3 = C.body, ClipsDescendants = true,
    })
    stroke(holder, C.inline)

    local sections = {}
    local current = nil

    local function select(sec)
        if current then
            current.page.Visible = false
            current.btn.BackgroundColor3 = rgb(18, 18, 18)
            current.btn.TextColor3 = C.dim
        end
        sec.page.Visible = true
        sec.btn.BackgroundColor3 = C.body
        sec.btn.TextColor3 = C.text
        current = sec
        lib.activeMultiSection = sec
        lib:closePopups()
    end

    for i, name in ipairs(names) do
        local btn = new("TextButton", {
            Parent = bar, Size = dim2(0, 0, 1, 0), AutomaticSize = Enum_X, BackgroundColor3 = rgb(18, 18, 18),
            BackgroundTransparency = 0, Text = lower(name), TextColor3 = C.dim, TextXAlignment = ACenter, LayoutOrder = i,
        })
        stroke(btn, C.inline)
        new("UIPadding", { Parent = btn, PaddingLeft = dim(0, 5), PaddingRight = dim(0, 5) })

        local page = new("ScrollingFrame", {
            Parent = holder, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false,
            AutomaticCanvasSize = Enum_Y, ScrollBarThickness = 2,
        })
        new("UIPadding", { Parent = page, PaddingTop = dim(0, 8), PaddingBottom = dim(0, 8), PaddingLeft = dim(0, 8), PaddingRight = dim(0, 10) })
        new("UIListLayout", { Parent = page, Padding = dim(0, 4), SortOrder = Enum.SortOrder.LayoutOrder })
        lib:guard(page)
        lib:bindAccent(function(c) page.ScrollBarImageColor3 = c end)

        local sec = setmetatable({ lib = lib, body = page, page = page, name = name, btn = btn }, Section)
        sections[i] = sec

        btn.MouseButton1Click:Connect(function() select(sec) end)
        btn.MouseEnter:Connect(function()
            if current ~= sec then tween(btn, { TextColor3 = rgb(180, 180, 180) }, 0.1) end
        end)
        btn.MouseLeave:Connect(function()
            if current ~= sec then tween(btn, { TextColor3 = C.dim }, 0.1) end
        end)
    end

    select(sections[1])

    return table.unpack(sections)
end

function Section:label(text)
    local lib = self.lib
    if type(text) == "table" then text = text.name or text.text end
    local row = new("Frame", { Parent = self.body, Size = dim2(1, 0, 0, 13), BackgroundTransparency = 1, LayoutOrder = nxt(lib) })
    local lbl = label(row, lower(tostring(text or "label")), C.text, off(0, 0), dim2(1, -30, 1, 0))
    local e = setmetatable({ lib = lib, right = makeRight(row), lbl = lbl }, Element)
    function e.set(t) lbl.Text = lower(tostring(t)) end
    return e
end

function Section:button(o)
    local lib = self.lib
    local body, outer = fieldBox(self.body, dim2(1, 0, 0, 20))
    outer.LayoutOrder = nxt(lib)
    local lbl = label(body, lower(o.name or "button"), C.text, off(0, 0), dim2(1, 0, 1, 0), ACenter)
    local hit = new("TextButton", { Parent = outer, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 5 })
    hit.MouseEnter:Connect(function() tween(outer, { BackgroundColor3 = lib.accent }, 0.1) end)
    hit.MouseLeave:Connect(function() tween(outer, { BackgroundColor3 = C.outline }, 0.1) end)
    hit.MouseButton1Click:Connect(function()
        lbl.TextColor3 = lib.accent
        tween(lbl, { TextColor3 = C.text }, 0.3)
        if o.callback then o.callback() end
    end)
    return outer
end

function Section:toggle(o)
    local lib = self.lib
    local cfg = {
        lib = lib, name = o.name or "toggle", flag = o.flag or o.name or "toggle",
        callback = o.callback or function() end, value = false,
    }

    local row = new("TextButton", { Parent = self.body, Size = dim2(1, 0, 0, 13), LayoutOrder = nxt(lib) })
    local box = new("Frame", { Parent = row, Position = off(0, 3), Size = off(7, 7), BackgroundColor3 = rgb(24, 24, 24) })
    local boxStroke = stroke(box, rgb(48, 48, 48))
    local lbl = label(row, lower(cfg.name), rgb(150, 150, 150), off(16, 0), dim2(1, -16, 1, 0))
    cfg.right = makeRight(row)

    function cfg.set(v, instant)
        cfg.value = v and true or false
        lib:setFlag(cfg.flag, cfg.value)
        local bc = cfg.value and lib.accent or rgb(24, 24, 24)
        local sc = cfg.value and lib.accent or rgb(48, 48, 48)
        local tc = cfg.value and C.text or rgb(150, 150, 150)
        if instant == true then
            box.BackgroundColor3 = bc
            boxStroke.Color = sc
            lbl.TextColor3 = tc
        else
            tween(box, { BackgroundColor3 = bc })
            tween(boxStroke, { Color = sc })
            tween(lbl, { TextColor3 = tc })
        end
        cfg.callback(cfg.value)
    end

    lib:bindAccent(function(c)
        if cfg.value then
            box.BackgroundColor3 = c
            boxStroke.Color = c
        end
    end)
    row.MouseButton1Click:Connect(function() cfg.set(not cfg.value) end)
    row.MouseEnter:Connect(function()
        if not cfg.value then tween(lbl, { TextColor3 = rgb(190, 190, 190) }, 0.1) end
    end)
    row.MouseLeave:Connect(function()
        if not cfg.value then tween(lbl, { TextColor3 = rgb(150, 150, 150) }, 0.1) end
    end)

    lib.setters[cfg.flag] = cfg.set
    cfg.set(o.default or false, true)

    return setmetatable(cfg, Element)
end

function Element:colorpicker(o)
    o = o or {}
    local lib = self.lib
    lib.cpCount += 1

    local cp = { flag = o.flag or ("color_" .. lib.cpCount), callback = o.callback or function() end, open = false }
    local start = typeof(o.color) == "Color3" and o.color or WHITE
    local h, s, v = start:ToHSV()

    local swBody, swOuter = fieldBox(self.right, off(22, 12), nil, WHITE, rgb(165, 165, 165))
    swOuter.LayoutOrder = lib.cpCount
    swBody.BackgroundColor3 = start
    local swHit = new("TextButton", { Parent = swOuter, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 5 })
    swHit.MouseEnter:Connect(function() swOuter.BackgroundColor3 = lib.accent end)
    swHit.MouseLeave:Connect(function() swOuter.BackgroundColor3 = C.outline end)

    local pb, pop = framed(lib.gui, off(150, 124))
    pop.Visible = false
    pop.ZIndex = 100
    pb.BackgroundColor3 = C.body

    local sv = new("Frame", { Parent = pb, Position = off(6, 6), Size = off(110, 108), BackgroundColor3 = Color3.fromHSV(h, 1, 1), ClipsDescendants = true })
    local whiteL = new("Frame", { Parent = sv, Size = dim2(1, 0, 1, 0), BackgroundColor3 = WHITE })
    new("UIGradient", { Parent = whiteL, Transparency = NumberSequence.new(0, 1) })
    local blackL = new("Frame", { Parent = sv, Size = dim2(1, 0, 1, 0), BackgroundColor3 = rgb(0, 0, 0) })
    new("UIGradient", { Parent = blackL, Rotation = 90, Transparency = NumberSequence.new(1, 0) })
    local svBtn = new("TextButton", { Parent = sv, Size = dim2(1, 0, 1, 0), ZIndex = 3 })
    local svCursor = new("Frame", { Parent = sv, Size = off(5, 5), BackgroundColor3 = WHITE, ZIndex = 4 })
    stroke(svCursor, C.outline)

    local hue = new("Frame", { Parent = pb, Position = off(122, 6), Size = off(14, 108), BackgroundColor3 = WHITE })
    new("UIGradient", {
        Parent = hue, Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, rgb(255, 0, 0)), ColorSequenceKeypoint.new(0.17, rgb(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, rgb(0, 255, 0)), ColorSequenceKeypoint.new(0.5, rgb(0, 255, 255)),
            ColorSequenceKeypoint.new(0.67, rgb(0, 0, 255)), ColorSequenceKeypoint.new(0.83, rgb(255, 0, 255)),
            ColorSequenceKeypoint.new(1, rgb(255, 0, 0)),
        }),
    })
    local hueBtn = new("TextButton", { Parent = hue, Size = dim2(1, 0, 1, 0), ZIndex = 3 })
    local hueCursor = new("Frame", { Parent = hue, Size = dim2(1, 0, 0, 2), BackgroundColor3 = WHITE, ZIndex = 4 })
    stroke(hueCursor, C.outline)

    local function apply()
        local c = Color3.fromHSV(h, s, v)
        swBody.BackgroundColor3 = c
        sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        svCursor.Position = dim2(s, -2, 1 - v, -2)
        hueCursor.Position = dim2(0, 0, h, -1)
        lib:setFlag(cp.flag, c)
        cp.callback(c)
    end

    local mode
    local function update()
        local m = UIS:GetMouseLocation()
        if mode == "sv" then
            s = clamp((m.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
            v = 1 - clamp((m.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
        elseif mode == "hue" then
            h = clamp((m.Y - hue.AbsolutePosition.Y) / hue.AbsoluteSize.Y, 0, 0.999)
        end
        apply()
    end

    svBtn.MouseButton1Down:Connect(function() mode = "sv"; update() end)
    hueBtn.MouseButton1Down:Connect(function() mode = "hue"; update() end)
    lib:connect(UIS.InputEnded, function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then mode = nil end end)
    lib:connect(UIS.InputChanged, function(i) if mode and i.UserInputType == Enum.UserInputType.MouseMovement then update() end end)

    local popup = { frame = pop, anchor = swOuter }
    function popup.close() pop.Visible = false; cp.open = false end

    swHit.MouseButton1Click:Connect(function()
        cp.open = not cp.open
        if cp.open then
            local p = swOuter.AbsolutePosition
            local vpS = Workspace.CurrentCamera.ViewportSize
            local x = clamp(p.X + swOuter.AbsoluteSize.X - 150, 0, vpS.X - 150)
            local y = p.Y + swOuter.AbsoluteSize.Y + 4
            if y + 124 > vpS.Y then y = p.Y - 128 end
            pop.Position = off(x, y)
            pop.Visible = true
            lib:openPopup(popup)
        else
            popup.close()
            lib.popup = nil
        end
    end)

    function cp.set(c) h, s, v = c:ToHSV(); apply() end
    lib.setters[cp.flag] = cp.set
    apply()

    return self
end

function Section:dropdown(o)
    local lib = self.lib
    local cfg = {
        lib = lib, name = o.name or "dropdown", flag = o.flag or o.name or "dropdown",
        items = o.items or {}, multi = o.multi or false,
        callback = o.callback or function() end, open = false, buttons = {},
    }
    local default = o.default
    if default == nil then default = cfg.multi and {} or cfg.items[1] end

    local holder = new("Frame", { Parent = self.body, Size = dim2(1, 0, 0, 36), BackgroundTransparency = 1, LayoutOrder = nxt(lib) })
    label(holder, lower(cfg.name), C.text, off(2, 0), dim2(1, -2, 0, 13))
    local body, outer = fieldBox(holder, dim2(1, 0, 0, 19), off(0, 16))
    local valLbl = label(body, "", C.text, off(5, 0), dim2(1, -22, 1, 0))
    valLbl.TextTruncate = Enum.TextTruncate.AtEnd
    local plus = label(body, "+", C.text, off(0, 0), dim2(1, -5, 1, 0), ARight)
    local hit = new("TextButton", { Parent = outer, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 5 })

    local rowH, maxRows = 16, 8
    local rows = math.max(#cfg.items, 1)
    local scrolls = rows > maxRows
    local listH = math.min(rows, maxRows) * rowH + 6

    local listBody, listOuter = fieldBox(lib.gui, off(100, listH + 4))
    listOuter.Visible = false
    listOuter.ZIndex = 100

    local scroller = new("ScrollingFrame", {
        Parent = listBody, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1,
        AutomaticCanvasSize = Enum_Y, ScrollBarThickness = scrolls and 2 or 0,
    })
    lib:bindAccent(function(c) scroller.ScrollBarImageColor3 = c end)
    new("UIListLayout", { Parent = scroller, SortOrder = Enum.SortOrder.LayoutOrder })
    new("UIPadding", { Parent = scroller, PaddingTop = dim(0, 3), PaddingBottom = dim(0, 3), PaddingRight = dim(0, scrolls and 4 or 0) })

    for i, item in ipairs(cfg.items) do
        local b = new("TextButton", {
            Parent = scroller, Size = dim2(1, 0, 0, rowH), Text = lower(tostring(item)),
            TextColor3 = C.item, LayoutOrder = i,
        })
        new("UIPadding", { Parent = b, PaddingLeft = dim(0, 6) })
        cfg.buttons[item] = b
    end

    local function isSelected(item)
        if cfg.multi then
            for _, x in ipairs(cfg.value or {}) do
                if x == item then return true end
            end
            return false
        end
        return cfg.value == item
    end

    local function recolor()
        for item, b in pairs(cfg.buttons) do
            b.TextColor3 = isSelected(item) and lib.accent or C.item
        end
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
            for _, x in ipairs(sel) do table.insert(shown, lower(tostring(x))) end
            valLbl.Text = table.concat(shown, ", ")
        else
            cfg.value = val
            valLbl.Text = lower(tostring(val or ""))
        end
        recolor()
        lib:setFlag(cfg.flag, cfg.value)
        cfg.callback(cfg.value)
    end

    lib:bindAccent(function() if cfg.value ~= nil then recolor() end end)

    local popup = { frame = listOuter, anchor = outer }
    function popup.close()
        listOuter.Visible = false
        cfg.open = false
        plus.Text = "+"
        outer.BackgroundColor3 = C.outline
    end

    hit.MouseEnter:Connect(function() tween(outer, { BackgroundColor3 = lib.accent }, 0.1) end)
    hit.MouseLeave:Connect(function()
        if not cfg.open then tween(outer, { BackgroundColor3 = C.outline }, 0.1) end
    end)

    hit.MouseButton1Click:Connect(function()
        cfg.open = not cfg.open
        if cfg.open then
            local p, sz = outer.AbsolutePosition, outer.AbsoluteSize
            local vpS = Workspace.CurrentCamera.ViewportSize
            local y = p.Y + sz.Y + 2
            if y + listH + 4 > vpS.Y then y = p.Y - listH - 6 end
            listOuter.Position = off(p.X, y)
            listOuter.Size = off(sz.X, listH + 4)
            listOuter.Visible = true
            plus.Text = "-"
            outer.BackgroundColor3 = lib.accent
            lib:openPopup(popup)
        else
            popup.close()
            lib.popup = nil
        end
    end)

    for item, b in pairs(cfg.buttons) do
        b.MouseEnter:Connect(function()
            if not isSelected(item) then b.TextColor3 = rgb(215, 215, 215) end
        end)
        b.MouseLeave:Connect(function()
            b.TextColor3 = isSelected(item) and lib.accent or C.item
        end)
        b.MouseButton1Click:Connect(function()
            if cfg.multi then
                local newSel, found = {}, false
                for _, x in ipairs(cfg.value) do
                    if x == item then found = true else table.insert(newSel, x) end
                end
                if not found then table.insert(newSel, item) end
                cfg.set(newSel)
            else
                cfg.set(item)
                popup.close()
                lib.popup = nil
            end
        end)
    end

    lib.setters[cfg.flag] = cfg.set
    cfg.set(default)
    return cfg
end

function Section:slider(o)
    local lib = self.lib
    local cfg = {
        lib = lib, name = o.name or "slider", flag = o.flag or o.name or "slider",
        min = o.min or 0, max = o.max or 100, interval = o.interval or 1,
        suffix = o.suffix or "", callback = o.callback or function() end, dragging = false,
    }
    local decimals = 0
    if cfg.interval < 1 then
        decimals = #(tostring(cfg.interval):match("%.(%d+)") or "")
    end

    local row = new("Frame", { Parent = self.body, Size = dim2(1, 0, 0, 24), BackgroundTransparency = 1, LayoutOrder = nxt(lib) })
    label(row, lower(cfg.name), C.text, off(0, 0), dim2(0.6, 0, 0, 12))
    local valLbl = label(row, "", C.text, dim2(1, 0, 0, 0), dim2(0.4, 0, 0, 12), ARight)
    valLbl.AnchorPoint = v2(1, 0)

    local track = new("TextButton", { Parent = row, Position = off(0, 16), Size = dim2(1, 0, 0, 5), BackgroundColor3 = rgb(30, 30, 30), BackgroundTransparency = 0 })
    stroke(track, C.outline)
    local fill = new("Frame", { Parent = track, Size = dim2(0, 0, 1, 0), BackgroundColor3 = C.accent })
    lib:accentOn(fill, "BackgroundColor3")
    new("UIGradient", { Parent = fill, Rotation = 90, Color = ColorSequence.new(rgb(255, 255, 255), rgb(150, 150, 150)) })
    local handle = new("Frame", { Parent = track, AnchorPoint = v2(0.5, 0.5), Position = dim2(0, 0, 0.5, 0), Size = off(4, 11), BackgroundColor3 = rgb(125, 125, 125), ZIndex = 3 })
    stroke(handle, C.outline)

    track.MouseEnter:Connect(function() tween(handle, { BackgroundColor3 = rgb(170, 170, 170) }, 0.1) end)
    track.MouseLeave:Connect(function()
        if not cfg.dragging then tween(handle, { BackgroundColor3 = rgb(125, 125, 125) }, 0.1) end
    end)

    function cfg.set(val)
        val = clamp(floor(val / cfg.interval + 0.5) * cfg.interval, cfg.min, cfg.max)
        val = tonumber(string.format("%." .. decimals .. "f", val))
        cfg.value = val
        local frac = (val - cfg.min) / (cfg.max - cfg.min)
        fill.Size = dim2(frac, 0, 1, 0)
        handle.Position = dim2(frac, 0, 0.5, 0)
        valLbl.Text = tostring(val) .. cfg.suffix
        lib:setFlag(cfg.flag, val)
        cfg.callback(val)
    end

    local function fromMouse()
        local m = UIS:GetMouseLocation()
        local frac = clamp((m.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        cfg.set(cfg.min + (cfg.max - cfg.min) * frac)
    end

    track.MouseButton1Down:Connect(function() cfg.dragging = true; fromMouse() end)
    lib:connect(UIS.InputChanged, function(i)
        if cfg.dragging and i.UserInputType == Enum.UserInputType.MouseMovement then fromMouse() end
    end)
    lib:connect(UIS.InputEnded, function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 and cfg.dragging then
            cfg.dragging = false
            tween(handle, { BackgroundColor3 = rgb(125, 125, 125) }, 0.1)
        end
    end)

    lib.setters[cfg.flag] = cfg.set
    cfg.set(o.default or cfg.min)
    return cfg
end

function Column:preview(o)
    o = o or {}
    local lib = self.lib
    local page = self.tab.page
    local sec = self:section({ name = o.name or "preview" })

    local area = new("Frame", { Parent = sec.body, Size = dim2(1, 0, 0, 250), BackgroundColor3 = rgb(9, 9, 9), LayoutOrder = nxt(lib), ClipsDescendants = true })
    stroke(area, rgb(28, 28, 28))

    local viewport = new("ViewportFrame", {
        Parent = area, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1,
        Ambient = rgb(190, 190, 190), LightColor = WHITE, ZIndex = 1,
    })
    local cam = Instance.new("Camera")
    cam.FieldOfView = 40
    cam.CFrame = CFrame.lookAt(Vector3.new(0, 0.3, 14), Vector3.new(0, -0.3, 0))
    cam.Parent = viewport
    viewport.CurrentCamera = cam

    local ov = new("Frame", { Parent = area, Size = dim2(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 2 })

    local glow = new("ImageLabel", {
        Parent = ov, Image = "rbxassetid://110204605000367", ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(v2(21, 21), v2(79, 79)), BackgroundTransparency = 1,
        ImageTransparency = 0.35, Visible = false, ZIndex = 1,
    })
    local boxFill = new("Frame", { Parent = ov, BackgroundColor3 = WHITE, Visible = false, ZIndex = 2 })
    local boxFillGrad = new("UIGradient", { Parent = boxFill })

    local full, corner, box3d, bones = {}, {}, {}, {}
    for i = 1, 4 do full[i] = newLine(ov, 3) end
    for i = 1, 8 do corner[i] = newLine(ov, 3) end
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
    local dotStroke = stroke(headDot, rgb(0, 0, 0))

    local nameT = newText(ov, 0.5, 1, 5)
    local distT = newText(ov, 0, 0, 5)
    local toolT = newText(ov, 0.5, 0, 5)
    local hpT   = newText(ov, 1, 0, 5)

    local last = "enemy"
    local clone, cornersW, headPart, bonePairs = nil, nil, nil, {}
    local parts = {}
    local tinted = nil
    local rot = 0
    local hpKey, arKey = nil, nil

    local function on(k) return lib.flags[last .. "_" .. k] == true end
    local function num(k, fb)
        local v = lib.flags[last .. "_" .. k]
        if type(v) == "number" then return v end
        return fb
    end
    local function col(k, fb)
        local v = lib.flags[last .. "_" .. k]
        if typeof(v) == "Color3" then return v end
        return fb
    end
    local function str(k, fb)
        local v = lib.flags[last .. "_" .. k]
        if type(v) == "string" then return v end
        return fb
    end

    local function espFont(name)
        local f = lib.espFonts and lib.espFonts[name]
        return f or FONT, f ~= nil
    end

    local function putText(t, text, fontName, size, c1, c2, rotation, px, py)
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
        lbl.Position = off(px, py)
        lbl.Visible = true
    end

    local function applyTint(want)
        if want == tinted then return end
        tinted = want
        for part, orig in pairs(parts) do
            if want then
                part.Color = want
                part.Material = Enum.Material.ForceField
            else
                part.Color = orig.c
                part.Material = orig.m
            end
        end
    end

    local function hideAll()
        glow.Visible = false
        boxFill.Visible = false
        hideGroup(full)
        hideGroup(corner)
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
    end

    local function render(dt)
        if not (clone and cornersW) then return end
        if not (lib.root.Visible and page.Visible) then return end

        rot = rot + dt * 0.9
        clone:PivotTo(CFrame.Angles(0, rot, 0))

        local nm = lower(lib.activeMultiSection and lib.activeMultiSection.name or "enemy")
        if nm == "enemy" or nm == "team" or nm == "ai" then last = nm end

        if not on("enabled") then
            hideAll()
            applyTint(nil)
            return
        end

        local w, h = area.AbsoluteSize.X, area.AbsoluteSize.Y
        if w < 20 or h < 20 then return end
        local camCF = cam.CFrame
        local tanHalf = math.tan(math.rad(cam.FieldOfView) / 2)

        local pc = {}
        local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
        for i = 1, 8 do
            local pt = projectPoint(cornersW[i], camCF, tanHalf, w, h)
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
        local thick = num("box_thickness", 1)
        local lineCol = col("box_color", WHITE)
        local fillOn = showBox and on("boxfill")
        local fillC1 = col("boxfill_c1", rgb(255, 80, 80))
        local fillC2 = col("boxfill_c2", rgb(255, 40, 40))

        if fillOn and boxType ~= "3D" then
            boxFill.Position = off(x, y)
            boxFill.Size = off(sx, sy)
            boxFill.BackgroundTransparency = num("boxfill_trans", 0.7)
            boxFillGrad.Color = ColorSequence.new(fillC1, fillC2)
            boxFillGrad.Rotation = (tick() * 120) % 360
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
                hideGroup(corner)
                hideGroup(box3d)
                for i = 1, 4 do full[i].thickness = thick; full[i].color(lineCol) end
                full[1].set(v2(x, y), v2(x + sx, y))
                full[2].set(v2(x, y + sy), v2(x + sx, y + sy))
                full[3].set(v2(x, y), v2(x, y + sy))
                full[4].set(v2(x + sx, y), v2(x + sx, y + sy))
            elseif boxType == "3D" then
                hideGroup(full)
                hideGroup(corner)
                for i = 1, 12 do
                    local e = EDGES_3D[i]
                    local a, b = pc[e[1]], pc[e[2]]
                    if a and b then
                        box3d[i].thickness = thick
                        box3d[i].color(lineCol)
                        box3d[i].set(a, b)
                    else
                        box3d[i].hide()
                    end
                end
            else
                hideGroup(full)
                hideGroup(box3d)
                local len = clamp(0.22 + (127 / 400) * 0.18, 0.22, 0.38)
                local cw = clamp(floor(sx * len + 0.5), 2, floor(sx / 2))
                local ch = clamp(floor(sy * len + 0.5), 2, floor(sy / 2))
                for i = 1, 8 do corner[i].thickness = thick; corner[i].color(lineCol) end
                corner[1].set(v2(x, y), v2(x + cw + 1, y))
                corner[2].set(v2(x, y), v2(x, y + ch + 1))
                corner[3].set(v2(x + sx, y), v2(x + sx - cw - 1, y))
                corner[4].set(v2(x + sx, y), v2(x + sx, y + ch + 1))
                corner[5].set(v2(x, y + sy), v2(x + cw + 1, y + sy))
                corner[6].set(v2(x, y + sy), v2(x, y + sy - ch - 1))
                corner[7].set(v2(x + sx, y + sy), v2(x + sx - cw - 1, y + sy))
                corner[8].set(v2(x + sx, y + sy), v2(x + sx, y + sy - ch - 1))
            end
        else
            hideGroup(full)
            hideGroup(corner)
            hideGroup(box3d)
        end

        local want = nil
        if on("chams") then
            want = col("chams_color", C.accent)
        elseif fillOn and boxType == "3D" then
            want = fillC1
        end
        applyTint(want)

        local size = floor(num("textsize", 12))
        local rotG = lib.flags.esp_text_gradient == "Animated" and (tick() * 100) % 360 or 0
        local textFont = str("none", "") ~= "" and "" or (lib.flags.esp_text_font or "Gojiberry Quibble")
        local flagsFont = lib.flags.esp_flags_font or "Gojiberry Quibble"
        local healthFont = lib.flags.esp_health_font or "Gojiberry Quibble"

        local hpRatio = 0.55 + 0.45 * math.sin(tick() * 1.2)
        local hi = col("health_high", rgb(0, 255, 100))
        local mid = col("health_mid", rgb(255, 255, 0))
        local lo = col("health_low", rgb(255, 40, 40))

        if on("healthbar") then
            hpBack.Position = off(x - 5, y)
            hpBack.Size = off(2, sy)
            hpBack.Visible = true
            hpFill.Size = dim2(1, 0, hpRatio, 0)
            local key = tostring(hi) .. tostring(mid) .. tostring(lo)
            if hpKey ~= key then
                hpGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, hi),
                    ColorSequenceKeypoint.new(0.5, mid),
                    ColorSequenceKeypoint.new(1, lo),
                })
                hpKey = key
            end
            if on("healthtext") then
                local t2 = clamp(hpRatio, 0, 1)
                local hc = t2 >= 0.5 and mid:Lerp(hi, (t2 - 0.5) * 2) or lo:Lerp(mid, t2 * 2)
                local ty = clamp(y + sy - sy * hpRatio - 5, y - 2, y + sy - 10)
                putText(hpT, tostring(floor(hpRatio * 100 + 0.5)), healthFont, size, hc, hc, 0, x - 8, ty)
            else
                hpT.label.Visible = false
            end
        else
            hpBack.Visible = false
            hpT.label.Visible = false
        end

        local armorOn = on("armorbar")
        if armorOn then
            arBack.Position = off(x, y + sy + 2)
            arBack.Size = off(sx, 2)
            arBack.Visible = true
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
        else
            arBack.Visible = false
        end

        if on("names") then
            local nt = str("name_type", "Display")
            local txt = lp.DisplayName
            if nt == "Username" then
                txt = lp.Name
            elseif nt == "Both" then
                txt = lp.DisplayName .. " (@" .. lp.Name .. ")"
            end
            putText(nameT, txt, textFont, size, col("name_color", WHITE), col("name_color2", WHITE), rotG, x + sx * 0.5, y - 4)
        else
            nameT.label.Visible = false
        end

        if on("distance") then
            putText(distT, "[45m]", flagsFont, size, col("dist_color", WHITE), col("dist_color2", WHITE), rotG, x + sx + 4, y - 1)
        else
            distT.label.Visible = false
        end

        if on("tool") then
            putText(toolT, "Weapon", textFont, size, col("tool_color", WHITE), col("tool_color2", WHITE), rotG, x + sx * 0.5, y + sy + (armorOn and 6 or 2))
        else
            toolT.label.Visible = false
        end

        if on("headdot") and headPart then
            local hp = projectPoint(headPart.Position, camCF, tanHalf, w, h)
            if hp then
                local ds = math.max(4, floor(num("headdot_size", 20) * 0.5))
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
            tracer.thickness = 1
            tracer.color(col("tracer_color", WHITE))
            tracer.set(v2(w * 0.5, h), v2(x + sx * 0.5, y + sy))
        else
            tracer.hide()
        end

        if on("skeleton") then
            local c1 = col("skeleton_color", WHITE)
            local c2 = col("skeleton_color2", WHITE)
            local sth = num("skeleton_thickness", 1)
            for i = 1, 10 do
                local pair = bonePairs[i]
                if pair then
                    local a = projectPoint(pair[1].Position, camCF, tanHalf, w, h)
                    local b = projectPoint(pair[2].Position, camCF, tanHalf, w, h)
                    if a and b then
                        bones[i].thickness = sth
                        bones[i].color(c1, c2)
                        bones[i].set(a, b)
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

    task.spawn(function()
        local char = lp.Character or lp.CharacterAdded:Wait()
        if not char:FindFirstChild("HumanoidRootPart") then char:WaitForChild("HumanoidRootPart", 5) end
        char.Archivable = true
        local ok, c = pcall(function() return char:Clone() end)
        if not ok or not c then return end
        for _, d in ipairs(c:GetDescendants()) do
            if d:IsA("BaseScript") then
                d:Destroy()
            elseif d:IsA("Humanoid") then
                d.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                d.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
            end
        end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if not hrp then c:Destroy() return end
        c.PrimaryPart = hrp
        for _, d in ipairs(c:GetDescendants()) do
            if d:IsA("BasePart") then
                d.Anchored = true
                parts[d] = { c = d.Color, m = d.Material }
            end
        end
        c:PivotTo(CFrame.new(0, 0, 0))
        c.Parent = viewport

        local corners, r15 = computeCorners(c)
        if not corners then return end

        for _, pr in ipairs(r15 and R15_BONES or R6_BONES) do
            local a, b = c:FindFirstChild(pr[1]), c:FindFirstChild(pr[2])
            if a and b then bonePairs[#bonePairs + 1] = { a, b } end
        end
        headPart = c:FindFirstChild("Head")
        cornersW = corners
        clone = c
    end)

    lib:connect(RunService.RenderStepped, render)

    return sec
end

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/24124s1/Catware/refs/heads/main/EspLibrary.lua"))()

local win = Library.new({ name = "Catware", version = "Private", config = "default.cfg", fonts = ESP.Fonts })

local combat = win:category("Combat")
local aimbot = combat:tab("Aimbot")
local antiaim = combat:tab("Anti-Aim")

local visuals = win:category("Visuals")
local playersTab = visuals:tab("Players")
local world = visuals:tab("World")

local other = win:category("Other")
local misc = other:tab("Misc")
local config = other:tab("Config")

local left = playersTab:column("left")
local right = playersTab:column("right")

local Enemy, Team, AI, Items, Setting = left:multi_section({
    names = {"Enemy", "Team", "AI", "Items", "Settings"}
})

local function addESPSection(sec, tbl, prefix)
    sec:toggle({name = "Enabled", default = tbl.Enabled, flag = prefix.."_enabled", callback = function(v) tbl.Enabled = v end})
    sec:toggle({name = "Box", default = tbl.BoxEnabled, flag = prefix.."_box", callback = function(v) tbl.BoxEnabled = v end})
        :colorpicker({flag = prefix.."_box_color", color = tbl.LineColor, callback = function(c) tbl.LineColor = c end})
    sec:dropdown({name = "Box Type", items = {"Corner", "Full", "3D"}, default = tbl.BoxType, flag = prefix.."_box_type", callback = function(v) tbl.BoxType = v end})
    sec:slider({name = "Box Thickness", min = 1, max = 5, default = tbl.Thickness, interval = 1, flag = prefix.."_box_thickness", callback = function(v) tbl.Thickness = v end})
    sec:toggle({name = "Box Glow", default = tbl.BoxGlow, flag = prefix.."_box_glow", callback = function(v) tbl.BoxGlow = v end})
    sec:toggle({name = "Box Fill", default = tbl.BoxFill, flag = prefix.."_boxfill", callback = function(v) tbl.BoxFill = v end})
        :colorpicker({flag = prefix.."_boxfill_c1", color = tbl.BoxFillColor1, callback = function(c) tbl.BoxFillColor1 = c end})
        :colorpicker({flag = prefix.."_boxfill_c2", color = tbl.BoxFillColor2, callback = function(c) tbl.BoxFillColor2 = c end})
    sec:slider({name = "Fill Transparency", min = 0, max = 1, default = tbl.BoxFillTransparency, interval = 0.05, flag = prefix.."_boxfill_trans", callback = function(v) tbl.BoxFillTransparency = v end})
    sec:toggle({name = "Chams", default = tbl.Chams, flag = prefix.."_chams", callback = function(v) tbl.Chams = v end})
        :colorpicker({flag = prefix.."_chams_color", color = tbl.ChamsColor, callback = function(c) tbl.ChamsColor = c end})
    sec:toggle({name = "Names", default = tbl.Names, flag = prefix.."_names", callback = function(v) tbl.Names = v end})
        :colorpicker({flag = prefix.."_name_color", color = tbl.NameColor, callback = function(c) tbl.NameColor = c end})
        :colorpicker({flag = prefix.."_name_color2", color = tbl.NameColor2, callback = function(c) tbl.NameColor2 = c end})
    sec:dropdown({name = "Name Type", items = {"Display", "Username", "Both"}, default = tbl.NameType, flag = prefix.."_name_type", callback = function(v) tbl.NameType = v end})
    sec:toggle({name = "Distance", default = tbl.Distance, flag = prefix.."_distance", callback = function(v) tbl.Distance = v end})
        :colorpicker({flag = prefix.."_dist_color", color = tbl.DistanceColor, callback = function(c) tbl.DistanceColor = c end})
        :colorpicker({flag = prefix.."_dist_color2", color = tbl.DistanceColor2, callback = function(c) tbl.DistanceColor2 = c end})
    sec:toggle({name = "Tool", default = tbl.Tool, flag = prefix.."_tool", callback = function(v) tbl.Tool = v end})
        :colorpicker({flag = prefix.."_tool_color", color = tbl.ToolColor, callback = function(c) tbl.ToolColor = c end})
        :colorpicker({flag = prefix.."_tool_color2", color = tbl.ToolColor2, callback = function(c) tbl.ToolColor2 = c end})
    sec:toggle({name = "Health Bar", default = tbl.HealthBar, flag = prefix.."_healthbar", callback = function(v) tbl.HealthBar = v end})
        :colorpicker({flag = prefix.."_health_high", color = tbl.HealthHigh, callback = function(c) tbl.HealthHigh = c end})
        :colorpicker({flag = prefix.."_health_mid", color = tbl.HealthMid, callback = function(c) tbl.HealthMid = c end})
        :colorpicker({flag = prefix.."_health_low", color = tbl.HealthLow, callback = function(c) tbl.HealthLow = c end})
    sec:toggle({name = "Health Text", default = tbl.HealthText, flag = prefix.."_healthtext", callback = function(v) tbl.HealthText = v end})
    sec:toggle({name = "Armor Bar", default = tbl.ArmorBar, flag = prefix.."_armorbar", callback = function(v) tbl.ArmorBar = v end})
        :colorpicker({flag = prefix.."_armor_high", color = tbl.ArmorHigh, callback = function(c) tbl.ArmorHigh = c end})
        :colorpicker({flag = prefix.."_armor_mid", color = tbl.ArmorMid, callback = function(c) tbl.ArmorMid = c end})
        :colorpicker({flag = prefix.."_armor_low", color = tbl.ArmorLow, callback = function(c) tbl.ArmorLow = c end})
    sec:toggle({name = "Skeleton", default = tbl.Skeleton, flag = prefix.."_skeleton", callback = function(v) tbl.Skeleton = v end})
        :colorpicker({flag = prefix.."_skeleton_color", color = tbl.SkeletonColor, callback = function(c) tbl.SkeletonColor = c end})
        :colorpicker({flag = prefix.."_skeleton_color2", color = tbl.SkeletonColor2, callback = function(c) tbl.SkeletonColor2 = c end})
    sec:slider({name = "Skeleton Thickness", min = 1, max = 5, default = tbl.SkeletonThickness, interval = 1, flag = prefix.."_skeleton_thickness", callback = function(v) tbl.SkeletonThickness = v end})
    sec:toggle({name = "Head Dot", default = tbl.HeadDot, flag = prefix.."_headdot", callback = function(v) tbl.HeadDot = v end})
        :colorpicker({flag = prefix.."_headdot_color", color = tbl.HeadDotColor, callback = function(c) tbl.HeadDotColor = c end})
    sec:slider({name = "Head Dot Size", min = 4, max = 40, default = tbl.HeadDotSize, interval = 1, flag = prefix.."_headdot_size", callback = function(v) tbl.HeadDotSize = v end})
    sec:toggle({name = "Tracers", default = tbl.Tracers, flag = prefix.."_tracers", callback = function(v) tbl.Tracers = v end})
        :colorpicker({flag = prefix.."_tracer_color", color = tbl.TracerColor, callback = function(c) tbl.TracerColor = c end})
    sec:slider({name = "Text Size", min = 8, max = 20, default = tbl.TextSize, interval = 1, flag = prefix.."_textsize", callback = function(v) tbl.TextSize = v end})
end

addESPSection(Enemy, ESP.Settings.Enemy, "enemy")
addESPSection(Team, ESP.Settings.Teammate, "team")
addESPSection(AI, ESP.Settings.AI, "ai")

Items:toggle({name = "Enabled", default = ESP.Settings.Items.Enabled, flag = "items_enabled", callback = function(v) ESP.Settings.Items.Enabled = v end})
Items:slider({name = "Max Distance", min = 50, max = 1000, default = ESP.Settings.Items.MaxDistance, interval = 10, flag = "items_maxdist", callback = function(v) ESP.Settings.Items.MaxDistance = v end})
Items:toggle({name = "Show Names", default = ESP.Settings.Items.ShowNames, flag = "items_names", callback = function(v) ESP.Settings.Items.ShowNames = v end})
Items:toggle({name = "Show Distance", default = ESP.Settings.Items.ShowDistance, flag = "items_dist", callback = function(v) ESP.Settings.Items.ShowDistance = v end})
Items:toggle({name = "Chams", default = ESP.Settings.Items.Chams, flag = "items_chams", callback = function(v) ESP.Settings.Items.Chams = v end})

local itemList = {
    {"Safe", "Safe"}, {"Civilian Airdrop", "CivilianAirdrop"}, {"Abandoned Car", "AbandonedCar"},
    {"Duffel Bag", "DuffelBag"}, {"Food Crate", "FoodCrate"}, {"Leather Pouch", "LeatherPouch"},
    {"Supply Crate", "SupplyCrate"}, {"Medical Pouch", "MedicalPouch"}, {"Dropped Item Container", "DroppedItemContainer"},
    {"T.C.R Supply Crate", "TCRCrate"}, {"Metal Crate", "MetalCrate"}, {"Specops Supply Crate", "SpecopsCrate"},
    {"Tall Metal Crate", "TallMetalCrate"}, {"Wooden Crate", "WoodenCrate"}, {"Ammo Box", "AmmoBox"},
    {"Dead Body", "Dead"}
}

for _, item in ipairs(itemList) do
    local displayName, key = item[1], item[2]
    Items:toggle({
        name = displayName,
        default = ESP.Settings.Items[key] and ESP.Settings.Items[key].Enabled or false,
        flag = "items_" .. string.lower(key),
        callback = function(v)
            if ESP.Settings.Items[key] then ESP.Settings.Items[key].Enabled = v end
        end
    }):colorpicker({
        flag = "items_" .. string.lower(key) .. "_color",
        color = ESP.Settings.Items[key] and ESP.Settings.Items[key].Color or Color3.fromRGB(255, 255, 255),
        callback = function(c)
            if ESP.Settings.Items[key] then ESP.Settings.Items[key].Color = c end
        end
    })
end

local fontList = {"Gojiberry Quibble", "Tahoma", "Tahoma Bold", "ProggyClean", "ProggyTiny", "Minecraftia", "Comfortaa", "Rubik", "Verdana", "Inter Medium", "Inter SemiBold"}

Setting:dropdown({name = "Text Font", items = fontList, default = ESP.Settings.TextFont, flag = "esp_text_font", callback = function(v) ESP.Settings.TextFont = v end})
Setting:dropdown({name = "Flags Font", items = fontList, default = ESP.Settings.FlagsFont, flag = "esp_flags_font", callback = function(v) ESP.Settings.FlagsFont = v end})
Setting:dropdown({name = "Health Font", items = fontList, default = ESP.Settings.HealthFont, flag = "esp_health_font", callback = function(v) ESP.Settings.HealthFont = v end})
Setting:dropdown({name = "Text Gradient", items = {"Static", "Animated"}, default = ESP.Settings.TextGradientAnimated and "Animated" or "Static", flag = "esp_text_gradient", callback = function(v) ESP.Settings.TextGradientAnimated = (v == "Animated") end})
Setting:slider({name = "Refresh Rate", min = 60, max = 240, default = ESP.Settings.RefreshRate, flag = "esp_refresh_rate", callback = function(v) ESP.Settings.RefreshRate = v end})

right:preview({ name = "preview" })

local menu = config:section({ name = "menu", side = "left" })
menu:label("menu accent"):colorpicker({
    flag = "menu_accent", color = C.accent,
    callback = function(c) win:setAccent(c) end,
})
menu:button({ name = "unload", callback = function()
    ESP:Stop()
    win:unload()
end})

playersTab:open()
ESP:Start()
