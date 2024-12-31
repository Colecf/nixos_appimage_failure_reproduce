{
  config,
  lib,
  pkgs,
  is2411,
  home-manager,
  ...
}:
let
  specificTo2411 = if is2411 then {
    hardware.graphics.enable = true;
  } else {};
  specificTo2405 = if !is2411 then {
    hardware.opengl.enable = true;
  } else {};

  runelite = pkgs.stdenv.mkDerivation {
      name = "runelite";

      src = pkgs.fetchurl {
          name = "runelite";
          url = "https://github.com/runelite/launcher/releases/download/2.7.2/RuneLite.AppImage";
          sha256 = "sha256-lAGCngrbEw1Yhsw/m5W1xj+gtNtJQxgentUlYUOFgec=";
      };

      phases = [ "installPhase" ];

      installPhase = ''
          install -D $src $out
      '';
  };
in
{
  imports = [home-manager.nixosModules.home-manager];

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

  users.mutableUsers = false;
  users.users.root.initialPassword = "password";
  users.users.myuser = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
    ];
  };
  services.displayManager.autoLogin.user = "myuser";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.myuser = {pkgs, ... }: {
    home.file."Desktop/Runelite".source = runelite;
    home.stateVersion = "24.05";
  };

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  system.stateVersion = "24.05";

} // specificTo2411 // specificTo2405
