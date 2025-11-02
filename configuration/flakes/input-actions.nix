{ inputs, system, ... }:

{
  imports = [
    # Use the InputActions flake's NixOS module for the current system
    inputs.inputactions.nixosModules.${system}.default
  ];
}

