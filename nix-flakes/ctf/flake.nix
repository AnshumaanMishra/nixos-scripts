{
  description = "CTF Toolkit Environment with Fish shell and auto WARP connect";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          fish
          wireshark
          binwalk
          exiftool
          xxd
          hexedit
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
          python3
          sqlmap
          cloudflare-warp
        ];

        shellHook = ''
          echo "CTF toolkit loaded. Connecting to Cloudflare WARP..."
          warp-cli connect
          exec fish -c "warp-cli status"
	  
        '';
      };
    };
}

