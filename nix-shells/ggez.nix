with import <nixpkgs> {};

let
  libs = [
    # Audio + input
    alsa-lib
    udev

    # X11 (required for winit X11 backend)
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    xorg.libXext

    # Wayland support
    wayland
    wayland-protocols
    libxkbcommon

    # GPU / Graphics
    vulkan-loader
    libglvnd
    mesa # includes libEGL + libGL
  ];
in

mkShell {
  buildInputs = [
    pkg-config
  ] ++ libs;

  LD_LIBRARY_PATH = lib.makeLibraryPath libs;

  PKG_CONFIG_PATH = lib.concatStringsSep ":" [
    "${alsa-lib.dev}/lib/pkgconfig"
    "${udev.dev}/lib/pkgconfig"
  ];

  shellHook = ''
    export WINIT_UNIX_BACKEND=x11
    export SHELL=${pkgs.fish}/bin/fish
    exec $SHELL
  '';
}
