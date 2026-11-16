local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService  = game:GetService("HttpService")
local Workspace    = game:GetService("Workspace")

local lp    = Players.LocalPlayer
local rgb   = Color3.fromRGB
local clamp = math.clamp
local floor = math.floor

local C = {
    outline = rgb(0, 0, 0), inline = rgb(40, 40, 40), body = rgb(14, 14, 14),
    text = rgb(205, 205, 205), dim = rgb(112, 112, 112), accent = rgb(204, 112, 148),
}

local S = {
    Enabled = true,
    BoxEnabled = true, BoxType = "Corner", Thickness = 1, LineColor = rgb(255, 80, 80),
    Chams = false, ChamsColor = rgb(255, 80, 80), ChamsFillTransparency = 0.3, ChamsGlow = false,
    Names = false, NameColor = rgb(255, 255, 255), NameColor2 = rgb(200, 200, 200),
    Distance = false, DistanceColor = rgb(255, 255, 255), DistanceColor2 = rgb(200, 200, 200),
    HealthBar = false, HealthText = false,
    HealthHigh = rgb(0, 255, 100), HealthMid = rgb(255, 255, 0), HealthLow = rgb(255, 40, 40),
    Skeleton = false, SkeletonThickness = 1, SkeletonColor = rgb(255, 80, 80), SkeletonColor2 = rgb(200, 200, 200),
    Tracers = false, TracerColor = rgb(255, 80, 80), TracerThickness = 1,
    TextSize = 12, FakeDistance = 42, FakeHealth = 0.85, FakeMaxHealth = 100,
}

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

local FONT_URL = "https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/fs-tahoma-8px.ttf"
local function loadFont()
    local ok, font = pcall(function()
        if not (writefile and getcustomasset and isfile) then error("no fs") end
        if not isfile("midnight_font.ttf") then writefile("midnight_font.ttf", game:HttpGet(FONT_URL)) end
        local data = {name = "MidnightPixel", faces = {{name = "Regular", weight = 400, style = "normal", assetId = getcustomasset("midnight_font.ttf")}}}
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
    if class == "TextLabel" or class == "TextButton" then
        o.FontFace = FONT
        o.TextSize = 12
        o.TextColor3 = C.text
        o.BackgroundTransparency = 1
        o.TextXAlignment = Enum.TextXAlignment.Left
        o.Text = ""
    end
    if class == "TextButton" then o.AutoButtonColor = false end
    for k, v in pairs(props) do if k ~= "Parent" then o[k] = v end end
    o.Parent = props.Parent
    return o
end

local function stroke(parent, color)
    return new("UIStroke", {Parent = parent, Color = color or C.inline, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
end

local function label(parent, text, color, pos, size)
    return new("TextLabel", {Parent = parent, Text = text, TextColor3 = color or C.text, Position = pos or UDim2.new(), Size = size or UDim2.new(1, 0, 1, 0)})
end

local function framed(parent, size, pos)
    local o = new("Frame", {Parent = parent, Size = size, Position = pos or UDim2.new(), BackgroundColor3 = C.outline})
    local i = new("Frame", {Parent = o, Size = UDim2.new(1, -2, 1, -2), Position = UDim2.fromOffset(1, 1), BackgroundColor3 = C.inline})
    local b = new("Frame", {Parent = i, Size = UDim2.new(1, -2, 1, -2), Position = UDim2.fromOffset(1, 1), BackgroundColor3 = C.body})
    return b, o
end

local gui = new("ScreenGui", {
    Name = "ESPPreviewUI", IgnoreGuiInset = true, ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 1000, Parent = getParent(),
})

local vp = Workspace.CurrentCamera.ViewportSize
local W, H = 900, 500
local root = new("Frame", {
    Parent = gui, BackgroundTransparency = 1, Size = UDim2.fromOffset(W, H),
    Position = UDim2.fromOffset(floor(vp.X / 2 - W / 2), floor(vp.Y / 2 - H / 2)),
})

local side = framed(root, UDim2.fromOffset(148, H))
new("Frame", {Parent = side, Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = C.accent, ZIndex = 2})
local sideHeader = new("Frame", {Parent = side, Position = UDim2.fromOffset(0, 2), Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1})
new("Frame", {Parent = sideHeader, Position = UDim2.fromOffset(10, 15), Size = UDim2.fromOffset(10, 10), BackgroundColor3 = rgb(22, 22, 22)})
new("Frame", {Parent = sideHeader, Position = UDim2.fromOffset(14, 19), Size = UDim2.fromOffset(7, 7), BackgroundColor3 = C.accent})
label(sideHeader, "esp", rgb(240, 240, 240), UDim2.fromOffset(34, 11), UDim2.new(1, -34, 0, 12))
label(sideHeader, "preview", rgb(85, 85, 85), UDim2.fromOffset(34, 23), UDim2.new(1, -34, 0, 12))
new("Frame", {Parent = side, Position = UDim2.fromOffset(0, 44), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = rgb(30, 30, 30)})
local sideList = new("Frame", {Parent = side, Position = UDim2.fromOffset(0, 50), Size = UDim2.new(1, 0, 1, -50), BackgroundTransparency = 1})
new("UIListLayout", {Parent = sideList, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder})

local content = framed(root, UDim2.fromOffset(380, H), UDim2.fromOffset(156, 0))
new("Frame", {Parent = content, Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = C.accent, ZIndex = 2})
local header = new("Frame", {Parent = content, Position = UDim2.fromOffset(0, 2), Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1})
local crumb = label(header, "", rgb(240, 240, 240), UDim2.fromOffset(8, 0), UDim2.new(1, -16, 1, 0))
new("Frame", {Parent = content, Position = UDim2.fromOffset(0, 31), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = rgb(30, 30, 30)})
local pageHolder = new("Frame", {Parent = content, Position = UDim2.fromOffset(0, 32), Size = UDim2.new(1, 0, 1, -32), BackgroundTransparency = 1})

local previewPane = framed(root, UDim2.fromOffset(356, H), UDim2.fromOffset(544, 0))
new("Frame", {Parent = previewPane, Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = C.accent, ZIndex = 2})
local previewHeader = new("Frame", {Parent = previewPane, Position = UDim2.fromOffset(0, 2), Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1})
label(previewHeader, "live preview", rgb(240, 240, 240), UDim2.fromOffset(8, 0), UDim2.new(1, -16, 1, 0))
new("Frame", {Parent = previewPane, Position = UDim2.fromOffset(0, 31), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = rgb(30, 30, 30)})
local previewHolder = new("Frame", {Parent = previewPane, Position = UDim2.fromOffset(0, 32), Size = UDim2.new(1, 0, 1, -32), BackgroundTransparency = 1})
new("UIPadding", {Parent = previewHolder, PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)})

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
makeDraggable(previewHeader, root)

local previewState = {update = nil}

local function buildPreview(parent)
    local frame = new("Frame", {Parent = parent, Size = UDim2.new(1, 1, 1, -16), BackgroundColor3 = rgb(10, 10, 10)})
    stroke(frame, C.inline)

    local viewport = new("ViewportFrame", {
        Parent = frame, Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = rgb(18, 20, 26), BackgroundTransparency = 0,
        Ambient = rgb(170, 170, 170), LightColor = rgb(255, 255, 255),
    })

    local cam = Instance.new("Camera")
    cam.Parent = viewport
    viewport.CurrentCamera = cam
    cam.FieldOfView = 40
    cam.CFrame = CFrame.lookAt(Vector3.new(5, 3.2, 10), Vector3.new(0, 1.8, 0))

    local world = Instance.new("WorldModel")
    world.Parent = viewport

    local ground = Instance.new("Part")
    ground.Size = Vector3.new(20, 0.2, 20)
    ground.Anchored = true; ground.CanCollide = false
    ground.Color = rgb(24, 24, 30); ground.Material = Enum.Material.SmoothPlastic
    ground.Position = Vector3.new(0, -0.1, 0)
    ground.Parent = world

    local rig = Instance.new("Model")
    rig.Parent = world

    local skin, shirt, pants = rgb(220, 190, 140), rgb(40, 90, 180), rgb(40, 70, 40)
    local parts, baseCfs = {}, {}
    local function mk(name, size, color, pos)
        local p = Instance.new("Part")
        p.Name = name; p.Size = size; p.Color = color
        p.CFrame = CFrame.new(pos)
        p.Anchored = true; p.CanCollide = false
        p.Material = Enum.Material.SmoothPlastic
        p.Parent = rig
        parts[name] = p
        baseCfs[name] = p.CFrame
        return p
    end
    mk("Head",       Vector3.new(1.5, 1.5, 1.5), skin,  Vector3.new(0, 4.5, 0))
    mk("Torso",      Vector3.new(2.0, 2.0, 1.0), shirt, Vector3.new(0, 2.75, 0))
    mk("Left Arm",   Vector3.new(1.0, 2.0, 1.0), skin,  Vector3.new(-1.5, 2.75, 0))
    mk("Right Arm",  Vector3.new(1.0, 2.0, 1.0), skin,  Vector3.new(1.5, 2.75, 0))
    mk("Left Leg",   Vector3.new(1.0, 2.0, 1.0), pants, Vector3.new(-0.5, 0.75, 0))
    mk("Right Leg",  Vector3.new(1.0, 2.0, 1.0), pants, Vector3.new(0.5, 0.75, 0))

    local chams = {}
    for name, orig in pairs(parts) do
        local c = Instance.new("Part")
        c.Size = orig.Size * 1.04
        c.CFrame = orig.CFrame
        c.Anchored = true; c.CanCollide = false
        c.Material = Enum.Material.ForceField
        c.Color = S.ChamsColor; c.Transparency = 1
        c.Parent = world
        chams[name] = c
    end

    local overlay = new("Frame", {Parent = frame, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 5})

    local function makeLine()
        local fr = new("Frame", {Parent = overlay, BackgroundColor3 = rgb(255, 255, 255), AnchorPoint = Vector2.new(0.5, 0.5), Visible = false, ZIndex = 2})
        stroke(fr, rgb(0, 0, 0))
        local grad = new("UIGradient", {Parent = fr})
        return {Frame = fr, Gradient = grad}
    end
    local function setLine(l, a, b, color, thickness)
        if not a or not b then l.Frame.Visible = false return end
        local d = (b - a).Magnitude
        if d < 0.5 then l.Frame.Visible = false return end
        local c = a:Lerp(b, 0.5)
        local ang = math.deg(math.atan2(b.Y - a.Y, b.X - a.X))
        l.Frame.Position = UDim2.fromOffset(c.X, c.Y)
        l.Frame.Size = UDim2.fromOffset(d, thickness)
        l.Frame.Rotation = ang
        l.Frame.BackgroundColor3 = color
        l.Frame.Visible = true
    end

    local function makeText()
        local lbl = new("TextLabel", {
            Parent = overlay, BackgroundTransparency = 1, TextSize = 12, TextColor3 = rgb(255, 255, 255),
            TextStrokeTransparency = 0, TextStrokeColor3 = rgb(0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.fromOffset(0, 0), Visible = false, ZIndex = 6,
        })
        new("UIGradient", {Parent = lbl, Name = "TextGradient"})
        return lbl
    end

    local fullLines, cornerLines, box3d, skBones = {}, {}, {}, {}
    for i = 1, 4  do fullLines[i]   = makeLine() end
    for i = 1, 8  do cornerLines[i] = makeLine() end
    for i = 1, 12 do box3d[i]       = makeLine() end
    for i = 1, 5  do skBones[i]     = makeLine() end
    local tracer = makeLine()
    local nameText, distText, healthText = makeText(), makeText(), makeText()

    local healthBar = new("Frame", {Parent = overlay, BackgroundColor3 = rgb(15, 15, 15), Visible = false, ZIndex = 3})
    stroke(healthBar, rgb(0, 0, 0))
    local healthFill = new("Frame", {Parent = healthBar, BackgroundColor3 = rgb(0, 255, 100), AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.fromScale(1, 1), Visible = false, ZIndex = 4})

    local function project(worldPos, vsize)
        local rel = cam.CFrame:PointToObjectSpace(worldPos)
        if rel.Z >= -0.01 then return nil end
        local tanY = math.tan(math.rad(cam.FieldOfView) / 2)
        local tanX = tanY * (vsize.X / vsize.Y)
        local sx = (rel.X / (-rel.Z * tanX)) * 0.5 + 0.5
        local sy = 0.5 - (rel.Y / (-rel.Z * tanY)) * 0.5
        return Vector2.new(sx * vsize.X, sy * vsize.Y)
    end

    local update = function()
        local vs = overlay.AbsoluteSize
        if vs.X < 20 or vs.Y < 20 then return end

        local t = tick()
        local pivot = Vector3.new(0, 2.5, 0)
        local rot = CFrame.new(pivot) * CFrame.Angles(0, t * 0.6, 0) * CFrame.new(-pivot)
        for name, base in pairs(baseCfs) do
            local cf = rot * base
            parts[name].CFrame = cf
            if chams[name] then chams[name].CFrame = cf end
        end

        if S.Chams then
            for name, ch in pairs(chams) do
                ch.Transparency = 1 - S.ChamsFillTransparency
                ch.Color = S.ChamsColor
                ch.Material = S.ChamsGlow and Enum.Material.Neon or Enum.Material.ForceField
            end
        else
            for _, ch in pairs(chams) do ch.Transparency = 1 end
        end

        local minV = Vector3.new(math.huge, math.huge, math.huge)
        local maxV = Vector3.new(-math.huge, -math.huge, -math.huge)
        for _, p in pairs(parts) do
            local cf, s = p.CFrame, p.Size
            for _, off in ipairs({
                Vector3.new(s.X/2, s.Y/2, s.Z/2), Vector3.new(-s.X/2, s.Y/2, s.Z/2),
                Vector3.new(-s.X/2, -s.Y/2, s.Z/2), Vector3.new(s.X/2, -s.Y/2, s.Z/2),
                Vector3.new(s.X/2, s.Y/2, -s.Z/2), Vector3.new(-s.X/2, s.Y/2, -s.Z/2),
                Vector3.new(-s.X/2, -s.Y/2, -s.Z/2), Vector3.new(s.X/2, -s.Y/2, -s.Z/2),
            }) do
                local w = (cf * CFrame.new(off)).Position
                minV = Vector3.new(math.min(minV.X, w.X), math.min(minV.Y, w.Y), math.min(minV.Z, w.Z))
                maxV = Vector3.new(math.max(maxV.X, w.X), math.max(maxV.Y, w.Y), math.max(maxV.Z, w.Z))
            end
        end

        local corners = {
            Vector3.new(minV.X, minV.Y, minV.Z), Vector3.new(maxV.X, minV.Y, minV.Z),
            Vector3.new(maxV.X, maxV.Y, minV.Z), Vector3.new(minV.X, maxV.Y, minV.Z),
            Vector3.new(minV.X, minV.Y, maxV.Z), Vector3.new(maxV.X, minV.Y, maxV.Z),
            Vector3.new(maxV.X, maxV.Y, maxV.Z), Vector3.new(minV.X, maxV.Y, maxV.Z),
        }
        local projC, vis = {}, {}
        local minX, minY = math.huge, math.huge
        local maxX, maxY = -math.huge, -math.huge
        local vc = 0
        for i = 1, 8 do
            local p = project(corners[i], vs)
            if p then
                projC[i], vis[i] = p, true
                vc = vc + 1
                minX, minY = math.min(minX, p.X), math.min(minY, p.Y)
                maxX, maxY = math.max(maxX, p.X), math.max(maxY, p.Y)
            else vis[i] = false end
        end

        local drawBox = S.Enabled and S.BoxEnabled and vc > 0
        local x, y, sx, sy = 0, 0, 0, 0
        if drawBox then
            local pad = 4
            x, y = floor(minX - pad + 0.5), floor(minY - pad + 0.5)
            sx = math.max(floor(maxX - minX + pad * 2 + 0.5), 8)
            sy = math.max(floor(maxY - minY + pad * 2 + 0.5), 8)
        end

        if drawBox then
            if S.BoxType == "Full" then
                for _, l in ipairs(cornerLines) do l.Frame.Visible = false end
                for _, l in ipairs(box3d)       do l.Frame.Visible = false end
                setLine(fullLines[1], Vector2.new(x, y),         Vector2.new(x + sx, y),         S.LineColor, S.Thickness)
                setLine(fullLines[2], Vector2.new(x, y + sy),    Vector2.new(x + sx, y + sy),    S.LineColor, S.Thickness)
                setLine(fullLines[3], Vector2.new(x, y),         Vector2.new(x, y + sy),         S.LineColor, S.Thickness)
                setLine(fullLines[4], Vector2.new(x + sx, y),    Vector2.new(x + sx, y + sy),    S.LineColor, S.Thickness)
            elseif S.BoxType == "3D" then
                for _, l in ipairs(fullLines)   do l.Frame.Visible = false end
                for _, l in ipairs(cornerLines) do l.Frame.Visible = false end
                local edges = {{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}}
                for i, e in ipairs(edges) do
                    if vis[e[1]] and vis[e[2]] then
                        setLine(box3d[i], projC[e[1]], projC[e[2]], S.LineColor, S.Thickness)
                    else box3d[i].Frame.Visible = false end
                end
            else
                for _, l in ipairs(fullLines) do l.Frame.Visible = false end
                for _, l in ipairs(box3d)     do l.Frame.Visible = false end
                local len = 0.25
                local cw = clamp(floor(sx * len + 0.5), 2, floor(sx / 2))
                local ch = clamp(floor(sy * len + 0.5), 2, floor(sy / 2))
                setLine(cornerLines[1], Vector2.new(x, y),         Vector2.new(x + cw + 1, y),      S.LineColor, S.Thickness)
                setLine(cornerLines[2], Vector2.new(x, y),         Vector2.new(x, y + ch + 1),      S.LineColor, S.Thickness)
                setLine(cornerLines[3], Vector2.new(x + sx, y),    Vector2.new(x + sx - cw - 1, y), S.LineColor, S.Thickness)
                setLine(cornerLines[4], Vector2.new(x + sx, y),    Vector2.new(x + sx, y + ch + 1), S.LineColor, S.Thickness)
                setLine(cornerLines[5], Vector2.new(x, y + sy),    Vector2.new(x + cw + 1, y + sy), S.LineColor, S.Thickness)
                setLine(cornerLines[6], Vector2.new(x, y + sy),    Vector2.new(x, y + sy - ch - 1), S.LineColor, S.Thickness)
                setLine(cornerLines[7], Vector2.new(x + sx, y + sy), Vector2.new(x + sx - cw - 1, y + sy), S.LineColor, S.Thickness)
                setLine(cornerLines[8], Vector2.new(x + sx, y + sy), Vector2.new(x + sx, y + sy - ch - 1), S.LineColor, S.Thickness)
            end
        else
            for _, l in ipairs(fullLines)   do l.Frame.Visible = false end
            for _, l in ipairs(cornerLines) do l.Frame.Visible = false end
            for _, l in ipairs(box3d)       do l.Frame.Visible = false end
        end

        if S.Enabled and S.Skeleton then
            local pairs_ = {
                {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
                {"Torso", "Left Leg"}, {"Torso", "Right Leg"},
            }
            for i, pr in ipairs(pairs_) do
                local pa, pb = project(parts[pr[1]].Position, vs), project(parts[pr[2]].Position, vs)
                if pa and pb then
                    local l = skBones[i]
                    setLine(l, pa, pb, S.SkeletonColor, S.SkeletonThickness)
                    l.Frame.BackgroundColor3 = Color3.new(1, 1, 1)
                    l.Gradient.Color = ColorSequence.new(S.SkeletonColor, S.SkeletonColor2)
                    l.Gradient.Rotation = 0
                else skBones[i].Frame.Visible = false end
            end
        else for _, l in ipairs(skBones) do l.Frame.Visible = false end end

        if S.Names and drawBox then
            nameText.Text = "Player"
            nameText.Position = UDim2.fromOffset(x + sx * 0.5, y - 4)
            nameText.AnchorPoint = Vector2.new(0.5, 1)
            nameText.TextXAlignment = Enum.TextXAlignment.Center
            nameText.TextYAlignment = Enum.TextYAlignment.Bottom
            nameText.TextSize = S.TextSize
            nameText.TextColor3 = S.NameColor
            local g = nameText:FindFirstChild("TextGradient")
            if g then g.Color = ColorSequence.new(S.NameColor, S.NameColor2) end
            nameText.Visible = true
        else nameText.Visible = false end

        if S.Distance and drawBox then
            distText.Text = "[" .. S.FakeDistance .. "m]"
            distText.Position = UDim2.fromOffset(x + sx + 4, y - 1)
            distText.AnchorPoint = Vector2.new(0, 0)
            distText.TextXAlignment = Enum.TextXAlignment.Left
            distText.TextYAlignment = Enum.TextYAlignment.Top
            distText.TextSize = S.TextSize
            distText.TextColor3 = S.DistanceColor
            local g = distText:FindFirstChild("TextGradient")
            if g then g.Color = ColorSequence.new(S.DistanceColor, S.DistanceColor2) end
            distText.Visible = true
        else distText.Visible = false end

        if S.HealthBar and drawBox then
            healthBar.Position = UDim2.fromOffset(x - 5, y)
            healthBar.Size = UDim2.fromOffset(2, sy)
            healthBar.Visible = true
            healthFill.Size = UDim2.fromScale(1, S.FakeHealth)
            healthFill.Visible = true
            local t2 = S.FakeHealth
            local col = t2 >= 0.5 and S.HealthMid:Lerp(S.HealthHigh, (t2 - 0.5) * 2)
                                 or S.HealthLow:Lerp(S.HealthMid, t2 * 2)
            healthFill.BackgroundColor3 = col
            if S.HealthText then
                healthText.Text = tostring(floor(S.FakeHealth * S.FakeMaxHealth + 0.5))
                healthText.Position = UDim2.fromOffset(x - 8, y + sy - sy * S.FakeHealth)
                healthText.AnchorPoint = Vector2.new(1, 0)
                healthText.TextXAlignment = Enum.TextXAlignment.Right
                healthText.TextYAlignment = Enum.TextYAlignment.Top
                healthText.TextSize = S.TextSize
                healthText.TextColor3 = col
                healthText.Visible = true
            else healthText.Visible = false end
        else
            healthBar.Visible = false
            healthText.Visible = false
        end

        if S.Tracers and drawBox then
            setLine(tracer, Vector2.new(vs.X * 0.5, vs.Y), Vector2.new(x + sx * 0.5, y + sy), S.TracerColor, S.TracerThickness)
        else tracer.Frame.Visible = false end
    end

    previewState.update = update
end

buildPreview(previewHolder)

local function makeToggle(parent, name, flag)
    local row = new("TextButton", {Parent = parent, Size = UDim2.new(1, 0, 0, 22), BackgroundColor3 = rgb(20, 20, 20)})
    stroke(row, rgb(36, 36, 36))
    local box = new("Frame", {Parent = row, Size = UDim2.fromOffset(10, 10), Position = UDim2.fromOffset(6, 6), BackgroundColor3 = S[flag] and C.accent or rgb(28, 28, 28)})
    stroke(box, rgb(48, 48, 48))
    label(row, name, C.text, UDim2.fromOffset(24, 0), UDim2.new(1, -24, 1, 0))
    row.MouseButton1Click:Connect(function()
        S[flag] = not S[flag]
        box.BackgroundColor3 = S[flag] and C.accent or rgb(28, 28, 28)
    end)
    return row
end

local function makeCycle(parent, name, flag, values)
    local row = new("TextButton", {Parent = parent, Size = UDim2.new(1, 0, 0, 22), BackgroundColor3 = rgb(20, 20, 20)})
    stroke(row, rgb(36, 36, 36))
    label(row, name, C.dim, UDim2.fromOffset(6, 0), UDim2.new(0.5, 0, 1, 0))
    local val = label(row, tostring(S[flag]), C.text, UDim2.new(0.5, 0, 0, 0), UDim2.new(0.5, -6, 1, 0))
    val.TextXAlignment = Enum.TextXAlignment.Right
    row.MouseButton1Click:Connect(function()
        local idx = 1
        for i, v in ipairs(values) do if v == S[flag] then idx = i break end end
        idx = (idx % #values) + 1
        S[flag] = values[idx]
        val.Text = tostring(S[flag])
    end)
    return row
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

local tabs, currentTab = {}, nil
local function addTab(name, builder)
    local btn = new("TextButton", {Parent = sideList, Size = UDim2.new(1, 0, 0, 22), BackgroundColor3 = rgb(24, 24, 24), BackgroundTransparency = 1})
    local bar = new("Frame", {Parent = btn, Size = UDim2.new(0, 2, 1, 0), BackgroundColor3 = C.accent, Visible = false})
    local bullet = new("Frame", {Parent = btn, Position = UDim2.fromOffset(11, 9), Size = UDim2.fromOffset(3, 3), BackgroundColor3 = rgb(70, 70, 70)})
    local txt = label(btn, name, rgb(160, 160, 160), UDim2.fromOffset(22, 0), UDim2.new(1, -22, 1, 0))
    local pg = new("Frame", {Parent = pageHolder, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false})
    new("UIPadding", {Parent = pg, PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)})
    new("UIListLayout", {Parent = pg, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder})
    builder(pg)
    local tab = {btn = btn, bar = bar, bullet = bullet, text = txt, page = pg, name = name}
    tabs[name] = tab
    btn.MouseButton1Click:Connect(function()
        if currentTab then
            currentTab.bar.Visible = false
            currentTab.btn.BackgroundTransparency = 1
            currentTab.text.TextColor3 = rgb(160, 160, 160)
            currentTab.bullet.BackgroundColor3 = rgb(70, 70, 70)
            currentTab.page.Visible = false
        end
        currentTab = tab
        bar.Visible = true
        btn.BackgroundTransparency = 0
        txt.TextColor3 = rgb(245, 245, 245)
        bullet.BackgroundColor3 = C.accent
        pg.Visible = true
        crumb.Text = name
    end)
    return tab
end

addTab("Box", function(pg)
    local s = section(pg, "box settings")
    makeToggle(s, "enabled", "Enabled")
    makeToggle(s, "box", "BoxEnabled")
    makeCycle(s, "box type", "BoxType", {"Corner", "Full", "3D"})
    makeCycle(s, "thickness", "Thickness", {1, 2, 3, 4})
end)
addTab("Chams", function(pg)
    local s = section(pg, "chams")
    makeToggle(s, "chams", "Chams")
    makeToggle(s, "chams glow", "ChamsGlow")
end)
addTab("Skeleton", function(pg)
    local s = section(pg, "skeleton")
    makeToggle(s, "skeleton", "Skeleton")
    makeCycle(s, "thickness", "SkeletonThickness", {1, 2, 3})
end)
addTab("Text", function(pg)
    local s = section(pg, "text")
    makeToggle(s, "names", "Names")
    makeToggle(s, "distance", "Distance")
end)
addTab("Health", function(pg)
    local s = section(pg, "health")
    makeToggle(s, "health bar", "HealthBar")
    makeToggle(s, "health text", "HealthText")
end)
addTab("Tracers", function(pg)
    local s = section(pg, "tracers")
    makeToggle(s, "tracers", "Tracers")
    makeCycle(s, "thickness", "TracerThickness", {1, 2, 3})
end)

tabs["Box"].bar.Visible = true
tabs["Box"].btn.BackgroundTransparency = 0
tabs["Box"].text.TextColor3 = rgb(245, 245, 245)
tabs["Box"].bullet.BackgroundColor3 = C.accent
tabs["Box"].page.Visible = true
currentTab = tabs["Box"]
crumb.Text = "Box"

local wmOuter = new("Frame", {Parent = gui, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 8), Size = UDim2.new(0, 0, 0, 20), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = C.outline})
new("UIPadding", {Parent = wmOuter, PaddingTop = UDim.new(0, 1), PaddingBottom = UDim.new(0, 1), PaddingLeft = UDim.new(0, 1), PaddingRight = UDim.new(0, 1)})
local wmInner = new("Frame", {Parent = wmOuter, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = C.inline})
new("UIPadding", {Parent = wmInner, PaddingTop = UDim.new(0, 1), PaddingBottom = UDim.new(0, 1), PaddingLeft = UDim.new(0, 1), PaddingRight = UDim.new(0, 1)})
local wmBody = new("Frame", {Parent = wmInner, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = C.body})
new("Frame", {Parent = wmBody, Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = C.accent, ZIndex = 2})
local wmText = new("TextLabel", {Parent = wmBody, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, RichText = true, TextYAlignment = Enum.TextYAlignment.Center, FontFace = FONT})
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

RunService.RenderStepped:Connect(function()
    if previewState.update then pcall(previewState.update) end
end)

local api = {Settings = S, GUI = gui, Root = root, Preview = previewHolder}
return api
