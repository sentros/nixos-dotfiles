{
  lib,
  config,
  ...
}: {
  # qmk for keyboard configuration
  hardware.keyboard.qmk.enable = true;

  # enable bluetooth
  hardware.bluetooth.enable = true;

  #enable trim
  services.fstrim.enable = lib.mkDefault true;
}
