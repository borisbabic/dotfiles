hl.monitor({
  output = "eDP-1",
  mode = "2560x1600@165.000",
  scale = "1.6",
  position = "520x1440",
  vrr = 1,
  bitdepth = 10,
  sdrsaturation = 1.5
})
hl.monitor({
  output = "HDMI-A-2",
  mode = "3840x2160@120.00Hz",
  scale = "1.5",
  position = "0x0",
  vrr = 1,
  bitdepth = 10,
  sdrsaturation = 1.5
})
hl.monitor({
  output = "DP-2",
  mode = "preferred",
  scale = "2",
  transform = 1,
  position = "2560x0",
  vrr = 0
})

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})
