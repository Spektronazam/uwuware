--!strict
--[[
    uwuware reborn — example script
    demonstrates every element + new features (resize, animations, config simulation)
    
    original by jans (~5 years ago), rewrite for modern luau
]]

------------------------------ Load the library ----------------------------

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Spektronazam/uwuware/refs/heads/main/source", true))()

------------------------------ Create windows ------------------------------

--// Window 1: Main combat/player stuff
local Combat = Library:CreateWindow("Combat")

--// Window 2: Visuals
local Visuals = Library:CreateWindow("Visuals")

--// Window 3: Misc utilities
local Misc = Library:CreateWindow("Miscellaneous")

--// Window 4: Settings (demonstrates canInit — this window loads with everything else)
local Settings = Library:CreateWindow("Settings")

-- You can prevent a window from loading on Init if needed:
-- Settings.canInit = false

------------------------------ COMBAT WINDOW ------------------------------

-- Labels are just static text, useful for section headers or info
Combat:AddLabel({ text = "Aimbot" })

-- Basic toggle — prints state to console
local aimbotToggle = Combat:AddToggle({
    text = "Enable Aimbot",
    flag = "aimbot_enabled",     -- unique flag name for library.flags
    state = false,               -- default off
    callback = function(enabled: boolean)
        print("[Combat] Aimbot:", enabled)
    end,
})

-- Slider for FOV — floating point with 0.5 steps
Combat:AddSlider({
    text = "Aimbot FOV",
    flag = "aimbot_fov",
    min = 10,
    max = 500,
    value = 120,
    float = 0.5,               -- snap to nearest 0.5
    callback = function(value: number)
        print("[Combat] FOV set to:", value)
    end,
})

-- Slider with negative range (demonstrates the fill bar going both directions)
Combat:AddSlider({
    text = "Aim Offset Y",
    flag = "aim_offset_y",
    min = -50,
    max = 50,
    value = 0,
    float = 1,
    callback = function(value: number)
        print("[Combat] Y Offset:", value)
    end,
})

-- Dropdown list for target selection
local targetList = Combat:AddList({
    text = "Target Part",
    flag = "target_part",
    value = "Head",
    values = { "Head", "Torso", "HumanoidRootPart", "Random" },
    callback = function(selected: string)
        print("[Combat] Targeting:", selected)
    end,
})

-- Color picker for aimbot FOV circle
Combat:AddColor({
    text = "FOV Color",
    flag = "fov_color",
    color = Color3.fromRGB(255, 65, 65),   -- default red accent
    callback = function(color: Color3)
        print("[Combat] FOV circle color:", color)
    end,
})

-- Folder inside combat window — nest anything
local meleeFolder = Combat:AddFolder("Melee")

meleeFolder:AddToggle({
    text = "Auto Swing",
    flag = "auto_swing",
    state = false,
    callback = function(enabled: boolean)
        print("[Melee] Auto swing:", enabled)
    end,
})

meleeFolder:AddSlider({
    text = "Swing Delay (ms)",
    flag = "swing_delay",
    min = 0,
    max = 500,
    value = 100,
    float = 10,
    callback = function(value: number)
        print("[Melee] Delay:", value, "ms")
    end,
})

-- You can even nest folders inside folders
local advancedMelee = meleeFolder:AddFolder("Advanced")

advancedMelee:AddToggle({
    text = "Prediction",
    flag = "melee_prediction",
    state = true,
    callback = function(enabled: boolean)
        print("[Melee/Advanced] Prediction:", enabled)
    end,
})

------------------------------ VISUALS WINDOW -----------------------------

Visuals:AddLabel({ text = "ESP" })

Visuals:AddToggle({
    text = "Box ESP",
    flag = "box_esp",
    state = false,
    callback = function(enabled: boolean)
        print("[Visuals] Box ESP:", enabled)
    end,
})

Visuals:AddToggle({
    text = "Name ESP",
    flag = "name_esp",
    state = false,
    callback = function(enabled: boolean)
        print("[Visuals] Name ESP:", enabled)
    end,
})

-- Color picker — you can also pass a table {R, G, B} (0-1 range) for JSON config loading
Visuals:AddColor({
    text = "ESP Color",
    flag = "esp_color",
    color = { 0, 1, 0.5 },    -- table form: Color3.new(0, 1, 0.5)
    callback = function(color: Color3)
        print("[Visuals] ESP color:", color)
    end,
})

Visuals:AddColor({
    text = "Chams Color",
    flag = "chams_color",
    color = Color3.fromRGB(120, 80, 255),
    callback = function(color: Color3)
        print("[Visuals] Chams color:", color)
    end,
})

Visuals:AddSlider({
    text = "ESP Distance",
    flag = "esp_distance",
    min = 100,
    max = 2000,
    value = 500,
    float = 50,
    callback = function(value: number)
        print("[Visuals] Max distance:", value)
    end,
})

-- Dropdown with dynamic values — you can add/remove later
local espStyleList = Visuals:AddList({
    text = "Box Style",
    flag = "box_style",
    value = "2D",
    values = { "2D", "3D", "Corner" },
    callback = function(selected: string)
        print("[Visuals] Box style:", selected)
    end,
})

-- Demonstrate adding a value to a list after creation
task.delay(2, function()
    espStyleList:AddValue("Rounded")
    print("[Demo] Added 'Rounded' to box style list")
end)

local crosshairFolder = Visuals:AddFolder("Crosshair")

crosshairFolder:AddToggle({
    text = "Custom Crosshair",
    flag = "custom_crosshair",
    state = false,
    callback = function(enabled: boolean)
        print("[Crosshair] Enabled:", enabled)
    end,
})

crosshairFolder:AddSlider({
    text = "Size",
    flag = "crosshair_size",
    min = 2,
    max = 30,
    value = 8,
    float = 1,
    callback = function(value: number)
        print("[Crosshair] Size:", value)
    end,
})

crosshairFolder:AddColor({
    text = "Crosshair Color",
    flag = "crosshair_color",
    color = Color3.fromRGB(0, 255, 0),
    callback = function(color: Color3)
        print("[Crosshair] Color:", color)
    end,
})

------------------------------ MISC WINDOW --------------------------------

Misc:AddLabel({ text = "Movement" })

Misc:AddToggle({
    text = "Speed Boost",
    flag = "speed_enabled",
    state = false,
    callback = function(enabled: boolean)
        print("[Misc] Speed:", enabled)
    end,
})

Misc:AddSlider({
    text = "Walk Speed",
    flag = "walk_speed",
    min = 16,
    max = 200,
    value = 16,
    float = 1,
    callback = function(value: number)
        print("[Misc] WalkSpeed:", value)
        -- Example real usage:
        -- local char = game.Players.LocalPlayer.Character
        -- if char and char:FindFirstChild("Humanoid") then
        --     char.Humanoid.WalkSpeed = value
        -- end
    end,
})

Misc:AddSlider({
    text = "Jump Power",
    flag = "jump_power",
    min = 50,
    max = 300,
    value = 50,
    float = 5,
    callback = function(value: number)
        print("[Misc] JumpPower:", value)
    end,
})

-- Textbox input — useful for player names, commands, etc.
Misc:AddBox({
    text = "Target Player",
    flag = "target_player",
    value = "",
    callback = function(text: string, enterPressed: boolean?)
        if enterPressed then
            print("[Misc] Searching for player:", text)
        end
    end,
})

-- Button — fires once on click
Misc:AddButton({
    text = "Reset Character",
    flag = "reset_char",
    callback = function()
        print("[Misc] Resetting character...")
        -- local player = game.Players.LocalPlayer
        -- if player.Character then
        --     player.Character:BreakJoints()
        -- end
    end,
})

Misc:AddButton({
    text = "Rejoin Server",
    flag = "rejoin",
    callback = function()
        print("[Misc] Rejoining...")
        -- game:GetService("TeleportService"):TeleportToPlaceInstance(
        --     game.PlaceId, game.JobId
        -- )
    end,
})

-- Keybind — press a key to trigger callback
Misc:AddBind({
    text = "Toggle Fly",
    flag = "fly_bind",
    key = "F",                 -- can be a string or Enum.KeyCode.F
    hold = false,              -- false = toggle, true = hold mode
    callback = function()
        print("[Misc] Fly toggled!")
    end,
})

-- Keybind with hold mode — callback fires while held, and once on release
Misc:AddBind({
    text = "Noclip (Hold)",
    flag = "noclip_bind",
    key = "V",
    hold = true,
    callback = function(released: boolean?)
        if released then
            print("[Misc] Noclip released")
        else
            -- This fires every heartbeat while held
            -- Noclip logic would go here
        end
    end,
})

-- Mouse button as a keybind
Misc:AddBind({
    text = "Trigger Bot",
    flag = "triggerbot_bind",
    key = "MouseButton2",      -- right click
    callback = function()
        print("[Misc] Triggerbot fired!")
    end,
})

------------------------------ SETTINGS WINDOW ----------------------------

Settings:AddLabel({ text = "UI Settings" })

-- Toggle UI visibility keybind
Settings:AddBind({
    text = "Toggle UI",
    flag = "toggle_ui",
    key = "RightShift",
    callback = function()
        Library:Close()
    end,
})

-- ══════════════════════════════════════════════
-- NEW FEATURE: Resize all windows programmatically
-- Useful when loading a config that was saved at a different width
-- ══════════════════════════════════════════════
Settings:AddSlider({
    text = "UI Width",
    flag = "ui_width",
    min = 200,
    max = 420,
    value = 230,
    float = 5,
    callback = function(value: number)
        Library:ResizeWindows(value)
        print("[Settings] UI width resized to:", value)
    end,
})

Settings:AddButton({
    text = "Reset Width",
    flag = "reset_width",
    callback = function()
        Library:ResizeWindows(230)   -- back to default
        print("[Settings] Width reset to default")
    end,
})

-- Simulate "load config" — just resets some flags and resizes
Settings:AddButton({
    text = "Load Fake Config",
    flag = "load_config",
    callback = function()
        print("[Settings] Loading fake config...")

        -- Simulate config values
        aimbotToggle:SetState(true)
        targetList:SetValue("Torso")

        -- Config was saved at width 300, so resize to that
        Library:ResizeWindows(300)

        print("[Settings] Config loaded!")
    end,
})

-- Demonstrate dynamically changing a label
local infoLabel = Settings:AddLabel({ text = "Status: Idle" })

task.delay(3, function()
    infoLabel.Text = "Status: Running"
    print("[Demo] Label text updated")
end)

-- Demonstrate dynamically changing window title
task.delay(5, function()
    Settings:SetTitle("Settings ✓")
    print("[Demo] Window title updated")
end)

------------------------------ INITIALIZE ---------------------------------
--[[
    This is where the magic happens:
    1. ScreenGui is created and parented
    2. Loading throbber fades in and spins
    3. All windows are built while throbber shows
    4. Throbber decelerates and fades out
    5. Windows slide in from center to their positions
    
    On close (RightShift by default):
    1. Windows resize back to original size
    2. Slide to center of screen
    3. Fade out
    
    On reopen:
    1. Appear at center
    2. Slide back to original position
    3. Fade in
]]

Library:Init()

------------------------------ POST-INIT NOTES ----------------------------
--[[
    ═══════════════════════════════════════════════════════════════
    READING FLAGS
    ═══════════════════════════════════════════════════════════════
    
    All option values are stored in Library.flags with their flag name:
    
        Library.flags["aimbot_enabled"]   → boolean
        Library.flags["aimbot_fov"]       → number
        Library.flags["target_part"]      → string
        Library.flags["fov_color"]        → Color3
        Library.flags["fly_bind"]         → string (key name)
        Library.flags["target_player"]    → string
    
    You can read these from anywhere:
    
        if Library.flags["aimbot_enabled"] then
            -- do aimbot with FOV = Library.flags["aimbot_fov"]
        end
    
    ═══════════════════════════════════════════════════════════════
    PROGRAMMATIC CONTROL
    ═══════════════════════════════════════════════════════════════
    
    -- Set a toggle:
    aimbotToggle:SetState(true)
    
    -- Set a slider:
    -- (access the returned option from AddSlider and call :SetValue)
    
    -- Set a dropdown:
    targetList:SetValue("Torso")
    
    -- Set a keybind:
    -- bindOption:SetKey(Enum.KeyCode.G)
    -- bindOption:SetKey("G")
    
    -- Set a color:
    -- colorOption:SetColor(Color3.fromRGB(0, 255, 128))
    
    -- Set a textbox:
    -- boxOption:SetValue("some text")
    
    -- Add/remove dropdown values dynamically:
    -- listOption:AddValue("NewOption")
    -- listOption:RemoveValue("OldOption")
    
    -- Resize all windows (e.g. on config load):
    Library:ResizeWindows(300)
    
    -- Toggle UI:
    Library:Close()
    
    ═══════════════════════════════════════════════════════════════
    RESIZE
    ═══════════════════════════════════════════════════════════════
    
    Users can drag the bottom-right grip of any window to resize
    it horizontally (min 200px, max 420px).
    
    When Library:Close() is called, windows tween back to their
    original size before sliding to center and fading out.
    
    When Library:ResizeWindows(width) is called (e.g. from a
    config load), all windows smoothly tween to that width.
    
    ═══════════════════════════════════════════════════════════════
    FOLDERS
    ═══════════════════════════════════════════════════════════════
    
    Folders work exactly like windows — they support every element:
    
        local folder = Window:AddFolder("Section Name")
        folder:AddToggle({...})
        folder:AddSlider({...})
        folder:AddFolder("Nested!")  -- infinite nesting
    
]]
