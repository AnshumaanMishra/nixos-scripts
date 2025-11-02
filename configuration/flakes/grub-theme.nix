{ inputs, system, ... }:

{
  imports = [
    inputs.distro-grub-themes.nixosModules.${system}.default
  ];
}

