# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  # pkgs-unstable,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Include nvidia specific settings.
    ./nvidia-hardware-configuration.nix
    # Hardware specific stuff
    ./hardware.nix
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
  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    grub = {
      enable = true;
      zfsSupport = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
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
  boot.kernelParams = ["nohibernate" "amd_pstate=active"];

  # https://nix.catppuccin.com/options/main/nixos/catppuccin/
  catppuccin = {
    flavor = "mocha";
    grub.enable = true;
    sddm.enable = true;
    tty.enable = true;
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
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
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "fi";
  };

  # Use hyprland for DE
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
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

  # Tell electron based apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
  environment.systemPackages = with pkgs; [
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
    diff-so-fancy
    wayland-utils
    # libsForQt5.qt5.qtgraphicaleffects
  ];

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

  # Add kwallet for credential storage. F.ex. vscode needs it to store github creds
  security = {
    pam.services.kwallet = {
      name = "kwallet";
      enableKwallet = true;
    };
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
