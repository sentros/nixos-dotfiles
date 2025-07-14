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
    extraConfig = builtins.readFile ./hyprland.conf;
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

  # Configure lock screen and behaviour in h;;yprland
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
      mode = "dock";
      gtk-layer-shell = true;

      modules-left = [
        "custom/left"
        "hyprland/workspaces"
        "custom/right"
        "custom/paddw"
        "hyprland/window"
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
        "custom/power-menu"
      ];
      "custom/left" = {
        format = "";
        tooltip = false;
      };
      "hyprland/workspaces" = {
        on-click = "activate";
        on-scroll-up = "hyprctl dispatch workspace -1";
        on-scroll-down = "hyprctl dispatch workspace +1";
        persistent-workspaces = {
          "1" = "[]";
          "2" = "[]";
          "3" = "[]";
          "4" = "[]";
          "5" = "[]";
        };
      };
      "custom/right" = {
        format = "";
        tooltip = false;
      };
      "custom/paddw" = {
        format = " ";
        tooltip = false;
      };

      "hyprland/window" = {
        swap-icon-label = false;
        format = "{}";
        tooltip = false;
        min-length = 5;
        rewrite = {
          "" = "<span foreground='#89b4fa'> </span> Hyprland";
          "~" = "  Terminal";
          zsh = "  Terminal";
          "tmux(.*)" = "<span foreground='#a6e3a1'> </span> Tmux";
          "(.*)Mozilla Firefox" = "<span foreground='#f38ba8'>󰈹 </span> Firefox";
          "(.*) — Mozilla Firefox" = "<span foreground='#f38ba8'>󰈹 </span> $1";
          nvim = "<span foreground='#a6e3a1'> </span> Neovim";
          "nvim (.*)" = "<span foreground='#a6e3a1'> </span> $1";
        };
      };

      clock = {
        timezone = "Europe/Helsinki";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format = "{:%H:%M}";
        format-alt = "{:%Y-%m-%d}";
        min-length = 6;
        max-lenght = 6;
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
        format = "󰍛 {usage}%";
        tooltip = false;
        interval = 5;
        min-length = 6;
        max-length = 6;
        on-click = "ghostty -e btop";
      };

      memory = {
        states = {
          warning = 75;
          critical = 90;
        };
        format = "󰘚 {percentage}%";
        format-critical = "󰀦 {percentage}%";
        tooltip = false;
        interval = 5;
        min-length = 7;
        max-length = 7;
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
        format = "󰋋 {volume}%";
        format-muted = "󰝟 {volume}%";
        scroll-step = 5;
        on-click = "helvum";
        tooltip-format = "Playing at {volume}%";
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
    };
    style = ''
      * {
          min-height: 0;
          border: none;
          margin: 0;
          padding: 0;
      }
      window#waybar {
        background: shade(#11111b, 0.5);
      }
      window#waybar > box {
        background: #11111b;
        margin: 2px;
      }
      tooltip {
        background: #11111b;
        border: 1.5px solid #cdd6f4;
        border-radius: 8px;
      }

      tooltip label {
        color: #cdd6f4;
        margin: -1.5px 3px;
      }

      #workspaces
      #window
      #clock
      #systemd-failed-units,
      #bluetooth,
      #network,
      #wireplumber,
      #cpu,
      #memory,
      #temperature,
      #custom-power-menu {
        opacity: 1;
        color: #cdd6f4;
        padding: 0 10px;
      }
      #custom-left {
        margin-bottom: 0;
        text-shadow: -2px 0 2px rgba(0, 0, 0, 0.5);
        color: #181825;
        background: #11111b;
        padding-left: 2px;
      }
      #workspaces {
        background: #181825;
      }
      workspaces button {
        color: #cdd6f4;
        border-radius: 8px;
        box-shadow: none;
        margin: 2px 0;
        padding: 0 2px;
        transition: none;
      }
      #workspaces button:hover {
        color: alpha(#cdd6f4, 0.75);
        background: #313244;
        text-shadow: none;
      }
      #workspaces button.active {
        color: #11111b;
        background: #9399b2;
        text-shadow: 0 0 2px rgba(0, 0, 0, 0.6);
        box-shadow: 0 0 2px 1px rgba(0, 0, 0, 0.4);
        margin: 2px;
        padding: 0 6px;
      }
      #custom-right {
        color: #181825;
        background: #11111b;
        margin-bottom: 0;
        padding-right: 3px;
        text-shadow: 2px 0 2px rgba(0, 0, 0, 0.5);
      }
      #clock {
        background: #313244;
        margin-left: -2px;
        padding: 0 3px 0 0;
      }
      #bluetooth {
        background: #181825;
        padding-right: 5px;
      }

      #bluetooth:hover {
        color: alpha(#cdd6f4, 0.75);
      }
      #network {
        background: #181825;
        padding: 0 8px 0 5px;
      }

      #network:hover {
        color: alpha(#cdd6f4, 0.75);
      }
      #wireplumber {
        background: #181825;
      }

      #wireplumber:hover {
        color: alpha(#cdd6f4, 0.75);
      }
      #cpu {
        background: #313244;
      }
      #memory {
        background: #1e1e2e;
        padding: 0 0 0 1px;
      }

      #memory.warning {
        color: #f9e2af;
      }

      #memory.critical {
        color: #f38ba8;
      }
      #temperature {
        background: #181825;
        padding: 0 0 0 10px;
      }
      #custom-power-menu {
        color: #11111b;
        background: #9399b2;
        text-shadow: 0 0 2px rgba(0, 0, 0, 0.6);
        box-shadow: 0 0 2px 1px rgba(0, 0, 0, 0.6);
        border-radius: 10px;
        margin: 2px 4px 2px 0;
        padding: 0 6px 0 9px;
      }

      #custom-power-menu:hover {
        color: alpha(#cdd6f4, 0.75);
        background: #313244;
        text-shadow: none;
        box-shadow: none;
      }
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 16px;
        font-weight: bold;
      }

      tooltip label,
      #window label {
        font-weight: normal;
      }
    '';
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
      nrs = "nh os switch -a -u /etc/nixos";
      #nrs = "sudo nixos-rebuild switch --flake /etc/nixos/hosts/#KINGKONG";
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
      # Show only discrete GPU
      pci_dev = "0000:01:00.0";
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
    automount = false;
    settings = {
      program_options = {
        file_manager = "${pkgs.nautilus}/bin/nautilus";
      };
    };
  };
}
