{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.username = "john";
  home.homeDirectory = "/home/john";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    bat
    eza
    telegram-desktop
    tree
    fastfetch
    btop
    htop
    nixfmt-rfc-style
  ];

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
        grace = 300;
        hide_cursor = false;
        no_fade_in = false;
      };

      background = [
        {
          path = "/home/john/wallpaper.jpg";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = "<span foreground=\"##cad3f5\">Password...</span>";
          shadow_passes = 2;
        }
      ];

    };
  };

  # Configure top bar in hyprland
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.mainBar = {
      height = 30;
      spacing = 4;

      modules-left = [
        "hyprland/workspaces"
      ];
      modules-center = [
        "hyprland/window"
      ];
      modules-right = [
        "systemd-failed-units"
        "cpu"
        "memory"
        "temperature"
        "clock"
      ];

      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        wrap-on-scroll = false;
        format = "{name}: {icon}";
        format-icons = {
          urgent = "";
          active = "";
          default = "";
        };
      };

      clock = {
        timezone = "Europe/Helsinki";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format-alt = "{:%Y-%m-%d}";
      };

      cpu = {
        format = "{usage}% ";
        tooltip = false;
      };

      memory = {
        format = "{}% ";
      };

      temperature = {
        hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
        critical-threshold = 95;
        format = "{temperatureC}°C ";
      };

      "systemd-failed-units" = {
        hide-on-ok = false;
        format = "✗ {nr_failed}";
        format-ok = "✓";
        system = true;
        user = true;
      };
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload = [ "/home/john/wallpaper.jpg" ];
      wallpaper = [ ",/home/john/wallpaper.jpg" ];
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
    };
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
      theme = "monokai-pro";
      font-size = 12;
      font-family = "Hack";
    };
    themes = {
      monokai-pro = {
        background = "2d2a2e";
        cursor-color = "c1c0c0";
        cursor-text = "c1c0c0";
        foreground = "fcfcfa";
        palette = [
          "0=#2d2a2e"
          "1=#ff6188"
          "2=#a9dc76"
          "3=#ffd866"
          "4=#fc9867"
          "5=#ab9df2"
          "6=#78dce8"
          "7=#fcfcfa"
          "8=#727072"
          "9=#ff6188"
          "10=#a9dc76"
          "11=#ffd866"
          "12=#fc9867"
          "13=#ab9df2"
          "14=#78dce8"
          "15=#fcfcfa"
        ];
        selection-background = "5b595c";
        selection-foreground = "fcfcfa";
      };
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
    };
    settingsPerApplication.Civ7_linux_Vulkan_FinalRelease = {
      fps_limit = 60;
    };
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
  };

  programs.firefox = {
    enable = true;
  };
}
