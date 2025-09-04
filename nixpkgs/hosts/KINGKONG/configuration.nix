{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Home manager stuff
    inputs.home-manager.nixosModules.default
    # Neovim configuration
    ./nvf.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
    rocmSupport = true;
  };
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = ["nct6775"];
    initrd.kernelModules = ["nvidia"];
  };

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
      ];
    };
    keyboard.qmk.enable = true;
    bluetooth.enable = true;
    enableAllFirmware = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      # package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  networking = {
    hostName = "KINGKONG"; # Define your hostname.
    networkmanager.enable = true; # Easiest to use and most distros use this by default.
    interfaces.eno1.wakeOnLan.enable = true;
  };

  time.timeZone = "Europe/Helsinki";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod.fcitx5.waylandFrontend = true;
  };
  console = {
    keyMap = "fi";
  };

  powerManagement.powertop = {
    enable = true;
    postStart = ''
      ${lib.getExe' config.systemd.package "udevadm"} trigger -c bind -s usb -a idVendor=1532 -a idProduct=00b7
      ${lib.getExe' config.systemd.package "udevadm"} trigger -c bind -s usb -a idVendor=320f -a idProduct=5044
    '';
  };

  services = {
    xserver.videoDrivers = ["nvidia"];
    displayManager = {
      sddm = {
        enable = true;
        package = pkgs.kdePackages.sddm;
        wayland.enable = true;
      };
      defaultSession = "hyprland-uwsm";
    };

    udev.extraRules =
      /*
      ini
      */
      ''
        # disable USB auto suspend for Razer DeathAdder V3 Pro
        ACTION=="bind", SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="00b7", TEST=="power/control", ATTR{power/control}="on"
        # disable USB auto suspend for Glorious GMMK Pro ISO
        ACTION=="bind", SUBSYSTEM=="usb", ATTR{idVendor}=="320f", ATTR{idProduct}=="5044", TEST=="power/control", ATTR{power/control}="on"
      '';

    printing.enable = true;
    smartd.enable = true;

    pulseaudio = {
      enable = true;
    };
    pipewire = {
      enable = false;
      pulse.enable = false;
    };

    openssh.enable = true;

    gnome.gnome-keyring.enable = true;
    udisks2.enable = true;
  };

  users.users.john = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    backupFileExtension = "hm-backup";
    users = {
      "john" = {
        imports = [
          ./home.nix
          inputs.catppuccin.homeModules.catppuccin
        ];
      };
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # https://nix.catppuccin.com/options/main/nixos/catppuccin/
  catppuccin = {
    flavor = "mocha";
    sddm.enable = true;
    tty.enable = true;
  };

  programs = {
    firefox.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };
    steam.enable = true;
    coolercontrol = {
      enable = true;
      nvidiaSupport = true;
    };
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 14d --keep 3";
      flake = "/etc/nixos";
    };

    _1password = {
      enable = true;
      # package = pkgs-unstable._1password-cli;
    };
    _1password-gui = {
      enable = true;
      # package = pkgs-unstable._1password-gui;
      # Certain features, including CLI integration and system authentication support,
      # require enabling PolKit integration on some desktop environments (e.g. Plasma).
      polkitPolicyOwners = ["john"];
    };
  };

  security = {
    pam.services.sddm.enableGnomeKeyring = true;
  };

  environment = {
    systemPackages = with pkgs; [
      wget
      ghostty
      kitty
      git
      vscode
      hyprshot
      nautilus
      kdePackages.kwallet
      dig
      killall
      peazip
      lm_sensors
      stress-ng
      blueberry
      bluetui
      usbutils
      diff-so-fancy
      wayland-utils
      nvtopPackages.full
      egl-wayland
      ffmpeg
      wl-clipboard
      neovim
    ];
    sessionVariables = {
      NVD_BACKEND = "direct";
      LIBVA_DRIVER_NAME = "nvidia";
    };
  };
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.hack
    font-awesome
    nerd-fonts.caskaydia-mono
  ];

  system.stateVersion = "25.05"; # Did you read the comment?
}
