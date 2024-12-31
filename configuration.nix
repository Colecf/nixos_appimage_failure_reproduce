{
  config,
  pkgs,
  is2411,
  ...
}:
let
  specificTo2411 = if is2411 then {
    hardware.graphics.enable = true;
  } else {};
  specificTo2405 = if !is2411 then {
    hardware.opengl.enable = true;
  } else {};
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.loader.systemd-boot.enable = true;
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  networking.networkmanager.enable = true;
  
  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };
  services.libinput.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

} // specificTo2411 // specificTo2405
