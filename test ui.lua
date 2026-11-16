--[[
    midnight UI
    Recreation of the screenshot layout (sidebar + breadcrumb header + two column pages + preview + watermark)
    Written in the same style/conventions as your libraries (accent hooks, flags, pixel font, nested outline/inline frames).

    This is UI only. Toggles/sliders/dropdowns just write to `win.flags[flag]` and fire callbacks.
    Hook your own logic into the callbacks or read win.flags.

    Works as an executor script (gethui / getcustomasset) and falls back to PlayerGui + a built-in font
    if those functions don't exist (e.g. Studio LocalScript).
]]

-- services
local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService   = game:GetService("RunService")
local HttpService  = game:GetService("HttpService")
local Workspace    = game:GetService("Workspace")

local lp = Players.LocalPlayer

-- shorthands
local rgb   = Color3.fromRGB
local clamp = math.clamp
local floor = math.floor

local Enum_X = Enum.AutomaticSize.X
local Enum_Y = Enum.AutomaticSize.Y
local Enum_XY = Enum.AutomaticSize.XY

-- palette
local C = {
    outline = rgb(0, 0, 0),
    inline  = rgb(40, 40, 40),
    body    = rgb(14, 14, 14),
    text    = rgb(205, 205, 205),
    dim     = rgb(112, 112, 112),
    accent  = rgb(204, 112, 148),
}

-- parent / font helpers
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

-- instance helpers
local function new(class, props)
    local o = Instance.new(class)
    if o:IsA("GuiObject") then o.BorderSizePixel = 0 end
    if class == "TextLabel" or class == "TextButton" or class == "TextBox" then
        o.FontFace = FONT
        o.TextSize = 12
        o.TextColor3 = C.text
        o.BackgroundTransparency = 1
        o.TextXAlignment = Enum.TextXAlignment.Left
        o.Text = ""
    end
    if class == "TextButton" then o.AutoButtonColor = false end
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
        Position = pos or UDim2.new(), Size = size or UDim2.new(1, 0, 1, 0),
        TextXAlignment = xa or Enum.TextXAlignment.Left,
    })
end

local function stroke(parent, color)
    return new("UIStroke", {
        Parent = parent, Color = color or C.inline,
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

-- black outline > grey inline > dark body (returns body, outer)
local function framed(parent, size, pos)
    local o = new("Frame", { Parent = parent, Size = size, Position = pos or UDim2.new(), BackgroundColor3 = C.outline })
    local i = new("Frame", { Parent = o, Size = UDim2.new(1, -2, 1, -2), Position = UDim2.fromOffset(1, 1), BackgroundColor3 = C.inline })
    local b = new("Frame", { Parent = i, Size = UDim2.new(1, -2, 1, -2), Position = UDim2.fromOffset(1, 1), BackgroundColor3 = C.body })
    return b, o
end

local function accentLine(parent)
    local line = new("Frame", { Parent = parent, Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = C.accent, ZIndex = 2 })
    new("UIGradient", { Parent = line, Rotation = 90, Color = ColorSequence.new(rgb(255, 255, 255), rgb(150, 150, 150)) })
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

-- classes
local Library  = {}; Library.__index  = Library
local Category = {}; Category.__index = Category
local Tab      = {}; Tab.__index      = Tab
local Section  = {}; Section.__index  = Section
local Element  = {}; Element.__index  = Element

local function nxt(lib) lib.order += 1 return lib.order end

----------------------------------------------------------------------
-- window
----------------------------------------------------------------------
function Library.new(opts)
    opts = opts or {}
    local self = setmetatable({}, Library)

    self.name = opts.name or "midnight"
    self.version = opts.version or "v1"
    self.accent = opts.accent or C.accent
    self.toggleKey = opts.toggleKey or Enum.KeyCode.RightShift
    self.flags, self.setters, self.listeners = {}, {}, {}
    self.connections, self.accentHooks = {}, {}
    self.order = 0
    self.popup = nil
    self.currentTab = nil

    self.gui = new("ScreenGui", {
        Name = HttpService:GenerateGUID(false), IgnoreGuiInset = true, ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 1000, Parent = getParent(),
    })

    local vp = Workspace.CurrentCamera.ViewportSize
    self.root = new("Frame", {
        Parent = self.gui, BackgroundTransparency = 1, Size = UDim2.fromOffset(630, 440),
        Position = UDim2.fromOffset(floor(vp.X / 2 - 315), floor(vp.Y / 2 - 220)),
    })

    ------------------------------------------------------------ sidebar
    local side = framed(self.root, UDim2.fromOffset(148, 440))
    self:accentOn(accentLine(side), "BackgroundColor3")

    local sideHeader = new("Frame", { Parent = side, Position = UDim2.fromOffset(0, 2), Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1 })
    local iconOuter = new("Frame", { Parent = sideHeader, Position = UDim2.fromOffset(10, 15), Size = UDim2.fromOffset(10, 10), BackgroundColor3 = rgb(22, 22, 22) })
    stroke(iconOuter, rgb(70, 70, 70))
    local iconInner = new("Frame", { Parent = sideHeader, Position = UDim2.fromOffset(14, 19), Size = UDim2.fromOffset(7, 7), BackgroundColor3 = C.accent })
    self:accentOn(iconInner, "BackgroundColor3")
    label(sideHeader, self.name, rgb(240, 240, 240), UDim2.fromOffset(34, 11), UDim2.new(1, -34, 0, 12))
    label(sideHeader, self.version, rgb(85, 85, 85), UDim2.fromOffset(34, 23), UDim2.new(1, -34, 0, 12))
    new("Frame", { Parent = side, Position = UDim2.fromOffset(0, 44), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = rgb(30, 30, 30) })

    self.sideList = new("Frame", { Parent = side, Position = UDim2.fromOffset(0, 50), Size = UDim2.new(1, 0, 1, -100), BackgroundTransparency = 1 })
    new("UIListLayout", { Parent = self.sideList, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder })

    local footer = new("Frame", { Parent = side, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 44), BackgroundTransparency = 1 })
    new("Frame", { Parent = footer, Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = rgb(30, 30, 30) })
    local avatar = new("Frame", { Parent = footer, Position = UDim2.fromOffset(10, 10), Size = UDim2.fromOffset(24, 24), BackgroundColor3 = rgb(10, 10, 10) })
    stroke(avatar, rgb(48, 48, 48))
    new("TextLabel", {
        Parent = avatar, Size = UDim2.new(1, 0, 1, 0), Text = lp.Name:sub(1, 1):upper(),
        TextXAlignment = Enum.TextXAlignment.Center, TextColor3 = rgb(240, 240, 240),
    })
    label(footer, lp.Name, rgb(215, 215, 215), UDim2.fromOffset(42, 10), UDim2.new(1, -46, 0, 12)).TextTruncate = Enum.TextTruncate.AtEnd
    label(footer, "uid " .. tostring(lp.UserId), rgb(85, 85, 85), UDim2.fromOffset(42, 22), UDim2.new(1, -46, 0, 12)).TextTruncate = Enum.TextTruncate.AtEnd

    ------------------------------------------------------------ content
    local content = framed(self.root, UDim2.fromOffset(474, 440), UDim2.fromOffset(156, 0))
    self:accentOn(accentLine(content), "BackgroundColor3")

    local header = new("Frame", { Parent = content, Position = UDim2.fromOffset(0, 2), Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1 })
    local crumbs = new("Frame", { Parent = header, Position = UDim2.fromOffset(8, 0), Size = UDim2.new(0.7, 0, 1, 0), BackgroundTransparency = 1 })
    new("UIListLayout", {
        Parent = crumbs, FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 4),
    })
    self.crumbCat = label(crumbs, "", rgb(85, 85, 85), nil, UDim2.new(0, 0, 1, 0)); self.crumbCat.AutomaticSize = Enum_X
    self.crumbTab = label(crumbs, "", rgb(240, 240, 240), nil, UDim2.new(0, 0, 1, 0)); self.crumbTab.AutomaticSize = Enum_X
    local cfgName = label(header, opts.config or "default.cfg", rgb(70, 70, 70), UDim2.new(1, -8, 0, 0), UDim2.new(0, 0, 1, 0))
    cfgName.AnchorPoint = Vector2.new(1, 0); cfgName.AutomaticSize = Enum_X
    new("Frame", { Parent = content, Position = UDim2.fromOffset(0, 31), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = rgb(30, 30, 30) })

    self.pageHolder = new("Frame", { Parent = content, Position = UDim2.fromOffset(0, 32), Size = UDim2.new(1, 0, 1, -32), BackgroundTransparency = 1 })

    self:drag(sideHeader, self.root)
    self:drag(header, self.root)

    ------------------------------------------------------------ watermark
    self:watermark()

    ------------------------------------------------------------ input
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
            target.Position = UDim2.fromOffset(startPos.X.Offset + d.X, startPos.Y.Offset + d.Y)
        end
    end)
end

-- accent theming
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

-- flags
function Library:setFlag(flag, value)
    self.flags[flag] = value
    for _, fn in ipairs(self.listeners) do pcall(fn, flag, value) end
end

function Library:onChange(fn)
    table.insert(self.listeners, fn)
end

-- popups (dropdown lists, colorpickers)
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

-- watermark (top right)
function Library:watermark()
    local outer = new("Frame", {
        Parent = self.gui, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 8),
        Size = UDim2.new(0, 0, 0, 20), AutomaticSize = Enum_X, BackgroundColor3 = C.outline,
    })
    new("UIPadding", { Parent = outer, PaddingTop = UDim.new(0, 1), PaddingBottom = UDim.new(0, 1), PaddingLeft = UDim.new(0, 1), PaddingRight = UDim.new(0, 1) })
    local inner = new("Frame", { Parent = outer, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum_X, BackgroundColor3 = C.inline })
    new("UIPadding", { Parent = inner, PaddingTop = UDim.new(0, 1), PaddingBottom = UDim.new(0, 1), PaddingLeft = UDim.new(0, 1), PaddingRight = UDim.new(0, 1) })
    local body = new("Frame", { Parent = inner, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum_X, BackgroundColor3 = C.body })
    local line = new("Frame", { Parent = body, Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = C.accent, ZIndex = 2 })
    self:accentOn(line, "BackgroundColor3")

    local text = new("TextLabel", {
        Parent = body, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum_X, RichText = true,
        TextYAlignment = Enum.TextYAlignment.Center,
    })
    new("UIPadding", { Parent = text, PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) })

    local fps, frames, acc = 60, 0, 0
    self:connect(RunService.RenderStepped, function(dt)
        frames += 1
        acc += dt
        if acc >= 0.5 then
            fps = floor(frames / acc + 0.5)
            frames, acc = 0, 0
            local c = self.accent
            text.Text = string.format(
                '<font color="rgb(%d,%d,%d)">%s</font> | %s | %d fps | %s',
                floor(c.R * 255), floor(c.G * 255), floor(c.B * 255),
                self.name, lp.Name, fps, os.date("%H:%M")
            )
        end
    end)
end

----------------------------------------------------------------------
-- categories + tabs
----------------------------------------------------------------------
function Library:category(name)
    local cat = setmetatable({ lib = self, name = name }, Category)

    local row = new("Frame", { Parent = self.sideList, Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, LayoutOrder = nxt(self) })
    new("UIListLayout", {
        Parent = row, FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    new("UIPadding", { Parent = row, PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 10) })
    local t = label(row, name, rgb(95, 95, 95), nil, UDim2.new(0, 0, 1, 0)); t.AutomaticSize = Enum_X
    local line = new("Frame", { Parent = row, Size = UDim2.new(0, 10, 0, 1), BackgroundColor3 = rgb(36, 36, 36) })
    new("UIFlexItem", { Parent = line, FlexMode = Enum.UIFlexMode.Fill })

    return cat
end

function Category:tab(name)
    local lib = self.lib
    local tab = setmetatable({ lib = lib, name = name, category = self }, Tab)

    tab.button = new("TextButton", {
        Parent = lib.sideList, Size = UDim2.new(1, 0, 0, 20), LayoutOrder = nxt(lib),
        BackgroundColor3 = rgb(24, 24, 24), BackgroundTransparency = 1,
    })
    tab.bar = new("Frame", { Parent = tab.button, Size = UDim2.new(0, 2, 1, 0), BackgroundColor3 = C.accent, Visible = false })
    lib:accentOn(tab.bar, "BackgroundColor3")
    tab.bullet = new("Frame", { Parent = tab.button, Position = UDim2.fromOffset(11, 9), Size = UDim2.fromOffset(3, 3), BackgroundColor3 = rgb(70, 70, 70) })
    tab.text = label(tab.button, name, rgb(160, 160, 160), UDim2.fromOffset(22, 0), UDim2.new(1, -22, 1, 0))

    -- page + two fixed columns
    tab.page = new("Frame", { Parent = lib.pageHolder, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false })
    new("UIPadding", { Parent = tab.page, PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })
    new("UIListLayout", { Parent = tab.page, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })
    for i, side in ipairs({ "left", "right" }) do
        local col = new("Frame", { Parent = tab.page, Size = UDim2.new(0.5, -4, 1, 0), BackgroundTransparency = 1, LayoutOrder = i })
        new("UIListLayout", { Parent = col, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })
        tab[side] = col
    end

    tab.button.MouseButton1Click:Connect(function() tab:open() end)
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
    lib.crumbCat.Text = self.category.name .. " /"
    lib.crumbTab.Text = self.name
end

----------------------------------------------------------------------
-- section
----------------------------------------------------------------------
function Tab:section(o)
    o = o or {}
    local lib = self.lib
    local col = (o.side == "right") and self.right or self.left

    local container = new("Frame", {
        Parent = col, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum_Y,
        BackgroundTransparency = 1, LayoutOrder = nxt(lib),
    })
    new("UIPadding", { Parent = container, PaddingTop = UDim.new(0, 7) })

    local body = new("Frame", { Parent = container, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum_Y, BackgroundColor3 = C.body, ZIndex = 1 })
    stroke(body, C.inline)
    new("UIPadding", { Parent = body, PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })
    new("UIListLayout", { Parent = body, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder })

    local title = label(container, o.name or "section", C.text, UDim2.fromOffset(6, -7), UDim2.new())
    title.AutomaticSize = Enum_XY
    title.BackgroundTransparency = 0
    title.BackgroundColor3 = C.body
    title.ZIndex = 3
    stroke(title, C.inline)
    new("UIPadding", { Parent = title, PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4) })

    return setmetatable({ lib = lib, body = body }, Section)
end

----------------------------------------------------------------------
-- elements
----------------------------------------------------------------------
function Section:label(text)
    local lib = self.lib
    local row = new("Frame", { Parent = self.body, Size = UDim2.new(1, 0, 0, 13), BackgroundTransparency = 1, LayoutOrder = nxt(lib) })
    local lbl = label(row, text, C.text, UDim2.fromOffset(0, 0), UDim2.new(1, -30, 1, 0))
    local e = setmetatable({ lib = lib, right = makeRight(row), lbl = lbl }, Element)
    function e.set(t) lbl.Text = t end
    return e
end

function Section:button(o)
    local lib = self.lib
    local btn = new("TextButton", {
        Parent = self.body, Size = UDim2.new(1, 0, 0, 18), LayoutOrder = nxt(lib),
        BackgroundColor3 = rgb(20, 20, 20), BackgroundTransparency = 0,
        Text = o.name or "button", TextXAlignment = Enum.TextXAlignment.Center,
    })
    stroke(btn, rgb(36, 36, 36))
    btn.MouseButton1Click:Connect(function()
        btn.TextColor3 = lib.accent
        tween(btn, { TextColor3 = C.text }, 0.3)
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

    local row = new("TextButton", { Parent = self.body, Size = UDim2.new(1, 0, 0, 13), LayoutOrder = nxt(lib) })
    local box = new("Frame", { Parent = row, Position = UDim2.fromOffset(0, 3), Size = UDim2.fromOffset(7, 7), BackgroundColor3 = rgb(24, 24, 24) })
    stroke(box, rgb(48, 48, 48))
    local lbl = label(row, cfg.name, C.dim, UDim2.fromOffset(16, 0), UDim2.new(1, -16, 1, 0))
    cfg.right = makeRight(row)

    function cfg.set(v)
        cfg.value = v and true or false
        lib:setFlag(cfg.flag, cfg.value)
        tween(box, { BackgroundColor3 = cfg.value and lib.accent or rgb(24, 24, 24) })
        tween(lbl, { TextColor3 = cfg.value and C.text or C.dim })
        cfg.callback(cfg.value)
    end

    lib:bindAccent(function(c) if cfg.value then box.BackgroundColor3 = c end end)
    row.MouseButton1Click:Connect(function() cfg.set(not cfg.value) end)

    lib.setters[cfg.flag] = cfg.set
    cfg.set(o.default or false)

    return setmetatable(cfg, Element)
end

-- small color swatch + popup picker, attaches to the right side of a toggle/label
function Element:colorpicker(o)
    o = o or {}
    local lib = self.lib
    lib.cpCount = (lib.cpCount or 0) + 1

    local cp = { flag = o.flag or ("color_" .. lib.cpCount), callback = o.callback or function() end, open = false }
    local start = o.color or rgb(255, 255, 255)
    local h, s, v = start:ToHSV()

    local swatch = new("TextButton", { Parent = self.right, Size = UDim2.fromOffset(16, 6), BackgroundColor3 = start, BackgroundTransparency = 0, LayoutOrder = lib.cpCount })
    stroke(swatch, C.outline)
    new("UIGradient", { Parent = swatch, Rotation = 90, Color = ColorSequence.new(rgb(255, 255, 255), rgb(170, 170, 170)) })

    local pop = new("Frame", { Parent = lib.gui, Visible = false, Size = UDim2.fromOffset(144, 116), BackgroundColor3 = C.body, ZIndex = 100 })
    stroke(pop, rgb(60, 60, 60))

    local sv = new("Frame", { Parent = pop, Position = UDim2.fromOffset(8, 8), Size = UDim2.fromOffset(110, 100), BackgroundColor3 = Color3.fromHSV(h, 1, 1), ClipsDescendants = true })
    local white = new("Frame", { Parent = sv, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = rgb(255, 255, 255) })
    new("UIGradient", { Parent = white, Transparency = NumberSequence.new(0, 1) })
    local black = new("Frame", { Parent = sv, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = rgb(0, 0, 0) })
    new("UIGradient", { Parent = black, Rotation = 90, Transparency = NumberSequence.new(1, 0) })
    local svBtn = new("TextButton", { Parent = sv, Size = UDim2.new(1, 0, 1, 0), ZIndex = 3 })
    local svCursor = new("Frame", { Parent = sv, Size = UDim2.fromOffset(5, 5), BackgroundColor3 = rgb(255, 255, 255), ZIndex = 4 })
    stroke(svCursor, C.outline)

    local hue = new("Frame", { Parent = pop, Position = UDim2.fromOffset(126, 8), Size = UDim2.fromOffset(10, 100), BackgroundColor3 = rgb(255, 255, 255) })
    new("UIGradient", {
        Parent = hue, Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, rgb(255, 0, 0)), ColorSequenceKeypoint.new(0.17, rgb(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, rgb(0, 255, 0)), ColorSequenceKeypoint.new(0.5, rgb(0, 255, 255)),
            ColorSequenceKeypoint.new(0.67, rgb(0, 0, 255)), ColorSequenceKeypoint.new(0.83, rgb(255, 0, 255)),
            ColorSequenceKeypoint.new(1, rgb(255, 0, 0)),
        }),
    })
    local hueBtn = new("TextButton", { Parent = hue, Size = UDim2.new(1, 0, 1, 0), ZIndex = 3 })
    local hueCursor = new("Frame", { Parent = hue, Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = rgb(255, 255, 255), ZIndex = 4 })
    stroke(hueCursor, C.outline)

    local function apply()
        local c = Color3.fromHSV(h, s, v)
        swatch.BackgroundColor3 = c
        sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        svCursor.Position = UDim2.new(s, -2, 1 - v, -2)
        hueCursor.Position = UDim2.new(0, 0, h, -1)
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

    local popup = { frame = pop, anchor = swatch }
    function popup.close() pop.Visible = false; cp.open = false end

    swatch.MouseButton1Click:Connect(function()
        cp.open = not cp.open
        if cp.open then
            local p = swatch.AbsolutePosition
            local vp = Workspace.CurrentCamera.ViewportSize
            local x = clamp(p.X + swatch.AbsoluteSize.X - 144, 0, vp.X - 144)
            pop.Position = UDim2.fromOffset(x, p.Y + 10)
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

    local holder = new("Frame", { Parent = self.body, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, LayoutOrder = nxt(lib) })
    local btn = new("TextButton", { Parent = holder, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = rgb(20, 20, 20), BackgroundTransparency = 0 })
    stroke(btn, rgb(36, 36, 36))
    label(btn, cfg.name, rgb(85, 85, 85), UDim2.fromOffset(5, 0), UDim2.new(0.4, 0, 1, 0))
    local valLbl = label(btn, "", C.text, UDim2.new(1, -16, 0, 0), UDim2.new(0.6, -16, 1, 0), Enum.TextXAlignment.Right)
    valLbl.AnchorPoint = Vector2.new(1, 0)
    valLbl.TextTruncate = Enum.TextTruncate.AtEnd

    -- little triangle arrow built from 3 frames
    local arrow = new("Frame", { Parent = btn, Position = UDim2.new(1, -11, 0.5, -1), Size = UDim2.fromOffset(5, 3), BackgroundTransparency = 1 })
    local arrowParts = {
        new("Frame", { Parent = arrow, Size = UDim2.fromOffset(5, 1), BackgroundColor3 = rgb(130, 130, 130) }),
        new("Frame", { Parent = arrow, Position = UDim2.fromOffset(1, 1), Size = UDim2.fromOffset(3, 1), BackgroundColor3 = rgb(130, 130, 130) }),
        new("Frame", { Parent = arrow, Position = UDim2.fromOffset(2, 2), Size = UDim2.fromOffset(1, 1), BackgroundColor3 = rgb(130, 130, 130) }),
    }

    local list = new("Frame", { Parent = lib.gui, Visible = false, Size = UDim2.new(0, 100, 0, 0), AutomaticSize = Enum_Y, BackgroundColor3 = C.body, ZIndex = 100 })
    stroke(list, rgb(60, 60, 60))
    new("UIListLayout", { Parent = list, SortOrder = Enum.SortOrder.LayoutOrder })
    new("UIPadding", { Parent = list, PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 2) })

    for i, item in ipairs(cfg.items) do
        local b = new("TextButton", { Parent = list, Size = UDim2.new(1, 0, 0, 16), Text = item, TextColor3 = C.dim, LayoutOrder = i })
        new("UIPadding", { Parent = b, PaddingLeft = UDim.new(0, 6) })
        cfg.buttons[item] = b
    end

    local function recolor()
        local lookup = {}
        if cfg.multi then
            for _, x in ipairs(cfg.value or {}) do lookup[x] = true end
        else
            lookup[cfg.value] = true
        end
        for item, b in pairs(cfg.buttons) do
            b.TextColor3 = lookup[item] and lib.accent or C.dim
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

    lib:bindAccent(function() if cfg.value ~= nil then recolor() end end)

    local popup = { frame = list, anchor = btn }
    function popup.close()
        list.Visible = false
        cfg.open = false
        for _, p in ipairs(arrowParts) do p.BackgroundColor3 = rgb(130, 130, 130) end
    end

    btn.MouseButton1Click:Connect(function()
        cfg.open = not cfg.open
        if cfg.open then
            local p = btn.AbsolutePosition
            list.Position = UDim2.fromOffset(p.X, p.Y + btn.AbsoluteSize.Y + 2)
            list.Size = UDim2.new(0, btn.AbsoluteSize.X, 0, 0)
            list.Visible = true
            for _, ap in ipairs(arrowParts) do ap.BackgroundColor3 = lib.accent end
            lib:openPopup(popup)
        else
            popup.close()
            lib.popup = nil
        end
    end)

    for item, b in pairs(cfg.buttons) do
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

    local row = new("Frame", { Parent = self.body, Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, LayoutOrder = nxt(lib) })
    label(row, cfg.name, C.text, UDim2.fromOffset(0, 0), UDim2.new(0.5, 0, 0, 12))
    local valLbl = label(row, "", C.text, UDim2.new(1, 0, 0, 0), UDim2.new(0.5, 0, 0, 12), Enum.TextXAlignment.Right)
    valLbl.AnchorPoint = Vector2.new(1, 0)

    local track = new("TextButton", { Parent = row, Position = UDim2.fromOffset(0, 15), Size = UDim2.new(1, 0, 0, 4), BackgroundColor3 = rgb(32, 32, 32), BackgroundTransparency = 0 })
    stroke(track, C.outline)
    local fill = new("Frame", { Parent = track, Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = C.accent })
    lib:accentOn(fill, "BackgroundColor3")
    new("UIGradient", { Parent = fill, Rotation = 90, Color = ColorSequence.new(rgb(255, 255, 255), rgb(150, 150, 150)) })
    local handle = new("Frame", { Parent = track, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(4, 9), BackgroundColor3 = rgb(125, 125, 125), ZIndex = 3 })
    stroke(handle, C.outline)

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
    lib:connect(UIS.InputChanged, function(i)
        if cfg.dragging and i.UserInputType == Enum.UserInputType.MouseMovement then fromMouse() end
    end)
    lib:connect(UIS.InputEnded, function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then cfg.dragging = false end
    end)

    lib.setters[cfg.flag] = cfg.set
    cfg.set(o.default or cfg.min)
    return cfg
end

----------------------------------------------------------------------
-- preview panel (rotating character + esp overlay driven by flags)
----------------------------------------------------------------------
function Tab:preview(o)
    o = o or {}
    local lib = self.lib
    local ids = o.flags or {}
    local sec = self:section({ name = o.name or "preview", side = o.side })

    local area = new("Frame", { Parent = sec.body, Size = UDim2.new(1, 0, 0, 250), BackgroundColor3 = rgb(10, 10, 10), BackgroundTransparency = 0, LayoutOrder = nxt(lib), ClipsDescendants = true })
    stroke(area, rgb(32, 32, 32))

    local vp = new("ViewportFrame", { Parent = area, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Ambient = rgb(190, 190, 190), LightColor = rgb(255, 255, 255) })
    local cam = new("Camera", { FieldOfView = 40 })
    cam.CFrame = CFrame.lookAt(Vector3.new(0, 0.4, 7.5), Vector3.new(0, -0.1, 0))
    cam.Parent = vp
    vp.CurrentCamera = cam

    -- esp overlay
    local ov = new("Frame", { Parent = area, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 6), Size = UDim2.fromOffset(130, 168), BackgroundTransparency = 1 })
    local boxStroke = new("UIStroke", { Parent = ov, Color = rgb(255, 255, 255), Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, LineJoinMode = Enum.LineJoinMode.Miter })
    local nameLbl = label(ov, lp.DisplayName, C.text, UDim2.new(0.5, 0, 0, -3), UDim2.new(0, 0, 0, 12), Enum.TextXAlignment.Center)
    nameLbl.AnchorPoint = Vector2.new(0.5, 1); nameLbl.AutomaticSize = Enum_X
    local hpBar = new("Frame", { Parent = ov, Position = UDim2.new(0, -6, 0.1, 0), Size = UDim2.new(0, 2, 0.9, 0), BackgroundColor3 = rgb(90, 220, 90) })
    local hpText = label(ov, "90", C.text, UDim2.new(0, -9, 0.1, 0), UDim2.new(0, 0, 0, 12), Enum.TextXAlignment.Right)
    hpText.AnchorPoint = Vector2.new(1, 0); hpText.AutomaticSize = Enum_X

    local function refresh()
        local f = lib.flags
        local function on(k) return ids[k] and f[ids[k]] == true end
        local function col(k, fallback)
            local c = ids[k] and f[ids[k]]
            return typeof(c) == "Color3" and c or fallback
        end
        boxStroke.Enabled = on("box")
        boxStroke.Color = col("box_color", rgb(255, 255, 255))
        nameLbl.Visible = on("name")
        nameLbl.TextColor3 = col("name_color", C.text)
        hpBar.Visible = on("health")
        hpText.Visible = on("health")
    end
    lib:onChange(refresh)
    task.defer(refresh)

    -- clone the local character into the viewport
    task.spawn(function()
        local char = lp.Character or lp.CharacterAdded:Wait()
        if not char:FindFirstChild("HumanoidRootPart") then char:WaitForChild("HumanoidRootPart", 5) end
        char.Archivable = true
        local ok, clone = pcall(function() return char:Clone() end)
        if not ok or not clone then return end
        for _, d in ipairs(clone:GetDescendants()) do
            if d:IsA("BaseScript") then d:Destroy() end
        end
        local hrp = clone:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        hrp.Anchored = true
        clone.Parent = vp

        local rot = 0
        lib:connect(RunService.RenderStepped, function(dt)
            if not (lib.root.Visible and area.Parent and sec.body.Parent.Parent.Parent.Visible) then return end
            rot += dt * 0.9
            clone:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(0, rot, 0))
        end)
    end)

    return sec
end

----------------------------------------------------------------------
-- DEMO: the screenshot layout
----------------------------------------------------------------------
local win = Library.new({ name = "midnight", version = "v67", config = "default.cfg" })

local combat = win:category("combat")
local aimbot = combat:tab("aimbot")
local antiaim = combat:tab("anti-aim")

local visuals = win:category("visuals")
local players = visuals:tab("players")
local world = visuals:tab("world")

local other = win:category("other")
local misc = other:tab("misc")
local config = other:tab("config")

-- esp
local esp = players:section({ name = "esp", side = "left" })
esp:toggle({ name = "enable", flag = "esp_enable", default = true })
esp:toggle({ name = "box", flag = "esp_box", default = true }):colorpicker({ flag = "esp_box_color", color = rgb(220, 220, 220) })
esp:dropdown({ name = "box type", flag = "esp_box_type", items = { "full", "corner" }, default = "full" })
esp:toggle({ name = "name", flag = "esp_name", default = true }):colorpicker({ flag = "esp_name_color", color = rgb(225, 185, 245) })
esp:toggle({ name = "health", flag = "esp_health", default = true })
esp:toggle({ name = "weapon", flag = "esp_weapon" })
esp:toggle({ name = "ammo", flag = "esp_ammo" })
esp:toggle({ name = "flags", flag = "esp_flags" })
esp:dropdown({ name = "show", flag = "esp_show", items = { "money", "scoped", "armor", "defusing" }, multi = true, default = { "money", "scoped" } })
esp:toggle({ name = "skeleton", flag = "esp_skeleton" }):colorpicker({ flag = "esp_skeleton_color", color = rgb(95, 125, 225) })
esp:toggle({ name = "snaplines", flag = "esp_snaplines" }):colorpicker({ flag = "esp_snaplines_color", color = rgb(235, 235, 235) })
esp:toggle({ name = "offscreen", flag = "esp_offscreen", default = true }):colorpicker({ flag = "esp_offscreen_color", color = rgb(225, 70, 70) })
esp:toggle({ name = "teammates", flag = "esp_teammates" })
esp:slider({ name = "distance", flag = "esp_distance", min = 0, max = 500, default = 300, suffix = " m" })

-- glow
local glow = players:section({ name = "glow", side = "left" })
glow:toggle({ name = "enable", flag = "glow_enable" }):colorpicker({ flag = "glow_color", color = rgb(225, 110, 60) })
glow:dropdown({ name = "style", flag = "glow_style", items = { "outline", "fill", "pulse" }, default = "outline" })

-- chams
local chams = players:section({ name = "chams", side = "right" })
chams:toggle({ name = "enable", flag = "chams_enable", default = false }):colorpicker({ flag = "chams_color", color = rgb(235, 130, 185) })
chams:dropdown({ name = "material", flag = "chams_material", items = { "flat", "glass", "neon", "forcefield" }, default = "glass" })
chams:toggle({ name = "behind walls", flag = "chams_walls" }):colorpicker({ flag = "chams_walls_color", color = rgb(80, 110, 225) })

-- preview
players:preview({
    name = "preview", side = "right",
    flags = {
        box = "esp_box", box_color = "esp_box_color",
        name = "esp_name", name_color = "esp_name_color",
        health = "esp_health",
    },
})

-- a couple of extras so the other tabs aren't empty
local menu = config:section({ name = "menu", side = "left" })
menu:label("menu accent"):colorpicker({
    flag = "menu_accent", color = C.accent,
    callback = function(c) win:setAccent(c) end,
})
menu:button({ name = "unload", callback = function() win:unload() end })

players:open()

return win
