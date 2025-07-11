# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    # This is not included in git
    ./hardware-configuration.nix
    # Include nvidia specific settings.
    ./nvidia-hardware-configuration.nix
    # Hardware specific stuff
    ./hardware.nix
    # Main user creation
    ./main-user.nix
    inputs.home-manager.nixosModules.default
    ./amd-cpu.nix
    ./nvf.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  main-user.enable = true;
  main-user.userName = "john";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.john = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    backupFileExtension = "hm-backup";
    users = {
      "john" = import ./home.nix;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "KINGKONG"; # Define your hostname.

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
    sddm.enable = true;
    sddm.wayland.enable = true;
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
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
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
    helvum
    diff-so-fancy
    wayland-utils
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
