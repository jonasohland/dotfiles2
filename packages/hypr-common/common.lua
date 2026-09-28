-- vim: ft=lua
--
-- Shared Hyprland config, required from each host's hyprland.lua.
--
-- The host config may define a global `Apps` table *before* requiring this
-- file to override the programs bound below (the old $terminal / $fileManager
-- / $menu hyprlang variables):
--
--   Apps = { terminal = "alacritty", fileManager = "caja", menu = "rofi ..." }
--   require("common")

local apps        = Apps or {}
local terminal    = apps.terminal or "alacritty"
local fileManager = apps.fileManager or "caja"
local menu        = apps.menu or 'rofi -show drun -run-command "uwsm app -- {cmd}"'

-- Run a program as its own uwsm-managed scope, like `uwsm app -- <cmd>` did.
local function app(cmd)
    return hl.dsp.exec_cmd("uwsm app -- " .. cmd)
end

------------------------
---- LOOK AND FEEL  ----
------------------------

hl.config({
    general = {
        gaps_in  = 1,
        gaps_out = 3,

        border_size = 1,

        -- https://wiki.hypr.land/Configuring/Core/Config-options/ for info about colors
        col = {
            active_border   = { colors = { "rgb(808080)", "rgb(595959)" } },
            inactive_border = "rgba(505050aa)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,

        -- Please see https://wiki.hypr.land/Configuring/Extra/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding = 4,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 0.92,

        shadow = {
            enabled      = false,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 2,

            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = false,
    },

    dwindle = {
        preserve_split = true, -- You probably want this
    },

    master = {
        new_status = "master",
    },
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

hl.bind(mainMod .. " + Q", app(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + E", app(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", app(menu))
hl.bind(mainMod .. " + B", app("firefox"))
hl.bind(mainMod .. " + T", app("teams-for-linux.desktop"))
hl.bind(mainMod .. " + M", app("microsoft-edge-stable --app=https://music.apple.com"))
hl.bind(mainMod .. " + P", app("microsoft-edge-stable --app=https://podcasts.apple.com"))
hl.bind(mainMod .. " + X", app("hyprlock"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + S", app("hyprshot -m region"))

hl.bind(mainMod .. " + O", app("wpctl set-default $(pw-select-node-menu -f media.class=Audio/Sink)"))
hl.bind(mainMod .. " + I", app("wpctl set-default $(pw-select-node-menu -f media.class=Audio/Source)"))
hl.bind(mainMod .. " + SHIFT + O", app("pw-select-route-menu sink"))
hl.bind(mainMod .. " + SHIFT + I", app("pw-select-route-menu source"))

-- Move focus with mainMod + hjkl
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Move the active window with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.window.move({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    name  = "no-maximize",
    match = { class = ".*" },

    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "xwayland-fix",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name    = "fix-opacity-youtube",
    match   = { title = "^.*- YouTube — Mozilla Firefox$" },
    opacity = "1.0 override",
})

hl.window_rule({
    name    = "fix-opacity-obs",
    match   = { class = "com.obsproject.Studio" },
    opacity = "1.0 override",
})

hl.window_rule({
    name    = "fix-opacity-alacritty",
    match   = { class = "Alacritty" },
    opacity = "0.97 0.93 override",
})

hl.window_rule({
    name  = "tile-chrome",
    match = { class = "Google-chrome" },
    tile  = true,
})

hl.window_rule({
    name  = "tile-edge",
    match = { class = "Microsoft-edge" },
    tile  = true,
})

hl.window_rule({
    name  = "no-tile-gst",
    match = { class = "GStreamer" },
    tile  = false,
})

hl.window_rule({
    name    = "fix-opacity-mpv",
    match   = { class = "mpv" },
    opacity = "1.0 override",
})

hl.window_rule({
    name    = "pip-opacity",
    match   = { title = "^Picture-in-Picture$" },
    opacity = "1.0 override",
})
