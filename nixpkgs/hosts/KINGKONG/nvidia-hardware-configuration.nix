{config, ...}: {
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
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "570.169";
      sha256_64bit = "sha256-XzKoR3lcxcP5gPeRiausBw2RSB1702AcAsKCndOHN2U=";
      sha256_aarch64 = "sha256-s8jqaZPcMYo18N2RDu8zwMThxPShxz/BL+cUsJnszts=";
      openSha256 = "sha256-oqY/O5fda+CVCXGVW2bX7LOa8jHJOQPO6mZ/EyleWCU=";
      settingsSha256 = "sha256-0E3UnpMukGMWcX8td6dqmpakaVbj4OhhKXgmqz77XZc=";
      persistencedSha256 = "sha256-dttFu+TmbFI+mt1MbbmJcUnc1KIJ20eHZDR7YzfWmgE=";
    };
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];
}
