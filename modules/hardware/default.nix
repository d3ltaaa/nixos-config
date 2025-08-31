{ ... }:
{
  imports = [
    ./amdGpu.nix
    ./audio.nix
    ./bluetooth.nix
    ./brightness.nix
    ./drawingTablet.nix
    ./nvidiaGpu.nix
    # ./partitioning.nix # TODO
    ./powerManagement.nix
    ./printing.nix
    ./usb.nix
  ];
}
