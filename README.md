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
