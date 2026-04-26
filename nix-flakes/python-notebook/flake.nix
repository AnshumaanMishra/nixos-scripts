{
  description = "Python + CUDA + cuDNN development shell for notebooks (GPU-ready)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs }: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    python = pkgs.python311;
    cuda = pkgs.cudaPackages;
  in {
    devShells.${system}.default = pkgs.mkShell {
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
        echo "You can now create a venv and install cudf, numba, torch, etc."
      '';
    };
  };
}

