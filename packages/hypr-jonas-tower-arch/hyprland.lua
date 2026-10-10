-- vim: ft=lua
--
-- Hyprland config for jonas-tower-arch.
-- Reference: https://wiki.hypr.land/Configuring/Core/

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

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("MOZ_DISABLE_RDD_SANDBOX", "1")
hl.env("XDG_MENU_PREFIX", "arch-")

----------------
----  MISC  ----
----------------

hl.config({
    cursor = {
        no_hardware_cursors = true,
    },

    input = {
        kb_layout  = "us",
        kb_variant = "altgr-intl",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0,

        touchpad = {
            natural_scroll = false,
        },
    },

    misc = {
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
    },
})

------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "DP-3",
    mode     = "5120x1440@69.97",
    position = "0x0",
    scale    = 1,
})

require("common")

------------------------
---- HOST KEYBINDS  ----
------------------------

hl.bind("SUPER + SHIFT + V", hl.dsp.exec_cmd("sudo systemctl --machine riedel-vpn --user start vpnui-at-login.service"))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("sudo systemctl --machine riedel-vpn --user stop vpnui-at-login.service"))
