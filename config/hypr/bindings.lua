-- Set programs that you use
local terminal = "ghostty"
local fileManager = "nautilus"
local menu = "walker"
local swayosd = "swayosd-client"
local browser = "firefox"

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local webapp = "uwsm app -- chromium --new-window --ozone-platform=wayland --app="

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal .. " -e tmux") , { description = "Open the terminal" })

hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "Close window" })
hl.bind(mainMod .. " + W", hl.dsp.window.close(), { description = "Close window" })
-- bind = $mainMod, M, exit,
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager) , { description = "Open file manager" })
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser) , { description = "Open browser" })
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle window floating/tiling" })
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu) , { description = "Open file launcher" })
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo(), { description = "Pseudo window" })
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"), { description = "Toggle window split" })
hl.bind(mainMod .. " + F12", hl.dsp.exec_cmd("hyprshot -m output") , { description = "Take screenshot" })
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session") , { description = "Lock computer" })
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(webapp .. "https://chatgpt.com") , { description = "Open ChatGPT" })
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(webapp .. "https://web.whatsapp.com/") , { description = "Open WhatsApp" })
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(webapp .. "https://app.slack.com/client/E04PJEHPW9K/C0399LQH0") , { description = "Open Slack" })
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(webapp .. "https://teams.microsoft.com") , { description = "Open Teams" })
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(webapp .. "https://outlook.office.com/mail") , { description = "Open Outlook" })

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }), { description = "Full screen" })

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + LEFT", hl.dsp.focus({ direction = "l" }), { description = "Focus on left window" })
hl.bind(mainMod .. " + RIGHT", hl.dsp.focus({ direction = "r" }), { description = "Focus on right window" })
hl.bind(mainMod .. " + UP", hl.dsp.focus({ direction = "u" }), { description = "Focus on above window" })
hl.bind(mainMod .. " + DOWN", hl.dsp.focus({ direction = "d" }), { description = "Focus on below window" })

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
-- Move active window to a workspace silently with mainMod + SHIFT + ALT + [0-9]
for workspace = 1, 10 do
  local key = "code:" .. tostring(workspace + 9)
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = tostring(workspace) }), { description = "Switch to workspace " .. workspace })
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = tostring(workspace) }), { description = "Move window to workspace " .. workspace })
  hl.bind(mainMod .. " + SHIFT + ALT + " .. key, hl.dsp.window.move({ workspace = tostring(workspace), follow = false }), { description = "Move window silently to workspace " .. workspace })
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Scroll active workspace forward" })
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Scroll active workspace backward" })

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

-- Keyboard volume knob for pulseaudio
-- https://wiki.gentoo.org/wiki/Hyprland#Sound_volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(swayosd .. " --output-volume raise"), { locked = true, repeating = true, description = "Volume up" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(swayosd .. " --output-volume lower"), { locked = true, repeating = true, description = "Volume down" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(swayosd .. " --output-volume mute-toggle"), { locked = true, repeating = true, description = "Mute" })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +10%"), { locked = true, repeating = true, description = "Brightness up" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"), { locked = true, repeating = true, description = "Brightness down" })
