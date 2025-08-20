{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  packages = with pkgs; [
    fish
    wireshark
    binwalk
    exiftool
    xxd
    hexedit
    cfr
    jadx
    file
    burpsuite
    radare2
    nmap
    john
    hashcat
    foremost
    steghide
    zsteg
    binutils
    gdb
    ghidra
    binaryninja-free
    sqlmap
    sleuthkit
  ];

  shellHook = ''
    echo "CTF toolkit loaded. Happy hacking!"
    exec fish
  '';
}

