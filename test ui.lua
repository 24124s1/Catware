-- midnight ui (catware-inspired rewrite)
local cloneref = cloneref or function(o) return o end

local Players      = cloneref(game:GetService("Players"))
local UIS          = cloneref(game:GetService("UserInputService"))
local TweenService = cloneref(game:GetService("TweenService"))
local RunService   = cloneref(game:GetService("RunService"))
local HttpService  = cloneref(game:GetService("HttpService"))
local Workspace    = cloneref(game:GetService("Workspace"))
local CoreGui      = cloneref(game:GetService("CoreGui"))
local Lighting     = cloneref(game:GetService("Lighting"))
local GuiService   = cloneref(game:GetService("GuiService"))

local lp     = Players.LocalPlayer
local mouse  = lp:GetMouse()
local camera = Workspace.CurrentCamera
local gui_offset = GuiService:GetGuiInset().Y

local rgb   = Color3.fromRGB
local hsv   = Color3.fromHSV
local hex   = Color3.fromHex
local dim2  = UDim2.new
local dim   = UDim.new
local vec2  = Vector2.new
local vec3  = Vector3.new
local cfr   = CFrame.new
local angle = CFrame.Angles
local clamp = math.clamp
local floor = math.floor
local abs   = math.abs
local sin   = math.sin
local max   = math.max
local min   = math.min
local round = math.round

local Enum_X  = Enum.AutomaticSize.X
local Enum_Y  = Enum.AutomaticSize.Y
local Enum_XY = Enum.AutomaticSize.XY

-- theme
local themes = {
    preset = {
        outline       = hex("#0A0A0A"),
        inline        = hex("#2D2D2D"),
        accent        = hex("#CC7094"),
        high_contrast = hex("#141414"),
        low_contrast  = hex("#1E1E1E"),
        text          = hex("#B4B4B4"),
        text_outline  = rgb(0, 0, 0),
        glow          = hex("#CC7094"),
    },
    utility = {
        outline = { BackgroundColor3 = {}, Color = {} },
        inline  = { BackgroundColor3 = {}, ImageColor3 = {} },
        accent  = { BackgroundColor3 = {}, TextColor3 = {}, ImageColor3 = {}, ScrollBarImageColor3 = {} },
        high_contrast = { BackgroundColor3 = {} },
        low_contrast  = { BackgroundColor3 = {} },
        text = { TextColor3 = {} },
        text_outline = { Color = {} },
        glow = { ImageColor3 = {} },
        contrast = { Color = {} },
    }
}

local function getParent()
    if typeof(gethui) == "function" then
        local ok, ui = pcall(gethui)
        if ok and ui then return ui end
    end
    if not RunService:IsStudio() then
        local ok, cg = pcall(function() return CoreGui end)
        if ok and cg then return cg end
    end
    return lp:WaitForChild("PlayerGui")
end

-- font
local FONT_URL = "https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/fs-tahoma-8px.ttf"
local function loadFont()
    local ok, font = pcall(function()
        if not (writefile and getcustomasset and isfile) then error("no fs") end
        if not isfile("midnight_font.ttf") then
            writefile("midnight_font.ttf", game:HttpGet(FONT_URL))
        end
        local data = {
            name = "MidnightPixel",
            faces = {{ name = "Regular", weight = 400, style = "normal", assetId = getcustomasset("midnight_font.ttf") }}
        }
        writefile("midnight_font.json", HttpService:JSONEncode(data))
        return Font.new(getcustomasset("midnight_font.json"), Enum.FontWeight.Regular)
    end)
    return (ok and font) or Font.fromEnum(Enum.Font.Code)
end
local FONT = loadFont()

-- helpers
local function new(class, props)
    local o = Instance.new(class)
    if o:IsA("GuiObject") then o.BorderSizePixel = 0 end
    if class == "TextLabel" or class == "TextButton" or class == "TextBox" then
        o.FontFace = FONT
        o.TextSize = 12
        o.TextColor3 = themes.preset.text
        o.BackgroundTransparency = 1
        o.TextXAlignment = Enum.TextXAlignment.Left
        o.Text = ""
    end
    if class == "TextButton" then o.AutoButtonColor = false end
    local parent = props and props.Parent
    if props then
        for k, v in pairs(props) do
            if k ~= "Parent" then o[k] = v end
        end
    end
    if parent then o.Parent = parent end
    return o
end

local function apply_theme(inst, theme, prop)
    if themes.utility[theme] and themes.utility[theme][prop] then
        table.insert(themes.utility[theme][prop], inst)
    end
end

local function update_theme(theme, color)
    if not themes.utility[theme] then return end
    for prop, list in pairs(themes.utility[theme]) do
        for _, obj in ipairs(list) do
            if obj and obj.Parent then
                pcall(function() obj[prop] = color end)
            end
        end
    end
    themes.preset[theme] = color
end

local function tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), props):Play()
end

local function inside(obj, pos)
    local p, s = obj.AbsolutePosition, obj.AbsoluteSize
    return pos.X >= p.X and pos.X <= p.X + s.X and pos.Y >= p.Y and pos.Y <= p.Y + s.Y
end

local function framed(parent, size, pos)
    local o = new("Frame", { Parent = parent, Size = size, Position = pos or UDim2.new(), BackgroundColor3 = themes.preset.outline })
    apply_theme(o, "outline", "BackgroundColor3")
    local i = new("Frame", { Parent = o, Size = UDim2.new(1, -2, 1, -2), Position = UDim2.fromOffset(1, 1), BackgroundColor3 = themes.preset.inline })
    apply_theme(i, "inline", "BackgroundColor3")
    local b = new("Frame", { Parent = i, Size = UDim2.new(1, -2, 1, -2), Position = UDim2.fromOffset(1, 1), BackgroundColor3 = themes.preset.high_contrast })
    apply_theme(b, "high_contrast", "BackgroundColor3")
    return b, o
end

local function accentLine(parent)
    local line = new("Frame", { Parent = parent, Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = themes.preset.accent, ZIndex = 2 })
    apply_theme(line, "accent", "BackgroundColor3")
    new("UIGradient", {
        Parent = line, Rotation = 90,
        Color = ColorSequence.new(rgb(255, 255, 255), rgb(150, 150, 150))
    })
    return line
end

local function makeRight(row)
    local r = new("Frame", {
        Parent = row, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum_X, BackgroundTransparency = 1,
    })
    new("UIListLayout", {
        Parent = r, FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder,
    })
    return r
end

-- library
local Library  = {}; Library.__index  = Library
local Category = {}; Category.__index = Category
local Tab      = {}; Tab.__index      = Tab
local Section  = {}; Section.__index  = Section
local Element  = {}; Element.__index  = Element

local flags, config_flags, visible_flags = {}, {}, {}
local connections, drawings, instances = {}, {}, {}
local current_element_open = nil
local display_orders = 0

local function connection(signal, fn)
    local c = signal:Connect(fn)
    table.insert(connections, c)
    return c
end

function Library.new(opts)
    opts = opts or {}
    local self = setmetatable({}, Library)

    self.name       = opts.name or "midnight"
    self.version    = opts.version or "v1"
    self.directory  = opts.directory or "Midnight"
    self.toggleKey  = opts.toggleKey or Enum.KeyCode.RightShift
    self.flags      = flags
    self.setters    = {}
    self.listeners  = {}
    self.connections = connections
    self.order      = 0
    self.popup      = nil
    self.currentTab = nil
    self.opened     = true

    -- folders
    if makefolder then
        makefolder(self.directory)
        makefolder(self.directory .. "/configs")
    end

    self.gui = new("ScreenGui", {
        Name = HttpService:GenerateGUID(false),
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 1000,
        Parent = getParent(),
    })

    local vp = camera.ViewportSize
    self.root = new("Frame", {
        Parent = self.gui,
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(630, 440),
        Position = UDim2.fromOffset(floor(vp.X / 2 - 315), floor(vp.Y / 2 - 220)),
    })

    -- side panel
    local side = framed(self.root, UDim2.fromOffset(148, 440))
    accentLine(side)

    local sideHeader = new("Frame", { Parent = side, Position = UDim2.fromOffset(0, 2), Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1 })
    local iconOuter = new("Frame", { Parent = sideHeader, Position = UDim2.fromOffset(10, 15), Size = UDim2.fromOffset(10, 10), BackgroundColor3 = rgb(22, 22, 22) })
    new("UIStroke", { Parent = iconOuter, Color = rgb(70, 70, 70), LineJoinMode = Enum.LineJoinMode.Miter })
    local iconInner = new("Frame", { Parent = sideHeader, Position = UDim2.fromOffset(14, 19), Size = UDim2.fromOffset(7, 7), BackgroundColor3 = themes.preset.accent })
    apply_theme(iconInner, "accent", "BackgroundColor3")
    new("TextLabel", { Parent = sideHeader, Text = self.name, TextColor3 = rgb(240, 240, 240), Position = UDim2.fromOffset(34, 11), Size = UDim2.new(1, -34, 0, 12) })
    new("TextLabel", { Parent = sideHeader, Text = self.version, TextColor3 = rgb(85, 85, 85), Position = UDim2.fromOffset(34, 23), Size = UDim2.new(1, -34, 0, 12) })
    new("Frame", { Parent = side, Position = UDim2.fromOffset(0, 44), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = rgb(30, 30, 30) })

    self.sideList = new("Frame", { Parent = side, Position = UDim2.fromOffset(0, 50), Size = UDim2.new(1, 0, 1, -100), BackgroundTransparency = 1 })
    new("UIListLayout", { Parent = self.sideList, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder })

    local footer = new("Frame", { Parent = side, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 44), BackgroundTransparency = 1 })
    new("Frame", { Parent = footer, Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = rgb(30, 30, 30) })
    local avatar = new("Frame", { Parent = footer, Position = UDim2.fromOffset(10, 10), Size = UDim2.fromOffset(24, 24), BackgroundColor3 = rgb(10, 10, 10) })
    new("UIStroke", { Parent = avatar, Color = rgb(48, 48, 48), LineJoinMode = Enum.LineJoinMode.Miter })
    new("TextLabel", {
        Parent = avatar, Size = UDim2.new(1, 0, 1, 0),
        Text = lp.Name:sub(1, 1):upper(),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextColor3 = rgb(240, 240, 240),
    })
    new("TextLabel", { Parent = footer, Text = lp.Name, TextColor3 = rgb(215, 215, 215), Position = UDim2.fromOffset(42, 10), Size = UDim2.new(1, -46, 0, 12), TextTruncate = Enum.TextTruncate.AtEnd })
    new("TextLabel", { Parent = footer, Text = "uid " .. tostring(lp.UserId), TextColor3 = rgb(85, 85, 85), Position = UDim2.fromOffset(42, 22), Size = UDim2.new(1, -46, 0, 12), TextTruncate = Enum.TextTruncate.AtEnd })

    -- content
    local content = framed(self.root, UDim2.fromOffset(474, 440), UDim2.fromOffset(156, 0))
    accentLine(content)

    local header = new("Frame", { Parent = content, Position = UDim2.fromOffset(0, 2), Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1 })
    local crumbs = new("Frame", { Parent = header, Position = UDim2.fromOffset(8, 0), Size = UDim2.new(0.7, 0, 1, 0), BackgroundTransparency = 1 })
    new("UIListLayout", {
        Parent = crumbs, FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 4),
    })
    self.crumbCat = new("TextLabel", { Parent = crumbs, Text = "", TextColor3 = rgb(85, 85, 85), AutomaticSize = Enum_X, Size = UDim2.new(0, 0, 1, 0) })
    self.crumbTab = new("TextLabel", { Parent = crumbs, Text = "", TextColor3 = rgb(240, 240, 240), AutomaticSize = Enum_X, Size = UDim2.new(0, 0, 1, 0) })
    local cfgName = new("TextLabel", { Parent = header, Text = opts.config or "default.cfg", TextColor3 = rgb(70, 70, 70), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 0), Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum_X })
    new("Frame", { Parent = content, Position = UDim2.fromOffset(0, 31), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = rgb(30, 30, 30) })

    self.pageHolder = new("Frame", { Parent = content, Position = UDim2.fromOffset(0, 32), Size = UDim2.new(1, 0, 1, -32), BackgroundTransparency = 1 })

    -- drag
    self:drag(sideHeader, self.root)
    self:drag(header, self.root)

    -- watermark
    self:watermark()

    -- keybind
    connection(UIS.InputBegan, function(input, gp)
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
    connection(UIS.InputChanged, function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - startInput
            target.Position = UDim2.fromOffset(startPos.X.Offset + d.X, startPos.Y.Offset + d.Y)
        end
    end)
end

function Library:setAccent(c)
    update_theme("accent", c)
    update_theme("glow", c)
end

function Library:setFlag(flag, value)
    flags[flag] = value
    for _, fn in ipairs(self.listeners) do
        pcall(fn, flag, value)
    end
end

function Library:onChange(fn)
    table.insert(self.listeners, fn)
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
    if current_element_open then
        current_element_open.set_visible(false)
        current_element_open.open = false
        current_element_open = nil
    end
end

function Library:unload()
    for _, c in ipairs(connections) do c:Disconnect() end
    self.gui:Destroy()
end

function Library:watermark()
    local outer = new("Frame", {
        Parent = self.gui, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 8),
        Size = UDim2.new(0, 0, 0, 20), AutomaticSize = Enum_X, BackgroundColor3 = themes.preset.outline,
    })
    apply_theme(outer, "outline", "BackgroundColor3")
    new("UIPadding", { Parent = outer, PaddingTop = UDim.new(0, 1), PaddingBottom = UDim.new(0, 1), PaddingLeft = UDim.new(0, 1), PaddingRight = UDim.new(0, 1) })
    local inner = new("Frame", { Parent = outer, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum_X, BackgroundColor3 = themes.preset.inline })
    apply_theme(inner, "inline", "BackgroundColor3")
    new("UIPadding", { Parent = inner, PaddingTop = UDim.new(0, 1), PaddingBottom = UDim.new(0, 1), PaddingLeft = UDim.new(0, 1), PaddingRight = UDim.new(0, 1) })
    local body = new("Frame", { Parent = inner, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum_X, BackgroundColor3 = themes.preset.high_contrast })
    apply_theme(body, "high_contrast", "BackgroundColor3")
    local line = new("Frame", { Parent = body, Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = themes.preset.accent, ZIndex = 2 })
    apply_theme(line, "accent", "BackgroundColor3")

    local text = new("TextLabel", {
        Parent = body, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum_X, RichText = true,
        TextYAlignment = Enum.TextYAlignment.Center,
    })
    new("UIPadding", { Parent = text, PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) })

    local fps, frames, acc = 60, 0, 0
    connection(RunService.RenderStepped, function(dt)
        frames += 1
        acc += dt
        if acc >= 0.5 then
            fps = floor(frames / acc + 0.5)
            frames, acc = 0, 0
            local c = themes.preset.accent
            text.Text = string.format(
                '<font color="rgb(%d,%d,%d)">%s</font> | %s | %d fps | %s',
                floor(c.R * 255), floor(c.G * 255), floor(c.B * 255),
                self.name, lp.Name, fps, os.date("%H:%M")
            )
        end
    end)
end

-- category / tab / section
function Library:category(name)
    local cat = setmetatable({ lib = self, name = name }, Category)
    local row = new("Frame", { Parent = self.sideList, Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, LayoutOrder = self.order })
    self.order += 1
    new("UIListLayout", {
        Parent = row, FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    new("UIPadding", { Parent = row, PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 10) })
    local t = new("TextLabel", { Parent = row, Text = name, TextColor3 = rgb(95, 95, 95), AutomaticSize = Enum_X, Size = UDim2.new(0, 0, 1, 0) })
    local line = new("Frame", { Parent = row, Size = UDim2.new(0, 10, 0, 1), BackgroundColor3 = rgb(36, 36, 36) })
    new("UIFlexItem", { Parent = line, FlexMode = Enum.UIFlexMode.Fill })
    return cat
end

function Category:tab(name)
    local lib = self.lib
    local tab = setmetatable({ lib = lib, name = name, category = self }, Tab)

    tab.button = new("TextButton", {
        Parent = lib.sideList, Size = UDim2.new(1, 0, 0, 20), LayoutOrder = lib.order,
        BackgroundColor3 = rgb(24, 24, 24), BackgroundTransparency = 1,
    })
    lib.order += 1
    tab.bar = new("Frame", { Parent = tab.button, Size = UDim2.new(0, 2, 1, 0), BackgroundColor3 = themes.preset.accent, Visible = false })
    apply_theme(tab.bar, "accent", "BackgroundColor3")
    tab.bullet = new("Frame", { Parent = tab.button, Position = UDim2.fromOffset(11, 9), Size = UDim2.fromOffset(3, 3), BackgroundColor3 = rgb(70, 70, 70) })
    tab.text = new("TextLabel", { Parent = tab.button, Text = name, TextColor3 = rgb(160, 160, 160), Position = UDim2.fromOffset(22, 0), Size = UDim2.new(1, -22, 1, 0) })

    tab.page = new("Frame", { Parent = lib.pageHolder, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false })
    new("UIPadding", { Parent = tab.page, PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })
    new("UIListLayout", { Parent = tab.page, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })

    for i, side in ipairs({ "left", "right" }) do
        local col = new("Frame", { Parent = tab.page, Size = UDim2.new(0.5, -4, 1, 0), BackgroundTransparency = 1, LayoutOrder = i })
        new("UIListLayout", { Parent = col, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })
        tab[side] = col
    end

    tab.button.MouseButton1Click:Connect(function() tab:open() end)

    return tab
end

function Tab:setActive(on)
    self.page.Visible = on
    self.bar.Visible = on
    self.button.BackgroundTransparency = on and 0 or 1
    self.text.TextColor3 = on and rgb(245, 245, 245) or rgb(160, 160, 160)
    self.bullet.BackgroundColor3 = on and themes.preset.accent or rgb(70, 70, 70)
end

function Tab:open()
    local lib = self.lib
    lib:closePopups()
    if lib.currentTab then lib.currentTab:setActive(false) end
    lib.currentTab = self
    self:setActive(true)
    lib.crumbCat.Text = self.category.name .. " /"
    lib.crumbTab.Text = self.name
end

function Tab:section(o)
    o = o or {}
    local lib = self.lib
    local col = (o.side == "right") and self.right or self.left

    local container = new("Frame", {
        Parent = col, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum_Y,
        BackgroundTransparency = 1, LayoutOrder = lib.order,
    })
    lib.order += 1
    new("UIPadding", { Parent = container, PaddingTop = UDim.new(0, 7) })

    local body = new("Frame", { Parent = container, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum_Y, BackgroundColor3 = themes.preset.high_contrast, ZIndex = 1 })
    apply_theme(body, "high_contrast", "BackgroundColor3")
    new("UIStroke", { Parent = body, Color = themes.preset.inline, LineJoinMode = Enum.LineJoinMode.Miter })
    apply_theme(body:FindFirstChildOfClass("UIStroke"), "inline", "Color")
    new("UIPadding", { Parent = body, PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })
    new("UIListLayout", { Parent = body, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder })

    local title = new("TextLabel", {
        Parent = container, Text = o.name or "section", TextColor3 = themes.preset.text,
        Position = UDim2.fromOffset(6, -7), AutomaticSize = Enum_XY, BackgroundTransparency = 0,
        BackgroundColor3 = themes.preset.high_contrast, ZIndex = 3,
    })
    apply_theme(title, "high_contrast", "BackgroundColor3")
    apply_theme(title, "text", "TextColor3")
    new("UIStroke", { Parent = title, Color = themes.preset.inline, LineJoinMode = Enum.LineJoinMode.Miter })
    new("UIPadding", { Parent = title, PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4) })

    return setmetatable({ lib = lib, body = body, holder = body }, Section)
end

-- multisection helper
function Tab:multisection(o)
    o = o or {}
    local lib = self.lib
    local col = (o.side == "right") and self.right or self.left

    local container = new("Frame", {
        Parent = col, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum_Y,
        BackgroundTransparency = 1, LayoutOrder = lib.order,
    })
    lib.order += 1

    local layout = new("UIListLayout", {
        Parent = container, FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder,
    })

    local sections = {}
    for i, name in ipairs(o.names or { "A", "B" }) do
        local sec = self:section({ name = name, side = o.side })
        sec.body.Parent = container
        sec.body.Size = UDim2.new(1 / #o.names, -3, 0, 0)
        table.insert(sections, sec)
    end
    return sections
end

-- elements
function Section:label(text)
    local lib = self.lib
    local row = new("Frame", { Parent = self.body, Size = UDim2.new(1, 0, 0, 13), BackgroundTransparency = 1, LayoutOrder = lib.order })
    lib.order += 1
    local lbl = new("TextLabel", { Parent = row, Text = text, TextColor3 = themes.preset.text, Size = UDim2.new(1, -30, 1, 0) })
    apply_theme(lbl, "text", "TextColor3")
    local e = setmetatable({ lib = lib, right = makeRight(row), lbl = lbl }, Element)
    function e.set(t) lbl.Text = t end
    return e
end

function Section:button(o)
    local lib = self.lib
    local btn = new("TextButton", {
        Parent = self.body, Size = UDim2.new(1, 0, 0, 18), LayoutOrder = lib.order,
        BackgroundColor3 = rgb(20, 20, 20), Text = o.name or "button",
        TextXAlignment = Enum.TextXAlignment.Center,
    })
    lib.order += 1
    new("UIStroke", { Parent = btn, Color = rgb(36, 36, 36), LineJoinMode = Enum.LineJoinMode.Miter })
    btn.MouseButton1Click:Connect(function()
        btn.TextColor3 = themes.preset.accent
        tween(btn, { TextColor3 = themes.preset.text }, 0.3)
        if o.callback then o.callback() end
    end)
    return btn
end

function Section:toggle(o)
    local lib = self.lib
    local cfg = {
        lib = lib, name = o.name or "toggle", flag = o.flag or o.name or "toggle",
        callback = o.callback or function() end, value = false,
    }

    local row = new("TextButton", { Parent = self.body, Size = UDim2.new(1, 0, 0, 13), LayoutOrder = lib.order })
    lib.order += 1
    local box = new("Frame", { Parent = row, Position = UDim2.fromOffset(0, 3), Size = UDim2.fromOffset(7, 7), BackgroundColor3 = rgb(24, 24, 24) })
    new("UIStroke", { Parent = box, Color = rgb(48, 48, 48), LineJoinMode = Enum.LineJoinMode.Miter })
    local lbl = new("TextLabel", { Parent = row, Text = cfg.name, TextColor3 = rgb(112, 112, 112), Position = UDim2.fromOffset(16, 0), Size = UDim2.new(1, -16, 1, 0) })
    cfg.right = makeRight(row)

    function cfg.set(v)
        cfg.value = v and true or false
        lib:setFlag(cfg.flag, cfg.value)
        tween(box, { BackgroundColor3 = cfg.value and themes.preset.accent or rgb(24, 24, 24) })
        tween(lbl, { TextColor3 = cfg.value and themes.preset.text or rgb(112, 112, 112) })
        cfg.callback(cfg.value)
    end

    row.MouseButton1Click:Connect(function() cfg.set(not cfg.value) end)

    config_flags[cfg.flag] = cfg.set
    cfg.set(o.default or false)

    return setmetatable(cfg, Element)
end

function Element:colorpicker(o)
    o = o or {}
    local lib = self.lib
    lib.cpCount = (lib.cpCount or 0) + 1

    local cp = {
        flag = o.flag or ("color_" .. lib.cpCount),
        callback = o.callback or function() end,
        open = false,
        color = o.color or rgb(255, 255, 255),
        alpha = o.alpha or 1,
    }
    local h, s, v = cp.color:ToHSV()
    local a = cp.alpha

    local swatch = new("TextButton", {
        Parent = self.right, Size = UDim2.fromOffset(16, 6),
        BackgroundColor3 = cp.color, LayoutOrder = lib.cpCount,
    })
    new("UIStroke", { Parent = swatch, Color = themes.preset.outline, LineJoinMode = Enum.LineJoinMode.Miter })
    new("UIGradient", { Parent = swatch, Rotation = 90, Color = ColorSequence.new(rgb(255, 255, 255), rgb(170, 170, 170)) })

    local pop = new("Frame", {
        Parent = lib.gui, Visible = false, Size = UDim2.fromOffset(190, 210),
        BackgroundColor3 = themes.preset.outline, ZIndex = 100,
    })
    apply_theme(pop, "outline", "BackgroundColor3")

    local win_inline = new("Frame", { Parent = pop, Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 1, -2), BackgroundColor3 = themes.preset.accent })
    apply_theme(win_inline, "accent", "BackgroundColor3")
    local win_holder = new("Frame", { Parent = win_inline, Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 1, -2), BackgroundColor3 = themes.preset.high_contrast })
    apply_theme(win_holder, "high_contrast", "BackgroundColor3")
    new("UIGradient", {
        Parent = win_holder, Rotation = 90,
        Color = ColorSequence.new(rgb(41, 41, 55), rgb(35, 35, 47))
    })

    local title = new("TextLabel", {
        Parent = win_holder, Text = o.name or "Color", TextColor3 = themes.preset.text,
        Position = UDim2.fromOffset(4, 4), AutomaticSize = Enum_XY,
    })
    apply_theme(title, "text", "TextColor3")
    new("UIStroke", { Parent = title, LineJoinMode = Enum.LineJoinMode.Miter })

    -- sat/val
    local main = new("Frame", { Parent = win_holder, Position = UDim2.fromOffset(4, 24), Size = UDim2.new(1, -8, 1, -50), BackgroundColor3 = themes.preset.inline })
    apply_theme(main, "inline", "BackgroundColor3")
    local main_in = new("Frame", { Parent = main, Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 1, -2), BackgroundColor3 = themes.preset.outline })
    apply_theme(main_in, "outline", "BackgroundColor3")
    local main_bg = new("Frame", { Parent = main_in, Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 1, -2), BackgroundColor3 = themes.preset.high_contrast })
    apply_theme(main_bg, "high_contrast", "BackgroundColor3")
    new("UIPadding", { Parent = main_bg, PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4) })

    local satval = new("Frame", { Parent = main_bg, Size = UDim2.new(1, -20, 1, -20), BackgroundColor3 = Color3.fromHSV(h, 1, 1) })
    local white = new("Frame", { Parent = satval, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = rgb(255, 255, 255) })
    new("UIGradient", { Parent = white, Transparency = NumberSequence.new(0, 1) })
    local black = new("Frame", { Parent = satval, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = rgb(0, 0, 0) })
    new("UIGradient", { Parent = black, Rotation = 90, Transparency = NumberSequence.new(1, 0) })
    local svBtn = new("TextButton", { Parent = satval, Size = UDim2.new(1, 0, 1, 0), ZIndex = 3 })
    local svCursor = new("Frame", { Parent = satval, Size = UDim2.fromOffset(4, 4), BackgroundColor3 = rgb(255, 255, 255), ZIndex = 4, BorderSizePixel = 1, BorderColor3 = rgb(0, 0, 0) })

    -- hue
    local hue = new("TextButton", { Parent = main_bg, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.fromOffset(14, 1), BackgroundColor3 = themes.preset.inline })
    apply_theme(hue, "inline", "BackgroundColor3")
    hue.Size = UDim2.new(0, 14, 1, -20)
    local hue_in = new("Frame", { Parent = hue, Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 1, -2), BackgroundColor3 = themes.preset.outline })
    local hue_grad = new("Frame", { Parent = hue_in, Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 1, -2), BackgroundColor3 = rgb(255, 255, 255) })
    new("UIGradient", {
        Parent = hue_grad, Rotation = 270,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, rgb(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, rgb(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, rgb(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, rgb(0, 255, 255)),
            ColorSequenceKeypoint.new(0.67, rgb(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, rgb(255, 0, 255)),
            ColorSequenceKeypoint.new(1, rgb(255, 0, 0)),
        }),
    })
    local hueCursor = new("Frame", { Parent = hue_grad, Size = UDim2.new(1, 0, 0, 3), BackgroundColor3 = rgb(255, 255, 255), BorderSizePixel = 1, BorderColor3 = rgb(0, 0, 0) })

    -- alpha
    local alpha = new("TextButton", { Parent = main_bg, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, -20, 0, 14), BackgroundColor3 = themes.preset.inline })
    apply_theme(alpha, "inline", "BackgroundColor3")
    local alpha_in = new("Frame", { Parent = alpha, Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 1, -2), BackgroundColor3 = themes.preset.outline })
    local alpha_drag = new("Frame", { Parent = alpha_in, Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 1, -2), BackgroundColor3 = Color3.fromHSV(h, s, v) })
    local alphaind = new("ImageLabel", {
        Parent = alpha_drag, ScaleType = Enum.ScaleType.Tile, Image = "rbxassetid://18274452449",
        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), TileSize = UDim2.fromOffset(6, 6),
    })
    new("UIGradient", { Parent = alphaind, Transparency = NumberSequence.new(0, 1) })
    local alphaCursor = new("Frame", { Parent = alpha_drag, Size = UDim2.new(0, 3, 1, 0), BackgroundColor3 = rgb(255, 255, 255), BorderSizePixel = 1, BorderColor3 = rgb(0, 0, 0) })

    -- rainbow + copy/paste
    local bottom = new("Frame", { Parent = win_holder, Position = UDim2.fromOffset(4, 1), AnchorPoint = Vector2.new(0, 1), Size = UDim2.new(1, -8, 0, 20), BackgroundTransparency = 1 })
    bottom.Position = UDim2.new(0, 4, 1, -4)
    local rainbowBtn = new("TextButton", { Parent = bottom, Size = UDim2.new(0.4, -2, 1, 0), Text = "Rainbow", TextXAlignment = Enum.TextXAlignment.Center, BackgroundColor3 = rgb(20, 20, 20) })
    new("UIStroke", { Parent = rainbowBtn, Color = rgb(36, 36, 36), LineJoinMode = Enum.LineJoinMode.Miter })
    local copyBtn = new("TextButton", { Parent = bottom, Position = UDim2.new(0.4, 2, 0, 0), Size = UDim2.new(0.3, -2, 1, 0), Text = "Copy", TextXAlignment = Enum.TextXAlignment.Center, BackgroundColor3 = rgb(20, 20, 20) })
    new("UIStroke", { Parent = copyBtn, Color = rgb(36, 36, 36), LineJoinMode = Enum.LineJoinMode.Miter })
    local pasteBtn = new("TextButton", { Parent = bottom, Position = UDim2.new(0.7, 2, 0, 0), Size = UDim2.new(0.3, -2, 1, 0), Text = "Paste", TextXAlignment = Enum.TextXAlignment.Center, BackgroundColor3 = rgb(20, 20, 20) })
    new("UIStroke", { Parent = pasteBtn, Color = rgb(36, 36, 36), LineJoinMode = Enum.LineJoinMode.Miter })

    local rainbow = false
    local dragging_sat, dragging_hue, dragging_alpha = false, false, false

    local function apply()
        local c = Color3.fromHSV(h, s, v)
        swatch.BackgroundColor3 = c
        satval.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        alpha_drag.BackgroundColor3 = c
        svCursor.Position = UDim2.new(s, -2, 1 - v, -2)
        hueCursor.Position = UDim2.new(0, 0, h, -1)
        alphaCursor.Position = UDim2.new(a, -1, 0, 0)
        flags[cp.flag] = { Color = c, Transparency = a }
        cp.callback(c, a)
    end

    local function update()
        local m = UIS:GetMouseLocation()
        if dragging_sat then
            s = clamp((m.X - satval.AbsolutePosition.X) / satval.AbsoluteSize.X, 0, 1)
            v = 1 - clamp((m.Y - satval.AbsolutePosition.Y) / satval.AbsoluteSize.Y, 0, 1)
        elseif dragging_hue then
            h = clamp(1 - (m.Y - hue.AbsolutePosition.Y) / hue.AbsoluteSize.Y, 0, 0.999)
        elseif dragging_alpha then
            a = clamp((m.X - alpha.AbsolutePosition.X) / alpha.AbsoluteSize.X, 0, 1)
        end
        apply()
    end

    svBtn.MouseButton1Down:Connect(function() dragging_sat = true; update() end)
    hue.MouseButton1Down:Connect(function() dragging_hue = true; update() end)
    alpha.MouseButton1Down:Connect(function() dragging_alpha = true; update() end)
    connection(UIS.InputEnded, function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging_sat = dragging_hue = dragging_alpha = false
        end
    end)
    connection(UIS.InputChanged, function(i)
        if (dragging_sat or dragging_hue or dragging_alpha) and i.UserInputType == Enum.UserInputType.MouseMovement then
            update()
        end
    end)

    rainbowBtn.MouseButton1Click:Connect(function()
        rainbow = not rainbow
        rainbowBtn.TextColor3 = rainbow and themes.preset.accent or themes.preset.text
    end)
    copyBtn.MouseButton1Click:Connect(function()
        lib.copied_flag = flags[cp.flag]
        lib.is_rainbow = rainbow
    end)
    pasteBtn.MouseButton1Click:Connect(function()
        if lib.copied_flag then
            local c = lib.copied_flag.Color
            h, s, v = c:ToHSV()
            a = lib.copied_flag.Transparency or 1
            rainbow = lib.is_rainbow or false
            rainbowBtn.TextColor3 = rainbow and themes.preset.accent or themes.preset.text
            apply()
        end
    end)

    task.spawn(function()
        while true do
            task.wait()
            if rainbow then
                h = (tick() % 5) / 5
                apply()
            end
        end
    end)

    local popup = { frame = pop, anchor = swatch }
    function popup.close()
        pop.Visible = false
        cp.open = false
    end

    function cp.set_visible(bool)
        pop.Visible = bool
        if bool then
            if current_element_open and current_element_open ~= cp then
                current_element_open.set_visible(false)
                current_element_open.open = false
            end
            current_element_open = cp
            local p = swatch.AbsolutePosition
            local vp = camera.ViewportSize
            local x = clamp(p.X + swatch.AbsoluteSize.X - 190, 0, vp.X - 190)
            pop.Position = UDim2.fromOffset(x, p.Y + 12)
        end
    end

    swatch.MouseButton1Click:Connect(function()
        cp.open = not cp.open
        cp.set_visible(cp.open)
        if cp.open then lib:openPopup(popup) else lib.popup = nil end
    end)

    function cp.set(color, alpha)
        if color then h, s, v = color:ToHSV() end
        if alpha then a = alpha end
        apply()
    end

    config_flags[cp.flag] = function(val)
        if type(val) == "table" and val.Color then
            cp.set(val.Color, val.Transparency)
        elseif typeof(val) == "Color3" then
            cp.set(val)
        end
    end

    apply()
    return self
end

function Section:dropdown(o)
    local lib = self.lib
    local cfg = {
        lib = lib, name = o.name or "dropdown", flag = o.flag or o.name or "dropdown",
        items = o.items or {}, multi = o.multi or false,
        callback = o.callback or function() end, open = false, buttons = {},
        option_instances = {}, multi_items = {},
    }
    local default = o.default
    if default == nil then default = cfg.multi and {} or cfg.items[1] end

    local holder = new("Frame", { Parent = self.body, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, LayoutOrder = lib.order })
    lib.order += 1
    local btn = new("TextButton", { Parent = holder, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = rgb(20, 20, 20) })
    new("UIStroke", { Parent = btn, Color = rgb(36, 36, 36), LineJoinMode = Enum.LineJoinMode.Miter })
    new("TextLabel", { Parent = btn, Text = cfg.name, TextColor3 = rgb(85, 85, 85), Position = UDim2.fromOffset(5, 0), Size = UDim2.new(0.4, 0, 1, 0) })
    local valLbl = new("TextLabel", {
        Parent = btn, Text = "", TextColor3 = themes.preset.text,
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -16, 0, 0),
        Size = UDim2.new(0.6, -16, 1, 0), TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })
    apply_theme(valLbl, "text", "TextColor3")

    local list = new("Frame", {
        Parent = lib.gui, Visible = false, Size = UDim2.new(0, 100, 0, 0),
        AutomaticSize = Enum_Y, BackgroundColor3 = themes.preset.high_contrast, ZIndex = 100,
    })
    apply_theme(list, "high_contrast", "BackgroundColor3")
    new("UIStroke", { Parent = list, Color = rgb(60, 60, 60), LineJoinMode = Enum.LineJoinMode.Miter })
    new("UIListLayout", { Parent = list, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2) })
    new("UIPadding", { Parent = list, PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 2) })

    local function recolor()
        local lookup = {}
        if cfg.multi then
            for _, x in ipairs(cfg.value or {}) do lookup[x] = true end
        else
            lookup[cfg.value] = true
        end
        for item, b in pairs(cfg.buttons) do
            b.TextColor3 = lookup[item] and themes.preset.accent or rgb(112, 112, 112)
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
            valLbl.Text = table.concat(sel, ", ")
        else
            cfg.value = val
            valLbl.Text = tostring(val or "")
        end
        recolor()
        lib:setFlag(cfg.flag, cfg.value)
        cfg.callback(cfg.value)
    end

    function cfg.refresh_options(list)
        for _, v in ipairs(cfg.option_instances) do v:Destroy() end
        cfg.option_instances = {}
        cfg.buttons = {}
        for i, item in ipairs(list) do
            local b = new("TextButton", {
                Parent = list, Size = UDim2.new(1, 0, 0, 16), Text = item,
                TextColor3 = rgb(112, 112, 112), LayoutOrder = i,
            })
            new("UIPadding", { Parent = b, PaddingLeft = UDim.new(0, 6) })
            cfg.buttons[item] = b
            table.insert(cfg.option_instances, b)
            b.MouseButton1Click:Connect(function()
                if cfg.multi then
                    local new_sel, found = {}, false
                    for _, x in ipairs(cfg.value) do
                        if x == item then found = true else table.insert(new_sel, x) end
                    end
                    if not found then table.insert(new_sel, item) end
                    cfg.set(new_sel)
                else
                    cfg.set(item)
                    popup.close()
                    lib.popup = nil
                end
            end)
        end
        recolor()
    end

    local popup = { frame = list, anchor = btn }
    function popup.close()
        list.Visible = false
        cfg.open = false
    end

    function cfg.set_visible(bool)
        list.Visible = bool
        if bool then
            if current_element_open and current_element_open ~= cfg then
                current_element_open.set_visible(false)
                current_element_open.open = false
            end
            current_element_open = cfg
            local p = btn.AbsolutePosition
            list.Position = UDim2.fromOffset(p.X, p.Y + btn.AbsoluteSize.Y + 2)
            list.Size = UDim2.new(0, btn.AbsoluteSize.X, 0, 0)
        end
    end

    btn.MouseButton1Click:Connect(function()
        cfg.open = not cfg.open
        cfg.set_visible(cfg.open)
        if cfg.open then lib:openPopup(popup) else lib.popup = nil end
    end)

    cfg.refresh_options(cfg.items)
    config_flags[cfg.flag] = cfg.set
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

    local row = new("Frame", { Parent = self.body, Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, LayoutOrder = lib.order })
    lib.order += 1
    new("TextLabel", { Parent = row, Text = cfg.name, TextColor3 = themes.preset.text, Size = UDim2.new(0.5, 0, 0, 12) })
    local valLbl = new("TextLabel", {
        Parent = row, Text = "", TextColor3 = themes.preset.text,
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0.5, 0, 0, 12), TextXAlignment = Enum.TextXAlignment.Right,
    })
    apply_theme(valLbl, "text", "TextColor3")

    local track = new("TextButton", { Parent = row, Position = UDim2.fromOffset(0, 15), Size = UDim2.new(1, 0, 0, 4), BackgroundColor3 = rgb(32, 32, 32) })
    new("UIStroke", { Parent = track, Color = themes.preset.outline, LineJoinMode = Enum.LineJoinMode.Miter })
    local fill = new("Frame", { Parent = track, Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = themes.preset.accent })
    apply_theme(fill, "accent", "BackgroundColor3")
    new("UIGradient", { Parent = fill, Rotation = 90, Color = ColorSequence.new(rgb(255, 255, 255), rgb(150, 150, 150)) })
    local handle = new("Frame", {
        Parent = track, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.fromOffset(4, 9), BackgroundColor3 = rgb(125, 125, 125), ZIndex = 3,
    })
    new("UIStroke", { Parent = handle, Color = themes.preset.outline, LineJoinMode = Enum.LineJoinMode.Miter })

    function cfg.set(val)
        val = clamp(floor(val / cfg.interval + 0.5) * cfg.interval, cfg.min, cfg.max)
        val = tonumber(string.format("%." .. decimals .. "f", val))
        cfg.value = val
        local frac = (val - cfg.min) / (cfg.max - cfg.min)
        fill.Size = UDim2.new(frac, 0, 1, 0)
        handle.Position = UDim2.new(frac, 0, 0.5, 0)
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
    connection(UIS.InputChanged, function(i)
        if cfg.dragging and i.UserInputType == Enum.UserInputType.MouseMovement then fromMouse() end
    end)
    connection(UIS.InputEnded, function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then cfg.dragging = false end
    end)

    config_flags[cfg.flag] = cfg.set
    cfg.set(o.default or cfg.min)
    return cfg
end

function Section:keybind(o)
    local lib = self.lib
    local cfg = {
        flag = o.flag or "keybind",
        callback = o.callback or function() end,
        key = o.key or Enum.KeyCode.Unknown,
        mode = o.mode or "toggle",
        active = false,
        open = false,
        name = o.name,
    }

    local btn = new("TextButton", {
        Parent = self.right or self.body, Size = UDim2.fromOffset(40, 14),
        BackgroundColor3 = themes.preset.outline, Text = "",
    })
    apply_theme(btn, "outline", "BackgroundColor3")
    local inline = new("Frame", { Parent = btn, Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 1, -2), BackgroundColor3 = themes.preset.inline })
    apply_theme(inline, "inline", "BackgroundColor3")
    local keyText = new("TextLabel", {
        Parent = inline, Size = UDim2.new(1, 0, 1, 0), Text = "none",
        TextXAlignment = Enum.TextXAlignment.Center, TextColor3 = themes.preset.text,
    })
    apply_theme(keyText, "text", "TextColor3")

    local keys = {
        [Enum.KeyCode.LeftShift] = "LS", [Enum.KeyCode.RightShift] = "RS",
        [Enum.KeyCode.LeftControl] = "LC", [Enum.KeyCode.RightControl] = "RC",
        [Enum.KeyCode.LeftAlt] = "LA", [Enum.KeyCode.RightAlt] = "RA",
        [Enum.KeyCode.Insert] = "INS", [Enum.KeyCode.Escape] = "ESC",
        [Enum.KeyCode.Space] = "SPC", [Enum.KeyCode.Return] = "ENT",
        [Enum.UserInputType.MouseButton1] = "MB1", [Enum.UserInputType.MouseButton2] = "MB2",
    }

    function cfg.set(input)
        if typeof(input) == "EnumItem" then
            cfg.key = input
            local name = keys[input] or tostring(input):gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "")
            keyText.Text = string.lower(name)
        elseif type(input) == "table" then
            cfg.key = input.key or cfg.key
            cfg.mode = input.mode or cfg.mode
            cfg.active = input.active or cfg.active
            local name = keys[cfg.key] or tostring(cfg.key):gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "")
            keyText.Text = string.lower(name or "none")
        end
        flags[cfg.flag] = { key = cfg.key, mode = cfg.mode, active = cfg.active }
        cfg.callback(cfg.active)
    end

    btn.MouseButton1Click:Connect(function()
        keyText.Text = "..."
        local conn
        conn = connection(UIS.InputBegan, function(input, gp)
            if gp then return end
            local key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
            if key == Enum.KeyCode.Escape then key = nil end
            cfg.set(key)
            conn:Disconnect()
        end)
    end)

    connection(UIS.InputBegan, function(input, gp)
        if gp or not cfg.key then return end
        local key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
        if key == cfg.key then
            if cfg.mode == "toggle" then
                cfg.active = not cfg.active
                cfg.callback(cfg.active)
            elseif cfg.mode == "hold" then
                cfg.active = true
                cfg.callback(true)
            end
        end
    end)
    connection(UIS.InputEnded, function(input, gp)
        if gp or not cfg.key or cfg.mode ~= "hold" then return end
        local key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
        if key == cfg.key then
            cfg.active = false
            cfg.callback(false)
        end
    end)

    config_flags[cfg.flag] = cfg.set
    cfg.set({ key = o.key, mode = o.mode or "toggle", active = o.default or false })
    return cfg
end

-- ESP Preview (Catware style)
function Tab:preview(o)
    o = o or {}
    local lib = self.lib
    local ids = o.flags or {}
    local sec = self:section({ name = o.name or "preview", side = o.side })

    local area = new("Frame", {
        Parent = sec.body, Size = UDim2.new(1, 0, 0, 250),
        BackgroundColor3 = rgb(10, 10, 10), ClipsDescendants = true, LayoutOrder = lib.order,
    })
    lib.order += 1
    new("UIStroke", { Parent = area, Color = rgb(32, 32, 32), LineJoinMode = Enum.LineJoinMode.Miter })

    local vp = new("ViewportFrame", {
        Parent = area, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Ambient = rgb(190, 190, 190), LightColor = rgb(255, 255, 255),
    })
    local cam = Instance.new("Camera")
    cam.FieldOfView = 40
    cam.CFrame = CFrame.lookAt(Vector3.new(0, 0.4, 7.5), Vector3.new(0, -0.1, 0))
    cam.Parent = vp
    vp.CurrentCamera = cam

    local ov = new("Frame", {
        Parent = area, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 6), Size = UDim2.fromOffset(130, 168),
        BackgroundTransparency = 1,
    })

    -- box (full)
    local box_handler = new("Frame", { Parent = ov, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 })
    local box_stroke = new("UIStroke", {
        Parent = box_handler, Color = rgb(255, 255, 255), Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, LineJoinMode = Enum.LineJoinMode.Miter,
    })
    local outline = new("Frame", { Parent = box_handler, Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 1, -2), BackgroundTransparency = 1 })
    new("UIStroke", { Parent = outline, Color = rgb(0, 0, 0), Thickness = 1, LineJoinMode = Enum.LineJoinMode.Miter })

    -- corners
    local corners = new("Frame", { Parent = ov, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false })
    local function makeCorner(ax, ay, w, h, px, py)
        local f = new("Frame", {
            Parent = corners, AnchorPoint = Vector2.new(ax, ay),
            Position = UDim2.new(px, 0, py, 0), Size = UDim2.new(w, 0, h, 0),
            BackgroundColor3 = rgb(0, 0, 0),
        })
        local inner = new("Frame", { Parent = f, Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 1, -2), BackgroundColor3 = rgb(255, 255, 255) })
        return inner
    end
    local c1 = makeCorner(0, 0, 0.4, 0, 0, 0) ; c1.Parent.Size = UDim2.new(0.4, 0, 0, 3)
    local c2 = makeCorner(0, 0, 0, 0.25, 0, 0) ; c2.Parent.Size = UDim2.new(0, 3, 0.25, 0)
    local c3 = makeCorner(1, 0, 0.4, 0, 1, 0) ; c3.Parent.Size = UDim2.new(0.4, 0, 0, 3)
    local c4 = makeCorner(1, 0, 0, 0.25, 1, 0) ; c4.Parent.Size = UDim2.new(0, 3, 0.25, 0)
    local c5 = makeCorner(0, 1, 0.4, 0, 0, 1) ; c5.Parent.Size = UDim2.new(0.4, 0, 0, 3)
    local c6 = makeCorner(0, 1, 0, 0.25, 0, 1) ; c6.Parent.Size = UDim2.new(0, 3, 0.25, 0)
    local c7 = makeCorner(1, 1, 0.4, 0, 1, 1) ; c7.Parent.Size = UDim2.new(0.4, 0, 0, 3)
    local c8 = makeCorner(1, 1, 0, 0.25, 1, 1) ; c8.Parent.Size = UDim2.new(0, 3, 0.25, 0)

    -- name
    local nameLbl = new("TextLabel", {
        Parent = ov, Text = string.format("%s (@%s)", lp.DisplayName, lp.Name),
        TextColor3 = themes.preset.text, AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 0, -5), AutomaticSize = Enum_X, Size = UDim2.new(0, 0, 0, 12),
        TextXAlignment = Enum.TextXAlignment.Center, TextStrokeTransparency = 0,
    })
    apply_theme(nameLbl, "text", "TextColor3")

    -- healthbar
    local hpHolder = new("Frame", {
        Parent = ov, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(0, -5, 0, 0),
        Size = UDim2.new(0, 4, 1, 0), BackgroundColor3 = rgb(0, 0, 0),
    })
    local hpBar = new("Frame", {
        Parent = hpHolder, Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 1, -2),
        BackgroundColor3 = rgb(0, 255, 0),
    })

    -- distance + weapon
    local distLbl = new("TextLabel", {
        Parent = ov, Text = "127st", TextColor3 = themes.preset.text,
        Position = UDim2.new(0, 0, 1, 5), Size = UDim2.new(1, 0, 0, 12),
        TextXAlignment = Enum.TextXAlignment.Center, TextStrokeTransparency = 0,
    })
    local wepLbl = new("TextLabel", {
        Parent = ov, Text = "[ Weapon ]", TextColor3 = themes.preset.text,
        Position = UDim2.new(0, 0, 1, 19), Size = UDim2.new(1, 0, 0, 12),
        TextXAlignment = Enum.TextXAlignment.Center, TextStrokeTransparency = 0,
    })

    local function refresh()
        local f = flags
        local function on(k) return ids[k] and f[ids[k]] == true end
        local function col(k, fallback)
            local c = ids[k] and f[ids[k]]
            if type(c) == "table" and c.Color then return c.Color end
            return typeof(c) == "Color3" and c or fallback
        end

        local boxOn = on("box")
        local isCorner = (f[ids.box_type] or "full") == "corner"

        box_handler.Visible = boxOn and not isCorner
        corners.Visible = boxOn and isCorner
        box_stroke.Color = col("box_color", rgb(255, 255, 255))
        for _, c in ipairs({ c1, c2, c3, c4, c5, c6, c7, c8 }) do
            c.BackgroundColor3 = col("box_color", rgb(255, 255, 255))
        end

        nameLbl.Visible = on("name")
        nameLbl.TextColor3 = col("name_color", themes.preset.text)

        hpHolder.Visible = on("health")
        local mult = abs(sin(tick() * 2))
        hpBar.Size = UDim2.new(1, -2, mult, -2)
        hpBar.Position = UDim2.new(0, 1, 1 - mult, 1)
        hpBar.BackgroundColor3 = rgb(255, 0, 0):Lerp(rgb(0, 255, 0), mult)

        distLbl.Visible = on("distance")
        distLbl.TextColor3 = col("distance_color", themes.preset.text)
        wepLbl.Visible = on("weapon")
        wepLbl.TextColor3 = col("weapon_color", themes.preset.text)
    end

    lib:onChange(refresh)
    task.defer(refresh)
    connection(RunService.RenderStepped, function()
        if area.Parent and area.Parent.Parent and area.Parent.Parent.Visible then
            refresh()
        end
    end)

    -- character
    task.spawn(function()
        local char = lp.Character or lp.CharacterAdded:Wait()
        if not char:FindFirstChild("HumanoidRootPart") then char:WaitForChild("HumanoidRootPart", 5) end
        char.Archivable = true
        local ok, clone = pcall(function() return char:Clone() end)
        if not ok or not clone then return end
        for _, d in ipairs(clone:GetDescendants()) do
            if d:IsA("BaseScript") or d:IsA("LocalScript") then d:Destroy() end
        end
        local hrp = clone:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        hrp.Anchored = true
        clone.Parent = vp

        local rot = 0
        connection(RunService.RenderStepped, function(dt)
            if not (lib.root.Visible and area.Parent and sec.body.Parent.Parent.Parent.Visible) then return end
            rot += dt * 0.9
            clone:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(0, rot, 0))
        end)
    end)

    return sec
end

-- config system
function Library:get_config()
    local Config = {}
    for k, v in pairs(flags) do
        if type(v) == "table" and v.key then
            Config[k] = { active = v.active, mode = v.mode, key = tostring(v.key) }
        elseif type(v) == "table" and v.Color then
            Config[k] = { Transparency = v.Transparency, Color = v.Color:ToHex() }
        else
            Config[k] = v
        end
    end
    return HttpService:JSONEncode(Config)
end

function Library:load_config(json)
    local ok, config = pcall(HttpService.JSONDecode, HttpService, json)
    if not ok then return end
    for k, v in pairs(config) do
        local setter = config_flags[k]
        if setter then
            if type(v) == "table" and v.Color then
                setter(hex(v.Color), v.Transparency)
            elseif type(v) == "table" and v.active ~= nil then
                setter(v)
            else
                setter(v)
            end
        end
    end
end

function Library:config_list_update()
    if not self.config_list then return end
    local list = {}
    if listfiles then
        for _, file in ipairs(listfiles(self.directory .. "/configs")) do
            local name = file:match("([^/\\]+)%.cfg$") or file:match("([^/\\]+)$")
            if name then table.insert(list, name) end
        end
    end
    if self.config_list.refresh_options then
        self.config_list.refresh_options(list)
    end
end

-- example usage
local win = Library.new({ name = "midnight", version = "v67", directory = "Midnight", config = "default.cfg" })

local combat = win:category("combat")
local aimbot = combat:tab("aimbot")
local antiaim = combat:tab("anti-aim")

local visuals = win:category("visuals")
local players = visuals:tab("players")
local world = visuals:tab("world")

local other = win:category("other")
local misc = other:tab("misc")
local config = other:tab("config")

-- ESP section
local esp = players:section({ name = "esp", side = "left" })
esp:toggle({ name = "enable", flag = "esp_enable", default = true })
esp:toggle({ name = "box", flag = "esp_box", default = true }):colorpicker({ flag = "esp_box_color", color = rgb(220, 220, 220) })
esp:dropdown({ name = "box type", flag = "esp_box_type", items = { "full", "corner" }, default = "full" })
esp:toggle({ name = "name", flag = "esp_name", default = true }):colorpicker({ flag = "esp_name_color", color = rgb(225, 185, 245) })
esp:toggle({ name = "health", flag = "esp_health", default = true })
esp:toggle({ name = "distance", flag = "esp_distance", default = true }):colorpicker({ flag = "esp_distance_color", color = rgb(200, 200, 200) })
esp:toggle({ name = "weapon", flag = "esp_weapon" }):colorpicker({ flag = "esp_weapon_color", color = rgb(200, 200, 200) })
esp:toggle({ name = "skeleton", flag = "esp_skeleton" }):colorpicker({ flag = "esp_skeleton_color", color = rgb(95, 125, 225) })
esp:slider({ name = "max distance", flag = "esp_max_distance", min = 0, max = 500, default = 300, suffix = " m" })

-- glow / chams
local glow = players:section({ name = "glow", side = "left" })
glow:toggle({ name = "enable", flag = "glow_enable" }):colorpicker({ flag = "glow_color", color = rgb(225, 110, 60) })

local chams = players:section({ name = "chams", side = "right" })
chams:toggle({ name = "enable", flag = "chams_enable" }):colorpicker({ flag = "chams_color", color = rgb(235, 130, 185) })
chams:dropdown({ name = "material", flag = "chams_material", items = { "flat", "glass", "neon", "forcefield" }, default = "glass" })

-- preview
players:preview({
    name = "preview", side = "right",
    flags = {
        box = "esp_box", box_color = "esp_box_color", box_type = "esp_box_type",
        name = "esp_name", name_color = "esp_name_color",
        health = "esp_health",
        distance = "esp_distance", distance_color = "esp_distance_color",
        weapon = "esp_weapon", weapon_color = "esp_weapon_color",
    },
})

-- config tab
local menu = config:section({ name = "menu", side = "left" })
menu:label("menu accent"):colorpicker({
    flag = "menu_accent", color = themes.preset.accent,
    callback = function(c) win:setAccent(c) end,
})
menu:label("ui keybind"):keybind({
    flag = "ui_keybind", key = Enum.KeyCode.RightShift,
    callback = function() end,
})
-- update toggle key from flag
win:onChange(function(flag, val)
    if flag == "ui_keybind" and type(val) == "table" and val.key then
        win.toggleKey = val.key
    end
end)

menu:button({ name = "unload", callback = function() win:unload() end })

local configs = config:section({ name = "configs", side = "right" })
local configList = configs:dropdown({ name = "config", flag = "config_list", items = {}, callback = function() end })
win.config_list = configList
configs:textbox({ name = "name", flag = "config_name", placeholder = "config name..." })

local function refreshConfigs()
    win:config_list_update()
end

configs:button({ name = "create", callback = function()
    local name = flags["config_name"] or "default"
    if writefile then
        writefile(win.directory .. "/configs/" .. name .. ".cfg", win:get_config())
        refreshConfigs()
    end
end })
configs:button({ name = "load", callback = function()
    local name = flags["config_list"]
    if name and readfile then
        win:load_config(readfile(win.directory .. "/configs/" .. name .. ".cfg"))
    end
end })
configs:button({ name = "save", callback = function()
    local name = flags["config_list"]
    if name and writefile then
        writefile(win.directory .. "/configs/" .. name .. ".cfg", win:get_config())
    end
end })
configs:button({ name = "delete", callback = function()
    local name = flags["config_list"]
    if name and delfile then
        delfile(win.directory .. "/configs/" .. name .. ".cfg")
        refreshConfigs()
    end
end })
configs:button({ name = "refresh", callback = refreshConfigs })

task.defer(refreshConfigs)

players:open()

return win
