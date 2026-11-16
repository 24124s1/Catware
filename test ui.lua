local uis = cloneref(game:GetService("UserInputService"))
local players = cloneref(game:GetService("Players"))
local ws = cloneref(game:GetService("Workspace"))
local http_service = cloneref(game:GetService("HttpService"))
local gui_service = cloneref(game:GetService("GuiService"))
local lighting = cloneref(game:GetService("Lighting"))
local run = cloneref(game:GetService("RunService"))
local tween_service = cloneref(game:GetService("TweenService"))

local vec2 = Vector2.new
local dim2 = UDim2.new
local dim = UDim.new 
local rect = Rect.new
local cfr = CFrame.new
local angle = CFrame.Angles
local dim_offset = UDim2.fromOffset

local rgb = Color3.fromRGB
local hex = Color3.fromHex
local rgbseq = ColorSequence.new
local rgbkey = ColorSequenceKeypoint.new

local camera = ws.CurrentCamera
local lp = players.LocalPlayer 
local mouse = lp:GetMouse() 
local gui_offset = gui_service:GetGuiInset().Y

local clamp = math.clamp
local floor = math.floor
local insert = table.insert 

local library = {
    directory = "CleanUI",
    folders = { "/fonts", "/configs", "/images" },
    flags = {},
    config_flags = {},
    visible_flags = {}, 
    guis = {}, 
    connections = {},   
    notifications = {},
    playerlist_data = {},
    current_tab, 
    current_element_open, 
    dock_button_holder,  
    old_config,
    font, 
    keybind_list,
    binds = {}, 
    copied_flag,
    is_rainbow,
    instances = {}, 
    drawings = {},
    display_orders = 0
}

local flags = library.flags
local config_flags = library.config_flags

local themes = {
    preset = {
        ["outline"] = hex("#0A0A0A"),
        ["inline"] = hex("#2D2D2D"),
        ["accent"] = hex("#6078BE"),
        ["high_contrast"] = hex("#141414"),
        ["low_contrast"] = hex("#1E1E1E"),
        ["text"] = hex("#B4B4B4"),
        ["text_outline"] = rgb(0, 0, 0),
        ["glow"] = hex("#6078BE"), 
    },
    utility = {
        ["outline"] = { ["BackgroundColor3"] = {}, ["Color"] = {} },
        ["inline"] = { ["BackgroundColor3"] = {}, ["ImageColor3"] = {} },
        ["accent"] = { ["BackgroundColor3"] = {}, ["TextColor3"] = {}, ["ImageColor3"] = {}, ["ScrollBarImageColor3"] = {} },
        ["contrast"] = { ["Color"] = {} },
        ["text"] = { ["TextColor3"] = {} },
        ["text_outline"] = { ["Color"] = {} },
        ["glow"] = { ["ImageColor3"] = {} }, 
        ["high_contrast"] = { ["BackgroundColor3"] = {} },
        ["low_contrast"] = { ["BackgroundColor3"] = {} }
    }
}

library.__index = library

for _, path in next, library.folders do 
    makefolder(library.directory .. path)
end 

if not isfile("clean_ui_font.ttf") then
    writefile("clean_ui_font.ttf", game:HttpGet("https://github.com/weasely111/beta/raw/refs/heads/main/fs-tahoma-8px.ttf"))
end

local tahoma = {
    name = "SmallestPixel7",
    faces = { { name = "Regular", weight = 400, style = "normal", assetId = getcustomasset("clean_ui_font.ttf") } }
}

if not isfile("clean_ui_font_json.json") then
    writefile("clean_ui_font_json.json", http_service:JSONEncode(tahoma))
end

library.font = Font.new(getcustomasset("clean_ui_font_json.json"), Enum.FontWeight.Regular)

local config_holder 

function library:apply_theme(instance, theme, property) 
    if themes.utility[theme] and themes.utility[theme][property] then
        insert(themes.utility[theme][property], instance)
    end
end

function library:tween(obj, properties) 
    return tween_service:Create(obj, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), properties):Play()
end 

function library:connection(signal, callback)
    local connection = signal:Connect(callback)
    insert(library.connections, connection)
    return connection 
end

function library:create(instance, options)
    local ins = Instance.new(instance) 
    for prop, value in next, options do 
        ins[prop] = value
    end
    if instance == "TextLabel" or instance == "TextButton" or instance == "TextBox" then 	
        library:apply_theme(ins, "text", "TextColor3")
        library:create("UIStroke", { Parent = ins, Color = themes.preset.text_outline })
    elseif instance == "ScreenGui" then 
        insert(library.guis, ins)
    end
    return ins 
end

function library:draggify(frame)
    local dragging = false 
    local start_size = frame.Position
    local start 

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            start = input.Position
            start_size = frame.Position
            if frame.Parent:IsA("ScreenGui") and frame.Parent.DisplayOrder ~= 999999 then 
                library.display_orders += 1
                frame.Parent.DisplayOrder = library.display_orders
            end   
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    library:connection(uis.InputChanged, function(input) 
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            frame.Position = dim2(
                0, clamp(start_size.X.Offset + (input.Position.X - start.X), 0, camera.ViewportSize.X - frame.Size.X.Offset),
                0, clamp(start_size.Y.Offset + (input.Position.Y - start.Y), 0, camera.ViewportSize.Y - frame.Size.Y.Offset)
            )
        end
    end)
end

function library:section(options)
    local cfg = { items = {}, name = options.name or "Section" }
    
    local section = library:create("Frame", {
        Parent = self.holder, Name = "", BorderColor3 = rgb(0, 0, 0), Size = dim2(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y, BorderSizePixel = 0, BackgroundColor3 = themes.preset.inline
    })
    library:apply_theme(section, "inline", "BackgroundColor3")

    local inline = library:create("Frame", {
        Parent = section, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = themes.preset.outline
    }) library:apply_theme(inline, "outline", "BackgroundColor3")

    local background = library:create("Frame", {
        Parent = inline, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255)
    })

    local UIGradient = library:create("UIGradient", {
        Parent = background, Rotation = 90, Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))}
    }) library:apply_theme(UIGradient, "contrast", "Color")

    local text = library:create("TextLabel", {
        Parent = background, FontFace = library.font, TextColor3 = themes.preset.text, BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name, BackgroundTransparency = 1, Position = dim2(0, 7, 0, 5), Size = dim2(1, 0, 0, 0),
        BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    })
    library:create("UIStroke", { Parent = text })

    local content_holder = library:create("Frame", {
        Parent = background, Name = "", BackgroundTransparency = 1, Position = dim2(0, 0, 0, 22),
        Size = dim2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BorderSizePixel = 0,
    })
    
    library:create("UIListLayout", { Parent = content_holder, Padding = dim(0, 4), SortOrder = Enum.SortOrder.LayoutOrder })
    library:create("UIPadding", { Parent = content_holder, PaddingBottom = dim(0, 6), PaddingRight = dim(0, 6), PaddingLeft = dim(0, 6) })

    cfg.holder = content_holder
    return setmetatable(cfg, library)
end

function library:label(options)
    local cfg = { name = options.name or "Label" }
    local label = library:create("TextLabel", {
        Parent = self.holder, FontFace = library.font, TextColor3 = themes.preset.text, BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name, BackgroundTransparency = 1, Size = dim2(1, 0, 0, 16), BorderSizePixel = 0,
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    })
    cfg.set = function(text) label.Text = text end
    return setmetatable(cfg, library)
end

function library:button_holder(options)
    local holder = library:create("Frame", {
        Parent = self.holder, Name = "", BackgroundTransparency = 1, Size = dim2(1, 0, 0, 18), BorderSizePixel = 0
    })
    library:create("UIListLayout", { Parent = holder, FillDirection = Enum.FillDirection.Horizontal, Padding = dim(0, 4), SortOrder = Enum.SortOrder.LayoutOrder })
    return setmetatable({ holder = holder }, library)
end

function library:button(options)
    local cfg = { name = options.name or "Button", callback = options.callback or function() end }
    local btn = library:create("TextButton", {
        Parent = self.holder, FontFace = library.font, TextColor3 = themes.preset.text, BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name, Size = dim2(1, 0, 0, 24), BorderSizePixel = 0, BackgroundColor3 = themes.preset.inline
    }) library:apply_theme(btn, "inline", "BackgroundColor3")
    
    local inline = library:create("Frame", {
        Parent = btn, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = themes.preset.outline
    }) library:apply_theme(inline, "outline", "BackgroundColor3")
    
    local bg = library:create("Frame", {
        Parent = inline, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255)
    })
    library:create("UIGradient", { Parent = bg, Rotation = 90, Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))} })
    
    btn.MouseButton1Click:Connect(cfg.callback)
    return setmetatable(cfg, library)
end

function library:toggle(options)
    local cfg = { name = options.name or "Toggle", flag = options.flag, default = options.default or false, callback = options.callback or function() end }
    flags[cfg.flag] = cfg.default
    
    local toggle = library:create("TextButton", {
        Parent = self.holder, FontFace = library.font, TextColor3 = themes.preset.text, BorderColor3 = rgb(0, 0, 0),
        Text = "", Size = dim2(1, 0, 0, 24), BorderSizePixel = 0, BackgroundColor3 = themes.preset.inline, AutoButtonColor = false
    }) library:apply_theme(toggle, "inline", "BackgroundColor3")
    
    local inline = library:create("Frame", {
        Parent = toggle, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = themes.preset.outline
    }) library:apply_theme(inline, "outline", "BackgroundColor3")
    
    local bg = library:create("Frame", {
        Parent = inline, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255)
    })
    library:create("UIGradient", { Parent = bg, Rotation = 90, Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))} })
    
    local label = library:create("TextLabel", {
        Parent = bg, FontFace = library.font, TextColor3 = themes.preset.text, BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name, BackgroundTransparency = 1, Position = dim2(0, 7, 0, 0), Size = dim2(1, -20, 1, 0),
        BorderSizePixel = 0, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local indicator = library:create("Frame", {
        Parent = bg, Name = "", AnchorPoint = vec2(1, 0.5), Position = dim2(1, -7, 0.5, 0),
        BorderColor3 = rgb(0, 0, 0), Size = dim2(0, 12, 0, 12), BorderSizePixel = 0, BackgroundColor3 = themes.preset.outline
    }) library:apply_theme(indicator, "outline", "BackgroundColor3")
    
    local ind_inline = library:create("Frame", {
        Parent = indicator, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = themes.preset.inline
    }) library:apply_theme(ind_inline, "inline", "BackgroundColor3")
    
    local ind_bg = library:create("Frame", {
        Parent = ind_inline, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = themes.preset.accent
    }) library:apply_theme(ind_bg, "accent", "BackgroundColor3")
    
    if not cfg.default then ind_bg.BackgroundTransparency = 1 end
    
    local function set(bool)
        flags[cfg.flag] = bool
        library:tween(ind_bg, { BackgroundTransparency = bool and 0 or 1 })
        cfg.callback(bool)
    end
    
    toggle.MouseButton1Click:Connect(function() set(not flags[cfg.flag]) end)
    cfg.set = set
    return setmetatable(cfg, library)
end

function library:slider(options)
    local cfg = { name = options.name or "Slider", flag = options.flag, min = options.min or 0, max = options.max or 100, default = options.default or 50, callback = options.callback or function() end }
    flags[cfg.flag] = cfg.default
    
    local slider = library:create("Frame", {
        Parent = self.holder, Name = "", Size = dim2(1, 0, 0, 32), BorderSizePixel = 0, BackgroundColor3 = themes.preset.inline
    }) library:apply_theme(slider, "inline", "BackgroundColor3")
    
    local inline = library:create("Frame", {
        Parent = slider, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = themes.preset.outline
    }) library:apply_theme(inline, "outline", "BackgroundColor3")
    
    local bg = library:create("Frame", {
        Parent = inline, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255)
    })
    library:create("UIGradient", { Parent = bg, Rotation = 90, Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))} })
    
    local label = library:create("TextLabel", {
        Parent = bg, FontFace = library.font, TextColor3 = themes.preset.text, BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name, BackgroundTransparency = 1, Position = dim2(0, 7, 0, 2), Size = dim2(1, -20, 0, 14),
        BorderSizePixel = 0, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local val_label = library:create("TextLabel", {
        Parent = bg, FontFace = library.font, TextColor3 = themes.preset.text, BorderColor3 = rgb(0, 0, 0),
        Text = tostring(cfg.default), BackgroundTransparency = 1, Position = dim2(0, 0, 0, 2), Size = dim2(1, -7, 0, 14),
        BorderSizePixel = 0, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right,
    })
    
    local bar_holder = library:create("Frame", {
        Parent = bg, Name = "", Position = dim2(0, 7, 1, -10), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -14, 0, 4), BorderSizePixel = 0, BackgroundColor3 = themes.preset.outline
    }) library:apply_theme(bar_holder, "outline", "BackgroundColor3")
    
    local bar = library:create("Frame", {
        Parent = bar_holder, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2((cfg.default - cfg.min) / (cfg.max - cfg.min), -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = themes.preset.accent
    }) library:apply_theme(bar, "accent", "BackgroundColor3")
    
    local dragging = false
    
    local function update(input)
        local percent = clamp((input.Position.X - bar_holder.AbsolutePosition.X) / bar_holder.AbsoluteSize.X, 0, 1)
        local value = floor(cfg.min + (cfg.max - cfg.min) * percent + 0.5)
        flags[cfg.flag] = value
        val_label.Text = tostring(value)
        library:tween(bar, { Size = dim2(percent, -2, 1, -2) })
        cfg.callback(value)
    end
    
    bar_holder.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(input)
        end
    end)
    
    library:connection(uis.InputChanged, function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
    end)
    
    library:connection(uis.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    
    cfg.set = function(val)
        flags[cfg.flag] = val
        val_label.Text = tostring(val)
        local percent = (val - cfg.min) / (cfg.max - cfg.min)
        library:tween(bar, { Size = dim2(percent, -2, 1, -2) })
        cfg.callback(val)
    end
    return setmetatable(cfg, library)
end

function library:dropdown(options)
    local cfg = { name = options.name or "Dropdown", flag = options.flag, items = options.items or {}, default = options.default or options.items[1], callback = options.callback or function() end, open = false }
    flags[cfg.flag] = cfg.default
    
    local drop = library:create("TextButton", {
        Parent = self.holder, FontFace = library.font, TextColor3 = themes.preset.text, BorderColor3 = rgb(0, 0, 0),
        Text = "", Size = dim2(1, 0, 0, 24), BorderSizePixel = 0, BackgroundColor3 = themes.preset.inline, AutoButtonColor = false
    }) library:apply_theme(drop, "inline", "BackgroundColor3")
    
    local inline = library:create("Frame", {
        Parent = drop, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = themes.preset.outline
    }) library:apply_theme(inline, "outline", "BackgroundColor3")
    
    local bg = library:create("Frame", {
        Parent = inline, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255), ClipsDescendants = true
    })
    library:create("UIGradient", { Parent = bg, Rotation = 90, Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))} })
    
    local label = library:create("TextLabel", {
        Parent = bg, FontFace = library.font, TextColor3 = themes.preset.text, BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name, BackgroundTransparency = 1, Position = dim2(0, 7, 0, 0), Size = dim2(1, -20, 0, 22),
        BorderSizePixel = 0, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local val_label = library:create("TextLabel", {
        Parent = bg, FontFace = library.font, TextColor3 = themes.preset.accent, BorderColor3 = rgb(0, 0, 0),
        Text = tostring(cfg.default), BackgroundTransparency = 1, Position = dim2(0, 0, 0, 0), Size = dim2(1, -7, 0, 22),
        BorderSizePixel = 0, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right,
    })
    
    local container = library:create("Frame", {
        Parent = drop, Name = "", Position = dim2(0, 0, 1, 2), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BorderSizePixel = 0, BackgroundColor3 = themes.preset.outline, Visible = false, ZIndex = 10
    }) library:apply_theme(container, "outline", "BackgroundColor3")
    
    local cont_inline = library:create("Frame", {
        Parent = container, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = themes.preset.inline, ZIndex = 10
    }) library:apply_theme(cont_inline, "inline", "BackgroundColor3")
    
    local list = library:create("Frame", {
        Parent = cont_inline, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255), ZIndex = 10
    })
    library:create("UIGradient", { Parent = list, Rotation = 90, Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))} })
    library:create("UIListLayout", { Parent = list, Padding = dim(0, 2), SortOrder = Enum.SortOrder.LayoutOrder })
    library:create("UIPadding", { Parent = list, PaddingTop = dim(0, 2), PaddingBottom = dim(0, 2) })

    for _, item in next, cfg.items do 
        local btn = library:create("TextButton", {
            Parent = list, FontFace = library.font, TextColor3 = themes.preset.text, BorderColor3 = rgb(0, 0, 0),
            Text = item, Size = dim2(1, 0, 0, 20), BorderSizePixel = 0, BackgroundTransparency = 1, TextSize = 12, ZIndex = 10
        })
        btn.MouseButton1Click:Connect(function()
            flags[cfg.flag] = item
            val_label.Text = item
            container.Visible = false
            cfg.open = false
            cfg.callback(item)
        end)
    end

    drop.MouseButton1Click:Connect(function()
        cfg.open = not cfg.open
        container.Visible = cfg.open
    end)
    
    cfg.refresh_options = function(new_items)
        for _, child in next, list:GetChildren() do if child:IsA("TextButton") then child:Destroy() end end
        for _, item in next, new_items do 
            local btn = library:create("TextButton", {
                Parent = list, FontFace = library.font, TextColor3 = themes.preset.text, BorderColor3 = rgb(0, 0, 0),
                Text = item, Size = dim2(1, 0, 0, 20), BorderSizePixel = 0, BackgroundTransparency = 1, TextSize = 12, ZIndex = 10
            })
            btn.MouseButton1Click:Connect(function()
                flags[cfg.flag] = item
                val_label.Text = item
                container.Visible = false
                cfg.open = false
                cfg.callback(item)
            end)
        end
    end
    return setmetatable(cfg, library)
end

function library:textbox(options)
    local cfg = { name = options.flag or "Textbox", flag = options.flag, default = options.default or "", callback = options.callback or function() end }
    flags[cfg.flag] = cfg.default
    
    local box = library:create("Frame", {
        Parent = self.holder, Name = "", Size = dim2(1, 0, 0, 24), BorderSizePixel = 0, BackgroundColor3 = themes.preset.inline
    }) library:apply_theme(box, "inline", "BackgroundColor3")
    
    local inline = library:create("Frame", {
        Parent = box, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = themes.preset.outline
    }) library:apply_theme(inline, "outline", "BackgroundColor3")
    
    local bg = library:create("Frame", {
        Parent = inline, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255)
    })
    library:create("UIGradient", { Parent = bg, Rotation = 90, Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))} })
    
    local text_box = library:create("TextBox", {
        Parent = bg, FontFace = library.font, TextColor3 = themes.preset.text, BorderColor3 = rgb(0, 0, 0),
        Text = cfg.default, PlaceholderText = "Input...", BackgroundTransparency = 1, Position = dim2(0, 7, 0, 0),
        Size = dim2(1, -14, 1, 0), BorderSizePixel = 0, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false
    })
    
    text_box.FocusLost:Connect(function()
        flags[cfg.flag] = text_box.Text
        cfg.callback(text_box.Text)
    end)
    return setmetatable(cfg, library)
end

function library:keybind(options)
    local cfg = { key = options.key or Enum.KeyCode.Insert, callback = options.callback or function() end }
    
    local btn = library:create("TextButton", {
        Parent = self.holder, FontFace = library.font, TextColor3 = themes.preset.text, BorderColor3 = rgb(0, 0, 0),
        Text = cfg.key.Name, Size = dim2(1, 0, 0, 24), BorderSizePixel = 0, BackgroundColor3 = themes.preset.inline
    }) library:apply_theme(btn, "inline", "BackgroundColor3")
    
    local inline = library:create("Frame", {
        Parent = btn, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = themes.preset.outline
    }) library:apply_theme(inline, "outline", "BackgroundColor3")
    
    local bg = library:create("Frame", {
        Parent = inline, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255)
    })
    library:create("UIGradient", { Parent = bg, Rotation = 90, Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))} })

    local listening = false
    btn.MouseButton1Click:Connect(function()
        listening = true
        btn.Text = "..."
    end)

    library:connection(uis.InputBegan, function(input)
        if listening then
            if input.KeyCode ~= Enum.KeyCode.Unknown then
                cfg.key = input.KeyCode
                btn.Text = cfg.key.Name
                listening = false
            end
        elseif input.KeyCode == cfg.key then
            cfg.callback()
        end
    end)
    return setmetatable(cfg, library)
end

function library:colorpicker(options)
    local cfg = { name = options.name or "Color", flag = options.flag, color = options.color or rgb(255,255,255), callback = options.callback or function() end }
    flags[cfg.flag] = { Color = cfg.color }
    
    local btn = library:create("TextButton", {
        Parent = self.holder, FontFace = library.font, TextColor3 = themes.preset.text, BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name, Size = dim2(1, 0, 0, 24), BorderSizePixel = 0, BackgroundColor3 = themes.preset.inline
    }) library:apply_theme(btn, "inline", "BackgroundColor3")
    
    local inline = library:create("Frame", {
        Parent = btn, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = themes.preset.outline
    }) library:apply_theme(inline, "outline", "BackgroundColor3")
    
    local bg = library:create("Frame", {
        Parent = inline, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255)
    })
    library:create("UIGradient", { Parent = bg, Rotation = 90, Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))} })
    
    local label = library:create("TextLabel", {
        Parent = bg, FontFace = library.font, TextColor3 = themes.preset.text, BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name, BackgroundTransparency = 1, Position = dim2(0, 7, 0, 0), Size = dim2(1, -20, 1, 0),
        BorderSizePixel = 0, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local ind = library:create("Frame", {
        Parent = bg, Name = "", AnchorPoint = vec2(1, 0.5), Position = dim2(1, -7, 0.5, 0),
        BorderColor3 = rgb(0, 0, 0), Size = dim2(0, 12, 0, 12), BorderSizePixel = 0, BackgroundColor3 = cfg.color
    })
    
    btn.MouseButton1Click:Connect(function()
        local new_col = rgb(math.random(0,255), math.random(0,255), math.random(0,255))
        ind.BackgroundColor3 = new_col
        flags[cfg.flag] = { Color = new_col }
        cfg.callback(new_col, 1)
    end)
    return setmetatable(cfg, library)
end

function library:list(options)
    return library:dropdown(options)
end

function library:playerlist(options)
    local cfg = { holder = self.holder }
    local frame = library:create("ScrollingFrame", {
        Parent = cfg.holder, Size = dim2(1, 0, 0, 150), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2
    })
    library:create("UIListLayout", { Parent = frame, Padding = dim(0, 2), SortOrder = Enum.SortOrder.LayoutOrder })
    return setmetatable(cfg, library)
end

function library:multi_section(options)
    local cfg = { names = options.names or {"First", "Second"}, sections = {} }
    local frame = library:create("Frame", {
        Parent = self.holder, Size = dim2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1
    })
    library:create("UIListLayout", { Parent = frame, Padding = dim(0, 4), SortOrder = Enum.SortOrder.LayoutOrder })
    
    for _, name in next, cfg.names do 
        local sec = setmetatable({ holder = frame }, library):section({ name = name })
        cfg.sections[name] = sec
    end
    return setmetatable(cfg, library)
end

function library:window(properties)
    local window = {opened = true}            
    local opened = {}
    local blur = library:create("BlurEffect", { Parent = lighting, Enabled = true, Size = 15 })    

    library.cache = library:create("ScreenGui", { Enabled = false, Parent = gethui(), Name = "" })
    
    local sgui = library:create("ScreenGui", { Enabled = true, Parent = gethui(), Name = "", DisplayOrder = 999999 })
    local notif_holder = library:create("ScreenGui", { Parent = gethui(), Name = "", IgnoreGuiInset = true, DisplayOrder = 999999 })

    local dock_outline = library:create("Frame", {
        Parent = sgui, Name = "", Visible = true, BorderColor3 = rgb(0, 0, 0), AnchorPoint = vec2(0.5, 0),
        Position = dim2(0.5, 0, 0, 20), Size = dim2(0, 157, 0, 39), BorderSizePixel = 0, BackgroundColor3 = themes.preset.outline
    }) 
    library:apply_theme(dock_outline, "outline", "BackgroundColor3") 
    dock_outline.Position = dim2(0, dock_outline.AbsolutePosition.X, 0, dock_outline.AbsolutePosition.Y) 
    dock_outline.AnchorPoint = vec2(0, 0) 
    library:draggify(dock_outline)

    local dock_inline = library:create("Frame", {
        Parent = dock_outline, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = themes.preset.inline
    }) library:apply_theme(dock_inline, "inline", "BackgroundColor3") 
    
    local button_holder = library:create("Frame", {
        Parent = dock_inline, Name = "", BackgroundTransparency = 1, Size = dim2(1, -2, 1, -2),
        Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255)
    }) library.dock_holder = button_holder
    
    library:create("UIListLayout", { Parent = button_holder, Padding = dim(0, 5), FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder })
    library:create("UIPadding", { Parent = button_holder, PaddingTop = dim(0, 6), PaddingBottom = dim(0, 4), PaddingRight = dim(0, 4), PaddingLeft = dim(0, 4) })
                
    local main_window = library:panel({
        name = properties and properties.name or "CleanUI", 
        size = dim2(0, 604, 0, 628),
        position = dim2(0, (camera.ViewportSize.X / 2) - 302 - 96, 0, (camera.ViewportSize.Y / 2) - 421 - 12),
        image = "rbxassetid://98823308062942",
    })

    local items = main_window.items

    window["tab_holder"] = library:create("Frame", {
        Parent = items.holder, Name = " ", BackgroundTransparency = 1, Size = dim2(1, 0, 0, 22),
        BorderColor3 = rgb(0, 0, 0), ZIndex = 5, BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255)
    })

    library:create("UIListLayout", { Parent = window["tab_holder"], FillDirection = Enum.FillDirection.Horizontal, HorizontalFlex = Enum.UIFlexAlignment.Fill, Padding = dim(0, 2), SortOrder = Enum.SortOrder.LayoutOrder })

    local section_holder = library:create("Frame", {
        Parent = items.holder, Name = " ", BackgroundTransparency = 1, Position = dim2(0, -1, 0, 19),
        BorderColor3 = rgb(0, 0, 0), Size = dim2(1, 0, 1, -22), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255)
    })
    window["section_holder"] = section_holder

    local outline = library:create("Frame", {
        Parent = section_holder, Name = "\0", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 1, 2), BorderSizePixel = 0, BackgroundColor3 = themes.preset.outline
    })
    library:apply_theme(outline, "outline", "BackgroundColor3") 

    local inline = library:create("Frame", {
        Parent = outline, Name = "\0", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = themes.preset.inline
    })
    library:apply_theme(inline, "inline", "BackgroundColor3") 

    local background = library:create("Frame", {
        Parent = inline, Name = "\0", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255)
    })
    library.section_holder = background

    library:create("UIPadding", { Parent = background, PaddingTop = dim(0, 4), PaddingBottom = dim(0, 4), PaddingRight = dim(0, 4), PaddingLeft = dim(0, 4) })
    library:create("UIGradient", { Parent = background, Rotation = 90, Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))} })

    local esp_holder = library:panel({
        name = "ESP Preview", 
        anchor_point = vec2(0, 0),
        size = dim2(0, 300, 0, 325),
        position = dim2(0, main_window.items.main_holder.AbsolutePosition.X + main_window.items.main_holder.AbsoluteSize.X + 2, 0, main_window.items.main_holder.AbsolutePosition.Y),
        image = "rbxassetid://77684377836328",
    })
    
    local esp_col = setmetatable(esp_holder.items, library):column() 
    window.esp_section = esp_col:section({name = "Main"})

    return setmetatable(window, library)
end

function library:panel(options) 
    local cfg = { name = options.text or options.name or "Window", size = options.size or dim2(0, 530, 0, 590), position = options.position or dim2(0, 500, 0, 500), anchor_point = options.anchor_point or vec2(0, 0), image = options.image or "", items = {} }
    local items = cfg.items do 
        items.sgui = library:create("ScreenGui", { Enabled = true, Parent = gethui(), Name = "" })
        items.main_holder = library:create("Frame", {
            Parent = items.sgui, Name = "", AnchorPoint = vec2(cfg.anchor_point.X, cfg.anchor_point.Y), Position = cfg.position,
            Active = true, BorderColor3 = rgb(0, 0, 0), Size = cfg.size, BorderSizePixel = 0, BackgroundColor3 = themes.preset.outline
        })
        library:draggify(items.main_holder)

        local Close = library:create("TextButton", {
            Parent = items.main_holder, FontFace = library.font, Name = "\0", AnchorPoint = vec2(1, 0), Active = false,
            BorderColor3 = rgb(0, 0, 0), Text = "X", Size = dim2(0, 0, 0, 0), Position = dim2(1, -7, 0, 5),
            BorderSizePixel = 0, BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Right, AutomaticSize = Enum.AutomaticSize.XY, TextSize = 12, ZIndex = 100
        })
        Close.MouseButton1Click:Connect(function() items.sgui.Enabled = false end)

        items.window_inline = library:create("Frame", { Parent = items.main_holder, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0), Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = themes.preset.accent })
        library:apply_theme(items.window_inline, "accent", "BackgroundColor3") 
        
        items.window_holder = library:create("Frame", { Parent = items.window_inline, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = themes.preset.outline, Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255) })
        library:create("UIGradient", { Parent = items.window_holder, Name = "", Rotation = 90, Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))} })
        
        items.text = library:create("TextLabel", { Parent = items.window_holder, Name = "", FontFace = library.font, TextColor3 = themes.preset.accent, BorderColor3 = rgb(0, 0, 0), Text = cfg.name, BackgroundTransparency = 1, Position = dim2(0, 2, 0, 4), BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.XY, TextSize = 12 })
        library:apply_theme(items.text, "accent", "TextColor3")
        
        items.outline = library:create("Frame", { Parent = items.window_holder, Name = "", Position = dim2(0, 0, 0, 18), BorderColor3 = rgb(0, 0, 0), Size = dim2(1, 0, 1, -18), BorderSizePixel = 0, BackgroundColor3 = themes.preset.inline })
        library:apply_theme(items.outline, "inline", "BackgroundColor3") 
        
        items.inline = library:create("Frame", { Parent = items.outline, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0), Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = themes.preset.outline })
        library:apply_theme(items.inline, "outline", "BackgroundColor3") 
        
        items.holder = library:create("Frame", { Parent = items.inline, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0), Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255) })
        library:create("UIGradient", { Parent = items.holder, Name = "", Rotation = 90, Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))} })
        library:create("UIPadding", { Parent = items.holder, Name = "", PaddingTop = dim(0, 5), PaddingBottom = dim(0, 5), PaddingRight = dim(0, 5), PaddingLeft = dim(0, 5) })
        
        items.button = library:create("TextButton", { Parent = library.dock_holder, Name = "", TextColor3 = rgb(0, 0, 0), BorderColor3 = rgb(0, 0, 0), Text = "", Size = dim2(0, 25, 0, 25), BorderSizePixel = 0, TextSize = 14, BackgroundColor3 = themes.preset.inline })
        local button_inline = library:create("Frame", { Parent = items.button, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0), Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = themes.preset.outline })
        library:apply_theme(button_inline, "outline", "BackgroundColor3") 
        
        local button_inline2 = library:create("Frame", { Parent = button_inline, Name = "", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0), Size = dim2(1, -2, 1, -2), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255) })
        library:apply_theme(button_inline2, "inline", "BackgroundColor3")
        
        items.Icon = library:create("ImageLabel", { Parent = button_inline2, Name = "", ImageColor3 = themes.preset.accent, Image = cfg.image, BackgroundTransparency = 1, BorderColor3 = rgb(0, 0, 0), Size = dim2(1, 0, 1, 0), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255) })
        library:apply_theme(items.Icon, "accent", "ImageColor3")
    end 

    items.sgui:GetPropertyChangedSignal("Enabled"):Connect(function()
        items.Icon.ImageColor3 = items.sgui.Enabled and themes.preset.accent or themes.preset.inline
    end)

    items.button.MouseButton1Click:Connect(function()
        items.sgui.Enabled = not items.sgui.Enabled
    end)
    
    return setmetatable(cfg, library)
end 

function library:tab(options)	
    local cfg = { name = options.name or "tab" }
    local tab_holder = library:create("TextButton", { Parent = self.tab_holder, FontFace = library.font, TextColor3 = themes.preset.text, BorderColor3 = rgb(0, 0, 0), Text = "", Name = "\0", BorderSizePixel = 0, Size = dim2(0, 0, 1, -2), ZIndex = 5, TextSize = 12, BackgroundColor3 = themes.preset.outline, AutoButtonColor = false })
    library:apply_theme(tab_holder, "outline", "BackgroundColor3") 

    local inline = library:create("Frame", { Parent = tab_holder, Size = dim2(1, -2, 1, 0), Name = "\0", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0), ZIndex = 5, BorderSizePixel = 0, BackgroundColor3 = themes.preset.inline })
    library:apply_theme(inline, "inline", "BackgroundColor3") 

    local background = library:create("Frame", { Parent = inline, Size = dim2(1, -2, 1, -1), Name = "\0", Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0), ZIndex = 5, BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255) })
    library:create("UIGradient", { Parent = background, Rotation = 90, Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))} }) 

    local text = library:create("TextLabel", { Parent = background, FontFace = library.font, TextColor3 = themes.preset.text, BorderColor3 = rgb(0, 0, 0), Text = cfg.name, Name = "\0", BackgroundTransparency = 1, Size = dim2(1, 0, 1, 0), BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.X, TextSize = 12, ZIndex = 5 })

    local section_holder = library:create("Frame", { Parent = library.section_holder, BackgroundTransparency = 1, Name = "\0", BorderColor3 = rgb(0, 0, 0), Size = dim2(1, 0, 1, 0), BorderSizePixel = 0, Visible = false })
    cfg["holder"] = section_holder
    library:create("UIListLayout", { Parent = section_holder, FillDirection = Enum.FillDirection.Horizontal, HorizontalFlex = Enum.UIFlexAlignment.Fill, Padding = dim(0, 4), SortOrder = Enum.SortOrder.LayoutOrder })

    function cfg.open_tab()
        if library.current_tab and library.current_tab[1] ~= background then 
            library.current_tab[1].Size = dim2(1, -2, 1, -1)
            library.current_tab[1]:FindFirstChildOfClass("UIGradient").Rotation = 90
            library.current_tab[1]:FindFirstChildOfClass("TextLabel").TextColor3 = themes.preset.text
            library.current_tab[2].Visible = false
        end
        library.current_tab = { background, section_holder }
        background.Size = dim2(1, -2, 1, 0)
        background:FindFirstChildOfClass("UIGradient").Rotation = -90
        text.TextColor3 = themes.preset.accent 
        section_holder.Visible = true 
    end
    
    tab_holder.MouseButton1Click:Connect(cfg.open_tab)
    return setmetatable(cfg, library) 
end

function library:column(path) 
    local cfg = {}
    local column = library:create("Frame", { Parent = path or self.holder, BackgroundTransparency = 1, Name = "\0", BorderColor3 = rgb(0, 0, 0), Size = dim2(1, 0, 1, 0), BorderSizePixel = 0 })
    library:create("UIListLayout", { Parent = column, Padding = dim(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, VerticalFlex = Enum.UIFlexAlignment.Fill })
    cfg["holder"] = column
    return setmetatable(cfg, library) 
end

return library
