This repo reproduces an issue where Runelite, an AppImage, fails
to start in nixos 24.11, but works fine in 24.05.

You can build a vm for each of the before/after cases with these
commands:

```
nixos-rebuild build-vm --flake '.#mysystem2411'
nixos-rebuild build-vm --flake '.#mysystem2405'
```

And then run them with `rm -f nixos.qcow2 && ./result/bin/run-nixos-vm`.

Runelite will be on the deskop, and you can just double click
to run it and get to the login page of the game (in 24.05).
In 24.11, its loading screen will appear breifly, and then
close.

There is also a python script on the desktop to download/build
runelite from source to experiment with adding debug statements,
but I haven't looked into this deeply.

Sometimes the vm gets stuck on a black screen while booting up,
but retrying fixes it.

You can build the vm with a specific commit of nixpkgs using:
`nixos-rebuild build-vm --override-input nixpkgs2411 github:nixos/nixpkgs/<commit> --flake '.#mysystem2411'`

Using this, I bisected it and found the commit that causes the
breakage is https://github.com/NixOS/nixpkgs/commit/19178a0b4bcb9339a8740970231c0a69e3d480d3
