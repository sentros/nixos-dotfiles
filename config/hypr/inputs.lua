-- https://wiki.hyprland.org/Configuring/Variables/--input
hl.config({
  input = {
    kb_layout = "fi",
    kb_variant = "",
    kb_model = "",
    kb_options = "compose:caps",
    kb_rules = "",
    follow_mouse = 1,
    sensitivity = 0,

    touchpad = {
      natural_scroll = false,
      tap_to_click = false,
      clickfinger_behavior = true,
    },
  },
  misc = {
    key_press_enables_dpms = true,
    mouse_move_enables_dpms = true,
  },
})
