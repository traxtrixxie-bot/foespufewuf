# Anonymous-OS Remake (Build Project)

A from-scratch, Ubuntu-based live `.iso` inspired by the look and feel of the
2012 "Anonymous-OS" release: dark theme, Guy Fawkes-style boot screen, the
"...ARE LEGION / DO NOT FORGIVE / DO NOT FORGET / EXPECT US" desktop, and a
bundle of legitimate privacy / networking tools.

**What's intentionally left out:** the original release bundled DDoS tools
(HOIC, Slowloris, TorsHammer...), SQL-injection tools (Sqlmap, Havij...), and
password-cracking tools (John the Ripper...). This remake does not include or
recreate any of that software or its GUIs — only legitimate, generally
available tools are installed (see `config/package-lists/custom.list.chroot`).

## What's included

- Ubuntu-based live system (boots live, like the original; no installer
  included by default — see "Going further" to add one)
- Dark MATE desktop with a wallpaper in the spirit of the original artwork
  (original SVG, not a copy of anyone else's image)
- A plain-text GRUB boot menu matching the original's wording
  (`live`, `xforcevesa`, `memtest`, `hd`)
- Legitimate tools: Tor + Tor Browser launcher, Pidgin, XChat/Hexchat IRC,
  Wireshark, Nmap/Zenmap, i2p, a local password generator, KeePassXC
- Works in VirtualBox, VMware, and QEMU/KVM, BIOS and UEFI boot

## Requirements to build

Run this **on a Linux machine** (a fresh Ubuntu 22.04/24.04 VM is easiest —
you can build it inside a VM and then boot the resulting ISO in another VM).
You need:

- `sudo` access
- An internet connection (packages are downloaded from Ubuntu's mirrors
  during the build)
- ~10 GB free disk space
- 30–90 minutes depending on your connection

This can't be built inside this chat session: producing the ISO means
downloading gigabytes of real Ubuntu packages from Ubuntu's mirrors, which
isn't possible from here. The `build.sh` script below does that step for you
once you run it on your own machine.

## How to build

```bash
cd anonymous-os-remake
chmod +x build.sh
sudo ./build.sh
```

When it finishes you'll have `anonymous-os-remake.iso` in this directory.

## How to test in a VM

**VirtualBox**
1. New VM → Type: Linux, Version: Ubuntu (64-bit)
2. 2+ GB RAM, no fixed disk needed to just test-boot live
3. Settings → Storage → attach `anonymous-os-remake.iso` as the optical drive
4. Settings → System → Enable EFI if you want to test UEFI boot (optional —
   it boots BIOS mode by default too)
5. Start the VM

**QEMU**
```bash
qemu-system-x86_64 -m 2048 -cdrom anonymous-os-remake.iso -boot d
```

**VMware**
- New VM → "Installer disc image file (iso)" → point it at the ISO →
  finish and power on.

## Project layout

```
anonymous-os-remake/
├── build.sh                          # Runs the whole build
├── config/
│   ├── package-lists/
│   │   └── custom.list.chroot        # Packages installed into the image
│   ├── includes.chroot/              # Files copied into the live filesystem
│   │   ├── usr/share/backgrounds/    # Desktop wallpaper (original SVG/PNG)
│   │   ├── etc/skel/Desktop/         # Desktop icons/shortcuts for the user
│   │   └── usr/share/plymouth/...    # Boot splash theme
│   └── hooks/live/                   # Scripts run during the build
│       ├── 0100-theme.hook.chroot    # Applies dark theme + wallpaper
│       └── 0200-grub-menu.hook.chroot# Customizes the GRUB boot menu text
└── README.md
```

## Customizing

- Swap `config/includes.chroot/usr/share/backgrounds/anonymous-wallpaper.svg`
  for your own art if you'd like.
- Add/remove packages in `config/package-lists/custom.list.chroot`.
- Edit `config/hooks/live/0200-grub-menu.hook.chroot` to change the boot menu
  wording.

## Going further (optional, not included)

- A Calamares or Ubiquity installer, if you want "install to disk" and not
  just live boot
- Persistence support for a USB build (`live-boot` supports this with a
  `persistence` partition)
