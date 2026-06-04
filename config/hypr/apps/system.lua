-- Floating windows
hl.window_rule({ match = { tag = "floating-window" }, float = true })
hl.window_rule({ match = { tag = "floating-window" }, center = true })
hl.window_rule({ match = { tag = "floating-window" }, size = { 875, 600 } })

hl.window_rule({ match = { class = "(blueberry.py|Impala|Wiremix|org.gnome.NautilusPreviewer)" }, tag = "+floating-window" })
hl.window_rule({ match = { class = "(xdg-desktop-portal-gtk|org.gnome.Nautilus)", title = "^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files|.*wants to [open|save].*|[C|c]hoose.*)" }, tag = "+floating-window" })

-- No transparency on media windows
hl.window_rule({ match = { class = "^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$" }, opacity = "1 1" })

-- Popped window rounding
hl.window_rule({ match = { tag = "pop" }, rounding = 8 })
