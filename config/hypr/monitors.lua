-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.env("GDK_SCALE", "1.75")

hl.monitor({
  output = "HDMI-A-1",
  mode = "3840x2160@119.88",
  scale = 1.6,
  vrr = 3
})

hl.monitor({
  output = "eDP-1",
  mode = "2880x1800@120.00",
  scale = 1.6,
  vrr = 1
})

hl.monitor({
  output = "DP-1",
  mode = "3440x1440@99.98",
  scale = 1.25,
})
