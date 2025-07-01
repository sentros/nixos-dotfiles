{ config, ... }:

{
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
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];
}
