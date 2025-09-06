nix-build '<nixpkgs/nixos>' -A vm -I nixpkgs=channel:nixos-24.05 -I nixos-config=./configuration.nix

QEMU_KERNEL_PARAMS=console=ttys0 ./result/bin/run-nixos-vm -nographic; reset
