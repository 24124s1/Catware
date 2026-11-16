local uis = cloneref(game:GetService("UserInputService"))
local players = cloneref(game:GetService("Players"))
local ws = cloneref(game:GetService("Workspace"))
local http_service = cloneref(game:GetService("HttpService"))
local gui_service = cloneref(game:GetService("GuiService"))
local lighting = cloneref(game:GetService("Lighting"))
local run = cloneref(game:GetService("RunService"))
local stats = cloneref(game:GetService("Stats"))
local coregui = cloneref(game:GetService("CoreGui"))
local debris = cloneref(game:GetService("Debris"))
local tween_service = cloneref(game:GetService("TweenService"))
local sound_service = cloneref(game:GetService("SoundService"))
local starter_gui = cloneref(game:GetService("StarterGui"))
local rs = cloneref(game:GetService("ReplicatedStorage"))

local vec2 = Vector2.new
local vec3 = Vector3.new
local dim2 = UDim2.new
local dim = UDim.new 
local rect = Rect.new
local cfr = CFrame.new
local empty_cfr = cfr()
local point_object_space = empty_cfr.PointToObjectSpace
local angle = CFrame.Angles
local dim_offset = UDim2.fromOffset

local color = Color3.new
local hsv = Color3.fromHSV
local rgb = Color3.fromRGB
local hex = Color3.fromHex
local rgbseq = ColorSequence.new
local rgbkey = ColorSequenceKeypoint.new
local numseq = NumberSequence.new
local numkey = NumberSequenceKeypoint.new

local camera = ws.CurrentCamera
local lp = players.LocalPlayer 
local mouse = lp:GetMouse() 
local gui_offset = gui_service:GetGuiInset().Y

local max = math.max 
local floor = math.floor 
local min = math.min 
local abs = math.abs 
local noise = math.noise
local rad = math.rad 
local random = math.random 
local pow = math.pow 
local sin = math.sin 
local pi = math.pi 
local tan = math.tan 
local atan2 = math.atan2 
local cos = math.cos 
local round = math.round
local clamp = math.clamp
local ceil = math.ceil
local sqrt = math.sqrt
local acos = math.acos

local insert = table.insert 
local find = table.find 
local remove = table.remove
local concat = table.concat

local library = {
    directory = "CleanUI",
    folders = {
        "/fonts",
        "/configs",
        "/images"
    },
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
        ["outline"] = {
            ["BackgroundColor3"] = {}, 	
            ["Color"] = {}, 
        },
        ["inline"] = {
            ["BackgroundColor3"] = {}, 	
            ["ImageColor3"] = {},
        },
        ["accent"] = {
            ["BackgroundColor3"] = {}, 	
            ["TextColor3"] = {}, 
            ["ImageColor3"] = {}, 
            ["ScrollBarImageColor3"] = {} 
        },
        ["contrast"] = {
            ["Color"] = {}, 	
        },
        ["text"] = {
            ["TextColor3"] = {}, 	
        },
        ["text_outline"] = {
            ["Color"] = {}, 	
        },
        ["glow"] = {
            ["ImageColor3"] = {}, 	
        }, 
        ["high_contrast"] = {
            ["BackgroundColor3"] = {},
        },
        ["low_contrast"] = {
            ["BackgroundColor3"] = {},
        }
    }, 
    find = {
        ["Frame"] = "BackgroundColor3", 
        ["TextLabel"] = "TextColor3", 
        ["UIGradient"] = "Color",
        ["UIStroke"] = "Color",
        ["ImageLabel"] = "ImageColor3",
        ["TextButton"] = "BackgroundColor3", 
        ["ScrollingFrame"] = "ScrollBarImageColor3"
    }
}

local keys = {
    [Enum.KeyCode.LeftShift] = "LS",
    [Enum.KeyCode.RightShift] = "RS",
    [Enum.KeyCode.LeftControl] = "LC",
    [Enum.KeyCode.RightControl] = "RC",
    [Enum.KeyCode.Insert] = "INS",
    [Enum.KeyCode.Backspace] = "BS",
    [Enum.KeyCode.Return] = "Ent",
    [Enum.KeyCode.LeftAlt] = "LA",
    [Enum.KeyCode.RightAlt] = "RA",
    [Enum.KeyCode.CapsLock] = "CAPS",
    [Enum.KeyCode.One] = "1",
    [Enum.KeyCode.Two] = "2",
    [Enum.KeyCode.Three] = "3",
    [Enum.KeyCode.Four] = "4",
    [Enum.KeyCode.Five] = "5",
    [Enum.KeyCode.Six] = "6",
    [Enum.KeyCode.Seven] = "7",
    [Enum.KeyCode.Eight] = "8",
    [Enum.KeyCode.Nine] = "9",
    [Enum.KeyCode.Zero] = "0",
    [Enum.KeyCode.KeypadOne] = "Num1",
    [Enum.KeyCode.KeypadTwo] = "Num2",
    [Enum.KeyCode.KeypadThree] = "Num3",
    [Enum.KeyCode.KeypadFour] = "Num4",
    [Enum.KeyCode.KeypadFive] = "Num5",
    [Enum.KeyCode.KeypadSix] = "Num6",
    [Enum.KeyCode.KeypadSeven] = "Num7",
    [Enum.KeyCode.KeypadEight] = "Num8",
    [Enum.KeyCode.KeypadNine] = "Num9",
    [Enum.KeyCode.KeypadZero] = "Num0",
    [Enum.KeyCode.Minus] = "-",
    [Enum.KeyCode.Equals] = "=",
    [Enum.KeyCode.Tilde] = "~",
    [Enum.KeyCode.LeftBracket] = "[",
    [Enum.KeyCode.RightBracket] = "]",
    [Enum.KeyCode.RightParenthesis] = ")",
    [Enum.KeyCode.LeftParenthesis] = "(",
    [Enum.KeyCode.Semicolon] = ",",
    [Enum.KeyCode.Quote] = "'",
    [Enum.KeyCode.BackSlash] = "\\",
    [Enum.KeyCode.Comma] = ",",
    [Enum.KeyCode.Period] = ".",
    [Enum.KeyCode.Slash] = "/",
    [Enum.KeyCode.Asterisk] = "*",
    [Enum.KeyCode.Plus] = "+",
    [Enum.KeyCode.Period] = ".",
    [Enum.KeyCode.Backquote] = "`",
    [Enum.UserInputType.MouseButton1] = "MB1",
    [Enum.UserInputType.MouseButton2] = "MB2",
    [Enum.UserInputType.MouseButton3] = "MB3",
    [Enum.KeyCode.Escape] = "ESC",
    [Enum.KeyCode.Space] = "SPC",
}
    
library.__index = library

for _, path in next, library.folders do 
    makefolder(library.directory .. path)
end 

writefile("clean_ui_font.ttf", game:HttpGet("https://github.com/weasely111/beta/raw/refs/heads/main/fs-tahoma-8px.ttf"))

local tahoma = {
    name = "SmallestPixel7",
    faces = {
        {
            name = "Regular",
            weight = 400,
            style = "normal",
            assetId = getcustomasset("clean_ui_font.ttf")
        }
    }
}

writefile("clean_ui_font_json.json", http_service:JSONEncode(tahoma))

library.font = Font.new(getcustomasset("clean_ui_font_json.json"), Enum.FontWeight.Regular)

local config_holder 

function library:hoverify(hover, parent) 
    local hover_instance = library:create("Frame", {
        Parent = parent,
        BackgroundTransparency = 1,
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.accent,
        ZIndex = 1
    }) library:apply_theme(hover_instance, "accent", "BackgroundColor3") 

    hover.MouseEnter:Connect(function()
        library:tween(hover_instance, {
            BackgroundTransparency = 0, 
        }) 
    end)
    
    hover.MouseLeave:Connect(function()
        library:tween(hover_instance, {
            BackgroundTransparency = 1, 
        }) 
    end)

    return hover_instance
end 

function library:hovering(Object)
    if type(Object) == "table" then 
        local Pass = false
        for _,obj in Object do 
            if library:hovering(obj) then 
                Pass = true
                return Pass
            end 
        end 
    else 
        local y_cond = Object.AbsolutePosition.Y <= mouse.Y and mouse.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
        local x_cond = Object.AbsolutePosition.X <= mouse.X and mouse.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X
        return (y_cond and x_cond)
    end 
end  

function library:make_resizable(frame) 
    local Frame = Instance.new("TextButton")
    Frame.Position = dim2(1, -10, 1, -10)
    Frame.BorderColor3 = rgb(0, 0, 0)
    Frame.Size = dim2(0, 10, 0, 10)
    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = rgb(255, 255, 255)
    Frame.Parent = frame
    Frame.BackgroundTransparency = 1 
    Frame.Text = ""

    local resizing = false 
    local start_size 
    local start 
    local og_size = frame.Size  

    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            start = input.Position
            start_size = frame.Size
        end
    end)

    Frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)

    library:connection(uis.InputChanged, function(input, game_event) 
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local viewport_x = camera.ViewportSize.X
            local viewport_y = camera.ViewportSize.Y

            local current_size = dim2(
                start_size.X.Scale,
                math.clamp(
                    start_size.X.Offset + (input.Position.X - start.X),
                    og_size.X.Offset,
                    viewport_x
                ),
                start_size.Y.Scale,
                math.clamp(
                    start_size.Y.Offset + (input.Position.Y - start.Y),
                    og_size.Y.Offset,
                    viewport_y
                )
            )
            frame.Size = current_size
        end
    end)
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

            if library.current_element_open then 
                library.current_element_open.set_visible(false)
                library.current_element_open.open = false 
                library.current_element_open = nil 
            end 

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

    library:connection(uis.InputChanged, function(input, game_event) 
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local viewport_x = camera.ViewportSize.X
            local viewport_y = camera.ViewportSize.Y

            local current_position = dim2(
                0,
                clamp(
                    start_size.X.Offset + (input.Position.X - start.X),
                    0,
                    viewport_x - frame.Size.X.Offset
                ),
                0,
                clamp(
                    start_size.Y.Offset + (input.Position.Y - start.Y),
                    0,
                    viewport_y - frame.Size.Y.Offset
                )
            )

            frame.Position = current_position
        end
    end)
end

function library:new_drawing(class, properties)
    local ins = Drawing.new(class)

    for _, v in next, properties do 
        ins[_] = v
    end 

    insert(library.drawings, ins)

    return ins 
end 

function library:new_item(class, properties) 
    local ins = Instance.new(class)

    for _, v in next, properties do 
        ins[_] = v
    end 

    insert(library.instances, ins)

    return ins 
end 

function library:convert_enum(enum)
    local enum_parts = {}
    for part in string.gmatch(enum, "[%w_]+") do
        insert(enum_parts, part)
    end
    local enum_table = Enum
    for i = 2, #enum_parts do
        local enum_item = enum_table[enum_parts[i]]
        enum_table = enum_item
    end
    return enum_table
end

function library:tween(obj, properties) 
    local tween = tween_service:Create(obj, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0), properties):Play()
    return tween
end 

function library:config_list_update() 
    if not config_holder then return end 
    local list = {}
    for idx, file in next, listfiles(library.directory .. "/configs") do
        local name = string.sub(file:gsub(library.directory .. "/configs\\", ""):gsub(library.directory .. "\\configs\\", ""), 1, -5)
        list[#list + 1] = name
    end
    config_holder.refresh_options(list)
end 

function library:get_config()
    local Config = {}
    for _, v in flags do
        if type(v) == "table" and v.key then
            Config[_] = {active = v.active, mode = v.mode, key = tostring(v.key)}
        elseif type(v) == "table" and v["Transparency"] and v["Color"] then
            Config[_] = {Transparency = v["Transparency"], Color = v["Color"]:ToHex()}
        else
            Config[_] = v
        end
    end 
    return http_service:JSONEncode(Config)
end

function library:load_config(config_json) 
    local config = http_service:JSONDecode(config_json)
    for _, v in next, config do 
        local function_set = library.config_flags[_]
        if function_set then 
            if type(v) == "table" and v["Transparency"] and v["Color"] then
                function_set(hex(v["Color"]), v["Transparency"])
            elseif type(v) == "table" and v["active"] then 
                function_set(v)
            else 
                function_set(v)
            end
        end 
    end 
end 

function library:round(number, float) 
    local multiplier = 1 / (float or 1)
    return floor(number * multiplier + 0.5) / multiplier
end 

function library:apply_theme(instance, theme, property) 
    insert(themes.utility[theme][property], instance)
end

function library:update_theme(theme, color)
    for _, property in next, themes.utility[theme] do 
        for m, object in next, property do 
            if object[_] == themes.preset[theme] or object.ClassName == "UIGradient" then
                object[_] = color 
            end
        end 
    end 
    themes.preset[theme] = color 
end 

function library:connection(signal, callback)
    local connection = signal:Connect(callback)
    insert(library.connections, connection)
    return connection 
end

function library:apply_stroke(parent) 
    local stroke = library:create("UIStroke", {
        Parent = parent,
        Color = themes.preset.text_outline, 
        LineJoinMode = Enum.LineJoinMode.Miter
    }) 
    library:apply_theme(stroke, "text_outline", "Color")
end

function library:create(instance, options)
    local ins = Instance.new(instance) 
    for prop, value in next, options do 
        ins[prop] = value
    end
    if instance == "TextLabel" or instance == "TextButton" or instance == "TextBox" then 	
        library:apply_theme(ins, "text", "TextColor3")
        library:apply_stroke(ins)
    elseif instance == "ScreenGui" then 
        insert(library.guis, ins)
    end
    return ins 
end

local tooltip_sgui = library:create("ScreenGui", {
    Enabled = true,
    Parent = gethui(),
    Name = "",
    DisplayOrder = 500, 
})

function library:tool_tip(options) 
    local cfg = {
        name = options.name or "info", 
        path = options.path or nil, 
    }

    if cfg.path then 
        local watermark_outline = library:create("Frame", {
            Parent = tooltip_sgui,
            Name = "",
            Size = dim2(0, 0, 0, 22),
            Position = dim2(0, 500, 0, 300),
            BorderColor3 = rgb(0, 0, 0),
            BorderSizePixel = 0,
            Visible = false,
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundColor3 = themes.preset.outline
        })
        
        local watermark_inline = library:create("Frame", {
            Parent = watermark_outline,
            Name = "",
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.inline
        })
        
        local watermark_background = library:create("Frame", {
            Parent = watermark_inline,
            Name = "",
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        local UIGradient = library:create("UIGradient", {
            Parent = watermark_background,
            Name = "",
            Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))}
        }) library:apply_theme(UIGradient, "contrast", "Color")
        
        local text = library:create("TextLabel", {
            Parent = watermark_background,
            Name = "",
            FontFace = library.font,
            TextColor3 = themes.preset.text,
            BorderColor3 = rgb(0, 0, 0),
            Text = " " .. cfg.name .. " ",
            Size = dim2(0, 0, 1, 0),
            BackgroundTransparency = 1,
            Position = dim2(0, 0, 0, -1),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.X,
            TextSize = 12,
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        local UIStroke = library:create("UIStroke", {
            Parent = text,
            Name = "",
            LineJoinMode = Enum.LineJoinMode.Miter
        })

        cfg.path.MouseEnter:Connect(function()
            watermark_outline.Visible = true 
        end)   

        cfg.path.MouseLeave:Connect(function()
            watermark_outline.Visible = false 
        end)

        library:connection(uis.InputChanged, function(input)
            if watermark_outline.Visible and input.UserInputType == Enum.UserInputType.MouseMovement then
                watermark_outline.Position = dim_offset(input.Position.X + 10, input.Position.Y + 10)
            end
        end)
    end 
    return cfg
end 

function library:panel(options) 
    local cfg = {
        name = options.text or options.name or "Window", 
        size = options.size or dim2(0, 530, 0, 590),
        position = options.position or dim2(0, 500, 0, 500),
        anchor_point = options.anchor_point or vec2(0, 0),
        image = options.image or "rbxassetid://79856374238119",
        open = options.open or true,
        items = {},
    }
    
    local items = cfg.items do 
        items.sgui = library:create("ScreenGui", {
            Enabled = true,
            Parent = gethui(),
            Name = "" 
        })
        
        items.main_holder = library:create("Frame", {
            Parent = items.sgui,
            Name = "",
            AnchorPoint = vec2(cfg.anchor_point.X, cfg.anchor_point.Y),
            Position = cfg.position,
            Active = true, 
            BorderColor3 = rgb(0, 0, 0),
            Size = cfg.size,
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.outline
        })
        library:draggify(items.main_holder)
        library:make_resizable(items.main_holder)

        local Close = library:create( "TextButton" , {
            Parent = items.main_holder,
            FontFace = library.font,
            Name = "\0",
            AnchorPoint = vec2(1, 0),
            Active = false,
            BorderColor3 = rgb(0, 0, 0),
            Text = "X",
            Size = dim2(0, 0, 0, 0),
            Selectable = false,
            Position = dim2(1, -7, 0, 5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Right,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextColor3 = themes.preset.text,
            TextSize = 12,
            ZIndex = 100,
            BackgroundColor3 = rgb(255, 255, 255)
        })

        library:create( "UIStroke" , {
            Parent = Close
        })         
        
        Close.MouseButton1Click:Connect(function()
            items.sgui.Enabled = false
        end)

        items.window_inline = library:create("Frame", {
            Parent = items.main_holder,
            Name = "",
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.accent
        })
        
        library:apply_theme(items.window_inline, "accent", "BackgroundColor3") 
        
        items.window_holder = library:create("Frame", {
            Parent = items.window_inline,
            Name = "",
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = themes.preset.outline,
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255)
        })
                    
        items.UIGradient = library:create("UIGradient", {
            Parent = items.window_holder,
            Name = "",
            Rotation = 90,
            Color = rgbseq{
            rgbkey(0, rgb(41, 41, 55)),
            rgbkey(1, rgb(35, 35, 47))
        }
        })
    
        library:apply_theme(items.UIGradient, "contrast", "Color") 
        
        items.text = library:create("TextLabel", {
            Parent = items.window_holder,
            Name = "",
            FontFace = library.font,
            TextColor3 = themes.preset.accent,
            BorderColor3 = rgb(0, 0, 0),
            Text = cfg.name,
            BackgroundTransparency = 1,
            Position = dim2(0, 2, 0, 4),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextSize = 12,
            BackgroundColor3 = rgb(255, 255, 255)
        }) library:apply_theme(items.text, "accent", "TextColor3")
        
        items.UIStroke = library:create("UIStroke", {
            Parent = items.text,
            Name = "",
            LineJoinMode = Enum.LineJoinMode.Miter
        })
        
        items.UIPadding = library:create("UIPadding", {
            Parent = items.window_holder,
            Name = "",
            PaddingBottom = dim(0, 4),
            PaddingRight = dim(0, 4),
            PaddingLeft = dim(0, 4)
        })
        
        items.outline = library:create("Frame", {
            Parent = items.window_holder,
            Name = "",
            Position = dim2(0, 0, 0, 18),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, 0, 1, -18),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.inline
        })
        
        library:apply_theme(items.outline, "inline", "BackgroundColor3") 
        
        items.inline = library:create("Frame", {
            Parent = items.outline,
            Name = "",
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.outline
        })
        
        library:apply_theme(items.inline, "outline", "BackgroundColor3") 
        
        items.holder = library:create("Frame", {
            Parent = items.inline,
            Name = "",
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        items.UIGradient = library:create("UIGradient", {
            Parent = items.holder,
            Name = "",
            Rotation = 90,
            Color = rgbseq{
                rgbkey(0, rgb(41, 41, 55)),
                rgbkey(1, rgb(35, 35, 47))
            }
        })
        
        library:apply_theme(items.UIGradient, "contrast", "Color") 
        
        items.UIPadding = library:create("UIPadding", {
            Parent = items.holder,
            Name = "",
            PaddingTop = dim(0, 5),
            PaddingBottom = dim(0, 5),
            PaddingRight = dim(0, 5),
            PaddingLeft = dim(0, 5)
        })
        
        items.glow = library:create("ImageLabel", {
            Parent = items.main_holder,
            Name = "",
            ImageColor3 = themes.preset.glow,
            ScaleType = Enum.ScaleType.Slice,
            BorderColor3 = rgb(0, 0, 0),
            BackgroundColor3 = rgb(255, 255, 255),
            Visible = true,
            Image = "http://www.roblox.com/asset/?id=18245826428",
            BackgroundTransparency = 1,
            ImageTransparency = 0.8, 
            Position = dim2(0, -20, 0, -20),
            Size = dim2(1, 40, 1, 40),
            ZIndex = 2,
            BorderSizePixel = 0,
            SliceCenter = rect(vec2(21, 21), vec2(79, 79))
        }) library:apply_theme(items.glow, "glow", "ImageColor3") 
        
        items.button = library:create("TextButton", {
            Parent = library.dock_holder,
            Name = "",
            TextColor3 = rgb(0, 0, 0),
            BorderColor3 = rgb(0, 0, 0),
            Text = "",
            Size = dim2(0, 25, 0, 25),
            BorderSizePixel = 0,
            TextSize = 14,
            BackgroundColor3 = themes.preset.inline
        })
        
        local button_inline = library:create("Frame", {
            Parent = items.button,
            Name = "",
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.outline
        }) library:apply_theme(button_inline, "outline", "BackgroundColor3") 
        
        local button_inline2 = library:create("Frame", {
            Parent = button_inline,
            Name = "",
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255)
        }) library:apply_theme(button_inline2, "inline", "BackgroundColor3")
        
        local UIGradient = library:create("UIGradient", {
            Parent = button_inline2,
            Name = "",
            Rotation = 90,
            Color = rgbseq{
                rgbkey(0, rgb(35, 35, 47)),
                rgbkey(1, rgb(41, 41, 55))
            }
        }) library:apply_theme(UIGradient, "contrast", "Color") 
        
        items.Icon = library:create("ImageLabel", {
            Parent = button_inline2,
            Name = "",
            ImageColor3 = themes.preset.accent,
            Image = cfg.image,
            BackgroundTransparency = 1,
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, 0, 1, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255)
        }) library:apply_theme(items.Icon, "accent", "ImageColor3") library:apply_theme(items.Icon, "inline", "ImageColor3") 
        
        local UIPadding = library:create("UIPadding", {
            Parent = button_inline2,
            Name = "",
            PaddingTop = dim(0, 4),
            PaddingBottom = dim(0, 4),
            PaddingRight = dim(0, 4),
            PaddingLeft = dim(0, 4)
        })

        library:tool_tip({name = cfg.name, path = items.button})
    end 

    items.sgui:GetPropertyChangedSignal("Enabled"):Connect(function()
        items.Icon.ImageColor3 = items.sgui.Enabled and themes.preset.accent or themes.preset.inline
    end)

    items.button.MouseButton1Click:Connect(function()
        items.sgui.Enabled = not items.sgui.Enabled
    end)
    
    return setmetatable(cfg, library)
end 

local sgui = library:create("ScreenGui", {
    Enabled = true,
    Parent = gethui(),
    Name = "",
    DisplayOrder = 999999, 
})

local notif_holder = library:create("ScreenGui", {
    Parent = gethui(),
    Name = "",
    IgnoreGuiInset = true, 
    DisplayOrder = 999999, 
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

function library:fold_elements(origin, elements)
    for _, x in next, elements do 
        local flag = library.visible_flags[x]
        if flag then    
            flag(flags[origin])
        end     
    end 
end 

function library:indicator() 
    local cfg = {
        items = {}
    }

    local items = cfg.items do 
        items.Window = library:create( "Frame" , {
            Parent = sgui,
            Name = "\0",
            Position = dim2(0, 400, 0, 500),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 322, 0, 147),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.outline
        })	library:apply_theme(items.Window, "outline", "BackgroundColor3") library:draggify(items.Window)
        
        items.InfoTitle = library:create( "TextLabel" , {
            FontFace = library.font,
            TextColor3 = themes.preset.text,
            BorderColor3 = rgb(0, 0, 0),
            Text = "Indicators",
            Parent = items.Window,
            Name = "\0",
            Size = dim2(1, 0, 0, 0),
            Position = dim2(0, 7, 0, 5),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            ZIndex = 5,
            AutomaticSize = Enum.AutomaticSize.Y,
            TextSize = 12,
        }) 

        items.Accent = library:create( "Frame" , {
            Parent = items.Window,
            Name = "\0",
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.accent
        })	library:apply_theme(items.Accent, "accent", "BackgroundColor3")
        
        items.Background = library:create( "Frame" , {
            Parent = items.Accent,
            Name = "\0",
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.high_contrast
        })	library:apply_theme(items.Background, "high_contrast", "BackgroundColor3")
        
        items.Inline = library:create( "Frame" , {
            Parent = items.Background,
            Name = "\0",
            Position = dim2(0, 4, 0, 18),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -8, 1, -22),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.outline
        })	library:apply_theme(items.Inline, "outline", "BackgroundColor3")
        
        items.Outline = library:create( "Frame" , {
            Parent = items.Inline,
            Name = "\0",
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.inline
        })	library:apply_theme(items.Outline, "inline", "BackgroundColor3")
        
        items.LowContrast = library:create( "Frame" , {
            Parent = items.Outline,
            Name = "\0",
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.low_contrast
        })	library:apply_theme(items.LowContrast, "low_contrast", "BackgroundColor3")
        
        items.Inline2 = library:create( "Frame" , {
            Parent = items.LowContrast,
            Name = "\0",
            Position = dim2(0, 4, 0, 4),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -8, 1, -8),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.inline
        })	library:apply_theme(items.Inline2, "inline", "BackgroundColor3")
        
        items.Outline2 = library:create( "Frame" , {
            Parent = items.Inline2,
            Name = "\0",
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.outline
        })	library:apply_theme(items.Outline2, "outline", "BackgroundColor3")
        
        items.LowContrast2 = library:create( "Frame" , {
            Parent = items.Outline2,
            Name = "\0",
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.low_contrast
        })	library:apply_theme(items.LowContrast2, "low_contrast", "BackgroundColor3") local image_holder = items.LowContrast2
        
        items.Inline3 = library:create( "Frame" , {
            Parent = items.LowContrast2,
            Name = "\0",
            Position = dim2(0, 4, 0, 4),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -8, 1, -8),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.inline
        })	library:apply_theme(items.Inline3, "inline", "BackgroundColor3")
        
        items.Outline3 = library:create( "Frame" , {
            Parent = items.Inline3,
            Name = "\0",
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.outline
        })	library:apply_theme(items.Outline3, "outline", "BackgroundColor3")
        
        items.LowContrast3 = library:create( "Frame" , {
            Parent = items.Outline3,
            Name = "\0",
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.low_contrast
        })	library:apply_theme(items.LowContrast3, "low_contrast", "BackgroundColor3")

        items.InfoTitle2 = library:create( "TextLabel" , {
            FontFace = library.font,
            TextColor3 = themes.preset.text,
            BorderColor3 = rgb(0, 0, 0),
            Text = "Info",
            Parent = items.Outline3,
            Name = "\0",
            Size = dim2(1, 0, 0, 0),
            Position = dim2(0, 7, 0, 5),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            ZIndex = 5,
            AutomaticSize = Enum.AutomaticSize.Y,
            TextSize = 12,
        })

        library:create( "UIStroke" , {
            Parent = items.InfoTitle2
        })
        
        items.Accent2 = library:create( "Frame" , {
            Name = "\0",
            Parent = items.LowContrast3,
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, 0, 0, 2),
            BackgroundColor3 = themes.preset.accent,
            BorderSizePixel = 0,
        })	library:apply_theme(items.Accent2, "accent", "BackgroundColor3")
        
        items.Shadow = library:create( "Frame" , {
            AnchorPoint = vec2(0, 1),
            Parent = items.Accent2,
            Name = "\0",
            Position = dim2(0, 0, 1, 0),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, 0, 0, 1),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.accent,
        }) library:apply_theme(items.Shadow, "accent", "BackgroundColor3")
        
        library:create( "UIGradient" , {
            Rotation = 90,
            Parent = items.Shadow,
            Color = rgbseq{rgbkey(0, rgb(150, 150, 150)), rgbkey(1, rgb(150, 150, 150))}
        })
        
        items.holder = library:create( "Frame" , {
            Parent = items.LowContrast3,
            Name = "\0",
            Position = dim2(0, 76, 0, 21),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -80, 0, 0),
            BorderSizePixel = 0,
        })	

        library:create("UIListLayout", {
            Parent = items.holder,
            Padding = dim(0, 4),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        items.Inline4 = library:create( "Frame" , {
            Parent = image_holder,
            Name = "\0",
            Position = dim2(0, 10, 0, 28),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 68, 0, 67),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.outline
        })	library:apply_theme(items.Inline4, "outline", "BackgroundColor3")
        
        items.Outline4 = library:create( "Frame" , {
            Parent = items.Inline4,
            Name = "\0",
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.inline
        })	library:apply_theme(items.Outline4, "inline", "BackgroundColor3")
        
        items.LowContrast4 = library:create( "Frame" , {
            Parent = items.Outline4,
            Name = "\0",
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.low_contrast
        })	library:apply_theme(items.LowContrast4, "low_contrast", "BackgroundColor3")

        items.Profile = library:create( "ImageLabel" , {
            BorderColor3 = rgb(0, 0, 0),
            Parent = items.LowContrast4,
            Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
            BackgroundTransparency = 1,
            Name = "\0",
            Size = dim2(1, 0, 1, 0),
            BorderSizePixel = 0,
        })	

        local section = setmetatable(items, library)
        items.label = section:label({name = "Player: "})
        items.slider = section:slider({name = "Health", custom = rgb(255, 0, 0), min = 0, max = 100, default = 50, input = true})
        
        library:create( "UIStroke" , {
            Parent = items.InfoTitle2
        })            
    end

    function cfg.set_visible(bool)
        items.Window.Visible = bool
    end 

    function cfg.change_health(int)
        items.slider.set(int)
    end

    function cfg.change_profile(player)
        items.label.set(string.format("Player: %s (%s)", player.Name, player.DisplayName))
        items.Profile.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=".. player.UserId .."&width=420&height=420&format=png"
    end 

    return setmetatable(cfg, library)
end     

function library:window(properties)
    local window = {opened = true}            
    local opened = {}
    local dock_outline
    local blur = library:create( "BlurEffect" , {
        Parent = lighting,
        Enabled = true,
        Size = 15
    })    

    library.cache = library:create("ScreenGui", {
        Enabled = false,
        Parent = gethui(),
        Name = "" 
    })

    function window.set_menu_visibility(bool) 
        window.opened = bool 
        
        if bool then 
            for _,gui in opened do 
                gui.Enabled = true 
                opened = {}
            end 
        else
            for _,gui in library.guis do 
                if gui.Enabled then 
                    gui.Enabled = false
                    table.insert(opened, gui)
                end
            end
        end

        library:tween(blur, {Size = bool and (flags["Blur Size"] or 15) or 0})

        dock_outline.Visible = bool

        sgui.Enabled = true
        notif_holder.Enabled = true
        tooltip_sgui.Enabled = true
        library.cache.Enabled = false

        for _,tooltip in tooltip_sgui:GetChildren() do 
            tooltip.Visible = false
        end 

        if library.current_element_open then 
            library.current_element_open.set_visible(false)
            library.current_element_open.open = false 
            library.current_element_open = nil 
        end
    end 

    dock_outline = library:create("Frame", {
        Parent = sgui,
        Name = "",
        Visible = true,
        BorderColor3 = rgb(0, 0, 0),
        AnchorPoint = vec2(0.5, 0),
        Position = dim2(0.5, 0, 0, 20),
        Size = dim2(0, 157, 0, 39),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.outline
    }) 

    library:apply_theme(dock_outline, "outline", "BackgroundColor3") 
    dock_outline.Position = dim2(0, dock_outline.AbsolutePosition.X, 0, dock_outline.AbsolutePosition.Y) 
    dock_outline.AnchorPoint = vec2(0, 0) 
    library:draggify(dock_outline)

    local dock_inline = library:create("Frame", {
        Parent = dock_outline,
        Name = "",
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.inline
    }) library:apply_theme(dock_inline, "inline", "BackgroundColor3") 
    
    local dock_holder = library:create("Frame", {
        Parent = dock_inline,
        Name = "",
        Size = dim2(1, -2, 1, -2),
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = themes.preset.outline,
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    }) library:apply_theme(dock_holder, "outline", "BackgroundColor3") 
    
    local accent = library:create("Frame", {
        Parent = dock_holder,
        Name = "",
        Size = dim2(1, 0, 0, 2),
        BorderColor3 = rgb(0, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.accent
    }) library:apply_theme(accent, "accent", "BackgroundColor3") 
    
    local UIGradient = library:create("UIGradient", {
        Parent = accent,
        Name = "",
        Rotation = 90,
        Color = rgbseq{
        rgbkey(0, rgb(255, 255, 255)),
        rgbkey(1, rgb(167, 167, 167))
    }
    })
    
    local button_holder = library:create("Frame", {
        Parent = dock_holder,
        Name = "",
        BackgroundTransparency = 1,
        Size = dim2(1, 0, 1, 0),
        BorderColor3 = rgb(0, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    }) library.dock_holder = button_holder
    
    local UIListLayout = library:create("UIListLayout", {
        Parent = button_holder,
        Name = "",
        Padding = dim(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    local UIPadding = library:create("UIPadding", {
        Parent = button_holder,
        Name = "",
        PaddingTop = dim(0, 6),
        PaddingBottom = dim(0, 4),
        PaddingRight = dim(0, 4),
        PaddingLeft = dim(0, 4)
    })
                
    local UIGradient = library:create("UIGradient", {
        Parent = dock_holder,
        Name = "",
        Rotation = 90,
        Color = rgbseq{
            rgbkey(0, rgb(41, 41, 55)),
            rgbkey(1, rgb(35, 35, 47))
        }
    }) library:apply_theme(UIGradient, "contrast", "Color") 

    local outline = library:create("Frame", {
        Parent = sgui,
        Name = "",
        Visible = false, 
        Active = true,
        Draggable = true, 
        Position = dim2(0, 50, 0, 200),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 182, 0, 25),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.outline
    })
    library:apply_theme(outline, "outline", "BackgroundColor3") 
    library:draggify(outline)
    library:make_resizable(outline)
    library.keybind_list_frame = outline 
    
    local inline = library:create("Frame", {
        Parent = outline,
        Name = "",
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.inline
    })
    library:apply_theme(inline, "inline", "BackgroundColor3")

    local background = library:create("Frame", {
        Parent = inline,
        Name = "",
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    local UIGradient = library:create("UIGradient", {
        Parent = background,
        Name = "",
        Rotation = 90,
        Color = rgbseq{
            rgbkey(0, themes.preset.high_contrast),
            rgbkey(1, themes.preset.low_contrast)
        }
    })
    library:apply_theme(UIGradient, "contrast", "Color") 
    
    local bg = library:create("Frame", {
        Parent = background,
        Name = "a",
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 0, 2),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.accent
    }) library:apply_theme(bg, "accent", "BackgroundColor3")
    
    
    library:create("UIGradient", {
        Parent = bg,
        Name = "",
        Enabled = true, 
        Rotation = 90,
        Color = rgbseq{
            rgbkey(0, rgb(255, 255, 255)),
            rgbkey(1, rgb(167, 167, 167))
        }
    })
    
    local text = library:create("TextLabel", {
        Parent = background,
        Name = "",
        FontFace = library.font,
        TextColor3 = themes.preset.text,
        BorderColor3 = rgb(0, 0, 0),
        Text = "Keybinds",
        BackgroundTransparency = 1,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Size = dim2(1, 0, 1, 0),
        BorderSizePixel = 0,
        TextSize = 12,
        BackgroundColor3 = themes.preset.text
    }, "text")
    
    local UIStroke = library:create("UIStroke", {
        Parent = text,
        Name = "",
        LineJoinMode = Enum.LineJoinMode.Miter
    })
    
    local text_holder = library:create("Frame", {
        Parent = background,
        Name = "",
        Position = dim2(0, -2, 1, 1),
        Size = dim2(1, 4, 0, 0),
        BorderColor3 = rgb(0, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = themes.preset.outline
    })
    library:apply_theme(text_holder, "outline", "BackgroundColor3")

    local inline = library:create("Frame", {
        Parent = text_holder,
        Name = "",
        Size = dim2(1, -2, 1, -2),
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.inline
    })
    library:apply_theme(inline, "inline", "BackgroundColor3")
    
    local background2 = library:create("Frame", {
        Parent = inline,
        Name = "",
        Size = dim2(1, -2, 1, -2),
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    library.keybind_list = background2
    
    local UIGradient = library:create("UIGradient", {
        Parent = background2,
        Name = "",
        Rotation = 90,
        Color = rgbseq{
            rgbkey(0, themes.preset.high_contrast),
            rgbkey(1, themes.preset.low_contrast)
        }
    })
    library:apply_theme(UIGradient, "contrast", "Color") 
    
    library:create("UIListLayout", {
        Parent = background2,
        Name = "",
        Padding = dim(0, -1),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    library:create("UIPadding", {
        Parent = background2,
        Name = "",
        PaddingBottom = dim(0, 4),
        PaddingLeft = dim(0, 5)
    })

    local main_window = library:panel({
        name = properties and properties.name or "CleanUI", 
        size = dim2(0, 604, 0, 628),
        position = dim2(0, (camera.ViewportSize.X / 2) - 302 - 96, 0, (camera.ViewportSize.Y / 2) - 421 - 12),
        image = "rbxassetid://98823308062942",
    })

    local items = main_window.items

    window["tab_holder"] = library:create("Frame", {
        Parent = items.holder,
        Name = " ",
        BackgroundTransparency = 1,
        Size = dim2(1, 0, 0, 22),
        BorderColor3 = rgb(0, 0, 0),
        ZIndex = 5,
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })

    library:create("UIListLayout", {
        Parent = window["tab_holder"],
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        Padding = dim(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local section_holder = library:create("Frame", {
        Parent = items.holder,
        Name = " ",
        BackgroundTransparency = 1,
        Position = dim2(0, -1, 0, 19),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 1, -22),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    window["section_holder"] = section_holder

    local outline = library:create("Frame", {
        Parent = section_holder,
        Name = "\0",
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 1, 2),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.outline
    })
    
    library:apply_theme(outline, "outline", "BackgroundColor3") 

    local inline = library:create("Frame", {
        Parent = outline,
        Name = "\0",
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.inline
    })
    
    library:apply_theme(inline, "inline", "BackgroundColor3") 

    local background = library:create("Frame", {
        Parent = inline,
        Name = "\0",
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })

    library.section_holder = background

    library:create("UIPadding", {
        Parent = background,
        PaddingTop = dim(0, 4),
        PaddingBottom = dim(0, 4),
        PaddingRight = dim(0, 4),
        PaddingLeft = dim(0, 4)
    })

    local UIGradient = library:create("UIGradient", {
        Parent = background,
        Rotation = 90,
        Color = rgbseq{
            rgbkey(0, rgb(41, 41, 55)),
            rgbkey(1, rgb(35, 35, 47))
        }
    })
    
    library:apply_theme(UIGradient, "contrast", "Color") 
    library:make_resizable(items.main_holder) 

    local style = library:panel({
        name = "Style", 
        anchor_point = vec2(0, 0),
        size = dim2(0, 394, 0, 464),
        position = dim2(0, main_window.items.main_holder.AbsolutePosition.X + main_window.items.main_holder.AbsoluteSize.X + 2, 0, main_window.items.main_holder.AbsolutePosition.Y),
        image = "rbxassetid://115194686863276",
    })

    local watermark = library:watermark({default = os.date('CleanUI | - %b %d %Y - %H:%M:%S')})  

    task.spawn(function()
        while task.wait(1) do 
            watermark.change_text(os.date('CleanUI - Beta - %b %d %Y - %H:%M:%S'))
        end 
    end) 

    local items = style.items

    local column = setmetatable(items, library):column() 
    local section = column:section({name = "Theme"})
    section:label({name = "Accent"})
    :colorpicker({name = "Accent", color = themes.preset.accent, flag = "accent", callback = function(color, alpha)
        library:update_theme("accent", color)
    end, flag = "Accent"})
    section:label({name = "Contrast"})
    :colorpicker({name = "Low", color = themes.preset.low_contrast, flag = "low_contrast", callback = function(color)
        if (flags["high_contrast"] and flags["low_contrast"]) then 
            library:update_theme("contrast", rgbseq{
                rgbkey(0, flags["low_contrast"].Color),
                rgbkey(1, flags["high_contrast"].Color)
            })
        end 
        library:update_theme("low_contrast", flags["low_contrast"].Color)
    end})
    :colorpicker({name = "High", color = themes.preset.high_contrast, flag = "high_contrast", callback = function(color)
        library:update_theme("contrast", rgbseq{
            rgbkey(0, flags["low_contrast"].Color),
            rgbkey(1, flags["high_contrast"].Color)
        })
        library:update_theme("high_contrast", flags["high_contrast"].Color)
    end})
    section:label({name = "Inline"})
    :colorpicker({name = "Inline", color = themes.preset.inline, callback = function(color, alpha)
        library:update_theme("inline", color)
    end, flag = "Inline"})
    section:label({name = "Outline"})
    :colorpicker({name = "Outline", color = themes.preset.outline, callback = function(color, alpha)
        library:update_theme("outline", color)
    end, flag = "Outline"})
    section:label({name = "Text Color"})
    :colorpicker({name = "Main", color = themes.preset.text, callback = function(color, alpha)
        library:update_theme("text", color)
    end, flag = "Main"})
    :colorpicker({name = "Outline", color = themes.preset.text_outline, callback = function(color, alpha)
        library:update_theme("text_outline", color)
    end, flag = "OutlineText"})
    section:label({name = "Glow"})
    :colorpicker({name = "Glow", color = themes.preset.glow, callback = function(color, alpha)
        library:update_theme("glow", color)
    end, flag = "Glow"})
    section:slider({name = "Blur Size", flag = "Blur Size", min = 0, max = 56, default = 15, interval = 1, callback = function(int)
        if window.opened then 
            blur.Size = int
        end
    end})
    local section2 = column:section({name = "Other"})
    section2:label({name = "UI Bind"})
    :keybind({callback = window.set_menu_visibility, key = Enum.KeyCode.Insert})
    section2:toggle({name = "Keybind List", flag = "keybind_list", callback = function(bool)
        library.keybind_list_frame.Visible = bool
    end})
    section2:toggle({name = "Watermark", flag = "watermark", callback = function(bool)
        watermark.set_visible(bool)
    end})
    section2:button_holder({})
    section2:button({name = "Copy JobId", callback = function()
        setclipboard(game.JobId)
    end})
    section2:button_holder({})
    section2:button({name = "Copy GameID", callback = function()
        setclipboard(game.GameId)
    end})
    section2:button_holder({})
    section2:button({name = "Copy Join Script", callback = function()
        setclipboard('game:GetService("TeleportService"):TeleportToPlaceInstance(' .. game.PlaceId .. ', "' .. game.JobId .. '", game.Players.LocalPlayer)')
    end})
    section2:button_holder({})
    section2:button({name = "Rejoin", callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
    end})
    section2:button_holder({})
    section2:button({name = "Join New Server", callback = function()
        local apiRequest = game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        local data = apiRequest.data[random(1, #apiRequest.data)]
        if data.playing <= flags["max_players"] then 
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, data.id)
        end 
    end})
    section2:slider({name = "Max Players", flag = "max_players", min = 0, max = 40, default = 15, interval = 1})

    local holder = library:panel({
        name = "Configurations", 
        size = dim2(0, 324, 0, 410),
        position = dim2(0, items.main_holder.AbsolutePosition.X + items.main_holder.AbsoluteSize.X + 2, 0, items.main_holder.AbsolutePosition.Y),
        image = "rbxassetid://105199726008012",
    }) 

    local items_cfg = holder.items

    getgenv().load_config = function(name)
        library:load_config(readfile(library.directory .. "/configs/" .. name .. ".cfg"))
    end 

    local column_cfg = setmetatable(items_cfg, library):column() 
    local section_cfg = column_cfg:section({name = "Options"})
    config_holder = section_cfg:list({flag = "config_name_list"})
    section_cfg:textbox({flag = "config_name_text_box"})
    section_cfg:button_holder({})
    section_cfg:button({name = "Create", callback = function()
        writefile(library.directory .. "/configs/" .. flags["config_name_text_box"] .. ".cfg", library:get_config())
        library:config_list_update()
    end})
    section_cfg:button({name = "Delete", callback = function()
        delfile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg")
        library:config_list_update()
    end})
    section_cfg:button_holder({})
    section_cfg:button({name = "Load", callback = function()
        library:load_config(readfile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg"))
        library:notification({text = "Loaded Config: " .. flags["config_name_list"], time = 3})
    end})
    section_cfg:button({name = "Save", callback = function()
        writefile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg", library:get_config())
        library:config_list_update()
        library:notification({text = "Saved Config: " .. flags["config_name_list"], time = 3})
    end})
    section_cfg:button_holder({})
    section_cfg:button({name = "Refresh Configs", callback = function()
        library:config_list_update()
    end})
    section_cfg:button_holder({})
    section_cfg:button({name = "Unload Config", callback = function()
        library:load_config(library.old_config)
    end})
    section_cfg:button({name = "Unload Menu", callback = function()
        library:load_config(library.old_config)
        for _, gui in library.guis do 
            gui:Destroy() 
        end 
        for _, connection in library.connections do 
            connection:Disconnect() 
        end
        blur:Destroy()
    end})

    local holder2 = library:panel({
        name = "ESP Preview", 
        anchor_point = vec2(0, 0),
        size = dim2(0, 300, 0, 325),
        position = dim2(0, style.items.main_holder.AbsolutePosition.X, 0, style.items.main_holder.AbsolutePosition.Y + style.items.main_holder.AbsoluteSize.Y + 2),
        image = "rbxassetid://77684377836328",
    })  
    
    local items_esp = holder2.items
    local column_esp = setmetatable(items_esp, library):column() 
    window.esp_section = column_esp:section({name = "Main"})

    local holder3 = library:panel({
        name = "Playerlist", 
        anchor_point = vec2(0, 0),
        size = dim2(0, 529, 0, 445),
        position = dim2(0, main_window.items.main_holder.AbsolutePosition.X - 531, 0, main_window.items.main_holder.AbsolutePosition.Y),
        image = "rbxassetid://107070078834415",
    })  
    
    local items_pl = holder3.items
    local column_pl = setmetatable(items_pl, library):column() 
    local section_pl = column_pl:section({name = "Playerlist"})
    local playerlist = section_pl:playerlist({})
    section_pl:dropdown({name = "Priority", items = {"Enemy", "Priority", "Neutral", "Friendly"}, default = "Neutral", flag = "PLAYERLIST_DROPDOWN", callback = function(text)
        library.prioritize(text)
    end})

    return setmetatable(window, library)
end

function library:watermark(options) 
    local cfg = {
        default = options.text or options.default or os.date('CleanUI | %b %d %Y | %H:%M')
    }

    local watermark_outline = library:create("Frame", {
        Parent = sgui,
        Name = "",
        BorderColor3 = rgb(0, 0, 0),
        AnchorPoint = vec2(1, 1),
        Position = dim2(1, -20, 0, 20),
        Size = dim2(0, 0, 0, 24),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = themes.preset.outline
    }) library:apply_theme(watermark_outline, "outline", "BackgroundColor3") 
    watermark_outline.Position = dim_offset(watermark_outline.AbsolutePosition.X, watermark_outline.AbsolutePosition.Y)
    library:draggify(watermark_outline)

    local watermark_inline = library:create("Frame", {
        Parent = watermark_outline,
        Name = "",
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.inline
    }) library:apply_theme(watermark_inline, "inline", "BackgroundColor3") 
    
    local watermark_background = library:create("Frame", {
        Parent = watermark_inline,
        Name = "",
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    local UIGradient = library:create("UIGradient", {
        Parent = watermark_background,
        Name = "",
        Rotation = 90,
        Color = rgbseq{
            rgbkey(0, rgb(41, 41, 55)),
            rgbkey(1, rgb(35, 35, 47))
        }
    }) library:apply_theme(UIGradient, "contrast", "Color") 
    
    local text = library:create("TextLabel", {
        Parent = watermark_background,
        Name = "",
        FontFace = library.font,
        TextColor3 = themes.preset.text,
        BorderColor3 = rgb(0, 0, 0),
        Text = "  CleanUI | Beta | Aug 29 2024 | 07:29:00  ",
        Size = dim2(0, 0, 1, 0),
        BackgroundTransparency = 1,
        Position = dim2(0, -1, 0, 1),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    library:create("UIStroke", {
        Parent = text,
        Name = "",
        LineJoinMode = Enum.LineJoinMode.Miter
    })
    
    local accent = library:create("Frame", {
        Parent = watermark_outline,
        Name = "",
        Position = dim2(0, 2, 0, 2),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -4, 0, 2),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.accent
    }) library:apply_theme(accent, "accent", "BackgroundColor3") 
    
    local UIGradient = library:create("UIGradient", {
        Parent = accent,
        Name = "",
        Rotation = 90,
        Color = rgbseq{
            rgbkey(0, rgb(255, 255, 255)),
            rgbkey(1, rgb(167, 167, 167))
        }
    })
    
    function cfg.change_text(input)
        text.Text = "  ".. input .."  "
    end 

    function cfg.set_visible(bool) 
        watermark_outline.Visible = bool
    end 

    cfg.change_text(cfg.default)

    return cfg 
end 

function library:esp_preview(properties)
    local cfg = {items = {}, rotation = 0, objects = {}}

    lp.Character.Archivable = true
    local character = lp.Character:Clone()
    character.Animate:Destroy()

    local items = cfg.items do 
        items.viewportframe = library:create( "ViewportFrame" , {
            Parent = self.holder,
            BackgroundTransparency = 1,
            Size = dim2(1, 0, 0, 220),
            BorderColor3 = rgb(0, 0, 0),
            ZIndex = 1,
            Position = dim2(0, 0, 0, 10),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        items.camera = library:create( "Camera" , {
            FieldOfView = 70.00022888183594,
            CameraType = Enum.CameraType.Track,
            Focus = cfr(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
            CFrame = cfr(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
            Parent = ws,
            Name = "\0"
        }) 

        items.viewportframe.CurrentCamera = items.camera
        character.Parent = items.viewportframe

        items.camera.CameraSubject = character

        library:connection(run.RenderStepped, function()
            task.wait()
            cfg.rotation += 0.5
            character:SetPrimaryPartCFrame(cfr(Vector3.new(0, 1, -6)) * angle(0, math.rad(cfg.rotation), 0))
        end)
    end 

    local objects = cfg.objects do 
        objects[ "holder" ] = library:create( "Frame" , {
            Parent = items.viewportframe,
            Name = "\0",
            BackgroundTransparency = 1,
            Position = dim2(0.5, 0, 0.5, 10),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 135, 0, 190),
            BorderSizePixel = 0,
            AnchorPoint = vec2(0.5, 0.5),
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        objects[ "box_outline" ] = library:create( "UIStroke" , {
            Parent = library.cache,
            LineJoinMode = Enum.LineJoinMode.Miter
        })
        
        objects[ "name" ] = library:create( "TextLabel" , {
            FontFace = library.font,
            Parent = library.cache,
            TextColor3 = flags["Name_Color"].Color,
            BorderColor3 = rgb(0, 0, 0),
            Text = string.format("%s (@%s)", lp.DisplayName, lp.Name),
            Name = "\0",
            TextStrokeTransparency = 0,
            AnchorPoint = vec2(0, 1),
            Size = dim2(1, 0, 0, 0),
            BackgroundTransparency = 1,
            Position = dim2(0, 0, 0, -5),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
            TextSize = 12,
        })
        
        objects[ "box_handler" ] = library:create( "Frame" , {
            Parent = library.cache,
            Name = "\0",
            BackgroundTransparency = 1,
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        objects[ "box_color" ] = library:create( "UIStroke" , {
            Color = rgb(255, 255, 255),
            LineJoinMode = Enum.LineJoinMode.Miter,
            Name = "\0",
            Parent = objects[ "box_handler" ]
        })
        
        objects[ "outline" ] = library:create( "Frame" , {
            Parent = objects[ "box_handler" ],
            Name = "\0",
            BackgroundTransparency = 1,
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        library:create( "UIStroke" , {
            Parent = objects[ "outline" ],
            LineJoinMode = Enum.LineJoinMode.Miter
        })  
        
        objects[ "corners" ] = library:create( "Frame" , {
            Visible = true,
            BorderColor3 = rgb(0, 0, 0),
            Parent = library.cache,
            BackgroundTransparency = 1,
            Position = dim2(0, -1, 0, 2),
            Name = "\0",
            Size = dim2(1, 0, 1, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255)
        })

        objects[ "1" ] = library:create( "Frame" , {
            Parent = objects[ "corners" ],
            Name = "line",
            Position = dim2(0, 0, 0, -2),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0.4, 0, 0, 3),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(0, 0, 0)
        })
        
        library:create( "Frame" , {
            Parent = objects[ "1" ],
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = flags["Box_Color"].Color
        })
        
        objects[ "2" ] = library:create( "Frame" , {
            Parent = objects[ "corners" ],
            Name = "line",
            Position = dim2(0, 0, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 3, 0.25, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(0, 0, 0)
        })
        
        library:create( "Frame" , {
            Parent = objects[ "2" ],
            Position = dim2(0, 1, 0, -2),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, 1),
            BorderSizePixel = 0,
            BackgroundColor3 = flags["Box_Color"].Color
        })
        
        objects[ "3" ] = library:create( "Frame" , {
            AnchorPoint = vec2(1, 0),
            Parent = objects[ "corners" ],
            Name = "line",
            Position = dim2(1, 0, 0, -2),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0.4, 0, 0, 3),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(0, 0, 0)
        })
        
        library:create( "Frame" , {
            Parent = objects[ "3" ],
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = flags["Box_Color"].Color
        })
        
        objects[ "4" ] = library:create( "Frame" , {
            AnchorPoint = vec2(1, 0),
            Parent = objects[ "corners" ],
            Name = "line",
            Position = dim2(1, 0, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 3, 0.25, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(0, 0, 0)
        })
        
        library:create( "Frame" , {
            Parent = objects[ "4" ],
            Position = dim2(0, 1, 0, -2),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, 1),
            BorderSizePixel = 0,
            BackgroundColor3 = flags["Box_Color"].Color
        })
        
        objects[ "5" ] = library:create( "Frame" , {
            AnchorPoint = vec2(0, 1),
            Parent = objects[ "corners" ],
            Name = "line",
            Position = dim2(0, -1, 1, -2),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0.4, 0, 0, 3),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(0, 0, 0)
        })
        
        library:create( "Frame" , {
            Parent = objects[ "5" ],
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = flags["Box_Color"].Color
        })
        
        objects[ "6" ] = library:create( "Frame" , {
            BorderColor3 = rgb(0, 0, 0),
            Rotation = 180,
            Parent = objects[ "corners" ],
            Name = "line",
            Position = dim2(0, 0, 1, -4),
            AnchorPoint = vec2(0, 1),
            Size = dim2(0, 3, 0.25, 1),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(0, 0, 0)
        })
        
        library:create( "Frame" , {
            Parent = objects[ "6" ],
            Position = dim2(0, 1, 0, -2),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, 1),
            BorderSizePixel = 0,
            BackgroundColor3 = flags["Box_Color"].Color
        })
        
        objects[ "7" ] = library:create( "Frame" , {
            AnchorPoint = vec2(1, 1),
            Parent = objects[ "corners" ],
            Name = "line",
            Position = dim2(1, -1, 1, -2),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0.4, 0, 0, 3),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(0, 0, 0)
        })
        
        library:create( "Frame" , {
            Parent = objects[ "7" ],
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = flags["Box_Color"].Color
        })
        
        objects[ "8" ] = library:create( "Frame" , {
            BorderColor3 = rgb(0, 0, 0),
            Rotation = 180,
            Parent = objects[ "corners" ],
            Name = "line",
            Position = dim2(1, 0, 1, -4),
            AnchorPoint = vec2(1, 1),
            Size = dim2(0, 3, 0.25, 1),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(0, 0, 0)
        })
        
        library:create( "Frame" , {
            Parent = objects[ "8" ],
            Position = dim2(0, 1, 0, -2),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, 1),
            BorderSizePixel = 0,
            BackgroundColor3 = flags["Box_Color"].Color
        })
        
        objects[ "healthbar_holder" ] = library:create( "Frame" , {
            AnchorPoint = vec2(1, 0),
            Parent = library.cache,
            Name = "\0",
            Position = dim2(0, -5, 0, 0),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 4, 1, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(0, 0, 0)
        })
        
        objects[ "healthbar" ] = library:create( "Frame" , {
            Parent = objects[ "healthbar_holder" ],
            Name = "\0",
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        objects[ "distance" ] = library:create( "TextLabel" , {
            FontFace = library.font,
            TextColor3 = flags["Distance_Color"].Color,
            BorderColor3 = rgb(0, 0, 0),
            Text = "127st",
            Parent = library.cache,
            TextStrokeTransparency = 0,
            Name = "\0",
            Size = dim2(1, 0, 0, 0),
            BackgroundTransparency = 1,
            Position = dim2(0, 0, 1, 5),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
            TextSize = 12,
        })                
        
        objects[ "weapon" ] = library:create( "TextLabel" , {
            FontFace = library.font,
            TextColor3 = flags["Weapon_Color"].Color,
            BorderColor3 = rgb(0, 0, 0),
            Text = "[ Weapon ]",
            Parent = library.cache,
            TextStrokeTransparency = 0,
            Name = "\0",
            Size = dim2(1, 0, 0, 0),
            BackgroundTransparency = 1,
            Position = dim2(0, 0, 1, 19),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
            TextSize = 12,
        })
    end 

    cfg.change_health = function()
        if flags[ "healthbar_holder" ] and flags[ "healthbar_holder" ].Parent ~= objects[ "holder" ] then 
            return 
        end

        local humanoid = character.Humanoid
        
        local multiplier = humanoid.MaxHealth * math.abs(math.sin(tick() * 2)) / humanoid.MaxHealth
        local color = flags[ "Health_Low" ].Color:Lerp( flags["Health_High"].Color, multiplier)
        
        objects[ "healthbar" ].Size = UDim2.new(1, -2, multiplier, -2)
        objects[ "healthbar" ].Position = UDim2.new(0, 1, 1 - multiplier, 1)
        objects[ "healthbar" ].BackgroundColor3 = color
    end

    function cfg.refresh_elements( )                                
        objects.holder.Parent = flags["Enabled"] and items.viewportframe or library.cache

        local temp = {
            ["Names"] = objects["name"], 
            ["Name_Color"] = {objects["name"]},
            ["Healthbar"] = objects[ "healthbar_holder" ],
            ["Distance"] = objects[ "distance" ],
            ["Weapon"] = objects[ "weapon" ],
            ["Distance_Color"] = {objects[ "distance" ]},
            ["Weapon_Color"] = {objects[ "weapon" ]},
        }

        for flag,object in temp do 
            if type(object) == "table" then 
                object[1].TextColor3 = flags[flag].Color
            else 
                object.Parent = flags[flag] and objects[ "holder" ] or library.cache
            end
        end 
        
        local is_corner = flags[ "Box_Type" ] == "Corner"

        if flags["Boxes"] then 
            if is_corner then 
                objects[ "corners" ].Parent = objects["holder"]
                objects[ "box_handler" ].Parent = library.cache
                objects[ "box_outline" ].Parent = library.cache
            else 
                objects[ "box_handler" ].Parent = objects[ "holder" ]
                objects[ "box_outline" ].Parent = objects[ "holder" ]
                objects[ "corners" ].Parent = library.cache
            end 
        else
            objects[ "corners" ].Parent =  library.cache
            objects[ "box_handler" ].Parent = library.cache
            objects[ "box_outline" ].Parent = library.cache
        end 

        objects[ "box_color" ].Color = flags["Box_Color"].Color 

        for _, corner in objects[ "corners" ]:GetChildren() do
            corner.Frame.BackgroundColor3 = flags["Box_Color"].Color
        end
    end

    task.spawn(function()
        while true do 
            task.wait()
            cfg.change_health()
        end 
    end)

    return setmetatable(cfg, library)
end

function library:refresh_notifications()  	
    for _, notif in next, library.notifications do 
        tween_service:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {Position = dim2(0, 20, 0, 72 + (_ * 28))}):Play()
    end     
end

function library:notification(properties)
    local cfg = {
        time = properties.time or 5,
        text = properties.text or properties.name or "Notification",
        flashing = false, 
    }

    local watermark_outline = library:create("Frame", {
        Parent = notif_holder,
        Name = "",
        Size = UDim2.new(0, 0, 0, 24),
        BorderColor3 = rgb(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 20, 0, 72 + (#library.notifications * 28)),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = themes.preset.outline,
        AnchorPoint = Vector2.new(1, 0)
    })
    
    local watermark_inline = library:create("Frame", {
        Parent = watermark_outline,
        Name = "",
        Position = UDim2.new(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = UDim2.new(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.inline
    })

    local watermark_background = library:create("Frame", {
        Parent = watermark_inline,
        Name = "",
        Position = UDim2.new(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = UDim2.new(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })

    local UIGradient = library:create("UIGradient", {
        Parent = watermark_background,
        Name = "",
        Color = ColorSequence.new{
            rgbkey(0, themes.preset.high_contrast),
            rgbkey(1, themes.preset.low_contrast)
        }
    })

    local text = library:create("TextLabel", {
        Parent = watermark_background,
        Name = "",
        FontFace = library.font,
        TextColor3 = themes.preset.text,
        BorderColor3 = rgb(0, 0, 0),
        Text = "  " .. cfg.text .. "  ",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, -1),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255)
    })

    local accent = library:create("Frame", {
        Parent = watermark_outline,
        Name = "",
        Position = UDim2.new(0, 2, 0, 2),
        BorderColor3 = rgb(0, 0, 0),
        Size = UDim2.new(0, 1, 1, -4),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.accent
    })

    library:apply_theme(accent, "accent", "BackgroundColor3")

    local UIGradient = library:create("UIGradient", {
        Parent = accent,
        Name = "",
        Rotation = 90,
        Color = ColorSequence.new{
            rgbkey(0, rgb(255, 255, 255)),
            rgbkey(1, rgb(167, 167, 167))
        }
    })
    
    local accent_bottom = library:create("Frame", {
        Parent = watermark_outline,
        Name = "",
        Position = UDim2.new(0, 2, 1, -3),
        BorderColor3 = rgb(0, 0, 0),
        Size = UDim2.new(0, -4, 0, 1),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.accent
    })
    
    local UIGradient = library:create("UIGradient", {
        Parent = accent,
        Name = "",
        Rotation = 90,
        Color = ColorSequence.new{
            rgbkey(0, rgb(255, 255, 255)),
            rgbkey(1, rgb(167, 167, 167))
        }
    })

    local index = #library.notifications + 1
    library.notifications[index] = watermark_outline

    library:refresh_notifications()

    tween_service:Create(watermark_outline, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {AnchorPoint = Vector2.new(0, 0)}):Play()
    
    tween_service:Create(accent_bottom, TweenInfo.new(cfg.time, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(1, -4, 0, 1)}):Play()
    
    task.spawn(function()
        task.wait(cfg.time)

        library.notifications[index] = nil

        tween_service:Create(watermark_outline, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1}):Play()
        
        for _, v in next, watermark_outline:GetDescendants() do 
            if v:IsA("TextLabel") then 
                tween_service:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
            elseif v:IsA("Frame") then 
                tween_service:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundTransparency = 1}):Play()
            elseif v:IsA("ImageLabel") then
                tween_service:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {ImageTransparency = 1}):Play()
            elseif v:IsA("UIStroke") then 
                tween_service:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Transparency = 1}):Play()
            end 
        end 

        task.wait(1)
        watermark_outline:Destroy()
    end)    
end 

function library:tab(options)	
    local cfg = {
        name = options.name or "tab", 
        enabled = false, 
    }
    
    local tab_holder = library:create("TextButton", {
        Parent = self.tab_holder,
        FontFace = library.font,
        TextColor3 = themes.preset.text,
        BorderColor3 = rgb(0, 0, 0),
        Text = "",
        Name = "\0",
        BorderSizePixel = 0,
        Size = dim2(0, 0, 1, -2),
        ZIndex = 5,
        TextSize = 12,
        BackgroundColor3 = themes.preset.outline,
        AutoButtonColor = false
    }) library:apply_theme(tab_holder, "outline", "BackgroundColor3") 

    local inline = library:create("Frame", {
        Parent = tab_holder,
        Size = dim2(1, -2, 1, 0),
        Name = "\0",
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        ZIndex = 5,
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.inline
    }) library:apply_theme(inline, "inline", "BackgroundColor3") 

    local background = library:create("Frame", {
        Parent = inline,
        Size = dim2(1, -2, 1, -1),
        Name = "\0",
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        ZIndex = 5,
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })

    local UIGradient = library:create("UIGradient", {
        Parent = background,
        Rotation = 90,
        Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))}
    }) library:apply_theme(UIGradient, "contrast", "Color") 

    local text = library:create("TextLabel", {
        Parent = background,
        FontFace = library.font,
        TextColor3 = themes.preset.text,
        BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name,
        Name = "\0",
        BackgroundTransparency = 1,
        Size = dim2(1, 0, 1, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 12,
        ZIndex = 5,
        BackgroundColor3 = rgb(255, 255, 255)
    }, "text")
    library:apply_theme(text, "accent", "TextColor3")

    local section_holder = library:create("Frame", {
        Parent = library.section_holder,
        BackgroundTransparency = 1,
        Name = "\0",
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 1, 0),
        BorderSizePixel = 0,
        Visible = false,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    cfg["holder"] = section_holder

    library:create("UIListLayout", {
        Parent = section_holder,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        Padding = dim(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    function cfg.open_tab()
        if library.current_tab and library.current_tab[1] ~= background then 
            local button = library.current_tab[1]
            button.Size = dim2(1, -2, 1, -1)
            button:FindFirstChildOfClass("UIGradient").Rotation = 90
            button:FindFirstChildOfClass("TextLabel").TextColor3 = themes.preset.text
                
            library.current_tab[2].Visible = false
            
            library.current_tab = nil
        end
        
        library.current_tab = {
            background, section_holder
        }
        
        local button = library.current_tab[1] 
        button.Size = dim2(1, -2, 1, 0)
        button:FindFirstChildOfClass("UIGradient").Rotation = -90
        button:FindFirstChildOfClass("TextLabel").TextColor3 = themes.preset.accent 

        library.current_tab[2].Visible = true 

        if library.current_element_open and library.current_element_open ~= cfg then 
            library.current_element_open.set_visible(false)
            library.current_element_open.open = false 
            library.current_element_open = nil 
        end
    end
    
    tab_holder.MouseButton1Click:Connect(cfg.open_tab)
    
    return setmetatable(cfg, library) 
end

function library:column(path) 
    local cfg = {}
    local holder = path or self.holder
    
    local column = library:create("Frame", {
        Parent = holder,
        BackgroundTransparency = 1,
        Name = "\0",
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.inline
    }) library:apply_theme(column, "inline", "BackgroundColor3") 
    
    library:create("UIListLayout", {
        Parent = column,
        Padding = dim(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalFlex = Enum.UIFlexAlignment.Fill
    })
    
    cfg["holder"] = column

    return setmetatable(cfg, library) 
end

function library:multi_section(options)
    local cfg = {
        names = options.names or {"First", "Second", "Third"}, 
        sections = {},
    }

    local section = library:create("Frame", {
        Parent = self.holder,
        Name = "",
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.inline
    }) library:apply_theme(section, "inline", "BackgroundColor3")
    
    local inline = library:create("Frame", {
        Parent = section,
        Name = "",
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.outline
    }) library:apply_theme(inline, "outline", "BackgroundColor3") 
    
    local __background = library:create("Frame", {
        Parent = inline,
        Name = "",
        ClipsDescendants = true,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    return setmetatable(cfg, library)
end
