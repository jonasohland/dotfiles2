-- vim: ft=lua
--
-- Hyprland config for jonas-thinkpad.
-- Reference: https://wiki.hypr.land/Configuring/Core/

-- hl.config({ experimental = { wp_cm_1_2 = true } })

-- This file is symlinked in from a dotfiles repo, and `require` resolves
-- relative to the *real* path of this file, not to ~/.config/hypr. Put the
-- hypr config dir on package.path so `require("common")` & co. work anyway.
local configDir = (os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")) .. "/hypr"
package.path = configDir .. "/?.lua;" .. package.path

---------------------
---- MY PROGRAMS ----
---------------------

-- Global, read by common.lua (replaces the old $terminal / $fileManager / $menu)
Apps = {
    terminal    = "alacritty",
    fileManager = "caja",
    menu        = 'rofi -show drun -run-command "uwsm app -- {cmd}"',
}

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("uwsm app -u wl-paste-text.scope -- wl-paste --type text --watch cliphist store")
    hl.exec_cmd("uwsm app -u wl-paste-images.scope -- wl-paste --type image --watch cliphist store")
end)

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = 1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
    },

    input = {
        kb_layout  = "us",
        kb_variant = "altgr-intl",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },

    cursor = {
        no_hardware_cursors = 1,
    },

    xwayland = {
        force_zero_scaling = true,
    },
})

------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "eDP-1",
    mode     = "2880x1800@60",
    position = "0x0",
    scale    = 1.5,
})

require("common")
require("hdmi")

------------------------
---- HOST KEYBINDS  ----
------------------------

hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("uwsm app -- bluetooth-options-menu"))
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("uwsm app -- refresh-rate-menu"))

-- Laptop multimedia keys for volume and LCD brightness
local elFlags = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ -l 1.0 5%+ > /dev/null; pkill -RTMIN+8 waybar"), elFlags)
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ -l 1.0 5%- > /dev/null; pkill -RTMIN+8 waybar"), elFlags)
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle; pkill -RTMIN+8 waybar"),                   elFlags)
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),                                        elFlags)
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s 5%+ --exponent=2.5 -q"),                                               elFlags)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%- --exponent=2.5 -q"),                                               elFlags)

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
