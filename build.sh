#!/bin/bash
# Build script for the Anonymous-OS remake live ISO.
# Run this on a Linux machine (Ubuntu 22.04/24.04 recommended) with sudo.
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "Please run this with sudo: sudo ./build.sh"
  exit 1
fi

echo "==> Installing build dependencies (live-build, grub, plymouth, librsvg)..."
apt-get update
apt-get install -y live-build live-boot live-config grub-pc-bin grub-efi-amd64-bin \
  grub2-common syslinux-utils plymouth-themes librsvg2-bin xorriso mtools dosfstools

echo "==> Cleaning any previous build..."
lb clean --purge || true

echo "==> Configuring live-build (Ubuntu-based, hybrid BIOS+UEFI ISO)..."
lb config \
  --distribution jammy \
  --archive-areas "main restricted universe multiverse" \
  --binary-images iso-hybrid \
  --bootappend-live "boot=live components quiet splash" \
  --mirror-bootstrap http://archive.ubuntu.com/ubuntu/ \
  --mirror-binary http://archive.ubuntu.com/ubuntu/ \
  --mirror-chroot-security http://security.ubuntu.com/ubuntu/ \
  --mirror-binary-security http://security.ubuntu.com/ubuntu/ \
  --apt-indices false \
  --apt-recommends true \
  --iso-application "Anonymous-OS Live" \
  --iso-publisher "Custom Build" \
  --iso-volume "ANONYMOUS-OS"

echo "==> Building the ISO (this downloads real Ubuntu packages, ~1-2GB, and takes a while)..."
lb build

if [ -f live-image-amd64.hybrid.iso ]; then
  mv live-image-amd64.hybrid.iso anonymous-os-remake.iso
elif [ -f live-image-amd64.iso ]; then
  mv live-image-amd64.iso anonymous-os-remake.iso
fi

echo "==> Done. Output: $(pwd)/anonymous-os-remake.iso"
echo "    Boot it in VirtualBox / VMware / QEMU to test."
