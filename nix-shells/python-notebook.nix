{ pkgs ? import <nixpkgs> {} }:
let
  python = pkgs.python311;
  libraryPath = pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc ];
in
  pkgs.mkShell {
    buildInputs = [
      python
      python.pkgs.virtualenv
    ];
    shellHook = ''
      export LD_LIBRARY_PATH="${libraryPath}:$LD_LIBRARY_PATH"
    '';
  }

