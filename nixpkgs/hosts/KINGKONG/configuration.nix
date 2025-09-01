# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  # pkgs-unstable,
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Hardware specific stuff
    ./hardware.nix
    ./nvidia-hardware-configuration.nix
    # Main user creation
    ./main-user.nix
    # Home manager stuff
    inputs.home-manager.nixosModules.default
    # Neovim configuration
    ./nvf.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  main-user.enable = true;
  main-user.userName = "john";

  # Current ZFS support is up to 6.15 kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_15;
  boot.loader = {
    systemd-boot.enable = false;
    grub = {
      enable = true;
      zfsSupport = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      # useOSProber = true;
      mirroredBoots = [
        {
          devices = ["nodev"];
          path = "/boot";
        }
      ];
    };
  };
  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot.enable = true;
    trim.enable = true;
  };
  boot.kernelModules = ["nct6775"];
  boot.kernelParams = ["video=HDMI-A-2:1920x1080@@120"];

  # https://nix.catppuccin.com/options/main/nixos/catppuccin/
  catppuccin = {
    flavor = "mocha";
    grub.enable = true;
    sddm.enable = true;
    tty.enable = true;
  };

  users.users.john = {
    isNormalUser = true;
    extraGroups = ["wheel" "audio"]; # Enable ‘sudo’ for the user.
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

  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
    rocmSupport = true;
  };
  networking.hostName = "KINGKONG"; # Define your hostname.
  networking.hostId = "773c1290";
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  i18n = {
    inputMethod.fcitx5.waylandFrontend = true;
    defaultLocale = "en_US.UTF-8";
  };
  console = {
    keyMap = "fi";
  };

  # Use hyprland for DE
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  # Use sddm for graphical login
  services.displayManager = {
    sddm = {
      enable = true;
      # current default is qt5 but catppuccin requires qt6
      package = pkgs.kdePackages.sddm;
      wayland.enable = true;
    };
    defaultSession = "hyprland-uwsm";
  };
  services.gnome.gnome-keyring.enable = true;

  powerManagement.powertop = {
    enable = true;
    postStart = ''
      ${lib.getExe' config.systemd.package "udevadm"} trigger -c bind -s usb -a idVendor=1532 -a idProduct=00b7
      ${lib.getExe' config.systemd.package "udevadm"} trigger -c bind -s usb -a idVendor=320f -a idProduct=5044
    '';
  };
  services.udev.extraRules =
    /*
    ini
    */
    ''
      # disable USB auto suspend for Razer DeathAdder V3 Pro
      ACTION=="bind", SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="00b7", TEST=="power/control", ATTR{power/control}="on"
      # disable USB auto suspend for Glorious GMMK Pro ISO
      ACTION=="bind", SUBSYSTEM=="usb", ATTR{idVendor}=="320f", ATTR{idProduct}=="5044", TEST=="power/control", ATTR{power/control}="on"
    '';

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };

  services.smartd = {
    enable = true;
  };

  services.scrutiny.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [pkgs.brlaser];
  services.printing.stateless = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound.
  services.pulseaudio = {
    enable = true;
    support32Bit = true;
  };
  services.pipewire = {
    enable = false;
    pulse.enable = false;
    alsa.enable = false;
    alsa.support32Bit = false;
  };

  programs._1password = {
    enable = true;
    # package = pkgs-unstable._1password-cli;
  };
  programs._1password-gui = {
    enable = true;
    # package = pkgs-unstable._1password-gui;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = ["john"];
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
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
      acpica-tools
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

  programs.steam = {
    enable = true;
  };

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  programs.coolercontrol = {
    enable = true;
    nvidiaSupport = true;
  };
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/etc/nixos";
  };

  security = {
    pam.services.sddm.enableGnomeKeyring = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      AllowUsers = ["john"];
    };
  };

  networking.interfaces.eno1.wakeOnLan.enable = true;

  # Manage removable media like USB storage
  services.udisks2.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
