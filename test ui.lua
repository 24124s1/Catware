getgenv().cloneref = cloneref or function(...) return ... end

local Library, Themes do
    local Players = cloneref(game:GetService("Players"))
    local UIS = cloneref(game:GetService("UserInputService"))
    local TweenService = cloneref(game:GetService("TweenService"))
    local RunService = cloneref(game:GetService("RunService"))
    local HttpService = cloneref(game:GetService("HttpService"))
    local Workspace = cloneref(game:GetService("Workspace"))
    local CoreGui = cloneref(game:GetService("CoreGui"))
    local GuiService = cloneref(game:GetService("GuiService"))
    local Lighting = cloneref(game:GetService("Lighting"))

    local lp = Players.LocalPlayer
    local camera = Workspace.CurrentCamera
    local mouse = lp:GetMouse()

    local rgb = Color3.fromRGB
    local hsv = Color3.fromHSV
    local hex = Color3.fromHex
    local dim2 = UDim2.new
    local dim = UDim.new
    local clamp = math.clamp
    local floor = math.floor
    local abs = math.abs
    local sin = math.sin
    local max = math.max
    local min = math.min

    local Enum_X = Enum.AutomaticSize.X
    local Enum_Y = Enum.AutomaticSize.Y
    local Enum_XY = Enum.AutomaticSize.XY

    Themes = {
        preset = {
            outline = hex("#0A0A0A"),
            inline = hex("#2D2D2D"),
            accent = hex("#CC7094"),
            high_contrast = hex("#141414"),
            low_contrast = hex("#1E1E1E"),
            text = hex("#B4B4B4"),
            text_outline = rgb(0, 0, 0),
            glow = hex("#CC7094"),
        },
        utility = {
            outline = {BackgroundColor3 = {}, Color = {}},
            inline = {BackgroundColor3 = {}, ImageColor3 = {}},
            accent = {BackgroundColor3 = {}, TextColor3 = {}, ImageColor3 = {}, ScrollBarImageColor3 = {}},
            high_contrast = {BackgroundColor3 = {}},
            low_contrast = {BackgroundColor3 = {}},
            text = {TextColor3 = {}},
            text_outline = {Color = {}},
            glow = {ImageColor3 = {}},
            contrast = {Color = {}},
        }
    }

    local flags = {}
    local config_flags = {}
    local connections = {}
    local current_element_open = nil
    local library = {
        directory = "Midnight",
        folders = {"/fonts", "/configs", "/images"},
        flags = flags,
        config_flags = config_flags,
        visible_flags = {},
        guis = {},
        connections = connections,
        notifications = {},
        playerlist_data = {},
        current_tab = nil,
        current_element_open = nil,
        dock_button_holder = nil,
        old_config = nil,
        font = nil,
        keybind_list = nil,
        binds = {},
        copied_flag = nil,
        is_rainbow = false,
        instances = {},
        drawings = {},
        display_orders = 0,
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

    local FONT
    do
        local ok, font = pcall(function()
            if not (writefile and getcustomasset and isfile) then error() end
            if not isfile("midnight_font.ttf") then
                writefile("midnight_font.ttf", game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/fs-tahoma-8px.ttf"))
            end
            local data = {name = "MidnightPixel", faces = {{name = "Regular", weight = 400, style = "normal", assetId = getcustomasset("midnight_font.ttf")}}}
            writefile("midnight_font.json", HttpService:JSONEncode(data))
            return Font.new(getcustomasset("midnight_font.json"), Enum.FontWeight.Regular)
        end)
        FONT = (ok and font) or Font.fromEnum(Enum.Font.Code)
        library.font = FONT
    end

    for _, path in next, library.folders do
        pcall(makefolder, library.directory .. path)
    end

    local function connection(signal, callback)
        local c = signal:Connect(callback)
        table.insert(connections, c)
        return c
    end

    local function create(class, props)
        local ins = Instance.new(class)
        if props then
            for k, v in pairs(props) do
                ins[k] = v
            end
        end
        if class == "TextLabel" or class == "TextButton" or class == "TextBox" then
            ins.FontFace = FONT
            ins.TextSize = 12
            if not props or not props.TextColor3 then
                ins.TextColor3 = Themes.preset.text
            end
            if not props or props.BackgroundTransparency == nil then
                ins.BackgroundTransparency = 1
            end
        end
        if class == "TextButton" then
            ins.AutoButtonColor = false
        end
        if class == "ScreenGui" then
            table.insert(library.guis, ins)
        end
        return ins
    end

    local function apply_theme(inst, theme, prop)
        if Themes.utility[theme] and Themes.utility[theme][prop] then
            table.insert(Themes.utility[theme][prop], inst)
        end
    end

    local function update_theme(theme, color)
        if not Themes.utility[theme] then return end
        for prop, list in pairs(Themes.utility[theme]) do
            for _, obj in ipairs(list) do
                if obj and obj.Parent then
                    pcall(function() obj[prop] = color end)
                end
            end
        end
        Themes.preset[theme] = color
    end

    local function tween(obj, props, t)
        TweenService:Create(obj, TweenInfo.new(t or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), props):Play()
    end

    local function inside(obj, pos)
        local p, s = obj.AbsolutePosition, obj.AbsoluteSize
        return pos.X >= p.X and pos.X <= p.X + s.X and pos.Y >= p.Y and pos.Y <= p.Y + s.Y
    end

    local keys = {
        [Enum.KeyCode.LeftShift] = "LS",
        [Enum.KeyCode.RightShift] = "RS",
        [Enum.KeyCode.LeftControl] = "LC",
        [Enum.KeyCode.RightControl] = "RC",
        [Enum.KeyCode.LeftAlt] = "LA",
        [Enum.KeyCode.RightAlt] = "RA",
        [Enum.KeyCode.Insert] = "INS",
        [Enum.KeyCode.Backspace] = "BS",
        [Enum.KeyCode.Return] = "ENT",
        [Enum.KeyCode.CapsLock] = "CAPS",
        [Enum.KeyCode.Escape] = "ESC",
        [Enum.KeyCode.Space] = "SPC",
        [Enum.UserInputType.MouseButton1] = "MB1",
        [Enum.UserInputType.MouseButton2] = "MB2",
        [Enum.UserInputType.MouseButton3] = "MB3",
    }

    local function getKeyName(input)
        if not input then return "NONE" end
        if keys[input] then return keys[input] end
        local str = tostring(input)
        str = str:gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "")
        return string.upper(str)
    end

    Library = {}
    Library.__index = Library

    function Library:window(opts)
        opts = opts or {}
        local self = setmetatable({}, Library)
        self.name = opts.name or "midnight"
        self.size = opts.size or dim2(0, 650, 0, 700)
        self.directory = opts.directory or library.directory
        self.toggleKey = opts.toggleKey or Enum.KeyCode.RightShift
        self.flags = flags
        self.listeners = {}
        self.order = 0
        self.popup = nil
        self.currentTab = nil
        self.opened = true
        self.cpCount = 0
        self.categories = {}

        if makefolder then
            makefolder(self.directory)
            makefolder(self.directory .. "/configs")
        end

        self.gui = create("ScreenGui", {
            Name = HttpService:GenerateGUID(false),
            IgnoreGuiInset = true,
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            DisplayOrder = 1000,
            Parent = getParent(),
        })

        local vp = camera.ViewportSize
        self.root = create("Frame", {
            Parent = self.gui,
            BackgroundTransparency = 1,
            Size = self.size,
            Position = dim2(0, floor(vp.X / 2 - self.size.X.Offset / 2), 0, floor(vp.Y / 2 - self.size.Y.Offset / 2)),
        })

        local glow = create("ImageLabel", {
            Parent = self.root,
            Name = "Glow",
            BackgroundTransparency = 1,
            Position = dim2(0, -15, 0, -15),
            Size = dim2(1, 30, 1, 30),
            Image = "rbxassetid://5028857084",
            ImageColor3 = Themes.preset.glow,
            ImageTransparency = 0.6,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(24, 24, 276, 276),
            ZIndex = 0,
        })
        apply_theme(glow, "glow", "ImageColor3")

        local outline = create("Frame", {
            Parent = self.root,
            Size = dim2(1, 0, 1, 0),
            BackgroundColor3 = Themes.preset.outline,
        })
        apply_theme(outline, "outline", "BackgroundColor3")

        local inline = create("Frame", {
            Parent = outline,
            Position = dim2(0, 1, 0, 1),
            Size = dim2(1, -2, 1, -2),
            BackgroundColor3 = Themes.preset.inline,
        })
        apply_theme(inline, "inline", "BackgroundColor3")

        local body = create("Frame", {
            Parent = inline,
            Position = dim2(0, 1, 0, 1),
            Size = dim2(1, -2, 1, -2),
            BackgroundColor3 = Themes.preset.high_contrast,
        })
        apply_theme(body, "high_contrast", "BackgroundColor3")

        local accent = create("Frame", {
            Parent = body,
            Size = dim2(1, 0, 0, 2),
            BackgroundColor3 = Themes.preset.accent,
            ZIndex = 2,
        })
        apply_theme(accent, "accent", "BackgroundColor3")
        create("UIGradient", {
            Parent = accent,
            Rotation = 90,
            Color = ColorSequence.new(rgb(255, 255, 255), rgb(150, 150, 150)),
        })

        local side = create("Frame", {
            Parent = body,
            Position = dim2(0, 0, 0, 2),
            Size = dim2(0, 150, 1, -2),
            BackgroundColor3 = Themes.preset.low_contrast,
        })
        apply_theme(side, "low_contrast", "BackgroundColor3")

        local sideHeader = create("Frame", {
            Parent = side,
            Size = dim2(1, 0, 0, 48),
            BackgroundTransparency = 1,
        })

        local iconOuter = create("Frame", {
            Parent = sideHeader,
            Position = dim2(0, 12, 0, 16),
            Size = dim2(0, 12, 0, 12),
            BackgroundColor3 = rgb(22, 22, 22),
        })
        create("UIStroke", {
            Parent = iconOuter,
            Color = rgb(70, 70, 70),
            LineJoinMode = Enum.LineJoinMode.Miter,
        })
        local iconInner = create("Frame", {
            Parent = sideHeader,
            Position = dim2(0, 16, 0, 20),
            Size = dim2(0, 8, 0, 8),
            BackgroundColor3 = Themes.preset.accent,
        })
        apply_theme(iconInner, "accent", "BackgroundColor3")

        create("TextLabel", {
            Parent = sideHeader,
            Text = self.name,
            TextColor3 = rgb(240, 240, 240),
            Position = dim2(0, 36, 0, 12),
            Size = dim2(1, -40, 0, 14),
            FontFace = FONT,
            TextSize = 13,
        })
        create("TextLabel", {
            Parent = sideHeader,
            Text = "v67",
            TextColor3 = rgb(85, 85, 85),
            Position = dim2(0, 36, 0, 26),
            Size = dim2(1, -40, 0, 12),
            FontFace = FONT,
            TextSize = 11,
        })

        create("Frame", {
            Parent = side,
            Position = dim2(0, 0, 0, 48),
            Size = dim2(1, 0, 0, 1),
            BackgroundColor3 = Themes.preset.outline,
        })

        self.sideList = create("ScrollingFrame", {
            Parent = side,
            Position = dim2(0, 0, 0, 50),
            Size = dim2(1, 0, 1, -100),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Themes.preset.accent,
            CanvasSize = dim2(0, 0, 0, 0),
            AutomaticCanvasSize = Enum_Y,
            BorderSizePixel = 0,
        })
        apply_theme(self.sideList, "accent", "ScrollBarImageColor3")
        create("UIListLayout", {
            Parent = self.sideList,
            Padding = dim(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })
        create("UIPadding", {
            Parent = self.sideList,
            PaddingTop = dim(0, 4),
            PaddingBottom = dim(0, 4),
        })

        local footer = create("Frame", {
            Parent = side,
            AnchorPoint = Vector2.new(0, 1),
            Position = dim2(0, 0, 1, 0),
            Size = dim2(1, 0, 0, 48),
            BackgroundTransparency = 1,
        })
        create("Frame", {
            Parent = footer,
            Size = dim2(1, 0, 0, 1),
            BackgroundColor3 = Themes.preset.outline,
        })

        local avatar = create("ImageLabel", {
            Parent = footer,
            Position = dim2(0, 10, 0, 10),
            Size = dim2(0, 28, 0, 28),
            BackgroundColor3 = rgb(10, 10, 10),
            Image = "",
            ScaleType = Enum.ScaleType.Crop,
        })
        create("UIStroke", {
            Parent = avatar,
            Color = rgb(48, 48, 48),
            LineJoinMode = Enum.LineJoinMode.Miter,
        })
        create("UICorner", {
            Parent = avatar,
            CornerRadius = dim(0, 4),
        })

        task.spawn(function()
            local ok, content = pcall(function()
                return Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            end)
            if ok and content then
                avatar.Image = content
            else
                avatar.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
            end
        end)

        create("TextLabel", {
            Parent = footer,
            Text = lp.DisplayName,
            TextColor3 = rgb(215, 215, 215),
            Position = dim2(0, 46, 0, 10),
            Size = dim2(1, -52, 0, 14),
            FontFace = FONT,
            TextSize = 12,
            TextTruncate = Enum.TextTruncate.AtEnd,
        })
        create("TextLabel", {
            Parent = footer,
            Text = "uid " .. tostring(lp.UserId),
            TextColor3 = rgb(85, 85, 85),
            Position = dim2(0, 46, 0, 24),
            Size = dim2(1, -52, 0, 12),
            FontFace = FONT,
            TextSize = 11,
            TextTruncate = Enum.TextTruncate.AtEnd,
        })

        local content = create("Frame", {
            Parent = body,
            Position = dim2(0, 150, 0, 2),
            Size = dim2(1, -150, 1, -2),
            BackgroundColor3 = Themes.preset.high_contrast,
        })
        apply_theme(content, "high_contrast", "BackgroundColor3")

        local header = create("Frame", {
            Parent = content,
            Size = dim2(1, 0, 0, 28),
            BackgroundTransparency = 1,
        })
        local crumbs = create("Frame", {
            Parent = header,
            Position = dim2(0, 10, 0, 0),
            Size = dim2(0.7, 0, 1, 0),
            BackgroundTransparency = 1,
        })
        create("UIListLayout", {
            Parent = crumbs,
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = dim(0, 4),
        })
        self.crumbCat = create("TextLabel", {
            Parent = crumbs,
            Text = "",
            TextColor3 = rgb(85, 85, 85),
            AutomaticSize = Enum_X,
            Size = dim2(0, 0, 1, 0),
            FontFace = FONT,
            TextSize = 12,
        })
        self.crumbTab = create("TextLabel", {
            Parent = crumbs,
            Text = "",
            TextColor3 = rgb(240, 240, 240),
            AutomaticSize = Enum_X,
            Size = dim2(0, 0, 1, 0),
            FontFace = FONT,
            TextSize = 12,
        })

        create("Frame", {
            Parent = content,
            Position = dim2(0, 0, 0, 28),
            Size = dim2(1, 0, 0, 1),
            BackgroundColor3 = Themes.preset.outline,
        })

        self.pageHolder = create("Frame", {
            Parent = content,
            Position = dim2(0, 0, 0, 29),
            Size = dim2(1, 0, 1, -29),
            BackgroundTransparency = 1,
        })

        local function drag(handle, target)
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
                    target.Position = dim2(0, startPos.X.Offset + d.X, 0, startPos.Y.Offset + d.Y)
                end
            end)
        end
        drag(sideHeader, self.root)
        drag(header, self.root)

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

    function Library:setAccent(c)
        update_theme("accent", c)
        update_theme("glow", c)
    end

    function Library:setFlag(flag, value)
        flags[flag] = value
        for _, fn in ipairs(self.listeners or {}) do
            pcall(fn, flag, value)
        end
    end

    function Library:onChange(fn)
        self.listeners = self.listeners or {}
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
        for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
        self.gui:Destroy()
    end

    function Library:tab(opts)
        opts = opts or {}
        local name = opts.name or "tab"
        local tab = {
            lib = self,
            name = name,
            buttons = {},
            pages = {},
        }

        local btn = create("TextButton", {
            Parent = self.sideList,
            Size = dim2(1, -8, 0, 22),
            BackgroundTransparency = 1,
            Text = "",
            LayoutOrder = self.order,
        })
        self.order = self.order + 1

        local bar = create("Frame", {
            Parent = btn,
            Size = dim2(0, 2, 1, 0),
            BackgroundColor3 = Themes.preset.accent,
            Visible = false,
        })
        apply_theme(bar, "accent", "BackgroundColor3")

        local bullet = create("Frame", {
            Parent = btn,
            Position = dim2(0, 12, 0, 9),
            Size = dim2(0, 4, 0, 4),
            BackgroundColor3 = rgb(70, 70, 70),
        })

        local text = create("TextLabel", {
            Parent = btn,
            Text = name,
            TextColor3 = rgb(160, 160, 160),
            Position = dim2(0, 24, 0, 0),
            Size = dim2(1, -28, 1, 0),
            FontFace = FONT,
            TextSize = 12,
        })

        local page = create("Frame", {
            Parent = self.pageHolder,
            Size = dim2(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
        })
        create("UIPadding", {
            Parent = page,
            PaddingTop = dim(0, 8),
            PaddingBottom = dim(0, 8),
            PaddingLeft = dim(0, 8),
            PaddingRight = dim(0, 8),
        })
        create("UIListLayout", {
            Parent = page,
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = dim(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        local left = create("Frame", {
            Parent = page,
            Size = dim2(0.5, -4, 1, 0),
            BackgroundTransparency = 1,
            LayoutOrder = 1,
        })
        create("UIListLayout", {
            Parent = left,
            Padding = dim(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        local right = create("Frame", {
            Parent = page,
            Size = dim2(0.5, -4, 1, 0),
            BackgroundTransparency = 1,
            LayoutOrder = 2,
        })
        create("UIListLayout", {
            Parent = right,
            Padding = dim(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        tab.button = btn
        tab.bar = bar
        tab.bullet = bullet
        tab.text = text
        tab.page = page
        tab.left = left
        tab.right = right

        function tab:open()
            local lib = self.lib
            lib:closePopups()
            if lib.currentTab then
                lib.currentTab.page.Visible = false
                lib.currentTab.bar.Visible = false
                lib.currentTab.button.BackgroundTransparency = 1
                lib.currentTab.text.TextColor3 = rgb(160, 160, 160)
                lib.currentTab.bullet.BackgroundColor3 = rgb(70, 70, 70)
            end
            lib.currentTab = self
            self.page.Visible = true
            self.bar.Visible = true
            self.button.BackgroundTransparency = 0
            self.button.BackgroundColor3 = rgb(24, 24, 24)
            self.text.TextColor3 = rgb(245, 245, 245)
            self.bullet.BackgroundColor3 = Themes.preset.accent
            lib.crumbCat.Text = ""
            lib.crumbTab.Text = self.name
        end

        btn.MouseButton1Click:Connect(function()
            tab:open()
        end)

        function tab:column()
            local col = {
                lib = self.lib,
                tab = self,
                holder = create("Frame", {
                    Parent = self.left,
                    Size = dim2(1, 0, 0, 0),
                    AutomaticSize = Enum_Y,
                    BackgroundTransparency = 1,
                    LayoutOrder = self.lib.order,
                }),
            }
            self.lib.order = self.lib.order + 1
            create("UIListLayout", {
                Parent = col.holder,
                Padding = dim(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder,
            })
            return setmetatable(col, {__index = self.lib})
        end

        function tab:multi_section(opts)
            opts = opts or {}
            local names = opts.names or {"Section"}
            local sections = {}
            local holder = create("Frame", {
                Parent = self.left,
                Size = dim2(1, 0, 0, 0),
                AutomaticSize = Enum_Y,
                BackgroundTransparency = 1,
                LayoutOrder = self.lib.order,
            })
            self.lib.order = self.lib.order + 1

            local tabBar = create("Frame", {
                Parent = holder,
                Size = dim2(1, 0, 0, 22),
                BackgroundColor3 = Themes.preset.outline,
            })
            apply_theme(tabBar, "outline", "BackgroundColor3")
            create("UIListLayout", {
                Parent = tabBar,
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = dim(0, 1),
                SortOrder = Enum.SortOrder.LayoutOrder,
            })

            local contentHolder = create("Frame", {
                Parent = holder,
                Position = dim2(0, 0, 0, 22),
                Size = dim2(1, 0, 0, 0),
                AutomaticSize = Enum_Y,
                BackgroundColor3 = Themes.preset.high_contrast,
            })
            apply_theme(contentHolder, "high_contrast", "BackgroundColor3")
            create("UIStroke", {
                Parent = contentHolder,
                Color = Themes.preset.inline,
                LineJoinMode = Enum.LineJoinMode.Miter,
            })

            local current
            for i, n in ipairs(names) do
                local secBtn = create("TextButton", {
                    Parent = tabBar,
                    Size = dim2(1 / #names, -1, 1, 0),
                    BackgroundColor3 = i == 1 and Themes.preset.high_contrast or Themes.preset.low_contrast,
                    Text = n,
                    TextColor3 = i == 1 and Themes.preset.text or rgb(100, 100, 100),
                    FontFace = FONT,
                    TextSize = 11,
                    LayoutOrder = i,
                })
                apply_theme(secBtn, "high_contrast", "BackgroundColor3")

                local secBody = create("Frame", {
                    Parent = contentHolder,
                    Size = dim2(1, 0, 0, 0),
                    AutomaticSize = Enum_Y,
                    BackgroundTransparency = 1,
                    Visible = i == 1,
                })
                create("UIPadding", {
                    Parent = secBody,
                    PaddingTop = dim(0, 8),
                    PaddingBottom = dim(0, 8),
                    PaddingLeft = dim(0, 8),
                    PaddingRight = dim(0, 8),
                })
                create("UIListLayout", {
                    Parent = secBody,
                    Padding = dim(0, 4),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                })

                local sec = setmetatable({
                    lib = self.lib,
                    body = secBody,
                    holder = secBody,
                    name = n,
                }, {__index = self.lib})

                secBtn.MouseButton1Click:Connect(function()
                    if current then
                        current.body.Visible = false
                        current.btn.BackgroundColor3 = Themes.preset.low_contrast
                        current.btn.TextColor3 = rgb(100, 100, 100)
                    end
                    current = {body = secBody, btn = secBtn}
                    secBody.Visible = true
                    secBtn.BackgroundColor3 = Themes.preset.high_contrast
                    secBtn.TextColor3 = Themes.preset.text
                end)

                if i == 1 then current = {body = secBody, btn = secBtn} end
                sections[i] = sec
            end

            return table.unpack(sections)
        end

        function tab:section(opts)
            opts = opts or {}
            local side = (opts.side == "right") and self.right or self.left
            local container = create("Frame", {
                Parent = side,
                Size = dim2(1, 0, 0, 0),
                AutomaticSize = Enum_Y,
                BackgroundTransparency = 1,
                LayoutOrder = self.lib.order,
            })
            self.lib.order = self.lib.order + 1
            create("UIPadding", {
                Parent = container,
                PaddingTop = dim(0, 7),
            })

            local body = create("Frame", {
                Parent = container,
                Size = dim2(1, 0, 0, 0),
                AutomaticSize = Enum_Y,
                BackgroundColor3 = Themes.preset.high_contrast,
                ZIndex = 1,
            })
            apply_theme(body, "high_contrast", "BackgroundColor3")
            create("UIStroke", {
                Parent = body,
                Color = Themes.preset.inline,
                LineJoinMode = Enum.LineJoinMode.Miter,
            })
            create("UIPadding", {
                Parent = body,
                PaddingTop = dim(0, 12),
                PaddingBottom = dim(0, 8),
                PaddingLeft = dim(0, 8),
                PaddingRight = dim(0, 8),
            })
            create("UIListLayout", {
                Parent = body,
                Padding = dim(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder,
            })

            local title = create("TextLabel", {
                Parent = container,
                Text = opts.name or "section",
                TextColor3 = Themes.preset.text,
                Position = dim2(0, 6, 0, -7),
                AutomaticSize = Enum_XY,
                BackgroundTransparency = 0,
                BackgroundColor3 = Themes.preset.high_contrast,
                ZIndex = 3,
                FontFace = FONT,
                TextSize = 12,
            })
            apply_theme(title, "high_contrast", "BackgroundColor3")
            apply_theme(title, "text", "TextColor3")
            create("UIStroke", {
                Parent = title,
                Color = Themes.preset.inline,
                LineJoinMode = Enum.LineJoinMode.Miter,
            })
            create("UIPadding", {
                Parent = title,
                PaddingLeft = dim(0, 4),
                PaddingRight = dim(0, 4),
            })

            local sec = setmetatable({
                lib = self.lib,
                body = body,
                holder = body,
            }, {__index = self.lib})
            self.lib.currentSection = sec
            return sec
        end

        function tab:preview(opts)
            opts = opts or {}
            local ids = opts.flags or {}
            local sec = self:section({name = opts.name or "preview", side = opts.side or "right"})

            local area = create("Frame", {
                Parent = sec.body,
                Size = dim2(1, 0, 0, 320),
                BackgroundColor3 = rgb(8, 8, 8),
                ClipsDescendants = true,
                LayoutOrder = self.lib.order,
            })
            self.lib.order = self.lib.order + 1
            create("UIStroke", {
                Parent = area,
                Color = rgb(30, 30, 30),
                LineJoinMode = Enum.LineJoinMode.Miter,
            })

            local vp = create("ViewportFrame", {
                Parent = area,
                Size = dim2(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Ambient = rgb(180, 180, 180),
                LightColor = rgb(255, 255, 255),
            })
            local cam = Instance.new("Camera")
            cam.FieldOfView = 40
            cam.CFrame = CFrame.lookAt(Vector3.new(0, 2.2, 7.5), Vector3.new(0, 1.4, 0))
            cam.Parent = vp
            vp.CurrentCamera = cam

            local ov = create("Frame", {
                Parent = area,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = dim2(0.5, 0, 0.5, 10),
                Size = dim2(0, 110, 0, 200),
                BackgroundTransparency = 1,
            })

            local boxFull = create("Frame", {
                Parent = ov,
                Size = dim2(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Visible = false,
            })
            local boxStroke = create("UIStroke", {
                Parent = boxFull,
                Color = rgb(255, 80, 80),
                Thickness = 1,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
            })
            local boxOutline = create("Frame", {
                Parent = boxFull,
                Position = dim2(0, 1, 0, 1),
                Size = dim2(1, -2, 1, -2),
                BackgroundTransparency = 1,
            })
            create("UIStroke", {
                Parent = boxOutline,
                Color = rgb(0, 0, 0),
                Thickness = 1,
                LineJoinMode = Enum.LineJoinMode.Miter,
            })

            local corners = create("Frame", {
                Parent = ov,
                Size = dim2(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Visible = false,
            })
            local function makeCorner(ax, ay, w, h, px, py)
                local f = create("Frame", {
                    Parent = corners,
                    AnchorPoint = Vector2.new(ax, ay),
                    Position = dim2(px, 0, py, 0),
                    Size = dim2(0, w, 0, h),
                    BackgroundColor3 = rgb(0, 0, 0),
                })
                local inner = create("Frame", {
                    Parent = f,
                    Position = dim2(0, 1, 0, 1),
                    Size = dim2(1, -2, 1, -2),
                    BackgroundColor3 = rgb(255, 80, 80),
                })
                return inner
            end
            local c1 = makeCorner(0, 0, 28, 2, 0, 0)
            local c2 = makeCorner(0, 0, 2, 22, 0, 0)
            local c3 = makeCorner(1, 0, 28, 2, 1, 0)
            local c4 = makeCorner(1, 0, 2, 22, 1, 0)
            local c5 = makeCorner(0, 1, 28, 2, 0, 1)
            local c6 = makeCorner(0, 1, 2, 22, 0, 1)
            local c7 = makeCorner(1, 1, 28, 2, 1, 1)
            local c8 = makeCorner(1, 1, 2, 22, 1, 1)

            local nameLbl = create("TextLabel", {
                Parent = ov,
                Text = string.format("%s (@%s)", lp.DisplayName, lp.Name),
                TextColor3 = rgb(255, 255, 255),
                AnchorPoint = Vector2.new(0.5, 1),
                Position = dim2(0.5, 0, 0, -6),
                AutomaticSize = Enum_X,
                Size = dim2(0, 0, 0, 13),
                TextXAlignment = Enum.TextXAlignment.Center,
                TextStrokeTransparency = 0,
                FontFace = FONT,
                TextSize = 12,
            })

            local hpHolder = create("Frame", {
                Parent = ov,
                AnchorPoint = Vector2.new(1, 0),
                Position = dim2(0, -6, 0, 0),
                Size = dim2(0, 3, 1, 0),
                BackgroundColor3 = rgb(15, 15, 15),
            })
            create("UIStroke", {
                Parent = hpHolder,
                Color = rgb(0, 0, 0),
                Thickness = 1,
            })
            local hpBar = create("Frame", {
                Parent = hpHolder,
                AnchorPoint = Vector2.new(0, 1),
                Position = dim2(0, 0, 1, 0),
                Size = dim2(1, 0, 1, 0),
                BackgroundColor3 = rgb(0, 255, 100),
            })

            local distLbl = create("TextLabel", {
                Parent = ov,
                Text = "[42m]",
                TextColor3 = rgb(255, 255, 255),
                Position = dim2(1, 5, 0, 0),
                Size = dim2(0, 0, 0, 12),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextStrokeTransparency = 0,
                AutomaticSize = Enum_X,
                FontFace = FONT,
                TextSize = 11,
            })

            local wepLbl = create("TextLabel", {
                Parent = ov,
                Text = "None",
                TextColor3 = rgb(255, 255, 255),
                AnchorPoint = Vector2.new(0.5, 0),
                Position = dim2(0.5, 0, 1, 4),
                Size = dim2(0, 0, 0, 12),
                TextXAlignment = Enum.TextXAlignment.Center,
                TextStrokeTransparency = 0,
                AutomaticSize = Enum_X,
                FontFace = FONT,
                TextSize = 11,
            })

            local headDot = create("Frame", {
                Parent = ov,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = dim2(0.5, 0, 0.12, 0),
                Size = dim2(0, 8, 0, 8),
                BackgroundColor3 = rgb(255, 255, 255),
                Visible = false,
            })
            create("UICorner", {Parent = headDot, CornerRadius = dim(1, 0)})
            create("UIStroke", {Parent = headDot, Color = rgb(0, 0, 0), Thickness = 1})

            local function refresh()
                local f = flags
                local function on(k) return ids[k] and f[ids[k]] == true end
                local function col(k, fallback)
                    local c = ids[k] and f[ids[k]]
                    if type(c) == "table" and c.Color then return c.Color end
                    return typeof(c) == "Color3" and c or fallback
                end
                local boxOn = on("box")
                local boxType = f[ids.box_type] or "Corner"
                local isCorner = boxType == "Corner"
                boxFull.Visible = boxOn and not isCorner
                corners.Visible = boxOn and isCorner
                local boxCol = col("box_color", rgb(255, 80, 80))
                boxStroke.Color = boxCol
                for _, c in ipairs({c1, c2, c3, c4, c5, c6, c7, c8}) do
                    c.BackgroundColor3 = boxCol
                end
                nameLbl.Visible = on("name")
                nameLbl.TextColor3 = col("name_color", rgb(255, 255, 255))
                hpHolder.Visible = on("health")
                local mult = abs(sin(tick() * 1.8))
                hpBar.Size = dim2(1, 0, mult, 0)
                distLbl.Visible = on("distance")
                distLbl.TextColor3 = col("distance_color", rgb(255, 255, 255))
                wepLbl.Visible = on("weapon")
                wepLbl.TextColor3 = col("weapon_color", rgb(255, 255, 255))
                headDot.Visible = on("headdot")
                headDot.BackgroundColor3 = col("headdot_color", rgb(255, 255, 255))
            end

            self.lib:onChange(refresh)
            task.defer(refresh)
            connection(RunService.RenderStepped, function()
                if area.Parent and area.Parent.Parent and area.Parent.Parent.Visible then
                    refresh()
                end
            end)

            task.spawn(function()
                local char = lp.Character or lp.CharacterAdded:Wait()
                if not char:FindFirstChild("HumanoidRootPart") then
                    char:WaitForChild("HumanoidRootPart", 5)
                end
                char.Archivable = true
                local ok, clone = pcall(function() return char:Clone() end)
                if not ok or not clone then return end
                for _, d in ipairs(clone:GetDescendants()) do
                    if d:IsA("BaseScript") or d:IsA("LocalScript") then
                        d:Destroy()
                    end
                end
                local hrp = clone:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.Anchored = true end
                clone.Parent = vp
                local rot = 0
                connection(RunService.RenderStepped, function(dt)
                    if not (self.lib.root.Visible and area.Parent) then return end
                    rot = rot + dt * 0.7
                    clone:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(0, rot, 0))
                end)
            end)

            return sec
        end

        return tab
    end

    function Library:toggle(opts)
        opts = opts or {}
        local cfg = {
            name = opts.name or "toggle",
            flag = opts.flag or opts.name or "toggle",
            callback = opts.callback or function() end,
            value = false,
        }
        local parent = self.currentSection and self.currentSection.body or self.holder
        local row = create("TextButton", {
            Parent = parent,
            Size = dim2(1, 0, 0, 16),
            BackgroundTransparency = 1,
            Text = "",
            LayoutOrder = self.order or 0,
        })
        if self.order then self.order = self.order + 1 end

        local box = create("Frame", {
            Parent = row,
            Position = dim2(0, 0, 0, 4),
            Size = dim2(0, 8, 0, 8),
            BackgroundColor3 = rgb(24, 24, 24),
        })
        create("UIStroke", {
            Parent = box,
            Color = rgb(48, 48, 48),
            LineJoinMode = Enum.LineJoinMode.Miter,
        })

        local lbl = create("TextLabel", {
            Parent = row,
            Text = cfg.name,
            TextColor3 = rgb(112, 112, 112),
            Position = dim2(0, 16, 0, 0),
            Size = dim2(1, -50, 1, 0),
            FontFace = FONT,
            TextSize = 12,
        })

        local right = create("Frame", {
            Parent = row,
            AnchorPoint = Vector2.new(1, 0),
            Position = dim2(1, 0, 0, 0),
            Size = dim2(0, 0, 1, 0),
            AutomaticSize = Enum_X,
            BackgroundTransparency = 1,
        })
        create("UIListLayout", {
            Parent = right,
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = dim(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })
        cfg.right = right

        function cfg.set(v)
            cfg.value = v and true or false
            flags[cfg.flag] = cfg.value
            tween(box, {BackgroundColor3 = cfg.value and Themes.preset.accent or rgb(24, 24, 24)})
            tween(lbl, {TextColor3 = cfg.value and Themes.preset.text or rgb(112, 112, 112)})
            cfg.callback(cfg.value)
        end

        row.MouseButton1Click:Connect(function()
            cfg.set(not cfg.value)
        end)

        config_flags[cfg.flag] = cfg.set
        cfg.set(opts.default or false)

        local mt = {
            colorpicker = function(_, o)
                return self:colorpicker(o, right)
            end,
            dropdown = function(_, o)
                return self:dropdown(o)
            end,
            keybind = function(_, o)
                return self:keybind(o, right)
            end,
        }
        return setmetatable(cfg, {__index = mt})
    end

    function Library:colorpicker(opts, parentOverride)
        opts = opts or {}
        self.cpCount = (self.cpCount or 0) + 1
        local cp = {
            flag = opts.flag or ("color_" .. self.cpCount),
            callback = opts.callback or function() end,
            open = false,
            color = opts.color or rgb(255, 255, 255),
            alpha = opts.alpha or 1,
        }
        local h, s, v = cp.color:ToHSV()
        local a = cp.alpha

        local parent = parentOverride or (self.currentSection and self.currentSection.body) or self.holder
        local swatch = create("TextButton", {
            Parent = parent,
            Size = dim2(0, 18, 0, 8),
            BackgroundColor3 = cp.color,
            LayoutOrder = self.cpCount,
            Text = "",
        })
        create("UIStroke", {
            Parent = swatch,
            Color = Themes.preset.outline,
            LineJoinMode = Enum.LineJoinMode.Miter,
        })
        create("UIGradient", {
            Parent = swatch,
            Rotation = 90,
            Color = ColorSequence.new(rgb(255, 255, 255), rgb(170, 170, 170)),
        })

        local pop = create("Frame", {
            Parent = self.gui,
            Visible = false,
            Size = dim2(0, 200, 0, 220),
            BackgroundColor3 = Themes.preset.outline,
            ZIndex = 400,
        })
        apply_theme(pop, "outline", "BackgroundColor3")

        local win_inline = create("Frame", {
            Parent = pop,
            Position = dim2(0, 1, 0, 1),
            Size = dim2(1, -2, 1, -2),
            BackgroundColor3 = Themes.preset.accent,
        })
        apply_theme(win_inline, "accent", "BackgroundColor3")

        local win_holder = create("Frame", {
            Parent = win_inline,
            Position = dim2(0, 1, 0, 1),
            Size = dim2(1, -2, 1, -2),
            BackgroundColor3 = Themes.preset.high_contrast,
        })
        apply_theme(win_holder, "high_contrast", "BackgroundColor3")

        create("TextLabel", {
            Parent = win_holder,
            Text = opts.name or "Color",
            TextColor3 = Themes.preset.text,
            Position = dim2(0, 6, 0, 4),
            AutomaticSize = Enum_XY,
            FontFace = FONT,
            TextSize = 12,
        })

        local main = create("Frame", {
            Parent = win_holder,
            Position = dim2(0, 6, 0, 24),
            Size = dim2(1, -12, 1, -60),
            BackgroundColor3 = Themes.preset.inline,
        })
        apply_theme(main, "inline", "BackgroundColor3")

        local main_bg = create("Frame", {
            Parent = main,
            Position = dim2(0, 1, 0, 1),
            Size = dim2(1, -2, 1, -2),
            BackgroundColor3 = Themes.preset.high_contrast,
        })
        apply_theme(main_bg, "high_contrast", "BackgroundColor3")
        create("UIPadding", {
            Parent = main_bg,
            PaddingTop = dim(0, 4),
            PaddingBottom = dim(0, 4),
            PaddingLeft = dim(0, 4),
            PaddingRight = dim(0, 4),
        })

        local satval = create("Frame", {
            Parent = main_bg,
            Size = dim2(1, -22, 1, -22),
            BackgroundColor3 = Color3.fromHSV(h, 1, 1),
        })
        local white = create("Frame", {
            Parent = satval,
            Size = dim2(1, 0, 1, 0),
            BackgroundColor3 = rgb(255, 255, 255),
        })
        create("UIGradient", {
            Parent = white,
            Transparency = NumberSequence.new(0, 1),
        })
        local black = create("Frame", {
            Parent = satval,
            Size = dim2(1, 0, 1, 0),
            BackgroundColor3 = rgb(0, 0, 0),
        })
        create("UIGradient", {
            Parent = black,
            Rotation = 90,
            Transparency = NumberSequence.new(1, 0),
        })
        local svBtn = create("TextButton", {
            Parent = satval,
            Size = dim2(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 3,
        })
        local svCursor = create("Frame", {
            Parent = satval,
            Size = dim2(0, 4, 0, 4),
            BackgroundColor3 = rgb(255, 255, 255),
            ZIndex = 4,
            BorderSizePixel = 1,
            BorderColor3 = rgb(0, 0, 0),
        })

        local hue = create("TextButton", {
            Parent = main_bg,
            AnchorPoint = Vector2.new(1, 0),
            Position = dim2(1, 0, 0, 0),
            Size = dim2(0, 16, 1, -22),
            BackgroundColor3 = Themes.preset.inline,
            Text = "",
        })
        local hue_grad = create("Frame", {
            Parent = hue,
            Position = dim2(0, 1, 0, 1),
            Size = dim2(1, -2, 1, -2),
            BackgroundColor3 = rgb(255, 255, 255),
        })
        create("UIGradient", {
            Parent = hue_grad,
            Rotation = 270,
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
        local hueCursor = create("Frame", {
            Parent = hue_grad,
            Size = dim2(1, 0, 0, 3),
            BackgroundColor3 = rgb(255, 255, 255),
            BorderSizePixel = 1,
            BorderColor3 = rgb(0, 0, 0),
        })

        local alpha = create("TextButton", {
            Parent = main_bg,
            AnchorPoint = Vector2.new(0, 1),
            Position = dim2(0, 0, 1, 0),
            Size = dim2(1, -22, 0, 16),
            BackgroundColor3 = Themes.preset.inline,
            Text = "",
        })
        local alpha_drag = create("Frame", {
            Parent = alpha,
            Position = dim2(0, 1, 0, 1),
            Size = dim2(1, -2, 1, -2),
            BackgroundColor3 = Color3.fromHSV(h, s, v),
        })
        local alphaind = create("ImageLabel", {
            Parent = alpha_drag,
            ScaleType = Enum.ScaleType.Tile,
            Image = "rbxassetid://18274452449",
            BackgroundTransparency = 1,
            Size = dim2(1, 0, 1, 0),
            TileSize = dim2(0, 6, 0, 6),
        })
        create("UIGradient", {
            Parent = alphaind,
            Transparency = NumberSequence.new(0, 1),
        })
        local alphaCursor = create("Frame", {
            Parent = alpha_drag,
            Size = dim2(0, 3, 1, 0),
            BackgroundColor3 = rgb(255, 255, 255),
            BorderSizePixel = 1,
            BorderColor3 = rgb(0, 0, 0),
        })

        local dragging_sat, dragging_hue, dragging_alpha = false, false, false
        local function apply()
            local c = Color3.fromHSV(h, s, v)
            swatch.BackgroundColor3 = c
            satval.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            alpha_drag.BackgroundColor3 = c
            svCursor.Position = dim2(s, -2, 1 - v, -2)
            hueCursor.Position = dim2(0, 0, h, -1)
            alphaCursor.Position = dim2(a, -1, 0, 0)
            flags[cp.flag] = {Color = c, Transparency = a}
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

        svBtn.MouseButton1Down:Connect(function() dragging_sat = true update() end)
        hue.MouseButton1Down:Connect(function() dragging_hue = true update() end)
        alpha.MouseButton1Down:Connect(function() dragging_alpha = true update() end)
        connection(UIS.InputEnded, function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging_sat = false
                dragging_hue = false
                dragging_alpha = false
            end
        end)
        connection(UIS.InputChanged, function(i)
            if (dragging_sat or dragging_hue or dragging_alpha) and i.UserInputType == Enum.UserInputType.MouseMovement then
                update()
            end
        end)

        local popup = {frame = pop, anchor = swatch}
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
                local x = clamp(p.X + swatch.AbsoluteSize.X - 200, 0, vp.X - 200)
                local y = p.Y + 14
                if y + 220 > vp.Y then y = p.Y - 224 end
                pop.Position = dim2(0, x, 0, y)
            end
        end
        swatch.MouseButton1Click:Connect(function()
            cp.open = not cp.open
            cp.set_visible(cp.open)
            if cp.open then self:openPopup(popup) else self.popup = nil end
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
        return cp
    end

    function Library:dropdown(opts)
        opts = opts or {}
        local cfg = {
            name = opts.name or "dropdown",
            flag = opts.flag or opts.name or "dropdown",
            items = opts.items or {},
            multi = opts.multi or false,
            callback = opts.callback or function() end,
            open = false,
            buttons = {},
            option_instances = {},
            value = nil,
        }
        local default = opts.default
        if default == nil then
            default = cfg.multi and {} or (cfg.items[1] or "")
        end

        local parent = self.currentSection and self.currentSection.body or self.holder
        local holder = create("Frame", {
            Parent = parent,
            Size = dim2(1, 0, 0, 22),
            BackgroundTransparency = 1,
            LayoutOrder = self.order or 0,
        })
        if self.order then self.order = self.order + 1 end

        local btn = create("TextButton", {
            Parent = holder,
            Size = dim2(1, 0, 1, 0),
            BackgroundColor3 = Themes.preset.outline,
            Text = "",
        })
        apply_theme(btn, "outline", "BackgroundColor3")
        create("UIStroke", {
            Parent = btn,
            Color = Themes.preset.inline,
            LineJoinMode = Enum.LineJoinMode.Miter,
        })

        local inline = create("Frame", {
            Parent = btn,
            Position = dim2(0, 1, 0, 1),
            Size = dim2(1, -2, 1, -2),
            BackgroundColor3 = Themes.preset.high_contrast,
        })
        apply_theme(inline, "high_contrast", "BackgroundColor3")

        create("TextLabel", {
            Parent = inline,
            Text = cfg.name,
            TextColor3 = rgb(85, 85, 85),
            Position = dim2(0, 6, 0, 0),
            Size = dim2(0.45, 0, 1, 0),
            FontFace = FONT,
            TextSize = 12,
        })

        local valLbl = create("TextLabel", {
            Parent = inline,
            Text = "",
            TextColor3 = Themes.preset.text,
            AnchorPoint = Vector2.new(1, 0),
            Position = dim2(1, -8, 0, 0),
            Size = dim2(0.5, 0, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Right,
            TextTruncate = Enum.TextTruncate.AtEnd,
            FontFace = FONT,
            TextSize = 12,
        })
        apply_theme(valLbl, "text", "TextColor3")

        local list = create("Frame", {
            Parent = self.gui,
            Visible = false,
            Size = dim2(0, 100, 0, 0),
            AutomaticSize = Enum_Y,
            BackgroundColor3 = Themes.preset.high_contrast,
            ZIndex = 400,
        })
        apply_theme(list, "high_contrast", "BackgroundColor3")
        create("UIStroke", {
            Parent = list,
            Color = Themes.preset.inline,
            LineJoinMode = Enum.LineJoinMode.Miter,
        })
        create("UIListLayout", {
            Parent = list,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = dim(0, 2),
        })
        create("UIPadding", {
            Parent = list,
            PaddingTop = dim(0, 2),
            PaddingBottom = dim(0, 2),
        })

        local function recolor()
            local lookup = {}
            if cfg.multi then
                if type(cfg.value) == "table" then
                    for _, x in ipairs(cfg.value) do
                        if x ~= nil then lookup[x] = true end
                    end
                end
            else
                if cfg.value ~= nil then lookup[cfg.value] = true end
            end
            for item, b in pairs(cfg.buttons) do
                if item ~= nil and b then
                    b.TextColor3 = lookup[item] and Themes.preset.accent or rgb(112, 112, 112)
                end
            end
        end

        function cfg.set(val)
            if cfg.multi then
                local lookup, sel = {}, {}
                if type(val) == "table" then
                    for _, x in ipairs(val) do
                        if x ~= nil then lookup[x] = true end
                    end
                end
                for _, item in ipairs(cfg.items) do
                    if item ~= nil and lookup[item] then
                        table.insert(sel, item)
                    end
                end
                cfg.value = sel
                valLbl.Text = table.concat(sel, ", ")
            else
                cfg.value = val
                valLbl.Text = tostring(val or "")
            end
            recolor()
            flags[cfg.flag] = cfg.value
            cfg.callback(cfg.value)
        end

        function cfg.refresh_options(lst)
            for _, v in ipairs(cfg.option_instances) do
                v:Destroy()
            end
            cfg.option_instances = {}
            cfg.buttons = {}
            if type(lst) ~= "table" then return end
            for i, item in ipairs(lst) do
                if item ~= nil then
                    local b = create("TextButton", {
                        Parent = list,
                        Size = dim2(1, 0, 0, 18),
                        Text = tostring(item),
                        TextColor3 = rgb(112, 112, 112),
                        BackgroundTransparency = 1,
                        FontFace = FONT,
                        TextSize = 12,
                        LayoutOrder = i,
                    })
                    create("UIPadding", {
                        Parent = b,
                        PaddingLeft = dim(0, 8),
                    })
                    cfg.buttons[item] = b
                    table.insert(cfg.option_instances, b)
                    b.MouseButton1Click:Connect(function()
                        if cfg.multi then
                            local new_sel, found = {}, false
                            if type(cfg.value) == "table" then
                                for _, x in ipairs(cfg.value) do
                                    if x == item then
                                        found = true
                                    else
                                        table.insert(new_sel, x)
                                    end
                                end
                            end
                            if not found then table.insert(new_sel, item) end
                            cfg.set(new_sel)
                        else
                            cfg.set(item)
                            popup.close()
                            self.popup = nil
                        end
                    end)
                end
            end
            recolor()
        end

        local popup = {frame = list, anchor = btn}
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
                local absPos = btn.AbsolutePosition
                local absSize = btn.AbsoluteSize
                list.Position = dim2(0, absPos.X, 0, absPos.Y + absSize.Y + 2)
                list.Size = dim2(0, absSize.X, 0, 0)
            end
        end

        btn.MouseButton1Click:Connect(function()
            cfg.open = not cfg.open
            cfg.set_visible(cfg.open)
            if cfg.open then
                self:openPopup(popup)
            else
                self.popup = nil
            end
        end)

        cfg.refresh_options(cfg.items)
        config_flags[cfg.flag] = cfg.set
        cfg.set(default)
        return cfg
    end

    function Library:slider(opts)
        opts = opts or {}
        local cfg = {
            name = opts.name or "slider",
            flag = opts.flag or opts.name or "slider",
            min = opts.min or 0,
            max = opts.max or 100,
            interval = opts.interval or 1,
            suffix = opts.suffix or "",
            callback = opts.callback or function() end,
            dragging = false,
        }
        local decimals = 0
        if cfg.interval < 1 then
            decimals = #(tostring(cfg.interval):match("%.(%d+)") or "")
        end

        local parent = self.currentSection and self.currentSection.body or self.holder
        local row = create("Frame", {
            Parent = parent,
            Size = dim2(1, 0, 0, 28),
            BackgroundTransparency = 1,
            LayoutOrder = self.order or 0,
        })
        if self.order then self.order = self.order + 1 end

        create("TextLabel", {
            Parent = row,
            Text = cfg.name,
            TextColor3 = Themes.preset.text,
            Size = dim2(0.5, 0, 0, 14),
            FontFace = FONT,
            TextSize = 12,
        })
        local valLbl = create("TextLabel", {
            Parent = row,
            Text = "",
            TextColor3 = Themes.preset.text,
            AnchorPoint = Vector2.new(1, 0),
            Position = dim2(1, 0, 0, 0),
            Size = dim2(0.5, 0, 0, 14),
            TextXAlignment = Enum.TextXAlignment.Right,
            FontFace = FONT,
            TextSize = 12,
        })
        apply_theme(valLbl, "text", "TextColor3")

        local track = create("TextButton", {
            Parent = row,
            Position = dim2(0, 0, 0, 18),
            Size = dim2(1, 0, 0, 6),
            BackgroundColor3 = Themes.preset.outline,
            Text = "",
        })
        apply_theme(track, "outline", "BackgroundColor3")
        create("UIStroke", {
            Parent = track,
            Color = Themes.preset.inline,
            LineJoinMode = Enum.LineJoinMode.Miter,
        })

        local fill = create("Frame", {
            Parent = track,
            Size = dim2(0, 0, 1, 0),
            BackgroundColor3 = Themes.preset.accent,
        })
        apply_theme(fill, "accent", "BackgroundColor3")
        create("UIGradient", {
            Parent = fill,
            Rotation = 90,
            Color = ColorSequence.new(rgb(255, 255, 255), rgb(150, 150, 150)),
        })

        local handle = create("Frame", {
            Parent = track,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = dim2(0, 0, 0.5, 0),
            Size = dim2(0, 6, 0, 12),
            BackgroundColor3 = rgb(200, 200, 200),
            ZIndex = 3,
        })
        create("UIStroke", {
            Parent = handle,
            Color = Themes.preset.outline,
            LineJoinMode = Enum.LineJoinMode.Miter,
        })

        function cfg.set(val)
            val = clamp(floor(val / cfg.interval + 0.5) * cfg.interval, cfg.min, cfg.max)
            val = tonumber(string.format("%." .. decimals .. "f", val))
            cfg.value = val
            local frac = (val - cfg.min) / (cfg.max - cfg.min)
            fill.Size = dim2(frac, 0, 1, 0)
            handle.Position = dim2(frac, 0, 0.5, 0)
            valLbl.Text = tostring(val) .. cfg.suffix
            flags[cfg.flag] = val
            cfg.callback(val)
        end

        local function fromMouse()
            local m = UIS:GetMouseLocation()
            local frac = clamp((m.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            cfg.set(cfg.min + (cfg.max - cfg.min) * frac)
        end
        track.MouseButton1Down:Connect(function()
            cfg.dragging = true
            fromMouse()
        end)
        connection(UIS.InputChanged, function(i)
            if cfg.dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                fromMouse()
            end
        end)
        connection(UIS.InputEnded, function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                cfg.dragging = false
            end
        end)

        config_flags[cfg.flag] = cfg.set
        cfg.set(opts.default or cfg.min)
        return cfg
    end

    function Library:keybind(opts, parentOverride)
        opts = opts or {}
        local cfg = {
            flag = opts.flag or "keybind",
            callback = opts.callback or function() end,
            key = opts.key or Enum.KeyCode.Unknown,
            mode = opts.mode or "toggle",
            active = false,
            name = opts.name or "keybind",
        }

        local parent = parentOverride or (self.currentSection and self.currentSection.body) or self.holder
        local row = create("Frame", {
            Parent = parent,
            Size = dim2(1, 0, 0, 18),
            BackgroundTransparency = 1,
            LayoutOrder = self.order or 0,
        })
        if self.order then self.order = self.order + 1 end

        create("TextLabel", {
            Parent = row,
            Text = cfg.name,
            TextColor3 = Themes.preset.text,
            Size = dim2(0.5, 0, 1, 0),
            FontFace = FONT,
            TextSize = 12,
        })

        local btn = create("TextButton", {
            Parent = row,
            AnchorPoint = Vector2.new(1, 0),
            Position = dim2(1, 0, 0, 2),
            Size = dim2(0, 50, 0, 14),
            BackgroundColor3 = Themes.preset.outline,
            Text = "",
        })
        apply_theme(btn, "outline", "BackgroundColor3")
        create("UIStroke", {
            Parent = btn,
            Color = Themes.preset.inline,
            LineJoinMode = Enum.LineJoinMode.Miter,
        })

        local inline = create("Frame", {
            Parent = btn,
            Position = dim2(0, 1, 0, 1),
            Size = dim2(1, -2, 1, -2),
            BackgroundColor3 = Themes.preset.high_contrast,
        })
        apply_theme(inline, "high_contrast", "BackgroundColor3")

        local keyText = create("TextLabel", {
            Parent = inline,
            Size = dim2(1, 0, 1, 0),
            Text = "NONE",
            TextXAlignment = Enum.TextXAlignment.Center,
            TextColor3 = Themes.preset.text,
            FontFace = FONT,
            TextSize = 11,
        })
        apply_theme(keyText, "text", "TextColor3")

        function cfg.set(input)
            if typeof(input) == "EnumItem" then
                cfg.key = input
                keyText.Text = getKeyName(input)
            elseif type(input) == "table" then
                cfg.key = input.key or cfg.key
                cfg.mode = input.mode or cfg.mode
                cfg.active = input.active or cfg.active
                keyText.Text = getKeyName(cfg.key)
            end
            flags[cfg.flag] = {key = cfg.key, mode = cfg.mode, active = cfg.active}
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
        cfg.set({key = opts.key, mode = opts.mode or "toggle", active = opts.default or false})
        return cfg
    end

    function Library:button(opts)
        opts = opts or {}
        local parent = self.currentSection and self.currentSection.body or self.holder
        local btn = create("TextButton", {
            Parent = parent,
            Size = dim2(1, 0, 0, 20),
            BackgroundColor3 = Themes.preset.outline,
            Text = opts.name or "button",
            TextColor3 = Themes.preset.text,
            FontFace = FONT,
            TextSize = 12,
            LayoutOrder = self.order or 0,
        })
        if self.order then self.order = self.order + 1 end
        apply_theme(btn, "outline", "BackgroundColor3")
        create("UIStroke", {
            Parent = btn,
            Color = Themes.preset.inline,
            LineJoinMode = Enum.LineJoinMode.Miter,
        })

        local inline = create("Frame", {
            Parent = btn,
            Position = dim2(0, 1, 0, 1),
            Size = dim2(1, -2, 1, -2),
            BackgroundColor3 = Themes.preset.high_contrast,
            ZIndex = 1,
        })
        apply_theme(inline, "high_contrast", "BackgroundColor3")

        local text = create("TextLabel", {
            Parent = inline,
            Size = dim2(1, 0, 1, 0),
            Text = opts.name or "button",
            TextColor3 = Themes.preset.text,
            TextXAlignment = Enum.TextXAlignment.Center,
            FontFace = FONT,
            TextSize = 12,
            ZIndex = 2,
        })
        apply_theme(text, "text", "TextColor3")

        btn.MouseButton1Click:Connect(function()
            text.TextColor3 = Themes.preset.accent
            tween(text, {TextColor3 = Themes.preset.text}, 0.3)
            if opts.callback then opts.callback() end
        end)
        return btn
    end

    function Library:label(opts)
        opts = opts or {}
        local parent = self.currentSection and self.currentSection.body or self.holder
        local row = create("Frame", {
            Parent = parent,
            Size = dim2(1, 0, 0, 16),
            BackgroundTransparency = 1,
            LayoutOrder = self.order or 0,
        })
        if self.order then self.order = self.order + 1 end

        local lbl = create("TextLabel", {
            Parent = row,
            Text = opts.name or opts.text or "label",
            TextColor3 = Themes.preset.text,
            Size = dim2(1, -30, 1, 0),
            FontFace = FONT,
            TextSize = 12,
        })
        apply_theme(lbl, "text", "TextColor3")

        local right = create("Frame", {
            Parent = row,
            AnchorPoint = Vector2.new(1, 0),
            Position = dim2(1, 0, 0, 0),
            Size = dim2(0, 0, 1, 0),
            AutomaticSize = Enum_X,
            BackgroundTransparency = 1,
        })
        create("UIListLayout", {
            Parent = right,
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = dim(0, 4),
        })

        local e = {
            lib = self,
            right = right,
            lbl = lbl,
        }
        function e.set(t) lbl.Text = t end

        local mt = {
            colorpicker = function(_, o)
                return self:colorpicker(o, right)
            end,
            keybind = function(_, o)
                return self:keybind(o, right)
            end,
        }
        return setmetatable(e, {__index = mt})
    end

    function Library:textbox(opts)
        opts = opts or {}
        local cfg = {
            flag = opts.flag or "textbox",
            callback = opts.callback or function() end,
            placeholder = opts.placeholder or "",
        }
        local parent = self.currentSection and self.currentSection.body or self.holder
        local row = create("Frame", {
            Parent = parent,
            Size = dim2(1, 0, 0, 22),
            BackgroundTransparency = 1,
            LayoutOrder = self.order or 0,
        })
        if self.order then self.order = self.order + 1 end

        local box = create("TextBox", {
            Parent = row,
            Size = dim2(1, 0, 1, 0),
            BackgroundColor3 = Themes.preset.outline,
            Text = "",
            PlaceholderText = cfg.placeholder,
            TextColor3 = Themes.preset.text,
            PlaceholderColor3 = rgb(80, 80, 80),
            ClearTextOnFocus = false,
            FontFace = FONT,
            TextSize = 12,
        })
        apply_theme(box, "outline", "BackgroundColor3")
        create("UIStroke", {
            Parent = box,
            Color = Themes.preset.inline,
            LineJoinMode = Enum.LineJoinMode.Miter,
        })
        create("UIPadding", {
            Parent = box,
            PaddingLeft = dim(0, 8),
        })

        box:GetPropertyChangedSignal("Text"):Connect(function()
            flags[cfg.flag] = box.Text
            cfg.callback(box.Text)
        end)

        function cfg.set(t)
            box.Text = tostring(t or "")
            flags[cfg.flag] = box.Text
        end
        config_flags[cfg.flag] = cfg.set
        if opts.default then cfg.set(opts.default) end
        return cfg
    end

    function Library:get_config()
        local Config = {}
        for k, v in pairs(flags) do
            if type(v) == "table" and v.key then
                Config[k] = {active = v.active, mode = v.mode, key = tostring(v.key)}
            elseif type(v) == "table" and v.Color then
                Config[k] = {Transparency = v.Transparency, Color = v.Color:ToHex()}
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

    return Library, Themes
end

local Library, Themes = Library, Themes
return Library
