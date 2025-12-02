with import <nixpkgs> {};

let
  libs = [
    # Audio + input
    alsa-lib
    udev

    # X11 backend (winit, ggez)
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    xorg.libXext

    # Wayland
    wayland
    wayland-protocols
    libxkbcommon

    # GPU / GL / Vulkan
    vulkan-loader
    libglvnd
    mesa
  ];

in mkShell {
  # Tools needed to build Rust + C deps
  nativeBuildInputs = [
    pkg-config

    # Use clang + lld for ALL linking
    llvmPackages.clang
    llvmPackages.lld
    llvmPackages.libclang
    rustc
    cargo
  ];

  buildInputs = libs;

  # Fix: make all libraries discoverable for runtime
  LD_LIBRARY_PATH = lib.makeLibraryPath libs;

  # Fix: FORCE clang + lld for all C and Rust build scripts
  CC = "${llvmPackages.clang}/bin/clang";
  CXX = "${llvmPackages.clang}/bin/clang++";
  CFLAGS = "-fuse-ld=lld";

  # Fix: Rust must use clang + lld or else linking fails
  RUSTFLAGS = "-C linker=${llvmPackages.clang}/bin/clang -C link-args=-fuse-ld=lld";

  # Optional but nice
  shellHook = ''
    export WINIT_UNIX_BACKEND=x11
    export SHELL=${pkgs.fish}/bin/fish
    exec $SHELL
  '';
}

