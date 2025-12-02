{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:
let
  python = pkgs.python311;
  cuda = pkgs.cudaPackages;
in
pkgs.mkShell {
  name = "python-notebook-gpu";

  buildInputs = [
    python
    python.pkgs.virtualenv
    python.pkgs.pip
    python.pkgs.setuptools
    python.pkgs.wheel

    pkgs.ncurses
    pkgs.zlib
    pkgs.libglvnd
    pkgs.xorg.libX11
    pkgs.xorg.libXi
    pkgs.xorg.libXext

    cuda.cudatoolkit
    cuda.cudnn
  ];

  shellHook = ''
    echo "🚀 Entering Python + CUDA shell..."
    export CUDA_HOME=${cuda.cudatoolkit}
    export PATH=$PATH:${cuda.cudatoolkit}/bin
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc
      cuda.cudatoolkit
      cuda.cudnn
      pkgs.zlib
      pkgs.libglvnd
      pkgs.xorg.libX11
      pkgs.xorg.libXext
      pkgs.xorg.libXi
    ]}:$LD_LIBRARY_PATH

    export NUMBA_CUDA_DRIVER=${cuda.cudatoolkit}/lib/libcuda.so

    echo "✅ CUDA_HOME set to: $CUDA_HOME"
    echo "✅ LD_LIBRARY_PATH configured"
    echo "You can now create a virtualenv and install cudf, numba, torch, etc."
  '';
}

