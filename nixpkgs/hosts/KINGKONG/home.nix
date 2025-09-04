{
  config,
  pkgs,
  lib,
  osConfig,
  inputs,
  ...
}: let
  customOhMyZshTheme =
    /*
    bash
    */
    ''
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
in {
  home.username = "john";
  home.homeDirectory = "/home/john";
  home.stateVersion = "25.05";

  # write oh-my-zsh theme file
  home.file.".oh-my-zsh/custom/themes/sentros.zsh-theme".text = customOhMyZshTheme;

  # zsh-peco-history plugin
  home.file.".oh-my-zsh/custom/plugins/zsh-peco-history".source = builtins.fetchGit {
    url = "https://github.com/jimeh/zsh-peco-history";
    rev = "73615968d46cf172931946b00f89a59da0c124a5";
  };

  # zsh fast-syntax-highlighting plugin
  home.file.".oh-my-zsh/custom/plugins/fast-syntax-highlighting".source = builtins.fetchGit {
    url = "https://github.com/zdharma-continuum/fast-syntax-highlighting.git";
    rev = "3d574ccf48804b10dca52625df13da5edae7f553";
  };

  home.packages = with pkgs; [
    bat
    eza
    telegram-desktop
    tree
    nixfmt-rfc-style
    libreoffice
    thunderbird
    pavucontrol
    pamixer
    walker
    gtk4-layer-shell
    gnome-themes-extra
    adwaita-icon-theme
    libqalculate
    peco
    tealdeer
    discord
    protonup-qt
    prettier
  ];

  # home.file.".config/walker" = {
  #   source = ./walker;
  #   recursive = true;
  # };
  home.activation.copyWalkerConfig =
    lib.hm.dag.entryAfter ["writeBoundary"]
    /*
    bash
    */
    ''
      mkdir -p ~/.config/walker
      cp -rn ${./walker}/* ~/.config/walker/
      chmod -R u+rw ~/.config/walker
    '';

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
    };
    iconTheme = {
      name = "Adwaita";
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  # https://nix.catppuccin.com/options/main/home/catppuccin/
  catppuccin = {
    # This would enable all possible catppuccin themes
    # enable = true;
    flavor = "mocha";
    bat.enable = true;
    btop.enable = true;
    chromium.enable = true;
    cursors.enable = true;
    firefox.enable = true;
    fzf.enable = true;
    ghostty.enable = true;
    thunderbird.enable = true;
    vscode.profiles.Default.enable = true;
    zsh-syntax-highlighting.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hypr/hyprland.conf;
    plugins = [
      inputs.hyprland-plugins.packages."${pkgs.system}".hyprfocus
    ];
  };

  # Allow unlocking 1password etc with system authentication
  services.hyprpolkitagent.enable = true;

  # Volume, capslock etc osd
  services.swayosd.enable = true;

  # write oh-my-zsh theme file
  # home.file.".config/swayosd/style.css".text = builtins.readFile ./swayosd/style.css;
  home.file.".config/swayosd".source = ./swayosd;

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
    style =
      /*
      css
      */
      ''
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
    # settings = builtins.readFile ./waybar/config.jsonc;
    style = builtins.readFile ./waybar/style.css;
    package = inputs.waybar.packages.x86_64-linux.waybar;
  };

  # write waybar config
  home.file.".config/waybar/config.jsonc".source = ./waybar/config.jsonc;
  # write power-menu
  home.file.".config/waybar/power-menu.sh" = {
    source = ./waybar/power-menu.sh;
    executable = true;
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload = ["/etc/nixos/nix.png"];
      wallpaper = [",/etc/nixos/nix.png"];
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
    localVariables = {
      ZSH_CUSTOM = "${config.home.homeDirectory}/.oh-my-zsh/custom";
    };
    shellAliases = {
      nrs = "nh os switch -a -u /etc/nixos";
      #nrs = "sudo nixos-rebuild switch --flake /etc/nixos/hosts/#KINGKONG";
      gc = "sudo nix-collect-garbage";
      ls = "eza";
      cat = "bat";
      icat = "kitten icat";
    };
    history = {
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
        "zsh-peco-history"
        "fast-syntax-highlighting"
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
    terminal = "screen-256color";
    extraConfig =
      /*
      tmux
      */
      ''
        # Enable clipboard
        set -g set-clipboard on
        set-option -g status-position top
      '';
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig =
          /*
          tmux
          */
          ''
            set -g @catppuccin_flavor "mocha"
            set -g @catppuccin_window_status_style "rounded"
            set -g status-right-length 100
            set -g status-left-length 100
            set -g status-left ""
            set -g status-right "#{E:@catppuccin_status_application}"
            set -agF status-right "#{E:@catppuccin_status_cpu}"
            set -ag status-right "#{E:@catppuccin_status_session}"
            set -ag status-right "#{E:@catppuccin_status_uptime}"
          '';
      }
      tmuxPlugins.cpu
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
      # Based on catppucchin mangohud
      legacy_layout = false;
      round_corners = 10;
      background_alpha = 0.8;
      background_color = "1E1E2E";
      table_columns = 3;

      ## Text ##
      font_size = 24;
      text_color = "CDD6F4";
      text_outline_color = 313244;

      ## GPU #
      gpu_text = "GPU";
      gpu_stats = true;
      gpu_temp = true;
      gpu_color = "A6E3A1";
      gpu_load_change = "";
      gpu_load_color = "CDD6F4,FAB387,F38BA8";
      # Show only discrete GPU
      pci_dev = "0000:01:00.0";
      vram = true;

      ## CPU ##
      cpu_text = "CPU";
      cpu_stats = true;
      cpu_temp = true;
      cpu_color = "89B4FA";
      cpu_load_change = true;
      cpu_load_color = "CDD6F4,FAB387,F38BA8";

      ## RAM ##
      ram = true;
      ram_color = "F5C2E7";

      ## ENGINE ##
      engine_color = "F38BA8";

      ## FPS ##
      fps = true;
      fps_color_change = "F38BA8,F9E2AF,A6E3A1";
      fps_limit = 120;
      fps_limit_method = "early";

      ## Wine ##
      wine = true;
      wine_color = "F38BA8";

      ## Frame timing ##
      frame_timing = false;
      frametime_color = "A6E3A1";

      arch = true;
    };
    settingsPerApplication = {
      "CivilizationVI_DX12.exe" = {
        fps_limit = 120;
      };
      #   Civ7_linux_Vulkan_FinalRelease = {
      #     fps_limit = 60;
      #   };
      #   Civ7_Win64_DX12 = {
      #     fps_limit = 60;
      #   };
    };
  };

  programs.git = {
    enable = true;
    userName = "Julius Stenros";
    userEmail = "julius.stenros@gmail.com";
    extraConfig = {
      gpg = {
        format = "ssh";
      };
      "gpg \"ssh\"" = {
        program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      };
      commit = {
        gpgsign = true;
      };
      user = {
        signingKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDoktPpTKsEIYLmIe57fy3BtIRUnqiybSL3Z5pynmOVMR4YpcIdrPGJXX9URAct/Rbz0/3/8YDOjxXP0cWVKVFpijoFj6VxsBSNNugIbGvam14uXJtGK5jByEXKRZvDnsTmg2hwBLOmZpY3vmtWz1IOD3yd1CeskJFYD9dr9LOO3sVty50xXqzy8S76Oe08KlRnNTfHfW9GnhpTuBTGZ+pvDNFA+mxi0+r9BgMbSgMo9BJ5Laq+kbFW37QH4uQ0fKJK+u90jKw4c880Gf4ZLDeTCQeyd46N5h3MzDLt08WgHBTY2e45vPNM0lzJqUc5dSkYreDAVSTwnjxSizasppZ8TKlidwsbFtqogUuC+UumczZcrglW8p7OqdbwFm88UOJ/K6LwqJ/1UefwEhpHz/vyLeRpc3K0drMU1FbbVvwZiWin2Qfs6KCcEx4DhHFYpU1QBC6S24B0ATXP7LTykuvz1eYOYEWl0rwvL7skooY8+AukEHQabFShuRL2Tan+5/M960dSJl3TzlXR9Fbhik4Ugq0iNPsL3mI8FbaOqggYcHRlg94ylKj4e2EgrfW9yNhh5OmrK5frF7qYoE53tVuaoeH/yIgM4WJ5mdoKZHOd43Z1ZiPC+HtiRGJyKtsHuUBhO8MXnj7AVcjZZQEc/utdyEybskcel11zgxA08iAIhQ==";
      };
    };
    diff-so-fancy.enable = true;
  };

  programs.firefox = {
    enable = true;
  };

  programs.chromium.enable = true;
  xdg.desktopEntries = {
    chatgpt = {
      name = "ChatGPT";
      comment = "ChatGPT";
      exec = "chromium --new-window --ozone-platform=wayland --app=https://chatgpt.com/ --name=ChatGPT --class=ChatGPT";
      terminal = false;
      type = "Application";
      icon = builtins.fetchurl {
        url = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/chatgpt.png";
        sha256 = "1bgm6b0gljl9kss4f246chblw40a4h4j93bl70a6i0bi05zim22f";
      };
      startupNotify = true;
    };
    whatsapp = {
      name = "WhatsApp";
      comment = "WhatsApp";
      exec = "chromium --new-window --ozone-platform=wayland --app=https://web.whatsapp.com/ --name=WhatsApp --class=WhatsApp";
      terminal = false;
      type = "Application";
      icon = builtins.fetchurl {
        url = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/whatsapp.png";
        sha256 = "1z70kvad27gizhbdr6j4115cks5n0015qvn79hpf56z8nnaf0xm2";
      };
      startupNotify = true;
    };
  };

  programs.lutris = {
    enable = true;
    steamPackage = osConfig.programs.steam.package;
    protonPackages = [pkgs.proton-ge-bin];
  };

  programs.btop = {
    enable = true;
    settings = {
      shown_boxes = "cpu gpu0 mem net proc";
      cpu_sensor = "nct6799/TSI0_TEMP";
      cpu_core_map = "";
      temp_scale = "celsius";
      net_download = 600;
      net_upload = 400;
      custom_gpu_name1 = "AMD Integrated";
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
