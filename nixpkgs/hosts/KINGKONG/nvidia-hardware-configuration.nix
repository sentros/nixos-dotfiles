{...}: {
  # nvidia drivers
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. This fixes sleep/suspend bug that I'm running into when waking up the
    # machine. For some reason after wakeup without this wayland won't return. Only tty works.
    powerManagement.enable = true;

    # Not needed as not running on a laptop
    powerManagement.finegrained = false;

    # Open source version of drivers perferred with newer nvidia cards
    open = true;

    # Enable the Nvidia settings menu,
    nvidiaSettings = true;

    # Driver version
    # package = config.boot.kernelPackages.nvidiaPackages.production;
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/nvidia-x11/default.nix#L74
    # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #   version = "570.172.08";
    #   sha256_64bit = "sha256-AlaGfggsr5PXsl+nyOabMWBiqcbHLG4ij617I4xvoX0=";
    #   sha256_aarch64 = "sha256-FVRyFvK1FKznckpatMMydmmQSkHK+41NkEjTybYJY9g=";
    #   openSha256 = "sha256-aTV5J4zmEgRCOavo6wLwh5efOZUG+YtoeIT/tnrC1Hg=";
    #   settingsSha256 = "sha256-N/1Ra8Teq93U3T898ImAT2DceHjDHZL1DuriJeTYEa4=";
    #   persistencedSha256 = "sha256-x4K0Gp89LdL5YJhAI0AydMRxl6fyBylEnj+nokoBrK8=";
    # };
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];
}
