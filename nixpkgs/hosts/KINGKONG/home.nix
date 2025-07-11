{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}: let
  customOhMyZshTheme = ''
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' stagedstr '%F{green}●'
    zstyle ':vcs_info:*' unstagedstr '%F{yellow}●'
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:svn:*' branchformat '%b'
    zstyle ':vcs_info:svn:*' formats ' [%b%F{1}:%F{11}%i%c%u%B%F{green}]'
    zstyle ':vcs_info:*' enable git svn

    theme_precmd () {
      if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
        zstyle ':vcs_info:git:*' formats ' [%b%c%u%B%F{green}]'
      else
        zstyle ':vcs_info:git:*' formats ' [%b%c%u%B%F{red}●%F{green}]'
      fi

      vcs_info
    }

    setopt prompt_subst
    PROMPT='[%*] %B%F{magenta}%~%B%F{green}''${vcs_info_msg_0_}%B%F{magenta} %{$reset_color%}%% '

    autoload -U add-zsh-hook
    add-zsh-hook precmd  theme_precmd
  '';
  prependedZshCustom = ''
    export ZSH_CUSTOM="${config.home.homeDirectory}/.oh-my-zsh/custom"
  '';
in {
  home.username = "john";
  home.homeDirectory = "/home/john";
  home.stateVersion = "25.05";

  # write oh-my-zsh theme file
  home.file.".oh-my-zsh/custom/themes/sentros.zsh-theme".text = customOhMyZshTheme;

  # set path file to custom folder
  home.file.".zshrc".text = ''
    ${prependedZshCustom}
  '';

  home.packages = with pkgs; [
    bat
    eza
    telegram-desktop
    tree
    nixfmt-rfc-style
    libreoffice
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor=, 3840x2160@119.88Hz, 0x0, 1.6, vrr, 1, bitdepth, 10, cm, wide

      # Set programs that you use
      $terminal = ghostty
      $fileManager = nautilus
      $menu = wofi

        # See https://wiki.hyprland.org/Configuring/Environment-variables/

        env = XCURSOR_SIZE,24
        env = HYPRCURSOR_SIZE,24

        # https://wiki.hyprland.org/Configuring/Variables/#general
        general {
            gaps_in = 5
            gaps_out = 20

            border_size = 2

            # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
            col.active_border = rgb(c6d0f5)
            col.inactive_border = rgba(595959aa)

            # Set to true enable resizing windows by clicking and dragging on borders and gaps
            resize_on_border = false

            # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
            allow_tearing = false

            layout = dwindle
        }

        # https://wiki.hyprland.org/Configuring/Variables/#decoration
        decoration {
            rounding = 10
            rounding_power = 2

            # Change transparency of focused and unfocused windows
            active_opacity = 1.0
            inactive_opacity = 1.0

            shadow {
                enabled = true
                range = 4
                render_power = 3
                color = rgba(1a1a1aee)
            }

            # https://wiki.hyprland.org/Configuring/Variables/#blur
            blur {
                enabled = true
                size = 3
                passes = 1

                vibrancy = 0.1696
            }
        }

        # https://wiki.hyprland.org/Configuring/Variables/#animations
        animations {
            enabled = yes, please :)

            # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

            bezier = easeOutQuint,0.23,1,0.32,1
            bezier = easeInOutCubic,0.65,0.05,0.36,1
            bezier = linear,0,0,1,1
            bezier = almostLinear,0.5,0.5,0.75,1.0
            bezier = quick,0.15,0,0.1,1

            animation = global, 1, 10, default
            animation = border, 1, 5.39, easeOutQuint
            animation = windows, 1, 4.79, easeOutQuint
            animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
            animation = windowsOut, 1, 1.49, linear, popin 87%
            animation = fadeIn, 1, 1.73, almostLinear
            animation = fadeOut, 1, 1.46, almostLinear
            animation = fade, 1, 3.03, quick
            animation = layers, 1, 3.81, easeOutQuint
            animation = layersIn, 1, 4, easeOutQuint, fade
            animation = layersOut, 1, 1.5, linear, fade
            animation = fadeLayersIn, 1, 1.79, almostLinear
            animation = fadeLayersOut, 1, 1.39, almostLinear
            animation = workspaces, 1, 1.94, almostLinear, fade
            animation = workspacesIn, 1, 1.21, almostLinear, fade
            animation = workspacesOut, 1, 1.94, almostLinear, fade
        }

        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        dwindle {
            pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
            preserve_split = true # You probably want this
        }

        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        master {
            new_status = master
        }

        # https://wiki.hyprland.org/Configuring/Variables/#misc
        misc {
            force_default_wallpaper = -1 # Set to 0 or 1 to disable the anime mascot wallpapers
            disable_hyprland_logo = false # If true disables the random hyprland logo / anime girl background. :(
        }

        # https://wiki.hyprland.org/Configuring/Variables/#input
        input {
            kb_layout = fi
            kb_variant =
            kb_model =
            kb_options =
            kb_rules =

            follow_mouse = 1

            sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

            touchpad {
                natural_scroll = false
            }
        }

        # https://wiki.hyprland.org/Configuring/Variables/#gestures
        gestures {
            workspace_swipe = false
        }

        ###################
        ### KEYBINDINGS ###
        ###################

        # See https://wiki.hyprland.org/Configuring/Keywords/
        $mainMod = SUPER # Sets "Windows" key as main modifier

        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        bind = $mainMod, RETURN, exec, $terminal
        bind = $mainMod, Q, killactive,
        bind = $mainMod, M, exit,
        bind = $mainMod, E, exec, $fileManager
        bind = $mainMod, B, exec, firefox
        bind = $mainMod, V, togglefloating,
        bind = $mainMod, SPACE, exec, $menu
        bind = $mainMod, P, pseudo, # dwindle
        bind = $mainMod, J, togglesplit, # dwindle
        bind = $mainMod, F12, exec, hyprshot -m output
        bind = $mainMod, L, exec, loginctl lock-session

        # Move focus with mainMod + arrow keys
        bind = $mainMod, left, movefocus, l
        bind = $mainMod, right, movefocus, r
        bind = $mainMod, up, movefocus, u
        bind = $mainMod, down, movefocus, d

        # Switch workspaces with mainMod + [0-9]
        bind = $mainMod, 1, workspace, 1
        bind = $mainMod, 2, workspace, 2
        bind = $mainMod, 3, workspace, 3
        bind = $mainMod, 4, workspace, 4
        bind = $mainMod, 5, workspace, 5
        bind = $mainMod, 6, workspace, 6
        bind = $mainMod, 7, workspace, 7
        bind = $mainMod, 8, workspace, 8
        bind = $mainMod, 9, workspace, 9
        bind = $mainMod, 0, workspace, 10

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        bind = $mainMod SHIFT, 1, movetoworkspace, 1
        bind = $mainMod SHIFT, 2, movetoworkspace, 2
        bind = $mainMod SHIFT, 3, movetoworkspace, 3
        bind = $mainMod SHIFT, 4, movetoworkspace, 4
        bind = $mainMod SHIFT, 5, movetoworkspace, 5
        bind = $mainMod SHIFT, 6, movetoworkspace, 6
        bind = $mainMod SHIFT, 7, movetoworkspace, 7
        bind = $mainMod SHIFT, 8, movetoworkspace, 8
        bind = $mainMod SHIFT, 9, movetoworkspace, 9
        bind = $mainMod SHIFT, 0, movetoworkspace, 10

        # Example special workspace (scratchpad)
        bind = $mainMod, S, togglespecialworkspace, magic
        bind = $mainMod SHIFT, S, movetoworkspace, special:magic

        # Scroll through existing workspaces with mainMod + scroll
        bind = $mainMod, mouse_down, workspace, e+1
        bind = $mainMod, mouse_up, workspace, e-1

        # Move/resize windows with mainMod + LMB/RMB and dragging
        bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod, mouse:273, resizewindow

        # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
        # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

        # Ignore maximize requests from apps. You'll probably like this.
        windowrule = suppressevent maximize, class:.*

        # Fix some dragging issues with XWayland
        windowrule = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
        windowrulev2 = opacity 0.9, class:^(com.mitchellh.ghostty)$

        # unscale XWayland
        xwayland {
          force_zero_scaling = true
        }
    '';
  };

  programs.wofi = {
    enable = true;
    settings = {
      width = 600;
      height = 350;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 40;
      gtk_dark = true;
    };
    style = ''
      @define-color	selected-text  #8caaee;
      @define-color	text  #c6d0f5;
      @define-color	base  #24273a;

      * {
      font-family: 'CaskaydiaMono Nerd Font', monospace;
      font-size: 18px;
      }

      window {
      margin: 0px;
      padding: 20px;
      background-color: @base;
      opacity: 0.95;
      }

      #inner-box {
      margin: 0;
      padding: 0;
      border: none;
      background-color: @base;
      }

      #outer-box {
      margin: 0;
      padding: 20px;
      border: none;
      background-color: @base;
      }

      #scroll {
      margin: 0;
      padding: 0;
      border: none;
      background-color: @base;
      }

      #input {
      margin: 0;
      padding: 10px;
      border: none;
      background-color: @base;
      color: @text;
      }

      #input:focus {
      outline: none;
      box-shadow: none;
      border: none;
      }

      #text {
      margin: 5px;
      border: none;
      color: @text;
      }

      #entry {
      background-color: @base;
      }

      #entry:selected {
      outline: none;
      border: none;
      }

      #entry:selected #text {
      color: @selected-text;
      }

      #entry image {
      -gtk-icon-transform: scale(0.7);
      }
    '';
  };
  # Configure idle times that lock / suspend machine in hyprland
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  # Configure lock screen and behaviour in hyprland
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = false;
        no_fade_in = false;
      };

      background = [
        {
          color = "rgba(24,24,36,1.0)";
        }
      ];

      animations = {
        enabled = false;
      };

      input-field = [
        {
          size = "600, 100";
          position = "0, 0";
          monitor = "";

          inner_color = "rgba(24,24,36,0.8)";
          outer_color = "rgba(205,214,244,1.0)";
          outline_thickness = 4;

          font_family = "CaskaydiaMono Nerd Font";
          font_size = 32;
          font_color = "rgba(205,214,244,1.0)";

          placeholder_color = "rgba(205,214,244,0.6)";
          placeholder_text = "Enter Password";
          check_color = "rgba(68, 157, 171, 1.0)";
          fail_text = "Wrong";

          rounding = 0;
          shadow_passes = 0;
          fade_on_empty = false;
        }
      ];
    };
  };

  # Configure top bar in hyprland
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      spacing = 0;
      height = 26;

      modules-left = [
        "hyprland/workspaces"
      ];

      modules-center = [
        "clock"
      ];
      modules-right = [
        "systemd-failed-units"
        "bluetooth"
        "network"
        "wireplumber"
        "cpu"
        "memory"
        "temperature"
        "network"
        "custom/power-menu"
      ];

      "hyprland/workspaces" = {
        on-click = "activate";
        format = "{icon}";
        format-icons = {
          default = "";
          "1" = 1;
          "2" = 2;
          "3" = 3;
          "4" = 4;
          "5" = 5;
          "6" = 6;
          "7" = 7;
          "8" = 8;
          "9" = 9;
          active = "󱓻";
        };
        persistent-workspaces = {
          "1" = "[]";
          "2" = "[]";
          "3" = "[]";
          "4" = "[]";
          "5" = "[]";
        };
      };

      clock = {
        timezone = "Europe/Helsinki";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format-alt = "{:%Y-%m-%d}";
      };

      network = {
        format-icons = "[\"󰤯\",\"󰤟\",\"󰤢\",\"󰤥\",\"󰤨\"]";
        format = "{icon}";
        format-wifi = "{icon}";
        format-ethernet = "󰀂";
        format-disconnected = "󰖪";
        tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
        tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
        tooltip-format-disconnected = "Disconnected";
        interval = 3;
        nospacing = 1;
      };

      cpu = {
        format = "{usage}% ";
        tooltip = false;
        on-click = "ghostty -e btop";
      };

      memory = {
        format = "{}% ";
      };

      temperature = {
        hwmon-path = "/sys/class/hwmon/hwmon2/temp13_input";
        critical-threshold = 95;
        format = "{temperatureC}°C ";
      };

      bluetooth = {
        format = "";
        format-disabled = "󰂲";
        format-connected = "";
        tooltip-format = "Devices connected: {num_connections}";
        on-click = "blueberry";
      };

      "systemd-failed-units" = {
        hide-on-ok = false;
        format = "✗ {nr_failed}";
        format-ok = "✓";
        system = true;
        user = true;
      };
      wireplumber = {
        format = "";
        format-muted = "󰝟";
        scroll-step = 5;
        on-click = "helvum";
        tooltip-format = "Playinf at {volume}%";
        on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      };
      "custom/power-menu" = {
        format = "󰐥";
        tooltip = false;
        on-click = pkgs.writeShellScript "power-menu" ''
          #!/bin/bash

          # Power menu from https://github.com/basecamp/omarchy/blob/master/bin/omarchy-power-menu
          # Provides power off, restart, and sleep options

          # Function to show power menu
          show_power_menu() {
            local menu_options="\u200B Lock
          \u200C󰤄 Sleep
          \u200D Relaunch
          \u2060󰜉 Restart
          󰐥\u2063 Shutdown" # These first characters are invisible sort keys

            local selection=$(echo -e "$menu_options" | wofi --show dmenu --prompt "Power Options" --width 200 --height 250 -O alphabetical)

            case "$selection" in
            *Lock*) hyprlock ;;
            *Sleep*) systemctl suspend ;;
            *Relaunch*) hyprctl dispatch exit ;;
            *Restart*) systemctl reboot ;;
            *Shutdown*) systemctl poweroff ;;
            esac
          }

          # Main execution
          show_power_menu
        '';
      };
      style = ''
        * {
          color = #cdd6f4;
          background-color: #181824;
          border: none;
          border-radius: 0;
          font-family: CaskaydiaMono Nerd Font;
          font-size: 12px;
        }


        #workspaces {
          margin-left: 7px;
        }

        #workspaces button {
          all: initial;
          padding: 2px 6px;
          margin-right: 3px;
        }

        #custom-dropbox,
        #cpu,
        #power-profiles-daemon,
        #battery,
        #network,
        #bluetooth,
        #pulseaudio,
        #clock {
          min-width: 12px;
          margin-right: 13px;
        }

        tooltip {
          padding: 2px;
        }

        tooltip label {
          padding: 2px;
        }
      '';
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload = ["/home/john/wallpaper.jpg"];
      wallpaper = [",/home/john/wallpaper.jpg"];
    };
  };

  services.mako = {
    enable = true;
    settings = {
      text-color = "#cad3f5";
      border-color = "#c6d0f5";
      background-color = "#24273a";
      width = 420;
      height = 110;
      padding = 10;
      border-size = 2;
      font = "Liberation Sans 11";
      anchor = "top-right";
      default-timeout = 5000;
      max-icon-size = "32";

      "mode=do-not-disturb" = {
        invisible = true;
      };

      "mode=do-not-disturb app-name=notify-send" = {
        invisible = false;
      };
    };
  };

  # Configure ssh to use 1password for keys
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
          IdentityAgent "~/.1password/agent.sock"
    '';
  };

  programs.eza.enableZshIntegration = true;

  # zsh config
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake /etc/nixos/hosts/#KINGKONG";
      gc = "sudo nix-collect-garbage";
      ls = "eza";
      cat = "bat";
    };
    history = {
      path = "$HOME/.zsh_history";
      save = 10000;
      size = 10000;
      share = true;
      saveNoDups = true;
      findNoDups = true;
      ignoreDups = true;
      ignoreSpace = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
      ];
      theme = "sentros";
    };
  };

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    shortcut = "b";
    terminal = "tmux-256color";
    extraConfig = ''
      set-option -g status-position top
    '';
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"
          set -g status-right-length 100
          set -g status-left-length 100
          set -g status-left ""
          set -g status-right "#{E:@catppuccin_status_application}"
          set -ag status-right "#{E:@catppuccin_status_session}"
          set -ag status-right "#{E:@catppuccin_status_uptime}"
        '';
      }
    ];
  };

  # ghostty terminal config
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      command = "/etc/profiles/per-user/john/bin/zsh";
      shell-integration-features = "cursor,sudo,title";
      clipboard-read = "allow";
      clipboard-write = "allow";
      window-theme = "dark";
      theme = "catppuccin-mocha";
      font-size = 12;
      font-family = "Hack";
    };
  };

  # Mangohud config to control and display fps etc in games
  programs.mangohud = {
    enable = true;
    settings = {
      gpu_temp = true;
      cpu_temp = true;
      vram = true;
      ram = true;
      frame_timing = 0;
      fps_limit = 60;
    };
    # settingsPerApplication = {
    #   Civ7_linux_Vulkan_FinalRelease = {
    #     fps_limit = 60;
    #   };
    #   Civ7_Win64_DX12 = {
    #     fps_limit = 60;
    #   };
    # };
  };

  programs.git = {
    enable = true;
    extraConfig = {
      gpg = {
        format = "ssh";
      };
      "gpg \"ssh\"" = {
        program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      };
      commit = {
        gpgsign = false;
      };

      #     user = {
      #       signingKey = "...";
      #     };
    };
    diff-so-fancy.enable = true;
  };

  programs.firefox = {
    enable = true;
  };

  programs.lutris = {
    enable = true;
    steamPackage = osConfig.programs.steam.package;
    protonPackages = [pkgs.proton-ge-bin];
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catpuccin";
      theme_background = true;
      truecolor = true;
      force_tty = false;
      presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
      vim_keys = false;
      rounded_corners = true;
      graph_symbol = "braille";
      graph_symbol_cpu = "default";
      graph_symbol_gpu = "default";
      graph_symbol_mem = "default";
      graph_symbol_net = "default";
      graph_symbol_proc = "default";
      shown_boxes = "cpu gpu0 mem net proc";
      update_ms = 2000;
      proc_sorting = "cpu lazy";
      proc_reversed = false;
      proc_tree = false;
      proc_colors = true;
      proc_gradient = true;
      proc_per_core = false;
      proc_mem_bytes = true;
      proc_cpu_graphs = true;
      proc_info_smaps = false;
      proc_left = false;
      proc_filter_kernel = false;
      proc_aggregate = false;
      cpu_graph_upper = "Auto";
      cpu_graph_lower = "Auto";
      show_gpu_info = "Auto";
      cpu_invert_lower = true;
      cpu_single_graph = false;
      cpu_bottom = false;
      show_uptime = true;
      check_temp = true;
      cpu_sensor = "nct6799/TSI0_TEMP";
      show_coretemp = true;
      #* Set a custom mapping between core and coretemp, can be needed on certain cpus to get correct temperature for correct core.
      #* Use lm-sensors or similar to see which cores are reporting temperatures on your machine.
      #* Format "x:y" x=core with wrong temp, y=core with correct temp, use space as separator between multiple entries.
      #* Example: "4:0 5:1 6:3"
      cpu_core_map = "";
      temp_scale = "celsius";
      base_10_sizes = false;
      show_cpu_freq = true;
      clock_format = "%X";
      background_update = true;
      custom_cpu_name = "";
      disks_filter = "";
      mem_graphs = true;
      mem_below_net = false;
      zfs_arc_cached = true;
      show_swap = true;
      swap_disk = true;
      show_disks = true;
      only_physical = true;
      use_fstab = true;
      zfs_hide_datasets = false;
      disk_free_priv = false;
      show_io_stat = true;
      io_mode = false;
      io_graph_combined = false;
      io_graph_speeds = "";
      net_download = 600;
      net_upload = 400;
      net_auto = false;
      net_sync = false;
      net_iface = "";
      show_battery = true;
      selected_battery = "Auto";
      log_level = "WARNING";
      nvml_measure_pcie_speeds = true;
      gpu_mirror_graph = true;
      custom_gpu_name0 = "NVIDIA Discrete";
      custom_gpu_name1 = "AMD Integrated";
      custom_gpu_name2 = "";
      custom_gpu_name3 = "";
      custom_gpu_name4 = "";
      custom_gpu_name5 = "";
    };
    themes = {
      catppuccin = ''
        theme[main_bg]="#24273a"
        theme[main_fg]="#c6d0f5"
        theme[title]="#c6d0f5"
        theme[hi_fg]="#8caaee"
        theme[selected_bg]="#51576d"
        theme[selected_fg]="#8caaee"
        theme[inactive_fg]="#838ba7"
        theme[graph_text]="#f2d5cf"
        theme[meter_bg]="#51576d"
        theme[proc_misc]="#f2d5cf"
        theme[cpu_box]="#ca9ee6" #Mauve
        theme[mem_box]="#a6d189" #Green
        theme[net_box]="#ea999c" #Maroon
        theme[proc_box]="#8caaee" #Blue
        theme[div_line]="#737994"
        theme[temp_start]="#a6d189"
        theme[temp_mid]="#e5c890"
        theme[temp_end]="#e78284"
        theme[cpu_start]="#81c8be"
        theme[cpu_mid]="#85c1dc"
        theme[cpu_end]="#babbf1"
        theme[free_start]="#ca9ee6"
        theme[free_mid]="#babbf1"
        theme[free_end]="#8caaee"
        theme[cached_start]="#85c1dc"
        theme[cached_mid]="#8caaee"
        theme[cached_end]="#babbf1"
        theme[available_start]="#ef9f76"
        theme[available_mid]="#ea999c"
        theme[available_end]="#e78284"
        theme[used_start]="#a6d189"
        theme[used_mid]="#81c8be"
        theme[used_end]="#99d1db"
        theme[download_start]="#ef9f76"
        theme[download_mid]="#ea999c"
        theme[download_end]="#e78284"
        theme[upload_start]="#a6d189"
        theme[upload_mid]="#81c8be"
        theme[upload_end]="#99d1db"
        theme[process_start]="#85c1dc"
        theme[process_mid]="#babbf1"
        theme[process_end]="#ca9ee6"
      '';
    };
  };
  programs.fastfetch = {
    enable = true;
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
      logo = {
        padding = {
          top = 5;
          right = 6;
        };
      };
      modules = [
        "break"
        {
          type = "custom";
          format = "┌───────────────────────Hardware──────────────────────┐";
          color = "90";
        }
        {
          type = "chassis";
          key = " PC";
          keyColor = "green";
        }
        {
          type = "board";
          key = "│ ├";
          keyColor = "green";
        }
        {
          type = "cpu";
          key = "│ ├";
          showPeCoreCount = true;
          format = "{1}";
          keyColor = "green";
        }
        {
          type = "gpu";
          key = "│ ├";
          detectionMethod = "pci";
          keyColor = "green";
        }
        {
          type = "display";
          key = "│ ├󱄄";
          keyColor = "green";
        }
        {
          type = "disk";
          key = "│ ├󰋊";
          keyColor = "green";
        }
        {
          type = "memory";
          key = "└ └";
          keyColor = "green";
        }
        {
          type = "custom";
          format = "└────────────────────────────────────────────────────┘";
          color = "90";
        }
        "break"
        {
          type = "custom";
          format = "┌──────────────────────Software──────────────────────┐";
          color = "90";
        }
        {
          type = "os";
          key = " OS";
          keyColor = "yellow";
        }
        {
          type = "kernel";
          key = "│ ├";
          keyColor = "yellow";
        }
        {
          type = "gpu";
          key = "│ ├󰍛 GPU Driver";
          format = "{3}";
          keyColor = "yellow";
        }
        {
          type = "packages";
          key = "│ ├󰏖";
          keyColor = "yellow";
        }
        {
          type = "shell";
          key = "│ ├";
          keyColor = "yellow";
        }
        {
          type = "editor";
          key = "└ └";
          keyColor = "yellow";
        }
        "break"
        {
          type = "wm";
          key = " WM";
          keyColor = "blue";
        }
        {
          type = "lm";
          key = "│ ├";
          keyColor = "blue";
        }
        {
          type = "theme";
          key = "│ ├󰉼";
          keyColor = "blue";
        }
        {
          type = "icons";
          key = "│ ├󰀻";
          keyColor = "blue";
        }
        {
          type = "cursor";
          key = "│ ├";
          keyColor = "blue";
        }
        {
          type = "terminalfont";
          key = "│ ├";
          keyColor = "blue";
        }
        {
          type = "terminal";
          key = "└ └";
          keyColor = "blue";
        }
        {
          type = "custom";
          format = "└────────────────────────────────────────────────────┘";
          color = "90";
        }
        "break"
        {
          type = "custom";
          format = "┌────────────────────Uptime / Age────────────────────┐";
          color = "90";
        }
        {
          type = "command";
          key = "  OS Age ";
          keyColor = "magenta";
          text = "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days";
        }
        {
          type = "uptime";
          key = "  Uptime ";
          keyColor = "magenta";
        }
        {
          type = "custom";
          format = "└────────────────────────────────────────────────────┘";
          color = "90";
        }
        "break"
      ];
    };
  };
  services.udiskie = {
    enable = true;
    settings = {
      program_options = {
        file_manager = "${pkgs.nautilus}/bin/nautilus";
      };
    };
  };
}
